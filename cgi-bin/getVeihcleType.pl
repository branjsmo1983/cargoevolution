#  <option value="0" selected>Qualunque</option>
#  <option value="1">Telonato</option>
#  <option value="2">Aperto</option>
#  <option value="3">Frigo</option>
#  <option value="4">Autotreno</option>
#  <option value="5">Sponda idraulica</option>
#  <option value="6">Motrice tax</option>
#  <option value="7">Centinato o Aperto</option>

sub getVeihcleType{

    my $vt = $_[0];
    my $vname;

    if    ($vt == 0 )
    {
        $vname = "Qualunque";
    }
    elsif ($vt == 1 )
    {
        $vname = "Bilico Centinato";
    }
    elsif ($vt == 2 )
    {
        $vname = "Aperto";
    }
    elsif ($vt == 3 )
    {
        $vname = "Frigo";
    }
    elsif ($vt == 4 )
    {
        $vname = "Autotreno";
    }
    elsif ($vt == 5 )
    {
        $vname = "Sponda idraulica";
    }
    elsif ($vt == 6 )
    {
        $vname = "Motrice";
    }
    elsif ($vt == 7 )
    {
        $vname = "Centinato o Aperto";
    }
    else
    {
        $vname = "N.A.";
    }

    return $vname;
}
1;
