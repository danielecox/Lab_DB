-- 1 - Select simples que mostra todas as colunas e todas as linhas de uma tabela
SELECT * FROM certificacao;
SELECT COUNT(*) FROM certificacao;

-- 2- Descriminando as colunas e colocando alguma condição (filtro)
SELECT nome_cert, carga_hr_cert FROM certificacao WHERE carga_hr_cert >= 200

-- 3- Funções de formatação de caracteres: UPPER, LOWER, INITCAP
SELECT UPPER(nome_aluno) AS MAIUSCULO,
        LOWER(end_aluno) AS minusculo,
        INITCAP(email_aluno) AS "Comeca Maisc resto minusc"
FROM aluno
WHERE sexo_aluno != 'M';

-- 4- Operador de concatenação - Pipe duplo ||
SELECT nome_aluno ||' eh do sexo: ' || sexo_aluno|| ' e reside em '|| end_aluno
AS "Dados do aluno"
FROM aluno;

-- 5- Operador LIKE - busca não exata
SELECT nome_aluno, end_aluno 
FROM aluno 
WHERE UPPER(end_aluno) LIKE '%VERGUEIRO%';

SELECT nome_aluno, dt_nascto
FROM aluno
WHERE UPPER(nome_aluno) LIKE 'JO_O %';

SELECT nome_aluno, dt_nascto
FROM aluno
WHERE UPPER(nome_aluno) NOT LIKE '%SOARES';

-- 6 - Funções de data
SELECT * 
FROM aluno
WHERE dt_nascto >= '01/01/1996';

SELECT *
FROM turma
WHERE dt_inicio BETWEEN current_date - 7 AND current_date;

-- 7 - funções de data e hora mais comuns
SELECT * FROM dual;
SELECT current_date FROM dual; --padrão SQL (roda em qualquer banco)
SELECT sysdate FROM dual; -- Roda somente no oracle

SELECT current_timestamp FROM dual; -- padrão SQL
SELECT systimestamp FROM dual; -- Roda somente no oracle

-- 8 - Função WXTRACT - extrai um pedaço da data: mes, dia, ano, hora
SELECT EXTRACT (YEAR FROM current_date) FROM dual;
SELECT EXTRACT (MONTH FROM current_date) FROM dual;
SELECT EXTRACT (HOUR FROM current_timestamp) FROM dual;
SELECT EXTRACT (HOUR FROM systimestamp) FROM dual;
SELECT EXTRACT (YEAR FROM current_date) -1 FROM dual;

--ALUNO QUE NASCEU DEPOIS DE 1993
SELECT nome_aluno, dt_nascto
FROM aluno
WHERE EXTRACT(YEAR FROM dt_nascto) > 1993;

-- turmas que iniciaram mês passado
SELECT * 
FROM turma
WHERE EXTRACT(MONTH FROM dt_inicio) = EXTRACT(MONTH FROM current_date) -1

-- alunos que nasceram entre março e junho
SELECT nome_aluno, dt_nascto
FROM aluno
WHERE EXTRACT(MONTH FROM dt_nascto) BETWEEN 3 AND 6;

-- alunos que não nasceram entre março e junho
SELECT nome_aluno, dt_nascto
FROM aluno
WHERE EXTRACT(MONTH FROM dt_nascto) NOT BETWEEN 3 AND 6;

-- 9 - Operador INTERVAL - permite adcionar ou subtrair intervalos de data: mês, ano, dia, hora
SELECT current_timestamp + INTERVAL '30' MINUTE FROM dual;
SELECT current_timestamp + INTERVAL '1' YEAR FROM dual;
SELECT current_timestamp - INTERVAL '1' YEAR FROM dual;

-- alunos com mais de 18 anos
SELECT nome_aluno, dt_nascto
FROM aluno
WHERE dt_nascto + INTERVAL '18' YEAR <= current_date;
WHERE dt_nascto + INTERVAL '23' YEAR <= current_date;
WHERE dt_nascto + INTERVAL '23' YEAR > current_date;

-- 10 - Calculando a idade dos alunos
SELECT nome_aluno, ROUND((current_date - dt_nascto)/365.25, 1) AS idade
FROM aluno;

SELECT nome_aluno, ROUND(MONTHS_BETWEEN (current_date, dt_nascto)/12, 1) AS idade
FROM aluno;

/****************************
-- Junção interna - INNER JOIN
****************************/

-- 11 - Nome do curso e da certificação
SELECT curso.nome_curso, curso.id_cert, certificacao.id_cert, certificacao.nome_cert
FROM curso, certificacao
WHERE curso.id_cert = certificacao.id_cert; -- comparando valor da FK com a PK

-- 12 - Idem ao 11 apelidando as tabelas
SELECT c.nome_curso, c.id_cert, ce.id_cert, ce.nome_cert
FROM curso c, certificacao ce
WHERE c.id_cert = ce.id_cert; -- junção interna

-- 13 Usando a sintaxe do INNER JOIN
SELECT c.nome_curso, c.id_cert, ce.id_cert, ce.nome_cert
FROM curso c INNER JOIN certificacao ce
              ON (c.id_cert = ce.id_cert); -- colunas de junção PK e FK

/***************************
-- Junções com mais tabelas
***************************/

-- 14 - Junção com 3 tabelas -- qtde JOINS = numero de tabelas -1
SELECT t.*, c.nome_curso, c.carga_hora_curso, ce.nome_cert
FROM turma t INNER JOIN curso c --turma X curso
             ON (t.id_curso = c.id_curso)
             INNER JOIN certificacao ce --curso x certificacao
             ON (c.id_cert = ce.id_cert); 
WHERE EXTRACT(MONTH FROM t.dt_inicio) BETWEEN 8 AND 9;

-- 15 - Junção com 4 tabelas - aulas que tem a palavra conceito no conteudo
-- dados da aula, dados do curso, da certificacao e da empresa certificadora
SELECT a.num_aula, a.conteudo_previsto, c.nome_curso, ce.nome_cert, emp.nome_empresa, emp.atuacao_principal
FROM aula a, curso c, certificacao ce, empresa_certificacao emp
WHERE UPPER(a.conteudo_previsto) LIKE '%CONCEITO%'
AND a.id_curso = c.id_curso -- aula x curso
AND c.id_cert = ce.id_cert -- curso x certificacao
AND ce.id_empresa_cert = emp.id_empresa; -- certificacao x empresa certificadora

-- 16 - Idem ao 15 com INNER JOIN
SELECT a.num_aula, a.conteudo_previsto, c.nome_curso, ce.nome_cert, emp.nome_empresa, emp.atuacao_principal
FROM aula a INNER JOIN curso c -- aula x curso
            ON (a.id_curso = c.id_curso)
            INNER JOIN certificacao ce  -- curso x certificacao
            ON (c.id_cert = ce.id_cert)
            INNER JOIN empresa_certificacao emp
            ON (ce.id_empresa_cert = emp.id_empresa) -- certificacao x empresa certificadora
WHERE UPPER(a.conteudo_previsto) LIKE '%CONCEITO%';
```