package Plow;
use strict;
use warnings;
use utf8;

use 5.10.0;

use Time::Piece qw/:override/; # override localtime, gmtime

use File::stat (); # make stat() function OO.
use Devel::Declare::MethodInstaller::Simple;

sub plowfy {
    my ($class, $fname, $src) = @_;

    return join("\n",
        "use 5.10.0; use utf8::all; use Plow::Signatures; use Plow::Signatures::Beam;",
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
    use Plow::Signatures;
}

1;

__END__

=head1 NAME

Plow - plow plow plow

sub UNIVERSAL::AUTOLOAD {
    warn "AH";
    if ($UNIVERSAL::AUTOLOAD =~ /::(file|max|min)\z/) {
        my $code = +{
            file => sub {
                return Path::Class::file(@_);
            },
            max => sub {
                return List::Util::max(@_);
            },
            min => sub {
                return List::Util::min(@_);
            },
        }->{$1};
        if ($code) {
            return $code->(@_);
        }
    }
    Carp::croak("Undefined subroutine &${UNIVERSAL::AUTOLOAD} called");
}

#   binmode *STDIN,  ':encoding(utf-8)';
#   binmode *STDOUT, ':encoding(utf-8)';
#   binmode *STDERR, ':encoding(utf-8)';
