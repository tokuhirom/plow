package Plow::Signatures::Class;
use strict;
use warnings;
use utf8;

use Devel::Declare;

sub class { $_[0]->() }

sub import {
    my $class = shift;
    my $pkg      = caller(0);

    {
        no strict 'refs';
        *{"${pkg}::class"} = \&class;
    }

    Devel::Declare->setup_for(
        $pkg => {
            'class' => [
                DECLARE_PACKAGE,
                \&handle_class,
            ]
        }
    );
}

sub handle_class {
    my ($usepack, $use, $inpack, $name, $proto, $is_block) = @_;
    return (sub (&) { shift; }, undef, "package ${name}; use Moo;");
}

1;

