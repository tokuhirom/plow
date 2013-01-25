package Plow::Stdlib;
use strict;
use warnings;
use utf8;

{
    package # hide from pause
        Entity;
    use File::Spec;
    use overload (
        q{""} => \&stringify,
    );

    sub new {
        my ($class, @name) = @_;
        my $name = @name==1 ? $name[0] : File::Spec->catfile(@name);
        bless {name => $name}, $class;
    }

    sub stringify {
        my $self = shift;
        $self->{name};
    }
}

{
    package # hide from pause
        Dir;
    use parent -norequire, qw/Entity/;
    use File::Path ();

    sub open {
        my $self = shift;
        opendir my $dh, $self->stringify;
        return $dh;
    }

    sub mkpath {
        my $self = shift;
        File::Path::mkpath($self->stringify);
    }

    sub rmtree {
        my $self = shift;
        File::Path::rmtree($self->stringify);
    }

    sub file {
        my ($self, @names) = @_;
        File->new($self->stringify, @names);
    }
}

{
    package # hide from pause
        File;
    use parent -norequire, qw/Entity/;
    use File::Basename ();

    sub slurp {
        my ($self, $mode) = @_;
        my $fh = $self->open($mode);
        $fh ? do { local $/; <$fh> } : undef;
    }

    sub open {
        my ($self, $mode) = @_;
        $mode ||= '<:utf8';
        open my $fh, $mode, $self->stringify;
        return $fh;
    }

    sub basename {
        my $self = shift;
        return File::Basename::basename($self->stringify);
    }
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

1;

