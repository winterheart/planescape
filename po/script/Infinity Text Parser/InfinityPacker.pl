#!/usr/bin/perl

use File::Read;
use Locale::PO;
use Getopt::Long;

use strict;
use warnings;

my %config;
GetOptions(\%config,
	'tra|t=s',
	'input|i=s' );

my $output;
my %hash;

my $text = read_file($config{tra});

# Цикл, который выцеживает сообщения по-отдельности
# Ключевой момент - поиск ленивый (.*?)
while ($text =~ m/\@(\d+)\s*\=\s*~(.*?)~(.*?)\n/sg) {
	my ($position, $entry, $ending) = ($1, $2, $3);
	# Есть 'плохой' элемент - '\', меняем на экранирование
	$entry =~ s/\\/\\\\/g;
	# убираем CR-символы
	$entry =~ s/\r\r\n/\n/g;
	# Есть и табуляции
	$entry =~ s/\t/\\t/g;
	# Обрабатываем строку - заменяем перенос на '\n'
	$entry =~ s/\n/\\n/g;
	$hash{$position} = [$entry, $ending];
}

my @files = <$config{input}/*.po>;

foreach my $file (@files) {
	my $po_entries = Locale::PO->load_file_asarray($file) || die "Can't open file";

	# Заголовок нам не нужен
	shift @{$po_entries};

	# В этом цикле все переведенные строки из po-каталога заменяют оригинальные из хеша
	# при этом используются адреса strref как ссылки для принятия соответсвия
	foreach my $item ( @{$po_entries} ) {
		my $string = Locale::PO->dequote($item->msgstr());
		unless (($string eq "") || $item->fuzzy()) {			
			my @referencies = split(/[ |\n]/, $item->reference());
			foreach my $reference (@referencies) {				
				$hash{$reference}[0] = $string;
			}
		}
	} 
}


# Формируем заново строки
foreach my $item (sort {$a<=>$b} keys %hash) {
	if ($hash{$item}[0]) {
		$hash{$item}[0] =~ s/\\n/\n/sg;
		$hash{$item}[0] =~ s/\\t/\t/sg;
		$hash{$item}[0] =~ s/\\\\/\\/sg;
	}
	$output.="\@".$item." = ~".$hash{$item}[0]."~".$hash{$item}[1]."\n";
}


open(TEXT,">", "$config{tra}");
print TEXT $output;
close(TEXT);
