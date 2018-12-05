<?php
require 'vendor/autoload.php';
use Mailgun\Mailgun;
include('./vendor/rmccue/requests/library/Requests.php');
Requests::register_autoloader();

# Instantiate the client.
$mgClient = new Mailgun('key-723120d2be335f7ef5fd93c294b053c8');
$domain = 'mg.cargoevolution.com';
$date = getdate(date("U"));
$wday = $date[weekday];
$month = $date[month];
$day = $date[mday];
# Get the first three letters of the wday and month
$wday = substr ( $wday , 0, 3 );
$month = substr ( $month , 0, 3 );
echo "$wday, $day, $month";

$queryString = array(
    'begin'        => "$wday, $day $month 2018 00:00:00 -0000",
    'ascending'    => 'yes',
    'limit'        =>  25,
    'pretty'       => 'yes',
    'event'        => 'failed',
    'severity'     => 'permanent'
);

# Make the call to the client.
$result = $mgClient->get("$domain/events", $queryString);
$json_string = json_encode($result, JSON_PRETTY_PRINT);

// Connecting, selecting database
$dbconn = pg_connect("host=localhost dbname=cargoevo_test user=cargoevo_postgres password=Afirmkick_02")
    or die('Could not connect: ' . pg_last_error());


foreach ($result->http_response_body->items  as $name => $value) {
    #echo $name . ':';
    $item = $result->http_response_body->items[$name];
    $url = $item->storage->url;
    $key = $item->storage->key;

    $options = array(
    	'auth' => array('api', 'key-723120d2be335f7ef5fd93c294b053c8')
    );
    $headers = array('Accept' => 'application/json');
    $cur_msg = Requests::get($url, $headers, $options);
    #echo $cur_msg;
    #$json_string = json_encode($cur_msg, JSON_PRETTY_PRINT);
    $body = $cur_msg->body;
    $string = var_dump( $body  );
    $json = json_decode($body, true);
    $mailID = $json['Message-Id'];
    $received = $json['Received'];
    $dstEmail =  $json['recipients'];
    $subject =  $json['subject'];
    $body =  $json['stripped-html'];

    // check if message id is already in database
    $query =  "SELECT * from unsent_mail where id = '$mailID';";
    $db_result = pg_query($query) or die('Query failed: ' . pg_last_error());

    $messageInDb = "False";
    while ($line = pg_fetch_array($db_result, null, PGSQL_ASSOC))
    {
      $messageInDb = "True";
    }

    pg_free_result($db_result);

    // Performing SQL query if the message is not in the DB
    if( $messageInDb === "False" and (!preg_match("/zanaga/i", $dstEmail)) and (!preg_match("/baudino/i", $dstEmail)) )
    {
      $subject_esc = pg_escape_string($subject);
      $body_esc = pg_escape_string($body);
      $received_esc = pg_escape_string($received);

      print( "\n" . $body . "\n" );

      $query = "INSERT INTO unsent_mail (id, mail_to, subject, body, received) VALUES ('$mailID', '$dstEmail', '{$subject_esc}', '{$body_esc}', '{$received}');";
      $db_result = pg_query($query) or die('Query failed: ' . pg_last_error());
      // Free resultset
      pg_free_result($db_result);
    }
    else {
      print("Skipping Message\n@@@@@@@@@@@@@@@@@\n");
    }

}


// Closing connection
pg_close($dbconn);

?>
