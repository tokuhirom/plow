package Plow::Functions;
use strict;
use warnings;
use utf8;

use List::Util ();
use Path::Class ();
use Carp ();
use Data::Dumper ();
use Class::XSAccessor ();

sub import {
    my $class = shift;
    my $pkg = caller(0);
    $class->export_to($pkg);
}

sub export_to {
    my ($class, $pkg) = @_;

    no strict 'refs';
    *{"${pkg}::min"} = \&List::Util::min;
    *{"${pkg}::max"} = \&List::Util::max;

    *{"${pkg}::file"} = \&Path::Class::file;
    *{"${pkg}::dir"} = \&Path::Class::dir;

    *{"${pkg}::croak"} = \&Carp::croak;
    *{"${pkg}::confess"} = \&Carp::confess;

    *{"${pkg}::has"} = \&has;
    *{"${pkg}::new"} = \&new;

    *{"${pkg}::slurp"} = \&slurp;

    *{"${pkg}::p"} = \&p;
}

sub p($) {
    local $Data::Dumper::Terse  = 1;
    local $Data::Dumper::Indent = 0;
    print Data::Dumper::Dumper($_[0]), "\n";
}

sub has {
    my $caller = caller(0);
    my $meth = shift;
    my %opts = @_;
    my $type = +{
        ro => 'getters',
        rw => 'accessors',
    }->{delete $opts{is}};
    unless ($type) {
        Carp::confess("Missing or invalid 'is' parameter");
    }
    Class::XSAccessor->import(
        $type => {
            $meth => $meth
        },
    );
    if (%opts) {
        Carp::confess("Invalid options for has.: " . Data::Dumper::Dumper(\%opts));
    }
}

sub slurp {
    my $fname = shift;
    my $op = shift || '<:utf8';
    open my $fh, $op, $fname
        or Carp::croak "$fname: $!";
    do { local $/; <$fh> };
}

sub new {
    my $class = shift;
    my %args = @_==1 ? %{$_[0]} : @_;
    return bless {%args}, $class;
}

1;

