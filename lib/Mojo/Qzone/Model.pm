package Mojo::Qzone::Model;
use strict;
use List::Util qw(first);

use Mojo::Qzone::User;
use base qw (Mojo::Qzone::Base);

use Mojo::Qzone::Model::Remote::_visit_uin;
use Mojo::Qzone::Model::Remote::_taotao;
#这里是用于存放对外开放的接口

#g_tk g_tk	2098489528
#g_tk	1414154653
#unikey 	
#http://user.qzone.qq.com/744891288/mood/98 23662c 62a93755c2970800.1
#http://user.qzone.qq.com/744891290/mood/9a 23662c 9ae2cb5649310d00.1
#                                                  9a23662 cd8e4cb5692280100.1
#                                                  9a23662c1119a75624320000.1
#GET http://taotao.qq.com/cgi-bin/emotion_cgi_msglist_v6
#?uin=744891200&inCharset=utf-8&outCharset=utf-8&hostUin=744891200&notice=0&sort=0&pos=20&num=20&cgi_host=http%3A%2F%2Ftaotao.qq.com%2Fcgi-bin%2Femotion_cgi_msglist_v6&code_version=1&format=jsonp&need_private_comment=1&g_tk=1414154653http://taotao.qq.com/cgi-bin/emotion_cgi_msglist_v6?uin=744891200&inCharset=utf-8&outCharset=utf-8&hostUin=744891200&notice=0&sort=0&pos=20&num=20&cgi_host=http%3A%2F%2Ftaotao.qq.com%2Fcgi-bin%2Femotion_cgi_msglist_v6&code_version=1&format=jsonp&need_private_comment=1&g_tk=1414154653

sub getshuoshuo
{
	my $self=shift;
	my $uin=shift;
	my $num=shift;
	$num=$num?$num:40;
	print "$num\n";
	my @text;
	$self->info("ready to search the last $num shuo shuo of the $uin");
    
    my $user_obj=$self->_visit_uin($uin);
    print Dumper($user_obj);
    	
	if($user_obj->is_visible)
	{
		@text=$self->_getshuoshuo($user_obj,$num);
	}
	else
	{
	 	$text[0]="$self->qq  can't access to $uin\n";
	}
	return @text;
}


sub thumb_up
{
my $self=shift;
my $uin=shift;
my $shuo_num=shift;
$self->info("ready to search the last $shuo_num shuo shuo of the $uin");
my $user_obj=$self->_visit_uin($uin);	#Mojo::Qzone::User;
print Dumper($user_obj);
if($user_obj->is_visible)
{
my $taotao=$self->_taotao($user_obj);
}
#http://taotao.qq.com/cgi-bin/emotion_cgi_msglist_v6?uin=1017044509&ftype=0&sort=0&pos=0&num=20&replynum=100
#&g_tk=22454137
#&callback=_preloadCallback&code_version=1&format=jsonp&need_private_comment=1
#qzfl_v8_2.1.45.js
#QZFL.pluginsDefine.getACSRFToken(url)
$self->test();
$self->info("visit result is ");
return 1;
}

1;