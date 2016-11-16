delete from testmoney.operations
delete from testmoney.[Currencies Rates]
delete from testmoney.clients
delete from testmoney.currencies

set identity_insert testmoney.clients on
insert into testmoney.clients(id, name) 
values (1, 'client 1') 
,(2, 'client 2')
,(3, 'client 3')
set identity_insert testmoney.clients off

insert into testmoney.currencies (id, codelat3, name)
values (840, 'USD', 'Доллар США')
,(643, 'RUB', 'Российский рубль')
,(974, 'BYR', 'Белорусский рубль')
,(978, 'EUR', 'Евро')

insert into testmoney.[Currencies Rates](currency_id, basecurrency_id, date, rate, volume)
values (840, 643, convert(date, '01.01.2016', 104), 1, 72.9299)
,(840, 643, convert(date, '04.01.2016', 104), 1, 72.9299)
,(840, 643, convert(date, '11.01.2016', 104), 1, 72.9299)
,(840, 643, convert(date, '18.01.2016', 104), 1, 76.5650)
,(840, 643, convert(date, '25.01.2016', 104), 1, 80.5714)
,(840, 643, convert(date, '01.02.2016', 104), 1, 75.1723)
,(840, 643, convert(date, '08.02.2016', 104), 1, 77.3409)
,(840, 643, convert(date, '15.02.2016', 104), 1, 79.4951)
,(840, 643, convert(date, '22.02.2016', 104), 1, 77.1326)
,(840, 643, convert(date, '29.02.2016', 104), 1, 75.0903)

,(974, 643, convert(date, '01.01.2016', 104), 10000, 39.0417)
,(974, 643, convert(date, '04.01.2016', 104), 10000, 39.0417)
,(974, 643, convert(date, '11.01.2016', 104), 10000, 39.0417)
,(974, 643, convert(date, '18.01.2016', 104), 10000, 38.4942)
,(974, 643, convert(date, '25.01.2016', 104), 10000, 37.9606)
,(974, 643, convert(date, '01.02.2016', 104), 10000, 36.0971)
,(974, 643, convert(date, '08.02.2016', 104), 10000, 35.7563)
,(974, 643, convert(date, '15.02.2016', 104), 10000, 36.0522)
,(974, 643, convert(date, '22.02.2016', 104), 10000, 35.7095)
,(974, 643, convert(date, '29.02.2016', 104), 10000, 35.0235)

,(978, 643, convert(date, '01.01.2016', 104), 1, 79.6395)
,(978, 643, convert(date, '04.01.2016', 104), 1, 79.6395)
,(978, 643, convert(date, '11.01.2016', 104), 1, 79.6395)
,(978, 643, convert(date, '18.01.2016', 104), 1, 83.2951)
,(978, 643, convert(date, '25.01.2016', 104), 1, 87.2266)
,(978, 643, convert(date, '01.02.2016', 104), 1, 81.9077)
,(978, 643, convert(date, '08.02.2016', 104), 1, 86.5754)
,(978, 643, convert(date, '15.02.2016', 104), 1, 89.8454)
,(978, 643, convert(date, '22.02.2016', 104), 1, 85.8563)
,(978, 643, convert(date, '29.02.2016', 104), 1, 82.9748)

declare @i int = 0
declare @j int = 0
declare @k int = 0

declare @value int = 0
declare @date date = convert(date, '01.01.2016', 104)
while @i < 1000000
begin
	insert into testmoney.operations(date, client_id, value, currency_id, docno)
	values (@date, 1, 1, 840, '1')
	,(@date, 1, 1, 978, '1')
	,(@date, 1, 10, 974, '1')

	set @date = dateadd(DD, 1, @date)
	set @i = @i + 1
end


--insert into testmoney.operations(date, client_id, value, currency_id, docno)
--values (convert(date, '01.01.2016', 104), 1, 1, 840, '1')
--,(convert(date, '03.01.2016', 104), 1, 1, 978, '1')
--,(convert(date, '05.01.2016', 104), 1, 1, 840, '1')
--,(convert(date, '07.01.2016', 104), 1,-1, 840, '1')
--,(convert(date, '09.01.2016', 104), 1, 1, 974, '1')
--,(convert(date, '11.01.2016', 104), 1, 1, 840, '1')
--,(convert(date, '13.01.2016', 104), 1, 1, 978, '1')
--,(convert(date, '15.01.2016', 104), 1,-1, 840, '1')
--,(convert(date, '17.01.2016', 104), 1, 1, 974, '1')
--,(convert(date, '19.01.2016', 104), 1, 1, 978, '1')
--,(convert(date, '21.01.2016', 104), 1, 1, 840, '1')
--,(convert(date, '23.01.2016', 104), 1,-1, 840, '1')
--,(convert(date, '25.01.2016', 104), 1, 1, 978, '1')
--,(convert(date, '27.01.2016', 104), 1, 1, 840, '1')
--,(convert(date, '29.01.2016', 104), 1,-1, 974, '1')
--,(convert(date, '31.01.2016', 104), 1, 1, 840, '1')
--,(convert(date, '02.02.2016', 104), 1, 1, 978, '1')
--,(convert(date, '04.02.2016', 104), 1,-1, 840, '1')
--,(convert(date, '06.02.2016', 104), 1, 1, 840, '1')
--,(convert(date, '08.02.2016', 104), 1,-1, 840, '1')
--,(convert(date, '10.02.2016', 104), 1, 1, 978, '1')
--,(convert(date, '12.02.2016', 104), 1, 1, 840, '1')
--,(convert(date, '14.02.2016', 104), 1, 1, 974, '1')
--,(convert(date, '16.02.2016', 104), 1,-1, 840, '1')
--,(convert(date, '18.02.2016', 104), 1, 1, 840, '1')
--,(convert(date, '20.02.2016', 104), 1, 1, 978, '1')
--,(convert(date, '22.02.2016', 104), 1, 1, 840, '1')
--,(convert(date, '24.02.2016', 104), 1, -1, 840, '1')
--,(convert(date, '26.02.2016', 104), 1, 1, 978, '1')
--,(convert(date, '28.02.2016', 104), 1, 1, 974, '1')
--,(convert(date, '01.03.2016', 104), 1,-1, 840, '1')
--,(convert(date, '04.03.2016', 104), 1, 1, 974, '1')


declare @datefrom date = convert(date, '01.01.2016', 104)
declare @dateto date = convert(date, '05.02.2016', 104)
declare @basecurrencyid int = 643

select o.client_id, o.currency_id, o.value, 
	sum(o.value) over (
		partition by 
			o.client_id, o.currency_id 
		order by o.date range 
			between unbounded preceding and unbounded following)
from testmoney.operations o
where o.date >= @datefrom and o.date < @dateto



declare @datefrom date = convert(date, '01.01.2016', 104)
declare @dateto date = convert(date, '05.02.2016', 104)
declare @basecurrencyid int = 643

select o.Client_Id, o.Currency_Id, sum(o.value) 
* (
	select top 1 rate/volume 
	from testmoney.[Currencies Rates] 
	where BaseCurrency_Id = @basecurrencyid and date <= @dateto 
	order by date desc
) total
from testmoney.operations o with(index(ix_operations))
where o.date >= @datefrom and o.date < @dateto and o.Client_Id in (
	select id 
	from testmoney.clients c
)
group by o.Client_Id, o.Currency_Id
order by o.Client_Id, o.Currency_Id

if exists (select * from sys.indexes where name = 'ix_operations')
	drop index ix_operations on testmoney.operations
create nonclustered index ix_operations on testmoney.operations(client_Id, date) include (value)

if exists (select * from sys.indexes where name = 'ix_currencies_rates')
	drop index ix_currencies_rates on testmoney.[currencies rates]
create nonclustered index ix_currencies_rates on testmoney.[currencies rates](BaseCurrency_Id, date)
