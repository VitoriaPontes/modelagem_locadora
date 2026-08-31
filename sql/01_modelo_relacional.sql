-- Modelo Relacional | Locadora de Veículos
-- SQLite 3.x
-- Script reproduzível: cria uma tabela de staging desnormalizada, normaliza os dados
-- e finaliza com integridade referencial entre as entidades.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS stg_locacao;
DROP TABLE IF EXISTS tb_locacao;
DROP TABLE IF EXISTS tb_cliente;
DROP TABLE IF EXISTS tb_cidade;
DROP TABLE IF EXISTS tb_carro;
DROP TABLE IF EXISTS tb_combustivel;
DROP TABLE IF EXISTS tb_vendedor;

-- 1. Fonte desnormalizada utilizada para demonstrar a normalização.
CREATE TABLE stg_locacao (
    idLocacao INTEGER PRIMARY KEY,
    idCliente INTEGER NOT NULL,
    idCarro INTEGER NOT NULL,
    kmCarro INTEGER NOT NULL,
    idCombustivel INTEGER NOT NULL,
    dataLocacao TEXT NOT NULL,
    horaLocacao TEXT NOT NULL,
    qtdDiaria INTEGER NOT NULL,
    vlrDiaria NUMERIC(10,2) NOT NULL,
    dataEntrega TEXT NOT NULL,
    horaEntrega TEXT NOT NULL,
    idVendedor INTEGER NOT NULL,
    nomeCliente TEXT NOT NULL,
    cidadeCliente TEXT NOT NULL,
    estadoCliente TEXT NOT NULL,
    paisCliente TEXT NOT NULL,
    chassiCarro TEXT NOT NULL,
    marcaCarro TEXT NOT NULL,
    modeloCarro TEXT NOT NULL,
    anoCarro INTEGER NOT NULL,
    tipoCombustivel TEXT NOT NULL,
    nomeVendedor TEXT NOT NULL,
    sexoVendedor INTEGER NOT NULL,
    estadoVendedor TEXT NOT NULL
);

INSERT INTO stg_locacao (idLocacao, idCliente, idCarro, kmCarro, idCombustivel, dataLocacao, horaLocacao, qtdDiaria, vlrDiaria, dataEntrega, horaEntrega, idVendedor, nomeCliente, cidadeCliente, estadoCliente, paisCliente, chassiCarro, marcaCarro, modeloCarro, anoCarro, tipoCombustivel, nomeVendedor, sexoVendedor, estadoVendedor) VALUES
(1, 2, 98, 25412, 1, '2015-01-10', '10:00', 2, 100, '2015-01-12', '10:00', 5, 'Cliente dois', 'São Paulo', 'São Paulo', 'Brasil', 'AKJHKN98JY76539', 'Fiat', 'Fiat Uno', 2000, 'Gasolina', 'Vendedor cinco', 0, 'São Paulo'),
(2, 2, 98, 29450, 1, '2015-02-10', '12:00', 2, 100, '2015-02-12', '12:00', 5, 'Cliente dois', 'São Paulo', 'São Paulo', 'Brasil', 'AKJHKN98JY76539', 'Fiat', 'Fiat Uno', 2000, 'Gasolina', 'Vendedor cinco', 0, 'São Paulo'),
(3, 3, 99, 20000, 1, '2015-02-13', '12:00', 2, 150, '2015-02-15', '12:00', 6, 'Cliente tres', 'Rio de Janeiro', 'Rio de Janeiro', 'Brasil', 'IKJHKN98JY76539', 'Fiat', 'Fiat Palio', 2010, 'Gasolina', 'Vendedora seis', 1, 'São Paulo'),
(4, 4, 99, 21000, 1, '2015-02-15', '13:00', 5, 150, '2015-02-20', '13:00', 6, 'Cliente quatro', 'Rio de Janeiro', 'Rio de Janeiro', 'Brasil', 'IKJHKN98JY76539', 'Fiat', 'Fiat Palio', 2010, 'Gasolina', 'Vendedora seis', 1, 'São Paulo'),
(5, 4, 99, 21700, 1, '2015-03-02', '14:00', 5, 150, '2015-03-07', '14:00', 7, 'Cliente quatro', 'Rio de Janeiro', 'Rio de Janeiro', 'Brasil', 'IKJHKN98JY76539', 'Fiat', 'Fiat Palio', 2010, 'Gasolina', 'Vendedora sete', 1, 'Rio de Janeiro'),
(6, 6, 3, 121700, 1, '2016-03-02', '14:00', 10, 250, '2016-03-12', '14:00', 8, 'Cliente seis', 'Belo Horizonte', 'Minas Gerais', 'Brasil', 'DKSHKNS8JS76S39', 'VW', 'Fusca 78', 1978, 'Gasolina', 'Vendedora oito', 1, 'Minas Gerais'),
(7, 6, 3, 131800, 1, '2016-08-02', '14:00', 10, 250, '2016-08-12', '14:00', 8, 'Cliente seis', 'Belo Horizonte', 'Minas Gerais', 'Brasil', 'DKSHKNS8JS76S39', 'VW', 'Fusca 78', 1978, 'Gasolina', 'Vendedora oito', 1, 'Minas Gerais'),
(8, 4, 3, 151800, 1, '2017-01-02', '18:00', 10, 250, '2017-01-12', '18:00', 6, 'Cliente quatro', 'Rio de Janeiro', 'Rio de Janeiro', 'Brasil', 'DKSHKNS8JS76S39', 'VW', 'Fusca 78', 1978, 'Gasolina', 'Vendedora seis', 1, 'São Paulo'),
(9, 4, 3, 152800, 1, '2018-01-02', '18:00', 10, 280, '2018-01-12', '18:00', 6, 'Cliente quatro', 'Rio de Janeiro', 'Rio de Janeiro', 'Brasil', 'DKSHKNS8JS76S39', 'VW', 'Fusca 78', 1978, 'Gasolina', 'Vendedora seis', 1, 'São Paulo'),
(10, 10, 10, 211800, 1, '2018-03-02', '18:00', 10, 50, '2018-03-12', '18:00', 16, 'Cliente dez', 'Rio Branco', 'Acre', 'Brasil', 'LKIUNS8JS76S39', 'Fiat', 'Fiat 147', 1996, 'Gasolina', 'Vendedor dezesseis', 0, 'Amazonas'),
(11, 20, 7, 212800, 1, '2018-04-01', '11:00', 10, 50, '2018-04-11', '11:00', 16, 'Cliente vinte', 'Macapá', 'Amapá', 'Brasil', 'SSIUNS8JS76S39', 'Fiat', 'Fiat 147', 1996, 'Gasolina', 'Vendedor dezesseis', 0, 'Amazonas'),
(12, 20, 6, 21800, 1, '2020-04-01', '11:00', 10, 150, '2020-04-11', '11:00', 16, 'Cliente vinte', 'Macapá', 'Amapá', 'Brasil', 'SKIUNS8JS76S39', 'Nissan', 'Versa', 2019, 'Gasolina', 'Vendedor dezesseis', 0, 'Amazonas'),
(13, 22, 2, 10000, 2, '2022-05-01', '8:00', 20, 150, '2022-05-21', '18:00', 30, 'Cliente vinte e dois', 'Porto Alegre', 'Rio Grande do Sul', 'Brasil', 'AKIUNS1JS76S39', 'Nissan', 'Versa', 2019, 'Etanol', 'Vendedor trinta', 0, 'Rio Grande do Sul'),
(14, 22, 2, 20000, 2, '2022-06-01', '8:00', 20, 150, '2022-06-21', '18:00', 30, 'Cliente vinte e dois', 'Porto Alegre', 'Rio Grande do Sul', 'Brasil', 'AKIUNS1JS76S39', 'Nissan', 'Versa', 2019, 'Etanol', 'Vendedor trinta', 0, 'Rio Grande do Sul'),
(15, 22, 2, 30000, 2, '2022-07-01', '8:00', 20, 150, '2022-07-21', '18:00', 30, 'Cliente vinte e dois', 'Porto Alegre', 'Rio Grande do Sul', 'Brasil', 'AKIUNS1JS76S39', 'Nissan', 'Versa', 2019, 'Etanol', 'Vendedor trinta', 0, 'Rio Grande do Sul'),
(16, 22, 2, 40000, 2, '2022-08-01', '8:00', 20, 150, '2022-08-21', '18:00', 30, 'Cliente vinte e dois', 'Porto Alegre', 'Rio Grande do Sul', 'Brasil', 'AKIUNS1JS76S39', 'Nissan', 'Versa', 2019, 'Etanol', 'Vendedor trinta', 0, 'Rio Grande do Sul'),
(17, 23, 4, 55000, 2, '2022-09-01', '8:00', 20, 150, '2022-09-21', '18:00', 31, 'Cliente vinte e tres', 'Eusébio', 'Ceará', 'Brasil', 'LLLUNS1JS76S39', 'Nissan', 'Versa', 2020, 'Etanol', 'Vendedor trinta e um', 0, 'Ceará'),
(18, 23, 4, 56000, 2, '2022-10-01', '8:00', 20, 150, '2022-10-21', '18:00', 31, 'Cliente vinte e tres', 'Eusébio', 'Ceará', 'Brasil', 'LLLUNS1JS76S39', 'Nissan', 'Versa', 2020, 'Etanol', 'Vendedor trinta e um', 0, 'Ceará'),
(19, 23, 4, 58000, 2, '2022-11-01', '8:00', 20, 150, '2022-11-21', '18:00', 31, 'Cliente vinte e tres', 'Eusébio', 'Ceará', 'Brasil', 'LLLUNS1JS76S39', 'Nissan', 'Versa', 2020, 'Etanol', 'Vendedor trinta e um', 0, 'Ceará'),
(20, 5, 1, 1800, 3, '2023-01-02', '18:00', 10, 880, '2023-01-12', '18:00', 16, 'Cliente cinco', 'Manaus', 'Amazonas', 'Brasil', 'AAAKNS8JS76S39', 'Toyota', 'Corolla XEI', 2023, 'Flex', 'Vendedor dezesseis', 0, 'Amazonas'),
(21, 5, 1, 8500, 3, '2023-01-15', '18:00', 10, 880, '2023-01-25', '18:00', 16, 'Cliente cinco', 'Manaus', 'Amazonas', 'Brasil', 'AAAKNS8JS76S39', 'Toyota', 'Corolla XEI', 2023, 'Flex', 'Vendedor dezesseis', 0, 'Amazonas'),
(22, 26, 5, 28000, 4, '2023-01-25', '8:00', 5, 600, '2023-01-30', '18:00', 32, 'Cliente vinte e seis', 'Campo Grande', 'Mato Grosso do Sul', 'Brasil', 'MSLUNS1JS76S39', 'Nissan', 'Frontier', 2022, 'Diesel', 'Vendedora trinta e dois', 1, 'Mato Grosso do Sul'),
(23, 26, 5, 38000, 4, '2023-01-31', '8:00', 5, 600, '2023-02-05', '18:00', 32, 'Cliente vinte e seis', 'Campo Grande', 'Mato Grosso do Sul', 'Brasil', 'MSLUNS1JS76S39', 'Nissan', 'Frontier', 2022, 'Diesel', 'Vendedora trinta e dois', 1, 'Mato Grosso do Sul'),
(24, 26, 5, 48000, 4, '2023-02-06', '8:00', 5, 600, '2023-02-11', '18:00', 32, 'Cliente vinte e seis', 'Campo Grande', 'Mato Grosso do Sul', 'Brasil', 'MSLUNS1JS76S39', 'Nissan', 'Frontier', 2022, 'Diesel', 'Vendedora trinta e dois', 1, 'Mato Grosso do Sul'),
(25, 26, 5, 68000, 4, '2023-02-12', '8:00', 5, 600, '2023-02-17', '18:00', 32, 'Cliente vinte e seis', 'Campo Grande', 'Mato Grosso do Sul', 'Brasil', 'MSLUNS1JS76S39', 'Nissan', 'Frontier', 2022, 'Diesel', 'Vendedora trinta e dois', 1, 'Mato Grosso do Sul'),
(26, 26, 5, 78000, 4, '2023-02-18', '8:00', 1, 600, '2023-02-19', '18:00', 32, 'Cliente vinte e seis', 'Campo Grande', 'Mato Grosso do Sul', 'Brasil', 'MSLUNS1JS76S39', 'Nissan', 'Frontier', 2022, 'Diesel', 'Vendedora trinta e dois', 1, 'Mato Grosso do Sul');

-- 2. Dimensão geográfica.
CREATE TABLE tb_cidade (
    idCidade INTEGER PRIMARY KEY,
    cidade TEXT NOT NULL,
    estado TEXT NOT NULL,
    pais TEXT NOT NULL,
    UNIQUE (cidade, estado, pais)
);

INSERT INTO tb_cidade (idCidade, cidade, estado, pais)
SELECT ROW_NUMBER() OVER (ORDER BY cidadeCliente, estadoCliente, paisCliente), cidadeCliente, estadoCliente, paisCliente
FROM (SELECT DISTINCT cidadeCliente, estadoCliente, paisCliente FROM stg_locacao);

-- 3. Cadastro de clientes.
CREATE TABLE tb_cliente (
    idCliente INTEGER PRIMARY KEY,
    nomeCliente TEXT NOT NULL,
    idCidade INTEGER NOT NULL,
    FOREIGN KEY (idCidade) REFERENCES tb_cidade(idCidade)
);

INSERT INTO tb_cliente (idCliente, nomeCliente, idCidade)
SELECT DISTINCT s.idCliente, s.nomeCliente, c.idCidade
FROM stg_locacao s
JOIN tb_cidade c ON c.cidade=s.cidadeCliente AND c.estado=s.estadoCliente AND c.pais=s.paisCliente;

-- 4. Cadastro de carros.
CREATE TABLE tb_carro (
    idCarro INTEGER PRIMARY KEY,
    chassiCarro TEXT NOT NULL UNIQUE,
    marcaCarro TEXT NOT NULL,
    modeloCarro TEXT NOT NULL,
    anoCarro INTEGER NOT NULL CHECK (anoCarro > 1900)
);

INSERT INTO tb_carro (idCarro, chassiCarro, marcaCarro, modeloCarro, anoCarro)
SELECT DISTINCT idCarro, chassiCarro, marcaCarro, modeloCarro, anoCarro
FROM stg_locacao;

-- 5. Tipos de combustível.
CREATE TABLE tb_combustivel (
    idCombustivel INTEGER PRIMARY KEY,
    tipoCombustivel TEXT NOT NULL UNIQUE
);

INSERT INTO tb_combustivel (idCombustivel, tipoCombustivel)
SELECT DISTINCT idCombustivel, tipoCombustivel
FROM stg_locacao;

-- 6. Vendedores.
CREATE TABLE tb_vendedor (
    idVendedor INTEGER PRIMARY KEY,
    nomeVendedor TEXT NOT NULL,
    sexoVendedor INTEGER NOT NULL CHECK (sexoVendedor IN (0,1)),
    estadoVendedor TEXT NOT NULL
);

INSERT INTO tb_vendedor (idVendedor, nomeVendedor, sexoVendedor, estadoVendedor)
SELECT DISTINCT idVendedor, nomeVendedor, sexoVendedor, estadoVendedor
FROM stg_locacao;

-- 7. Fato transacional da locação no modelo relacional.
CREATE TABLE tb_locacao (
    idLocacao INTEGER PRIMARY KEY,
    idCliente INTEGER NOT NULL,
    idCarro INTEGER NOT NULL,
    kmCarro INTEGER NOT NULL CHECK (kmCarro >= 0),
    idCombustivel INTEGER NOT NULL,
    dataLocacao TEXT NOT NULL,
    horaLocacao TEXT NOT NULL,
    qtdDiaria INTEGER NOT NULL CHECK (qtdDiaria > 0),
    vlrDiaria NUMERIC(10,2) NOT NULL CHECK (vlrDiaria >= 0),
    dataEntrega TEXT NOT NULL,
    horaEntrega TEXT NOT NULL,
    idVendedor INTEGER NOT NULL,
    CHECK (date(dataEntrega) >= date(dataLocacao)),
    FOREIGN KEY (idCliente) REFERENCES tb_cliente(idCliente),
    FOREIGN KEY (idCarro) REFERENCES tb_carro(idCarro),
    FOREIGN KEY (idCombustivel) REFERENCES tb_combustivel(idCombustivel),
    FOREIGN KEY (idVendedor) REFERENCES tb_vendedor(idVendedor)
);

INSERT INTO tb_locacao (
    idLocacao,idCliente,idCarro,kmCarro,idCombustivel,dataLocacao,horaLocacao,
    qtdDiaria,vlrDiaria,dataEntrega,horaEntrega,idVendedor
)
SELECT idLocacao,idCliente,idCarro,kmCarro,idCombustivel,dataLocacao,horaLocacao,
       qtdDiaria,vlrDiaria,dataEntrega,horaEntrega,idVendedor
FROM stg_locacao;

-- Índices para as colunas mais usadas em junções e filtros.
CREATE INDEX idx_locacao_cliente ON tb_locacao(idCliente);
CREATE INDEX idx_locacao_carro ON tb_locacao(idCarro);
CREATE INDEX idx_locacao_combustivel ON tb_locacao(idCombustivel);
CREATE INDEX idx_locacao_vendedor ON tb_locacao(idVendedor);
CREATE INDEX idx_cliente_cidade ON tb_cliente(idCidade);

DROP TABLE stg_locacao;

-- Consultas rápidas de validação.
SELECT 'tb_cidade' AS tabela, COUNT(*) AS registros FROM tb_cidade
UNION ALL SELECT 'tb_cliente', COUNT(*) FROM tb_cliente
UNION ALL SELECT 'tb_carro', COUNT(*) FROM tb_carro
UNION ALL SELECT 'tb_combustivel', COUNT(*) FROM tb_combustivel
UNION ALL SELECT 'tb_vendedor', COUNT(*) FROM tb_vendedor
UNION ALL SELECT 'tb_locacao', COUNT(*) FROM tb_locacao;
