#!/usr/bin/perl

=head1 NAME

Ltr2GFF.pl - Convert LTR-Finder result (.ltr) to standard GFF3 format

=head1 SYNOPSIS

  perl Ltr2GFF.pl input.ltr

  Output: input.ltr.gff

=head1 DESCRIPTION

This script parses the tab-delimited output of LTR-Finder (lines starting with "[")
and converts each predicted LTR retrotransposon into a GFF3 feature.

=cut

use strict;
use warnings;
use File::Basename qw(basename);

# Check input
die "Usage: perl $0 <LTR-Finder_output.ltr>\n" unless @ARGV == 1;

my $input_ltr = shift;
my $output_gff = basename($input_ltr) . ".gff";

# Open files
open my $in, '<', $input_ltr or die "Cannot open input file '$input_ltr': $!\n";
open my $out, '>', $output_gff or die "Cannot write to output file '$output_gff': $!\n";

# Print GFF header (optional but good practice)
print $out "##gff-version 3\n";

my $count = 0;
while (my $line = <$in>) {
    chomp $line;
    next unless $line =~ /^\[/;  # Only process lines starting with "["

    my @fields = split /\t/, $line;
    
    # Parse LTR ID from first column: e.g., "[ 1 ]" -> 1
    my ($id_num) = $fields[0] =~ /\[\s*(\d+)\s*\]/;
    next unless defined $id_num;

    # Chromosome/scaffold name
    my $seqid = $fields[1] // 'unknown';

    # Parse genomic range: e.g., "1000-2500"
    my ($start, $end) = ($fields[2] =~ /(\d+)-(\d+)/);
    next unless defined $start && defined $end;

    # Ensure start <= end (GFF requirement)
    if ($start > $end) {
        ($start, $end) = ($end, $start);
    }

    # Strand is in the 4th field from the end (index -4)
    my $strand = (@fields >= 4) ? $fields[-4] : '.';
    $strand = ($strand eq '+' || $strand eq '-') ? $strand : '.';

    # Build unique ID
    my $feature_id = "${seqid}_${id_num}_ltr";

    # Output GFF3 line
    print $out join("\t",
        $seqid,
        "LTR_Finder",
        "LTR_retrotransposon",
        $start,
        $end,
        '.',   # score
        $strand,
        '.',   # phase
        "ID=$feature_id;"
    ) . "\n";

    $count++;
}

close $in;
close $out;

print STDERR "Converted $count LTR predictions to '$output_gff'\n";
exit 0;

