  WITH FIS AS 
  (SELECT FISCODIGO 
    FROM TBFIS WHERE FISTPNATOP IN ('V','SR','R')),
  
  PED AS 
  (SELECT ID_PEDIDO
    FROM PEDID P
    INNER JOIN FIS ON P.FISCODIGO1=FIS.FISCODIGO
    WHERE 
    PEDDTEMIS BETWEEN @#DATE#DATA_INCIO@ and  @#DATE#DATA_FIM@
    AND PEDSITPED<>'C'),
  
  PED_PROMO_PAP AS 
  (SELECT P1.ID_PEDIDO ID_PEDIDO_PROMO, '' ID_PEDIDORIGINAL 
    FROM PDPRD P1
    INNER JOIN PED ON P1.ID_PEDIDO=PED.ID_PEDIDO
    WHERE PROCODIGO='PAP'),
  
  PED_PROMO_PLUGIN AS 
  (SELECT ID_PEDIDPROMOCAO ID_PEDIDO_PROMO,ID_PEDIDORIGINAL 
    FROM PEDIDPROMO P2
    INNER JOIN PED ON P2.ID_PEDIDPROMOCAO=PED.ID_PEDIDO),
    
  PED_PROMO_CONECTA1 AS (SELECT P3.ID_PEDIDO ID_PEDIDO_PROMO, '' ID_PEDIDORIGINAL 
                               FROM PDINFOPROMO P3
                                INNER JOIN PED ON P3.ID_PEDIDO=PED.ID_PEDIDO
                                 WHERE PIPPAR=2)  ,
                                 
                              PED_PROMO_CONECTA2 AS (SELECT '' ID_PEDIDO_PROMO , P4.ID_PEDIDO ID_PEDIDORIGINAL 
                               FROM PDINFOPROMO P4
                                INNER JOIN PED ON P4.ID_PEDIDO=PED.ID_PEDIDO
                                 WHERE PIPPAR=1)
  

SELECT ID_PEDIDO_PROMO ID_PEDIDO_PROMO, ID_PEDIDORIGINAL, 'PAP' PROMO_TIPO
    FROM PED_PROMO_PAP UNION
    SELECT ID_PEDIDO_PROMO ID_PEDIDO_PROMO, ID_PEDIDORIGINAL ,'PLUGIN' PROMO_TIPO
    FROM PED_PROMO_PLUGIN UNION
    SELECT ID_PEDIDO_PROMO ID_PEDIDO_PROMO, ID_PEDIDORIGINAL,'CONECTA' PROMO_TIPO
    FROM PED_PROMO_CONECTA1 UNION
    SELECT ID_PEDIDO_PROMO ID_PEDIDO_PROMO, ID_PEDIDORIGINAL,'CONECTA' PROMO_TIPO
    FROM PED_PROMO_CONECTA2