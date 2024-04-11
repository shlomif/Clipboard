package Clipboard::WaylandClipboard;

# First written 04/11/2024 by Lester Hightower (PAUSE ID hightowe)

use strict;
use warnings;

use File::Spec ();

sub copy {
    my $self = shift;
    my ($input) = @_;
    return $self->copy_to_selection($self->favorite_selection, $input);
}

sub copy_to_all_selections {
    my $self = shift;
    my ($input) = @_;
    foreach my $sel ($self->all_selections) {
        $self->copy_to_selection($sel, $input);
    }
    return;
}

sub copy_to_selection {
    my $self = shift;
    my ($selection, $input) = @_;

    my @cmd_parts = qw(| wl-copy);
    push(@cmd_parts, '--primary') if ($selection eq 'primary');
    my $cmd = join(' ', @cmd_parts);
    my $r = open my $exe, $cmd or die "Couldn't run `$cmd`: $!\n";
    binmode $exe, ':encoding(UTF-8)';
    print {$exe} $input;
    close $exe or die "Error closing `$cmd`: $!";

    return;
}
sub paste {
    my $self = shift;
    for ($self->all_selections) {
        my $data = $self->paste_from_selection($_);
        return $data if length $data;
    }
    return undef;
}
sub paste_from_selection {
    my $self = shift;
    my ($selection) = @_;

    my @cmd_parts = qw(wl-paste --no-newline);
    push(@cmd_parts, '--primary') if ($selection eq 'primary');
    push(@cmd_parts, '|');
    my $cmd = join(' ', @cmd_parts);
    open my $exe, $cmd or die "Couldn't run `$cmd`: $!\n";
    my $result = do { local $/; <$exe> };
    close $exe or die "Error closing `$cmd`: $!";
    return $result;
}
# "regular" isn't directly used in this code (it is the wl-clipboard default)
sub all_selections { qw( regular primary ) }
sub favorite_selection { my $self = shift; ($self->all_selections)[0] }

sub available {
    # close STDERR
    open my $olderr, '>&', \*STDERR;
    close STDERR;
    open STDERR, '>', File::Spec->devnull;

    my $open_retval = open my $just_checking, 'wl-copy --version |';

    # restore STDERR
    close STDERR;
    open STDERR, '>&', $olderr;
    close $olderr;

    return $open_retval;
}

{
  available() or warn <<'EPIGRAPH';

Can't find the 'wl-copy' program from the wl‐clipboard package.

Clipboard.pm's Wayland support depends on it.

Here's the project homepage: https://github.com/bugaevc/wl-clipboard

EPIGRAPH
}

1;
