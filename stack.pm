package stack;

# new
# add_card
# is_soft21
# total_of
# find_next (position on stack for new card to go)

use card;
use deck;

sub new {

    my $self = {
        card1 => 0,
        card2 => 0,
        card3 => 0,
        card4 => 0,
        card5 => 0,
        full  => 0,    # 5 Card Charlie?
        total => 0,    # The sum of card1 - card5
        aced  => 0,    # Ace in the stack?
    };
    bless($self);
    return $self;
}

sub is_full {
    my $self = shift;
    return $self->{full};
}

sub stack_score {

    my $self = shift;
    return 21 if $self->is_full();
    return $self->{total};

}

sub has_an_ace {

    my $self = shift;
    return $self->{aced};

}

sub add_card {
    my $self = shift;
    my $card = shift;

    my $position = $self->find_next;

    $self->{$position} = $card;

    if ( $position eq "card5" ) {
        $self->{full} = 1;
    }

    if ( $card->get_value() =~ /A/i ) {
        $self->{aced}++;
    }

    $self->total_of;

    return 1;
}

sub is_soft21 {
    my $self = shift;

    return 1 if ( ( $self->{aced} == 1 ) && ( $self->{total} == 21 ) );
    return 0;

}

sub total_of {
    my $self  = shift;
    my $total = 0;

    $self->{aced} = 0;

    foreach my $position ( 1 .. 5 ) {
        my $tmp_card_position = "card$position";
        my $tmp_card          = $self->{$tmp_card_position};
        next if ( $tmp_card == 0 );
        $total += $tmp_card->value_of();
        $self->{aced}++ if $tmp_card->is_an_ace();
    }

    $self->{total} = $total;
    while ( ( $self->{total} > 21 ) && ( $self->{aced} > 0 ) ) {
        $self->{aced}--;
        $self->{total} -= 10;
    }

    if ( ( $self->{total} == 21 ) && ( $self->{aced} > 0 ) ) {
        $self->{soft21} = 1;
    }
    else {
        $self->{soft21} = 0;
    }

    return 1;

}

sub find_next {
    my $self = shift;

    foreach my $position ( 1 .. 5 ) {
        my $tmp_card = "card$position";
        return $tmp_card if $self->{$tmp_card} eq "0";
    }

}

1;
