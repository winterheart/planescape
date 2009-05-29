package InfinityParser::DLG;

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
	open(DLG,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
    my $buffer;
    read(DLG, $buffer, 8);
    if ($buffer ne 'DLG V1.0') {
    	die "$self->{FILENAME} is not DLG-file version 1.0\n";
    }	
}

sub strref() {
	my $self = shift();
	my @strref;
	my ($buffer, $count, $offset);
	# Сначала стейты
	seek(DLG, 8, 0);
	read(DLG, $buffer, 4);
	$count = unpack("L", $buffer);
	read(DLG, $buffer, 4);
	$offset = unpack("L", $buffer);
	for (my $i=0; $i < $count; $i++) {
		# 0x0010 - размер стейта
		# 0x0000 - адрес для имени
		seek(DLG, 0x0010 * $i + $offset, 0);
		read(DLG, $buffer, 4);
		push(@strref, unpack("L", $buffer));
	}
	
	# Транзиты
	seek(DLG, 16, 0);
	read(DLG, $buffer, 4);
	$count = unpack("L", $buffer);
	read(DLG, $buffer, 4);
	$offset = unpack("L", $buffer);
	for (my $i=0; $i < $count; $i++) {
		# 0x0020 - размер транзита
		# 0x0004 - адрес для имени
		seek(DLG, 0x0020 * $i + $offset, 0);
		read(DLG, $buffer, 4);
		my $swith = unpack("L8", $buffer);
		# 1 - ответ
		if (($swith & 1) == 1) {
			seek(DLG, 0x0020 * $i + $offset + 4, 0);
			read(DLG, $buffer, 4);
			push(@strref, unpack("L", $buffer));
		}
		# 16 - запись в дневнике
		if (($swith & 16) == 16) {
			seek(DLG, 0x0020 * $i + $offset + 8, 0);
			read(DLG, $buffer, 4);
			push(@strref, unpack("L", $buffer));
		}
	}
	
	return @strref;	
}

END { }
1;