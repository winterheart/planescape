package InfinityParser::SPL;

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
	open(SPL,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
    my $buffer;
    read(SPL, $buffer, 8);
    if ($buffer ne 'SPL V1  ') {
    	die "$self->{FILENAME} is not SPL-file version 1\n";
    }	
}

sub strref() {
	my $self = shift();
	my @strref;
	my $buffer;
	# Первое название заклинания
	seek(SPL, 8, 0);
	read(SPL, $buffer, 4);
	push(@strref, unpack("L8", $buffer));
	# Второе название (идентифицированное) заклинания
#	read(SPL, $buffer, 4);
#	push(@strref, unpack("L8", $buffer));
	# Первое описание заклинния
	seek(SPL, 0x0050, 0);
	read(SPL, $buffer, 4);
	push(@strref, unpack("L8", $buffer));
	# Второе (идентифицированное) описание заклинания
#	read(SPL, $buffer, 4);
#	push(@strref, unpack("L8", $buffer));
	return @strref;	
}

END { }
1;
