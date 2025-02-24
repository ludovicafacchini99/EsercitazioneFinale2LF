CREATE DATABASE toysgroup;            -- creazione database
USE toysgroup;


-- creazione tabella categorie
CREATE TABLE categorie (
ID INT AUTO_INCREMENT PRIMARY KEY,   -- id categoria
nome VARCHAR(50) UNIQUE NOT NULL,    -- nome della categoria
descrizione VARCHAR(100)             -- descrizione della categoria
);

-- creazione tabella prodotti
CREATE TABLE prodotti (
ID INT AUTO_INCREMENT PRIMARY KEY,    -- id prodotto
nome VARCHAR(50) UNIQUE NOT NULL,     -- nome del prodotto
descrizione VARCHAR(100),             -- descrizione del prodotto
quantita INT,                         -- quantita disponibile in magazzino
prezzo_di_listino DECIMAL(10,2),      -- prezzo di listino
colore VARCHAR(50),                   -- colore principale del prodotto
peso DECIMAL(8,2),                    -- peso del prodotto (kg)
garanzia VARCHAR(20),                 -- anni di garanzia (es. "1 anno")
categoriaID INT, 
FOREIGN KEY (categoriaID) REFERENCES categorie(ID)
);

-- creazione tabella regione 
CREATE TABLE regione (
ID INT AUTO_INCREMENT PRIMARY KEY,         -- id della regione
nome_stato VARCHAR(30) UNIQUE,             -- nome degli stati nel mondo (ad esempio Italia, Francia, Canada etc...)
zona VARCHAR(40)                           -- nome delle zone (ad esempio NordEuropa, SudEuropa etc...)
);

-- creazione tabella vendite
CREATE TABLE vendite (
ID INT AUTO_INCREMENT PRIMARY KEY,                    -- id della vendita
numero_ordine VARCHAR(20),                            -- numero dell'ordine        
quantita INT NOT NULL CHECK (quantita > 0),           -- quantità di prodotto venduta
prezzo_unitario DECIMAL(10,2) NOT NULL,               -- prezzo unitario del prodotto al momento della vendita
prezzo_totale DECIMAL(10,2) AS (quantita * prezzo_unitario),   -- prezzo totale della vendita (quantita * prezzo_unitario)
data_ordine DATE,                                     -- data dell'ordine
data_di_vendita DATE,                                 -- data di vendita
metodo_di_pagamento VARCHAR(50),                      -- metodo di pagamento usato (paypal, bonifico_bancario, carta_di_credito)
regioneID INT,
prodottoID INT,
FOREIGN KEY (regioneID) REFERENCES regione(ID),
FOREIGN KEY (prodottoID) REFERENCES prodotti(ID)
);

-- inserisco un check sulle date nella tabella vendite
ALTER TABLE vendite
ADD CONSTRAINT date_check CHECK (data_di_vendita >= data_ordine);    -- chiedo che la data_di_vendita sia maggiore della data_ordine

-- passiamo agli inserimenti dei valori

-- inserimento dei dati nella tabella categorie (10 record)
INSERT INTO categorie (nome, descrizione) VALUES
('Bambole', 'Bambole di varie dimensioni e accessori'),
('Costruzioni', 'Mattoncini e set per costruzioni creative'),
('Giochi Educativi', 'Giochi per stimolare apprendimento e creatività'),
('Macchinine', 'Auto giocattolo, piste e accessori'),
('Peluches', 'Pupazzi e peluche morbidi per tutte le età'),
('Puzzle', 'Puzzle per bambini e adulti di diverse difficoltà'),
('Giochi da Tavolo', 'Giochi da tavolo e di società per tutta la famiglia'),
('Giochi all’Aperto', 'Giochi per il giardino e attività all’aperto'),
('Strumenti Musicali', 'Giochi musicali come tamburi, chitarre e tastiere per bambini'),
('Action Figures', 'Personaggi e modellini da collezione e per il gioco');

SELECT * FROM categorie;  -- visualizziamo i dati inseriti nella tabella categorie

-- inserimento dei dati nella tabella prodotti (25 record)
INSERT INTO prodotti (nome, descrizione, quantita, prezzo_di_listino, colore, peso, garanzia, categoriaID) VALUES
('Barbie Fashion', 'Bambola con vestiti alla moda', 50, 29.99, 'Rosa', 0.5, '2 anni', 1),
('Lego City', 'Set Lego per costruire una città', 40, 49.99, 'Multicolore', 1.2, '2 anni', 2),
('Abaco Educativo', 'Gioco educativo con palline colorate', 30, 19.99, 'Multicolore', 0.8, '1 anno', 3),
('Hot Wheels Turbo', 'Macchinina sportiva', 100, 9.99, 'Rosso', 0.2, '1 anno', 4),
('Orsetto Peluche', 'Morbido orsetto di peluche', 60, 15.99, 'Marrone', 0.7, '1 anno', 5),
('Puzzle 1000 Pezzi', 'Puzzle con paesaggio naturale', 25, 24.99, 'Multicolore', 1.1, '1 anno', 6),
('Monopoly', 'Gioco da tavolo classico', 35, 39.99, 'Multicolore', 2.0, '3 anni', 7),
('Altalena da Giardino', 'Altalena per bambini', 20, 79.99, 'Blu', 5.5, '2 anni', 8),
('Chitarra Giocattolo', 'Chitarra musicale per bambini', 30, 34.99, 'Rosso', 1.3, '2 anni', 9),
('Spider-Man Figure', 'Action figure di Spider-Man', 50, 22.99, 'Rosso e Blu', 0.4, '1 anno', 10),
('Lego Star Wars', 'Set Lego a tema Star Wars', 20, 99.99, 'Multicolore', 2.5, '2 anni', 2),
('Bambola Principessa', 'Bambola vestita da principessa', 40, 32.99, 'Azzurro', 0.6, '2 anni', 1),
('Treno Elettrico', 'Set ferroviario con treno elettrico', 15, 89.99, 'Nero e Rosso', 3.0, '3 anni', 2),
('Scacchi Deluxe', 'Set di scacchi in legno', 30, 45.99, 'Legno', 1.8, '3 anni', 7),
('Camion Gigante', 'Camion giocattolo con rimorchio', 50, 27.99, 'Giallo', 1.5, '1 anno', 4),
('Peluche Unicorno', 'Peluche morbido a forma di unicorno', 55, 18.99, 'Bianco', 0.9, '1 anno', 5),
('Puzzle 3D Torre Eiffel', 'Puzzle tridimensionale della Torre Eiffel', 20, 35.99, 'Grigio', 1.2, '1 anno', 6),
('Risiko', 'Gioco da tavolo strategico', 25, 42.99, 'Multicolore', 2.3, '3 anni', 7),
('Bicicletta Bambino', 'Bicicletta con rotelle per bambini', 10, 129.99, 'Rosso', 8.0, '5 anni', 8),
('Tamburo Giocattolo', 'Tamburo per bambini con bacchette', 40, 19.99, 'Blu', 1.0, '2 anni', 9),
('Batman Figure', 'Action figure di Batman', 45, 25.99, 'Nero', 0.5, '1 anno', 10),
('Castello delle Bambole', 'Grande castello per bambole', 10, 149.99, 'Rosa', 4.0, '2 anni', 1),
('Tenda da Gioco', 'Tenda per bambini a tema avventura', 12, 59.99, 'Verde', 3.2, '2 anni', 8),
('Xilofono Giocattolo', 'Strumento musicale per bambini', 35, 22.99, 'Multicolore', 1.1, '2 anni', 9),
('Hulk Figure', 'Action figure di Hulk', 30, 28.99, 'Verde', 0.6, '1 anno', 10);

SELECT * FROM prodotti;     -- visualizziamo i dati inseriti nella tabella prodotti

-- inserimento dei dati nella tabella regione, consideriamo solo l'Europa (15 record)
INSERT INTO regione (nome_stato, zona) VALUES
('Italia', 'SudEuropa'),
('Francia', 'OvestEuropa'),
('Germania', 'CentroEuropa'),
('Spagna', 'SudEuropa'),
('Regno Unito', 'NordEuropa'),
('Portogallo', 'SudEuropa'),
('Paesi Bassi', 'OvestEuropa'),
('Belgio', 'OvestEuropa'),
('Svizzera', 'CentroEuropa'),
('Austria', 'CentroEuropa'),
('Svezia', 'NordEuropa'),
('Norvegia', 'NordEuropa'),
('Danimarca', 'NordEuropa'),
('Polonia', 'EstEuropa'),
('Grecia', 'SudEuropa');

SELECT * FROM regione;     -- visualizziamo i dati inseriti nella tabella regione


-- inserimento dei dati nella tabella vendite (50 record)
INSERT INTO vendite (numero_ordine, quantita, prezzo_unitario, data_ordine, data_di_vendita, metodo_di_pagamento, regioneID, prodottoID)
VALUES
('ORD1001', 2, 19.99, '2023-01-05', '2023-01-08', 'carta_di_credito', 1, 1),
('ORD1002', 1, 29.50, '2023-02-10', '2023-02-12', 'paypal', 2, 2),
('ORD1003', 3, 15.75, '2023-03-15', '2023-03-17', 'bonifico_bancario', 3, 3),
('ORD1004', 5, 9.99, '2023-04-20', '2023-04-22', 'carta_di_credito', 4, 4),
('ORD1005', 2, 45.00, '2023-05-25', '2023-05-27', 'paypal', 5, 5),
('ORD1006', 1, 99.99, '2023-06-30', '2023-07-03', 'bonifico_bancario', 6, 6),
('ORD1007', 4, 12.99, '2023-08-01', '2023-08-02', 'carta_di_credito', 7, 7),
('ORD1008', 2, 27.50, '2023-09-05', '2023-09-07', 'paypal', 8, 8),
('ORD1009', 3, 34.99, '2023-10-10', '2023-10-13', 'bonifico_bancario', 9, 9),
('ORD1010', 1, 55.00, '2023-11-15', '2023-11-17', 'carta_di_credito', 10, 10),
('ORD1011', 5, 20.00, '2023-12-20', '2023-12-23', 'paypal', 11, 11),
('ORD1012', 2, 39.99, '2024-01-25', '2024-01-29', 'bonifico_bancario', 12, 12),
('ORD1013', 3, 24.90, '2024-02-10', '2024-02-12', 'carta_di_credito', 13, 13),
('ORD1014', 1, 74.99, '2024-03-15', '2024-03-16', 'paypal', 14, 14),
('ORD1015', 4, 18.50, '2024-04-20', '2024-04-24', 'bonifico_bancario', 15, 15),
('ORD1016', 2, 65.00, '2024-05-25', '2024-05-27', 'carta_di_credito', 1, 16),
('ORD1017', 3, 13.75, '2024-06-10', '2024-06-12', 'paypal', 2, 17),
('ORD1018', 1, 89.99, '2024-07-15', '2024-07-18', 'bonifico_bancario', 3, 18),
('ORD1019', 5, 16.99, '2024-08-20', '2024-08-22', 'carta_di_credito', 4, 19),
('ORD1020', 2, 50.00, '2024-09-25', '2024-09-27', 'paypal', 5, 20),
('ORD1021', 4, 29.50, '2024-10-30', '2024-11-02', 'bonifico_bancario', 6, 21),
('ORD1022', 3, 19.99, '2024-11-05', '2024-11-08', 'carta_di_credito', 7, 22),
('ORD1023', 1, 44.99, '2024-12-10', '2024-12-12', 'paypal', 8, 23),
('ORD1024', 2, 75.00, '2025-01-05', '2025-01-08', 'bonifico_bancario', 9, 24),
('ORD1025', 3, 22.50, '2025-02-10', '2025-02-13', 'carta_di_credito', 10, 25),
('ORD1026', 1, 99.99, '2023-02-10', '2023-02-14', 'paypal', 2, 1),
('ORD1027', 5, 30.00, '2023-07-01', '2023-07-03', 'bonifico_bancario', 5, 2),
('ORD1028', 2, 40.99, '2023-12-20', '2023-12-24', 'carta_di_credito', 7, 3),
('ORD1029', 3, 27.50, '2024-05-12', '2024-05-16', 'paypal', 8, 4),
('ORD1030', 1, 55.50, '2024-09-25', '2024-09-28', 'bonifico_bancario', 3, 5),
('ORD1031', 4, 12.75, '2024-11-30', '2024-12-03', 'carta_di_credito', 12, 6),
('ORD1032', 2, 48.00, '2025-01-20', '2025-01-23', 'paypal', 13, 7),
('ORD1033', 3, 34.99, '2025-02-05', '2025-02-09', 'bonifico_bancario', 14, 8),
('ORD1034', 5, 25.00, '2023-03-15', '2023-03-19', 'carta_di_credito', 15, 9),
('ORD1035', 2, 77.50, '2023-06-22', '2023-06-25', 'paypal', 1, 10),
('ORD1036', 3, 45.99, '2023-10-05', '2023-10-09', 'bonifico_bancario', 6, 11),
('ORD1037', 1, 88.00, '2024-01-12', '2024-01-15', 'carta_di_credito', 10, 12),
('ORD1038', 4, 29.50, '2024-03-22', '2024-03-26', 'paypal', 4, 13),
('ORD1039', 2, 15.99, '2024-07-10', '2024-07-12', 'bonifico_bancario', 5, 14),
('ORD1040', 3, 60.00, '2024-10-30', '2024-11-02', 'carta_di_credito', 9, 15),
('ORD1041', 2, 55.00, '2025-01-15', '2025-01-18', 'paypal', 1, 17),
('ORD1042', 3, 39.99, '2025-01-20', '2025-01-23', 'bonifico_bancario', 2, 18),
('ORD1043', 4, 22.75, '2025-01-30', '2025-02-02', 'carta_di_credito', 3, 19),
('ORD1044', 1, 89.00, '2025-02-01', '2025-02-03', 'paypal', 4, 20),
('ORD1045', 3, 27.99, '2025-02-05', '2025-02-08', 'bonifico_bancario', 5, 21),
('ORD1046', 2, 70.50, '2025-02-08', '2025-02-10', 'carta_di_credito', 6, 22),
('ORD1047', 5, 18.99, '2025-02-12', '2025-02-14', 'paypal', 7, 23),
('ORD1048', 3, 32.50, '2025-02-13', '2025-02-15', 'bonifico_bancario', 8, 24),
('ORD1049', 2, 45.00, '2025-02-15', '2025-02-17', 'carta_di_credito', 9, 25),
('ORD1050', 4, 27.99, '2025-02-18', '2025-02-20', 'paypal', 10, 12);


SELECT * FROM vendite;    --  visualizziamo i dati inseriti nella tabella vendite


-- inseriamo altri 5 prodotti nella tabella prodotti (che risulteranno invenduti)
INSERT INTO prodotti (nome, descrizione, quantita, prezzo_di_listino, colore, peso, garanzia, categoriaID) VALUES
('Bambola Sirena', 'Bambola con coda di sirena e capelli lunghi', 45, 27.99, 'Azzurro', 0.55, '2 anni', 1),
('Set Astronave Spaziale', 'Set di costruzioni per assemblare un’astronave', 35, 64.99, 'Bianco e Blu', 1.90, '1 anno', 2),
('Mappamondo Interattivo', 'Globo terrestre con funzioni didattiche', 20, 54.99, 'Blu', 2.10, '3 anni', 3),
('Camion dei Pompieri', 'Camion giocattolo con sirena e scala mobile', 50, 32.99, 'Rosso', 1.80, '2 anni', 4),
('Elefante Gigante', 'Peluche morbido a forma di elefante', 30, 44.99, 'Grigio', 1.20, '1 anno', 5);

SELECT * FROM prodotti;   -- ora in totale abbiamo 30 prodotti


-- mi sono resa conto che i prezzi_unitari dei prodotti delle vendite non coincidevano con il prezzo_di_listino
-- presente nella tabella prodotti allora faccio questo update
UPDATE vendite
JOIN prodotti ON vendite.prodottoID = prodotti.ID
SET vendite.prezzo_unitario = prodotti.prezzo_di_listino
WHERE vendite.prezzo_unitario != prodotti.prezzo_di_listino;

SELECT * FROM prodotti;   -- visualizzo che l'update sia stato effettuato
SELECT * FROM vendite;
