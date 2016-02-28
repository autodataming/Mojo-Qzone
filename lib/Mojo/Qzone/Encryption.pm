package Mojo::Qzone::Encryption;

sub getACSRFToken
{
	my $self=shift;
	my $p_skey=shift;
	print "$p_skey\n";
	my $t=$p_skey;
    my $n = 0;
    my $o=length($t);
    my $r;
    print "try to obtain  ACSRFtoken\n";
    if($t){
        for($r=5381;$o>$n;$n++){
            $r += ($r<<5) + ord(substr($t,$n,1));
        }
        my $token = 2147483647 & $r;
        
        print "$token\n";
        return $token;
    } 
	
	
}



1;
