#selection the combination beween serail and items

SELECT i.barcode, i.itemcallnumber, i.enumchron 
FROM items i join serialitems s on i.itemnumber = s.itemnumber JOIN serial s2 on s.serialid = s2.serialid 
WHERE i.enumchron REGEXP '^ع\\. *\\([0-9]{4}\\)$';

#synohony selection 
select items.id, items.call_sequence, callnum.shelving_key, callnum.call_sequence, items.catalog_key, callnum.catalog_key from items, callnum 
where items.catalog_key=callnum.catalog_key and items.call_sequence=callnum.call_sequence;
