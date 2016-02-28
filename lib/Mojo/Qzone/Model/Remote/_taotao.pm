use Mojo::Qzone::Encryption;
use Mojo::Qzone::Shuoshuo;
use Mojo::JSON qw (decode_json);
use Data::Dumper;
use strict;
sub Mojo::Qzone::Model::_getshuoshuo
{
	my $self=shift;
	my $user_obj=shift;
	my $num=shift;
	print "$num\n\n";
	print Dumper($user_obj);
	my $hash=$self->_taotao($user_obj);
	#print Dumper($hash);
	my @text;
	#map{push @text,"$hash->{msglist}->[$_]->{createTime} ".$hash->{msglist}->[$_]->{conlist}->[0]->{con}."\n"}(0..$num-1);
	for(0..$num-1)
	{
		my $time=$hash->{msglist}->[$_]->{createTime};
		$time=$time?$time:"unknowTime";
		my $shuoshuo=$hash->{msglist}->[$_]->{conlist}->[0]->{con};
		$shuoshuo=$shuoshuo?$shuoshuo:"kong bai";
		if($time && $shuoshuo)
		{
		 push @text,$time." ".$shuoshuo."\n";	
		}
	}
     return @text;
	
}

sub Mojo::Qzone::Model::_taotao
{
	my $self=shift;
	my $user_obj=shift;
	print Dumper($user_obj);
	$self->info("尝试进行获得滔滔不绝:\n");
	my $p_skey=$self->p_skey;
	my $skey=$self->skey;
	$self->info("p_skey is  $p_skey\n");
	#http://taotao.qq.com/cgi-bin/emotion_cgi_msglist_v6?uin=744891290&ftype=0&sort=0&pos=0&num=20&replynum=100&g_tk=22454137&callback=_preloadCallback&code_version=1&format=jsonp&need_private_comment=1
	my $taotaourl='http://taotao.qq.com/cgi-bin/emotion_cgi_msglist_v6';
	my @query_string;
	#?uin=744891290
	#&ftype=0
	#&sort=0
	#&pos=0
	#&num=20  #获得说说的条数
	#&replynum=100 #？
		
	#&g_tk=22454137 根据super_skey 加密获得
	my $g_tk=Mojo::Qzone::Encryption->getACSRFToken($skey);
	#$self->info("get g_tk  $g_tk\n");
	#&callback=_preloadCallback
	#&code_version=1
	#&format=jsonp
	#&need_private_comment=1';
	
	@query_string= 
	(
	uin=>$user_obj->uin,
	ftype=>0,
	sort=>0,
	pos=>0,
	num=>40,  #默认值是10，一次最多获得40条说说。 
	replynum=>0,
	g_tk=>$g_tk,
	callback=>'_preloadCallback',
	code_version=>1,
	format=>'jsonp',
	need_private_comment=>1,
	
	);
	#print join "\n",@query_string;
	my $url_sub=$self->gen_url($taotaourl,@query_string);
	
	
	
	
	$self->info("taotao url is $url_sub\n");
	
	

	
	
    my ($content,$ua,$tx)=$self->http_get($url_sub);
    
    $content=~s/\_preloadCallback\(//;
    $content=~s/\)\;//;
  #  $self->info($content);

    my $hash_taotao=decode_json($content);
  
  #  print Dumper $hash;
   #print "\n\n";
   my $num_shuoshuos=@{$hash_taotao->{msglist}};
   my $shuoshuo1=$hash_taotao->{msglist}->[1]->{conlist}->[0]->{con};
   my $shuoshuo=encode("utf8",$hash_taotao->{msglist}->[0]->{conlist}->[0]->{con});
#   $self->info("一共获得了 $num_shuoshuos 条说说\n");
  # $self->info($shuoshuo);

   # my $hash=decode_json $content;
    #my $hash=decode_json($content_json);
  #  my $hash=  $self->http_get($url_sub,{json=>1});
    return $hash_taotao;
     

	
	
	
}
1;