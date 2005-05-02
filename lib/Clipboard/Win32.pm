package Clipboard::Win32;
use Spiffy -Base;
use Win32::Clipboard;
our $board = Win32::Clipboard();
sub copy {
    $board->Set($_[0]);
}
sub paste {
    $board->Get();
}
