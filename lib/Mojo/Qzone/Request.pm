package Mojo::Qzone::Request;

sub http_get
{
  my $self=shift;
  return $self->_http_request("get",@_);	
}

sub _http_request
{
    my $self=shift;
    my $method=shift;
    my %opt=(json=>0,retry_times=>$self->ua_retry_times);
    my $tx;
    for (my $i=0;$i<=$opt{retry_times};$i++)
    {
    	$tx=$self->ua->$method(@_);  #$method eq get post
        if($self->ua_debug)
        {
                $self->print("-- Blocking request (@{[$tx->req->url->to_abs]})\n");
                $self->print("-- Client >>> Server (@{[$tx->req->url->to_abs]})\n@{[$tx->req->to_string]}\n");
                $self->print("-- Server >>> Client (@{[$tx->req->url->to_abs]})\n@{[$tx->res->to_string]}\n");
        }
        $self->save_cookie();
        if($tx->success)
        {
        	my $r=$tx->res->body;
        	 return wantarray?($r,$self->ua,$tx):$r;
        }
        elsif(defined $tx)
        {
               $self->warn($tx->req->url->to_abs . " 请求失败: " . ($tx->error->{code} || "-") . " " . $tx->error->{message});
                next;  	
        }
    	
    }
    $self->warn($tx->req->url->to_abs . " 请求失败: " . ($tx->error->{code}||"-") . " " . $tx->error->{message}) if defined $tx;
    return wantarray?(undef,$self->ua,$tx):undef;
}

sub gen_url
{
    my $self=shift;
    my ($url,@query_string)=@_;
    my @query_string_pairs;
   
    while(@query_string){
        my $key = shift(@query_string);
        my $val = shift(@query_string);
        $key = "" if not defined $key;
        $val = "" if not defined $val;
        push @query_string_pairs , $key . "=" . $val;
    }
     my $result=$url . '?' . join("&",@query_string_pairs); 

	return $result;
}
sub save_cookie
{
    my $self = shift;
    return if not $self->keep_cookie;
    return if not defined $self->qq;
    my $cookie_path = File::Spec->catfile($self->cookie_dir ,'mojo_webqq_cookie_' .$self->qq . '.dat');
    eval{Storable::nstore($self->ua->cookie_jar,$cookie_path);};
    $self->warn("客户端保存cookie失败: $@") if $@;
}

#sub search_cookie{
#    my $self   = shift;
#    my $cookie = shift;  #cookie name
#    my @cookies;
#    my @tmp = $self->ua->cookie_jar->all;
#    if(@tmp == 1 and ref $tmp[0] eq "ARRAY"){ 
#        @cookies = @{$tmp[0]};
#    }
#    else{
#        @cookies = @tmp;
#    }
#    my $c = first  { $_->name eq $cookie} @cookies;
#    return defined $c?$c->value:undef;
#}

1;