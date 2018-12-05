sub compare2date
{
    my $timestamp1 = $_[0];
    my $timestamp2 = $_[1];

    my @ts1 = split / / , $timestamp1;
    my @ts2 = split / / , $timestamp2;
    my $tt1 = $ts1[0];
    my $tt2 = $ts2[0];
    my @arrayDate1 = split /-/ , $tt1;
    my @arrayDate2 = split /-/ , $tt2;
    print " le due date sono $tt1 e $tt2 \n";
    my $yearInDays1 = $arrayDate1[0] * 365;
    print " anno in giorni prima data = $yearInDays1\n";
    my $yearInDays2 = $arrayDate2[0] * 365;
     print " anno in giorni seconda data = $yearInDays2\n";
    my $mountInDays1 = $arrayDate1[1] * 31;
     print " mesi in giorni prima data = $arrayDate1[1] * 31\n";
    my $mountInDays2 = $arrayDate2[1] * 31;
     print " mesi in giorni seconda data = $arrayDate2[1] * 31\n";
    my $totalDays1 = $arrayDate1[2] + $mountInDays1 + $yearInDays1;
     print " giorni totali  prima data = $totalDays1\n";
    my $totalDays2 = $arrayDate2[2] + $mountInDays2 + $yearInDays2;
     print " giorni totali  seconda data = $totalDays2\n";
    return ($totalDays1 - $totalDays2);
}
1;
    
