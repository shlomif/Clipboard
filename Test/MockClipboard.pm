package PhonyClipboard;
use Spiffy -Base;
our $board = '';
sub copy { $board = $_[0]; }
sub paste { $board }
$Clipboard::driver = 'PhonyClipboard';
