package InfinityParser::BAF;

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
	open(BAF,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
}

sub strref() {
	my $self = shift();
	my @strref;
	my $buffer;
	while ($buffer = <BAF>) {
		my $string;		
		if ($buffer =~ m/FloatMessage\(.*\,(\d+)\)/) {
			$string = $1;
			push (@strref, $string);
		}
	}	
	return @strref;	
}

END { }
1;