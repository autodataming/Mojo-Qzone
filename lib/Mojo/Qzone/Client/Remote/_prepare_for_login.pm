use Mojo::Util qw(url_escape);
use Data::Dumper;
#to some useful cookie
#pt_clientip	
#pt_local_token	
#pt_login_sig	
#pt_serverip	
#pt_user_id	
#ptui_identifier
#uikey	
sub Mojo::Qzone::Client::_prepare_for_login
{
	my $self=shift;
	$self->info("初始化".$self->type."客户端参数 ...\n");
	my $starturl='http://xui.ptlogin2.qq.com/cgi-bin/xlogin?proxy_url=http%3A//qzs.qq.com/qzone/v6/portal/proxy.html&daid=5&&hide_title_bar=1&low_login=0&qlogin_auto_login=1&no_verifyimg=1&link_target=blank&appid=549000912&style=22&target=self&s_url=http%3A%2F%2Fqzs.qq.com%2Fqzone%2Fv5%2Floginsucc.html%3Fpara%3Dizone&pt_qr_app=%E6%89%8B%E6%9C%BAQQ%E7%A9%BA%E9%97%B4&pt_qr_link=http%3A//z.qzone.com/download.html&self_regurl=http%3A//qzs.qq.com/qzone/v6/reg/index.html&pt_qr_help_link=http%3A//z.qzone.com/download.html';
#http://xui.ptlogin2.qq.com/cgi-bin/xlogin?proxy_url=http%3A//qzs.qq.com/qzone/v6/portal/proxy.html&daid=5&&hide_title_bar=1&low_login=0&qlogin_auto_login=1&no_verifyimg=1&link_target=blank&appid=549000912&style=22&target=self&s_url=http%3A%2F%2Fqzs.qq.com%2Fqzone%2Fv5%2Floginsucc.html%3Fpara%3Dizone&pt_qr_app=%E6%89%8B%E6%9C%BAQQ%E7%A9%BA%E9%97%B4&pt_qr_link=http%3A//z.qzone.com/download.html&self_regurl=http%3A//qzs.qq.com/qzone/v6/reg/index.html&pt_qr_help_link=http%3A//z.qzone.com/download.html
#http://xui.ptlogin2.qq.com/cgi-bin/xlogin?proxy_url=http%3A//qzs.qq.com/qzone/v6/portal/proxy.html&daid=5&&hide_title_bar=1&low_login=0&qlogin_auto_login=1&no_verifyimg=1&link_target=blank&appid=549000912&style=22&target=self&s_url=http%3A%2F%2Fqzs.qq.com%2Fqzone%2Fv5%2Floginsucc.html%3Fpara%3Dizone&pt_qr_app=%E6%89%8B%E6%9C%BAQQ%E7%A9%BA%E9%97%B4&pt_qr_link=http%3A//z.qzone.com/download.html&self_regurl=http%3A//qzs.qq.com/qzone/v6/reg/index.html&pt_qr_help_link=http%3A//z.qzone.com/download.html	
	#print $starturl,"\n";
	
	my ($content,$ua,$tx)=$self->http_get($starturl);
	
	my $jar = $tx->res->cookies; #Mojo::Cookie::Response
	#$ua->cookie_jar->test();
#	print "\n AAAAA  ",$ua->cookie_jar->search_cookie('pt_login_sig');

#	print "\n";
	
    for(@{$jar})
    {
    $self->info("get some cookie \n");
    $self->info($_->name,"||||",$_->value," end\n"); 
    }
  #  print Dumper($self->ua->cookie_jar);
      my $pt_login_sig=$ua->cookie_jar->search_cookie('pt_login_sig');
     $self->info("get pt_login_sig cookie: $pt_login_sig \n");
	 $self->pt_login_sig($pt_login_sig);
	return 1;
	
}
1;