package Mojo::Qzone::User;
use strict;
use base qw(Mojo::Base);
sub has { Mojo::Base::attr(__PACKAGE__, @_) }

has uin =>undef;
has is_visible => undef;# 0 �Ҳ������ɼ�|1�ɼ�undef;
has taotao =>undef;   #����˵˵�ļ���



1;