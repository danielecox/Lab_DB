## Código da aula

```sql
/***********************
Aula 02 - SQL -DDL e DML
************************/

/*****************************
Alteração nas tabelas
*****************************/

-- adicionando novas colunas -- no Oracle não tem COLUMN
DESC curso;
ALTER TABLE curso ADD (
conteudo VARCHAR2(50) NOT NULL,
duracao_aula SMALLINT NOT NULL );

--mudando o tipo de dado de uma coluna -- NO ORACLE não tem COLUMN
DESC aluno;
ALTER TABLE aluno MODIFY email_aluno CHAR(32);

--mudando o tamanho de uma coluna
ALTER TABLE curso MODIFY conteudo VARCHAR2(75) NULL;

-- definir valor default para a data_hora da matricula
ALTER TABLE matricula MODIFY data_hora DEFAULT current_timestamp;

-- definir uma restrição de verificação CHECK em certificacao
ALTER TABLE certificacao ADD CONSTRAINT chk_situ_cert CHECK (situacao_cert IN('ATIVA', 'SUSPENSA', 'DESCONTINUADA'));

-- renomeando uma coluna
DESC matricula;
ALTER TABLE matricula RENAME COLUMN prova_cert TO aproveitamento_prova_cert;

--renomeando uma tabela
ALTER TABLE utilizacao_software RENAME TO softw_uso_curso;

-- adicionar e excluir uma coluna
ALTER TABLE aluno ADD time_coracao VARCHAR2(50);
DESC aluno;
ALTER TABLE aluno DROP COLUMN time_coracao;

-- popular as tableas - DML - Insert, Update, Delete, Select - CRUD
DESC aluno;
SELECT * FROM aluno;
INSERT INTO aluno VALUES(aluno_seq.nextval, 'Joao Pereira Furtado', 'M', '10/05/1995', 1234, 'Rua Frei Joao, 100','jpereira@gmail.com',11987654321, 'jpereira', '123');
INSERT INTO aluno VALUES(aluno_seq.nextval, 'Maria Cristina Soares', 'F', current_date - INTERVAL '23' YEAR, 5678, 'Rua Vergueiro, 7200','mcrissoares@gmail.com',11912345678, 'mcrisso', '987');

UPDATE aluno SET end_aluno = 'Rua Frei Joao, 100 - Ipiranga',
                 email_aluno = 'jopereira@uol.com.br'
WHERE id_aluno = 200;

DELETE FROM aluno
WHERE id_aluno = 201;

-- certificacao
DESC certificacao;
INSERT INTO certificacao VALUES('CCNA','Cisco Certified Network Associate', 240, 75, 180, 'ATIVA', 'Cisco Systems Inc', null);
INSERT INTO certificacao VALUES('CCNP','Cisco Certified Network Professional', 240, 75, 180, 'ATIVA', 'Cisco Systems Inc', null);
UPDATE certificacao SET id_cert_pre_req = 'CCNA' WHERE id_cert = 'CCNP'
SELECT * FROM certificacao

INSERT INTO certificacao VALUES('OCA','Oracle Certified Associeate', 240, 75, 180, 'ATIVA', 'Oracle Corporation', null);

-- curso
DESC curso;
INSERT INTO curso VALUES ('CCNA1', 'Fundamentos de Redes', 40, 10, 75, 1, 'ATIVO', 'CCNA', null, 'Conceitos de redes', 60);
SELECT * FROM curso;
INSERT INTO curso VALUES ('CCNA2', 'Roteamento de Protocolos', 40, 10, 85, 2, 'ATIVO', 'CCNA', 'CCNA1', 'Conceitos de roteamento', 60);
INSERT INTO curso VALUES ('SQL', 'SQL Básico', 40, 10, 75, 1, 'ATIVO', 'OCA', null, 'Linguagem SQL', 60);

-- aula
DESC aula;
INSERT INTO aula VALUES (1, 'CCNA1', current_timestamp + 3, 'Conceitos de redes', 'Conceitos de redes', 'Exercicios 5 ao 20 do capitulo 1', 'Curso Redes Cisco', 'http://cisco.certificacao.ccna/redes.pdf');
INSERT INTO aula VALUES (1, 'SQL', current_timestamp + 7, 'criando tableas', 'criando tableas', 'lista 3', 'SQL para dummies', 'http://oracle.certificacao.oca/sql.html');
SELECT * FROM aula;

--participacao aula
DESC participacao_aula;
INSERT INTO participacao_aula (presenca, id_aluno, num_aula, id_curso) VALUES ('F', 200, 1, 'SQL');
INSERT INTO participacao_aula (id_aluno, presenca, num_aula, id_curso) VALUES ( 202,'F', 1, 'CCNA1');
SELECT * FROM participacao_aula;

-- transformar uma coluna em tabela auxiliar
SELECT * FROM certificacao;
-- criando a tabela da empresa certificadora
DROP TABLE empresa_certificacao CASCADE CONSTRAINTS;
CREATE TABLE empresa_certificacao(
id_empresa SMALLINT NOT NULL,
nome_empresa VARCHAR2(50) NOT NULL,
pais_empresa VARCHAR2(20) NOT NULL,
atuacao_principal VARCHAR2(20) NOT NULL );

-- acrescentando a PK
ALTER TABLE empresa_certificacao ADD CONSTRAINT pk_empresa_cert PRIMARY KEY (id_empresa);

-- populando a tabela
INSERT INTO empresa_certificacao VALUES (10, 'CISCO SYSTEMS INC', 'EUA', 'redes');
INSERT INTO empresa_certificacao VALUES (20, 'ORACLE CORPORATION', 'EUA', 'Banco de Dados');
INSERT INTO empresa_certificacao VALUES (30, 'MICROSOFT CORPORATION', 'EUA', 'Sistema Operacional');
SELECT * FROM empresa_certificacao;

-- adicionando nova coluna em certificacao que vai virar FK para empresa_certificacao
ALTER TABLE certificacao ADD id_empresa_cert SMALLINT;

-- carimbar o valor da PK da empresa_certificacao na coluna nova
-- maneira tosca
-- UPDATE certificacao SET id_empresa_cert = 10 WHERE UPPER(empresa_certificadora) LIKE %CISCO%;
-- melhor forma
UPDATE certificacao c SET c.id_empresa_cert = (SELECT empc.id_empresa 
                                               FROM empresa_certificacao empc
                                               WHERE UPPER(c.empresa_certificadora) LIKE '%'||UPPER(empc.nome_empresa)||'%');

-- transformar nova coluna em uma FK
ALTER TABLE certificacao MODIFY id_empresa_cert NOT NULL;
ALTER TABLE certificacao ADD CONSTRAINT fk_emp_cert FOREIGN KEY(id_empresa_cert)
                                                    REFERENCES empresa_certificacao(id_empresa);

-- excluindo a coluna original com o nome na tabela certificacao
ALTER TABLE certificacao DROP COLUMN empresa_certificadora;

-- resgatando os dados originais
SELECT c.*, ec.nome_empresa, ec.atuacao_principal
FROM certificacao c JOIN empresa_certificacao ec
ON (c.id_empresa_cert = ec.id_empresa);
```