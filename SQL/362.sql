
WITH FIS AS (SELECT FISCODIGO FROM TBFIS WHERE FISCODIGO IN ('5.92G','5.94G','5.94L','6.94L')),

   CLI AS (SELECT CLICODIGO,FUNCODIGO2 FROM CLIEN WHERE CLICLIENTE='S'),
    
    PED AS (SELECT ID_PEDIDO,
                    CLICODIGO,
                     EMPCODIGO,
                      PEDDTEMIS,
                       PEDDTBAIXA,
                         FISCODIGO1
                            FROM PEDID P
                             INNER JOIN FIS ON P.FISCODIGO1=FIS.FISCODIGO
                               WHERE PEDDTEMIS BETWEEN '15.05.2023' AND 'YESTERDAY' AND PEDSITPED<>'C' ),
                               
      CLI_EMP AS (SELECT CLICODIGO,EMPCODIGO EMPRESA_CLIENTE FROM CLIEMP),
      
      USU AS (SELECT FUNNOME,FUNCODIGO FROM FUNCIO)

    
      SELECT ID_PEDIDO,
              FISCODIGO1,
               P.CLICODIGO,
                P.EMPCODIGO EMPRESA_PEDIDO,
                 EMPRESA_CLIENTE,
                  PEDDTEMIS DT_EMISSAO,
                   PEDDTBAIXA DT_BAIXA,
                    FUNCODIGO2 COD_FUNC,
                     FUNNOME NOME
                    FROM PED P
                     LEFT JOIN CLI_EMP CP ON CP.CLICODIGO=P.CLICODIGO
                      LEFT JOIN CLI C ON P.CLICODIGO=C.CLICODIGO
                       LEFT JOIN USU U ON C.FUNCODIGO2=U.FUNCODIGO 
                               
                               
                               