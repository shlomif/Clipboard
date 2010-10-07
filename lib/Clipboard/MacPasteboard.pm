package Clipboard::MacPasteboard;
use Mac::Pasteboard;
our $board = Mac::Pasteboard->new();
sub copy {
    my $self = shift;
    $board->copy($_[0]);
}
sub paste {
    my $self = shift;
    $board->paste();
}
