package Clipboard::Pb;
use Spiffy -Base;
use IO::All;
sub copy {
    io('|pbcopy') < $_[0];
}
sub paste {
    io('pbpaste|')->all
}
