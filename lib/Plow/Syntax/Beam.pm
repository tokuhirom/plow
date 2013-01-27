package Plow::Syntax::Beam;
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

    my $linestr = $self->get_linestr;
    substr($linestr, $self->offset, 0) = ";BEGIN { Plow->beam(q{$name}) }";
    $self->set_linestr($linestr);

    $self->shadow(sub { });

    return;
}

1;

