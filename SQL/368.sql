
SELECT 
EMPCODIGO,
P.CLICODIGO,
CLIRAZSOCIAL,
CIDNOME CIDADE
FROM CLIEMP P
INNER JOIN (SELECT C.CLICODIGO,CIDNOME,CLIRAZSOCIAL FROM CLIEN C
LEFT JOIN (SELECT CLICODIGO,CIDNOME FROM ENDCLI E
                                               LEFT JOIN CIDADE CID ON E.CIDCODIGO=CID.CIDCODIGO
                                                 WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                                         
                                                   WHERE CLICLIENTE='S'
) C ON
C.CLICODIGO=P.CLICODIGO


                                              