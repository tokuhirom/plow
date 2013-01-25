package Plow::Functions;
use strict;
use warnings;
use utf8;

use List::Util ();
use Carp ();
use Data::Dumper ();

sub import {
    my $class = shift;
    my $pkg = caller(0);
    $class->export_to($pkg);
}

sub export_to {
    my ( $class, $pkg ) = @_;

    no strict 'refs';
    *{"${pkg}::min"} = \&List::Util::min;
    *{"${pkg}::max"} = \&List::Util::max;

    *{"${pkg}::file"} = \&file;
    *{"${pkg}::dir"}  = \&dir;

    *{"${pkg}::decode_json"} = \&decode_json;
    *{"${pkg}::encode_json"} = \&encode_json;

    *{"${pkg}::furl"}      = \&furl;
    *{"${pkg}::http_get"}  = \&http_get;
    *{"${pkg}::http_post"} = \&http_post;

    *{"${pkg}::croak"}   = \&Carp::croak;
    *{"${pkg}::confess"} = \&Carp::confess;

    *{"${pkg}::slurp"} = \&slurp;

    *{"${pkg}::p"} = \&p;
}

sub p($) {
    local $Data::Dumper::Terse  = 1;
    local $Data::Dumper::Indent = 0;
    print Data::Dumper::Dumper($_[0]), "\n";
}

sub slurp {
    my $fname = shift;
    my $op = shift || '<:utf8';
    open my $fh, $op, $fname
        or Carp::croak "$fname: $!";
    do { local $/; <$fh> };
}

sub file { File->new(@_) }
sub dir  { Dir->new(@_) }

our $JSON;
sub _json {
    $JSON ||= do {
        require JSON::XS;
        JSON::XS->new()->ascii(1);
    };
}
sub decode_json { _json()->decode(@_) }
sub encode_json { _json()->encode(@_) }

our $FURL;
sub furl {
    $FURL ||= do {
        require Furl;
        Furl->new();
    };
}
sub http_get { furl()->get(@_) }
sub http_post { furl()->post(@_) }

1;

