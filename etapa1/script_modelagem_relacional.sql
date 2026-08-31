-- consulta da tabela
select *
from tb_locacao

------------------------------------------------------------------------------------------------
------- criação das tabelas --------

-- criando uma nova tabela para os atributos de vendedor

create table tb_vendedor (
  idVendedor integer primary key,
  nomeVendedor text not null,
  sexoVendedor smallint not null,
  estadoVendedor text not null
);

insert into tb_vendedor(idVendedor, nomeVendedor, sexoVendedor, estadoVendedor)
select
	distinct idVendedor,
	nomeVendedor,
	sexoVendedor,
	estadoVendedor
from tb_locacao

-- agora vamos consultar a tabela vendedor para ver se foi criada corretamente

select *
from tb_vendedor


-- criando a tabela carro

create table tb_carro (
  idCarro integer primary key,
  chassiCarro text not null,
  marcaCarro text not null,
  modeloCarro text not null,
  anoCarro integer not null
);

insert into tb_carro (idCarro, chassiCarro, marcaCarro, modeloCarro, anoCarro)
select		-- deixarei de fora km pois pode variar com o carro que foi alugado
	distinct idCarro,
	chassiCarro,
	marcaCarro,
	modeloCarro,
	anoCarro
from tb_locacao

-- consultando se a tabela foi criada corretamente

select *
from tb_carro


-- criando a tabela combustível

create table tb_combustivel (
  idCombustivel integer primary key,
  tipoCombustivel text not null
);

insert into tb_combustivel (idCombustivel, tipoCombustivel)
select
	distinct idcombustivel as idCombustivel,
	tipoCombustivel
from tb_locacao

-- checando a tabela criada
select *
from tb_combustivel


-- criando a tabela cliente

create table tb_cliente (
  idCliente integer primary key,
  nomeCliente text not null,
  cidadeCliente text not null,
  estadoCliente text not null,
  paisCliente text not null
);

insert into tb_cliente(idCliente, nomeCliente, cidadeCliente, estadoCliente, paisCliente)
select
	distinct idCliente,
	nomeCliente,
	cidadeCliente,
	estadoCliente,
	paisCliente
from tb_locacao

-- checando a tabela criada
select *
from tb_cliente


-- criando a tabela cidade

create table tb_cidade (
  cidade text primary key,
  estado text not null,
  pais text not null
);

insert into tb_cidade(cidade, estado, pais)
select
	distinct cidadeCliente as cidade,
	estadoCliente as estado,
	paisCliente as pais
from tb_cliente

select *
from tb_cidade

--------------------------------------------------------------------------------------------------

----------- removendo as colunas com dependência transitiva ------------

-- irei remover os atributos repetitivos da tabela locacao
alter table tb_locacao
drop nomeVendedor

alter table tb_locacao
drop sexoVendedor

alter table tb_locacao
drop estadoVendedor


-- removendo as colunas de tb_locacao
alter table tb_locacao
drop chassiCarro

alter table tb_locacao
drop marcaCarro

alter table tb_locacao
drop modeloCarro

alter table tb_locacao
drop anoCarro


-- removendo o tipoCombustivel
alter table tb_locacao
drop tipoCombustivel


-- removendo as colunas de tb_locacao
alter table tb_locacao
drop nomeCliente

alter table tb_locacao
drop cidadeCliente

alter table tb_locacao
drop estadoCliente

alter table tb_locacao
drop paisCliente

-- removendo as colunas de tb_cliente
alter table tb_cliente
drop estadoCliente

alter table tb_cliente
drop paisCliente

---------------------------------------------------------------------------------------------------------


-- modificações em data e hora do sistema

create table tb_locacao_ajustada (
  idLocacao integer primary key,
  idCliente integer not null,
  idCarro integer not null,
  kmCarro integer not null,
  idCombustivel integer not null,
  dataLocacao date not null,
  horaLocacao time not null,
  qtdDiaria integer not null,
  vlrDiaria integer not null,
  dataEntrega date not null,
  horaEntrega time not null,
  idVendedor integer not null
);

-- criação de uma nova tabela para ajustar a ordem das colunas
insert into tb_locacao_ajustada (idLocacao, idCliente, idCarro, kmCarro, idCombustivel, dataLocacao, horaLocacao, qtdDiaria, vlrDiaria, dataEntrega, horaEntrega, idVendedor)
select
	idLocacao,
	idCliente,
	idCarro,
	kmCarro,
	idcombustivel as idCombustivel,
	date(substr(dataLocacao, 1, 4) || '-' || substr(dataLocacao, 5, 2) || '-' || substr(dataLocacao, 7, 2)),
	horaLocacao,
	qtdDiaria,
	vlrDiaria,
	date(substr(dataEntrega, 1, 4) || '-' || substr(dataEntrega, 5, 2) || '-' || substr(dataEntrega, 7, 2)),
	horaEntrega,
	idVendedor
from tb_locacao

select *
from tb_locacao_ajustada

-- deletando a tabela anterior
drop table tb_locacao

-- renomeando a tabela
alter table tb_locacao_ajustada rename to tb_locacao

-----------------------------------------------------------------------------------------------