/* select anterior
select pdprd.empcodigo Repro,cast(pedid.peddtemis as date) as Emissao,pdprd.id_pedido ID_Ped, pedid.clicodigo CliCod, clien.clirazsocial, pdprd.procodigo Produto, produ.prodescricao, pdprd.pdpqtdade QT, pdprd.uncodigo UN, (pdprd.pdpqtdade)*(pdprd.pdppcounit) SemDesc, (pdprd.pdpqtdade)*(pdprd.pdpunitliquido) ComDesc,
pdprd.fiscodigo CFOP, pdprd.pdpvrcontabil Contab,  pdprd.pdppcounit, pdprd.pdppcdescto, pdprd.pdpunitliquido, pdprd.pdpcusto, pdprd.pdpcustototal, pdprd.pdpcustoreal, pdprd.pdpvripi, pdprd.pdpvricmssufra, pdprd.pdpvrpissufra, pdprd.pdpvrcofinssufra, pdprd.pdpvricms, pdprd.pdpvrpis, pdprd.pdpvrcofins, pedid.pedsitped Sit, pedid.nrvouchersugerido, pedid.pedorigem, pdinfopromo.pippromocao, pdinfopromo.pipvoucher,
pdinfopromo.pippar, pedidpromo.id_pedidpromo, pedidpromo.id_pedidpromocao, pedidpromo.nrvoucherpromo, promo.descricao
from pdprd
left join pedid on pedid.id_pedido = pdprd.id_pedido
left join produ on produ.procodigo = pdprd.procodigo
left join clien on clien.clicodigo = pedid.clicodigo
left join pdinfopromo on pdinfopromo.id_pedido = pdprd.id_pedido
left join pedidpromo on pedidpromo.id_pedidoriginal = pdprd.id_pedido
left join promo on promo.id_promo = pedidpromo.id_promo
where
pedid.pedsitped = 'F'
and pdprd.fiscodigo in ('5.102','6.102','5.101','6.101','6.403','6.40S','5.124','6.124','5.117','6.117','7.102')
and pedid.peddtbaixa BETWEEN @#DATE#Faturamento_Inicial@ and @#DATE#Faturamento_Final@
order by 1,3 */

select pdprd.empcodigo Repro,cast(pedid.peddtemis as date) as Emissao,pdprd.id_pedido ID_Ped, pedid.clicodigo CliCod, clien.clirazsocial, pdprd.procodigo Produto,CHAVE, A.prodescricao, pdprd.pdpqtdade QT, pdprd.uncodigo UN, (pdprd.pdpqtdade)*(pdprd.pdppcounit) SemDesc, (pdprd.pdpqtdade)*(pdprd.pdpunitliquido) ComDesc,
pdprd.fiscodigo CFOP, pdprd.pdpvrcontabil Contab,  pdprd.pdppcounit, pdprd.pdppcdescto, pdprd.pdpunitliquido, pdprd.pdpcusto, pdprd.pdpcustototal, pdprd.pdpcustoreal, pdprd.pdpvripi, pdprd.pdpvricmssufra, pdprd.pdpvrpissufra, pdprd.pdpvrcofinssufra, pdprd.pdpvricms, pdprd.pdpvrpis, pdprd.pdpvrcofins, pedid.pedsitped Sit, pedid.nrvouchersugerido, pedid.pedorigem, pdinfopromo.pippromocao, pdinfopromo.pipvoucher,
pdinfopromo.pippar, pedidpromo.id_pedidpromo, pedidpromo.id_pedidpromocao, pedidpromo.nrvoucherpromo, promo.descricao
from pdprd
inner join (SELECT * FROM PEDID WHERE pedid.peddtbaixa BETWEEN  @#DATE#Faturamento_Inicial@ and @#DATE#Faturamento_Final@)pedid on pedid.id_pedido = pdprd.id_pedido
left join (SELECT PROCODIGO,PRODESCRICAO,IIF(PROCODIGO2 IS NULL,PROCODIGO,PROCODIGO2)CHAVE FROM PRODU)A on A.procodigo = pdprd.procodigo
left join clien on clien.clicodigo = pedid.clicodigo
left join pdinfopromo on pdinfopromo.id_pedido = pdprd.id_pedido
left join pedidpromo on pedidpromo.id_pedidoriginal = pdprd.id_pedido
left join promo on promo.id_promo = pedidpromo.id_promo
where
pedid.pedsitped = 'F'
and pdprd.fiscodigo in ('5.102','6.102','5.101','6.101','6.403','6.40S','5.124','6.124','5.117','6.117','7.102')
order by 1,3

