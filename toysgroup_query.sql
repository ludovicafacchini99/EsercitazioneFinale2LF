-- QUERY 1
-- Verificare che i campi definiti come PK siano univoci. In altre parole,
-- scrivi una query per determinare l’univocità dei valori di ciascuna PK (una query per tabella implementata).

-- tabella categorie
SELECT COUNT(ID) AS numero_pk, COUNT(DISTINCT ID) AS numero_pkdistinte FROM categorie;  -- prima soluzione

SELECT ID, COUNT(*) AS univocita
FROM categorie                           -- seconda soluzione
GROUP BY ID                              -- quello che spero di ottenere è la tabella vuota, significa che ID è la PK
HAVING COUNT(*) > 1;                     

-- tabella product
SELECT COUNT(ID) AS numero_pk, COUNT(DISTINCT ID) AS numero_pkdistinte FROM prodotti;  -- prima soluzione

SELECT ID, COUNT(*) AS univocita
FROM prodotti                           -- seconda soluzione
GROUP BY ID                             -- quello che spero di ottenere è la tabella vuota, significa che ID è la PK
HAVING COUNT(*) > 1;                                                 

-- tabella regione
SELECT COUNT(ID) AS numero_pk, COUNT(DISTINCT ID) AS numero_pkdistinte FROM regione;  -- prima soluzione

SELECT ID, COUNT(*) AS univocita
FROM regione                           -- seconda soluzione
GROUP BY ID                             -- quello che spero di ottenere è la tabella vuota, significa che ID è la PK
HAVING COUNT(*) > 1;

-- tabella vendite
SELECT COUNT(ID) AS numero_pk, COUNT(DISTINCT ID) AS numero_pkdistinte FROM vendite;  -- prima soluzione

SELECT ID, COUNT(*) AS univocita
FROM vendite                           -- seconda soluzione
GROUP BY ID                             -- quello che spero di ottenere è la tabella vuota, significa che ID è la PK
HAVING COUNT(*) > 1;


-- QUERY 2
-- Esporre l’elenco delle transazioni indicando nel result set il codice documento, la data, il nome del prodotto,
-- la categoria del prodotto, il nome dello stato, il nome della regione di vendita e un campo booleano valorizzato
-- in base alla condizione che siano passati più di 180 giorni dalla data vendita o meno (>180 -> True, <= 180 -> False).

SELECT vendite.numero_ordine, vendite.data_di_vendita, prodotti.nome AS nome_prodotto,
categorie.nome AS nome_categoria, regione.nome_stato , regione.zona AS nome_zona,
IF (DATEDIFF(CURDATE(), vendite.data_di_vendita) > 180, 'TRUE', 'FALSE') AS '+_di_180giorni_dalla_vendita'
FROM categorie JOIN prodotti
ON categorie.ID = prodotti.categoriaID
JOIN vendite ON prodotti.ID = vendite.prodottoID
JOIN regione ON regione.ID =  vendite.regioneID
ORDER BY vendite.data_di_vendita;


-- 	QUERY 3
-- Esporre l’elenco dei prodotti che hanno venduto, in totale, una quantità maggiore della media delle vendite realizzate 
-- nell’ultimo anno censito.(ogni valore della condizione deve risultare da una query e non deve essere inserito a mano). 
-- Nel result set devono comparire solo il codice prodotto e il totale venduto.

-- ragionamenti prima della query risolutiva
SELECT MAX(YEAR(data_di_vendita)) as ultimo_anno_censito FROM vendite;   -- ultimo_anno_censito
      
SELECT AVG(vendite.quantita) AS quantita_media_venduta
FROM vendite                               -- quantita_media dei prodotti venduti nel 2025
WHERE YEAR(data_di_vendita) = 2025;

-- query risolutiva 
-- io ho intrerpretato la richiesta espondendo i prodotti le cui quantita vendute sono maggiori 
-- della media della quantita totale dei prodotti venduti nell'ultimo anno censito
-- facendo vedere in output il codice prodotto e la rispettiva quantita venduta.
SELECT prodotti.ID AS codice_prodotto, SUM(vendite.quantita) AS quantita_venduta
FROM vendite
JOIN prodotti ON prodotti.ID = vendite.prodottoID     
WHERE YEAR(data_di_vendita) = 2025
GROUP BY prodotti.ID
HAVING quantita_venduta > (SELECT AVG(vendite.quantita) AS quantita_media_venduta FROM vendite)
ORDER BY codice_prodotto;


-- QUERY 4
-- Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno.

SELECT prodotti.ID AS codice_prodotto, prodotti.nome AS nome_prodotto, YEAR(vendite.data_di_vendita) AS anno_di_vendita,
SUM(vendite.prezzo_totale) AS fatturato_totale
FROM prodotti
JOIN vendite ON prodotti.ID = vendite.prodottoID
GROUP BY prodotti.ID, anno_di_vendita
ORDER BY prodotti.ID;


-- QUERY 5
-- Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.

SELECT regione.nome_stato, YEAR(vendite.data_di_vendita) AS anno_di_vendita, SUM(vendite.prezzo_totale) AS fatturato_totale
FROM regione
JOIN vendite ON regione.ID = vendite.regioneID
GROUP BY regione.nome_stato, anno_di_vendita
ORDER BY anno_di_vendita DESC, fatturato_totale DESC;


-- QUERY 6
-- Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?

-- la categoria maggiormente venduta è quella che ha venduto piu prodotti, dunque vado a sommare le quantita
-- dei prodotti venduti e raggruppo per il nome della categoria
SELECT categorie.nome AS nome_categoria, SUM(vendite.quantita) AS sommaQuantita
FROM categorie
JOIN prodotti ON categorie.ID = prodotti.categoriaID
JOIN vendite ON prodotti.ID = vendite.prodottoID
GROUP BY categorie.nome
ORDER BY sommaQuantita DESC 
LIMIT 1;   -- ho inserito LIMIT 1 per ottenere il primo record della select, che corrisponde alla categoria più venduta
           -- avendo ordinato in modo decrescente


-- QUERY 7
-- Rispondere alla seguente domanda: quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.

-- prima soluzione
SELECT prodotti.ID AS codice_prodotto, prodotti.nome AS nome_prodotto
FROM prodotti 
LEFT JOIN vendite   -- left join in modo da prendere in considerazione tutti i prodotti
ON prodotti.ID = vendite.prodottoID 
WHERE vendite.prodottoID IS NULL;

-- seconda soluzione
SELECT prodotti.ID AS codice_prodotto, prodotti.nome AS nome_prodotto
FROM prodotti  
WHERE prodotti.ID NOT IN(SELECT vendite.prodottoID FROM vendite);


-- 	QUERY 8
-- Creare una vista sui prodotti in modo tale da esporre una “versione denormalizzata” 
-- delle informazioni utili (codice prodotto, nome prodotto, nome categoria).

-- da questa vista otteniamo il codice_prodotto, il nome_prodotto e la categoria corrispondente.
CREATE VIEW info_prodotti AS
SELECT prodotti.ID AS codice_prodotto, prodotti.nome AS nome_prodotto, categorie.nome AS nome_categoria
FROM prodotti JOIN categorie 
ON prodotti.categoriaID = categorie.ID
ORDER BY codice_prodotto;

SELECT * FROM info_prodotti;


-- QUERY 9
-- Creare una vista per le informazioni geografiche.

-- ho pensato di creare una view che restituisca per ogni stato, la zona corrispondente,
-- i nomi dei prodotti venduti in quello stato, la categoria di appartenenza del prodotto,
-- il fatturato totale delle vendite del prodotto in quello stato e la quantita totale del prodotto venduto.
CREATE VIEW info_geografiche AS
SELECT regione.nome_stato AS nome_stato, regione.zona AS nome_zona, prodotti.nome AS nome_prodotto,
categorie.nome AS nome_categoria, SUM(vendite.prezzo_totale) AS fatturato_totale, SUM(vendite.quantita) AS quantita_totale
FROM regione
JOIN vendite ON regione.ID = vendite.regioneID
JOIN prodotti ON vendite.prodottoID = prodotti.ID
JOIN categorie ON prodotti.categoriaID = categorie.ID
GROUP BY nome_stato, nome_zona, nome_prodotto, nome_categoria
ORDER BY nome_stato;

SELECT * FROM info_geografiche;