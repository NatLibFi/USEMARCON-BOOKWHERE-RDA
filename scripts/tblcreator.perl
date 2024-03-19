#!/usr/bin/perl -w

use strict; 

sub usage() { # TODO: 338
    print STDERR "Usage: $0 (fin|swe|eng) (336|337|338) (a2a|a2b|b2a)\n\nExample: $0 fin 336 a2a\n";
    exit(-1);
}

if ( scalar(@ARGV) != 3 ) {
    print STDERR "ERROR\tWrong number of arguments!\n\n";
    &usage();
}

my ( $target_language, $target_tag, $target_subfield_codes ) = @ARGV;

if ( $target_subfield_codes !~ /^(a2a|a2b|b2a)$/ ) { &usage(); }


# $b is same for all languages, so no need to check it...
if ( $target_subfield_codes ne "a2b" && $target_language !~ /^(eng|fin|swe)$/ ) {
    print STDERR "ERROR\tUnsupported language!\n\n";
    &usage();
}

if ( $target_tag !~ /^(336|337|338)$/ ) { &usage(); }



my %rda;
my @rdacontent_types = ( 'crd', 'cri', 'crm', 'crt', 'crn', 'crf', 'cod', 'cop', 'ntv', 'ntm', 'prm', 'snd', 'spw', 'sti', 'tci', 'tcm', 'tcn', 'tct', 'tcf', 'txt', 'tdf', 'tdm', 'tdi', 'xxx', 'zzz' );
my @rdamedia_types = ('s', 'c', 'h', 'p', 'g', 'e', 'n', 'v', 'x', 'z');

my @rdacarrier_types = ('ca', 'cb', 'cd', 'ce', 'cf', 'ch', 'ck', 'cr', 'cz', 'eh', 'es', 'ez', 'gc', 'gd', 'gf', 'gs', 'gt', 'ha', 'hb', 'hc', 'hd', 'he', 'hf', 'hg', 'hh', 'hj', 'hz', 'mc', 'mf', 'mo', 'mr', 'mz', 'na', 'nb', 'nc', 'nn', 'no', 'nr', 'nz', 'pp', 'pz', 'sb', 'sd', 'se', 'sg', 'si', 'sq', 'ss', 'st', 'sw', 'sz', 'vc', 'vd', 'vf', 'vr', 'vz', 'zu' );
my @languages = ('fin', 'swe', 'eng', 'ger', 'fre');
for my $term ( @rdacontent_types ) {
    $rda{$term} = ();
}

# https://www.loc.gov/standards/valuelist/rdacontent.html
# https://www.rdaregistry.info/termList/RDAContentType/?language=fi
$rda{'crd'}{'eng'} = 'cartographic dataset';
$rda{'crd'}{'fin'} = 'kartografinen data';
$rda{'crd'}{'swe'} = 'kartografisk data';

$rda{'cri'}{'eng'} = 'cartographic image';
$rda{'cri'}{'fin'} = 'kartografinen kuva';
$rda{'cri'}{'swe'} = 'kartografisk bild';

$rda{'crm'}{'eng'} = 'cartographic moving image';
$rda{'crm'}{'fin'} = 'kartografinen liikkuva kuva';
$rda{'crm'}{'swe'} = 'kartografisk rörlig bild';

$rda{'crt'}{'eng'} = 'cartographic tactile image';
$rda{'crt'}{'fin'} = 'katrografinen taktiili kuva';
$rda{'crt'}{'swe'} = 'kartografisk taktil bild';

$rda{'crn'}{'eng'} = 'cartographic tactile three-dimensional form';
$rda{'crn'}{'fin'} = 'kartografinen taktiili kolmiulotteinen muoto';
$rda{'crn'}{'swe'} = 'kartografisk taktil tredimensionell form';

$rda{'crf'}{'eng'} = 'cartographic three-dimensional form';
$rda{'crf'}{'fin'} = 'kartografinen kolmiulotteinen muoto'; # See above
$rda{'crf'}{'swe'} = 'kartografisk tredimensionell form'; # vs "cartographic three-dimensional form"?!?

$rda{'cod'}{'eng'} = 'computer dataset';
$rda{'cod'}{'fin'} = 'digitaalinen data';
$rda{'cod'}{'swe'} = 'digitalt dataset';


$rda{'cop'}{'eng'} = 'computer program';
$rda{'cop'}{'fin'} = 'tietokoneohjelma';
$rda{'cop'}{'swe'} = 'datorprogram';

$rda{'ntv'}{'eng'} = 'notated movement';
$rda{'ntv'}{'fin'} = 'liikenotaatio';
$rda{'ntv'}{'swe'} = 'rörelsenotation';

$rda{'ntm'}{'eng'} = 'notated music';
$rda{'ntm'}{'fin'} = 'nuottikirjoitus'; # ei "notatoitu musiikki"
$rda{'ntm'}{'swe'} = 'noterad musik';

$rda{'prm'}{'eng'} = 'performed music';
$rda{'prm'}{'fin'} = 'esitetty musiikki';
$rda{'prm'}{'swe'} = 'framförd musik';

$rda{'snd'}{'eng'} = 'sounds';
$rda{'snd'}{'fin'} = 'ääni';
$rda{'snd'}{'swe'} = 'ljud';
$rda{'snd'}{'ger'} = 'Geräusche';

$rda{'spw'}{'eng'} = 'spoken word';
$rda{'spw'}{'fin'} = 'puhe';
$rda{'spw'}{'swe'} = 'tal';
$rda{'spw'}{'ger'} = 'gesprochenes Wort';

$rda{'sti'}{'eng'} = 'still image';
$rda{'sti'}{'fin'} = 'stillkuva';
$rda{'sti'}{'swe'} = 'stillbild';
$rda{'sti'}{'ger'} = "unbewegtes Bild";

$rda{'tci'}{'eng'} = 'tactile image';
$rda{'tci'}{'fin'} = 'taktiili kuva';
$rda{'tci'}{'swe'} = 'taktil bild';

$rda{'tcm'}{'eng'} = 'tactile notated music';
$rda{'tcm'}{'fin'} = 'taktiili nuottikirjoitus';
$rda{'tcm'}{'swe'} = 'taktil musiknotation';

$rda{'tcn'}{'eng'} = 'tactile notated movement';
$rda{'tcn'}{'fin'} = 'taktiili liikenotaatio';
$rda{'tcn'}{'swe'} = 'taktil noterad rörelse';

$rda{'tct'}{'eng'} = 'tactile text';
$rda{'tct'}{'fin'} = 'taktiili teksti';
$rda{'tct'}{'swe'} = 'taktil text';
$rda{'tct'}{'fre'} = "texte tactile";

$rda{'tcf'}{'eng'} = 'tactile three-dimensional form';
$rda{'tcf'}{'fin'} = 'taktiili kolmiulotteinen muoto';
$rda{'tcf'}{'swe'} = 'taktil tredimensionell form';

$rda{'txt'}{'eng'} = 'text';
$rda{'txt'}{'fin'} = 'teksti';
$rda{'txt'}{'swe'} = 'text';
$rda{'txt'}{'ger'} = "Text";
$rda{'txt'}{'fre'} = "texte";
$rda{'txt'}{'rus'} = 'текст': # Does not work in usemarcon rules



$rda{'tdf'}{'eng'} = 'three-dimensional form';
$rda{'tdf'}{'fin'} = 'kolmiulotteinen muoto';
$rda{'tdf'}{'swe'} = 'tredimensionell form';

$rda{'tdm'}{'eng'} = 'three-dimensional moving image';
$rda{'tdm'}{'fin'} = 'kolmiulotteinen liikkuva kuva';
$rda{'tdm'}{'swe'} = 'tredimensionell rörlig bild';

$rda{'tdi'}{'eng'} = 'two-dimensional moving image';
$rda{'tdi'}{'fin'} = 'kaksiulotteinen liikkuva kuva';
$rda{'tdi'}{'swe'} = 'tvådimensionell rörlig bild';

$rda{'xxx'}{'eng'} = 'other';
$rda{'xxx'}{'fin'} = 'muu';
$rda{'xxx'}{'swe'} = 'annan';

$rda{'zzz'}{'eng'} = 'unspecified';
$rda{'zzz'}{'fin'} = 'määrittelemätön';
$rda{'zzz'}{'swe'} = 'ospecificerad';

# Above erronously has 'kartografinen kolmiulotteinen kuva' (should be ...muoto)










# https://www.loc.gov/standards/valuelist/rdamedia.html
# https://wiki-emerita.it.helsinki.fi/pages/viewpage.action?pageId=400875286#id-3XXFyysisenkuvailunjne.kent%C3%A4t-337

$rda{'c'}{'eng'} = 'computer';
$rda{'c'}{'fin'} = 'tietokonekäyttöinen';
$rda{'c'}{'swe'} = 'dator';
$rda{'c'}{'ger'} = 'Computermedien';

$rda{'e'}{'eng'} = 'stereographic';
$rda{'e'}{'fin'} = 'stereografinen';
$rda{'e'}{'swe'} = 'stereografisk';
$rda{'e'}{'ger'} = 'stereografisch';

$rda{'g'}{'eng'} = 'projected';
$rda{'g'}{'fin'} = 'heijastettava';
$rda{'g'}{'swe'} = 'projicerad';
$rda{'g'}{'ger'} = 'projizierbar';

$rda{'h'}{'eng'} = 'microform';
$rda{'h'}{'fin'} = 'mikromuoto';
$rda{'h'}{'swe'} = 'mikroform';
$rda{'h'}{'ger'} = 'Mikroform';

$rda{'n'}{'swe'} = 'omedierad';
$rda{'n'}{'fin'} = 'käytettävissä ilman laitetta';
$rda{'n'}{'eng'} = 'unmediated';
$rda{'n'}{'ger'} = "ohne Hilfsmittel zu benutzen";
$rda{'n'}{'rus'} = 'неопосредованный'; # won't work in usemarcon rules

$rda{'p'}{'eng'} = 'microscopic';
$rda{'p'}{'fin'} = 'mikroskooppinen';
$rda{'p'}{'swe'} = 'mikroskopisk';
$rda{'p'}{'ger'} = 'mikroskopisch';

$rda{'s'}{'eng'} = 'audio';
$rda{'s'}{'fin'} = 'audio';
$rda{'s'}{'swe'} = 'audio';
$rda{'s'}{'ger'} = 'audio';

$rda{'v'}{'eng'} = 'video';
$rda{'v'}{'fin'} = 'video';
$rda{'v'}{'swe'} = 'video';
$rda{'v'}{'ger'} = 'video';

$rda{'x'}{'eng'} = 'other';
$rda{'x'}{'fin'} = 'muu';
$rda{'x'}{'swe'} = 'annan';

$rda{'z'}{'eng'} = 'unspecified';
$rda{'z'}{'fin'} = 'määrittelemätön';
$rda{'z'}{'swe'} = 'ospecificerad';








## 338 (English version *should* be complete):
# Swedish translations taken from MTS


$rda{'ca'}{'eng'} = 'computer tape cartridge';
$rda{'ca'}{'fin'} = 'tietonauhan silmukkakasetti';
$rda{'ca'}{'swe'} = 'datorbandmagasin';

$rda{'cb'}{'eng'} = 'computer cartridge';
$rda{'cb'}{'fin'} = 'piirikotelo';
$rda{'cb'}{'swe'} = 'datorminnesmodul';

$rda{'cd'}{'eng'} = 'computer disc';
$rda{'cd'}{'fin'} = 'tietolevy';
$rda{'cd'}{'swe'} = 'datorskiva';

$rda{'ce'}{'eng'} = 'computer disc cartridge';
$rda{'ce'}{'fin'} = 'tietolevykotelo';
$rda{'ce'}{'swe'} = 'datorskivmagasin';

$rda{'cf'}{'eng'} = 'computer tape cassette';
$rda{'cf'}{'fin'} = 'tietokasetti';
$rda{'cf'}{'swe'} = 'datorkassett';

$rda{'ch'}{'eng'} = 'computer tape reel';
$rda{'ch'}{'fin'} = 'tietonauhakela';
$rda{'ch'}{'swe'} = 'datorbandspole';

$rda{'ck'}{'eng'} = 'computer card';
$rda{'ck'}{'fin'} = 'muistikortti';
$rda{'ck'}{'swe'} = 'datorkort';
#$rda{'ck'}{'swe'} = 'minneskort';

$rda{'cr'}{'eng'} = 'online resource';
$rda{'cr'}{'fin'} = 'verkkoaineisto';
$rda{'cr'}{'swe'} = 'onlineresurs';


$rda{'cz'}{'eng'} = 'other';
$rda{'cz'}{'fin'} = 'muu';
$rda{'cz'}{'swe'} = 'annan';

$rda{'eh'}{'eng'} = 'stereograph card';
$rda{'eh'}{'fin'} = 'stereografinen kortti';
$rda{'eh'}{'swe'} = 'stereografiskt kort';

$rda{'es'}{'eng'} = 'stereograph disc';
$rda{'es'}{'fin'} = 'stereografinen levy';
$rda{'es'}{'swe'} = 'stereografisk skiva';

$rda{'ez'}{'eng'} = 'other';
$rda{'ez'}{'fin'} = 'muu';
$rda{'ez'}{'swe'} = 'annan';

$rda{'gc'}{'eng'} = 'filmstrip cartridge';
$rda{'gc'}{'fin'} = 'rainakasetti';
$rda{'gc'}{'swe'} = 'bildbandsmagasin';

$rda{'gd'}{'eng'} = 'filmslip';
$rda{'gd'}{'fin'} = 'filmiliuska';
$rda{'gd'}{'swe'} = 'filmremsa';

$rda{'gf'}{'eng'} = 'filmstrip';
$rda{'gf'}{'fin'} = 'raina';
$rda{'gf'}{'swe'} = 'bildband';

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
$rda{'hb'}{'swe'} = 'mikrofilmsmagasin';

$rda{'hc'}{'eng'} = 'microfilm cassette';
$rda{'hc'}{'fin'} = 'mikrofilmikasetti';
$rda{'hc'}{'swe'} = 'mikrofilmskassett';

$rda{'hd'}{'eng'} = 'microfilm reel';
$rda{'hd'}{'fin'} = 'mikrofilmikela';
$rda{'hd'}{'swe'} = 'mikrofilmsspole';

$rda{'he'}{'eng'} = 'microfiche';
$rda{'he'}{'fin'} = 'mikrokortti';
$rda{'he'}{'swe'} = 'mikrofiche';

$rda{'hf'}{'eng'} = 'microfiche cassette';
$rda{'hf'}{'fin'} = 'mikrokorttikasetti';
$rda{'hf'}{'swe'} = 'mikrofichekassett';

$rda{'hg'}{'eng'} = 'microopaque';
$rda{'hg'}{'fin'} = 'mikrokortti (läpinäkymätön)';
$rda{'hg'}{'swe'} = 'mikrofiche (ogenomskinlig)';

$rda{'hh'}{'eng'} = 'microfilm slip';
$rda{'hh'}{'fin'} = 'mikrofilmiliuska';
$rda{'hh'}{'swe'} = 'mikrofilmsremsa';

$rda{'hj'}{'eng'} = 'microfilm roll';
$rda{'hj'}{'fin'} = 'mikrofilmirulla';
$rda{'hj'}{'swe'} = 'mikrofilmsrulle';

$rda{'hz'}{'eng'} = 'other';
$rda{'hz'}{'fin'} = 'muu';
$rda{'hz'}{'swe'} = 'annan';

$rda{'mc'}{'eng'} = 'film cartridge';
$rda{'mc'}{'fin'} = 'filmisilmukkakasetti';
$rda{'mc'}{'swe'} = 'filmmagasin';

$rda{'mf'}{'eng'} = 'film cassette';
$rda{'mf'}{'fin'} = 'filmikasetti';
$rda{'mf'}{'swe'} = 'filmkassett';

$rda{'mo'}{'eng'} = 'film roll';
$rda{'mo'}{'fin'} = 'filmirulla';
$rda{'mo'}{'swe'} = 'filmrulle';

$rda{'mr'}{'eng'} = 'film reel';
$rda{'mr'}{'fin'} = 'filmikela';
$rda{'mr'}{'swe'} = 'filmspole';

$rda{'mz'}{'eng'} = 'other';
$rda{'mz'}{'fin'} = 'muu';
$rda{'mz'}{'swe'} = 'annan';

$rda{'na'}{'eng'} = 'roll';
$rda{'na'}{'fin'} = 'rulla';
$rda{'na'}{'swe'} = 'rulle';

$rda{'nb'}{'eng'} = 'sheet';
$rda{'nb'}{'fin'} = 'arkki';
$rda{'nb'}{'swe'} = 'ark';

$rda{'nc'}{'eng'} = 'volume';
$rda{'nc'}{'fin'} = 'nide';
$rda{'nc'}{'swe'} = 'volym';
$rda{'nc'}{'rus'} = 'том'; # won't work in usemarcon rules

$rda{'nn'}{'eng'} = 'flipchart';
$rda{'nn'}{'fin'} = 'lehtiötaulu';
$rda{'nn'}{'swe'} = 'blädderblock';

$rda{'no'}{'eng'} = 'card';
$rda{'no'}{'fin'} = 'kortti';
$rda{'no'}{'swe'} = 'kort';

$rda{'nr'}{'eng'} = 'object';
$rda{'nr'}{'fin'} = 'objekti';
$rda{'nr'}{'swe'} = 'föremål';

$rda{'nz'}{'eng'} = 'other';
$rda{'nz'}{'fin'} = 'muu';
$rda{'nz'}{'swe'} = 'annan';

$rda{'pp'}{'eng'} = 'microscope slide';
$rda{'pp'}{'fin'} = 'preparaattilasi';
$rda{'pp'}{'swe'} = 'mikroskoperingspreparat';
    
$rda{'pz'}{'eng'} = 'other';
$rda{'pz'}{'fin'} = 'muu';
$rda{'pz'}{'swe'} = 'annan';

$rda{'sb'}{'eng'} = 'audio belt'; # https://www.loc.gov/marc/mac/2019/2019-ft01.html we have none
$rda{'sb'}{'fin'} = 'äänihihna';
$rda{'sb'}{'swe'} = 'ljudslinga';



$rda{'sd'}{'eng'} = 'audio disc';
$rda{'sd'}{'fin'} = 'äänilevy';
$rda{'sd'}{'swe'} = 'ljudskiva';

$rda{'se'}{'eng'} = 'audio cylinder';
$rda{'se'}{'fin'} = 'äänisylinteri';
$rda{'se'}{'swe'} = 'ljudcylinder';

$rda{'sg'}{'eng'} = 'audio cartridge';
$rda{'sg'}{'fin'} = 'äänisilmukkakasetti';
$rda{'sg'}{'swe'} = 'ljudmagasin';

$rda{'si'}{'eng'} = 'sound-track reel';
$rda{'si'}{'fin'} = 'ääniraitakela';
$rda{'si'}{'swe'} = 'filmljudspole';

$rda{'sq'}{'eng'} = 'audio roll';
$rda{'sq'}{'fin'} = 'äänirulla';
$rda{'sq'}{'swe'} = 'ljudrulle';

$rda{'ss'}{'eng'} = 'audiocassette';
$rda{'ss'}{'fin'} = 'äänikasetti';
$rda{'ss'}{'swe'} = 'ljudkassett';

$rda{'st'}{'eng'} = 'audiotape reel';
$rda{'st'}{'fin'} = 'äänikela';
$rda{'st'}{'swe'} = 'ljudspole';

$rda{'sw'}{'eng'} = 'audio wire reel';
$rda{'sw'}{'fin'} = 'äänilankakela';
$rda{'sw'}{'swe'} = 'ljudtråd';

$rda{'sz'}{'eng'} = 'other';
$rda{'sz'}{'fin'} = 'muu';
$rda{'sz'}{'swe'} = 'annan';

$rda{'vc'}{'eng'} = 'video cartridge';
$rda{'vc'}{'fin'} = 'videosilmukkakasetti';
$rda{'vc'}{'swe'} = 'videomagasin';

$rda{'vd'}{'eng'} = 'videodisc';
$rda{'vd'}{'fin'} = 'videolevy';;
$rda{'vd'}{'swe'} = 'videoskiva';

$rda{'vf'}{'eng'} = 'videocassette';
$rda{'vf'}{'fin'} = 'videokasetti';
$rda{'vf'}{'swe'} = 'videokassett';

$rda{'vr'}{'eng'} = 'videotape reel';
$rda{'vr'}{'fin'} = 'videokela';
$rda{'vr'}{'swe'} = 'videospole';

$rda{'vz'}{'eng'} = 'other';
$rda{'vz'}{'fin'} = 'muu';
$rda{'vz'}{'swe'} = 'annan';

$rda{'zu'}{'eng'} = 'unspecified';
$rda{'zu'}{'fin'} = 'määrittelemätön';
$rda{'zu'}{'swe'} = 'ospecificerad';











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
    my ( $from_language, $to_language, $tag, $subfield_codes ) = @_;
    my $val = '';
    my @arr;
    if ( $tag eq '336' ) { @arr = @rdacontent_types; }
    elsif ( $tag eq '337' ) { @arr = @rdamedia_types; }
    elsif ( $tag eq '338' ) { @arr = @rdacarrier_types; }
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


	my $rhs = $subfield_codes eq 'a2b' ? $normalized_code : &normalize_term($to_term);

	$val .= &normalize_term($from_term)."\t| ".$rhs."\n";
    }
    return $val;
    
}




sub create_tbl_file_contents($$$){
    my ( $target_language, $tag, $subfield_codes ) = @_;
    my @rda_types;
    if ( $tag eq '336' ) { @rda_types = @rdacontent_types; }
    elsif ( $tag eq '337' ) { @rda_types = @rdamedia_types; }
    elsif ( $tag eq '338' ) { @rda_types = @rdacarrier_types; }
    else { die(); }
    
    my %mappings;



    
    # Map ISBD/RDA term to RDA term (33X$a) or code (33X$b)
    my $sets = '';
    if ( $subfield_codes eq "b2a" ) {
	foreach my $type ( @rda_types ) {
	    if ( !defined($rda{$type}{$target_language}) ) { die(); }
	    my $code = &normalize_term($type);
	    my $value = &normalize_term($rda{$type}{$target_language});
	    $sets .= "$code\t| $value\n";
	}
    }
    else {
	foreach my $from_language ( @languages ) {
	    $sets .= &map_a2a_or_b($from_language, $target_language, $tag, $subfield_codes);
	}
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
	if ( $tag eq '336' && length($code) != 3 ) { next; }
	if ( $tag eq '337' && length($code) != 1 ) { next; }
	if ( $tag eq '338' && length($code) != 2 ) { next; }
	#print STDERR "CODE $code\n";
	my $isbn_terms = $isbn2rda{$code};
	if ( defined($isbn_terms) ) {
	    my $target_term = $rda{$code}{$target_language};
	    my $rhs = $subfield_codes eq 'a2a' ? &normalize_term($target_term) : &normalize_term($code);
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


if ( 1 ) {
    # Two first lines are code
    if ( $target_subfield_codes eq 'a2a' ) {
	print "Term-to-term mappings for ${target_tag}\$$target_subfield_codes: any-language (ISBD and RDA) terms to $target_language terms\n";
    }
    elsif ( $target_subfield_codes eq 'a2b' ) {
	print "Mappings for ${target_tag}\$$target_subfield_codes any-language (ISBD and RDA) to corresponding RDA code\n";    
    }
    elsif ( $target_subfield_codes eq 'b2a' ) {
	print "Mappings for ${target_tag}\$b code to target language \$a\n";
    }
    else {
	die();
    }
    
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    if ( length($mon) == 1 ) { $mon = "0$mon"; }
    if ( length($mday) == 1 ) { $mday = "0$mday"; }
    #if ( length($hour) == 1 ) { $min = "0$hour"; }
    if ( length($min) == 1 ) { $min = "0$min"; }
    if ( length($sec) == 1 ) { $sec = "0$sec"; }
    
    print "Autogenerated file using $0, $year-$mon-$mday $hour:$min:$sec\n\n";
    
    
    &create_tbl_file_contents($target_language, $target_tag, $target_subfield_codes);
}
else {
    my @array = ();
    if ( $target_tag eq '336' ) {
	@array = @rdacontent_types;
    }
    elsif ( $target_tag eq '337' ) {
	@array = @rdamedia_types;
    }
    elsif ( $target_tag eq '338' ) {
	@array = @rdacarrier_types;
    }
    if ( scalar(@array) == 0 ) { die(); }

    print "[\n";
    for ( my $i=0; $i < scalar(@array); $i++ ) {
	my $type = $array[$i];
	print "  {\"code\": \"$type\"";
	foreach my $language ( @languages ) {
	    if ( defined($rda{$type}{$language}) ) {
		my $val = $rda{$type}{$language};
		print ", \"$language\": \"$val\"";
	    }
	}
	print "  }";
	if ( $i+1 < scalar(@array) ) {
	    print ",";
	}
	print "\n";
    }
    print "]\n";

}
    

