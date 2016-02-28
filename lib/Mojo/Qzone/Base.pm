package Mojo::Qzone::Base;
use Carp qw();
use Mojo::JSON qw();
use Encode qw(encode_utf8 encode decode);

sub fatal
{
	
    my $self=shift;
    $self->log->fatal(@_);
    return $self;		
}

sub info
{
    my $self=shift;
    $self->log->info(@_);
    return $self;	
}

sub print {
    my $self = shift;
    my $flag = 1;
    
    $self->log->info({time=>'',level=>'',},join (defined $,?$,:''),@_);
  
    $self;
}
sub warn{
    my $self = shift;
    $self->log->warn(@_);
    $self;
}
1;