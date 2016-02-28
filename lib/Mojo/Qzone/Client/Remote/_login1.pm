sub Mojo::Qzone::Client::_loginpwd
{
my $self=shift;
my $login_type=$self->login_type;
$self->info("try to login with the password  \n") if $login_type eq "login";
my $login_url='https://ssl.ptlogin2.qq.com/login?';
my @query_parameters;
if($login_type eq "login")
{
   if(not defined  $self->qq)
   {
     $self->fatal("未设置账号，无法登陆");
     $self->stop();
     return 0;
   }
   if (not defined $self->pwd)
   {
     $self->fatal("未设置密码，无法登陆")；
     $self->stop();
     return 0;
   }
   my $p;
   eval{
    $p= Mojo::Qzone::Encryption::pwd_encrypt($self->pwd,$self->md5_salt,$self->verifycode,1) ;
   };
   if($@)
   {
       $self->error("客户端加密算法执行错误 $@\n");
       return "contact author,check Encryption.pm\n"
   }

   @query_string = (
    u               =>  $self->qq,
    p               =>  $passwd,
    verifycode      =>  $self->verifycode,
    qzone_type      =>  10,
    remember_uin    =>  1,
    login2qq        =>  1,
    aid             =>  $self->g_appid,
    u1              =>  $query_string_ul,
    h               =>  1,
    ptredirect      =>  0,
    ptlang          =>  2052,
    daid            =>  $self->g_daid,
    from_ui         =>  1,
    pttype          =>  1,
    dumy            =>  undef,
    fp              =>  'loginerroralert',
    action          =>  $query_string_action,
    mibao_css       =>  $self->g_mibao_css,
    t               =>  1,
    g               =>  1,
    js_type         =>  0,
    js_ver          =>  $self->g_pt_version,
    login_sig       =>  $self->g_login_sig,
    pt_randsalt     =>  $self->isRandSalt,
    pt_vcode_v1     =>  0,
    pt_verifysession_v1 =>   $self->pt_verifysession || $self->search_cookie("verifysession"
    );

);
}

#to improve stable
my $content=$self->http_get(get_url($self->get_url($login_url,@query_parameters),$headers);
return 0 unless defined $content;
my %d;
@d{qw( retcode unknow_1 api_check_sig unknow_2 status uin)}=$content=~/'(.*?)'/g;
if($d{retcode} == 4)
{
       $self->error("您输入的验证码不正确，需要重新输入...\n");
       return -1;
}
elsif($d{retcode} == 3)
{
       if($self->encrypt_method eq "perl"){
           return -2;
       }
       else{
           $self->fatal("您输入的帐号或密码不正确，客户端终止运行...\n");
           $self->stop();
       }
}
elsif($d{retcode} != 0)
{
       $self->fatal("$d{status}，客户端终止运行...\n");
       $self->stop();
       return 0;
}
$self->api_check_sig($d{api_check_sig})->ptwebqq($self->search_cookie('ptwebqq'));

  return 1;
}
1;
#http://ptlogin2.qq.com/login?u=1017044504&verifycode=!YWC&pt_vcode_v1=0&pt_verifysession_v1=37a94a5542f81c09a02f63020512f29a184cb81427bdcd1b132ed0402b2f3d8f42c5b11d2ead7f5c62219010775f1078cdb055edba3b096c&p=mYp2tkziYPRmot7C9Q-WZUQDvoTmNnMik0EOzP9jti8lUlBAkrABtv5qKzqsgQzHZi5jPCLETQahLbYhlkJAvIw5Lfga1anr3zAXDA7Ztay08CirEig9eZtiV314ua8yeqVmHoBGIBAUDxmXuAhNqOedytsbOsVtxvc71dh5XleJX-B-RAu1F9d988R-OTf9E-xIqcRWDd8uMIwGV2oprw__&pt_randsalt=0&u1=http%3A%2F%2Fqzs.qq.com%2Fqzone%2Fv5%2Floginsucc.html%3Fpara%3Dizone&ptredirect=0&h=1&t=1&g=1&from_ui=1&ptlang=2052&action=2-1-1455859342424&js_ver=10149&js_type=1&login_sig=LxX-sQVdMEdV6v46JJMBtkdPyTVI0QF8bvU9y78t401JddRj4vqhIeMUVzxmPiT-&pt_uistyle=32&aid=549000912&daid=5&

}
