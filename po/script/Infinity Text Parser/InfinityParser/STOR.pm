package InfinityParser::STOR;

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
	open(STOR,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
    my $buffer;
    read(STOR, $buffer, 8);
    if ($buffer ne 'STORV1.1') {
    	die "$self->{FILENAME} is not STOR-file version 1.1\n";
    }	
}

sub strref() {
	my $self = shift();
	my @strref;
	my ($buffer, $count, $offset);
	# Название магазина
	seek(STOR, 0x000c, 0);
	read(STOR, $buffer, 4);
	push(@strref, unpack("L", $buffer));
	
	# Напитки
	seek(STOR, 0x004c, 0);
	read(STOR, $buffer, 4);
	$offset = unpack("L", $buffer);
	read(STOR, $buffer, 4);
	$count = unpack("L", $buffer);
	
	for (my $i=0; $i < $count; $i++) {
		# 0x0014 - размер структуры "Напитки"
		# 0x0008 - адрес в этой структуре для имени "Напитка"
		seek(STOR, 0x0014 * $i + $offset + 0x0008, 0);
		read(STOR, $buffer, 4);
		push(@strref, unpack("L", $buffer));
	}
	
	return @strref;	
}

END { }
1;