#!/usr/bin/perl

use File::Find;
use File::Slurp;
use Locale::PO;
use Getopt::Long;

use strict;
use warnings;
use encoding 'utf8';

my %config;
GetOptions(\%config,
	'tra|t=s',
	'input|i=s',
	'output|o=s');

my $output;
my %hash;
my @files;

my %translated;
my $total = 0;

my $text = read_file($config{tra});

# Цикл, который выцеживает сообщения по-отдельности
# Ключевой момент - поиск ленивый (.*?)
# Четыре группы захвата
# 1. номер записи
# 2. кавычка (~ или ")
# 3. Содержимое - запись
# 4. Остаток (ссылка на звуковой файл)
while ($text =~ m/@(.+?)\s*=\s*(["~])(?:\2|(.*?))\2(.*?)\n/sg) {
	my ($position, $entry, $ending) = ($1, $3, $4);
	# Есть 'плохой' элемент - '\', меняем на экранирование
	$entry =~ s/\\/\\\\/g;
	# убираем CR-символы
	$entry =~ s/\r\r\n/\n/g;
	# Есть и табуляции
	$entry =~ s/\t/\\t/g;
	# Обрабатываем строку - заменяем перенос на '\n'
	$entry =~ s/\n/\\n/g;
	$hash{$position} = [$entry, $ending];
	if ($entry ne "") {
		$total++;
	}
}

sub wanted {
	if (m/.*\.po$/) {
		push(@files, $File::Find::name);
	}
}

find(\&wanted, $config{input});

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
				# Если строка есть в исходном TRA
				if ($hash{$reference}) {
					$hash{$reference}[0] = $string;
					# Делаем зарубку по адресу strref
					$translated{$reference} = 1;
				}
			}
		}
	} 
}

# Считаем количество реально замененных строк
my $non_empty = keys %translated;

printf ("Translated:\t%d\nTotal:\t\t%d\nPercent:\t%.2f\n", $non_empty, $total, $non_empty/$total*100);

# Формируем заново строки
foreach my $item (sort {$a<=>$b} keys %hash) {
	if ($hash{$item}[0]) {
		$hash{$item}[0] =~ s/\\n/\n/sg;
		$hash{$item}[0] =~ s/\\t/\t/sg;
		$hash{$item}[0] =~ s/\\\\/\\/sg;
	}
	$output.="\@".$item." = ~".$hash{$item}[0]."~".$hash{$item}[1]."\n";
}


open(TEXT,">:utf8", "$config{output}") || die "$!";
print TEXT $output;
close(TEXT);
