#!/usr/bin/perl -w

use strict; 

sub usage() { # TODO: 338
    print STDERR "Usage: $0 (fin|swe|eng) (336|337) (a|b)\n\nExample: $0 fin 336 a\n";
    exit(-1);
}

if ( scalar(@ARGV) != 3 ) {
    print STDERR "ERROR\tWrong number of arguments!\n\n";
    &usage();
}

my ( $target_language, $target_tag, $target_subfield_code ) = @ARGV;

if ( $target_subfield_code !~ /^(a|b)$/ ) { &usage(); }


# $b is same for all languages, so no need to check it...
if ( $target_subfield_code ne 'b' && $target_language !~ /^(eng|fin|swe)$/ ) {
    print STDERR "ERROR\tUnsupported language!\n\n";
    &usage();
}

if ( $target_tag !~ /^(336|337)$/ ) { &usage(); }



my %rda;
my @rdacontent_types = ( 'crd', 'cri', 'crm', 'crt', 'crn', 'crf', 'cod', 'cop', 'ntv', 'ntm', 'prm', 'snd', 'spw', 'sti', 'tci', 'tcm', 'tcn', 'tct', 'tcf', 'txt', 'tdf', 'tdm', 'tdi', 'xxx', 'zzz' );
my @rdamedia_types = ('s', 'c', 'h', 'p', 'g', 'e', 'n', 'v', 'x', 'z');
my @languages = ('fin', 'swe', 'eng', 'ger');
for my $term ( @rdacontent_types ) {
    $rda{$term} = ();
}

# https://www.loc.gov/standards/valuelist/rdacontent.html
$rda{'crd'}{'eng'} = 'cartographic dataset';
$rda{'cri'}{'eng'} = 'cartographic image';
$rda{'crm'}{'eng'} = 'cartographic moving image';
$rda{'crt'}{'eng'} = 'cartographic tactile image';
$rda{'crn'}{'eng'} = 'cartographic tactile three-dimensional form';
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


# https://www.loc.gov/standards/valuelist/rdamedia.html
# https://wiki-emerita.it.helsinki.fi/pages/viewpage.action?pageId=400875286#id-3XXFyysisenkuvailunjne.kent%C3%A4t-337

$rda{'c'}{'eng'} = 'computer';
$rda{'c'}{'fin'} = 'tietokonekäyttöinen';
$rda{'c'}{'swe'} = 'dator';
$rda{'e'}{'eng'} = 'stereographic';
$rda{'e'}{'fin'} = 'stereografinen';
$rda{'e'}{'swe'} = 'stereografisk';
$rda{'g'}{'eng'} = 'projected';
$rda{'g'}{'fin'} = 'heijastettava';
$rda{'g'}{'swe'} = 'projicerad';
$rda{'h'}{'eng'} = 'microform';
$rda{'h'}{'fin'} = 'mikromuoto';
$rda{'h'}{'swe'} = 'mikroform';
$rda{'n'}{'swe'} = 'omedierad';
$rda{'n'}{'fin'} = 'käytettävissä ilman laitetta';
$rda{'n'}{'eng'} = 'unmediated';
$rda{'p'}{'eng'} = 'microscopic';
$rda{'p'}{'fin'} = 'mikroskooppinen';
$rda{'p'}{'swe'} = 'mikroskopisk';
$rda{'s'}{'eng'} = 'audio';
$rda{'s'}{'fin'} = 'audio';
$rda{'s'}{'swe'} = 'audio';
$rda{'v'}{'eng'} = 'video';
$rda{'v'}{'fin'} = 'video';
$rda{'v'}{'swe'} = 'video';
$rda{'x'}{'eng'} = 'other';
$rda{'x'}{'fin'} = 'muu';
$rda{'x'}{'swe'} = 'annan';
$rda{'z'}{'eng'} = 'unspecified';
$rda{'z'}{'fin'} = 'määrittelemätön';
$rda{'z'}{'swe'} = 'ospecificerad';








## 338 (extremely incomplete):
# Äänitallenteet:
$rda{'ca'}{'eng'} = 'computer tape cartridge';
$rda{'ca'}{'fin'} = 'tietonauhan silmukkakasetti';
$rda{'cb'}{'eng'} = 'computer cartridge';
$rda{'cb'}{'fin'} = 'piirikotelo';
$rda{'cd'}{'eng'} = 'computer disc';
$rda{'cd'}{'fin'} = 'tietolevy';
$rda{'cd'}{'swe'} = 'datorskiva';
$rda{'ce'}{'eng'} = 'computer disc cartridge';
$rda{'ce'}{'fin'} = 'tietolevykotelo';
$rda{'cf'}{'eng'} = 'computer tape cassette';
$rda{'cf'}{'fin'} = 'tietokasetti';
$rda{'ch'}{'eng'} = 'computer tape reel';
$rda{'ch'}{'fin'} = 'tietonauhakela';
$rda{'ck'}{'eng'} = 'computer card';
$rda{'cr'}{'eng'} = 'online resource';
$rda{'cr'}{'fin'} = 'verkkoaineisto';

$rda{'cz'}{'fin'} = 'muu';

$rda{'eh'}{'eng'} = 'stereograph card';
$rda{'eh'}{'fin'} = 'stereografinen kortti';
$rda{'es'}{'eng'} = 'stereograph disc';
$rda{'es'}{'fin'} = 'stereografinen levy';
$rda{'ez'}{'fin'} = 'muu';

$rda{'gc'}{'eng'} = 'filmstrip cartridge';
$rda{'gd'}{'eng'} = 'filmslip';
$rda{'gd'}{'eng'} = 'filmiliuska';

$rda{'gf'}{'eng'} = 'filmstrip';
$rda{'gf'}{'fin'} = 'raina';

$rda{'gs'}{'eng'} = 'slide';
$rda{'gs'}{'fin'} = 'dia';
$rda{'gs'}{'swe'} = 'diabild';

$rda{'gt'}{'eng'} = 'overhead transparency';
$rda{'gt'}{'fin'} = 'piirtoheitinkalvo';
$rda{'gt'}{'swe'} = 'transparang';

$rda{'ha'}{'eng'} = 'aperture card';
$rda{'ha'}{'fin'} = 'ikkunakortti';
$rda{'ha'}{'swe'} = 'fönsterkort';

$rda{'hb'}{'eng'} = 'microfilm cartridge';
$rda{'hb'}{'fin'} = 'mikrofilmisilmukkakasetti';

$rda{'hc'}{'eng'} = 'microfilm';
$rda{'hc'}{'fin'} = 'mikrofilmikasetti';

$rda{'hd'}{'eng'} = 'microfilm reel';
$rda{'hd'}{'fin'} = 'mikrofilmikela';

$rda{'he'}{'eng'} = 'microfiche';
$rda{'he'}{'fin'} = 'mikrokortti';
$rda{'he'}{'swe'} = 'mikrokort';

$rda{'hf'}{'eng'} = 'microfiche cassette';
$rda{'hf'}{'fin'} = 'mikrokorttikasetti';

$rda{'hg'}{'eng'} = 'microopaque';
$rda{'hg'}{'fin'} = 'mikrokortti (läpinäkymätön)';

$rda{'hh'}{'eng'} = 'microfilm slip';
$rda{'hh'}{'fin'} = 'mikrofilmiliuska';

$rda{'hj'}{'eng'} = 'microfilm roll';
$rda{'hj'}{'fin'} = 'mikrofilmirulla';

$rda{'hz'}{'fin'} = 'muu';

$rda{'mc'}{'eng'} = 'film cartridge';
$rda{'mc'}{'fin'} = 'filmisilmukkakasetti';
$rda{'mf'}{'eng'} = 'film cassette';
$rda{'mf'}{'fin'} = 'filmikasetti';
$rda{'mo'}{'eng'} = 'film roll';
$rda{'mo'}{'fin'} = 'filmirulla';
$rda{'mr'}{'eng'} = 'film reel';
$rda{'mr'}{'fin'} = 'filmikela';
$rda{'mz'}{'fin'} = 'muu';

$rda{'na'}{'eng'} = 'roll';
$rda{'na'}{'fin'} = 'rulla';

$rda{'nb'}{'eng'} = 'sheet';
$rda{'nb'}{'fin'} = 'arkki';
$rda{'nb'}{'swe'} = 'ark';

$rda{'nc'}{'eng'} = 'volume';
$rda{'nc'}{'fin'} = 'nide';

$rda{'nn'}{'eng'} = 'flipchart';
$rda{'nn'}{'fin'} = 'lehtiötaulu';

$rda{'no'}{'eng'} = 'card';
$rda{'no'}{'fin'} = 'kortti';
$rda{'no'}{'swe'} = 'bildkort';

$rda{'nr'}{'eng'} = 'object';
$rda{'nr'}{'fin'} = 'objekti';

$rda{'nz'}{'fin'} = 'muu';
$rda{'nz'}{'övrig'} = 'annan';

$rda{'pp'}{'eng'} = 'microscope slide';
$rda{'pp'}{'fin'} = 'preparaattilasi';
$rda{'pz'}{'fin'} = 'muu';

$rda{'sd'}{'eng'} = 'audio disc';
$rda{'sd'}{'fin'} = 'äänilevy';
$rda{'sd'}{'swe'} = 'ljudskiva';

$rda{'sg'}{'eng'} = 'audio cylinder';
$rda{'sg'}{'eng'} = 'audio cartridge';
$rda{'si'}{'eng'} = 'sound-track reel';
$rda{'sq'}{'eng'} = 'audio roll';
$rda{'ss'}{'eng'} = 'audiocassette';
$rda{'ss'}{'fin'} = 'äänikasetti';
$rda{'ss'}{'swe'} = 'ljudkassett';

$rda{'st'}{'eng'} = 'audiotape reel';
$rda{'st'}{'fin'} = 'äänikela';
$rda{'st'}{'swe'} = 'ljudspole';

$rda{'sz'}{'fin'} = 'muu';
$rda{'vc'}{'eng'} = 'video cartridge';
$rda{'vc'}{'fin'} = 'videosilmukkakasetti';
$rda{'vd'}{'eng'} = 'videodisc';
$rda{'vd'}{'fin'} = 'videolevy';
$rda{'vd'}{'swe'} = 'videoskiva';

$rda{'vf'}{'eng'} = 'video cassette';
$rda{'vf'}{'fin'} = 'videokasetti';
$rda{'vr'}{'eng'} = 'videotape reel';
$rda{'vr'}{'fin'} = 'videokela';
$rda{'vz'}{'eng'} = 'other';
$rda{'vz'}{'fin'} = 'muu';

$rda{'zu'}{'eng'} = 'unspecified';
$rda{'zu'}{'fin'} = 'muu';


# Compare Finnish and Swedish terms in MTS
$rda{'crd'}{'swe'} = 'kartografisk data';
$rda{'cri'}{'swe'} = 'kartografisk bild';
$rda{'crm'}{'swe'} = 'kartografisk rörlig bild';
$rda{'crt'}{'swe'} = 'kartografisk taktil bild';
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




# Common picks from other languages:
$rda{'sti'}{'ger'} = "unbewegtes Bild";
$rda{'txt'}{'ger'} = "Text";

$rda{'txt'}{'n'} = "ohne Hilfsmittel zu benutzen";
$rda{'txt'}{'s'} = "Geräusche";

# Contain isbn values
my %isbn2rda;
$isbn2rda{'cod'} = "Data|Dataset|dataset";
$isbn2rda{'cop'} = 'Datorprogram|Tietokoneohjelma';
$isbn2rda{'crd'} = "Data (kartografinen)|Dataset (kartografisk)";
$isbn2rda{'cri'} = "Kuva (kartografinen)|Bild (kartografisk)";
$isbn2rda{'crf'} = "Esine (kartogragrafinen ; kolmiulotteinen)|Esine (kartografinen)";
$isbn2rda{'crm'} = "Kuva (kartografinen ; liikkuva)|Bild (kartografisk ; rörlig)";
$isbn2rda{'crn'} = "Esine (kartografinen ; kosketeltava)|cartographic three-dimensional tactile form|Föremål (kartografisk ; att vidra)|Föremål (kartografisk ; tredimensionell)";
$isbn2rda{'crt'} = "Kuva (kartografinen ; kosketeltava)|Bild (kartografisk ; att vidra)";
$isbn2rda{'ntm'} = "Musiikki (notatoitu)|Musik (notation)";
$isbn2rda{'ntv'} = "Liike (notatoitu)|Rörelse (notation)";
$isbn2rda{'prm'} = "Musiikki (esitetty)|Musik (performance)";
$isbn2rda{'snd'} = 'Ljud|Ääni';
$isbn2rda{'spw'} = 'Puhe|Tal';
$isbn2rda{'sti'} = "Kuva|Kuva (still)|Kuva (still ; kaksiulotteinen)|Kuva (still ; kolmiulotteinen)|Bild (still ; tredimensionell)|Vild (still ; tvådimensionell)|Bild (still)";
$isbn2rda{'tcf'} = "Esine (kosketeltava)|Föremål (att vidra)";
$isbn2rda{'tci'} = "Kuva (still ; kosketeltava)|Bild (still ; att vidra)";
$isbn2rda{'tcm'} = "Musiikki (kosketeltava ; notatoitu)|Musiikki (notatoitu ; kosketeltava)|Musik (notation ; att vidra)";
$isbn2rda{'tcn'} = "Liike (kosketeltava ; notatoitu)|Liike (notatoitu ; kosketeltava|Rörelse (notation ; att vidra)";
$isbn2rda{'tct'} = "Teksti (kosketeltava); Text (att vidra)";
$isbn2rda{'tdf'} = "Esine|Esine (kolmiulotteinen)|Föremal|Föremål (tredimensionell)";
$isbn2rda{'tdi'} = "Kuva (liikkuva ; kaksiulotteinen)|Bild (rörlig ; tvådimensionell)";
$isbn2rda{'tdm'} = "Kuva (liikkuva ; kolmiulotteinen)|Bild (rörlig ; tredimensionell)";
$isbn2rda{'txt'} = "Teksti|texte"; # Text is in German list: no need to add it here. ('texte': some language? add to $rda{'txt'}{$lang}...
$isbn2rda{'zzz'} = 'Flera innehållstyper|Useita sisältötyyppejä|Määrittelemätön|Määrittelemätön sisältötyyppi|Obestämd innehållstyp|Ospecificerad innehållstyp';




$isbn2rda{'c'} = 'datoranvändbar|elektroninen|elektronisk';
$isbn2rda{'g'} = 'projicerbar|projektion';
$isbn2rda{'n'} = 'ei välittävää laitetta|ingen medietyp|oförmedlad';
$isbn2rda{'x'} = 'övrig';
$isbn2rda{'z'} = 'useita mediatyyppejä|määrittelemätön välittävä laite|ospecificerad medietyp';

sub normalize_term($) {
    my ( $term ) = @_;
    #print STDERR "TERM: '$term'...\n";
    $term =~ s/([A-Za-z\- \(\);]|å|ä|Ä|ö)/$1 /g;
    $term =~ s/(^| ) /${1}0x20/g;
    $term =~ s/ä/0xC3 0xA4/g;
    $term =~ s/Ä/0xC3 0x84/g;
    $term =~ s/ö/0xC3 0xB6/g;
    $term =~ s/å/0xC3 0xA5/g;
    if ( 1 ) { # sanity check
	my $tmp = $term;
	while ( $tmp =~ s/^(0x[a-fA-F0-9]{2}|[A-Za-z\-;\(\)]) // ) {}
	if ( $tmp ne '' ) { die($tmp); } # unhandled char
    }
    $term =~ s/ $//;
    return $term;
}

sub map_a2a_or_b($$$$) {
    my ( $from_language, $to_language, $tag, $subfield_code ) = @_;
    my $val = '';
    my @arr;
    if ( $tag eq '336' ) { @arr = @rdacontent_types; }
    elsif ( $tag eq '337' ) { @arr = @rdamedia_types; }
    else { die(); }

    
    for my $code ( @arr ) {
	my $normalized_code = &normalize_term($code);
	
	if ( $tag eq '336' && length($code) != 3 ) { next; }
	if ( $tag eq '337' && length($code) != 1 ) { next; }	
	my $from_term = $rda{$code}{$from_language};
	if ( !defined($from_term) ) {
	    if ( $from_language =~ /^(eng|fin|swe)$/ ) {
		print STDERR "WARNING\tMissing code $code for $from_language\n";
	    }
	    next;
	}
	my $to_term = $rda{$code}{$to_language};

	if ( !defined($rda{$code}{$to_language}) ) {
	    die("ERROR\tMissing code $code for $to_language");
	}


	my $rhs = $subfield_code eq 'b' ? $normalized_code : &normalize_term($to_term);

	$val .= &normalize_term($from_term)."\t| ".$rhs."\n";
    }
    return $val;
    
}




sub create_tbl_file_contents($$$){
    my ( $target_language, $tag, $subfield_code ) = @_;
    my @rda_types;
    if ( $tag eq '336' ) { @rda_types = @rdacontent_types; }
    elsif ( $tag eq '337' ) { @rda_types = @rdamedia_types; }
    else { die(); }
    
    my %mappings;

    # Map ISBD/RDA term to RDA term (33X$a) or code (33X$b)
    my $sets = '';
    foreach my $from_language ( @languages ) {
	$sets .= &map_a2a_or_b($from_language, $target_language, $tag, $subfield_code);
    }
    my @rows = split(/\n/, $sets);
    @rows = sort @rows;

    # Store data to %mappings:
    foreach my $row ( @rows ) {
	my ( $from, $to ) = split(/\t\| /, $row);
	# Check for doubles:
	if ( defined($mappings{$from}) && $mappings{$from} ne $to ) {
	    die($row);
	}
	$mappings{$from} = $to;
    }

    
    for my $code ( @rda_types ) {
	    # I'd like to sort them usin
	    if ( $tag eq '336' && length($code) != 3 ) { next; }
	    if ( $tag eq '337' && length($code) != 1 ) { next; }
	    #print STDERR "CODE $code\n";
	    my $isbn_terms = $isbn2rda{$code};
	    if ( defined($isbn_terms) ) {
		my $target_term = $rda{$code}{$target_language};
		my $rhs = $subfield_code eq 'a' ? &normalize_term($target_term) : &normalize_term($code);
		my @terms = split(/\|/, $isbn_terms);
		foreach my $isbn_term ( @terms ) {
		    my $lhs = &normalize_term($isbn_term);
		    if ( defined($mappings{$lhs}) && $mappings{$lhs} ne $rhs ) {
			die($isbn_term);
		    }
		    $mappings{$lhs} = $rhs;
		}
	    }
    }

    foreach my $key ( sort keys %mappings ) {
	print $key, "\t| ", $mappings{$key}, "\n";
    }

    print "\n\n#DEFAULT\t| COPY\n";
}


# Two first lines are code
if ( $target_subfield_code eq 'a' ) {
    print "Term-to-term mappings for ${target_tag}\$$target_subfield_code: any-language (ISBD and RDA) terms to $target_language terms\n";
}
else {
    print "Mappings for ${target_tag}\$$target_subfield_code any-language (ISBD and RDA) to corresponding RDA code\n";    
}

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
if ( length($mon) == 1 ) { $mon = "0$mon"; }
if ( length($mday) == 1 ) { $mday = "0$mday"; }
#if ( length($hour) == 1 ) { $min = "0$hour"; }
if ( length($min) == 1 ) { $min = "0$min"; }
if ( length($sec) == 1 ) { $sec = "0$sec"; }

print "Autogenerated file using $0, $year-$mon-$mday $hour:$min:$sec\n\n";
    

&create_tbl_file_contents($target_language, $target_tag, $target_subfield_code);
    

