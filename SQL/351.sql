-- DADOS DASHBOARD ADM

WITH FIS AS (SELECT FISCODIGO 
                     FROM TBFIS 
                      WHERE FISTPNATOP IN ('V','R','SR')),


DATE_PED AS (SELECT ID_PEDIDO 
                      FROM PEDID WHERE
                       PEDDTBAIXA BETWEEN '01.03.2023' AND 'TODAY'),
                       
                       
                       
                       PED AS (SELECT P.ID_PEDIDO,
                  CLICODIGO,
                    PEDDTBAIXA
                     FROM PEDID P
                      INNER JOIN FIS ON P.FISCODIGO1=FIS.FISCODIGO
                       INNER JOIN DATE_PED DTP ON P.ID_PEDIDO=DTP.ID_PEDIDO
                         WHERE PEDSITPED<>'C' AND 
                                    PEDLCFINANC IN ('S', 'L','N')),

-- PRODUTOS
PRODU AS (SELECT PROCODIGO,P.MARCODIGO,MARNOME MARCA
                                FROM PRODU P
                                 INNER JOIN MARCA M ON P.MARCODIGO=M.MARCODIGO
                                  WHERE P.MARCODIGO=57)

                                   
SELECT
   PEDDTBAIXA,
    CLICODIGO,
        PD.PROCODIGO,
         MARCODIGO,
          MARCA,
         PDPDESCRICAO DESCRICAO,
          SUM(PDPQTDADE)QTD,
           SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA 
            FROM PDPRD PD
             INNER JOIN PED P ON PD.ID_PEDIDO=P.ID_PEDIDO
              INNER JOIN PRODU PR ON PD.PROCODIGO=PR.PROCODIGO
                  GROUP BY 1,2,3,4,5,6