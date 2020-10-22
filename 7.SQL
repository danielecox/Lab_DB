/*
Esquema de Relações Certificacoes - BD Objeto-Relacional
Aluno (id_aluno(PK), nome_aluno, sexo_aluno, dt_nascto_aluno, cpf_aluno, {end_aluno}, login, senha)
Certificacao (id_cert(PK), nome_cert, carga_hora_cert, tempo_maximo, empresa_certificadora)
Curso (id_curso(PK), nome_curso, carga_hora_curso, qtd_aula, nota_corte, REF certificacao, sequencia, {aulas_programadas}, {softwares_usados})
Aulas_programadas (numero, conteudo_previsto, atividade_prevista, material, arquivo_material)
continua...

********/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';
SELECT sessiontimezone, current_timestamp FROM dual;

-- definindo um vetor para telefones
DROP TYPE tipofone FORCE;
CREATE OR REPLACE TYPE tipofone AS VARRAY(5) OF INTEGER;

--definindo um tipo para endereco
DROP TYPE tipoendereco FORCE;
CREATE OR REPLACE TYPE tipoendereco AS OBJECT
(tipo_logradouro CHAR(10),
logradouro VARCHAR2(40),
numero INTEGER,
complemento CHAR(15),
bairro VARCHAR2(30),
cidade VARCHAR2(30),
UF CHAR(2),
email VARCHAR2(32),
fones tipofone) FINAL;

--tipo para aluno
DROP TYPE tipoaluno FORCE;
CREATE OR REPLACE TYPE tipoaluno AS OBJECT
(id_aluno INTEGER,
nome_aluno VARCHAR2(50),
sexo_aluno CHAR(1),
dt_nascto_aluno DATE,
cpf_aluno NUMBER(11),
end_aluno tipoendereco,
login CHAR(10),
senha CHAR(6)) FINAL;

--tabela tipada para aluno
DROP TABLE or_aluno CASCADE CONSTRAINTS;
CREATE TABLE or_aluno OF tipoaluno
(PRIMARY KEY (id_aluno),
nome_aluno NOT NULL,
CHECK(sexo_aluno IN('M','F')),
UNIQUE (cpf_aluno),
UNIQUE (login))
OBJECT IDENTIFIER IS SYSTEM GENERATED;

--populando aluno
INSERT INTO or_aluno VALUES(1, 'Jeronimo Torres', 'M', current_date - INTERVAL '23' YEAR, 12345, 
tipoendereco ('Avenida', 'Nazare', 1000, 'ap 33', 'Ipiranga', 'Sao Paulo', 'SP','torresj@gmail.com',
tipofone (11987654321, 11991188223, 11991234567)), 'jeron23', 'torres');

SELECT a.nome_aluno, a.sexo_aluno, a.end_aluno.logradouro, a.end_aluno.numero, a.end_aluno.bairro
FROM or_aluno a;

--o operadot TABLE abre o array
SELECT a.nome_aluno, a.sexo_aluno, a.end_aluno.logradouro, a.end_aluno.numero, a.end_aluno.bairro
FROM or_aluno a;

-- Tipo para certificacao
DROP TYPE tipocertificacao FORCE;
CREATE OR REPLACE TYPE tipocertificacao AS OBJECT
(id_cert CHAR(6),
nome_cert VARCHAR2(50),
carga_hora_cert SMALLINT,
tempo_maximo SMALLINT,
empresa_certificadora VARCHAR2(30)) FINAL;

--tabela tipada para certificacao
DROP TABLE or_certificacao CASCADE CONSTRAINTS;
CREATE TABLE or_certificacao OF tipocertificacao
(PRIMARY KEY (id_cert),
nome_cert NOT NULL, 
CHECK (carga_hora_cert > 0))
OBJECT IDENTIFIER IS SYSTEM GENERATED;

--populando certificacao
INSERT INTO or_certificacao VALUES('OCA', 'Oracle Certified Associate', 240, 180, 'Oracle Corporation');

--Tipo para curso --aulas_programadas e softwares_usados ainda não, serão tabelas aninhadas
DROP TYPE tipocurso FORCE;
CREATE OR REPLACE TYPE tipocurso AS OBJECT
(id_curso CHAR(6),
nome_curso VARCHAR2(50),
carga_hora_curso SMALLINT,
qtde_aulas SMALLINT,
nota_corte NUMBER(4,2),
certificacao REF tipocertificacao,
sequencia SMALLINT) FINAL;

--Tabela tipada para curso
DROP TABLE or_curso CASCADE CONSTRAINTS;
CREATE TABLE or_curso OF tipocurso
(PRIMARY KEY (id_curso),
nome_curso NOT NULL,
CHECK (carga_hora_curso > 0))
OBJECT IDENTIFIER IS SYSTEM GENERATED;

--Populando tabela curso
SELECT REF(ce) FROM or_certificacao ce WHERE ce.id_cert = 'OCA';

INSERT INTO or_curso VALUES('SQL', 'Fundamentos de SQL', 40, 10, 7.75, 
(SELECT REF(ce) FROM or_certificacao ce WHERE ce.id_cert = 'OCA'), 1);

SELECT c.nome_curso, c.qtde_aulas, c.certificacao.nome_cert, c.certificacao.empresa_certificadora
FROM or_curso c;

--Tipo aula Aulas_programadas (numero, conteudo_previsto, atividade_prevista, material, arquivo_material)
DROP TYPE tipoaula_programada FORCE;
CREATE OR REPLACE TYPE tipoaula_programada AS OBJECT
(numero SMALLINT,
conteudo_previsto VARCHAR2(100),
atividade_prevista VARCHAR2(50),
material VARCHAR2(30),
arquivo_material VARCHAR2(50));
```

# Atividade

```sql
--a)Defina um tipo para turmae a respectiva tabela tipada, com uma referência para o objeto curso. Popule com 
	--duas linhas a tabela tipada.
--Turma(num_turma(PK),dt_inicio,dt_termino,vagas,horario_aula,vl_curso,instrutor,situacao_turma)
DROP TYPE tipoturma FORCE;
CREATE OR REPLACE TYPE tipoturma AS OBJECT
(num_turma SMALLINT,
dt_inicio DATE,
dt_termino DATE,
vagas SMALLINT,
horario_aula CHAR(10),
valor_curso NUMBER(6,2),
instrutor VARCHAR2(50),
situacao VARCHAR2(10),
curso REF tipocurso) FINAL;

--Tabela tipada para turma
DROP TABLE or_turma CASCADE CONSTRAINTS;
CREATE TABLE or_turma OF tipoturma
(PRIMARY KEY (num_turma),
dt_inicio NOT NULL,
dt_termino NOT NULL,
CHECK (vagas > 0))
OBJECT IDENTIFIER IS SYSTEM GENERATED;

--Populando tabela turma
SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL';

INSERT INTO or_turma VALUES(1, current_date - 15, current_date + 15 , 50, '19h', 
500, 'Tobias Nascimento', 'ATIVA', (SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL'));

INSERT INTO or_turma VALUES(1, current_date - 20, current_date + 20 , 60, '20h', 
460, 'Laila Gomes', 'ATIVA', (SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL'));

SELECT t.num_turma,t.vagas, t.curso.nome_curso
FROM or_turma t;

--b)Defina  um  tipo  para empresa:  nome  e  nacionalidade  e  a  respectiva  tabela  tipada.  Popule  com  três empresas  (Ex:  Oracle,  Cisco  e Microsoft).
--Tipo empresa
DROP TYPE tipoempresa_certificadora FORCE;
CREATE OR REPLACE TYPE tipoempresa_certificadora AS OBJECT
(id_empresa CHAR(6),
nome_empresa CHAR(50),
nacionalidade CHAR(10)) FINAL;

--Tabela tipada para empresa_certificadora
DROP TABLE or_empresa_certificadora CASCADE CONSTRAINTS;
CREATE TABLE or_empresa_certificadora OF tipoempresa_certificadora
(PRIMARY KEY (id_empresa),
nome_empresa NOT NULL)
OBJECT IDENTIFIER IS SYSTEM GENERATED;

--Populando empresa_certificadora
INSERT INTO or_empresa_certificadora VALUES('ORA', 'Oracle Certified Associate', 'EUA');
INSERT INTO or_empresa_certificadora VALUES('MIC', 'Microsoft Corporation', 'EUA');
INSERT INTO or_empresa_certificadora VALUES('CIS', 'Cisco System Corporation', 'EUA');

--)Defina um tipo para software com os mesmosatributos que o relacional 
--mas agora com uma referência para o objeto Fabricante. Popule com uma linha para cada fabricante criado em b) para a tabela tipadade software. 

--Software(id_softw(PK),nome_softw,versao,sistema_operacional,fabricante)

--Tipo software
DROP TYPE tiposoftware FORCE;
CREATE OR REPLACE TYPE tiposoftware AS OBJECT
(id_softw CHAR(6),
nome_softw VARCHAR2(50),
versao VARCHAR(20),
sistema_operacional VARCHAR2(10),
fabricante REF tipoempresa_certificadora) FINAL;

--Tabela tipada para software
DROP TABLE or_software CASCADE CONSTRAINTS;
CREATE TABLE or_software OF tiposoftware
(PRIMARY KEY (id_softw),
nome_softw NOT NULL)
OBJECT IDENTIFIER IS SYSTEM GENERATED;

--Populando tabela turma
SELECT REF(temp) FROM or_empresa_certificadora temp WHERE id_empresa = 'ORA';

INSERT INTO or_software VALUES('PKC', 'Packet Trace', '7.3','Windows',
(SELECT REF(temp) FROM or_empresa_certificadora temp WHERE id_empresa = 'ORA'));
INSERT INTO or_software VALUES('MSQL', 'Workbench', '9.5','Windows',
(SELECT REF(temp) FROM or_empresa_certificadora temp WHERE id_empresa = 'MIC'));

SELECT s.nome_softw,s.sistema_operacional, s.fabricante.nome_empresa
FROM or_software s;

```

# Atividade - Pegar Correção

```sql
/**********************************
Atividade 6 - Banco de Dados Objeto-Relacional  : Com as instruções SQL para tipos e tabelas tipadas no Objeto Relacional
a)	Defina um tipo para turma e a respectiva tabela tipada, com uma referência para o objeto curso.
Popule com duas linhas a tabela tipada. 
Turma(num_turma(PK), REF curso,dt_inicio,dt_termino,vagas,horario_aula,vl_curso)***/
DROP TYPE tipoturma FORCE ;
CREATE TYPE tipoturma AS OBJECT
( num_turma SMALLINT,
dt_inicio DATE,
dt_termino DATE,
vagas SMALLINT,
dias_semana CHAR(15),
horario CHAR(10),
valor_curso NUMBER(6,2),
curso REF tipocurso) ;

ALTER TYPE tipoturma ADD ATTRIBUTE situacao_turma CHAR(12)
CASCADE ;
-- tabela tipada
DROP TABLE or_turma CASCADE CONSTRAINTS;
CREATE TABLE or_turma OF tipoturma 
( PRIMARY KEY(num_turma) ,
vagas NOT NULL,
CHECK ( situacao_turma IN ( 'ATIVA', 'CANCELADA', 'ENCERRADA')),
valor_curso NOT NULL ) 
OBJECT IDENTIFIER IS SYSTEM GENERATED ;

DESC or_curso ;
INSERT INTO or_curso VALUES ( 'DBA1', 'Administracao de Banco de Dados', 40, 75, 10, 1, 
   ( SELECT REF(ce) FROM or_certificacao ce WHERE ce.id_cert = 'OCA' )       ) ;
INSERT INTO or_turma VALUES ( 1, current_date + 10, current_date + 20, 20, 'SEG-QUA', '19-22hs', 500,
   ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL' ), 'ATIVA' ) ;
INSERT INTO or_turma VALUES ( 2, current_date + 15, current_date + 30, 30, 'TER-QUI-SEX', '19-22hs', 500,
   ( SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'DBA1' ), 'ATIVA' ) ; 
   
UPDATE or_turma SET dias_semana = 'SEG-QUA-SEX' WHERE num_turma = 1 ;

/*** b)	Defina um tipo para empresa : nome e nacionalidade e a respectiva tabela tipada. 
Popule com três empresas (Ex: Oracle, Cisco e Microsoft).  ***/
-- Empresa( nome, pais, area_atuacao)
DROP TYPE tipoempresa FORCE ;
CREATE TYPE tipoempresa AS OBJECT
( nome_empresa VARCHAR2(40) ,
pais CHAR(15),
area_atuacao VARCHAR2(30) ) ;

-- tabela tipada
DROP TABLE or_empresa CASCADE CONSTRAINTS ;
CREATE TABLE or_empresa OF tipoempresa
( UNIQUE (nome_empresa) ) 
OBJECT IDENTIFIER IS SYSTEM GENERATED ;

INSERT INTO or_empresa VALUES ( 'Cisco Systems Inc', 'EUA', 'Redes Computadores') ;
INSERT INTO or_empresa VALUES (  'Oracle Corporation', 'EUA', 'Banco de dados');
INSERT INTO or_empresa VALUES (  'Microsoft Corporation', 'EUA', 'Sistema Operacional');

/*** c)	Defina um tipo para software com os mesmos atributos que o relacional 
mas agora com uma referência para o objeto Fabricante. 
Popule com uma linha para cada fabricante criado em b) para a tabela tipada de software.  
Software(id_softw(PK),nome_softw,versao,sistema_operacional, REF empresa)
***/
DROP TYPE tiposoftware FORCE ;
CREATE TYPE tiposoftware AS OBJECT
( id_softw CHAR(6),
nome_softw VARCHAR2(30),
versao CHAR(10),
sistema_operacional VARCHAR2(20),
fabricante REF tipoempresa) ;
-- tabela tipada
DROP TABLE or_software CASCADE CONSTRAINTS ;
CREATE TABLE or_software OF tiposoftware
( PRIMARY KEY ( id_softw) ,
nome_softw NOT NULL ) 
OBJECT IDENTIFIER IS SYSTEM GENERATED ;

INSERT INTO or_software VALUES ( 'SQLDEV', 'SQL Developer', '4.1.0.19', 'Windows 10', 
(SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%ORACLE%' ) ) ;
INSERT INTO or_software VALUES ( 'PKTRAC', 'Cisco Packet Tracer', '7.2.1', 'Windows 10', 
(SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%CISCO%' )) ;
INSERT INTO or_software VALUES ( 'ORADB', 'Oracle DBMS', '19c', 'Windows 10', 
(SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%ORACLE%' )) ;
INSERT INTO or_software VALUES ( 'DTMOD', 'Oracle DataModeler', '10.1', 'Windows 10', 
(SELECT REF(e) FROM or_empresa e WHERE UPPER(e.nome_empresa) LIKE '%ORACLE%' )) ;
```

# Aula 20/out — Tabelas Aninhadas

```sql
/*****************************
Aula 20/0ut
*******************************/

/*******
Esquema de Relações Certificacoes - BD Objeto-Relacional
Aluno (id_aluno(PK), nome_aluno, sexo_aluno, dt_nascto_aluno, cpf_aluno, {end_aluno}, login, senha, {aulas_realizadas})
Certificacao (id_cert(PK), nome_cert, carga_hora_cert, tempo_maximo, empresa_certificadora)
Curso (id_curso(PK), nome_curso, carga_hora_curso, qtd_aula, nota_corte, REF certificacao, sequencia, {aulas_programadas}, {softwares_usados})
Aulas_programadas (numero, conteudo_previsto, atividade_prevista, material, arquivo_material)
continua...
Turma(num_turma(PK), REF curso, dt_inicio, dt_termino, vagas, horario_aula, vl_curso, {matricula})
Empresa(nome, pais, area_atuacao)
Software (id_softw(PK), nome_softw, versao, sistema_operacional, REF empresa)
Matricula( num_matricula, dt_hora_matr, val_pago, REF aluno, prova_certificacao, aproveitamento_final, frequencia_final, situacao_matr)
Aulas_realizadas(numero, REF curso, dt_hora_aula, conteudo_dado, instrutor, dt_hora_entrega_atividade, arquivo_atividade, aproveitamento_atividade, presenca)
********/

SELECT * FROM or_aluno;
/*deletar atributo*/
ALTER TYPE tipoaluno DROP ATTRIBUTE aulas_realizadas CASCADE;

--Estrutura para aninhar matricula em turma
DROP TYPE tipomatricula FORCE;
CREATE OR REPLACE TYPE tipomatricula AS OBJECT (
num_matricula INTEGER,
dt_hora_matr TIMESTAMP,
vl_pago NUMBER(6, 2),
aluno REF tipoaluno,
prova_certificacao NUMBER(5,2),
aproveitamento_final NUMBER(5,2),
frequencia_final NUMBER(5,2),
situacao_matr CHAR(15));

-- tipo tabela para tipomatricula
DROP TYPE tab_matriculas FORCE;
CREATE OR REPLACE TYPE tab_matriculas AS TABLE OF tipomatricula;

-- aninhando tab_matricula em turma
ALTER TYPE tipo_turma ADD ATTRIBUTE matriculas tab_matriculas CASCADE;

SELECT * FROM or_turma;

UPDATE or_turma t SET t.matriculas = 
    tab_matriculas (
        tipomatricula (matricula_seq.interval, current_timestamp - 1, 480, 
            (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 1), null, null, null, 'CURSANDO'),
        tipomatricula (matricula_seq.interval, current_timestamp, 490.33, 
            (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 2), null, null, null, 'CURSANDO'))
WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL';            
    
    
    
--conferindo se atualizou
SELECT t.num_turma, t.curso.id_curso, mt.aluno.nome_aluno, mt.*
FROM or_turma t, TABLE(t.matriculas) mt;

--excluindo um objeto da tabela aninhada
DELETE FROM TABLE (SELECT t.matriculas FROM or_turma t WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL') mt
WHERE mt.num_matricula  = 2020 AND UPPER(mt.aluno.nome_aluno) LIKE '%ASTRID%');

-- inserindo uma nova matricula na turma 1 de SQL - não precisa se como o outro, pois já existe dados na tabela de matriculas
INSERT INTO TABLE (SELECT t.matriculas FROM or_turma t WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL') mt
VALUES (matricula_seq.interval, current_timestamp, 455.55, 
            (SELECT REF(a) FROM or_aluno a WHERE a.id_aluno = 4), null, null, null, 'CURSANDO');

-- atualizando o valor pago de uma matricula
UPDATE TABLE (SELECT t.matriculas FROM or_turma t WHERE t.num_turma = 1 AND t.curso.id_curso = 'SQL') mt
SET mt.vl_pago = 477.77 
WHERE mt.num_matricula = 2021;

-- consulta das matriculas nas turmas com dados de aluno, curso e certificacao e ainda não começaram
SELECT t.num_turma, t.dias_semana, mt.num_matricula, t.valor_curso AS ValorCurso, mt.vl_pago AS ValorPago,
mt.aluno.nome_aluno, mt.aluno.end_aluno.logradouro, mt.aluno.end_aluno.bairro, t.curso.nome_curso, 
t.curso.certificacao.nome_cert
FROM or_turma t, TABLE(t.matriculas) mt
WHERE t.dt_inicio > current_date;

-- consulta das matriculas nas turmas com dados de aluno, curso e certificacao e ainda não começaram - Com telefone
SELECT t.num_turma, t.dias_semana, mt.num_matricula, t.valor_curso AS ValorCurso, mt.vl_pago AS ValorPago,
mt.aluno.nome_aluno, mt.aluno.end_aluno.logradouro, mt.aluno.end_aluno.bairro, t.curso.nome_curso, 
t.curso.certificacao.nome_cert, fn.*
FROM or_turma t, TABLE(t.matriculas) mt, TABLE(mt.aluno.end_aluno.fones fn)
WHERE t.dt_inicio > current_date;

-- aninhar as aulas programadas no curso
-- ESTRUTURA JA CRIADA
DROP TYPE tab_aulas_programadas FORCE;
CREATE OR REPLACE TYPE tab_aulas_programadas AS TABLE OF tipoaula_programada;

-- aninhando 
ALTER TYPE tipocurso ADD ATTRIBUTE aulas_programadas tab_aulas_programadas CASCADE;

-- excluindo aulas_programadas ( só se tiver no banco)
ALTER TYPE tipocurso DROP ATTRIBUTE aulas_programadas CASCADE;

-- atualizacao do curso SQL incluindo duas aulas
UPDATE or_curso c SET c.aulas_programadas = 
    tab_aulas_programadas (
        tipoaula_programada (1, 'Visão Geral SQL', 'Exercicios capitulo 1', 'Capitulo 1', 'SQL_Fundamentos.pdf'),
        tipoaula_programada (2, 'Comandos DDL', 'Exercicios 3 a 20 cap 2', 'Capitulo 2', 'SQL_Fundamentos.pdf'),
                            )
WHERE c.id_curso = 'SQL';

-- conferindo
SELECT c.nome_curso, ap.*
FROM or_curso c, TABLE(c.aulas_programadas) ap;

-- aninhando as aulas realizadas na tabela aluno --
-- Aulas_realizadas(numero, REF curso, dt_hora_aula, conteudo_dado, 
-- instrutor, dt_hora_entrega_atividade, arquivo_atividade, aproveitamento_atividade, presenca)
DROP TYPE tipoaula_realizada FORCE;
CREATE OR REPLACE TYPE tipoaula_realizada AS OBJECT
(num_aula INTEGER, 
curso REF tipocurso, 
dt_hora_aula TIMESTAMP,
conteudo_dado VARCHAR2(50),
instrutor CHAR(20),
dt_hora_entrega_atividade TIMESTAMP,
arquivo_atividade VARCHAR2(40),
aproveitamento_atividade NUMBER(5,2),
presenca CHAR(1));

-- tabela de tipoaula_realizada
DROP TYPE tab_aulas_realizadas FORCE;
CREATE OR REPLACE TYPE tab_aulas_realizadas AS TABLE OF tipo_aula_realizada;

-- aninhando em aluno
ALTER TYPE tipoaluno ADD ATTRIBUTE aulas_realizadas tab_aulas_realizadas CASCADE;

-- inserindo uma nova aula para o Jeronimo
UPDATE or_aluno a SET a.aulas_realizadas = 
    tab_aulas_realizadas ( tipoaula_realizadas(1, (SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL'),
                            current_timestamp + 10,'o previsto', 'Ze Maria', null, null, null, null))
WHERE a.id_aluno = 1;                             

-- incluindo uma nova aula para o aluno Jeronimo
INSERT INTO TABLE (SELECT a.aulas_realizadas FROM or_aluno a WHERE a.id_aluno = 1)
VALUES (2, (SELECT REF(c) FROM or_curso c WHERE c.id_curso = 'SQL'),
                            current_timestamp + 10,'o previsto', 'Maze', null, null, null, null);

-- conferindo
SELECT a.nome_aluno, ar.*
FROM or_aluno a, TABLE (a.aulas_relizadas) ar;

-- consulta comparando aula relizada X aula programada
SELECT a.nome_aluno, ar.curso.nome_curso, ar.curso.certificacao.nome_cert, 
ap.numero AS Aula, ar.dt_hora_aula, ap.conteudo_previsto AS Previsto
ar.conteudo_dado AS Dado, ap.*
FORM or_aluno a, TABLE(a.aulas_realizadas) ar, or_curso c, TABLE(c.aulas_programadas) ap
WHERE c.id_curso = ar.curso.id_curso
AND ap.numero = ar.num_aula
AND ar.dt_hora_aula >= current_timestamp;
```