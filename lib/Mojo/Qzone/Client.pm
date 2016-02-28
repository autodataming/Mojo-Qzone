package Mojo::Qzone::Client;

use strict;
use Mojo::IOLoop;

$Mojo::Webqq::Client::CLIENT_COUNT  = 0;  #our $CLIENT_COUNT=0;


use Mojo::Qzone::Client::Remote::_prepare_for_login;
use Mojo::Qzone::Client::Remote::_check_verify_code;
use Mojo::Qzone::Client::Remote::_get_img_verify_code;
use Mojo::Qzone::Client::Remote::_login_pwd;
use Mojo::Qzone::Client::Remote::_check_sig;

use base qw(Mojo::Qzone::Request );


sub login
{
    my $self=shift;
    my %p = @_;
    my $delay = defined $p{delay}?$p{delay}:0;

    my $callback=sub
    {
    	my $bool1=$self->_prepare_for_login();
    	print "bool1  $bool1\n";
    	my $bool2=$self->_check_verify_code();
    	print "bool2  $bool2\n";
    	my $bool3=$self->_get_img_verify_code();
    	print "bool3  $bool3\n";
    	if($bool1 && $bool2 && $bool3)
    	{
    	    while(1)
    	    {
    	    	my $ret=$self->_login_pwd();
    #ptuiCB('4','0','','0','您输入的验证码不正确，请重新输入。', '12345678');
    #ptuiCB('3','0','','0','您输入的帐号或密码不正确，请重新输入。', '2735534596');
	
	
    	    	
    	    	
    	       if($ret ==0)
    	       {
    	          $self->info("登陆成功 ret is 0\n");
    	          my $bool1= $self->_check_sig();
    	          if($bool1)
    	          {
    	          	 $self->info("服务器再次确认登陆成功");
    	             $self->login_state('success');
    	          }
    	          else
    	          {
    	          	 $self->info("没有通过服务器的check_sig确认");
    	          }
    	          last;	
    	       }
    	       elsif($ret ==4 )
    	       {
    	       	 $self->error("您输入的验证码不正确，需要重新输入...\n");
    	       	 $self->_get_img_verify_code();
                 next;
    	       }
    	       elsif($ret ==3)
    	       {
    	       	    $self->error("登录失败，用户名和密码不正确,请认真检查...");
    	       	    $self->info("若用户名和密码正确仍旧不能登陆，可以联系我 qq群：PERL学习交流 144539789\n");
    	       	       $self->login_state('fail');     
                    last;
    	       	
    	       }
    	       else
    	       {
    	           $self->info("登陆失败 ret is $ret not 1 \n");
    	       	    last;
    	       }
    	    	
    	    }	   		
    	}

       if($self->login_state ne 'success')
       {
            $self->fatal("登录失败，客户端退出（可能网络不稳定，请多尝试几次）");
         
        }
        else
        {
            $self->info("帐号(" . $self->qq . ")登录成功");            
           
            
            $self->emit("login"); #触发客服端登陆成功事件 处理函数
        }
    	
    };
    
    $callback->();
    return $self;

}



sub stop
{
    my $self = shift;
    my $mode = shift || "auto";
    $self->is_stop(1);
    if($mode eq "auto"){
        $Mojo::Qzone::Client::CLIENT_COUNT > 1?$Mojo::Qzone::Client::CLIENT_COUNT--:exit;
    }
    else{
        $Mojo::Qzone::Client::CLIENT_COUNT--;
    }
	
	
}

#24h 监控，run是一个函数,对外的接口
sub run
{
	my $self =shift;
	$self->emit("run"); #这里的run 是一个事件名称 #没有绑定任何事件处理函数。
	$self->ioloop->start unless $self->ioloop->is_running;
	
}

1;
