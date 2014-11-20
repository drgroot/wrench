#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;

my %srcds_list = ();
my $startScript = "";

# get list of folders
opendir(DIR,".",) or die $!;
while( my $file = readdir(DIR) ){
	next unless (-d "$file");
	next if($file =~ m/^\./);
	next if ($file eq "master" || $file eq "config");
	next unless (-e "$file/wrench.config");
	$srcds_list{$file} = 1;
}
closedir(DIR);
#print Dumper(\%srcds_list);

GetOptions(
	 "start=s"	=> \&start
	,"status=s" => \&status
	,"list"		=> \&list
);

sub start{
	my $srcds = $_[1];
	if( $srcds eq "all" ){

	}
	else{

		return unless exists ( $srcds_list{$srcds} );
		makeStartScript($srcds);
	}
}

sub status{
	my $srcds = $_[1];
	return unless exists ( $srcds_list{$srcds} );
}

sub list{

}

sub makeStartScript{
	my $srcds = $_[0];
	$startScript = "./$srcds/srcds_run -game tf ";

	open(INFO, "$srcds/wrench.config") or die("Could not open file.");
	foreach my $line (<INFO>){
		$line =~ s/\n//g;
		my ( $flag, $value ) = split(":", $line);
		
		if(! defined $value ){
			$startScript .= "-$flag ";
		}
		else{
			$startScript .= "+$flag $value ";
		}

	}
	close(INFO);
	`screen -dmS $srcds $startScript`;
}


