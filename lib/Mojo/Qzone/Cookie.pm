package Mojo::Qzone::Cookie;
use Mojo::Base 'Mojo::UserAgent::CookieJar';
use List::Util qw(first);
use Data::Dumper;
sub test
{
  my $self=shift;
  print "\ntestcookie bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n";	
	
}
sub search_cookie
{
 my $self=shift;
 my $cookies=$self->all;
 my $cookiename=shift;

 #print Dumper($cookies);
 my $c = first  { $_->name eq $cookiename} @{$cookies};
 return defined $c?$c->value:undef;
 	
}

1;