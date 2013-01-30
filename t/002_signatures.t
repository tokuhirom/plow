use strict;
use warnings;
use utf8;
use Test::More;

{
    use Plow;

    sub foo($a, $b) {
        $a+$b;
    }
    is(foo(1,2), 3);
}

done_testing;

