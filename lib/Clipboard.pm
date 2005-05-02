package Clipboard;
use Spiffy -Base;
our $VERSION = '0.02';
our $driver;

sub copy { $driver->copy(@_); }
sub cut { goto &copy }
sub paste { $driver->paste(@_); }

sub bind_os { my $driver = shift; map { $_ => $driver } @_; }
sub find_driver {
    my $os = shift;
    my %drivers = (
        $self->bind_os(Xclip => qw(linux)),
        $self->bind_os(Pb => qw(macos darwin)),
        $self->bind_os(Win32 => qw(^win.* cygwin)),
    );
    $os =~ /$_/i && return $drivers{$_} for keys %drivers;
    die "The $os system is not yet supported by Clipboard.pm.  Please email rking\@panoptic.com and tell him about this.\n";
}
sub import {
    my $drv = Clipboard->find_driver($^O);
    require "Clipboard/$drv.pm";
    $driver = "Clipboard::$drv";
}

1;
=head1 NAME 

Clipboard - Copy and paste with any OS

=head1 SYNOPSIS

    use Clipboard;
    print Clipboard->paste;
    Clipboard->copy($foo);

    # Clipboard->cut() is an alias for copy(), but the less-preferred
    # name - you're not really "cutting", just copying.

=head1 DESCRIPTION

    The clipboard (or "selection", under some environments) is so
    useful.  If we get this working well, then it will also be trivial
    to use from your Perl code.

=head1 STATUS
    
    Very early.  Please help me get this running smoothly.

=head1 AUTHOR

Ryan King <rking@panoptic.com>

=head1 COPYRIGHT

Copyright (c) 2005. Ryan King. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
# vi:tw=72
