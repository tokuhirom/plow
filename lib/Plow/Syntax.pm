package Plow::Syntax;
use strict;
use warnings;
use utf8;

use B::Hooks::Parser;

sub import {
    my $class = shift;
    my $pkg   = caller(0);

    B::Hooks::Parser::setup();
    my $linestr = B::Hooks::Parser::get_linestr();
    my $offset  = B::Hooks::Parser::get_linestr_offset();
    substr( $linestr, $offset, 0 ) = 'use B::OPCheck const => check => \&Plow::Syntax::_check;';
    B::Hooks::Parser::set_linestr($linestr);
}

sub _check {
    my $op = shift;
    # return unless ref( $op->gv ) eq 'B::PV';

    my $linestr = B::Hooks::Parser::get_linestr;
    my $offset  = B::Hooks::Parser::get_linestr_offset;
    if ( substr( $linestr, $offset, 7 ) eq 'package' ) {
        my $line = substr( $linestr, $offset );
        if ( $line =~ /\A(package\s+(?:[A-Za-z0-9_:-]+)\s*[\{;])/ ) {
            substr( $linestr, $offset + length($1), 0 ) = ';use Moo;use Plow::Functions;';
            B::Hooks::Parser::set_linestr($linestr);
        }
    }
}

1;

