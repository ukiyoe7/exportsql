

WITH PED_DT AS (SELECT ID_PEDIDO FROM PEDID WHERE PEDDTEMIS BETWEEN DATEADD(-60 DAY TO CURRENT_DATE) AND 'TODAY'),

PED AS (SELECT P.ID_PEDIDO,CLICODIGO,PEDDTEMIS,FUNCODIGO2,PEDORIGEM,FISCODIGO1 
           FROM PEDID P
            INNER JOIN PED_DT D ON P.ID_PEDIDO=D.ID_PEDIDO
             WHERE PEDORIGEM IN ('D','E')),

PED_GR AS (SELECT PG.ID_PEDIDO,CLICODIGO,PEDDTEMIS,PEDORIGEM,FISCODIGO1 
                FROM PEDID PG 
                  INNER JOIN PED_DT D ON PG.ID_PEDIDO=D.ID_PEDIDO
                   WHERE FISCODIGO1 IN ('5.94L','5.94G','5.91O')),

USE AS (SELECT FUNNOME,F.FUNCODIGO,USUNOME,USUCODIGO FROM FUNCIO F
                          LEFT JOIN USUARIO  U ON U.FUNCODIGO=F.FUNCODIGO                
                            WHERE 
                            (
                            -- FILIAIS
                            F.FUNCODIGO IN (2011,2029,1613,1973)
                            OR
                            -- FUNCIONARIOS MATRIZ
                            DPTCODIGO=2
                            OR
                            -- OUTROS
                            F.FUNCODIGO IN (43,2022)
                            OR
                            USUCODIGO=1
                            )),

UNI AS (SELECT EMPCODIGO EMPRESA,
           A.ID_PEDIDO,
            FISCODIGO1 CFOP, 
            PEDORIGEM,
             CLICODIGO,
              USUNOME USUARIO,
               FUNNOME NOME,
                APDATA 
                FROM ACOPED A
INNER JOIN PED P ON A.ID_PEDIDO=P.ID_PEDIDO
INNER JOIN USE U ON A.USUCODIGO=U.USUCODIGO
WHERE LPCODIGO=1 

UNION

SELECT EMPCODIGO EMPRESA,
           A2.ID_PEDIDO,
            FISCODIGO1 CFOP,
            PEDORIGEM,
             CLICODIGO,
              USUNOME USUARIO,
               FUNNOME NOME,
                APDATA 
                FROM ACOPED A2
INNER JOIN PED_GR PG ON A2.ID_PEDIDO=PG.ID_PEDIDO
INNER JOIN USE U2 ON A2.USUCODIGO=U2.USUCODIGO
WHERE LPCODIGO=1


UNION

SELECT EMPCODIGO EMPRESA,
           A.ID_PEDIDO,
            FISCODIGO1 CFOP,
            PEDORIGEM,
             CLICODIGO,
              USUNOME USUARIO,
               FUNNOME NOME,
                APDATA 
                FROM ACOPED A
INNER JOIN PED P ON A.ID_PEDIDO=P.ID_PEDIDO
INNER JOIN USE U2 ON A.USUCODIGO=U2.USUCODIGO
WHERE LPCODIGO=42

UNION

SELECT EMPCODIGO EMPRESA,
           A2.ID_PEDIDO,
            FISCODIGO1 CFOP,
            PEDORIGEM,
             CLICODIGO,
              USUNOME USUARIO,
               FUNNOME NOME,
                APDATA 
                FROM ACOPED A2
INNER JOIN PED_GR PG ON A2.ID_PEDIDO=PG.ID_PEDIDO
INNER JOIN USE U2 ON A2.USUCODIGO=U2.USUCODIGO
WHERE LPCODIGO=42

)

SELECT DISTINCT 
         EMPRESA,
           ID_PEDIDO,
            CFOP,
            PEDORIGEM,
             CLICODIGO,
              USUARIO,
               NOME,
                APDATA 
                FROM UNI
