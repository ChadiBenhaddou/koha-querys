SELECT EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]') ,EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="9"]')
from biblio_metadata bm WHERE EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="9"]') = '' and
EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]') <> '';  #20,496
SELECT * from auth_header ah WHERE authid = 380116;
SELECT biblionumber, EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]') as zone_a_biblio,
EXTRACTVALUE(ah.marcxml , '//datafield[\@tag="100"]/subfield[\@code="a"]') as zone_a_auth  ,EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="9"]') as old_9, ah.authid as new_9
from biblio_metadata bm join auth_header ah on EXTRACTVALUE(bm.metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]') = EXTRACTVALUE(ah.marcxml , '//datafield[\@tag="100"]/subfield[\@code="a"]')  WHERE  EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]') <> '' and EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="9"]') <> '' AND
EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="9"]') not in (SELECT authid from auth_header) ; #4,731
SELECT
   biblionumber,
   EXTRACTVALUE(metadata, '//datafield[@tag="100"]/subfield[@code="a"]') AS zone_a_biblio,
   EXTRACTVALUE(metadata, '//datafield[@tag="100"]/subfield[@code="9"]') AS old_9,
    EXTRACTVALUE(metadata, '//datafield[@tag="100"]/subfield[@code="d"]') as zon_biblio_d
FROM
   biblio_metadata
WHERE EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="a"]') <> '' and
EXTRACTVALUE(metadata, '//datafield[\@tag="100"]/subfield[\@code="9"]') <> '' and
   EXTRACTVALUE(metadata, '//datafield[@tag="100"]/subfield[@code="9"]')  IN
   (SELECT authid FROM auth_header);
SELECT z.*, ah.authid from zon100 as z join auth_header ah on z.zone_a_biblio = EXTRACTVALUE(ah.marcxml , '//datafield[\@tag="100"]/subfield[\@code="a"]') ;
SELECT z.*, ah.authid, EXTRACTVALUE(ah.marcxml , '//datafield[\@tag="100"]/subfield[\@code="d"]')è- from zon100 as z , auth_header ah WHERE z.zone_a_biblio = EXTRACTVALUE(ah.marcxml , '//datafield[\@tag="100"]/subfield[\@code="a"]') and EXTRACTVALUE(ah.marcxml , '//datafield[\@tag="100"]/subfield[\@code="d"]') = z.zon_biblio_d ;
TRUNCATE zon100;
CREATE TABLE koha_library.zon100 (
	biblionumber int(11) NULL,
	zone_a_biblio varchar(255) NULL,
	old_9 varchar(255) NULL
);
TRUNCATE auth_biblio_auth_new2 ;
SELECT * from auth_biblio_auth_new WHERE a_part_bilio <> '' and (a_part_bilio <> a_part_auth or d_part_bilio <> d_part_auth );
SELECT * from auth_biblio_auth_new2 WHERE a_part_bilio <> '' and (a_part_bilio <> a_part_auth or d_part_bilio <> d_part_auth ) and N_controle = "861082";
SELECT * from auth_biblio_auth_new2 aban WHERE N_controle = "861082 a810792";
SELECT kensam3ek
   EXTRACTVALUE(b.metadata, '//controlfield[@tag="001"]') AS N_controle,
   EXTRACTVALUE(b.metadata, '//datafield[@tag="100"]/subfield[@code="9"]') AS authid,
   EXTRACTVALUE(b.metadata, '//datafield[@tag="100"]/subfield[@code="a"]') AS a_part_bilio,
   EXTRACTVALUE(b.metadata, '//datafield[@tag="100"]/subfield[@code="d"]') AS d_part_bilio,
   EXTRACTVALUE(ah.marcxml, '//datafield[@tag="100"]/subfield[@code="a"]') AS a_part_auth,
   EXTRACTVALUE(ah.marcxml, '//datafield[@tag="100"]/subfield[@code="d"]') AS d_part_auth
FROM
   biblio_metadata b
JOIN
   auth_header ah ON EXTRACTVALUE(b.metadata, '//datafield[@tag="100"]/subfield[@code="9"]') = ah.authid;
SELECT
   EXTRACTVALUE(b.metadata, '//controlfield[@tag="001"]') AS N_controle,
   EXTRACTVALUE(b.metadata, '//datafield[@tag="700"]/subfield[@code="9"][1]') AS authid,
   EXTRACTVALUE(b.metadata, '//datafield[@tag="700"]/subfield[@code="a"][1]') AS a_part_bilio,
   EXTRACTVALUE(b.metadata, '//datafield[@tag="700"]/subfield[@code="d"][1]') AS d_part_bilio,
   EXTRACTVALUE(ah.marcxml, '//datafield[@tag="100"]/subfield[@code="a"]') AS a_part_auth,
   EXTRACTVALUE(ah.marcxml, '//datafield[@tag="100"]/subfield[@code="d"]') AS d_part_auth
FROM
   biblio_metadata b
JOIN
   auth_header ah ON EXTRACTVALUE(b.metadata, '//datafield[@tag="700"]/subfield[@code="9"][1]') = ah.authid;
#37361
SELECT * from biblio b ;
SELECT
   EXTRACTVALUE(b.metadata, '//controlfield[@tag="001"]') AS N_controle,
   EXTRACTVALUE(b.metadata, '//datafield[@tag="700"][14]/subfield[@code="9"]') AS authid,
   EXTRACTVALUE(b.metadata, '//datafield[@tag="700"][14]/subfield[@code="a"]') AS a_part_bilio_700_5,
   EXTRACTVALUE(b.metadata, '//datafield[@tag="700"][14]/subfield[@code="d"]') AS d_part_bilio_700_5,
   EXTRACTVALUE(ah.marcxml, '//datafield[@tag="100"]/subfield[@code="a"]') AS a_part_auth,
   EXTRACTVALUE(ah.marcxml, '//datafield[@tag="100"]/subfield[@code="d"]') AS d_part_auth
FROM
   biblio_metadata b
JOIN
   auth_header ah ON EXTRACTVALUE(b.metadata, '//datafield[@tag="700"][14]/subfield[@code="9"]') = ah.authid
WHERE
   EXTRACTVALUE(b.metadata, '//datafield[@tag="700"][14]/subfield[@code="a"]') <> ''
   AND (
       EXTRACTVALUE(b.metadata, '//datafield[@tag="700"][14]/subfield[@code="a"]') <> EXTRACTVALUE(ah.marcxml, '//datafield[@tag="100"]/subfield[@code="a"]')
       OR
       EXTRACTVALUE(b.metadata, '//datafield[@tag="700"][14]/subfield[@code="d"]') <> EXTRACTVALUE(ah.marcxml, '//datafield[@tag="100"]/subfield[@code="d"]')
   );
UPDATE auth_biblio_auth_new a join n_9 n on a.authId = n.extracted_number SET a.N_controle = n.flexible_key ;
);
SELECT * FROM action_logs al WHERE al.info LIKE "%000002396873%";
SELECT * FROM action_logs al WHERE al.info
LIKE '%000007969362%'
  OR al.info LIKE '%000007969355%'
  OR al.info LIKE '%000007969027%'
OR al.info LIKE '%000007969249%';
SELECT * from idsLogs;
TRUNCATE idsLogs;
SELECT biblionumber, EXTRACTVALUE(metadata, '//datafield[@tag="773"]/subfield[@code="i"]')  as codebar from biblio_metadata WHERE EXTRACTVALUE(metadata, '//datafield[@tag="773"]/subfield[@code="i"]') <> '' AND
LENGTH(EXTRACTVALUE(metadata, '//datafield[@tag="773"]/subfield[@code="i"]')) = 12;
INSERT INTO zebraqueue (biblio_auth_number, operation, server) SELECT DISTINCT biblionumber, 'specialUpdate', 'biblioserver' from items WHERE barcode in (000007969362,000007969355,000007969027,000007969249);
select * from serial where biblionumber =204047 and publisheddate like '%1987%';
SELECT * from serialitems s ;
select itemnumber, barcode, itemcallnumber, enumchron  from items where biblionumber =204047;
SELECT itemnumber, barcode, itemcallnumber, enumchron
FROM items
WHERE enumchron  LIKE '%(%[0-9]%)%';
SELECT * from items i WHERE barcode =  	 	000002396873;
SELECT DISTINCT m.biblionumber
from manu_biblio m join items i
on m.biblionumber = i.biblionumber
WHERE i.itype <> 'MANU'  and i.itype <> 'MANU_COPY';
SELECT * from manu_biblio mb WHERE biblionumber not in (SELECT biblionumber from biblio );
SELECT * from manu_biblio mb WHERE biblionumber = "a730967";
s
SELECT EXTRACTVALUE(bm.metadata, '//controlfield[@tag="001"]') as N_controle,
CONCAT(EXTRACTVALUE(metadata, '//datafield[@tag="260"]/subfield[@code="c"]'), ' م') as zone_260_c,
CONCAT(EXTRACTVALUE(metadata, '//datafield[@tag="260"]/subfield[@code="g"]'),' هـ') as zone_260_g
from biblio_metadata bm join items i
on bm.biblionumber = i.biblionumber
WHERE i.itype in ('MANU', 'IMPL') and EXTRACTVALUE(metadata, '//datafield[@tag="260"]/subfield[@code="c"]') <> '' and
EXTRACTVALUE(metadata, '//datafield[@tag="260"]/subfield[@code="g"]') <> '' and
EXTRACTVALUE(metadata, '//datafield[@tag="260"]/subfield[@code="c"]') not LIKE "%م%" and
EXTRACTVALUE(metadata, '//datafield[@tag="260"]/subfield[@code="g"]') NOT LIKE "%هـ%" and
EXTRACTVALUE(metadata, '//datafield[@tag="260"]/subfield[@code="c"]') not LIKE "%[%" ;
;

