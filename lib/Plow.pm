package Plow;
use strict;
use warnings;
use utf8;

use 5.10.0;

our $VERSION = '1.0.0';

use Time::Piece qw/:override/; # override localtime, gmtime

use File::stat (); # make stat() function OO.

use Plow::Stdlib;

sub plowfy {
    my ($class, $fname, $src) = @_;

    return join("\n",
        "use 5.10.0; no autovivification; use true; use utf8::all; use Plow::Signatures::Func; use Plow::Signatures::Class; use Plow::Signatures::Beam;",
        "#line 1 $fname",
        $src,
    );
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

