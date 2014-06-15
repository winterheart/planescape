#!/usr/bin/perl

# TRAExtratror - extracts strings from WeiDU's TRA-files and converts them to 
# Gettext POT format.
# (c) 2014 Azamat H. Hackimov <azamat.hackimov@gmail.com>

use File::Find;
use File::Slurp;
use Locale::PO;
use Getopt::Long;
use POSIX qw/strftime/;

use strict;
use warnings;
use encoding 'utf8';

my %config;

GetOptions(\%config,
  'tra|t=s',
  'pot|p=s',
);

my $date = strftime('%Y-%m-%d %H:%M %z',localtime);

my @pot;
my %hash;
my $text = read_file($config{tra});
my $total = 0;

# Цикл, который выцеживает сообщения по-отдельности
# Ключевой момент - поиск ленивый (.*?)
# В TRA в качестве кавычек может выступать ~ и "
# Четыре группы захвата
# 1. номер записи
# 2. кавычка (~ или ")
# 3. Содержимое - запись
# 4. Остаток (ссылка на звуковой файл)
while ($text =~ m/@(.+?)\s*=\s*(["~])(?:\2|(.*?))\2(.*?)\n/sg) {
	my ($position, $entry, $ending) = ($1, $3, $4);
	$position =~ s/\s*//g;
	# Есть 'плохой' элемент - '\', меняем на экранирование
#	$entry =~ s/\\/\\\\/g;
	# убираем CR-символы
	$entry =~ s/\r\r\n/\r\n/g;
	# Есть и табуляции
	$entry =~ s/\t/\\t/g;
	# Обрабатываем строку - заменяем перенос на '\n'
	$entry =~ s/\r\n/\\n/g;
	$hash{$position} = $entry;
	if ($entry ne "") {
		$total++;
	}
}

$pot[0] = new Locale::PO(-fuzzy=>'1', -msgid=>'', -msgstr=>
	"Project-Id-Version: PACKAGE VERSION\\n" .
	"POT-Creation-Date: $date\\n" .
	"PO-Revision-Date: YEAR-MO-DA HO:MI +ZONE\\n" .
	"Last-Translator: FULL NAME <EMAIL\@ADDRESS>\\n" .
	"Language-Team: LANGUAGE <LL\@li.org>\\n" .
	"MIME-Version: 1.0\\n" .
	"Content-Type: text/plain; charset=CHARSET\\n" .
	"Content-Transfer-Encoding: ENCODING\\n");

foreach my $position (sort keys %hash) {
	push(@pot, new Locale::PO(-msgid=>$hash{$position}, -msgstr=>"", -reference=>"$position"));
}

print "Total entries proceded: $total\n";
Locale::PO->save_file_fromarray($config{pot}, \@pot);
system("msguniq", $config{pot}, "-o", $config{pot});
