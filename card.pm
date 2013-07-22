package card;

use strict;
use Switch;

my @suits  = qw (h d c s);
my @values = qw (2 3 4 5 6 7 8 9 T J Q K A);

sub new {

    my $class = shift;

    my $self = {
        suit  => shift,
        value => shift,
    };

    bless $self;
}

# Getters and Setters -----------------------

sub get_suit {
    my $self = shift;
    return $self->{suit};
}

sub set_suit {
    my $self = shift;
    my $suit = shift;
    $self->{suit} = $suit;
}

sub get_value {
    my $self = shift;
    return $self->{value};
}

sub set_value {
    my $self  = shift;
    my $value = shift;
    $self->{value} = $value;
}


# Functions ---------------------------------

sub value_of {

    my $card  = shift;
    my $value = $card->get_value();

    return $value if $value =~ /\d/;
    return 10     if $value =~ /(T|J|Q|K)/;
    return 11     if $value =~ /A/;

}

sub get_value_english {

    my $card  = shift;
    my $value = $card->get_value;

    switch ($value) {
        case 'T' { return "Ten" }
        case 'J' { return "Jack" }
        case 'Q' { return "Queen" }
        case 'K' { return "King" }
        case 'A' { return "Ace" }
    }

    return $value;

}


sub get_suit_english {

    my $card = shift;
    my $suit = $card->get_suit;

    switch ($suit) {
        case 'h' { return "Hearts" }
        case 's' { return "Spades" }
        case 'd' { return "Diamonds" }
        case 'c' { return "Clubs" }

    }

}

sub is_an_ace {
    my $self = shift;
    return 1 if $self->get_value eq 'A';
    return 0;
}

1;


