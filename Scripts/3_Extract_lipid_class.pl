#!/usr/bin/perl

# Meeyoung Park, 04/07/2016
use warnings;
use strict;

#input gene files: symbol
my $baseDir = 'C:/Users/Meeyoung/Dropbox/HF11_LipidomicsStudy/HF11/Data_Preprocessing/';
my $outDir = 'C:/Users/Meeyoung/Dropbox/HF11_LipidomicsStudy/HF11/Data_Preprocessing/';

my @InFileNames	= glob ($baseDir."*_nonRedundant.txt");

foreach my $inFile (@InFileNames)
{

	my @tmp1 = split (/\//, $inFile);
	my @tmp2 = split (/\.txt/, $tmp1[$#tmp1]);
	my $tmpOutFile1	= $outDir."/".$tmp2[0]."_LipidClass.txt";

	open (OUTFILE, ">".$tmpOutFile1);
	open (INFILE, $inFile);
	print $inFile."\n";
	
	while(<INFILE>)
	{	
			my $lipid = "";
			my $class = "";
			my $carbon = "";
			my $chain = "";
			
			my $line = $_;
			$line =~ s/\r|\n//g;
			my @tmpSplit = split (/\t/, $line);
			my $lipid_name = $tmpSplit[0];
			
			#Remove Iternal standards
			if(index($lipid_name, "IS") >=0)
			{
				#Skip the line for internal standards
			}
			elsif ($lipid_name eq "Lipid")	#header
			{
				print OUTFILE "Class"."\t"."Carbon"."\t"."Saturation";
				    for (my $i=1; $i <= $#tmpSplit; $i++) {
						print OUTFILE "\t".$tmpSplit[$i];
					}				
			}
			else{
				my @lipid_info = split /[;,\@]+/, $lipid_name;
				$lipid = $lipid_info[0];
				$lipid =~ s/\r|\n//g;
				
				#Split chains in the lipid species
				if (index($lipid, "(") >=0)
				{
					my @carbon_info = split /[\(,:,\)]+/, $lipid;
					$class = $carbon_info[0];
					$class =~ s/\r|\n//g;
					$carbon = $carbon_info[1];
					$carbon =~ s/\r|\n//g;
					$chain = $carbon_info[2];
					$chain =~ s/\r|\n//g;
				}
				else
				{
					my @carbon_info = split /:/, $lipid;
					my $temp = $carbon_info[0];
					my @temp2 = split / /, $temp;
					$class = $temp2[0];
					$class =~ s/\r|\n//g;
					$carbon = $temp2[1];
					$carbon =~ s/\r|\n//g;
					$chain = $carbon_info[1];
					$chain =~ s/\r|\n//g;
				}			
				
				#$adduct = $lipid_info[1];
				#$adduct =~ s/\r|\n//g;
				#$rt = $lipid_info[2];
				#$rt =~ s/\r|\n//g;
				print OUTFILE $class."\t".$carbon."\t".$chain;
				    for (my $i=1; $i <= $#tmpSplit; $i++) {
						print OUTFILE "\t".$tmpSplit[$i];
					}
			}
			print OUTFILE "\n";
					
	}

	close INFILE;	
	close OUTFILE;
}