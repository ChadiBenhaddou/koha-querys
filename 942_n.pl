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



my $sql = qq{   select * from biblio_show where updated_at >  '2025-02-24 01:00:44'; };

my $sth = $dbh->prepare($sql);
$sth->execute();

my @templates;
while (my $template = $sth->fetchrow_hashref()) {

    my $sql_update1 = qq{
           UPDATE marc_modification_template_actions set field_value = ? where template_id = 36 and  from_subfield = 'n';
        };

    my $sth_update1 = $dbh->prepare($sql_update1);
    $sth_update1->execute($template->{'noShow'});

     my $mmtid = 36;
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

        print "Successfully updated biblio record " . $template->{'biblionumber'} . "\n";


        # Reset field_value for the template
        my $sql_reset = qq{
            UPDATE marc_modification_template_actions 
            SET field_value = '' 
            WHERE template_id = 36;
        };

        my $sth_reset = $dbh->prepare($sql_reset);
        $sth_reset->execute();
    
}
