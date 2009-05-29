package InfinityParser::AREA;

use strict;
use warnings;
BEGIN {
	use Exporter();
	our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
	$VERSION = "0.1";
#	@ISA = qw(Exporter);
	@EXPORT = qw( &new &open &strref ); # Экспорт функций - &func1 &func2
	@EXPORT_OK = qw( ); # Экспортные внешние переменные
}

our @EXPORT_OK;

sub new() {
	my $self  = {};
	$self->{FILENAME} = undef;
    bless($self);           # but see below
    return $self;
}

sub open($) {
	my $self = shift();
	$self->{FILENAME} = shift();
	open(AREA,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
    my $buffer;
    read(AREA, $buffer, 8);
    if ($buffer ne 'AREAV1.0') {
    	die "$self->{FILENAME} is not AREA-file version 1.0\n";
    }	
}

sub strref() {
	my $self = shift();
	my @strref;
	my ($buffer, $count, $offset);
	# "Интересные поинты"
	seek(AREA, 0x005a, 0);
	read(AREA, $buffer, 2);
	$count = unpack ("S", $buffer);
	read(AREA, $buffer, 4);
	$offset = unpack("L", $buffer);
	
	for (my $i=0; $i < $count; $i++) {
		# 0x00c4 - размер структуры "интересная точка"
		# 0x0064 - адрес в этой структуре для имени точки
		seek(AREA, 0x00c4 * $i + $offset + 0x064, 0);
		read(AREA, $buffer, 4);
		push (@strref, unpack("L", $buffer));
	}

	# Двери (тоже могут содержать strref)
	seek(AREA, 0x00a4, 0);
	read(AREA, $buffer, 4);
	$count = unpack("L", $buffer);
	read(AREA, $buffer, 4);
	$offset = unpack("L", $buffer);
	
	for (my $i=0; $i < $count; $i++) {
		# 0x00c8 - размер структуры "дверь"
		# 0x00b4 - адрес в этой структуре для имени "двери"
		seek(AREA, 0x00c8 * $i + $offset + 0x00b4, 0);
		read(AREA, $buffer, 4);
		push(@strref, unpack("L", $buffer));
	}

	return @strref;	
}

END { }
1;