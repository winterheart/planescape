#!/usr/bin/perl

use File::Read;
use Locale::PO;
use Getopt::Long;

use strict;
use warnings;

my %config;

GetOptions(\%config,
  'input|i=s',
  'output|o=s' );

my @po;

# Заголовок
$po[0] = new Locale::PO(-fuzzy=>'1', -msgid=>'', -msgstr=>
	"Project-Id-Version: PACKAGE VERSION\\n" .
	"PO-Revision-Date: YEAR-MO-DA HO:MI +ZONE\\n" .
	"Last-Translator: FULL NAME <EMAIL\@ADDRESS>\\n" .
	"Language-Team: LANGUAGE <LL\@li.org>\\n" .
	"MIME-Version: 1.0\\n" .
	"Content-Type: text/plain; charset=CHARSET\\n" .
	"Content-Transfer-Encoding: ENCODING\\n");

my @po_entries;

my $text = read_file($config{input}) or 
  die "Cannot open input file $config{input}: $!";

my $i = 1;

# Цикл, который выцеживает сообщения по-отдельности
# Ключевой момент - поиск ленивый (.*?)
while ($text =~ m/\@(\d+)\s*\=\s*~(.*?)~/sg) {
  my ($position, $entry) = ($1, $2);
  # Добавляем только непустые строки
  if ($entry ne '' ) {
    # Есть 'плохой' элемент - '\', меняем на экранирование
    $entry =~ s/\\/\\\\/g;
    # убираем CR-символы
#    $entry =~ s/\r\r\n/\n/g;
    # Обрабатываем строку - заменяем перенос на '\n'
    $entry =~ s/\n/\\n/g;
    $po[$i] = new Locale::PO(-msgid=>$entry, -msgstr=>"", -reference=>"$config{input}:$position");
    #print "$position: $entry\n";
    $i++;
  }
}

Locale::PO->save_file_fromarray($config{output},\@po) or 
  die "Cannot save output file $config{output}: $!";

system("msguniq", "$config{output}", "-o", "$config{output}");

