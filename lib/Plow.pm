package Plow;
use strict;
use warnings;
use utf8;

use 5.16.2;

use Time::Piece qw/:override/;

# add some more builtin functions
use List::Util ();
use Path::Class ();
use Carp ();
sub UNIVERSAL::AUTOLOAD {
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
sub UNIVERSAL::DESTROY { }

use File::stat (); # make stat() function OO.

1;

