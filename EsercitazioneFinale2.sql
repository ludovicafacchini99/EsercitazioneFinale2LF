CREATE DATABASE esfin2;
USE esfin2;

-- question 4
CREATE TABLE prodotti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    prezzo DECIMAL(10,2) NOT NULL,
    quantita INT    -- quantita dei prodotti per categoria
);

INSERT INTO prodotti (nome, categoria, prezzo, quantita) VALUES
('Laptop', 'Elettronica', 1200.99, 10),
('Smartphone', 'Elettronica', 799.49, 25),
('Frigorifero', 'Elettrodomestici', 499.99, 5),
('Tavolo', 'Arredamento', 150.00, 12),
('Sedia', 'Arredamento', 75.50, 30),
('Libro', 'Cultura', 19.99, 50);

SELECT * FROM prodotti;

-- vorrei sapere il numero totale di prodotti per categoria
SELECT categoria,  SUM(quantita) AS quantita_totale
FROM prodotti
GROUP BY categoria;

-- question 6
CREATE TABLE prodotti2 (
ID INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(20) NOT NULL,
categoria VARCHAR(30),
prezzo DECIMAL(8,2)
);

CREATE TABLE ordini (
ID INT AUTO_INCREMENT PRIMARY KEY,
numero_ordine VARCHAR(15) NOT NULL,
data_ordine DATE,
quantita INT,
prodID INT,
FOREIGN KEY (prodID) REFERENCES prodotti2(ID)
);

INSERT INTO prodotti2 (nome, categoria, prezzo) VALUES
('Penna', 'Cancelleria', 2.50),
('Matita', 'Cancelleria', 1.20),
('Quaderno', 'Cartoleria', 4.50),
('Zaino', 'Cartoleria',	20.0),
('Cartella', 'Cancelleria', 14.50);

SELECT * FROM prodotti2;

INSERT INTO ordini (numero_ordine, data_ordine, quantita, prodID) VALUES
('OR1001', '2025-02-20', 3, 1),
('OR1002', '2025-02-21', 2, 2),
('OR1003', '2025-02-22', 1, 3),
('OR1004', '2025-02-23', 4, 5),
('OR1005', '2025-02-23', 1, 4);

SELECT * FROM ordini;

-- vogliamo la quantita del prodotto (nome prodotto, quantità) 
-- per i prodotti della categoria "Cancelleria" e con prezzo maggiore di 5.

-- risoluzione con la join
SELECT prodotti2.nome, ordini.quantita
FROM ordini 
JOIN prodotti2  ON ordini.prodID = prodotti2.ID
WHERE prodotti2.categoria = 'Cancelleria' AND prodotti2.prezzo > 5;

-- risoluzione con la subquery (ho bisogno di due subquery)
SELECT (SELECT nome FROM prodotti2 WHERE prodotti2.ID = ordini.prodID
        AND categoria = 'Cancelleria' AND prezzo > 5) AS nome_prodotto, quantita
FROM ordini 
WHERE prodID IN ( SELECT ID FROM prodotti2
                  WHERE categoria = 'Cancelleria' AND prezzo > 5);



-- question 8
SELECT YEAR('2025-02-21') AS anno;
SELECT YEAR(CURDATE()) AS anno_data_corrente;
SELECT YEAR(NOW()) AS anno_data_odierna;

-- question 9
SELECT (15>10 AND 9>3) AS provaAND; -- restituisce 1 (true) perchè entrambe sono true
SELECT (5>10 AND 9>3) AS provaAND2; -- restituisce 0 (false) perchè una condizione non è true
SELECT (5>10 AND 9>11) AS provaAND3; -- restituisce 0 (false) perchè entrambe sono false

SELECT (15>10 OR 9>3) AS provaOR; -- restituisce 1 (true) perchè entrambe sono true
SELECT (5>10 OR 9>3) AS provaOR2; -- restituisce 1 (true) perchè alemeno una delle due condizione è true
SELECT (5>10 OR 9>11) AS provaOR3; -- restituisce 0 (false) perchè entrambe sono false


-- esempio di AND e OR applicati alla tabella prodotti

-- trovare un prodotto con un prezzo > 100 e una quantità maggiore di 10
SELECT * FROM prodotti WHERE prezzo > 100 AND quantita > 10;     -- troviamo lo smartphone e il tavolo

-- trovare un prodotto con un prezzo < 50 o una quantità maggiore di 25
SELECT * FROM prodotti WHERE prezzo < 50 OR quantita > 25;     -- troviamo la sedia e il libro


-- question 10

-- esempio riferito alla tabella prodotti

-- si vuole visualizzare il codice id del prodotto, il nome del prodotto,
-- la categoria, il prezzo e il prezzo max per la stessa categoria del prodotto.
SELECT nome, categoria, prezzo, 
       (SELECT MAX(prezzo) FROM prodotti WHERE categoria = p.categoria) AS prezzo_max_categoria     -- prezzo max
FROM prodotti AS p;

-- si vuole visualizzare il codice id del prodotto, il nome del prodotto,
-- la categoria, il prezzo e il prezzo medio per la stessa categoria del prodotto.
SELECT id, nome, categoria, prezzo, 
       (SELECT ROUND(AVG(prezzo),2) FROM prodotti WHERE categoria = p.categoria) AS prezzo_medio_categoria  -- prezzo medio
FROM prodotti AS p;
-- accanto ad ogni prodotto c’è il prezzo medio dei prodotti che hanno la stessa categoria del prodotto considerato.


-- esempio riferito alla tabella prodotti2 e ordini

-- vogliamo vedere l'elenco di tutti i prodotti con il numero totale di volte in cui sono stati ordinati. 
SELECT prodotti2.nome AS nome_prodotto, prodotti2.categoria,
    (SELECT SUM(ordini.quantita) FROM ordini
     WHERE ordini.prodID = prodotti2.ID) AS quantita_totale_ordinata
FROM prodotti2;


-- question 11
SELECT * FROM prodotti WHERE categoria = 'Elettronica' OR categoria = 'Abbigliamento';
SELECT * FROM prodotti WHERE categoria IN ('Elettronica', 'Abbigliamento');


-- question 12

-- esempio 1
SELECT * FROM prodotti 
WHERE prezzo BETWEEN 150 AND 1000;
-- esempio 2
SELECT * FROM prodotti 
WHERE quantita BETWEEN 25 AND 50;