use Mojo::Qzone::User;
use Encode qw(decode encode);
use Encode::Locale;
sub Mojo::Qzone::Model::_visit_uin
{

	my $self=shift;
	my $uin=shift;
    my $user_obj=Mojo::Qzone::User->new();
    $user_obj->uin($uin);
	$self->info("try to visit $uin homepage\n");
    if($self->login_state ne 'success')
    {
    	$self->fatal("you have not login success, must login before visit $uin qzone");
    }
    #http://1219054530.qzone.qq.com/
	my $userurl="http://user.qzone.qq.com/".$uin;
	

	$self->info("try to visit $userurl\n");
	
	my $accept='text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
	my $acceptencoding='gzip,deflate';
	my $acceptlanguage='zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3';
	my $connection='keep-alive';
	my $host='user.qzone.qq.com';
	my $useragent='Mozilla/5.0 (Windows NT 6.1; rv:38.0) Gecko/20100101 Firefox/38.0';
	my $modified='Sun, 28 Feb 2016 01:15:09 GMT';

		my $cookies= $self->ua->cookie_jar->all;
		
	my ($content,$ua,$tx)=$self->http_get($userurl);

	if(my $res=$tx->success)
	{
	  
	   my $title=$res->dom->at('title')->text; #应该不是utf8编码
	  # $self->info($title);
	   $self->info(encode('utf8',$title));
	  #  $self->info($res->body);


	
	   if($title=~/$uin/)
	   {
	   	   $self->info("发现$uin主页，登陆成功\n");
	   	   $user_obj->is_visible(1);
	   	     return $user_obj;
	   }
	   else
	   {
	   	     $user_obj->is_visible(0);
	   	     if ($title=~/\b404\b/)
	         {
	   	       $self->info("没有404 登陆成功");
	   	 
	         }
	        
	        return $user_obj;
	   	
	   	
	   }
	   
	 
	 #  if($title=~/(\d+)/){$self->info($1)}
#	   $title=decode('utf8',$title);
#	     $title=encode('utf-8',$title);
#	   $self->info($title);
       
	}
	

	
	
	
	
}

sub Mojo::Qzone::Model::test
{
 my $self=shift;	
 $self->info("test testtest test\n");
 
}
1;