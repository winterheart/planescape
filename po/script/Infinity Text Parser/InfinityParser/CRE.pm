package InfinityParser::CRE;

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
	open(CRE,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
    my $buffer;
    read(CRE, $buffer, 7);
    if ($buffer ne 'CRE V1.') {
    	die "$self->{FILENAME} is not CRE-file version 1.x\n";
    }	
}

sub strref() {
	my $self = shift();
	my @strref;
	my $buffer;

	seek(CRE, 8, 0);
	read(CRE, $buffer, 4);
	push(@strref, unpack("L8", $buffer));
	read(CRE, $buffer, 4);
	push(@strref, unpack("L8", $buffer));
	seek(CRE, 0x00a4, 0);
	
	for (my $i=1; $i<=100; $i++) {
		read(CRE, $buffer, 4);
		push(@strref, unpack("L8", $buffer));
	}
	return @strref;	
}

END { }
1;