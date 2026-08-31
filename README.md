# Modelagem do Banco de Dados

Esse projeto consiste na normalização de uma base de dados de uma concessionária fictícia e depois na criação do modelo dimensional, baseado no seu modelo relacional.

# Etapas

## Modelo Relacional

Para a criação do Modelo Relacional, o objetivo é aplicar as formas normais para evitar redundâncias de dados e transformar essa única tabela em várias tabelas mais organizadas.

### Script da Modelagem Relacional
1. Criação da tabela tb_vendedor e definição do tipo dos seus atributos.

    ```
    create table tb_vendedor (
        idVendedor integer primary key,
        nomeVendedor text not null,
        sexoVendedor smallint not null,
        estadoVendedor text not null
    );
    ```


2. Inserindo os dados na tabela baseado na tabela original tb_locacao.

    ```
    insert into tb_vendedor(idVendedor, nomeVendedor, sexoVendedor, estadoVendedor)
    select
	    distinct idVendedor,
	    nomeVendedor,
	    sexoVendedor,
	    estadoVendedor
    from tb_locacao
    ```
    
3. Checando se a tabela foi criada corretamente com os dados colocados.

    ```
    select *
    from tb_vendedor
    ```


4. Criando a tabela tb_carro e definindo o tipo de seus atributos.

    ```
    create table tb_carro (
        idCarro integer primary key,
        chassiCarro text not null,
        marcaCarro text not null,
        modeloCarro text not null,
        anoCarro integer not null
    );
    ```

5. Inserindo os dados na tabela baseado na tabela original tb_locacao.

   ```
   insert into tb_carro (idCarro, chassiCarro, marcaCarro, modeloCarro, anoCarro)
   select		-- deixarei de fora km pois pode variar com o carro que foi alugado
       distinct idCarro,
       chassiCarro,
       marcaCarro,
       modeloCarro,
       anoCarro
   from tb_locacao
   ```


6. Checando se a tabela foi criada corretamente com os dados colocados.

   ```
   select *
   from tb_carro
   ```


7. Criando a tabela tb_combustivel e definindo o tipo dos seus atributos.
    ```
    create table tb_combustivel (
    idCombustivel integer primary key,
    tipoCombustivel text not null
    );
    ```

8. Inserindo os dados na tabela baseado na tabela original tb_locacao.
   ```
   insert into tb_combustivel (idCombustivel, tipoCombustivel)
   select
       distinct idcombustivel as idCombustivel,
       tipoCombustivel
   from tb_locacao
   ```


9. Checando se a tabela foi criada corretamente com os dados colocados.
    ```
    select *
    from tb_combustivel
    ```


10. Criando a tabela tb_cliente e definindo o tipo de seus atributos.
    ```
    create table tb_cliente (
        idCliente integer primary key,
        nomeCliente text not null,
        cidadeCliente text not null,
        estadoCliente text not null,
        paisCliente text not null
    );
    ```


11. Inserindo os dados na tabela baseado na tabela original tb_locacao.
    ```
    insert into tb_cliente(idCliente, nomeCliente, cidadeCliente, estadoCliente, paisCliente)
    select
	    distinct idCliente,
	    nomeCliente,
	    cidadeCliente,
	    estadoCliente,
	    paisCliente
    from tb_locacao
    ```


12. Checando se a tabela foi criada corretamente com os dados colocados.
    ```
    select *
    from tb_cliente
    ```


13. Criando a tabela tb_cidade e definindo o tipo de seus atributos.
    ```
    create table tb_cidade (
        cidade text primary key,
        estado text not null,
        pais text not null
    );
    ```


14. Inserindo os dados na tabela baseado na tabela original tb_locacao.
    ```
    insert into tb_cidade(cidade, estado, pais)
    select
	    distinct cidadeCliente as cidade,
	    estadoCliente as estado,
	    paisCliente as pais
    from tb_cliente
    ```


15. Checando se a tabela foi criada corretamente com os dados colocados.
    ```
    select *
    from tb_cidade
    ```


16. Removendo as colunas de tb_locacao que possuem dependência transitiva.
    ```
    alter table tb_locacao
    drop nomeVendedor

    alter table tb_locacao
    drop sexoVendedor

    alter table tb_locacao
    drop estadoVendedor

    alter table tb_locacao
    drop chassiCarro

    alter table tb_locacao
    drop marcaCarro

    alter table tb_locacao
    drop modeloCarro

    alter table tb_locacao
    drop anoCarro

    alter table tb_locacao
    drop tipoCombustivel

    alter table tb_locacao
    drop nomeCliente

    alter table tb_locacao
    drop cidadeCliente

    alter table tb_locacao
    drop estadoCliente

    alter table tb_locacao
    drop paisCliente

    ```
    
    Removendo as colunas da tabela tb_cliente.
    ```
    alter table tb_cliente
    drop estadoCliente

    alter table tb_cliente
    drop paisCliente
    ```

17. Checando se a tabela tb_locacao está correta.
    ```
    select *
    from tb_locacao
    ```


18. Criação de uma nova tabela para tb_locacao onde será ajustado o formato de data.
    ```
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
    ```


19. Inserindo os elementos de tb_locacao em tb_locacao_ajustada.
    ```
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
    ```


20. Checando se a tabela nova está correta.
    ```
    select *
    from tb_locacao
    ```

 
21. Deletando a antiga tabela tb_locacao.
    ```
    drop table tb_locacao
    ```



23. Renomeando a nova tabela que agora será tb_locacao.
    ```
    alter table tb_locacao_ajustada rename to tb_locacao
    ```


### Diagrama do Modelo Relacional

Após obter o Modelo Relacional, temos as seguintes tabelase e suas respectivas relações ilustradas pelo diagrama abaixo. Nele, podemos notar que *tb_locacao* derivou as tabelas *tb_cliente*, *tb_vendedor*, *tb_carro*, *tb_combustivel* e *tb_cidade*. Cada tabela tem seus próprios atributos e elas se relacionam por meio da **primary key** contida em cada uma e em *tb_locacao*.

![diagrama](./Desafio_Parte_1/diagrama_modelo_relacional.png)

## Modelo Dimensional

Para a criação do Modelo Dimensional, são criadas dimensões que ajudam a ter uma visão melhor de cada entidade, tornando a visualização mais limpa e intuitiva. São feitas utilizando **views** no SQL e ficam a parte das tabelas já criadas para o Modelo Relacional.

### Script da Modelagem Dimensional

1. Criação e visualização da dimensão cliente.
   ```
   create view dim_cliente as
   select
   	idCliente as id,
   	nomeCliente as nome,
   	cidadeCliente as cidade,
   	tb_cidade.estado as estado,
   	tb_cidade.pais as pais
   from tb_cliente
   join tb_cidade on tb_cidade.cidade = tb_cliente.cidadeCliente
   ```

   ```
   select *
   from dim_cliente
   ```

2. Criação e visualização da dimensão carro.
   ```
   create view dim_carro as
   select
   	idCarro as id,
   	chassiCarro as chassi,
   	marcaCarro as marca,
   	anoCarro as ano
   from tb_carro
   ```

   
   ```
   select *
   from dim_carro
   ```


3. Criação e visualização da dimensão combustível.
   ```
   create view dim_combustivel as
   select
   	idCombustivel as id,
   	tipoCombustivel as tipo
   from tb_combustivel
   ```

   ```
   select *
   from dim_combustivel
   ```

4. Criação e visualização da dimensão vendedor.
   ```
   create view dim_vendedor as
   select
   	idVendedor as id,
   	nomeVendedor as nome,
   	sexoVendedor as sexo,
   	estadoVendedor
   from tb_vendedor
   ```
   ```
   select *
   from dim_vendedor
   ```

5. Criação e visualização da dimensão data.
   ```
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
   ```

   ```
   select *
   from dim_data
   ```

6. Criação e visualização da dimensão fato.
   ```
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
   ```
   
   ```
   select *
   from fato_locacao
   ```

### Diagrama do Modelo Dimensional

Após criar as dimensões, obtemos *dim_cliente*, *dim_vendedor*, *dim_carro*, *dim_combustivel*, *dim_data* e *fato_locacao*. Utilizando essas **views** podemos ter uma visualização mais intuitiva de como funcionam as tabelas e suas relações. Sendo possível observar melhor a relação de cada dimensão com seus próprios atributos ao invés de pensar no banco de dados como um todo.

![diagrama](./Desafio_Parte_2/diagrama_modelo_dimensional.png)
