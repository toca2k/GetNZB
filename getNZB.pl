#!/usr/bin/perl

use strict;
use warnings;
use XML::RSS::Parser;
use FileHandle;


########### Get the RSS File #############
my $tempfile = "/tmp/output.xml";
my $nzbstore = "/root/nzb-archiv/";

print "Host: $ARGV[0]\n";
print "TempFile: $tempfile\n";
system ("torify wget --no-check-certificate \"$ARGV[0]\" -O $tempfile");

 ########### Process RSS File #############
my $p = XML::RSS::Parser->new;
my $fh = FileHandle->new($tempfile);
my $feed = $p->parse_file($fh);
 
my $feed_title = $feed->query('/channel/title');
print $feed_title->text_content;
my $count = $feed->item_count;
print " ($count)\n";

########### Get the NZBs #############
foreach my $i ( $feed->query('//item') ) { 
    my $title = $i->query('title');
    #print $title->text_content;
	my $link = $i->query('link');
    #print $link->text_content;
    print "\n==========Next file==========\n"; 
	
	if (-e $nzbstore.$title->text_content.".nzb") {
			print "Skipping file, already Exist: ".$nzbstore.$title->text_content.".nzb\n";
		} else {
			print "Downloading ...\n";
			system ("torify wget --no-check-certificate \"".$link->text_content."\" -O ".$nzbstore.$title->text_content.".nzb");
		}
}
exit (0);
