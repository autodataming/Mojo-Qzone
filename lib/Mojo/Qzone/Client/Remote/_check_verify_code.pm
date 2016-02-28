sub Mojo::Qzone::Client::_check_verify_code
{
#http://check.ptlogin2.qq.com/check?regmaster=
#&pt_tea=1
#&pt_vcode=1
#&uin=744227268
#&appid=549000912
#&js_ver=10150
#&js_type=1
#&login_sig=8S1INBkdkhg0MFfu8xYYSCMYw9xauYgGLmBh9Vy0gBecpBLUFq577PBZMB2ZSxr7
#&u1=http%3A%2F%2Fqzs.qq.com%2Fqzone%2Fv5%2Floginsucc.html%3Fpara%3Dizone
#&r=0.14102546532136795	
my $self=shift;
my $checkurl='http://check.ptlogin2.qq.com/check';
my $queryurl='http%3A%2F%2Fqzs.qq.com%2Fqzone%2Fv5%2Floginsucc.html%3Fpara%3Dizone';
my @query_string=(
regmaster=>"",
pt_tea =>1,
pt_vcode =>1,
uin => $self->qq,
appid => $self->appid,
js_ver => $self->js_ver,
js_type => $self->js_type,
login_sig => $self->pt_login_sig,
u1=>$queryurl,
r=>0.14102546532136795,
);

my $checkurl_sub=$self->gen_url($checkurl,@query_string);
$self->info("get checkurl:\n $checkurl_sub \n");
my $content=$self->http_get($checkurl_sub);

$self->info("get check verify code information:\n $content\n");
my %d = ();
#ptui_checkVC('0','!CUZ','\x00\x00\x00\xe\xde\x18''f2c8dfc460','0');
 @d{qw( retcode cap_cd md5_salt ptvfsession isRandSalt)} = $content=~/'(.*?)'/g ;
 $self->md5_salt($d{md5_salt})
      ->cap_cd($d{cap_cd})
      ->isRandSalt($d{isRandSalt})
      ->pt_verifysession($d{ptvfsession});
    if($d{retcode} ==0){
        $self->info("检查结果: 很幸运，本次登录不需要验证码\n");
        $self->verifycode($d{cap_cd});
    }
    elsif($d{retcode} == 1){
        $self->info("检查结果: 需要输入图片验证码\n")->is_need_img_verifycode(1) ;
    }
    return 1;
	
}
1;