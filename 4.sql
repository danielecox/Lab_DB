```sql
-- 17 - Alunos matriculados em cursos que a empresa certificadora é a mesma empresa que fabrica os softwares usados nos cursos da certificação
SELECT a.nome_aluno, c.nome_curso, f.nome_fabr
FROM aluno a, matricula mt, turma t, curso c, certificacao ce, empresa_certificacao emp, software sw, softw_uso_curso swc, fabricante_softw fsw
WHERE a.id_aluno = mt.id_aluno --aluno x matricula
AND (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso) --matricula x turma
AND t.id_curso = c.id_curso --turma x curso
AND c.id_cert=ce-id_cert --curso com certificacao
AND ce.id_empresa_cert = emp.id_empresa --certificacao x empresa_certificadora
AND sw.id_softw = swc.id_software -- software x uso_software
AND swc.id_curso = c.id_curso -- uso_software x curso
AND sw.id_fabr = fsw.id_fabr -- software x fabricante
AND UPPER(emp.nome_empresa) LIKE '%'||UPPER(fsw.nome_fabr)||'%';

-- 18 - Funções de grupo - Agregação
SELECT COUNT(*) FROM  aluno;

SELECT COUNT(*) AS Contagem,
       SUM(c.carga_hora_curso) AS Soma,
       AVG(c.carga_hora_curso) AS Media,
       MAX(c.carga_hora_curso) AS MAIOR,
       MIN(c.carga_hora_curso) AS Menor
FROM curso c;

--19 por certificacao
SELECT c.id_cert AS Certificacao, COUNT(*) AS Contagem,
       SUM(c.carga_hora_curso) AS Soma,
       AVG(c.carga_hora_curso) AS Media,
       MAX(c.carga_hora_curso) AS MAIOR,
       MIN(c.carga_hora_curso) AS Menor
FROM curso c
GROUP BY c.id_cert;

-- 20 - Mostrar para cada curso (nome) o total arrecadado nos ultimos 12 meses
-- (considere a data de matricula)
SELECT c.nome_curso AS Curso, SUM(mt.vl_pago) AS "Total Arrecadado", COUNT(*) AS Matriculas
FROM curso c, matricula mt, turma t
WHERE mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso
AND t.id_curso = c.id_curso
AND mt.dt_hora_matr > current_timestamp - INTERVAL '12' MONTH
GROUP BY c.nome_curso 
ORDER BY 1;

SELECT COUNT(id_curso_pre_req) FROM curso; -- só conta linhas que não contém nulo

-- 21 - idem, agora por mes
SELECT c.nome_curso AS Curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes, SUM(mt.vl_pago) AS "Total Arrecadado", COUNT(*) AS Matriculas
FROM curso c, matricula mt, turma t
WHERE mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso
AND t.id_curso = c.id_curso
AND mt.dt_hora_matr > current_timestamp - INTERVAL '12' MONTH
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) 
ORDER BY 1, 2;

UPDATE matricula SET dt_hora_matr = dt_hora_matr - INTERVAL '1' MONTH
WHERE MOD(num_matricula,2) = 1;

UPDATE matricula SET dt_hora_matr = dt_hora_matr - INTERVAL '1' MONTH
WHERE MOD(num_matricula,2) = 1; -- mudando as datas dos impares

-- 22 - idem, mes que tenha arrecadado mais de 750
SELECT c.nome_curso AS Curso, EXTRACT(MONTH FROM mt.dt_hora_matr) AS Mes, SUM(mt.vl_pago) AS "Total Arrecadado", COUNT(*) AS Matriculas
FROM curso c, matricula mt, turma t
WHERE mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso
AND t.id_curso = c.id_curso
AND mt.dt_hora_matr > current_timestamp - INTERVAL '12' MONTH --filtro para linha
GROUP BY c.nome_curso, EXTRACT(MONTH FROM mt.dt_hora_matr) 
HAVING SUM(mt.vl_pago) > 750 --where para o grupo --filtro para o grupo
ORDER BY 1, 2;

**Where somente antes do Group By

--23 - mostrar a media de idade dos alunos por sexo e curso que tem mais de 1 matriculado
SELECT c.nome_curso, a.sexo_aluno, ROUND(AVG((current_date - a.dt_nascto_aluno)/365.25),0) AS Media_idade, COUNT(mt.id_aluno) AS Matriculados
FROM aluno a JOIN matricula mt
            ON (a.id_aluno = mt.id_aluno)
            JOIN turma t
            ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
            JOIN curso c 
            ON (t.id_curso = c.id_curso)
GROUP BY c.nome_curso, a.sexo_aluno
HAVING COUNT(mt.id_aluno) > 1
ORDER BY 1;

-- 24 - moste a qtde de alunos matriculados em cada turma
SELECT * from matricula

SELECT t.num_turma, t.id_curso, COUNT(*) AS Matriculados 
FROM turma t 
            JOIN matricula mt
            ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
GROUP BY t.num_turma, t.id_curso;

-- 25 - idem com menos de 10 e para cada certificacao
SELECT t.num_turma, t.id_curso, ce.nome_cert, COUNT(*) AS Matriculados, SUM(mt.vl_pago) AS "Arrecadacao" 
FROM turma t 
            JOIN matricula mt
            ON (mt.num_turma = t.num_turma AND mt.id_curso = t.id_curso)
            JOIN curso c
            ON(c.id_curso = t.id_curso)
            JOIN certificacao ce
            ON (ce.id_cert = c.id_cert)
GROUP BY t.num_turma, t.id_curso, ce.nome_cert
HAVING COUNT(*) < 10 AND SUM(mt.vl_pago) > 1000; -- no having pode ter somente condição de grupo
```