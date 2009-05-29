package InfinityParser::ITM;

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
	open(ITM,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
    my $buffer;
    read(ITM, $buffer, 8);
    if ($buffer ne 'ITM V1.1') {
    	die "$self->{FILENAME} is not ITM-file version 1.1\n";
    }	
}

sub strref() {
	my $self = shift();
	my @strref;
	my $buffer;
	# Первое название заклинания
	seek(ITM, 8, 0);
	read(ITM, $buffer, 4);
	push(@strref, unpack("L8", $buffer));
	# Второе название (идентифицированное) заклинания
	read(ITM, $buffer, 4);
	push(@strref, unpack("L8", $buffer));
	# Первое описание заклинния
	seek(ITM, 0x0050, 0);
	read(ITM, $buffer, 4);
	push(@strref, unpack("L8", $buffer));
	# Второе (идентифицированное) описание заклинания
	read(ITM, $buffer, 4);
	push(@strref, unpack("L8", $buffer));
	return @strref;	
}

END { }
1;