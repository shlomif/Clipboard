package Clipboard::Pb;
use Spiffy -Base;
use IO::All;
sub copy {
    open my $exe, '|pbcopy' or die "Couldn't run pbcopy: $!";
    print $exe $_[0];
}
sub paste {
    open my $exe, 'pbpaste|' or die "Couldn't run pbpaste: $!";
    return join '', <$exe>;
}
