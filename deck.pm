package deck;

use strict;
use card;

## Contents
#
# new
# load
# shuffle
# count_cards
# add_card
# get_next_card
dd

my @suits  = qw (h d c s);
my @values = qw (2 3 4 5 6 7 8 9 T J Q K A);

sub new {
    my $self = { cards => [], };
    bless $self;
    $self->load();
    return $self;

}

sub load {
    my $self = shift;

    foreach my $value (@values) {
        foreach my $suit (@suits) {
            $self->add_card( $value, $suit );
        }
    }
}

sub shuffle {
    my $self = shift;
    my $i;

    for ( $i = $self->count_cards ; $i-- ; ) {
        my $j = int rand( $i + 1 );
        next if $i == $j;
        @{ $self->{cards} }[ $i, $j ] = @{ $self->{cards} }[ $j, $i ];
    }
}

sub count_cards {
    my $self = shift;
    return @{ $self->{cards} };
}

sub add_card {
    my $self  = shift;
    my $suit  = shift;
    my $value = shift;

    my $new_card = card->new( $value, $suit );
    push( @{ $self->{cards} }, $new_card );

}

sub get_next_card {
    my $self = shift;
    my $card = shift @{ $self->{cards} };
    return $card;
}

return 1;

