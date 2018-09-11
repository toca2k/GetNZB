#!/usr/bin/perl

use strict;
use warnings;

system ("torify", "wget --no-check-certificate " $ARGV[1] " -O /tmp/output.xml");
 