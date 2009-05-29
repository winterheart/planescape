package InfinityParser::WMAP;

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
	open(WMAP,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
    my $buffer;
    read(WMAP, $buffer, 8);
    if ($buffer ne 'WMAPV1.0') {
    	die "$self->{FILENAME} is not WMAP-file version 1.0\n";
    }	
}

sub strref() {
	my $self = shift();
	my @strref;
	my ($buffer, $count, $offset);
	# Количество записей и их смещение
	seek(WMAP, 0x0008, 0);
	read(WMAP, $buffer, 4);
	$count = unpack("L", $buffer);
	read(WMAP, $buffer, 4);
	$offset = unpack("L", $buffer);
	
	for (my $i=0; $i < $count; $i++) {
		# Для полей Entry
		my ($sub_offset, $sub_count);
		# 0x00B8 - размер "Entry Map"
		# 0x0014 - адрес для имени Entry Map
		seek(WMAP, 0x00B8 * $i + 0x0014 + $offset, 0);
		read(WMAP, $buffer, 4);
		push(@strref, unpack("L", $buffer));
		
		# Спускаемся вниз по структуре
		seek(WMAP, 0x00B8 * $i + 0x0020 + $offset, 0);
		read(WMAP, $buffer, 4);
		$sub_count = unpack("L", $buffer);
		read(WMAP, $buffer, 4);
		$sub_offset = unpack("L", $buffer);
		
		for (my $j=0; $j < $sub_count; $j++) {
			seek(WMAP, 0x00F0 * $j + 0x0040 + $sub_offset, 0);
			read(WMAP, $buffer, 4);
			push(@strref, unpack("L", $buffer));
			read(WMAP, $buffer, 4);
			push(@strref, unpack("L", $buffer));
		}
	}
	
		
#	for (my $i=0; $i < $count; $i++) {
#		# 0x0014 - размер структуры "Напитки"
#		# 0x0008 - адрес в этой структуре для имени "Напитка"
#		seek(WMAP, 0x0014 * $i + $offset + 0x0008, 0);
#		read(WMAP, $buffer, 4);
#		push(@strref, unpack("L", $buffer));
#	}
	
	return @strref;	
}

END { }
1;