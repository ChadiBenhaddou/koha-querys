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

my $dbh = C4::Context->dbh;

my $sql = qq{  SELECT bm.biblionumber, EXTRACTVALUE(bm.metadata, '//controlfield[\@tag="001"]') as N_controle,
CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="c"]'), ' م') as zone_260_c,
CONCAT(EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="g"]'),' هـ') as zone_260_g
from biblio_metadata bm join items i
on bm.biblionumber = i.biblionumber
WHERE i.itype in ('MANU', 'IMPL') and EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="c"]') <> '' and
EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="g"]') <> '' and
EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="c"]') not LIKE "%م%" and
EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="g"]') NOT LIKE "%هـ%" and
EXTRACTVALUE(metadata, '//datafield[\@tag="260"]/subfield[\@code="c"]') not LIKE "%[%" ; };

my $sth = $dbh->prepare($sql);
$sth->execute();

my @templates;
while (my $template = $sth->fetchrow_hashref()) {

    my $sql_update1 = qq{
           UPDATE marc_modification_template_actions set field_value = ? where template_id = 34 and  from_subfield = 'c';
        };

    my $sth_update1 = $dbh->prepare($sql_update1);
    $sth_update1->execute($template->{'zone_260_c'});


    my $sql_update2 = qq{
           UPDATE marc_modification_template_actions set field_value = ? where template_id = 34 and from_subfield = 'g';
        };

    my $sth_update2 = $dbh->prepare($sql_update2);
    $sth_update2->execute($template->{'zone_260_g'});

     my $mmtid = 34;
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
            WHERE template_id = 34;
        };

        my $sth_reset = $dbh->prepare($sql_reset);
        $sth_reset->execute();

    
}
