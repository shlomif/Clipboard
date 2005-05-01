use inc::Module::Install;
name('Clipboard');
author('Ryan King <rking@panoptic.com');
abstract('Cliboard - Copy and Paste with any OS');
license('perl');
version_from('lib/Clipboard.pm');
requires(qw(
    Test::Chunks 0
    IO::All 0
));
check_nmake();
WriteAll();
