#!/usr/bin/perl -w

use lib "F:\\Qzone\\lib";
use Mojo::Qzone::Cookie;
use Mojo::UserAgent;
my $ua=Mojo::UserAgent->new(
        max_redirects      => 7,
        request_timeout    => 120,
        inactivity_timeout => 120,
        transactor => Mojo::UserAgent::Transactor->new( 
            name =>  'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062'),
         cookie_jar => Mojo::Qzone::Cookie->new(),
        ,
    );
my $starturl='http://www.baidu.com/';
$tx=$ua->get($starturl);
$jar = $tx->res->cookies;
for(@{$jar})
{
	print $_->name,"||||",$_->value," end\n";

}

$ua->cookie_jar->test();