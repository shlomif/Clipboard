use Test::More 'no_plan'; use strict; use warnings;
use lib 'lib'; # XXX
my %map = qw(
    linux Xclip
    freebsd Xclip
    netbsd Xclip
    openbsd Xclip
    Win32 Win32
    cygwin Win32
    MacOS Pb
    darwin Pb
);
use_ok 'Clipboard';
is(Clipboard->find_driver($_), $map{$_}, $_) for keys %map;
my $drv = Clipboard->find_driver($^O);
ok(exists $INC{"Clipboard/$drv.pm"}, "Driver-check ($drv)");
eval { Clipboard->find_driver('NonOS') };
like($@, qr/is not yet supported/, 'find_driver correctly fails');

is($Clipboard::driver, "Clipboard::$drv");
my $silence_stupid_warning = $Clipboard::driver;
