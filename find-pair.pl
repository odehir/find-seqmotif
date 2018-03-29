#!/usr/bin/perl -w

#
# Usage:
# ./find-pair.pl  (output1) (output2)
# 
# output1/output2 : These are outputs of "find-seqmotif.pl" with two distinct motif sequences
#
# The script automatically sorts positions of the identified regions within the two files.
# In addition, it highlights positions of pair sequences within <100 bp.
#
#  Example)
# ./find-pair.pl output1.csv output2.csv > output12.csv
#

use strict;

my $file1 = shift; 
my $file2 = shift; 

my $flag = 0;
my $data;
open FILE1, "$file1";
while(<FILE1>){
  s/^\s+//;
  s/\s+$//;
  my $line = $_;

  if($flag == 0){ 
    $flag++;
    printf "%s, , ,", $line;
  }else{
    my @tmp = split /\,/, $line;
    $data->{$tmp[0]}->{l} = 1;
    $data->{$tmp[0]}->{s} = $tmp[1];
  }
}
close FILE1;

$flag = 0;
open FILE2, "$file2";
while(<FILE2>){
  s/^\s+//;
  s/\s+$//;
  my $line = $_;

  if($flag == 0){ 
    $flag++;
    printf "%s, ,\n", $line;
  }else{
    my @tmp = split /\,/, $line;
    $data->{$tmp[0]}->{l} = 2;
    $data->{$tmp[0]}->{s} = $tmp[1];
  }
}
close FILE2;

my $pre = 0;
my $prel = 0;
foreach my $i (sort {$main::a <=> $main::b} keys %{$data}){
  if($data->{$i}->{l} == 1){
    printf "%d, %s, , , ,", $i, $data->{$i}->{s};
  }else{
    printf " , , , %d, %s,", $i, $data->{$i}->{s};
  }
  if(($i - $pre < 100) && ($prel != $data->{$i}->{l})){
    printf " %d,\n", $i - $pre;
  }else{
    printf " ,\n";
  }
  $pre = $i;
  $prel = $data->{$i}->{l};
}
 


