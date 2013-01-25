package Plow;
use strict;
use warnings;
use utf8;

use 5.10.0;

our $VERSION = '1.0.0';

use Time::Piece qw/:override/; # override localtime, gmtime

use File::stat (); # make stat() function OO.

sub plowfy {
    my ($class, $fname, $src) = @_;

    return join("\n",
        "use 5.10.0; no autovivification; use true; use utf8::all; use Plow::Signatures::Func; use Plow::Signatures::Class; use Plow::Signatures::Beam;",
        "#line 1 $fname",
        $src,
    );
}

{
    package # hide from pause
        Class;

    my $i = 0;
    sub new {
        my ($class, $name) = @_;
        $name //= "Class::Anon$i";
        bless {name => $name}, $class;
    }
    sub add_method {
        my ($self, $name, $code) = @_;
        no strict 'refs';
        *{"$self->{name}::${name}"} = $code;
    }
    sub name {
        my $self = shift;
        return $self->{name};
    }
}

sub beam {
    my ($class, $module) = @_;
    $module =~ s!::!/!g;
    $module .= ".plow";

    for my $path (@INC) {
        next if ref $path; # for deep recursion

        if (-f "$path/$module") {
            my $fullpath = "$path/$module";
            $INC{$module} = $fullpath;
            open my $fh, '<', $fullpath;
            eval Plow->plowfy($fullpath, do { local $/; <$fh> });
            return;
        }
    }
    die "$module not found in library path( @{[ join(', ', @INC) ]} )\n";
}

{
    package main;
    use Plow::Functions;
}

1;

__END__

=head1 NAME

Plow - plow plow plow

