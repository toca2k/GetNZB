#!/usr/bin/perl

use strict;
use warnings;
use XML::RSS::Parser;
use FileHandle;


########### Check the environment and parameters #############
my $randomNum = int rand(10000);
my $tempfile = "/tmp/output".$randomNum.".xml";
my ($rssurl, $nzbstore) = @ARGV;

if (not defined $rssurl) {
	die "No RSS URL found, Syntax: $0 [RSS URL] [/path/to/nzb-store/]";	
} 
if (not defined $nzbstore) {
	die "No path to NZB Download Folder found, Syntax: $0 [RSS URL] [/path/to/nzb-store/]";
} else {
	if (not -d $nzbstore) { # Test if it's a directory
		die "No path to NZB Download Folder found, $nzbstore is not a directory: Syntax: $0 [RSS URL] [/path/to/nzb-store/]";
	}
}


########### Get the RSS File #############
print "RSS Url: $rssurl\n";
print "NZB Store: $nzbstore\n";
print "TempFile: $tempfile\n";
system ("wget --no-check-certificate \"$rssurl\" -O $tempfile");

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
#    print "Title: ".$title->text_content;
     my $link = $i->query('link');
#    print "Link:  ".$link->text_content;
    print "\n==========Next file==========\n"; 
	
	if (-e $nzbstore.$title->text_content.".nzb") {
			print "Skipping file, already Exist: ".$nzbstore.$title->text_content.".nzb\n";
		} else {
			print "Downloading ...\n";
			print "\n Debug :: \"".$nzbstore.$title->text_content.".nzb\"";
			system ("wget --no-check-certificate \"".$link->text_content."\" -O '".$nzbstore.$title->text_content.".nzb'");
		}
}
exit (0);
