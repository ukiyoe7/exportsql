select distinct pe.empcodigo Emp, pe.id_pedido ID, pe.clicodigo COD, cast (left(cl.clirazsocial,20) as varchar(20)) Cliente, gc.gclcodigo Rede,
cast(pe.peddtemis as date)Entrada, cast(pe.pedhoraent as time)Hora, pgt.pgtdescricao Pagto, pe.pedvrtotal, acop.apobs
from pedid pe
inner join acoped acop on acop.id_pedido = pe.id_pedido and acop.empcodigo = pe.empcodigo and acop.apobs <> ' ' and acop.lpcodigo = 66
inner join clien cl on cl.clicodigo = pe.clicodigo
left join grupocli gc on gc.gclcodigo = cl.gclcodigo
inner join plpto pgt on pgt.pgtcodigo = pe.pgtcodigo
-- traz o pedidos com pacotes
LEFT OUTER JOIN (SELECT ID_PEDIDO FROM PDPRD WHERE PCTNUMERO IS NOT NULL) PD on pe.ID_PEDIDO=PD.ID_PEDIDO
where pe.peddtaprovado is null and pe.pedsitped = 'A' and pe.empcodigo in (1,3,4,5,8) and pe.pgtcodigo in (1,54)
and pe.peddtemis between current_date - 90 and current_date
and exists (select 1 from pedapv pdap where pdap.id_pedido = pe.id_pedido and pdap.pdapdata is null and pdap.apvcodigo = 2) 
and PD.ID_PEDIDO IS NULL
order by 3,1