delete from testmoney.clients
delete from testmoney.currencies

set identity_insert testmoney.clients on
insert into testmoney.clients(id, name) 
values (1, 'client 1') 
,(2, 'client 2')
,(3, 'client 3')
set identity_insert testmoney.clients off

insert into testmoney.currencies (id, codelat3, name)
values (1, 'USD', '$')
,(2, 'RUB', 'R')
,(3, 'BLR', 'B')

insert into testmoney.currenciesrates(currency_id, basecurrency_id, date, rate, volume)
values (1, 2, convert(date, '', 106))

declare @datefrom date
declare @dateto date
declare @basecurrencyid int = 2

select * 
from testmoney.operations o
	join testmoney.clients c on o.client_id = c.id
	join testmoney.currencies cur on cur.id = 
	