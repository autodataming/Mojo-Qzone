package Mojo::Qzone;
use strict;
$Mojo::Qzone::VERSION = "1.0.0";
use base qw(Mojo::Base);
use Mojo::Qzone::Log;
use Mojo::Qzone::Cookie;
sub has { Mojo::Base::attr(__PACKAGE__, @_) };

use base qw(Mojo::EventEmitter Mojo::Qzone::Base Mojo::Qzone::Client  Mojo::Qzone::Model );

has qq => undef;
has pwd => undef;
has cookie_dir          => sub{return $_[0]->tmpdir;};
has tmpdir              => sub {File::Spec->tmpdir();};
has ua_debug            => 0;

has login_type          => 'login';    #qrlogin|login
###Qzone
has is_stop             =>0;
#&js_ver=10150
#&js_type=1
has js_ver              =>10150;
has js_type             =>1; 
has appid               =>549000912; #549000912qzone|webqq501004106
has type                => 'qzone';  #qzone|smartqq|
has _qz_referrer           => 'i.qq.com';
has log_encoding        => undef;  #utf8|gbk|...
has log_path            => undef;
has log_level           => 'info';     #debug|info|warn|error|fatal
has ua_retry_times          => 5;
has keep_cookie       =>1;
has pt_verifysession       => undef,
has ptvfsession            => undef;
has md5_salt               => undef;
has cap_cd                 => undef;
has isRandSalt             => 0;
has verifycode             => undef;
has is_need_img_verifycode => 0;

has pt_login_sig => undef;


has api_check_sig =>undef;
has check_sig_url=>undef;
has skey  =>undef;
has RK =>undef;
has ptcz=>undef;

has p_skey=>undef;
has superkey=>undef;
       
has login_state             => "init";#init|relogin|success|scaning|confirming|fail
has ioloop              => sub {Mojo::IOLoop->singleton};
has ua=> sub
{
	my $self=shift;
    require Mojo::UserAgent;
    require Storable if $self->keep_cookie;
	Mojo::UserAgent->new(
        max_redirects      => 7,
        request_timeout    => 120,
        inactivity_timeout => 120,
        transactor => Mojo::UserAgent::Transactor->new( 
            name =>  'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062'),
         cookie_jar => Mojo::Qzone::Cookie->new(),
        ,
    );
	
};



has log    => sub
{
	Mojo::Qzone::Log->new
	  (encoding=>$_[0]->log_encoding,
	   path=>$_[0]->log_path,
	   level=>$_[0]->log_level,
	   format=>sub
	   {
					my ($time, $level, @lines) = @_;
					my $title = "";
					if(ref $lines[0] eq "HASH"){
					    my $opt = shift @lines; 
					    $time = $opt->{"time"} if defined $opt->{"time"};
					    $title = $opt->{title} . " " if defined $opt->{"title"};
					    $level  = $opt->{level} if defined $opt->{"level"};
					}
					@lines = split /\n/,join "",@lines;
					my $return = "";
					$time = $time?POSIX::strftime('[%y/%m/%d %H:%M:%S]',localtime($time)):"";
					$level = $level?"[$level]":"";
					for(@lines)
					   {
						    $return .=
						      $time
						    . " " 
						    . $level 
						    . " " 
						    . $title 
						    . $_ 
						    . "\n";
                        }
                   return $return;
       }
       );
};

sub new
{
	
    my $class = shift;
    my $self  = $class->Mojo::Base::new(@_);

    if(not defined $self->{qq}){
        $self->fatal("客户端初始化缺少qq参数");
        $self->exit();
    }
    else
    {
    	$self->info("get the qq number $self->{qq} \n");
    	$self->info("get the password  $self->{pwd} \n");
    	
    }
    


    $self;
}


1;
