package Plow::REPL;
use strict;
use warnings;
use utf8;

use Term::ReadLine;
use Term::ANSIColor qw/colored/;
use Try::Tiny;
use Data::Dumper;

sub new {
    my $class = shift;
    bless { }, $class;
}

sub run {
    my ($class) = @_;

    my $term = Term::ReadLine->new('plow');
    while ( defined ($_ = $term->readline(colored(['yellow'], 'plow> '))) ) {
        my $PACKAGE = 'main';
        my $src = Plow->plowfy('-', $_);
        my $code = eval "package $PACKAGE; sub { $src; BEGIN { \$PACKAGE = __PACKAGE__ }};";
        if ($@) {
            print STDERR colored(['red'], $@);
            next;
        }
        try {
            my $ret = $code->();

            local $Data::Dumper::Terse  = 1;
            local $Data::Dumper::Indent = 0;
            print colored(['blue'], Data::Dumper::Dumper($ret)), "\n";
        } catch {
            print STDERR colored(['red'], $_);
        } finally {
            $term->addhistory($_) if /\S/;
        };
    }
}

1;

