#http://ptlogin4.qzone.qq.com/check_sig?pttype=1&uin=1017044504&service=login&nodirect=0&ptsigx=5a4a699ed4d997159c9391e908ca0450e078b26346f29a2a0af06f276c8b944b85e1a45e17f28fbac13fd446ca32c4ae342a6b662f1802308f8ec3459f3b9266&s_url=http%3A%2F%2Fqzs.qq.com%2Fqzone%2Fv5%2Floginsucc.html%3Fpara%3Dizone%26specifyurl%3Dhttp%253A%252F%252Fuser.qzone.qq.com%252F1017064534&f_url=&ptlang=2052&ptredirect=100&aid=549000912&daid=5&j_later=0&low_login_hour=0&regmaster=0&pt_login_type=1&pt_aid=0&pt_aaid=0&pt_light=0&pt_3rd_aid=0
sub Mojo::Qzone::Client::_check_sig
{
	my $self=shift;
	$self->info("服务器需要再次确认登陆成功\n");
	my $check_sig_url=$self->check_sig_url;
	
	my $content=$self->http_get($check_sig_url);
	
	 return 0 unless defined $content;
	 $self->info("get some useful cookie\n");
	 
	 my $cookies=$self->ua->cookie_jar->all;
	 for(@$cookies)
	 {
	     $self->info($_->name);
	     if($_->name eq 'superkey')
	     {
	     	$self->superkey($_->value);
	     	$self->p_skey($_->value);
	        	
	     } 
	     	
	 }
	 	
	 
    return 1;
	
	
}


1;