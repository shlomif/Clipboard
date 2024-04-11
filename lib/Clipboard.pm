package Clipboard;

use strict;
use warnings;

our $driver;

sub copy { my $self = shift; return $driver->copy(@_); }
sub copy_to_all_selections {
    my $self = shift;
    my $meth = $driver->can('copy_to_all_selections');
    return $meth ? $meth->($driver, @_) : $driver->copy(@_);
}

sub cut { goto &copy }
sub paste { my $self = shift; return $driver->paste(@_); }

sub bind_os { my $driver = shift; return map { $_ => $driver } @_; }
sub find_driver {
    my $self = shift;
    my $os = shift;
    my %drivers = (
        # list stolen from Module::Build, with some modifications (for
        # example, cygwin doesn't count as Unix here, because it will
        # use the Win32 clipboard.)
        bind_os(Xsel => qw(linux bsd$ aix bsdos dec_osf dgux
            dynixptx gnu hpux irix dragonfly machten next os2 sco_sv solaris
            sunos svr4 svr5 unicos unicosmk)),
        bind_os(Xclip => qw(linux bsd$ aix bsdos dec_osf dgux
            dynixptx gnu hpux irix dragonfly machten next os2 sco_sv solaris
            sunos svr4 svr5 unicos unicosmk)),
        #bind_os(WaylandClipboard => qw(linux)), # Do not uncomment this line...
        bind_os(MacPasteboard => qw(darwin)),
    );

    if ($os =~ /^(?:mswin|win|cygwin)/i) {
        # If we are connected to windows through ssh, and xclip is
        # available, use it.
        if (exists $ENV{SSH_CONNECTION}) {
            local $SIG{__WARN__} = sub {};
            require Clipboard::Xsel;
            return 'Xsel' if Clipboard::Xsel::xsel_available();
            require Clipboard::Xclip;
            return 'Xclip' if Clipboard::Xclip::xclip_available();
        }

        return 'Win32';
    }
    # Preferentially use Clipboard::WaylandClipboard if we see WAYLAND_DISPLAY
    if (exists($ENV{WAYLAND_DISPLAY}) && length($ENV{WAYLAND_DISPLAY}))
    {
        require Clipboard::WaylandClipboard;
        return 'WaylandClipboard' if Clipboard::WaylandClipboard::available();
    }
    foreach my $d (sort keys %drivers)
    {
        if ($os =~ /$d/i)
        {
            return $drivers{$d};
        }
    }
    # use xsel/xclip on unknown OSes that seem to have a DISPLAY
    if (exists($ENV{DISPLAY}))
    {
        require Clipboard::Xsel;
        return 'Xsel' if Clipboard::Xsel::xsel_available();
        require Clipboard::Xclip;
        return 'Xclip' if Clipboard::Xclip::xclip_available();
    }

    die "The $os system is not yet supported by Clipboard.pm.  Please email rking\@panoptic.com and tell him about this.\n";
}

sub import {
    my $self = shift;
    my $drv = Clipboard->find_driver($^O);
    require "Clipboard/$drv.pm";
    $driver = "Clipboard::$drv";
    return;
}

1;
=head1 NAME

Clipboard - Copy and paste with any OS

=head1 SYNOPSIS

    use Clipboard;
    print Clipboard->paste;
    Clipboard->copy('foo');
    # Same as copy on non-X / non-Xclip systems
    Clipboard->copy_to_all_selections('text_to_copy');


Clipboard->cut() is an alias for copy(). copy() is the preferred
method, because we're not really "cutting" anything.

=head1 DESCRIPTION

Who doesn't remember the first time they learned to copy and paste, and
generated an exponentially growing text document?   Yes, that's right,
clipboards are magical.

With Clipboard.pm, this magic is now trivial to access,
in a cross-platform-consistent API, from your Perl code.

=head1 STATUS

Seems to be working well for Linux, OSX, *BSD, and Windows.  I use it
every day on Linux, so I think I've got most of the details hammered out
(X selections are kind of weird).  Please let me know if you encounter
any problems in your setup.

=head1 AUTHOR

Ryan King <rking@panoptic.com>

=head1 COPYRIGHT

Copyright (c) 2010. Ryan King. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=head1 SEE ALSO

L<clipaccumulate(1)>, L<clipbrowse(1)>, L<clipedit(1)>,
L<clipfilter(1)>, L<clipjoin(1)>

=cut
# vi:tw=72
