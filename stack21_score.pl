#!/usr/bin/perl

## Stack21
## You have $number_of_stacks and a deck of cards.
## Come as close to 21 as you can get in those $number_of_stacks piles.
## You have $passes skip cards.
##
## By Augie De Blieck Jr.
## 02 February 2006
##

use strict;
use stack;
use deck;
use card;

## Subroutines (at the end of script):
## ------------------------------------
## * create_stacks
## * show_stacks
## * find_total (of all stacks)
##

my @stacks;    # Series of stack objects
my $number_of_stacks = 8;

my $passes      = 3;    # Number of skips left to play
my $no_new_card = 0;
my $score       = 0;

my $counter  = 1;
my $choice   = 0;
my $top_card = 0;

##
## Create stacks, deck
##

create_stacks( $number_of_stacks, \@stacks );
my $deck = deck->new();
$deck->shuffle();

MAINGAME:
while (
    ( find_total( \@stacks, $number_of_stacks ) != ( $number_of_stacks * 21 ) )
    && ( $choice !~ /END/i ) )
{

    if ( $no_new_card == 0 ) {
        $top_card    = $deck->get_next_card();
        $no_new_card = 0;
    }

    $score = find_total( \@stacks, $number_of_stacks );
    show_stacks( $number_of_stacks, @stacks );

    my $deck_size = $deck->count_cards();
    my $card      = $top_card->get_value_english;
    my $suit      = $top_card->get_suit_english;

    print qq~
      SCORE: $score     PASSES LEFT: $passes     CARDS LEFT: $deck_size
      -----------------------------------------------------------
      NEW CARD: $card of $suit

      Please select a stack (1 - $number_of_stacks), (E)ND, or (P)ASS:~;

    chomp( $choice = <STDIN> );

    print "\n\n\n\n\n\n\n";

    ## If ENDING THE GAME
    if ( $choice =~ /(E|END)/i ) {
        $choice = "END";
        last MAINGAME;
    }
   ## If PASSING on a card
    if ( $choice =~ /(P|PASS)/i ) {
        if ( $passes > 0 ) {
            $passes--;
            $no_new_card = 0;
        }
        else {
            $no_new_card = 1;
            print "SORRY - YOU'RE OUT OF PASSES\n\n\n";
        }

        next MAINGAME;

    }

    if (   ( $choice !~ /\d/ )
        || ( $choice > $number_of_stacks )
        || ( $choice < 1 ) )
    {

        $no_new_card = 1;
        print "SORRY - INVALID CHOICE - PLEASE TRY AGAIN\n\n\n";
        next MAINGAME;
    }

    ## If a STACK IS CHOSEN
    ## Is STACK FULL or CLOSED or CAN'T HOLD THIS CARD?
    if ( $stacks[$choice]->is_full ) {
        $no_new_card = 1;
        print "SORRY - THAT STACK IS ALREADY FULL\n";
        next MAINGAME;
    }
    elsif (( $stacks[$choice]->stack_score == 21 )
        && ( $stacks[$choice]->has_an_ace  == 0  ))
    {
        print "That stack is closed at 21. Please choose another.\n";
        $no_new_card = 1;

    }
    elsif (( $stacks[$choice]->stack_score + $top_card->value_of() > 21 )
        && ( $top_card->get_value() eq 'A' ) )
    {
        ## Total is greater than 21, but you've drawn an ACE, so it's 1, not 11

        $stacks[$choice]->add_card($top_card);
        $no_new_card = 0;
    }
    elsif ( ( $stacks[$choice]->stack_score + $top_card->value_of() > 21 )
        && $stacks[$choice]->has_an_ace == 0 )
    {

        ## Total is greater than 21 without an ace -- you're busted

        $no_new_card = 1;
        print "\n   SORRY - THAT WOULD BUST YOUR STACK\n";
        next MAINGAME;
    }
    elsif ( $choice > $number_of_stacks ) {
        ## Invalid key stroke
        $no_new_card = 1;
        print "INVALID STACK NUMBER (1 to $number_of_stacks)\n\n\n";
        next MAINGAME;
    }
    else {
        ## I have no further reason to say no.  Add the card to the stack.
        $stacks[$choice]->add_card($top_card);
        $no_new_card = 0;
    }
}

print "\n\n\n";
print "Congrats, your final score is $score.\n";

# Functions ------------------------------------------

sub create_stacks {

    my $maxstacks = shift;
    my $stacks    = shift;

    foreach my $counter ( 1 .. $maxstacks ) {
        @$stacks[$counter] = stack->new;
    }

    return;

}

sub show_stacks {

    my $many_stacks = shift;
    my @stacks      = @_;

    print "\n# --------------------------------------------------------------- #\n";
    foreach my $mystack ( 1 .. $many_stacks ) {

        print "STACK #$mystack: (" . $stacks[$mystack]->stack_score;

        my $spaces = 10;

        if ( $stacks[$mystack]->stack_score > 9 ) {
            $spaces = 9;
        }

        if ( $stacks[$mystack]->is_soft21 ) {
            print " SOFT)    ";
        }
        else {
            print ")" . ( " " x $spaces );
        }

        foreach my $position ( 1 .. 5 ) {
            my $tmp_card = "card$position";


            if ( $stacks[$mystack]->{$tmp_card} eq "0" ) {
                print "--     ";
            }
            else {
                my $tmp       = $stacks[$mystack]->{$tmp_card};
                my $formatted = $tmp->get_value . $tmp->get_suit;
                print $formatted . "     ";
            }

        }

        print "\n";
    }
    return;

}

sub find_total {

    ## Add up all stacks
    ## for final score
    my $self       = shift;
    my $num_stacks = shift;
    my $counter    = 1;
    my $total      = 0;

    while ( $counter < ( $num_stacks + 1 ) ) {
        $total += @$self[$counter]->stack_score;
        $counter++;
    }
    print "\n";
    return $total;
}



