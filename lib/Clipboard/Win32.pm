package Clipboard::Win32;

use strict;
use warnings;

use Win32::Clipboard;

our $board = Win32::Clipboard();
sub copy {
    my $self = shift;
    $board->Set($_[0]);
}
sub paste {
    my $self = shift;
    return $board->Get();
}

1;
