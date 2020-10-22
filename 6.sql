/* Esquema de Relacoes - Controle de Certificacoes 
Aluno(id_aluno(PK),nome_aluno,sexo_aluno,dt_nascto_aluno,cpf_aluno,end_aluno,email_aluno,fone_aluno,login,senha)
Certificacao(id_cert(PK),nome_cert,carga_hora_cert,nota_corte_cert,tempo_maximo,situacao_cert,empresa_certificadora,id_cert_pre_req(FK))
Curso(id_curso(PK),nome_curso,carga_hora_curso,qtde_aulas,nota_corte_curso,sequencia,situacao_curso,id_cert(FK),id_curso_pre_req(FK))
Aula(num_aula(PK),id_curso(PK)(FK),dt_hora_aula,conteudo_previsto,conteudo_ministrado,atividade,material,arquivo_material)
Turma(num_turma(PK),id_curso(PK)(FK),dt_inicio,dt_termino,vagas,horario_aula,vl_curso,instrutor,situacao_turma)
Software(id_softw(PK),nome_softw,versao,sistema_operacional,fabricante)
Matricula(num_matricula(PK),dt_hora_matr,vl_pago,situacao_matr,id_aluno(FK),num_turma(FK),id_curso(FK),prova_certificacao,
aproveitamento_final,frequencia_final)
Realizacao_aula(num_aula(PK),id_curso(PK)(FK),id_aluno(FK),arquivo_atividade_entregue,data_hora_entrega,aproveitamento_atividade,presenca)
Utilizacao_software(id_curso(PK)(FK),id_software(PK)(FK))
**/

-- novo usuario
create user c##lbd20202 identified by ipiranga ;
grant dba to c##lbd20202 ;

/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

-- tabela aluno
--Aluno(id_aluno(PK),nome_aluno,sexo_aluno,dt_nascto_aluno,cpf_aluno,end_aluno,email_aluno,fone_aluno,login,senha)
DROP TABLE aluno CASCADE CONSTRAINTS ;
CREATE TABLE aluno ( 
id_aluno INTEGER PRIMARY KEY, 
nome_aluno VARCHAR2(50) NOT NULL, 
sexo_aluno CHAR(1) NOT NULL CHECK ( sexo_aluno IN ( 'M', 'F') ) ,
dt_nascto_aluno DATE NOT NULL,
cpf_aluno NUMBER(11) NOT NULL,
end_aluno VARCHAR2(75) NOT NULL,
email_aluno VARCHAR2(32) NOT NULL,
fone_aluno NUMBER(11) NOT NULL,
login CHAR(10) NOT NULL,
senha CHAR(8) NOT NULL,
UNIQUE (cpf_aluno) ,
UNIQUE (login) ) ; 
-- para ver a estrutura da tabela
DESC aluno ;
-- tabela certificacao
/* Certificacao(id_cert(PK),nome_cert,carga_hora_cert,nota_corte_cert,tempo_maximo,situacao_cert,
empresa_certificadora,id_cert_pre_req(FK))*/
DROP TABLE certificacao CASCADE CONSTRAINTS ;
CREATE TABLE certificacao (
id_cert CHAR(6) NOT NULL,
nome_cert VARCHAR2(50) NOT NULL,
carga_hora_cert SMALLINT NOT NULL,
nota_corte_cert NUMBER(5,2) NOT NULL,
tempo_maximo SMALLINT NOT NULL,
situacao_cert VARCHAR2(15) NOT NULL,
empresa_certificadora VARCHAR2(30) NOT NULL,
id_cert_pre_req NULL,
PRIMARY KEY (id_cert),
FOREIGN KEY ( id_cert_pre_req) REFERENCES certificacao ( id_cert) ) ;
-- tabela curso
/* Curso(id_curso(PK),nome_curso,carga_hora_curso,qtde_aulas,nota_corte_curso,sequencia,
situacao_curso,id_cert(FK),id_curso_pre_req(FK)) */
DROP TABLE curso CASCADE CONSTRAINTS;
CREATE TABLE curso (
id_curso  CHAR(6) CONSTRAINT pk_curso PRIMARY KEY,
nome_curso VARCHAR2(50) CONSTRAINT nn_nmcurso NOT NULL,
carga_hora_curso SMALLINT NOT NULL,
qtde_aulas SMALLINT NOT NULL,
nota_corte_curso NUMBER(5,2) NOT NULL,
sequencia_curso SMALLINT NOT NULL,
situacao_curso VARCHAR2(15) NOT NULL,
id_cert CHAR(6) NOT NULL REFERENCES certificacao (id_cert) ,
id_curso_pre_req NULL REFERENCES curso ( id_curso) ) ;
-- tabela aula
/* Aula(num_aula(PK),id_curso(PK)(FK),dt_hora_aula,conteudo_previsto,conteudo_ministrado,
atividade,material,arquivo_material) */
DROP TABLE aula CASCADE CONSTRAINTS ;
CREATE TABLE aula (
num_aula SMALLINT NOT NULL ,
id_curso CHAR(6) NOT NULL REFERENCES curso ( id_curso) ON DELETE CASCADE ,
dt_hora_aula TIMESTAMP NOT NULL,
conteudo_previsto VARCHAR2(100) NOT NULL,
conteudo_ministrado VARCHAR2(100) NULL,
atividade VARCHAR2(200) NOT NULL,
material VARCHAR2(50) NOT NULL,
arquivo_material VARCHAR2(75) NOT NULL,
PRIMARY KEY ( num_aula, id_curso) ) ; 
-- tabela participacao do aluno na aula
 /* Participacao_aula(num_aula(PK),id_curso(PK)(FK),id_aluno(FK),arquivo_atividade_entregue,
 data_hora_entrega,aproveitamento_atividade,presenca) */
 DROP TABLE participacao_aula CASCADE CONSTRAINTS ;
 CREATE TABLE participacao_aula (
 num_aula SMALLINT NOT NULL,
 id_curso CHAR(6) NOT NULL, 
 id_aluno INTEGER NOT NULL,
 arquivo_atividade_entregue VARCHAR2(50) NULL,
 data_hora_entrega TIMESTAMP NULL,
 aproveitamento_atividade NUMBER(5,2) NULL,
 presenca CHAR(1) NOT NULL CHECK ( presenca IN ( 'P', 'F' ) ) ,
 FOREIGN KEY ( num_aula, id_curso) REFERENCES aula ( num_aula, id_curso) ON DELETE CASCADE ,
 FOREIGN KEY ( id_aluno ) REFERENCES aluno ON DELETE CASCADE ,
 PRIMARY KEY ( num_aula, id_curso, id_aluno)  ) ;
 -- criando uma sequencia de auto-numeracao para o id_aluno
 DROP SEQUENCE aluno_seq ;
 CREATE SEQUENCE aluno_seq START WITH 200 INCREMENT BY 1
 MINVALUE 200 MAXVALUE 10000 NOCYCLE ;
 
 SELECT * FROM user_sequences ;
 
 /*****************************
 Atividade 1  
1 Montar o script em SQL para a criacao das tabelas QUE NÃO FORAM IMPLEMENTADAS AINDA EM AULA, 
conforme o esquema de relacao gerado a partir da Atividade 0 acima, no SGBD Oracle com as seguintes caracteristicas: 
a) Codigo da matricula eh uma sequencia comecando em 2000 ;
b) Acoes referenciais ON DELETE .
 **************************/ 
 
 -- tabela turma
DROP TABLE turma CASCADE CONSTRAINTS ;
CREATE TABLE turma (
 num_turma SMALLINT NOT NULL,
 id_curso CHAR(6) NOT NULL REFERENCES curso ON DELETE CASCADE,
 dt_inicio DATE NOT NULL,
 dt_termino DATE NOT NULL,
 vagas SMALLINT NOT NULL,
 horario_aula CHAR(10) NOT NULL,
 vl_curso NUMBER(6,2) NOT NULL,
 instrutor VARCHAR2(50) NOT NULL,
 situacao_turma VARCHAR2(50) NOT NULL,
 PRIMARY KEY (num_turma, id_curso) );

-- tabela matricula
DROP TABLE matricula CASCADE CONSTRAINTS ;
CREATE TABLE matricula (
 num_matricula INTEGER NOT NULL PRIMARY KEY,
 dt_hora_matr TIMESTAMP NOT NULL,
 vl_pago NUMBER(6,2) NOT NULL,
 situacao_matr VARCHAR2(50) NOT NULL,
 id_aluno INTEGER NOT NULL REFERENCES aluno ON DELETE CASCADE,
 num_turma SMALLINT NOT NULL,
 id_curso CHAR(6) NOT NULL,
 prova_certificacao NUMBER(5,2) NOT NULL,
 aproveitamento_final NUMBER(5,2) NOT NULL,
 frequencia_final NUMBER(5,2) NOT NULL,
 FOREIGN KEY ( num_turma, id_curso) REFERENCES turma ON DELETE CASCADE );
 
 DROP SEQUENCE matr_seq ;
 CREATE SEQUENCE matr_seq START WITH 20000; 

-- tabela software
DROP TABLE software CASCADE CONSTRAINTS; 
CREATE TABLE software (
 id_softw CHAR(6) NOT NULL PRIMARY KEY,
 nome_softw VARCHAR2(50) NOT NULL,
 versao VARCHAR2(50) NOT NULL,
 sistema_operacional VARCHAR2(20) NOT NULL,
 fabricante VARCHAR2(50) NOT NULL );

-- tabela utilizacao do software pelo curso
DROP TABLE utilizacao_software CASCADE CONSTRAINTS ;
CREATE TABLE utilizacao_software (
 id_curso CHAR(6) NOT NULL REFERENCES curso ON DELETE CASCADE ,
 id_software CHAR(6) NOT NULL REFERENCES software ON DELETE CASCADE , 
 PRIMARY KEY (id_curso, id_software) );

/**************************
Aula 2 - SQL - DDL e DML
***************************/

/*****************************************************************
Alteracao na estrutura das tabelas 
******************************************************************/

```

```sql
-- adicionando novas colunas -- no oracle não tem COLUMN
DESC curso ;
ALTER TABLE curso ADD 
(conteudo VARCHAR2(50) NOT NULL,
duracao_aula SMALLINT NOT NULL )  ; 
-- mudando o tipo de dado de uma coluna --  COLUMN
DESC aluno ;
ALTER TABLE aluno MODIFY email_aluno CHAR(32) ;
-- mudando o tamanho de uma coluna 
ALTER TABLE curso MODIFY conteudo VARCHAR2(75) NULL ; 
-- definir um valor default para o data hora da matricula
ALTER TABLE matricula MODIFY dt_hora_matr DEFAULT current_timestamp ; 
-- definir uma restricao de verificacao - CHECK - em certificacao
ALTER TABLE certificacao ADD CONSTRAINT chk_situ_cert CHECK ( situacao_cert IN ( 'ATIVA', 'SUSPENSA', 'DESCONTINUADA') ) ; 
-- renomeando uma coluna
DESC matricula ;
ALTER TABLE matricula RENAME COLUMN prova_certificacao TO aproveitamento_prova_cert ;
-- renomeando uma tabela
ALTER TABLE utilizacao_software RENAME TO softw_uso_curso ; 
SELECT table_name FROM user_tables ;
-- adicionar e excluir uma coluna
ALTER TABLE aluno ADD time_coracao VARCHAR2(50) ;
DESC aluno ;
ALTER TABLE aluno DROP COLUMN time_coracao ; 
 -- popular as tabelas - DML - Data Manipulation Language - Insert, Update, Delete, select - CRUD 
 DESC aluno ;
 SELECT * FROM aluno ;
 INSERT INTO aluno VALUES ( aluno_seq.nextval, 'Joao Pereira Furtado', 'M', '10/05/1995', 1234, 'Rua fei Joao, 100-Ipiranga',
 'jpereira@gmail.com', 11987654321, 'jpereira', '123' ) ;
 INSERT INTO aluno VALUES ( aluno_seq.nextval, 'Maria Cristina Soares', 'F', current_date - INTERVAL '23' YEAR, 
 5678, 'Rua Vergueiro, 7200-Ipiranga',  'mcrissoares@gmail.com', 11912345678, 'mcrisso', '987' ) ; 
 UPDATE aluno SET end_aluno = 'Rua Frei Joao, 100 - Ipiranga',
                                 email_aluno = 'jopereira@uol.com.br'
 WHERE id_aluno = 200 ; 
 DELETE FROM aluno
 WHERE id_aluno = 201 ;
 -- certificacao
 DESC certificacao ;
 INSERT INTO certificacao VALUES ( 'CCNA', 'Cisco Certified Network Associate', 240, 75, 180, 'ATIVA', 
 'Cisco Systems Inc', null ) ; 
  INSERT INTO certificacao VALUES ( 'CCNP', 'Cisco Certified Network Professional', 240, 75, 180, 'ATIVA', 
 'Cisco Systems Inc', null ) ; 
 UPDATE certificacao SET id_cert_pre_req = 'CCNA' 
 WHERE id_cert = 'CCNP' ; 
 SELECT * FROM certificacao ;
INSERT INTO certificacao VALUES ( 'OCA', 'Oracle Certified Associate', 240, 75, 180, 'ATIVA', 
 'Oracle Corporation', null ) ; 
 -- curso
 DESC curso ;
 SELECT * FROM curso ;
 INSERT INTO curso VALUES ( 'CCNA1', 'Fundamentos de Redes', 40, 10, 75, 1, 'ATIVO', 'CCNA', null, 'conceitos de redes', 60) ;
 INSERT INTO curso VALUES ( 'CCNA2', 'Roteamento e protocolos', 40, 10, 85, 2, 'ATIVO', 'CCNA', 'CCNA1', 'conceitos de roteamento', 60) ; 
 INSERT INTO curso VALUES ( 'SQL', 'SQL Basico', 40, 10, 75, 1, 'ATIVO', 'OCA', null, 'linguagem SQL', 60) ;
-- aula
DESC aula ;
SELECT * FROM aula ;
INSERT INTO aula VALUES ( 1, 'CCNA1', current_timestamp + 3 , 'conceitos de redes', null, 'Exercicios 5 ao 20 do cap1',
'Curso Redes Cisco', 'http://cisco.certificacao.ccna/redes.pdf' ) ;
INSERT INTO aula VALUES ( 1, 'SQL', current_timestamp + 7 , 'criando tabelas', null, 'Lista 3',
'SQL para dummies', 'http://oracle.certificacao.oca/sql.html' ) ;
-- participacao aula
DESC participacao_aula ;
SELECT * FROM participacao_aula ;
INSERT INTO participacao_aula (presenca, id_aluno, num_aula, id_curso )
VALUES ( 'F', 200, 1, 'SQL') ;
INSERT INTO participacao_aula (id_aluno, presenca, num_aula, id_curso )
VALUES ( 202, 'F', 1, 'CCNA1') ;
```

```sql
/********************************
2- Com o comando ALTER TABLE da linguagem SQL: 
a) Inclua uma nova coluna em turma : Certificação do Instrutor;  **/
DESC turma ;
ALTER TABLE turma ADD instrutor_certificacao CHAR(6) ;
/* b) Crie as seguintes constraints de verificação : 
		Situação em Turma: Ativa, Cancelada, Encerrada ;
		Situação em Matrícula : Cursando, Cancelada, Aprovado ou Reprovado; */
ALTER TABLE turma ADD CONSTRAINT chk_turma_situ CHECK ( situacao_turma IN ( 'ATIVA', 'CANCELADA', 'ENCERRADA')) ;  
ALTER TABLE matricula ADD CONSTRAINT chk_matr_situ CHECK ( situacao_matr 
IN ( 'CURSANDO', 'CANCELADA', 'APROVADO', 'REPROVADO')) ;  
SELECT constraint_name , search_condition FROM user_constraints 
WHERE table_name = 'MATRICULA' ;
--c) Renomeie alguma coluna;
DESC software ;
ALTER TABLE software RENAME COLUMN versao TO versao_softw ;
DESC software ;
--d) Renomeie a tabela softw_uso_curso para Uso_softwares_curso ;
ALTER TABLE softw_uso_curso RENAME TO uso_softwares_curso ;
SELECT table_name FROM user_tables ;
--e) Altere o tipo de dados de alguma coluna CHAR para VARCHAR2 e altere o tamanho ;
DESC turma ;
ALTER TABLE turma MODIFY horario_aula VARCHAR2(15) ;
--f) Coloque valores default para todas as colunas que indiquem aproveitamento e para a data e hora de entrega da atividade.
ALTER TABLE matricula MODIFY aproveitamento_prova_cert DEFAULT 0.0 ;
ALTER TABLE matricula MODIFY aproveitamento_final DEFAULT 0.0 ;
ALTER TABLE participacao_aula MODIFY aproveitamento_atividade DEFAULT 0.0 ;
DESC aula ;
ALTER TABLE aula ADD dt_hora_entrega_atv TIMESTAMP DEFAULT current_timestamp ;
SELECT * FROM aula ;
--g) Insira duas linhas em cada tabela criada na atividade 1 acima;
-- turma
DESC turma ;
SELECT * FROM turma ;
INSERT INTO turma VALUES (1, 'CCNA1', current_date - 15, current_date + 15 , 50, 'Seg-Qua-Sex 19h', 
500, 'Tobias Nascimento', 'ATIVA' , 'CCNP') ;
INSERT INTO turma VALUES (3, 'SQL', current_date , current_date + 20 , 50, 'Sabado 8h-12h', 
500, 'Jaqueline Thompson', 'ATIVA' , 'OCP') ;
-- matricula
SELECT* FROM matricula ;
SELECT * FROM aluno ;
INSERT INTO matricula VALUES ( matr_seq.nextval, DEFAULT, 500, 'CURSANDO', 200, 1, 'CCNA1',  0, 0, 0 ) ;
INSERT INTO matricula VALUES ( matr_seq.nextval, DEFAULT, 400, 'CURSANDO', 201, 3, 'SQL',  0, 0, 0 ) ;
INSERT INTO matricula VALUES ( matr_seq.nextval, DEFAULT, 425, 'CURSANDO', 202, 3, 'SQL',  0, 0, 0 ) ;
-- software
DESC software;
SELECT * FROM software ;
INSERT INTO software VALUES ( 'SQLDEV', 'SQL Developer', '4.1.0.19', 'Windows 10', 'Oracle') ;
INSERT INTO software VALUES ( 'PKTRAC', 'Cisco Packet Tracer', '7.2.1', 'Windows 10', 'Cisco') ;
-- utilizacao do software
DESC uso_softwares_curso ;
SELECT * FROM uso_softwares_curso ;
INSERT INTO uso_softwares_curso VALUES ( 'SQL', 'SQLDEV' ) ;
INSERT INTO uso_softwares_curso VALUES ( 'CCNA1', 'PKTRAC' ) ;

/* h) Depois de populada a tabela Software, transforme a coluna Fabricante em uma nova tabela ( id, nome, país ) . 
Preencha o nome com o conteúdo que existe na coluna original em Software; 
estabeleça o relacionamento incluindo o id do fabricante na tabela software e atualizando os dados. 
Posteriormente exclua a coluna fabricante.
*****************************************/
DROP SEQUENCE fabr_seq ; 
CREATE SEQUENCE fabr_seq START WITH 10 INCREMENT BY 10 ;
DROP TABLE fabricante_softw CASCADE CONSTRAINT ;
CREATE TABLE fabricante_softw
( id_fabr SMALLINT PRIMARY KEY,
nome_fabr VARCHAR2(50) NOT NULL ,
pais_fabr CHAR(20) ) ;
SELECT * FROM fabricante_softw ;
-- populando
INSERT INTO fabricante_softw VALUES ( fabr_seq.nextval , 'Oracle Corporation', 'EUA' ) ;
INSERT INTO fabricante_softw VALUES ( fabr_seq.nextval , 'Cisco Systems Inc', 'EUA' ) ;
INSERT INTO fabricante_softw VALUES ( fabr_seq.nextval , 'Microsoft Corporation', 'EUA' ) ;
SELECT * FROM FABRICANTE_SOFTW ;
-- nova coluna em software
DESC software ;
ALTER TABLE software DROP COLUMN id_fabr ;
SELECT * FROM software ;
ALTER TABLE software ADD id_fabr SMALLINT ;
-- atualizando o valor
UPDATE software s SET s.id_fabr = (  SELECT fs.id_fabr 
                                                                 FROM fabricante_softw fs
                                                                 WHERE UPPER(fs.nome_fabr) LIKE '%'||UPPER(s.fabricante)||'%') ;
SELECT * FROM software ;
-- transformando em FK
ALTER TABLE software ADD FOREIGN KEY ( id_fabr) REFERENCES fabricante_softw ;
ALTER TABLE software MODIFY id_fabr NOT NULL ;
-- excluindo a coluna texto
--ALTER TABLE software DROP COLUMN fabricante ;
```

```sql
/*******
Atividade 03: Com a instrucao SELECT responda as seguintes consultas :
1- Mostrar os dados dos cursos no formato : 'Fundamentos de Redes tem carga horaria de 120 horas'  **/
SELECT c.nome_curso||' tem carga horaria de '||TO_CHAR(c.carga_hora_curso)||' horas' AS "Dados Curso"
FROM curso c 
ORDER BY c.nome_curso ;

/* 2- Mostrar o nome e carga horaria das certificaoees que tem 'PROFESSIONAL' ou 'INSTRUCTOR'
no nome e tem nota de corte superior a 85 */
SELECT ce.nome_cert, ce.carga_hora_cert, ce.nota_corte_cert
FROM certificacao ce
WHERE ( UPPER(ce.nome_cert) LIKE '%PROFESSIONAL%' 
          OR UPPER(ce.nome_cert) LIKE '%INSTRUCTOR%' )
AND ce.nota_corte_cert >= 85 ;

/* 3' Mostrar os dados das alunas que NÃO tem as letras k,w e y no login e que tem mais de 22 anos : 
Nome Aluna-Idade-login */
SELECT a.nome_aluno AS Aluna, ROUND((current_date-a.dt_nascto_aluno)/365.25,0) AS Idade, a.login
FROM aluno a
WHERE ROUND((current_date-a.dt_nascto_aluno)/365.25,0) > 22
AND a.sexo_aluno = 'F'
AND UPPER(a.login) NOT LIKE '%K%' 
          AND UPPER(a.login) NOT LIKE '%Y%' 
          AND UPPER(a.login) NOT LIKE '%W%' ; 

/* 4- Mostrar os dados das turmas que tem entre 30 e 40 vagas e valor entre R$ 450 e R$ 550 
que ainda nao comecaram :
Numero da Turma ' Data Inicio ' Valor ' Quantidade de vagas */
SELECT t.num_turma, TO_CHAR(t.dt_inicio, 'DD/MM/YYYY') AS Data_Inicio, t.vl_curso, t.vagas
FROM turma t
WHERE t.vagas BETWEEN 30 AND 50
AND t.vl_curso BETWEEN 450 AND 550
AND TO_DATE(TO_CHAR( t.dt_inicio, 'DD/MM/YYYY'))  > TO_DATE(TO_CHAR(current_timestamp, 'DD/MM/YYYY'))  ;

SELECT current_timestamp FROM dual ;

/* 5- Repetir a consulta 4 acima, usando a sintaxe do INNER JOIN e adicionando os seguintes criterios : 
para cursos com carga horaria inferiores a 200 horas, no formato : 
Nome do Curso- Carga Horaria- Numero da Turma ' Data Inicio ' Valor ' Quantidade de vagas */
SELECT c.nome_curso, c.carga_hora_curso, t.num_turma, t.dt_inicio, t.vl_curso, t.vagas
FROM turma t INNER JOIN curso c
                           ON ( t.id_curso = c.id_curso) 
WHERE t.vagas BETWEEN 30 AND 40
AND t.vl_curso BETWEEN 450 AND 550
AND TO_DATE(TO_CHAR( t.dt_inicio, 'DD/MM/YYYY'))  > TO_DATE(TO_CHAR(current_timestamp, 'DD/MM/YYYY'))
AND c.carga_hora_curso < 200 ;

/* 6- Mostrar os softwares utilizados em certificaoees da Oracle que tem pre-requisitos : 
Nome do Software-Versão-Id Certificacao Pre-Requisito */
SELECT s.nome_softw, s.versao_softw, ce.id_cert_pre_req
FROM software s, softw_uso_curso swc , curso c, certificacao ce, empresa_certificacao ec
WHERE s.id_softw = swc.id_software -- software x uso softw
AND swc.id_curso = c.id_curso  -- uso softw x curso
AND c.id_cert = ce.id_cert  -- curso x cert 
AND ce.id_empresa_cert = ec.id_empresa -- cert x empresa certificacao
AND UPPER(ec.nome_empresa) LIKE '%ORACLE%'
AND ce.id_cert_pre_req IS NOT NULL ;

SELECT * FROM certificacao ;

/* 7- Mostrar o nome dos alunos que fizeram matricula hoje entre 10 e 14 horas: 
Numero da Matricula-Data e Hora-Valor Pago-Turma-Nome Curso */
SELECT a.nome_aluno, mt.num_matricula, mt.dt_hora_matr, mt.vl_pago, t.num_turma, c.nome_curso
FROM aluno a, matricula mt, turma t , curso c
WHERE a.id_aluno = mt.id_aluno -- aluno x matricula
AND (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) -- matricula x turma 
AND t.id_curso = c.id_curso -- turma x curso
AND TO_CHAR(mt.dt_hora_matr, 'DD/MM/YYYY') = TO_CHAR(current_timestamp, 'DD/MM/YYYY') 
AND EXTRACT ( HOUR FROM mt.dt_hora_matr) BETWEEN 10 AND 14 ;

SELECT * FROM matricula ;
SELECT current_timestamp FROM dual ;

/* 8- Mostrar os alunos que cancelaram matricula em turmas que terminam 
no proximo mes em certificaoees oferecidas pela Cisco no formato - usando a sintaxe do INNER JOIN :
Numero Matricula ' Data Hora Matricula ' Nome do Aluno- Sexo- Turma ' Horario Aula-
Data Inicio-Data Termino- Nome do Curso ' Nome da Certificacao */
SELECT mt.num_matricula, mt.dt_hora_matr, a.nome_aluno, a.sexo_aluno, t.num_turma,
t.horario_aula, t.dt_inicio, t.dt_termino, c.nome_curso, ce.nome_cert
FROM aluno a INNER JOIN matricula mt ON ( a.id_aluno = mt.id_aluno)
                           INNER JOIN turma t ON ( mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
                           INNER JOIN curso c ON ( t.id_curso = c.id_curso)
                           INNER JOIN certificacao ce ON ( c.id_cert = ce.id_cert) 
                           INNER JOIN empresa_certificacao ec ON ( ce.id_empresa_cert = ec.id_empresa)
WHERE EXTRACT ( MONTH FROM t.dt_termino) = EXTRACT(MONTH FROM Current_date ) + 1
AND UPPER(ec.nome_empresa) LIKE '%CISCO%' ;
```