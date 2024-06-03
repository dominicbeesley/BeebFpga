#!/usr/bin/env perl

use strict;

# makemi - convert a binary file to a .mi file for Gowin memory tools
# data should be byte aligned right, little endian

use strict;

sub Usage {
	my ($msg, $exit) = @_;

	my $fh = ($exit)?*STDERR:*STDOUT;

	print $fh "
makemi.pl [options] <binary file>

options:
	--width <n> width in BITS for the data, default 8 bits
";

	if ($msg) {
		print $fh "$msg\n";
	}

	if ($exit) {
		exit $exit;
	}
}

##############################################################################
#################################### main ####################################
##############################################################################

my $width=8;

while (scalar @ARGV && $ARGV[0] =~ /^-/) {

	my $sw = shift;

	if ($sw =~ /^-(-?)h/)
	{
		Usage();
		exit 0;
	}
	elsif ($sw eq "--width") 
	{
		$width = shift;
		$width or die "Bad width";
	}
	else {
		die Usage("unknown switch $sw", 1);
	}
	
}

if (scalar @ARGV != 1) {
	Usage ("incorrect number of arguments", 1)
}

my $fn_in = shift;
my $content;
open (my $fh_in, "<:raw:", $fn_in) or Usage "Cannot open input file \"$fn_in\" : $!";
{ local $/; $content = <$fh_in>;}
close $fh_in;

my $nbytes = int(($width + 7) / 8);
my $depth = int(length($content) / $nbytes);

((length($content) % $nbytes) == 0) or die "bad data alignment file is not a multiple of $nbytes bytes.";

print "#File_format=Bin
#Address_depth=$depth
#Data_width=$width
";

my $i = 0;
while ($i < length($content)) {
	my $b = $nbytes * 8;
	for (my $j = $nbytes - 1; $j >= 0; $j--) {
		my $c = ord(substr($content, $i + $j, 1));
		my $m = 0x80;
		while ($m) {
			$b = $b - 1;
			if ($b < $width) {
				print (($c & $m)?"1":"0");
			} else {
				print "$b";
			}
			$m = $m >> 1;
		}
	}
	$i += $nbytes;
	print "\n";
}