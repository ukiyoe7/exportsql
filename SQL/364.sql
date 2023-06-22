
WITH CLI AS (SELECT DISTINCT C.CLICODIGO,
                         CLINOMEFANT,
                          ENDCODIGO,
                           GCLCODIGO,
                           SETOR
                            FROM CLIEN C
                             INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO,ZODESCRICAO SETOR,ENDCODIGO FROM ENDCLI E
                              INNER JOIN (SELECT ZOCODIGO,ZODESCRICAO FROM ZONA 
                              WHERE ZOCODIGO IN (20,21,22,23,24,25,26,27,26,27,28))Z ON 
                              E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                               WHERE CLICLIENTE='S' AND GCLCODIGO=175),
                               
                               
   FIS AS (SELECT FISCODIGO FROM TBFIS WHERE FISTPNATOP IN ('V','R','SR')),
    
    PED AS (SELECT ID_PEDIDO,
                
                     PEDDTEMIS,
                      P.CLICODIGO,
                       GCLCODIGO,
                        SETOR,
                          CLINOMEFANT,
                           PEDORIGEM
                            FROM PEDID P
                             INNER JOIN FIS ON P.FISCODIGO1=FIS.FISCODIGO
                              INNER JOIN CLI C ON P.CLICODIGO=C.CLICODIGO
                               WHERE PEDDTEMIS BETWEEN @#DATE#DATA_INCIO@ and  @#DATE#DATA_FIM@ AND PEDSITPED<>'C' ),
      
      
 PROD AS (SELECT PROCODIGO,IIF(PROCODIGO2 IS NULL,PROCODIGO,PROCODIGO2)CHAVE,PROTIPO FROM PRODU),
 
  VARILUX AS (SELECT PROCODIGO FROM PRODU WHERE MARCODIGO=57),
  
   EYEZEN AS (SELECT PROCODIGO FROM PRODU WHERE PRODESCRICAO LIKE '%EYEZEN%'),
     
    CRIZAL AS (SELECT PROCODIGO FROM PRODU WHERE PRODESCRICAO LIKE '%CRIZAL%' AND PROTIPO<>'T')
    
      SELECT PD.ID_PEDIDO,
               PEDDTEMIS,
                CLICODIGO,
                 CLINOMEFANT,
                  GCLCODIGO,
                   SETOR,
                     PD.PROCODIGO,
                         CHAVE,
                          CASE 
                          WHEN VLX.PROCODIGO IS NOT NULL THEN 'VARILUX'
                           WHEN EYZ.PROCODIGO IS NOT NULL THEN 'EYEZEN'
                            WHEN CRZ.PROCODIGO IS NOT NULL THEN 'CRIZAL'
                             ELSE NULL END MARCA,
                               PDPDESCRICAO,
                             SUM(PDPQTDADE)QTD,
                              SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA
                                FROM PDPRD PD
                                 INNER JOIN PED P ON PD.ID_PEDIDO=P.ID_PEDIDO
                                  LEFT JOIN PROD PR ON PD.PROCODIGO=PR.PROCODIGO
                                   LEFT JOIN VARILUX VLX ON PD.PROCODIGO=VLX.PROCODIGO
                                    LEFT JOIN EYEZEN EYZ ON PD.PROCODIGO=EYZ.PROCODIGO
                                     LEFT JOIN CRIZAL CRZ ON PD.PROCODIGO=CRZ.PROCODIGO
                                       GROUP BY 1,2,3,4,5,6,7,8,9,10 ORDER BY ID_PEDIDO DESC