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

my $sql = qq{SELECT EXTRACTVALUE(metadata, '//controlfield[\@tag="001"]') as tag001,
           biblionumber, 
           EXTRACTVALUE(metadata, '//datafield[\@tag="765"]/subfield[\@code="w"]') as ControleNumber
    FROM biblio_metadata 
    WHERE biblio_metadata.`timestamp` >= CURDATE()
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="765"]/subfield[\@code="w"]') <> '' 
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="765"]/subfield[\@code="a"]') = ''  
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="765"]/subfield[\@code="d"]') = ''
      AND EXTRACTVALUE(metadata, '//datafield[\@tag="765"]/subfield[\@code="t"]') = ''; };

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
        SELECT biblionumber 
        FROM biblio_metadata 
        WHERE EXTRACTVALUE(metadata, '//controlfield[\@tag="001"]') = ?;
    };

    my $sth1 = $dbh->prepare($sql1);
    $sth1->execute($template->{'ControleNumber'});
    
    if (my $row = $sth1->fetchrow_hashref()) {
                    print "row 1";

        my $biblionumber = $row->{'biblionumber'};

        # SQL for the update of marc_modification_template_actions
        my $sql_update1 = qq{
           UPDATE marc_modification_template_actions m, biblio_metadata b
           SET m.field_value = CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="d"]'), ' -')
           WHERE m.template_id = 26 
           AND m.from_subfield = 'a' 
           AND CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="d"]')) <> '' 
           AND b.biblionumber = ?;
        };

        my $sth_update1 = $dbh->prepare($sql_update1);
        $sth_update1->execute($biblionumber);

        # Second update query
        my $sql_update2 = qq{
            UPDATE marc_modification_template_actions m, biblio_metadata b
            SET m.field_value = CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="b"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="c"]'), ' -')
            WHERE m.template_id = 26 
            AND m.from_subfield = 'd' 
            AND CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="b"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="c"]')) <> ''
            AND b.biblionumber = ?;
        };

        my $sth_update2 = $dbh->prepare($sql_update2);
        $sth_update2->execute($biblionumber);

        # Third update query
        my $sql_update3 = qq{
            UPDATE marc_modification_template_actions m, biblio_metadata b
            SET m.field_value = CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="245"]/subfield[\@code="a"]'), ' -')
            WHERE m.template_id = 26 
            AND m.from_subfield = 't' 
            AND EXTRACTVALUE(metadata, '//datafield[\@tag="245"]/subfield[\@code="a"]') <> ''
            AND b.biblionumber = ?;
        };

        my $sth_update3 = $dbh->prepare($sql_update3);
        $sth_update3->execute($biblionumber);

        # Fourth update query
        my $sql_update4 = qq{
            UPDATE marc_modification_template_actions m, biblio_metadata b
            SET m.field_value = EXTRACTVALUE(metadata, '//datafield[\@tag="020"]/subfield[\@code="a"]')
            WHERE m.template_id = 26 
            AND m.from_subfield = 'z' 
            AND EXTRACTVALUE(metadata, '//datafield[\@tag="020"]/subfield[\@code="a"]') <> ''
            AND b.biblionumber = ?;
        };

        my $sth_update4 = $dbh->prepare($sql_update4);
        $sth_update4->execute($biblionumber);

        # Apply modifications using Koha's API
        my $mmtid = 26;
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
            SET field_value = '' 
            WHERE template_id = 26;
        };

        my $sth_reset = $dbh->prepare($sql_reset);
        $sth_reset->execute();

        #******************************************************************************************** 767 *****************************
        # SQL for the update of marc_modification_template_actions

my $sql22 = qq{
    SELECT EXTRACTVALUE(metadata, '//datafield[\@tag="767"]/subfield[\@code="w"]') as fisControle
    FROM biblio_metadata 
    WHERE biblionumber = ?;
};

my $sth22 = $dbh->prepare($sql22);
$sth22->execute($biblionumber);
my $row = $sth22->fetchrow_hashref();  # Added semicolon

if ($row->{'fisControle'} ne '') { 
    print "row 2";

    my $sql25 = qq{
        SELECT 
            CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="d"]')) as a,
            CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="b"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="c"]')) as d,
            EXTRACTVALUE(metadata, '//datafield[\@tag="245"]/subfield[\@code="a"]') as t,
            EXTRACTVALUE(metadata, '//datafield[\@tag="020"]/subfield[\@code="a"]') as z,
            EXTRACTVALUE(metadata, '//controlfield[\@tag="001"]') as w 
        FROM biblio_metadata
        WHERE biblionumber  =  ?;
    };

    my $sth25 = $dbh->prepare($sql25);
    $sth25->execute($template->{'biblionumber'});

    if (my $row25 = $sth25->fetchrow_hashref()) {
        my $a = $row25->{'a'};
        my $d = $row25->{'d'};
        my $t = $row25->{'t'};
        my $z = $row25->{'z'};
        my $w = $row25->{'w'};

        my $sql23 = qq{
            UPDATE biblio_metadata
            SET metadata = CONCAT(
                SUBSTRING(metadata, 1, LOCATE('</datafield>', metadata, LOCATE('<datafield tag="767"', metadata)) + LENGTH('</datafield>')),
                '  <datafield tag="767" ind1=" " ind2=" ">
                <subfield code="a">', ?, '</subfield>
                <subfield code="d">', ?, '</subfield>
                <subfield code="t">', ?, '</subfield>
                <subfield code="z">', ?, '</subfield>
                <subfield code="w">', ?, '</subfield>
              </datafield>',
                SUBSTRING(metadata, LOCATE('</datafield>', metadata, LOCATE('<datafield tag="767"', metadata)) + LENGTH('</datafield>'))
            )
            WHERE biblionumber = ? ;
        };

        my $sth23 = $dbh->prepare($sql23);
        $sth23->execute($a, $d, $t, $z,$w, $biblionumber);
    }
} else {
        print "row 3";

     my $sql_update5 = qq{
           UPDATE marc_modification_template_actions m, biblio_metadata b
           SET m.field_value = CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="d"]'))
           WHERE m.template_id = 27 
           AND m.from_subfield = 'a' 
           AND CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="d"]')) <> '' 
           AND b.biblionumber = ?;
        };

        my $sth_update5 = $dbh->prepare($sql_update5);
        $sth_update5->execute($template->{'biblionumber'});

        # Second update query
        my $sql_update6 = qq{
            UPDATE marc_modification_template_actions m, biblio_metadata b
            SET m.field_value = CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="b"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="c"]'))
            WHERE m.template_id = 27 
            AND m.from_subfield = 'd' 
            AND CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="a"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="b"]'), ' ', EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="c"]')) <> ''
            AND b.biblionumber = ?;
        };

        my $sth_update6 = $dbh->prepare($sql_update6);
        $sth_update6->execute($template->{'biblionumber'});

        # Third update query
        my $sql_update7 = qq{
            UPDATE marc_modification_template_actions m, biblio_metadata b
            SET m.field_value = CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="245"]/subfield[\@code="a"]'))
            WHERE m.template_id = 27 
            AND m.from_subfield = 't' 
            AND EXTRACTVALUE(metadata, '//datafield[\@tag="245"]/subfield[\@code="a"]') <> ''
            AND b.biblionumber = ?;
        };

        my $sth_update7 = $dbh->prepare($sql_update7);
        $sth_update7->execute($template->{'biblionumber'});

        # Fourth update query
        my $sql_update8 = qq{
            UPDATE marc_modification_template_actions m, biblio_metadata b
            SET m.field_value = EXTRACTVALUE(metadata, '//datafield[\@tag="020"]/subfield[\@code="a"]')
            WHERE m.template_id = 27 
            AND m.from_subfield = 'z' 
            AND EXTRACTVALUE(metadata, '//datafield[\@tag="020"]/subfield[\@code="a"]') <> ''
            AND b.biblionumber = ?;
        };

        my $sth_update8 = $dbh->prepare($sql_update8);
        $sth_update8->execute($template->{'biblionumber'});

        my $sql_update9 = qq{
            UPDATE marc_modification_template_actions m, biblio_metadata b
            SET m.field_value = EXTRACTVALUE(metadata, '//controlfield[\@tag="001"]')
            WHERE m.template_id = 27 
            AND m.from_subfield = 'w' 
            AND b.biblionumber = ?;
        };

        my $sth_update9 = $dbh->prepare($sql_update9);
        $sth_update9->execute($template->{'biblionumber'});

        # Apply modifications using Koha's API
        my $mmtid2 = 27;
        my $args2 = {
            source       => 'batchmod',
            categorycode => 'S',
            userid       => 1
        };

        my $biblio2 = Koha::Biblios->find($biblionumber);
        my $record2 = $biblio2->metadata->record;
        C4::MarcModificationTemplates::ModifyRecordWithTemplate($mmtid2, $record2);
        my $frameworkcode2 = C4::Biblio::GetFrameworkCode($biblionumber);
        C4::Biblio::ModBiblio($record2, $biblionumber, $frameworkcode2, {
            overlay_context   => $args2->{overlay_context},
            skip_record_index => 1,
        });

        # Reset field_value for the template
        my $sql_reset2 = qq{
            UPDATE marc_modification_template_actions 
            SET field_value = '' 
            WHERE template_id = 27;
        };

        my $sth_reset2 = $dbh->prepare($sql_reset2);
        $sth_reset2->execute();
}

       
    }
}
