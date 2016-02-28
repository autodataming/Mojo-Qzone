sub Mojo::Qzone::Client::_login_pwd
{
	my $self=shift;
	my $login_type=$self->login_type;
	$self->info("尝试进行密码登录(1)...\n") if $login_type eq "login";
	
#http://ptlogin2.qq.com/login?u=1017044504&verifycode=!MMM&pt_vcode_v1=0&pt_verifysession_v1=abbf5b6366e8463c435f1800c30b93e204d94205119b5a50b8f96d52aad9f1d3d87266d925f99f59ee1359a07a81182cd7c2be15493a62f5&p=hwlWuHEXY1golktgO5XBhLWgsxtkTp*Go5C2I-PePpn4ogT8cz9Lc48Ayv6BRWUxzGV4ixCp234P652vCTn60Z*hILR5W2I4g2mCfKtXHitylqUdek4WoK6luekUNMVcOTH3EL79bt95X5PCNpv7nUE8zWpBc3pIE4zaImRyBSKxz6C1ZS0S827CC97XtD38eO3sykYthEJFB*HoWvC3tQ__&pt_randsalt=0&u1=http%3A%2F%2Fqzs.qq.com%2Fqzone%2Fv5%2Floginsucc.html%3Fpara%3Dizone&ptredirect=0&h=1&t=1&g=1&from_ui=1&ptlang=2052&action=3-4-1456533113530&js_ver=10150&js_type=1&login_sig=P1UCQFIkqOzp5Ro2ir8g1knVnuZYNE3skaIDz*f95JDpPZrumMXUkDZ1NDg26d6z&pt_uistyle=32&aid=549000912&daid=5&
	




#has pt_verifysession       => undef,
#has ptvfsession            => undef;
#has md5_salt               => undef;
#has cap_cd                 => undef;
#has isRandSalt             => 0;
#has verifycode             => undef;
#has is_need_img_verifycode => 0;
	
	my $loginurl='http://ptlogin2.qq.com/login';

	my $query_url='http%3A%2F%2Fqzs.qq.com%2Fqzone%2Fv5%2Floginsucc.html%3Fpara%3Dizone';
	my $pwd_encrypt;
	eval{require Webqq::Encryption;};
    if($@){
        $self->fatal("帐号密码登录模式需要模块 Webqq::Encryption ,请先确保该模块正确安装");
        $self->stop();
        return 0;
    }
	my $passwd1 = Webqq::Encryption::pwd_encrypt($self->pwd,$self->md5_salt,$self->verifycode,0) ;#0 pwd 是明文	
#	my $passwd2 = Webqq::Encryption::pwd_encrypt_js($self->pwd,$self->md5_salt,$self->verifycode,0) ;#1 pwd是md5后的值#登录密码的32位MD5值
	$self->info("perl encrypt $passwd1");
    $self->info("js encrypt $passwd2");	
    my @query_string;
    
	@query_string=(
	u=>$self->qq,
	verifycode=>$self->verifycode,
	pt_vcode_v1=>0,
	pt_verifysession_v1=>$self->pt_verifysession,
	p=>$passwd1,
	pt_randsalt=>0,
	u1=>$query_url,
	ptredirect=>0,
	h=>1,
	t=>1,
	g=>1,
	from_ui=>1,
ptlang=>2052,
action=>'3-4-1456533113530',
js_ver=>10150,
js_type=>1,
login_sig=>$self->pt_login_sig,
pt_uistyle=>32,
aid=>549000912,
daid=>5,	
	);
	
	my $url_sub=$self->gen_url($loginurl,@query_string);
	$self->info("logiurl is \n$url_sub");
	my $content=$self->http_get($url_sub);
	$self->info($content);
	return 0 unless defined $content;
    #ptuiCB('4','0','','0','您输入的验证码不正确，请重新输入。', '12345678');
    #ptuiCB('3','0','','0','您输入的帐号或密码不正确，请重新输入。', '2735534596');
	
	
	if($login_type eq "login")
	{
        my %d = ();
        @d{qw( retcode unknown_1 api_check_sig unknown_2 status uin )} = $content=~/'(.*?)'/g;
        if($d{retcode} == 4){
            $self->error("您输入的验证码不正确，需要重新输入...\n");
            return $d{retcode};
        }
        elsif($d{retcode} == 3){
          
                $self->fatal("您输入的帐号或密码不正确，客户端终止运行...\n");
                $self->stop();
                return $d{retcode};
            
        }   
        elsif($d{retcode} != 0){
            $self->fatal("$d{status}，客户端终止运行...\n");
            #$self->stop(); #没成功之前，没必要执行CLIENT_COUNT-- 
            return $d{retcode};
        }
        #skey RK ptcz
        my $skey=$self->ua->cookie_jar->search_cookie('skey');
        my $rk=$self->ua->cookie_jar->search_cookie('RK');
        my $ptcz=$self->ua->cookie_jar->search_cookie('ptcz');
        $self->info("get some uesful cookie\nskey: $skey\n");
        $self->api_check_sig($d{api_check_sig})
             ->check_sig_url($d{api_check_sig})
             ->skey($skey)
             ->RK($rk)
             ->ptcz($ptcz);
         $self->info("登陆成功： retcode: is $d{retcode} eq  0\n");    
        return $d{retcode};
        
    }
	
	
	
  

}
1;