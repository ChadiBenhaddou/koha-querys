#selection the combination beween serail and items

SELECT i.barcode, i.itemcallnumber, i.enumchron 
FROM items i join serialitems s on i.itemnumber = s.itemnumber JOIN serial s2 on s.serialid = s2.serialid 
WHERE i.enumchron REGEXP '^ع\\. *\\([0-9]{4}\\)$';
