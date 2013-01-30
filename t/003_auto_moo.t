use strict;
use warnings;
use utf8;
use Test::More;

{
    use Plow;

    package Foo {
        has 'x' => (is => 'ro');
    }

    my $foo = Foo->new(x => 3);
    is($foo->x, 3);
}

done_testing;

