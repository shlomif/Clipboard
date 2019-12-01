package Clipboard::MacPasteboard;

use strict;
use warnings;

use Mac::Pasteboard 0.011;

our $board = Mac::Pasteboard->new();
$board->set( missing_ok => 1 );
sub copy {
    my $self = shift;
    $board->clear();
    $board->copy($_[0]);
}
sub paste {
    my $self = shift;
    return scalar $board->paste();
}

1;
