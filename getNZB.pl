#!/usr/bin/perl

use strict;
use warnings;

my $tempfile = "/tmp/output.xml";

print "Host: $ARGV[0]\n";
print "TempFile: $tempfile\n";

# system ("torify wget --no-check-certificate \"$ARGV[0]\" -O $tempfile");

my @links = ();
my @names =();
open FILE, '<', $tempfile or die "can't open $tempfile. $!\n";

while (my $zeile = <FILE>) {
	if ($zeile =~ /title/)
	{	
		print $zeile;
		push @names, $zeile;
	}
}
close FILE;





exit (0);
