sub getFeedbackStatusMID
{
    my $status_code= $_[0];
    my $status_string;
    
    if( $status_code == 0 )
    {
        $status_string = "New message";
    }
    elsif( $status_code == 1 )
    {
        $status_string = "Message closed";
    }
    elsif( $status_code == 2 )
    {
        $status_string = "Feedback email sent";
    }
    elsif( $status_code == 3 )
    {
        $status_string = "Feedback received from seller";
    }
    elsif( $status_code == 4 )
    {
        $status_string = "Feedback received from buyer";
    }
    elsif( $status_code == 5 )
    {
        $status_string = "Feedback complete";
    }
    else
    {
        $status_string = "Unknown status";
    }

    return $status_string;
}
1;
