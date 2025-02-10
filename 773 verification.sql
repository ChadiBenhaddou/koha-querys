SELECT b.biblionumber 
FROM biblio_metadata b 
JOIN biblio_metadata bm ON ExtractValue(b.metadata, '//controlfield[@tag="001"]') = 
    ExtractValue(bm.metadata, '//datafield[@tag="773"]/subfield[@code="w"]') 
WHERE CONCAT(
    ExtractValue(b.metadata, '//datafield[@tag="245"]/subfield[@code="a"]'),
    ExtractValue(b.metadata, '//datafield[@tag="245"]/subfield[@code="b"]'),
    ' ',
    ExtractValue(b.metadata, '//datafield[@tag="260"]/subfield[@code="a"]'), 
    ' -'
) = ExtractValue(bm.metadata, '//datafield[@tag="773"]/subfield[@code="t"]');
