#!/usr/bin/perl

use strict;
use warnings;

package MyClass;

use base 'Class::Accessor';

sub hello
{
    print "Hello World!\n";
}

sub add
{
    my ($self, $x, $y) = @_;

    return $x+$y;
}

sub print_add
{
    my ($self, $x, $y) = @_;

    printf "Hello %i!\n", $self->add($x,$y);
}

package DelegateTo;

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(qw(obj));

sub new
{
    my $class = shift;
    my $self = $class->SUPER::new();

    $self->obj(MyClass->new());

    return $self;
}

# The magic is here:
{
    no strict 'refs';
    foreach my $method (qw(hello add print_add))
    {

        *{__PACKAGE__."::".$method} =
            sub {
                my $self = shift;
                return $self->obj()->$method(@_);
            };
    }
}
# End of magic.

package main;

my $d = DelegateTo->new();

$d->print_add(10, 30);

$d->hello();

print "3 + 4 = ", $d->add(3,4), "\n";
