package Clipboard::Xclip;
use Spiffy -Base;
use IO::All;
sub copy {
    io('|xclip -i -selection '. $self->favorite_selection) < $_[0];
}
sub paste {
    for ($self->all_selections) {
        my $data = io("xclip -o -selection $_|")->all;
        return $data if $data !~ /^(?:\n|)$/m;
    }
    undef
}
# This ordering isn't officially verified, but so far seems to work the best:
sub all_selections { qw(primary buffer clipboard secondary) }
sub favorite_selection { ($self->all_selections)[0] }
eval { io('xclip -o|')->all }; $@ and die <<EPIGRAPH;

Can't find the 'xclip' script.  Clipboard.pm's X support depends on it.

Here's the project homepage: http://freshmeat.net/projects/xclip

EPIGRAPH
