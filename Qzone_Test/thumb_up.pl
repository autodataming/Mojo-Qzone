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
#�����½�ɹ������¼�
$client->on(login=>sub{shift->info("Login Success\n,You can do interesting thing by it")});
$client->thumb_up($uin,5);
#90s ���һ�Σ�$uin���µ�5��˵˵,���û�е��޾ͻ��Զ����ޡ�
#$client->interval(90,sub{$client->thumb_up($uin,5)});

$client->run();


