#!/usr/bin/perl
use strict;
use warnings;
use File::Basename qw(dirname basename);
use File::Path qw(make_path);
use List::Util qw(pairmap);

# Creates intl file from property files and dtd files in ../chrome/content/locale/
#
# https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Internationalization#Internationalizing_manifest.json


my $json = <<'EOS';
{
%s
}
EOS
my $json_entry = '  "%s": { "message": "%s" }';

main() if __FILE__ eq $0;

sub main {
    my $dir = dirname __FILE__;
    my $localedirs = "$dir/../chrome/locale/*/*";

    for my $localedir (glob $localedirs) {
        my ($prop) = glob "$localedir/*.properties";
        my ($dtd) = glob "$localedir/*.dtd";

        my @entries = pairmap { sprintf $json_entry, $a, $b } (load_properties($prop), load_dtd($dtd));
        my $body = join ",\n", sort @entries;

        my $lang = basename dirname dirname $prop;
        $lang =~ tr/-/_/;
        my $out = "$dir/$lang/messages.json";
        make_path dirname $out;
        write_json($out, $body);

        print "$out\n";
    }
}

sub write_json {
    my ($destpath, $desc) = @_;

    open my $f, '>utf8', $destpath;
    printf $f $json, $desc;
}

sub load_properties {
    (slurp($_[0]) =~ /^ ([^=\r\n]*) \s* = \s* ([^\r\n]*)/gmx)
}

sub load_dtd {
    (slurp($_[0]) =~ /^ [^\r\n"]* \s ([^\s\r\n"]+) \s* "(.*)"> \s* $/gmx)
}

sub slurp {
    my ($path) = @_;

    open my $f, '<:encoding(utf8)', $path;
    local $/;
    readline $f;
}
