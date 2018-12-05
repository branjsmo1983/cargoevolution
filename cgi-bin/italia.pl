sub italia{

my $from_login=$_[1];
my $username = $_[0];

my $script;

if( $from_login )
{
   $script = "/cgi-bin/login_succ_view.pl?username=$username";
}
else
{
   $script = "";
}

print <<EOF;
<map name="regioni" id="regions" >
    <area shape="rect" coords="14, 24, 35, 37" href="$script#&id=19" target="_self" value="Valle d'Aosta">
    <area shape="circle" coords="45, 156, 29" href="$script#&id=14" target="_self" id="Sardegna" > 
    <area shape="poly" coords="105, 199, 115, 197, 121, 200, 131, 201, 139, 198, 150, 197, 156, 195, 151, 201, 145, 209, 148, 212, 150, 219, 152, 225, 147, 227, 144, 231, 128, 221, 119, 219, 113, 212, 108, 212, 102, 210, 98, 205" href="$script#&id=15" target="_self" id="Sicilia">
</map>

EOF

}
1;

