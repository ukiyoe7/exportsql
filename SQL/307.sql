execute block
returns (
NOME_FANTASIA varchar(50),
CNPJ char(18),
EMPRESA integer,
LAB varchar(100),
QTD_CONECTA integer,
PERC_CONECTA numeric(3,2),
VR_CONECTA numeric(15,2),
QTD_SHOP9 integer,
PERC_SHOP9 numeric(3,2),
VR_SHOP9 numeric(15,2),
QTD_OPTISOUL integer,
PERC_OPTISOUL numeric(3,2),
VR_OPTISOUL numeric(15,2),
QTD_OPTICLICK integer,
PERC_OPTICLICK numeric(3,2),
VR_OPTICLICK numeric(15,2),
QTD_OUTROS integer,
PERC_OUTROS numeric(3,2),
VR_OUTROS numeric(15,2),
QTD_TOTAL integer,
VR_TOTAL numeric(15,2)
)
as
declare variable nomeaux varchar(50);
declare variable cnpjaux char(18);
declare variable empaux integer;
declare variable empaux2 integer;
declare variable cli integer;
declare variable origem integer;
declare variable valor numeric(15,2);
declare variable cod char(3);
declare variable cliaux integer;
declare variable data_inicial date;
declare variable data_final date;
declare variable pedori char(1);

begin

data_inicial = @#DATE#data_inicial@;
data_final = @#DATE#data_FINAL@;

QTD_CONECTA = 0;
VR_CONECTA = 0;
QTD_SHOP9 = 0;
VR_SHOP9 = 0;
QTD_OPTISOUL = 0;
VR_OPTISOUL = 0;
QTD_OPTICLICK = 0;
VR_OPTICLICK = 0;
QTD_OUTROS = 0;
VR_OUTROS = 0;
QTD_TOTAL = 0;
VR_TOTAL = 0;
EMPAUX = 0;
EMPAUX2 = 0;
CLIAUX = 0;

    select first 1 substring(e.emprazsocial from 1 for 100) from empresa e
    order by e.empcodigo
    into :lab;

    for
          select c.clinomefant
                ,c.clicnpjcpf
                ,p.empcodigo
                ,p.poccodigo
                ,p.pedvrtotal
                ,right(p.pedcodigo,3)
                ,p.clicodigo
                ,p.pedorigem
             from pedid p
        left join clien c on c.clicodigo = p.clicodigo
        left join empresa e on e.empcodigo = p.empcodigo
            where p.peddtemis between :data_inicial and :data_final
              and p.pedlcfinanc <> 'N'
              order by 2,3
              into :nomeaux, :cnpjaux, :empaux, :origem, :valor, :cod, :cli, :pedori

              do begin

              if (:empaux2 <> 0 or :cliaux <> 0) then
              begin
                  if (:empaux2 <> :empaux or :cliaux <> :cli) then
                  begin

                    qtd_total = :qtd_conecta + :qtd_shop9 + :qtd_optisoul + :qtd_opticlick + :qtd_outros;
                    vr_total = :vr_conecta + :vr_shop9 + :vr_optisoul + :vr_opticlick + :vr_outros;

                    if (:qtd_total <> 0) then
                    begin
                        perc_conecta = ( :qtd_conecta * 100.00 ) / :qtd_total;
                        perc_shop9 = ( :qtd_shop9 * 100.00 ) / :qtd_total;
                        perc_optisoul = ( :qtd_optisoul * 100.00 ) / :qtd_total;
                        perc_opticlick = ( :qtd_opticlick * 100.00 ) / :qtd_total;
                        perc_outros = ( :qtd_outros * 100.00 ) / :qtd_total;
                    end else
                        begin
                            perc_conecta = 0;
                            perc_shop9 = 0;
                            perc_optisoul = 0;
                            perc_opticlick = 0;
                            perc_outros = 0;
                            qtd_total = 0;
                        end


                    suspend;

                    QTD_CONECTA = 0;
                    VR_CONECTA = 0;
                    QTD_SHOP9 = 0;
                    VR_SHOP9 = 0;
                    QTD_OPTISOUL = 0;
                    VR_OPTISOUL = 0;
                    QTD_OPTICLICK = 0;
                    VR_OPTICLICK = 0;
                    QTD_OUTROS = 0;
                    VR_OUTROS = 0;
                    QTD_TOTAL = 0;
                    VR_TOTAL = 0;
                    cliaux = :cli;
                    NOME_FANTASIA = :nomeaux;
                    CNPJ = :cnpjaux;
                    EMPRESA = :empaux;
                    empaux2 = :empaux;

                    end

                end


              --Caso seja origem Conecta
                  if (:origem = 101 AND :pedori <> 'E') then
                  begin

                        if (:cod = '000') then
                        qtd_conecta = :qtd_conecta + 1;

                        vr_conecta = :vr_conecta + :valor;

                  end

              --Caso seja origem Shop9
                  if (:origem = 103 AND :pedori <> 'E') then
                  begin

                        if (:cod = '000') then
                        qtd_shop9 = :qtd_shop9 + 1;

                        vr_shop9 = :vr_shop9 + :valor;

                  end

              --Caso seja origem Optisoul
                  if (:origem = 104 AND :pedori <> 'E') then
                  begin

                        if (:cod = '000') then
                        qtd_OPTISOUL = :qtd_OPTISOUL + 1;

                        vr_OPTISOUL = :vr_OPTISOUL + :valor;

                  end

              --Caso seja origem Opticlick
                  if (:pedori = 'E') then
                  begin

                        if (:cod = '000') then
                        qtd_OPTICLICK = :qtd_OPTICLICK + 1;

                        vr_OPTICLICK = :vr_OPTICLICK + :valor;

                  end

              --Caso seja origem Outros
                  if ((:origem not in (101,103,104) or :origem is null) and (:pedori <> 'E')) then
                  begin

                        if (:cod = '000') then
                        qtd_outros = :qtd_outros + 1;

                        vr_outros = :vr_outros + :valor;

                  end

                  empaux2 = :empaux;
                  cliaux = :cli;
                  NOME_FANTASIA = :nomeaux;
                  CNPJ = :cnpjaux;
                  EMPRESA = :empaux;

              end

              qtd_total = :qtd_conecta + :qtd_shop9 + :qtd_optisoul + :qtd_opticlick + :qtd_outros;
              vr_total = :vr_conecta + :vr_shop9 + :vr_optisoul + :vr_opticlick + :vr_outros;

              if (:nomeaux is not null) then
              begin

                    if (:qtd_total <> 0) then
                    begin
                        perc_conecta = ( :qtd_conecta * 100.00 ) / :qtd_total;
                        perc_shop9 = ( :qtd_shop9 * 100.00 ) / :qtd_total;
                        perc_optisoul = ( :qtd_optisoul * 100.00 ) / :qtd_total;
                        perc_opticlick = ( :qtd_opticlick * 100.00 ) / :qtd_total;
                        perc_outros = ( :qtd_outros * 100.00 ) / :qtd_total;
                    end else
                        begin
                            perc_conecta = 0;
                            perc_shop9 = 0;
                            perc_optisoul = 0;
                            perc_opticlick = 0;
                            perc_outros = 0;
                            qtd_total = 0;
                        end

                  suspend;
              end
end