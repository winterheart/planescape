package InfinityParser::SRC;

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
	open(SRC,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
}

sub strref() {
	my $self = shift();
	my @strref;
	my ($buffer, $count);

	seek(SRC, 0, 0);
	read(SRC, $buffer, 4);
	$count = unpack("L",$buffer);
	for (my $i=0; $i < $count; $i++) {
		seek(SRC, $i * 8 + 4, 0);
		read(SRC, $buffer, 4);
		push(@strref, unpack("L8", $buffer));
	}
	return @strref;	
}

END { }
1;