WITH 
CLI AS (SELECT DISTINCT C.CLICODIGO,
                              CLINOMEFANT,
                                     C.GCLCODIGO,
                                      GCLNOME GRUPO,  
                                        SETOR
                                         FROM CLIEN C
                                          LEFT JOIN (SELECT CLICODIGO,E.ZOCODIGO,ZODESCRICAO SETOR FROM ENDCLI E
                                            LEFT JOIN (SELECT ZOCODIGO,ZODESCRICAO FROM ZONA WHERE ZOCODIGO IN (20,21,22,23,24,25,26,27,28))Z ON E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                                             LEFT JOIN GRUPOCLI GR ON C.GCLCODIGO=GR.GCLCODIGO),


CLI1 AS (SELECT DISTINCT CL.CLICODIGO,
                           GCLCODIGO,
                              GRUPO,
                               TBPCODIGO,
                                SETOR  FROM CLITBP CL 
LEFT JOIN CLI C ON CL.CLICODIGO=C.CLICODIGO),

CLI2 AS (SELECT DISTINCT 
                  CL.CLICODIGO,
                           GCLCODIGO,
                              GRUPO,
                               TBPCODIGO,
                                SETOR FROM CLITBPCOMB CL 
LEFT JOIN CLI C ON CL.CLICODIGO=C.CLICODIGO)

SELECT TA.TBPCODIGO COD_TABELA,
                      CLICODIGO,
                       GCLCODIGO,
                        GRUPO,
                         TBPDESCRICAO DESCRICAO,
                          TBPDTINICIO INICIO,
                           TBPDTVALIDADE VALIDADE,
                             SETOR 
                              FROM TABPRECO TA
LEFT JOIN CLI1 C1 ON TA.TBPCODIGO=C1.TBPCODIGO
WHERE TBPSITUACAO='A' AND TBPDTVALIDADE >='TODAY' AND 
TBPDESCRICAO NOT LIKE '%PROMO DO MES%' AND TBPTABCOMB='N' UNION

SELECT TA.TBPCODIGO COD_TABELA,
                     CLICODIGO,
                      GCLCODIGO,
                       GRUPO,
                        TBPDESCRICAO DESCRICAO,
                         TBPDTINICIO INICIO, 
                          TBPDTVALIDADE VALIDADE,
                           SETOR 
                            FROM TABPRECO TA
LEFT JOIN CLI2 C2 ON TA.TBPCODIGO=C2.TBPCODIGO
WHERE TBPSITUACAO='A' AND TBPDTVALIDADE >='TODAY' AND 
TBPDESCRICAO NOT LIKE '%PROMO DO MES%' AND TBPTABCOMB='S'