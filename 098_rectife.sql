SELECT 
    au.authid,
    TRIM(CONCAT(
        ExtractValue(au.marcxml, '//datafield[@tag="100"]/subfield[@code="a"]'), ' ',
        ExtractValue(au.marcxml, '//datafield[@tag="100"]/subfield[@code="d"]'), ' ',
        ExtractValue(au.marcxml, '//datafield[@tag="100"]/subfield[@code="c"]')
    )) as zon_100,
    TRIM(CONCAT(
        ExtractValue(au.marcxml, '//datafield[@tag="700"]/subfield[@code="a"]'), ' ',
        ExtractValue(au.marcxml, '//datafield[@tag="700"]/subfield[@code="d"]'), ' ',
        ExtractValue(au.marcxml, '//datafield[@tag="700"]/subfield[@code="c"]')
    )) as zon_700, 
    a.authid,
    CONCAT(au.authid,'-',a.authid) as zone_098,
    ExtractValue(au.marcxml, '//datafield[@tag="098"]/subfield[@code="a"]')
FROM 
    auth_header au 
    JOIN auth_098 a ON TRIM(CONCAT(
        ExtractValue(au.marcxml, '//datafield[@tag="700"]/subfield[@code="a"]'), ' ',
        ExtractValue(au.marcxml, '//datafield[@tag="700"]/subfield[@code="d"]'), ' ',
        ExtractValue(au.marcxml, '//datafield[@tag="700"]/subfield[@code="c"]')
    )) = a.zon_100 
WHERE 
    authtypecode = 'PERSO_NAME'
    AND LENGTH(ExtractValue(au.marcxml, '//datafield[@tag="100"]/subfield[@code="a"]')) > 0
    AND LENGTH(ExtractValue(au.marcxml, '//datafield[@tag="700"]/subfield[@code="a"]')) > 0;
