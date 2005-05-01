use Test::More 'no_plan'; use strict; use warnings;
use lib 'lib'; # XXX
use Clipboard;
package PhonyClipboard;
use Spiffy -Base;
our $board = '';
sub copy { $board = $_[0]; }
sub paste { $board }
package main;
$Clipboard::driver = 'PhonyClipboard';
my $str = 'Semirobotic Invasion';
Clipboard->copy($str);
is($PhonyClipboard::board, $str, 'copy');
is(Clipboard->paste, $str, 'paste');
