sub Mojo::Qzone::Client::_get_img_verify_code
{
	my $self=shift;
	return 1 if not $self->is_need_img_verifycode ;
	$self->info("需要输入验证码，等你输入：");
	
}
1;