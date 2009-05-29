package InfinityParser::TLK;

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

=head1 NAME

InfinityParser::TLK - (read-only)-interface for TLK-file for games based on Infinity Engine   

=head1 SYNOPSYS

	use InfinityParser::TLK;
	
	my $tlk = InfinityParser::TLK->new();
	$tlk->open("Dialog.tlk");
	my ($string, $sound_file, $volume_variance, $pitch_variance) = $tlk->strref(100);

=head1 SUPPORTED VERSIONS

Currently supported TLK V1 files (Baldur's Gate, Planescape: Torment, Icewind Dale)

=head1 DESCRIPTION

TODO

=cut

sub new() {
	my $self  = {};
	$self->{FILENAME} = undef;
	$self->{MAX_STRING} = undef;
	$self->{STRING_OFFSET} = undef;	
    bless($self);           # but see below
    return $self;
}

=head1 METHODS

TODO

=cut
	
sub open($) {
	my $self = shift();
	$self->{FILENAME} = shift();
	open(TLK,"<", $self->{FILENAME}) or die "Couldn't open $self->{FILENAME}: $!\n";
    my $buffer;
    read(TLK, $buffer, 8);
    if ($buffer ne 'TLK V1  ') {
    	die "$self->{FILENAME} is not TLK-file version 1\n";
    }
    seek(TLK, 0x0a, 0);
    read(TLK, $buffer, 4);
    $self->{MAX_STRING} = unpack("L8", $buffer);
    read(TLK, $buffer, 4);
    $self->{STRING_OFFSET} = unpack("L8", $buffer);
}

sub strref($) {
	my $self = shift();
	my $strref = shift();
	if ($strref > $self->{MAX_STRING}) {
		# Пока не понятно, как обрабатывать out-range события
		return ""; # die "Strref cannot be greater than $self->{MAX_STRING}\n";
	}
	my ($sound_file, $volume, $pitch, $str_offset, $str_length, $string);
	# Имя файла со звуком
	seek(TLK, 18 + (26 * $strref + 2), 0);
	read(TLK, $sound_file, 8);
	read(TLK, $volume, 4);
	read(TLK, $pitch, 4);
	read(TLK, $str_offset, 4);
	read(TLK, $str_length, 4);
	seek(TLK, unpack("L8", $str_offset) + $self->{STRING_OFFSET}, 0);
	read(TLK, $string, unpack("L8", $str_length));
	return ($string, $sound_file, unpack("L8", $volume), unpack("L8", $pitch));
}

sub maxstring() {
	my $self = shift();
	return $self->{MAX_STRING}; 
}

=head1 SEE ALSO

=item * http://www.ugcs.caltech.edu/~jedwin/baldur_TLK.html

=head1 COPYRIGHT

Copyright 2009 Azamat H. Hackimov <azamat.hackimov@gmail.com>

license here

=cut

END { }
1;
