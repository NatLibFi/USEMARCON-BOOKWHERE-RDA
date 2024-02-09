#!/usr/bin/perl -w

use strict; 
sub usage() {
    print STDERR "Usage: $0 (fin|swe|eng) (336|337) (a|b)\n\nExample: $0 fin 336 a\n";
    exit(-1);
}

if ( scalar(@ARGV) != 3 ) {
    &usage();
}

my ( $target_language, $target_tag, $target_subfield_code ) = @ARGV;

if ( $target_language !~ /^(engfin|swe)$/ ) { &usage(); }
if ( $target_tag !~ /^(336|337)$/ ) { &usage(); }
if ( $target_subfield_code !~ /^(a|b)$/ ) { &usage(); }


my %rda;
my @rdacontent_types = ( 'crd', 'cri', 'crm', 'crt', 'crn', 'crf', 'cod', 'cop', 'ntv', 'ntm', 'prm', 'snd', 'spw', 'sti', 'tci', 'tcm', 'tcn', 'tct', 'tcf', 'txt', 'tdf', 'tdm', 'tdi', 'xxx', 'zzz' );
my @languages = ('fin', 'swe', 'eng', 'ger');
for my $term ( @rdacontent_types ) {
    $rda{$term} = ();
}

# https://www.loc.gov/standards/valuelist/rdacontent.html
$rda{'crd'}{'eng'} = 'cartographic dataset';
$rda{'cri'}{'eng'} = 'cartographic image';
$rda{'crm'}{'eng'} = 'cartographic moving image';
$rda{'crt'}{'eng'} = 'cartographic tactile image';
$rda{'crn'}{'eng'} = 'cartographic three-dimensional tactile form';
$rda{'crf'}{'eng'} = 'cartographic three-dimensional form';
$rda{'cod'}{'eng'} = 'computer dataset';
$rda{'cop'}{'eng'} = 'computer program';
$rda{'ntv'}{'eng'} = 'notated movement';
$rda{'ntm'}{'eng'} = 'notated music';
$rda{'prm'}{'eng'} = 'performed music';
$rda{'snd'}{'eng'} = 'sounds';
$rda{'spw'}{'eng'} = 'spoken word';
$rda{'sti'}{'eng'} = 'still image';
$rda{'tci'}{'eng'} = 'tactile image';
$rda{'tcm'}{'eng'} = 'tactile notated music';
$rda{'tcn'}{'eng'} = 'tactile notated movement';
$rda{'tct'}{'eng'} = 'tactile text';
$rda{'tcf'}{'eng'} = 'tactile three-dimensional form';
$rda{'txt'}{'eng'} = 'text';
$rda{'tdf'}{'eng'} = 'three-dimensional form';
$rda{'tdm'}{'eng'} = 'three-dimensional moving image';
$rda{'tdi'}{'eng'} = 'two-dimensional moving image';
$rda{'xxx'}{'eng'} = 'other';
$rda{'zzz'}{'eng'} = 'unspecified';

# https://www.loc.gov/standards/valuelist/rdamedia.html
$rda{'s'}{'eng'} = 'audio';
$rda{'c'}{'eng'} = 'computer';
$rda{'h'}{'eng'} = 'microform';
$rda{'p'}{'eng'} = 'microscopic';
$rda{'g'}{'eng'} = 'projected';
$rda{'e'}{'eng'} = 'stereographic';
$rda{'n'}{'eng'} = 'unmediated';
$rda{'v'}{'eng'} = 'video';
$rda{'x'}{'eng'} = 'other';
$rda{'z'}{'eng'} = 'unspecified';

# https://wiki-emerita.it.helsinki.fi/pages/viewpage.action?pageId=400875286#id-3XXFyysisenkuvailunjne.kent%C3%A4t-336 et al
# Above erronously has 'kartografinen kolmiulotteinen kuva' (should be ...muoto)
$rda{'crd'}{'fin'} = 'kartografinen data';
$rda{'cri'}{'fin'} = 'kartografinen kuva';
$rda{'crm'}{'fin'} = 'kartografinen liikkuva kuva';
$rda{'crt'}{'fin'} = 'katrografinen taktiili kuva';
$rda{'crn'}{'fin'} = 'kartografinen taktiili kolmiulotteinen muoto';
$rda{'crf'}{'fin'} = 'kartografinen kolmiulotteinen muoto'; # See above
$rda{'cod'}{'fin'} = 'digitaalinen data';
$rda{'cop'}{'fin'} = 'tietokoneohjelma';
$rda{'ntv'}{'fin'} = 'liikenotaatio';
$rda{'ntm'}{'fin'} = 'nuottikirjoitus'; # ei "notatoitu musiikki"
$rda{'prm'}{'fin'} = 'esitetty musiikki';
$rda{'snd'}{'fin'} = 'ääni';
$rda{'spw'}{'fin'} = 'puhe';
$rda{'sti'}{'fin'} = 'stillkuva';
$rda{'tci'}{'fin'} = 'taktiili kuva';
$rda{'tcm'}{'fin'} = 'taktiili nuottikirjoitus';
$rda{'tcn'}{'fin'} = 'taktiili liikenotaatio';
$rda{'tct'}{'fin'} = 'taktiili teksti';
$rda{'tcf'}{'fin'} = 'taktiili kolmiulotteinen muoto';
$rda{'txt'}{'fin'} = 'teksti';
$rda{'tdf'}{'fin'} = 'kolmiulotteinen muoto';
$rda{'tdm'}{'fin'} = 'kolmiulotteinen liikkuva kuva';
$rda{'tdi'}{'fin'} = 'kaksiulotteinen liikkuva kuva';
$rda{'xxx'}{'fin'} = 'muu';
$rda{'zzz'}{'fin'} = 'määrittelemätön';

# https://wiki-emerita.it.helsinki.fi/pages/viewpage.action?pageId=400875286#id-3XXFyysisenkuvailunjne.kent%C3%A4t-337
$rda{'s'}{'fin'} = 'audio';
$rda{'c'}{'fin'} = 'tietokonekäyttöinen';
$rda{'h'}{'fin'} = 'mikromuoto';
$rda{'p'}{'fin'} = 'mikroskooppinen';
$rda{'g'}{'fin'} = 'heijastettava';
$rda{'e'}{'fin'} = 'stereografinen';
$rda{'n'}{'fin'} = 'käytettävissä ilman laitetta';
$rda{'v'}{'fin'} = 'video';
$rda{'x'}{'fin'} = 'muu';
$rda{'z'}{'fin'} = 'määrittelemätön';

# Compare Finnish and Swedish terms in MTS
$rda{'crd'}{'swe'} = 'kartografisk data';
$rda{'cri'}{'swe'} = 'kartografisk bild';
$rda{'crm'}{'swe'} = 'kartografisk rörlig bild';
$rda{'crt'}{'swe'} = 'katrografisk taktil bild';
$rda{'crn'}{'swe'} = 'kartografisk taktil tredimensionell form';
$rda{'crf'}{'swe'} = 'kartografisk tredimensionell form'; # vs "cartographic three-dimensional form"?!?
$rda{'cod'}{'swe'} = 'digitalt dataset';
$rda{'cop'}{'swe'} = 'datorprogram';
$rda{'ntv'}{'swe'} = 'rörelsenotation';
$rda{'ntm'}{'swe'} = 'noterad musik';
$rda{'prm'}{'swe'} = 'framförd musik';
$rda{'snd'}{'swe'} = 'ljud';
$rda{'spw'}{'swe'} = 'tal';
$rda{'sti'}{'swe'} = 'stillbild';
$rda{'tci'}{'swe'} = 'taktil bild';
$rda{'tcm'}{'swe'} = 'taktil musiknotation';
$rda{'tcn'}{'swe'} = 'taktil noterad rörelse';
$rda{'tct'}{'swe'} = 'taktil text';
$rda{'tcf'}{'swe'} = 'taktil tredimensionell form';
$rda{'txt'}{'swe'} = 'text';
$rda{'tdf'}{'swe'} = 'tredimensionell form';
$rda{'tdm'}{'swe'} = 'tredimensionell rörlig bild';
$rda{'tdi'}{'swe'} = 'tvådimensionell rörlig bild';
$rda{'xxx'}{'swe'} = 'annan';
$rda{'zzz'}{'swe'} = 'ospecificerad';


$rda{'s'}{'swe'} = 'audio';
$rda{'c'}{'swe'} = 'dator';
$rda{'h'}{'swe'} = 'mikroform';
$rda{'p'}{'swe'} = 'mikroskopisk';
$rda{'g'}{'swe'} = 'projicerad';
$rda{'e'}{'swe'} = 'stereografisk';
$rda{'n'}{'swe'} = 'omedierad';
$rda{'v'}{'swe'} = 'video';
$rda{'x'}{'swe'} = 'annan';
$rda{'z'}{'swe'} = 'ospecificerad';

# Marginal languages:
$rda{'txt'}{'ger'} = "Text";
$rda{'txt'}{'n'} = "ohne Hilfsmittel zu benutzen";
$rda{'txt'}{'s'} = "Geräusche";

my %isbn2rda;
$isbn2rda{'cod'} = "Data|Dataset";
$isbn2rda{'crd'} = "Data (kartografinen)|Dataset (kartografisk)";
$isbn2rda{'cri'} = "Kuva (kartografinen)";
$isbn2rda{'crf'} = "Esine (kartogragrafinen ; kolmiulotteinen)";
$isbn2rda{'crm'} = "Kuva (kartografinen ; liikkuva)";
$isbn2rda{'crn'} = "Esine (kartografinen ; kosketeltava)";
$isbn2rda{'crt'} = "Kuva (kartografinen ; kosketeltava)";
$isbn2rda{'ntm'} = "Musiikki (notatoitu)";
$isbn2rda{'ntv'} = "Liike (notatoitu)";
$isbn2rda{'prm'} = "Musiikki (esitetty)";
$isbn2rda{'sti'} = "Kuva|Kuva (still)|Kuva (still ; kaksiulotteinen)|Kuva (still ; kolmiulotteinen)";
$isbn2rda{'tcf'} = "Esine (kosketeltava)";
$isbn2rda{'tci'} = "Kuva (still ; kosketeltava)";
$isbn2rda{'tcm'} = "Musiikki (kosketeltava ; notatoitu)|Musiikki (notatoitu ; kosketeltava)";
$isbn2rda{'tcn'} = "Liike (kosketeltava ; notatoitu)|Liike (notatoitu ; kosketeltava)";
$isbn2rda{'tct'} = "Teksti (kosketeltava)";
$isbn2rda{'tdf'} = "Esine|Esine (kolmiulotteinen)";
$isbn2rda{'tdi'} = "Kuva (liikkuva ; kaksiulotteinen)";
$isbn2rda{'tdm'} = "Kuva (liikkuva ; kolmiulotteinen)";
$isbn2rda{'txt'} = "Teksti";





sub normalize_term($) {
    my ( $term ) = @_;
    #print STDERR "TERM: '$term'...\n";
    $term =~ s/([A-Za-z\- \(\);]|å|ä|ö)/$1 /g;
    $term =~ s/(^| ) /${1}0x20/g;
    $term =~ s/ä/0xC3 0xA4/g;
    $term =~ s/Ä/0xC3 0x84/g;
    $term =~ s/ö/0xC3 0xB6/g;
    $term =~ s/å/0xc3 0xA5/g;
    my $tmp = $term;
    while ( $tmp =~ s/^(0x[a-fA-F0-9]{2}|[A-Za-z\-;\(\)]) // ) {}
    if ( $tmp ne '' ) { die($tmp); } # unhandled char
    $term =~ s/ $//;
    return $term;
}

sub map_rdacontent($$$) {
    my ( $from_language, $to_language, $tag ) = @_;
    my $val = '';
    for my $code ( @rdacontent_types ) {
	if ( $tag eq '336' && length($code) != 3 ) { next; }
	if ( $tag eq '337' && length($code) != 1 ) { next; }	
	my $from_term = $rda{$code}{$from_language};
	if ( !defined($from_term) ) {
	    print STDERR "WARNING\tMissing code $code for $from_language\n";
	    next;
	}
	my $to_term = $rda{$code}{$to_language};

	if ( !defined($rda{$code}{$to_language}) ) {
	    die("ERROR\tMissing code $code for $to_language");
	}



	$val .= &normalize_term($from_term)."\t| ".&normalize_term($to_term)."\n";
    }
    return $val;
}



sub create_tbl_file_contents($$){
    my ( $target_language, $tag ) = @_;
    foreach my $from_language ( @languages ) {
	my $set = &map_rdacontent($from_language, $target_language, $tag);
	if ( $set ne '' ) {
	    print "$set\n\n";
	}
    }
    
    for my $code ( @rdacontent_types ) {
	if ( $tag eq '336' && length($code) != 3 ) { next; }
	if ( $tag eq '337' && length($code) != 1 ) { next; }
	#print STDERR "CODE $code\n";
	my $isbn_terms = $isbn2rda{$code};
	if ( defined($isbn_terms) ) {
	    my $target_term = $rda{$code}{$target_language};
	    my @terms = split(/\|/, $isbn_terms);
	    foreach my $isbn_term ( @terms ) {
		
		my $val .= &normalize_term($isbn_term)."\t| ". &normalize_term($target_term);

		print $val, "\n";;
	    }
	    print "\n";
		
	}
    }
    print "\n\n#DEFAULT\t|COPY\n";
}

&create_tbl_file_contents($target_language, $target_tag, $target_subfield_code);
    

