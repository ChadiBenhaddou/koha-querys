/* SQL REPORT */
SELECT
    ExtractValue(bm.metadata, '//datafield[@tag="245"]/*') AS 'Titre (245)',
    ExtractValue(bm.metadata, '//datafield[@tag="260"]/*') AS 'Éditeur (260)',
    SUBSTRING(ExtractValue(bm.metadata, '//controlfield[@tag="008"]'), 36, 3) AS 'Langue du document',
    ExtractValue(bm.metadata, '//datafield[@tag="072"]/*') AS 'Domaine de recherche (072)',
    aq.created_by AS 'Créé par',
    aq.invoiceid AS 'Numéro de facture',
    ROUND(aq.listprice, 2) AS 'Prix facturé en devise',
    ROUND(aq.invoice_unitprice * (
        SELECT c.rate 
        FROM currency c 
        WHERE c.currency = aq.invoice_currency 
        LIMIT 1
    ), 2) AS 'Prix facturé en dirham'
FROM
    biblio_metadata bm
JOIN
    aqorders aq ON aq.biblionumber = bm.biblionumber join invoice i on aq.invoiceid = i.invoiceid
ORDER BY
    aq.datereceived DESC, aq.ordernumber;
