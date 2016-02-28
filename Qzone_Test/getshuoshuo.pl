#!/usr/bin/perl -w
use strict;
use lib "F:\\Qzone\\lib";
use Encode qw(encode);
use utf8;
use Mojo::Qzone;
#517395fcnppgcvfj
#2149957710          	517395fcnppgcvfj
my $qq='2149957710';
my $uin='744891290';
my $pwd='517395fcnppgcvfj';
my $client=Mojo::Qzone->new(
qq=>$qq,
pwd=>$pwd,
login_type=>'login',
);
$client->login();
#定义登陆成功触发事件
$client->on(login=>sub{shift->info("Login Success\n,You can do interesting thing by it")});

my @text=$client->getshuoshuo($uin,40);
my @result;

map{push @result,encode("gbk",$_)} @text;
my $file=$uin.'_result.txt';
open FH,">$file";
print FH @result;

