-- Modelo Dimensional | Locadora de Veículos
-- SQLite 3.x
-- Modelo estrela: dimensões materializadas + tabela fato.

PRAGMA foreign_keys = ON;
ATTACH DATABASE '../database/relacional.sqlite' AS relacional;

DROP TABLE IF EXISTS fato_locacao;
DROP TABLE IF EXISTS dim_data;
DROP TABLE IF EXISTS dim_cliente;
DROP TABLE IF EXISTS dim_carro;
DROP TABLE IF EXISTS dim_combustivel;
DROP TABLE IF EXISTS dim_vendedor;

-- Dimensão Cliente (SCD Tipo 1 para este projeto).
CREATE TABLE dim_cliente (
    skCliente INTEGER PRIMARY KEY,
    idClienteOrigem INTEGER NOT NULL UNIQUE,
    nomeCliente TEXT NOT NULL,
    cidade TEXT NOT NULL,
    estado TEXT NOT NULL,
    pais TEXT NOT NULL
);

INSERT INTO dim_cliente (skCliente,idClienteOrigem,nomeCliente,cidade,estado,pais)
SELECT c.idCliente,c.idCliente,c.nomeCliente,ci.cidade,ci.estado,ci.pais
FROM relacional.tb_cliente c
JOIN relacional.tb_cidade ci ON ci.idCidade=c.idCidade;

-- Dimensão Carro.
CREATE TABLE dim_carro (
    skCarro INTEGER PRIMARY KEY,
    idCarroOrigem INTEGER NOT NULL UNIQUE,
    chassi TEXT NOT NULL,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL,
    ano INTEGER NOT NULL
);

INSERT INTO dim_carro (skCarro,idCarroOrigem,chassi,marca,modelo,ano)
SELECT idCarro,idCarro,chassiCarro,marcaCarro,modeloCarro,anoCarro
FROM relacional.tb_carro;

-- Dimensão Combustível.
CREATE TABLE dim_combustivel (
    skCombustivel INTEGER PRIMARY KEY,
    idCombustivelOrigem INTEGER NOT NULL UNIQUE,
    tipo TEXT NOT NULL
);

INSERT INTO dim_combustivel (skCombustivel,idCombustivelOrigem,tipo)
SELECT idCombustivel,idCombustivel,tipoCombustivel
FROM relacional.tb_combustivel;

-- Dimensão Vendedor.
CREATE TABLE dim_vendedor (
    skVendedor INTEGER PRIMARY KEY,
    idVendedorOrigem INTEGER NOT NULL UNIQUE,
    nome TEXT NOT NULL,
    sexo INTEGER NOT NULL,
    estado TEXT NOT NULL
);

INSERT INTO dim_vendedor (skVendedor,idVendedorOrigem,nome,sexo,estado)
SELECT idVendedor,idVendedor,nomeVendedor,sexoVendedor,estadoVendedor
FROM relacional.tb_vendedor;

-- Dimensão Data: uma linha por data, sem duplicar locação/entrega.
-- A mesma dimensão é referenciada duas vezes na fato (role-playing dimension).
CREATE TABLE dim_data (
    skData INTEGER PRIMARY KEY,
    data TEXT NOT NULL UNIQUE,
    ano INTEGER NOT NULL,
    trimestre INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    nomeMes TEXT NOT NULL,
    semanaAno INTEGER NOT NULL,
    dia INTEGER NOT NULL,
    diaSemana INTEGER NOT NULL,
    nomeDiaSemana TEXT NOT NULL,
    fimDeSemana INTEGER NOT NULL CHECK (fimDeSemana IN (0,1))
);

WITH datas AS (
    SELECT date(dataLocacao) AS data FROM relacional.tb_locacao
    UNION
    SELECT date(dataEntrega) AS data FROM relacional.tb_locacao
), numeradas AS (
    SELECT data, CAST(strftime('%Y',data) AS INTEGER) AS ano,
           CAST(strftime('%m',data) AS INTEGER) AS mes,
           CAST(strftime('%W',data) AS INTEGER) AS semanaAno,
           CAST(strftime('%d',data) AS INTEGER) AS dia,
           CAST(strftime('%w',data) AS INTEGER) AS diaSemana
    FROM datas
)
INSERT INTO dim_data (skData,data,ano,trimestre,mes,nomeMes,semanaAno,dia,diaSemana,nomeDiaSemana,fimDeSemana)
SELECT CAST(strftime('%Y%m%d',data) AS INTEGER), data, ano,
       ((mes-1)/3)+1,
       mes,
       CASE mes WHEN 1 THEN 'Janeiro' WHEN 2 THEN 'Fevereiro' WHEN 3 THEN 'Março' WHEN 4 THEN 'Abril'
                WHEN 5 THEN 'Maio' WHEN 6 THEN 'Junho' WHEN 7 THEN 'Julho' WHEN 8 THEN 'Agosto'
                WHEN 9 THEN 'Setembro' WHEN 10 THEN 'Outubro' WHEN 11 THEN 'Novembro' WHEN 12 THEN 'Dezembro' END,
       semanaAno,dia,diaSemana,
       CASE diaSemana WHEN 0 THEN 'Domingo' WHEN 1 THEN 'Segunda-feira' WHEN 2 THEN 'Terça-feira'
                      WHEN 3 THEN 'Quarta-feira' WHEN 4 THEN 'Quinta-feira' WHEN 5 THEN 'Sexta-feira'
                      WHEN 6 THEN 'Sábado' END,
       CASE WHEN diaSemana IN (0,6) THEN 1 ELSE 0 END
FROM numeradas;

-- Tabela fato: granularidade = uma linha por locação.
CREATE TABLE fato_locacao (
    skLocacao INTEGER PRIMARY KEY,
    idLocacaoOrigem INTEGER NOT NULL UNIQUE,
    skCliente INTEGER NOT NULL,
    skCarro INTEGER NOT NULL,
    skCombustivel INTEGER NOT NULL,
    skVendedor INTEGER NOT NULL,
    skDataLocacao INTEGER NOT NULL,
    skDataEntrega INTEGER NOT NULL,
    horaLocacao TEXT NOT NULL,
    horaEntrega TEXT NOT NULL,
    kmCarro INTEGER NOT NULL,
    qtdDiaria INTEGER NOT NULL,
    vlrDiaria NUMERIC(10,2) NOT NULL,
    valorTotal NUMERIC(12,2) NOT NULL,
    diasCalendario INTEGER NOT NULL,
    FOREIGN KEY (skCliente) REFERENCES dim_cliente(skCliente),
    FOREIGN KEY (skCarro) REFERENCES dim_carro(skCarro),
    FOREIGN KEY (skCombustivel) REFERENCES dim_combustivel(skCombustivel),
    FOREIGN KEY (skVendedor) REFERENCES dim_vendedor(skVendedor),
    FOREIGN KEY (skDataLocacao) REFERENCES dim_data(skData),
    FOREIGN KEY (skDataEntrega) REFERENCES dim_data(skData),
    CHECK (qtdDiaria > 0),
    CHECK (vlrDiaria >= 0),
    CHECK (kmCarro >= 0)
);

INSERT INTO fato_locacao (
    skLocacao,idLocacaoOrigem,skCliente,skCarro,skCombustivel,skVendedor,
    skDataLocacao,skDataEntrega,horaLocacao,horaEntrega,kmCarro,qtdDiaria,
    vlrDiaria,valorTotal,diasCalendario
)
SELECT l.idLocacao,l.idLocacao,
       c.skCliente,car.skCarro,comb.skCombustivel,v.skVendedor,
       dl.skData,de.skData,l.horaLocacao,l.horaEntrega,l.kmCarro,l.qtdDiaria,
       l.vlrDiaria,ROUND(l.qtdDiaria*l.vlrDiaria,2),
       CAST(julianday(l.dataEntrega)-julianday(l.dataLocacao) AS INTEGER)
FROM relacional.tb_locacao l
JOIN dim_cliente c ON c.idClienteOrigem=l.idCliente
JOIN dim_carro car ON car.idCarroOrigem=l.idCarro
JOIN dim_combustivel comb ON comb.idCombustivelOrigem=l.idCombustivel
JOIN dim_vendedor v ON v.idVendedorOrigem=l.idVendedor
JOIN dim_data dl ON dl.data=l.dataLocacao
JOIN dim_data de ON de.data=l.dataEntrega;

CREATE INDEX idx_fato_cliente ON fato_locacao(skCliente);
CREATE INDEX idx_fato_carro ON fato_locacao(skCarro);
CREATE INDEX idx_fato_combustivel ON fato_locacao(skCombustivel);
CREATE INDEX idx_fato_vendedor ON fato_locacao(skVendedor);
CREATE INDEX idx_fato_data_locacao ON fato_locacao(skDataLocacao);
CREATE INDEX idx_fato_data_entrega ON fato_locacao(skDataEntrega);

-- Consultas de validação.
SELECT 'dim_cliente' AS tabela, COUNT(*) AS registros FROM dim_cliente
UNION ALL SELECT 'dim_carro', COUNT(*) FROM dim_carro
UNION ALL SELECT 'dim_combustivel', COUNT(*) FROM dim_combustivel
UNION ALL SELECT 'dim_vendedor', COUNT(*) FROM dim_vendedor
UNION ALL SELECT 'dim_data', COUNT(*) FROM dim_data
UNION ALL SELECT 'fato_locacao', COUNT(*) FROM fato_locacao;

DETACH DATABASE relacional;
