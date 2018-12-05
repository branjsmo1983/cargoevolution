<?php
require("vendor/autoload.php");
use Sendinblue\Mailin;

$to_whom = $argv[1];
$subject = $argv[2];
$body = $argv[3];

if($to_whom === NULL or $subject === NULL or $body === NULL )
{
  print("Error: null parameters");
}
else {

 #$subject = utf8_decode( $subject );
 #$body = utf8_decode( $body );




  $mailin = new Mailin("https://api.sendinblue.com/v2.0","qCkcxQ43HyNAGD8L");
  $data = array( "to" => array($to_whom=>"Utente"),
      "from" => array("info@cargoevolution.com", "cargoevolution.com"),
      "subject" => $subject,
      "text" => $body
  );

  var_dump($mailin->send_email($data));
}
# $tstrF = utf8_decode($tstr);
# print(  utf8_decode( $subject ) . "\n");
# print( utf8_decode( $body ) . "\n");
#print ($cur_encoding . "\n");

?>
