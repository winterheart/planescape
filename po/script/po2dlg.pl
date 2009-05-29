#!/usr/bin/perl

use File::Read;
use Locale::PO;
use Getopt::Long;

use strict;
use warnings;

my %config;

GetOptions(\%config,
  'dlg|d=s',
  'po|p=s',
  'output|o=s' );


my $text = read_file($config{dlg});
my $po_entries = Locale::PO->load_file_ashash($config{po}) || die "Can't open file";

my $po = new Locale::PO();

my $output;

# Цикл, который выцеживает сообщения по-отдельности
# Ключевой момент - поиск ленивый (.*?)
while ($text =~ m/(\@\d+\s*\=\s*)~(.*?)~(.*?)\n/sg) {
  my ($position, $entry, $ending) = ($1, $2, $3);
  # Есть 'плохой' элемент - '\', меняем на экранирование
  $entry =~ s/\\/\\\\/g;
  # убираем CR-символы
  $entry =~ s/\r\r\n/\n/g;
  # Есть и табуляции
  $entry =~ s/\t/\\t/g;
  # Обрабатываем строку - заменяем перенос на '\n'
  $entry =~ s/\n/\\n/g;
  my $translated = '';
  if ($entry ne '') {
    my $po = new Locale::PO();
    $po = Locale::PO->dequote(%{$po_entries}->{Locale::PO->quote($entry)});
    unless ($po->fuzzy()) {
      $translated = Locale::PO->dequote($po->msgstr());
    }
  }
  if ($translated ne '') {
    $entry = $translated;
  }
  $entry =~ s/\\n/\n/sg;
  $entry =~ s/\\t/\t/sg;
#  $entry =~ s/\n/\r\r\n/sg;
  $entry =~ s/\\\\/\\/sg;

  $output.="$position~$entry~$ending\n";

}
open(TEXT,">", "$config{output}");
print TEXT $output;

