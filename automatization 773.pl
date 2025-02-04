#!/usr/bin/perl

use Modern::Perl;
use strict;
use warnings;
use lib '/usr/share/koha/intranet/cgi-bin';
use C4::Context;
use C4::Biblio;
use C4::MarcModificationTemplates qw(GetModificationTemplates ModifyRecordWithTemplate);
use MARC::Record;
use Try::Tiny;
use Data::Dumper;

# Configuration
=head2 
my $mmtid = 11;
my $biblionumber = 855862;
my $args = {
                source       => 'batchmod',
                categorycode => 'S',
                userid       => 1
            };

 my $biblio = Koha::Biblios->find($biblionumber);
            my $record = $biblio->metadata->record;
            C4::MarcModificationTemplates::ModifyRecordWithTemplate( $mmtid, $record );
            my $frameworkcode = C4::Biblio::GetFrameworkCode( $biblionumber );
            C4::Biblio::ModBiblio( $record, $biblionumber, $frameworkcode, {
                overlay_context   => $args->{overlay_context},
                skip_record_index => 1,
            }); 
=cut
my $dbh = C4::Context->dbh;

my $sql = qq{  SELECT 
           biblionumber, 
           EXTRACTVALUE(metadata, '//datafield[\@tag="773"]/subfield[\@code="i"]') as codebar, `timestamp`
    FROM biblio_metadata 
    WHERE
    biblio_metadata.`timestamp` >= CURDATE()
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="773"]/subfield[\@code="i"]') <> '' 
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="773"]/subfield[\@code="g"]') = ''
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="773"]/subfield[\@code="a"]') = ''
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="773"]/subfield[\@code="d"]') = ''  
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="773"]/subfield[\@code="o"]') = ''
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="773"]/subfield[\@code="t"]') = ''; };

my $sth = $dbh->prepare($sql);
$sth->execute();

my @templates;
while (my $template = $sth->fetchrow_hashref()) {

    # Uncomment if you need biblionumber or tag001
    # print $template->{'ControleNumber'}, "\n";
    # print $template->{'biblionumber'}, "\n";
    # print $template->{'tag001'}, "\n";

    # Prepare the first query to fetch biblionumber
    my $sql1 = qq{
       SELECT 
    CONCAT(
        ExtractValue(biblio_metadata.metadata, '//datafield[\@tag="245"]/subfield[\@code="a"]'),
        ExtractValue(biblio_metadata.metadata, '//datafield[\@tag="245"]/subfield[\@code="b"]'),
        ' ',
        ExtractValue(biblio_metadata.metadata, '//datafield[\@tag="260"]/subfield[\@code="a"]'), ' -'
    ) AS subfield_t,
        items.enumchron
   AS subfield_g,
    CONCAT(
        CASE 
            WHEN SUBSTRING(ExtractValue(biblio_metadata.metadata, '//controlfield[\@tag="008"]'), 8, 4) = 'ara' 
            THEN 'رقم ترتيب المجلة : '
            ELSE 'cote de la revue : '
        END,
        items.itemcallnumber, ' -'
    ) AS subfield_o,
    EXTRACTVALUE(biblio_metadata.metadata, '//controlfield[\@tag="001"]') AS subfield_w
FROM items
JOIN biblio_metadata ON items.biblionumber  = biblio_metadata.biblionumber 
WHERE items.barcode = ? LIMIT 1;
    };

    my $sth1 = $dbh->prepare($sql1);
    $sth1->execute($template->{'codebar'});
    
    if (my $row = $sth1->fetchrow_hashref()) {
                    print "row 1";

        my $barcode = $template->{'codebar'};


        my $t = $row->{'subfield_t'};
        my $g = $row->{'subfield_g'};
        my $o = $row->{'subfield_o'};
        my $w = $row->{'subfield_w'};

        # SQL for the update of marc_modification_template_actions
        my $sql_update1 = qq{
           UPDATE marc_modification_template_actions set field_value = ? , conditional_value = ? where template_id = 28 and from_subfield = 't';
        };

        my $sth_update1 = $dbh->prepare($sql_update1);
        $sth_update1->execute($t, $barcode);

        # Second update query
        my $sql_update2 = qq{
            UPDATE marc_modification_template_actions set field_value = ? , conditional_value = ? where template_id = 28 and from_subfield = 'g';

        };

        my $sth_update2 = $dbh->prepare($sql_update2);
        $sth_update2->execute($g, $barcode);

        # Third update query
        my $sql_update3 = qq{
            UPDATE marc_modification_template_actions set field_value = ? , conditional_value = ? where template_id = 28 and from_subfield = 'o';

        };

        my $sth_update3 = $dbh->prepare($sql_update3);
        $sth_update3->execute($o, $barcode);

        # Fourth update query
        my $sql_update4 = qq{
            UPDATE marc_modification_template_actions set field_value = ? , conditional_value = ? where template_id = 28 and from_subfield = 'w';

        };

        my $sth_update4 = $dbh->prepare($sql_update4);
        $sth_update4->execute($w, $barcode);

        my $sql_update5 = qq{
            UPDATE marc_modification_template_actions set conditional_value = ? where template_id = 28 and from_subfield = 'i';

        };

        my $sth_update5 = $dbh->prepare($sql_update5);
        $sth_update5->execute($barcode);

        # Apply modifications using Koha's API
        my $mmtid = 28;
        my $args = {
            source       => 'batchmod',
            categorycode => 'S',
            userid       => 1
        };

        my $biblio = Koha::Biblios->find($template->{'biblionumber'});
        my $record = $biblio->metadata->record;
        C4::MarcModificationTemplates::ModifyRecordWithTemplate($mmtid, $record);
        my $frameworkcode = C4::Biblio::GetFrameworkCode($template->{'biblionumber'});
        C4::Biblio::ModBiblio($record, $template->{'biblionumber'}, $frameworkcode, {
            overlay_context   => $args->{overlay_context},
            skip_record_index => 1,
        });

        # Reset field_value for the template
        my $sql_reset = qq{
            UPDATE marc_modification_template_actions 
            SET field_value = '' , conditional_value = 'code'
            WHERE template_id = 28;
        };

        my $sth_reset = $dbh->prepare($sql_reset);
        $sth_reset->execute();
       
    }
}
