#!/usr/bin/perl -w

#
# Usage:
# ./find-seqmotif.pl  (fasta file) (motif sequence)
# 
# fasta file     : The file should contain one nucleotide reference sequence.
# motif sequence : The short motif sequence is defined.
#                  The sequence can be defined with the letters "A", "T(not U)", "G", "C", as well as "Y", "R", "N".
#
# The script outputs positions of 5'-end nucleotides of the identified regions carring the defined motif.
# In addition, the script outputs sequences at the identified regions, with extra information on two flanking nucleotides at each of 5'- and 3'-ends.
#
#
# Example)
# ./find-seqmotif.pl EColi_BL21DE3.fasta YACCCGGY > output1.csv
# ./find-seqmotif.pl EColi_BL21DE3.fasta YYRCCGGGT > output2.csv
#

use strict;

my $ref = "";
my $file = shift; 
my $seq  = shift;

open FILE, "$file";
while(<FILE>){
  s/^\s+//;
  s/\s+$//;
  my $line = $_;
 
  if(/^\>/){ ; }
  else{
    $ref = $ref . $line;
  }
}
close FILE;

my @ref = split //, $ref;

my %ref;
for(my $i = 0; $i <= $#ref - length($seq) + 1; $i++){
  $ref{$i} = "";
  for(my $j = 0; $j < length($seq); $j++){
    $ref{$i} = $ref{$i} . $ref[$i+$j];
  }
}

my @s = split //, $seq;
printf "%s\n", $seq;
for(my $i = 0; $i <= $#ref - length($seq) + 1; $i++){
  my @r = split //, $ref{$i};
  my $flag = 0;
  for(my $j = 0; $j <= $#r; $j++){
    if($r[$j] eq "A"){
      if($s[$j] eq "A" ){ ; }
      elsif($s[$j] eq "R" ){ ; }
      elsif($s[$j] eq "N" ){ ; }
      else              { $flag++; last; }
    }
    if($r[$j] eq "G"){
      if($s[$j] eq "G" ){ ; }
      elsif($s[$j] eq "R" ){ ; }
      elsif($s[$j] eq "N" ){ ; }
      else              { $flag++; last; }
    }
    if($r[$j] eq "C"){
      if($s[$j] eq "C" ){ ; }
      elsif($s[$j] eq "Y" ){ ; }
      elsif($s[$j] eq "N" ){ ; }
      else              { $flag++; last; }
    }
    if($r[$j] eq "T"){
      if($s[$j] eq "T" ){ ; }
      elsif($s[$j] eq "Y" ){ ; }
      elsif($s[$j] eq "N" ){ ; }
      else              { $flag++; last; }
    }
  }
  if($flag == 0){ printf "%d,%s%s%s%s%s\n", $i+1,$ref[$i-2], $ref[$i-1], $ref{$i},$ref[$i+ length($seq)], $ref[$i + length($seq) +1]; }
}

