package Mojo::Qzone::User;
use strict;
use base qw(Mojo::Base);
sub has { Mojo::Base::attr(__PACKAGE__, @_) }

has uin =>undef;
has is_visible => undef;# 0 找不到不可见|1可见undef;
has taotao =>undef;   #所有说说的集合



1;