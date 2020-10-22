-- a) Inclua uma nova coluna em turma : Certificação do Instrutor;

DESC turma;
ALTER TABLE turma ADD (
cert_instrutor VARCHAR2(50) NOT NULL);

--b) Crie as seguintes constraintsde verificação : 
--Situação em Turma: Ativa, Cancelada, Encerrada;
--Situação em Matrícula : Cursando, Cancelada, Aprovado ou Reprovado;

ALTER TABLE turma ADD CONSTRAINT chk_situ_turma CHECK (situacao IN('ATIVA', 'CANCELADA', 'ENCERRADA'));
ALTER TABLE turma ADD CONSTRAINT chk_situ_matricula CHECK (situacao IN('CURSANDO', 'CANCELADA', 'APROVADO', 'REPROVADO'));

-- c) Renomeie alguma coluna;
DESC software;
ALTER TABLE software RENAME COLUMN sistema_operarional TO sist_operacional;

--d) Renomeie a tabela softw_uso_curso para Uso_softwares_curso;
ALTER TABLE softw_uso_curso RENAME TO Uso_softwares_curso;

-- e) Altere o tipo de dados de alguma coluna CHAR para VARCHAR2 e altere o tamanho ;
DESC aluno;
ALTER TABLE aluno MODIFY login VARCHAR2(10);

-- f) Coloque valores default para todas as colunas que indiquem aproveitamento e para a data e hora de entrega da atividade.
ALTER TABLE participacao_aula MODIFY aproveitamento_atividade DEFAULT 0;
ALTER TABLE matricula MODIFY aproveitamento_final DEFAULT 0;
ALTER TABLE aula MODIFY atividade DEFAULT current_timestamp;
ALTER TABLE participacao_aula MODIFY data_hora_entrega DEFAULT current_timestamp;

--g) Insira duas linhas em cada tabela criada na atividade 1 acima;

DESC software;
ALTER TABLE software ADD (
valor NUMBER(5,2) NOT NULL,
ocupacao_memoria NUMBER(5) NOT NULL );

DESC matricula;
ALTER TABLE matricula ADD (
desconto NUMBER(5,2) NOT NULL,
valor_total NUMBER(5,2) NOT NULL );

DESC turma;
ALTER TABLE turma ADD (
detalhes_turma VARCHAR2(10) NOT NULL,
sala NUMBER(2) NOT NULL );

--h) Depois de populada a tabela Software, 
SELECT * FROM software;
INSERT INTO software VALUES (10, 'SQLDeveloper', '19.2.1', 'Windows', 'Oracle Corporation', 0, 430.9);
INSERT INTO software VALUES (20, 'cisco packet tracer', '7.3.1', 'Windows', 'Cisco Systems Inc', 0, 471.7 );

-- transforme a coluna Fabricante em uma nova tabela ( id, nome, país)
DROP TABLE fabricante CASCADE CONSTRAINTS;
CREATE TABLE fabricante(
id_fabricante SMALLINT PRIMARY KEY NOT NULL,
nome_fabricante VARCHAR2(50) NOT NULL,
pais_fabricante VARCHAR2(20) NOT NULL);

-- Preencha o nomecom o conteúdo que existe na coluna original em Software; 
INSERT INTO fabricante VALUES (10, 'CISCO SYSTEMS INC', 'EUA');
INSERT INTO fabricante VALUES (20, 'ORACLE CORPORATION', 'EUA');
INSERT INTO fabricante VALUES (30, 'MICROSOFT CORPORATION', 'EUA');
SELECT * FROM fabricante;

--estabeleça o relacionamento incluindo o id do fabricante natabela software e atualizando os dados.
ALTER TABLE software ADD id_fabricante SMALLINT;
SELECT * FROM software;

UPDATE software s SET s.id_fabricante = (SELECT fab.id_fabricante 
                                               FROM fabricante fab
                                               WHERE UPPER(s.fabricante) LIKE '%'||UPPER(fab.nome_fabricante)||'%');

ALTER TABLE software MODIFY id_fabricante NOT NULL;
ALTER TABLE software ADD CONSTRAINT fk_fabricante FOREIGN KEY(id_fabricante)
                                                  REFERENCES fabricante(id_fabricante);

--Posteriormente exclua a coluna fabricante.
ALTER TABLE software DROP COLUMN fabricante;