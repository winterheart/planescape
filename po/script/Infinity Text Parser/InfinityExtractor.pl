#!/usr/bin/perl -w

use InfinityParser::TLK;
use InfinityParser::AREA;
use InfinityParser::CHUI;
use InfinityParser::CRE;
use InfinityParser::DLG;
use InfinityParser::ITM;
use InfinityParser::SPL;
use InfinityParser::SRC;
use InfinityParser::STOR;
use InfinityParser::WMAP;

use Locale::PO;
use Getopt::Long;
use Switch;
use POSIX qw/strftime/;

my %config;

GetOptions(\%config,
  'tlk|t=s',
  'directory|d=s',
  'output|o=s',
);

my $date = strftime('%Y-%m-%d %H:%M %z',localtime);

my $tlk =  InfinityParser::TLK->new();
$tlk->open($config{tlk});
my $max_string = $tlk->maxstring();

@files = <$config{directory}/*>;

my @po;
my @po_entries;
my $src;
 
foreach $file (@files) {
	$file =~ m/(\w+\..*)$/;
	my $filename = $1;
	if ($file =~ m/\.(SRC|src)$/ ) {
		$src = InfinityParser::SRC->new();
	} else {		
		open(FILE,"<", $file);
		read(FILE, my $buffer, 4);
		switch ($buffer) {
			case "AREA" { $src = InfinityParser::AREA->new(); }
			case "CHUI" { $src = InfinityParser::CHUI->new(); }
			case "CRE " { $src = InfinityParser::CRE->new(); }
			case "DLG " { $src = InfinityParser::DLG->new(); }
			case "ITM " { $src = InfinityParser::ITM->new(); }
			case "SPL " { $src = InfinityParser::SPL->new(); }
			case "STOR" { $src = InfinityParser::STOR->new(); }
			case "WMAP" { $src = InfinityParser::WMAP->new(); }
			else { print "Unknown type found! $file\n"; }
		}
	}
	$src->open($file);
	@str = $src->strref();
	my %hashTemp = map { $_ => 1 } @str;
	@str = sort keys %hashTemp;

	$po[0] = new Locale::PO(-fuzzy=>'1', -msgid=>'', -msgstr=>
		"Project-Id-Version: PACKAGE VERSION\\n" .
		"POT-Creation-Date: $date\\n" .
		"PO-Revision-Date: YEAR-MO-DA HO:MI +ZONE\\n" .
		"Last-Translator: FULL NAME <EMAIL\@ADDRESS>\\n" .
		"Language-Team: LANGUAGE <LL\@li.org>\\n" .
		"MIME-Version: 1.0\\n" .
		"Content-Type: text/plain; charset=CHARSET\\n" .
		"Content-Transfer-Encoding: ENCODING\\n");

	foreach my $i (@str) {
		my ($string, undef, undef, undef) = $tlk->strref($i);
		if ($string ne "") {
			$string =~ s/\\/\\\\/g;
			$string =~ s/\r//g;
			$string =~ s/\n/\\n/g;
			# Странно, но ноль не может подставляться. Bug.
			if ($i != 0) {
				push(@po, new Locale::PO(-msgid=>"$string", -msgstr=>"", -reference=>"$i"));
			} else {
				push(@po, new Locale::PO(-msgid=>"$string", -msgstr=>"", -reference=>"0 "));
			}
		}
	}
	push(@all, @str);
	Locale::PO->save_file_fromarray($config{output}."/$filename.pot", \@po);
	@po = ();
	@po_entries= (); 
	system("msguniq", $config{output}."/$filename.pot", "-o", $config{output}."/$filename.pot");
} 

%hashTemp = map { $_ => 1 } @all;
#@all = sort keys %hashTemp;

#print %hashTemp;
for (my $i=0; $i<=$max_string; $i++) {
    unless ($hashTemp{$i}) {
        # it's not in %seen, so add to @aonly
        push(@rest, $i);
    }
}

$po[0] = new Locale::PO(-fuzzy=>'1', -msgid=>'', -msgstr=>
	"Project-Id-Version: PACKAGE VERSION\\n" .
	"POT-Creation-Date: $date\\n" .	
	"PO-Revision-Date: YEAR-MO-DA HO:MI +ZONE\\n" .
	"Last-Translator: FULL NAME <EMAIL\@ADDRESS>\\n" .
	"Language-Team: LANGUAGE <LL\@li.org>\\n" .
	"MIME-Version: 1.0\\n" .
	"Content-Type: text/plain; charset=CHARSET\\n" .
	"Content-Transfer-Encoding: ENCODING\\n");

foreach my $i (@rest) {
	my ($string, undef, undef, undef) = $tlk->strref($i);
	if ($string ne "") {
		$string =~ s/\\/\\\\/g;
		$string =~ s/\r//g;
		$string =~ s/\n/\\n/g;
		push(@po, new Locale::PO(-msgid=>"$string", -msgstr=>"", -reference=>"$i"));
	}
}
# Формируем файл, в котором сохраняются строки, не найденные больше нигде
Locale::PO->save_file_fromarray($config{output}."rest.pot", \@po);
system("msguniq", $config{output}."/rest.pot", "-o", $config{output}."/rest.pot");

#print @all;

