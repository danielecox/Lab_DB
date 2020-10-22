```sql
-- Atividade 5
-- 1) Mostre o nome, e-mail dos alunos, nome do cursoe turma, para os alunosque fizeram cursos em que não se matricularam homens;
SELECT a.nome_aluno, a.email_aluno, c.nome_curso, t.num_turma 
FROM aluno a JOIN matricula mt ON(a.id_aluno=mt.id_aluno)
             JOIN turma t ON(mt.num_turma=t.num_turma AND mt.id_curso=t.id_curso)
             JOIN curso c ON (t.id_curso=c.id_curso)
WHERE sexo_aluno NOT IN('M');             

-- 2) Mostre o nome dos fabricantes de software que ainda não tem softwares usados em cursos. Faça de três formas diferentes sendo uma com junção externa

-- OUTER JOIN
FROM curso c
    LEFT OUTER JOIN uso_softwares_curso usc
    ON(c.id_curso = usc.id_curso)
    JOIN software s
    ON (s.id_softw = usc.id_software)
    JOIN fabricante_softw f
    ON(f.id_fabr = s.id_fabr)
WHERE usc.id_curso IS NULL;    

-- NOT IN
SELECT f.nome_fabr
FROM fabricante_softw f
     JOIN software s 
     ON(f.id_fabr = s.id_fabr)
WHERE s.id_softw
     NOT IN (
        SELECT usc.id_curso
        FROM uso_softwares_curso usc
     );   

-- Minus
SELECT f.nome_fabr
FROM fabricante_softw f
     JOIN software s 
     ON(f.id_fabr = s.id_fabr)
WHERE s.id_softw
     IN(
        SELECT s.id_softw
        FROM fabricante_softw f
        JOIN software s
        ON(f.id_fabr = s.id_fabr)
        MINUS
        (SELECT usc.id_curso
        FROM uso_softwares_curso usc)
     );   
        
-- 3) Mostrar o nome do curso, valor do curso, turma, data de início e horário das aulas 
-- para as turmas que ainda não começaram,mas não tem ninguém matriculado. Mostre por extenso o horário da aula, 
-- por exemplo : SEGUNDA,QUARTA E SEXTA-FEIRA. Use junção externa. Faça de duas formas : com DECODE e outra com CASE.  

--DECODE
SELECT c.nome_curso, t.vl_curso, t.num_turma, TO_CHAR(t.dt_inicio, 'DD/MM/YYY'),
      DECODE(UPPER(t.horario_aula), 'SEG', 'SEGUNDA-FEIRA')||
      DECODE(UPPER(t.horario_aula), 'TERCA', 'TERCA-FEIRA')||
      DECODE(UPPER(t.horario_aula), 'QUA', 'QUARTA-FEIRA')||
      DECODE(UPPER(t.horario_aula), 'QUI', 'QUINTA-FEIRA')||
      DECODE(UPPER(t.horario_aula), 'SEX', 'SEXTA-FEIRA')||
      DECODE(UPPER(t.horario_aula), 'SAB', 'SABADO')||
      DECODE(UPPER(t.horario_aula), 'DOM', 'DOMINGO') AS "Horario da aula"
FROM curso c 
     LEFT JOIN turma t
     ON(c.id_curso = t.id_curso)
WHERE t.num_turma 
     NOT IN(
        SELECT mt.num_turma
        FROM matricula mt
     );
     
-- CASE
SELECT c.nome_curso, t.vl_curso, t.num_turma, TO_CHAR(t.dt_inicio, 'DD/MM/YYY'),
      CASE(UPPER(t.horario_aula))
        WHEN 'SEG' THEN 'SEGUNDA-FEIRA'
        WHEN 'TER' THEN 'TERCA-FEIRA'
        WHEN 'QUA' THEN 'QUARTA-FEIRA'
        WHEN 'QUI' THEN 'QUINTA-FEIRA'
        WHEN 'SEX' THEN 'SEXTA-FEIRA'
        WHEN 'SAB' THEN 'SABADO'
        WHEN 'DOM' THEN 'DOMINGO'
      END AS "Horario aula"
FROM curso c 
     LEFT JOIN turma t
     ON(c.id_curso = t.id_curso)
WHERE t.num_turma 
     NOT IN(
        SELECT mt.num_turma
        FROM matricula mt
     );
     
     
-- 4) Mostrar para  os  cursos  de  certificações ‘PROFESSIONAL’as  turmas  que  tem  alunos  matriculados  
--mas  o  curso  ainda  não aulas programadas: 
--Nome do curso,nome da certificação, quantidade de aulas,nome do aluno, sexo, código da turma, data de início e data prevista de término;
SELECT c.nome_curso, ce.nome_cert, c.qtde_aulas, a.nome_aluno, a.sexo_aluno, t.num_turma, t.dt_inicio, t.dt_termino
FROM aluno a JOIN matricula mt ON(a.id_aluno=mt.id_aluno)
             JOIN turma t ON(mt.num_turma=t.num_turma AND mt.id_curso=t.id_curso)
             JOIN curso c ON (t.id_curso=c.id_curso)
             JOIN certificacao ce ON(ce.id_cert=c.id_cert)
             JOIN empresa_certificacao emp ON(ce.id_empresa_cert=emp.id_empresa)
             JOIN aula al ON (al.id_curso=c.id_curso)
WHERE c.id_cert != ce.id_cert_pre_req AND UPPER(al.conteudo_previsto) IS NULL;

-- 5) Mostrar  o  nome  do  curso  e  a  turma  para  os  cursos que  não  são de  certificações ‘INSTRUCTOR’ e que  
-- tiveram  mais  de  R$  2mil  de arrecadação na turma e com mais de 90% de preenchimento de vagas.
SELECT c.nome_curso, t.num_turma
FROM curso c
     JOIN turma t
     ON(c.id_curso = t.id_curso)
WHERE c.id_curso NOT IN (
                        SELECT c.id_curso
                        FROM curso c
                        JOIN certificacao ce
                        ON(c.id_cert=ce.id_cert)
                        WHERE UPPER(ce.nome_cert) LIKE '%INSTRUCTOR'
                    )
AND c.id_curso IN (
                    SELECT c.id_curso
                    FROM curso c
                    JOIN matricula mt ON(c.id_curso=mt.id_curso)
                    JOIN turma t ON(mt.num_turma=t.num_turma AND mt.id_curso=t.id_curso)   
                    HAVING SUM(mt.vl_pago) > 2000
                    GROUP BY c.id_curso
                )
AND c.id_curso IN (
                    SELECT c.id_curso
                    FROM curso c
                    JOIN matricula mt ON(c.id_curso=mt.id_curso)
                    JOIN turma t ON(mt.num_turma=t.num_turma AND mt.id_curso=t.id_curso)   
                    HAVING COUNT(mt.num_matricula) > (SUM(t.vagas)*10)/100
                    GROUP BY c.id_curso
                  );
```