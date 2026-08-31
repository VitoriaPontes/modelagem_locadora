-- criação do DW

-- dimensão cliente
create view dim_cliente as
select
	idCliente as id,
	nomeCliente as nome,
	cidadeCliente as cidade,
	tb_cidade.estado as estado,
	tb_cidade.pais as pais
from tb_cliente
join tb_cidade on tb_cidade.cidade = tb_cliente.cidadeCliente

select *
from dim_cliente

-- dimensão carro
create view dim_carro as
select
	idCarro as id,
	chassiCarro as chassi,
	marcaCarro as marca,
	anoCarro as ano
from tb_carro


select *
from dim_carro

-- dimensão combustivel
create view dim_combustivel as
select
	idCombustivel as id,
	tipoCombustivel as tipo
from tb_combustivel

select *
from dim_combustivel

-- dimensão vendedor
create view dim_vendedor as
select
	idVendedor as id,
	nomeVendedor as nome,
	sexoVendedor as sexo,
	estadoVendedor
from tb_vendedor

select *
from dim_vendedor

-- dimensão data
create view dim_data as
select
	dataLocacao as data,
	strftime('%Y', dataLocacao) as ano,
	strftime('%m', dataLocacao) as mes,
	strftime('%W', dataLocacao) as semana,
	strftime('%d', dataLocacao) as dia,
	horaLocacao as hora,
	'locacao' as tipo
from tb_locacao

union

select
	dataEntrega data,
	strftime('%Y', dataEntrega) as ano,
	strftime('%m', dataEntrega) as mes,
	strftime('%W', dataEntrega) as semana,
	strftime('%d', dataEntrega) as dia,
	horaEntrega as hora,
	'entrega' as tipo
from tb_locacao;

select *
from dim_data


-- fato_locacao
create view fato_locacao as
select
	idLocacao,
	idCliente,
	idCarro,
	idCombustivel,
	dataLocacao,
	qtdDiaria,
	vlrDiaria,
	dataEntrega,
	idVendedor
from tb_locacao

select *
from fato_locacao