WITH CLI AS (SELECT DISTINCT C.CLICODIGO,
                         CLINOMEFANT,
                          ENDCODIGO,
                           GCLCODIGO,
                           SETOR
                            FROM CLIEN C
                             LEFT JOIN (SELECT CLICODIGO,E.ZOCODIGO,ZODESCRICAO SETOR,ENDCODIGO FROM ENDCLI E
                              LEFT JOIN (SELECT ZOCODIGO,ZODESCRICAO FROM ZONA 
                              WHERE ZOCODIGO IN (20,21,22,23,24,25,26,27,28))Z ON 
                              E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                               WHERE CLICLIENTE='S'),
                               
                               
   FIS AS (SELECT FISCODIGO FROM TBFIS WHERE FISTPNATOP IN ('V','R','SR')),
    
    PED AS (SELECT ID_PEDIDO,
                    EMPCODIGO,
                    TPCODIGO,
                     PEDDTEMIS,
                      P.CLICODIGO,
                       GCLCODIGO,
                        SETOR,
                          CLINOMEFANT,
                           PEDORIGEM,
                            PEDVRDESCTO,
                            PEDVRTOTAL
                            FROM PEDID P
                             INNER JOIN FIS ON P.FISCODIGO1=FIS.FISCODIGO
                              INNER JOIN CLI C ON P.CLICODIGO=C.CLICODIGO AND P.ENDCODIGO=C.ENDCODIGO
                               WHERE PEDDTEMIS BETWEEN @#DATE#DATA_INCIO@ and  @#DATE#DATA_FIM@ AND PEDSITPED<>'C' ),
                               
      PROD AS (SELECT PROCODIGO,IIF(PROCODIGO2 IS NULL,PROCODIGO,PROCODIGO2)CHAVE,PROTIPO FROM PRODU WHERE PROTIPO IN ('F','P','E')),
      
     ACPD AS( SELECT DISTINCT A.ID_PEDIDO FROM ACOPED A
                                   INNER JOIN PED P ON A.ID_PEDIDO=P.ID_PEDIDO
                                    WHERE LPCODIGO = 1856)
                                    
                                    
                                    
        SELECT PD.ID_PEDIDO,
PD.EMPCODIGO,
PEDDTEMIS,
CLICODIGO,
CLINOMEFANT,
GCLCODIGO,
SETOR,
FISCODIGO,
PD.PROCODIGO,
CHAVE,
PDPDESCRICAO,
PEDVRDESCTO,
PEDVRTOTAL,
PEDVRDESCTO+PEDVRTOTAL TOTAL,
SUM(PDPQTDADE)QTD
FROM PDPRD PD
INNER JOIN ACPD AC ON PD.ID_PEDIDO=AC.ID_PEDIDO
INNER JOIN PED P ON PD.ID_PEDIDO=P.ID_PEDIDO
INNER JOIN PROD PR ON PD.PROCODIGO=PR.PROCODIGO

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13 ORDER BY ID_PEDIDO DESC                            
                                    
                                    
    