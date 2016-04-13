#!/usr/bin/perl

# Meeyoung Park, 04/07/2016
use warnings;
use strict;

#input gene files: symbol
my $inDir = 'C:/Users/Meeyoung/Dropbox/HF11_LipidomicsStudy/HF11/Data_Preprocessing/';
my $outDir = 'C:/Users/Meeyoung/Dropbox/HF11_LipidomicsStudy/HF11/Data_Preprocessing/';

my @InFileNames	= glob ($inDir."*.txt");

foreach my $inFile (@InFileNames)
{

	my @tmp1 = split (/\//, $inFile);
	my @tmp2 = split (/\.txt/, $tmp1[$#tmp1]);
	my $tmpOutFile1	= $outDir."/".$tmp2[0]."_LipidSeparated.txt";

	open (OUTFILE, ">".$tmpOutFile1);
	open (INFILE, $inFile);
	print $inFile."\n";
	
	while(<INFILE>)
	{	
			my $lipid = "";
			my $adduct = "";
			my $rt = "";
			
			my $line = $_;
			$line =~ s/\r|\n//g;
			my @tmpSplit = split (/\t/, $line);
			my $lipid_name = $tmpSplit[0];
			
			#Remove Iternal standards
			if(index($lipid_name, "IS") >=0)
			{
				#Skip the line for internal standards
			}
			elsif ($lipid_name eq "Name")	#header
			{
				print OUTFILE "Lipid"."\t"."Adduct"."\t"."RT";
				    for (my $i=1; $i <= $#tmpSplit; $i++) {
						print OUTFILE "\t".$tmpSplit[$i];
					}				
			}
			else{
				#redundant check!
				my @lipid_info = split /[;,\@]+/, $lipid_name;
				$lipid = $lipid_info[0];
				$lipid =~ s/\r|\n//g;				
				$adduct = $lipid_info[1];
				$adduct =~ s/\r|\n//g;
				$rt = $lipid_info[2];
				$rt =~ s/\r|\n//g;
				print OUTFILE $lipid."\t".$adduct."\t".$rt;
				    for (my $i=1; $i <= $#tmpSplit; $i++) {
						print OUTFILE "\t".$tmpSplit[$i];
					}
			}
			print OUTFILE "\n";
		
					
	}
	print "Complete!";
	close INFILE;	
	close OUTFILE;
}