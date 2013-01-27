package Plow;
use strict;
use warnings;
use utf8;

use 5.10.0;

our $VERSION = '1.0.0';

use Time::Piece qw/:override/; # override localtime, gmtime

use File::stat (); # make stat() function OO.

use Plow::Stdlib;

sub import {
    feature->import(qw/say state switch unicode_strings unicode_eval/);
    true->import;
    utf8::all->import;
    autovivification->unimport;
    Plow::Syntax::Func->import;
    Plow::Syntax::Class->import;
    Plow::Syntax::Beam->import;
}

sub plowfy {
    my ($class, $fname, $src) = @_;

    return join("\n",
        "use 5.10.0; no autovivification; use true; use utf8::all; use Plow::Syntax::Func; use Plow::Syntax::Class; use Plow::Syntax::Beam;",
        "#line 1 $fname",
        $src,
    );
}

sub beam {
    my ($class, $module) = @_;
    $module =~ s!::!/!g;
    $module .= ".plow";

    # require only once.
    return if $INC{$module};

    for my $path (@INC) {
        next if ref $path; # for deep recursion

        if (-f "$path/$module") {
            my $fullpath = "$path/$module";
            $INC{$module} = $fullpath;
            open my $fh, '<', $fullpath;
            ## no critic.
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

=head1 SYNOPSIS

  use Plow;

=head1 DESCRIPTION

Plow is development suite for Perl5.

This distribution provides L<plow> command. Please see it for more details.

B<THIS IS A DEVELOPMENT RELEASE. API MAY CHANGE WITHOUT NOTICE>.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF@ GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
