package Plow::Signatures::Method;
use strict;
use warnings;
use utf8;
use parent qw/Devel::Declare::MethodInstaller::Simple/;

use Sub::Name;

sub import {
    my ( $class ) = @_;
    my $pkg = caller(0);
    $class->install_methodhandler(
        name => 'method',
        into => $pkg,
    );
}

sub parse_proto {
    my $self = shift;
    my ($proto) = @_;
    $proto ||= '';
    my $inject = 'my $self=shift @_;';
    $inject .= "my ($proto) = \@_;" if defined $proto and length $proto;
    return $inject;
}

sub code_for {
    my ( $self, $name ) = @_;

    if ( defined $name ) {
        my $pkg = $self->get_curstash_name;
        $name = join( '::', $pkg, $name )
          unless ( $name =~ /::/ );
        return sub (&) {
            my $code = shift;

            # So caller() gets the subroutine name
            no strict 'refs';
            *{$name} = subname $name => $code;

            return;
        };
    }
    else {
        return sub (&) {
            my $code = shift;
            return $code;
        };
    }
}

1;

