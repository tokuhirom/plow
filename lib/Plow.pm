package Plow;
use strict;
use warnings;
use utf8;

use 5.10.0;

use Time::Piece qw/:override/; # override localtime, gmtime

use File::stat (); # make stat() function OO.

package Plow::Hook {
    sub new {
        my $class = shift;
        bless {}, $class;
    }

    sub Plow::Hook::INC {
        my $self = shift;
        my $origmodule = shift;
        my $module = $origmodule;
        $module =~ s/\.pm$// or return;
        $module .= ".plow";

        for my $path (@INC) {
            next if ref $path; # for deep recursion

            if (-f "$path/$module") {
                my $fullpath = "$path/$module";
                $INC{$origmodule} = $fullpath;
                open my $fh, '<', $fullpath;
                my @src = 'use 5.10.0; use strict; use warnings; use utf8;';
                return sub {
                    if (@src) {
                        $_ = shift @src;
                        return 1;
                    } else {
                        $_ = <$fh>;
                        if (/package\s+([A-Za-z_][A-Za-z0-9_:]*)/) {
                            Plow::Functions->export_to($1);
                        }
                        return !eof($fh);
                    }
                };
            }
        }

        return;
    }
}


{
    package main;
    use Plow::Functions;
}

BEGIN {
    unshift @INC, Plow::Hook->new();
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
