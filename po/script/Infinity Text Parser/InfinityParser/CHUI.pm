package InfinityParser::CHUI;

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
	open(CHUI,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
    my $buffer;
    read(CHUI, $buffer, 8);
    if ($buffer ne 'CHUIV1  ') {
    	die "$self->{FILENAME} is not CHUI-file version 1\n";
    }	
}

sub strref() {
	my $self = shift();
	my @strref;
	my ($buffer, $offset, $control_offset, $win_count, $win_offset);
	my $control_count = 0;

	seek(CHUI, 0x08, 0);
	# Количество окон
	read(CHUI, $buffer, 4);
	$win_count = unpack("L8", $buffer);
	
	# Смещение первого контрола
	read(CHUI, $buffer, 4);
	$offset = unpack("L8", $buffer);
	
	# Смещение первого окна
	read(CHUI, $buffer, 4);
	$win_offset = unpack("L8", $buffer);
	
	for (my $i=0; $i < $win_count; $i++) {
		seek(CHUI, 0x1c * $i + $win_offset + 0x0e, 0);
		read(CHUI, $buffer, 2);
		$control_count += unpack ("S", $buffer);
	}
	for (my $i = 0; $i < $control_count; $i++) {
		seek(CHUI, 0x08 * $i + $offset, 0);
		read(CHUI, $buffer, 4);
		# Настоящее смещение текущего контрола
		$control_offset = unpack("L8", $buffer);
		# 0x0c - адрес типа контрола в структуре контролов
		seek(CHUI, $control_offset + 0x0c, 0);
		read(CHUI, $buffer, 1);
		# если тип контрола 6 (строка), то добавляем в результат
		if ( unpack("C", $buffer) == 6 ) {
#			printf("0x%x ", $control_offset);
			seek(CHUI, $control_offset + 0x0e, 0);
			read(CHUI, $buffer, 4);
#			print unpack("L8", $buffer), "\n";
			push(@strref, unpack("L8", $buffer));			
		}
	}
	return @strref;
}

END { }
1;