#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

my %srcds_list = ();
my $startScript = "";

# get list of folders
opendir(DIR,".",) or die $!;
while( my $file = readdir(DIR) ){
	next unless (-d "$file");
	next if($file =~ m/^\./);
	next if ($file eq "master" || $file eq "copy" || $file eq "all");
	next unless (-e "$file/wrench.config");
	$srcds_list{$file} = 1;
}
closedir(DIR);

GetOptions(
	 "start=s"	=> \&start
	,"status=s" => \&status
	,"list"		=> \&list
	,"daily"	=> \&daily_scripts
);

sub daily_scripts{
	# clean log files
	foreach my $srcds ( keys %srcds_list ){
		system("find $srcds/tf/logs/ -mtime +2 -delete") >> 8 and print "Couldn't clean logs: $?\n";
		system("find $srcds/tf/addons/sourcemod/logs/ -mtime +2 -delete") >> 8 and print "Couldn't clean sourcemod logs: $?\n";
	}

	# update sourcemod
	system("cd master/tf2/tf; git pull origin master") >> 8 and print "Couldn't update Sourcemod: $?\n";
}

sub start{
	my $srcds = $_[1];
	if( $srcds eq "all" ){
		foreach $srcds (keys %srcds_list){
			next if $srcds eq "test";
			next if isRunning($srcds);
			makeStartScript($srcds);
		}
	}
	else{
		return unless exists ( $srcds_list{$srcds} );
		return if isRunning($srcds);
		makeStartScript($srcds);
	}
}

sub status{
	my $srcds = $_[1];
	return unless exists ( $srcds_list{$srcds} );
	if(isRunning($srcds)){
		print "Server: $srcds is already running\n";
	}
	else{
		print "Server: $srcds is not running\n";	
	}
}

sub list{
	foreach my $srcds (keys %srcds_list){
		status(0,$srcds);
	}
}

sub isRunning{
	my $srcds = $_[0];
	my $screens = `screen -ls`;
	if ($screens =~ m/\.$srcds\s+/){
		return 1;
	}

	return 0;
}

sub makeStartScript{
	my $srcds = $_[0];
	$startScript = "./$srcds/srcds_run -game tf ";

	open(INFO, "$srcds/wrench.config") or die("Could not open file.");
	foreach my $line (<INFO>){
		$line =~ s/\n//g;
		my ( $flag, $value ) = split(":", $line);
		
		if(! defined $value ){
			$startScript .= "$flag ";
		}
		else{
			$startScript .= "$flag $value ";
		}

	}
	close(INFO);
	`screen -dmS $srcds $startScript`;
}


