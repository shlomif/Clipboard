package Clipboard::Xclip;
use Spiffy -Base;
use IO::All;
sub copy {
    io('|xclip') < $_[0];
}
sub paste {
    io('xclip -o|')->all
}

# XXX should use IO::All
open(TMP, 'xclip -o|') or die <<EPIGRAPH;
Can't find the 'xclip' script.  Clipboard.pm's X support (currently?) depends
on it, but you should have it anyway - it's useful.

Here's the project homepage: http://freshmeat.net/projects/xclip
EPIGRAPH
close(TMP);
