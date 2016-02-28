#!/usr/bin/perl -w

use lib "F:\\Qzone\\lib";

use Mojo::Qzone;

my $qq='1017044504';
my $pwd='carine34844504';
my $client=Mojo::Qzone->new(
qq=>$qq,
pwd=>$pwd,
login_type=>'login',
);

$client->login();

