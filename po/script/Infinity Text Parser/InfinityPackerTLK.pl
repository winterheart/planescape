#!/usr/bin/perl

use File::Find;
use File::Slurp;
use Locale::PO;
use Getopt::Long;
use Encode;

use strict;
use warnings;

my %config;
GetOptions(\%config,
	'tlk|t=s',
	'input|i=s',
	'output|o=s');

my @files;

my %translated;
my $total = 0;

my $tlk;
my $new_tlk;
my $buffer;
my @entries;



sub wanted {
	if (m/.*\.po$/) {
		push(@files, $File::Find::name);
	}
}

find(\&wanted, $config{input});


open($tlk, "<", $config{tlk}) || die "Can't open TLK-file: $!\n";
read($tlk, $buffer, 8);
if ($buffer ne 'TLK V1  ') {
	die "$config{tlk} is not TLK-file version 1\n";
}

read($tlk, my $lang_id, 2);
read($tlk, $buffer, 4);
my $strref_count = unpack("L", $buffer);
read($tlk, my $string_offset, 4);

for (my $i = 0; $i < $strref_count; $i++) {
	read($tlk, $entries[$i]{tag}, 2);
	read($tlk, $entries[$i]{sound}, 8);
	read($tlk, $entries[$i]{volume}, 4);
	read($tlk, $entries[$i]{pitch}, 4);
	read($tlk, $entries[$i]{string_offset}, 4);
	read($tlk, $entries[$i]{string_length}, 4);
}

for (my $i = 0; $i < $strref_count; $i++) {
	read($tlk, $entries[$i]{string}, unpack("L", $entries[$i]{string_length}));
	if (unpack("L", $entries[$i]{string_length}) != 0) {
		$total++;
	}
}
close($tlk);

foreach my $file (@files) {
	my $po_entries = Locale::PO->load_file_asarray($file) || die "Can't open file";

	# Заголовок нам не нужен
	shift @{$po_entries};

	# В этом цикле все переведенные строки из po-каталога заменяют оригинальные из хеша
	# при этом используются адреса strref как ссылки для принятия соответствия
	# Пустые строки, неточные и устаревшие переводы не учитываются
	foreach my $item ( @{$po_entries} ) {
		my $string = Locale::PO->dequote($item->msgstr());
		unless (($string eq "") || $item->fuzzy() || $item->obsolete()) {
			my $test = $item -> reference();
			my @referencies = split(/[ |\n]/, $item->reference());
			foreach my $reference (@referencies) {
				# Если строка есть в исходном TLK
				if ($entries[$reference]) {
					$entries[$reference]{string} = $string;
					$entries[$reference]{string_length} = pack("L", length($string));
					
					#pack("L", length(Encode::encode_utf8($string)));
					# Делаем зарубку по адресу strref
					$translated{$reference} = 1;
				}
			}
		}
	} 
}
my $current_offset = 0;
for (my $i = 0; $i < $strref_count; $i++) {
	$entries[$i]{string_offset} = pack("L", $current_offset);
	$current_offset += length($entries[$i]{string}); #length(Encode::encode_utf8($entries[$i]{string}));
}

open($new_tlk, ">:raw", $config{output}) || die "Cannot write TLK-file: $!\n";
print $new_tlk 'TLK V1  ';
print $new_tlk $lang_id;
print $new_tlk pack("L", $strref_count);
print $new_tlk $string_offset;



for (my $i = 0; $i < $strref_count; $i++) {
	print $new_tlk $entries[$i]{tag};
        print $new_tlk $entries[$i]{sound};
        print $new_tlk $entries[$i]{volume};
        print $new_tlk $entries[$i]{pitch};
        print $new_tlk $entries[$i]{string_offset};
        print $new_tlk $entries[$i]{string_length};
}

for (my $i = 0; $i < $strref_count; $i++) {
	print $new_tlk $entries[$i]{string};
}



close($new_tlk);

# Считаем количество реально замененных строк
my $non_empty = keys %translated;

printf ("Translated:\t%d\nTotal:\t\t%d\nPercent:\t%.2f\n", $non_empty, $total, $non_empty/$total*100);

