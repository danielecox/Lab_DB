/*O projeto para o semestre é um banco de certificação de cursos

Entidades

- Certificação
- Cursos
- Softwares
- Material de Aula
- Aula
- Turma
- Aluno

Relacionamentos

- Certificação -1 composto N- Curso
- Curso -1 composto N- Aula
- Curso -1 oferece N- Turma
- Curso -N utiliza N- Software
- Aluno -N matricula N- Turma
- Aluno -N participa N- Aula

Criação do Banco

```sql*/ 
/* Esquema de Relações - Controle de Certificacoes 

***/

/* Esquema de Relacoes - Controle de Certificacoes 
Aluno(id_aluno(PK),nome_aluno,sexo_aluno,dt_nascto_aluno,cpf_aluno,end_aluno,email_aluno,fone_aluno,login,senha)
Certificacao(id_cert(PK),nome_cert,carga_hora_cert,nota_corte_cert,tempo_maximo,situacao_cert,empresa_certificadora,id_cert_pre_req(FK))
Curso(id_curso(PK),nome_curso,carga_hora_curso,qtde_aulas,nota_corte_curso,sequencia,situacao_curso,id_cert(FK),id_curso_pre_req(FK))
Aula(num_aula(PK),id_curso(PK)(FK),dt_hora_aula,conteudo_previsto,conteudo_ministrado,atividade,material,arquivo_material)
Turma(num_turma(PK),id_curso(PK)(FK),dt_inicio,dt_termino,vagas,horario_aula,vl_curso,instrutor,situacao_turma)
Software(id_softw(PK),nome_softw,versao,sistema_operacional,fabricante)
Matricula(num_matricula(PK),dt_hora_matr,vl_pago,situacao_matr,id_aluno(FK),num_turma(FK),id_curso(FK),prova_certificacao,
aproveitamento_final,frequencia_final)
Parcitipacao_aula(num_aula(PK),id_curso(PK)(FK),id_aluno(FK),arquivo_atividade_entregue,data_hora_entrega,aproveitamento_atividade,presenca)
Utilizacao_software(id_curso(PK)(FK),id_software(PK)(FK))
**/

/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

DROP TABLE aluno CASCADE CONSTRAINTS;
CREATE TABLE aluno (
id_aluno INTEGER PRIMARY KEY, 
nome_aluno VARCHAR2(50) NOT NULL, 
sexo_aluno CHAR(1) NOT NULL CHECK (sexo_aluno IN ('M', 'F')), 
dt_nascto DATE NOT NULL, 
cpf_aluno NUMBER(11) NOT NULL, 
end_aluno VARCHAR2(75) NOT NULL, 
email_aluno VARCHAR2 (32) NOT NULL, 
fone_aluno NUMBER(11) NOT NULL, 
login CHAR (10) NOT NULL, 
senha CHAR (8) NOT NULL, 
UNIQUE(cpf_aluno), 
UNIQUE(login) );

--tabela certificacao
--Certificacao(id_cert(PK),nome_cert,carga_hora_cert,nota_corte_cert,tempo_maximo,situacao_cert,empresa_certificadora,id_cert_pre_req(FK))
DROP TABLE certificacao CASCADE CONSTRAINTS; 
CREATE TABLE certificacao ( 
id_cert CHAR(6) NOT NULL, 
nome_cert VARCHAR2(50) NOT NULL, 
carga_hr_cert NUMBER(5,2) NOT NULL, 
nota_corte_cert NUMBER(5,2) NOT NULL, 
tempo_maximo SMALLINT NOT NULL, 
situacao_cert VARCHAR2(15) NOT NULL, 
empresa_certificadora VARCHAR2(30) NOT NULL, 
id_cert_pre_req NULL, 
PRIMARY KEY (id_cert), 
FOREIGN KEY(id_cert_pre_req) 
REFERENCES certificacao(id_cert) ); 

--tabela curso 
--Curso (id_curso(PK),nome_curso,carga_hora_curso,qtde_aulas,nota_corte_curso,sequencia,situacao_curso,id_cert(FK),id_curso_pre_req(FK)) 
DROP TABLE curso CASCADE CONSTRAINTS; 
CREATE TABLE curso ( 
id_curso CHAR(6) CONSTRAINT pk_curso PRIMARY KEY, 
nome_curso VARCHAR2(50) CONSTRAINT nn_nmcurso NOT NULL, 
carga_hora_curso SMALLINT NOT NULL, 
qtde_aulas SMALLINT NOT NULL, 
nota_corte_curso NUMBER(5,2) NOT NULL, 
sequencia_curso SMALLINT NOT NULL, 
situacao_curso VARCHAR2(15) NOT NULL, 
id_cert CHAR(6) NOT NULL REFERENCES certificacao(id_cert), 
id_curso_pre_req NULL REFERENCES curso(id_curso) ); 
/* PARA CONFERIR A CONSTRAINT CRIADA CASO APRESENTE ERRO SELECT constraint_name, constraint_type, table_name FROM */ 

--tabela aula 
--Aula (num_aula(PK),id_curso(PK)(FK),dt_hora_aula,conteudo_previsto,conteudo_ministrado,atividade,material,arquivo_material) 
DROP TABLE aula CASCADE CONSTRAINTS; 
CREATE TABLE aula ( 
num_aula SMALLINT NOT NULL, 
id_curso CHAR(6) NOT NULL REFERENCES curso(id_curso) ON DELETE CASCADE, 
dt_hora_aula TIMESTAMP NOT NULL, 
conteudo_previsto VARCHAR2(100) NOT NULL, 
conteudo_ministrado VARCHAR2(100) NOT NULL, 
atividade VARCHAR2(200) NOT NULL, 
material VARCHAR2(50) NOT NULL, 
arquivo_material VARCHAR2(50) NOT NULL, 
PRIMARY KEY(num_aula, id_curso) );

--tabela participacao_aula 
--Participacao_Aula (num_aula(PK),id_curso(PK)(FK),id_aluno(FK),arquivo_atividade_entregue,data_hora_entrega,aproveitamento_atividade,presenca) 
DROP TABLE participacao_aula CASCADE CONSTRAINTS; 
CREATE TABLE participacao_aula( 
num_aula SMALLINT NOT NULL, 
id_curso CHAR(6) NOT NULL, 
id_aluno INTEGER NOT NULL, 
arquivo_atividade_entregue VARCHAR2(50) NULL, 
data_hora_entrega TIMESTAMP NULL, 
aproveitamento_atividade NUMBER(5,2) NULL, 
presenca CHAR(1) NOT NULL CHECK(presenca IN ('P', 'F')), 
PRIMARY KEY(num_aula, id_curso, id_aluno), 
FOREIGN KEY(num_aula, id_curso) REFERENCES Aula(num_aula, id_curso) ON DELETE CASCADE, 
FOREIGN KEY(id_aluno) REFERENCES aluno ON DELETE CASCADE ); 

--CRIACAO DE SEQUENCA AUTO-INCREMENT PARA id_aluno 
DROP SEQUENCE aluno_seq; 
CREATE SEQUENCE aluno_seq START WITH 200 INCREMENT BY 1 MINVALUE 200 MAXVALUE 10000 NOCYCLE;

--tabela turma
--Turma(num_turma(PK),id_curso(PK)(FK),dt_inicio,dt_termino,vagas,horario_aula,vl_curso,instrutor,situacao_turma)
DROP TABLE turma CASCADE CONSTRAINTS;
CREATE TABLE turma (
num_turma SMALLINT NOT NULL,
id_curso CHAR(6) NOT NULL,
data_inicio DATE NOT NULL,
data_termino DATE NOT NULL,
vagas SMALLINT NOT NULL,
horario_aula CHAR(10) NOT NULL,
valor_curso NUMBER(6,2) NOT NULL,
instrutor VARCHAR2(50) NOT NULL,
situacao VARCHAR2(10) NOT NULL,
PRIMARY KEY(num_turma, id_curso),
FOREIGN KEY(id_curso) REFERENCES curso ON DELETE CASCADE );

--tabela software
--Software(id_softw(PK),nome_softw,versao,sistema_operacional,fabricante)
DROP TABLE software CASCADE CONSTRAINTS;
CREATE TABLE software (
id_softw CHAR(6) PRIMARY KEY,
nome_softw VARCHAR2(50) NOT NULL,
versao VARCHAR(20) NOT NULL,
sistema_operarional VARCHAR2(10) NOT NULL,
fabricante VARCHAR2(50) NOT NULL );

--tabela matricula
--Matricula(num_matricula(PK),dt_hora_matr,vl_pago,situacao_matr,id_aluno(FK),num_turma(FK),id_curso(FK),prova_certificacao,aproveitamento_final,frequencia_final)
DROP TABLE matricula CASCADE CONSTRAINTS;
CREATE TABLE matricula (
num_matricula INTEGER PRIMARY KEY,
data_hora TIMESTAMP NOT NULL,
valor_pago NUMBER(6,2) NOT NULL,
situacao VARCHAR2(10) NOT NULL,
id_aluno INTEGER NOT NULL,
num_turma SMALLINT NOT NULL,
id_curso CHAR(6) NOT NULL,
prova_cert NUMBER(5,2) NOT NULL,
aproveitamento_final NUMBER(5,2) NOT NULL,
frequencia_final NUMBER(5,2) NOT NULL,
FOREIGN KEY(id_aluno) REFERENCES aluno ON DELETE CASCADE,
FOREIGN KEY(num_turma, id_curso) REFERENCES turma(num_turma, id_curso) ON DELETE CASCADE );

--tabela utilizacao software
--Utilizacao_software(id_curso(PK)(FK),id_software(PK)(FK))
DROP TABLE utilizacao_software CASCADE CONSTRAINTS;
CREATE TABLE utilizacao_software (
id_curso CHAR(6) NOT NULL,
id_softw CHAR(6) NOT NULL,
PRIMARY KEY (id_curso, id_softw),
FOREIGN KEY (id_curso) REFERENCES curso ON DELETE CASCADE,
FOREIGN KEY (id_softw) REFERENCES software ON DELETE CASCADE );

--Código da matrícula é uma sequênciacomeçando em 2000 ;
DROP SEQUENCE matricula_seq; 
CREATE SEQUENCE matricula_seq START WITH 2000 INCREMENT BY 1 MINVALUE 2000 MAXVALUE 10000 NOCYCLE;