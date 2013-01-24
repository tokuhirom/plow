package Plow::Signatures::Beam;
use strict;
use warnings;
use utf8;

use parent qw/Devel::Declare::Context::Simple/;

sub import {
    my $class = shift;
    my $pkg = caller(0);
    my $warnings = warnings::enabled("redefine");
    my $ctx = $class->new();
    Devel::Declare->setup_for(
        $pkg,
        {
            beam => {
                const => sub { $ctx->parser( @_, $warnings ) }
            }
        }
    );
}

sub parser {
    my $self = shift;
    $self->init(@_);

    $self->skip_declarator;
    my $name   = $self->strip_name
        or die "Missing name after 'beam' keyword";
    $self->shadow(sub { });

    Plow->beam($name);

    return;
}

1;

