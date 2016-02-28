#!/usr/bin/perl -w
use strict;
use lib "F:\\Qzone\\lib";

use Mojo::Qzone;

my $qq='1017044504';
my $uin='744891290';
my $pwd='carine34844504';
my $client=Mojo::Qzone->new(
qq=>$qq,
pwd=>$pwd,
login_type=>'login',
);
$client->login();
#定义登陆成功触发事件
$client->on(login=>sub{shift->info("Login Success\n,You can do interesting thing by it")});
$client->thumb_up($uin,5);
#90s 监控一次，$uin最新的5条说说,如果没有点赞就会自动点赞。
#$client->interval(90,sub{$client->thumb_up($uin,5)});

$client->run();


