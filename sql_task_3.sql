delete from test.contracts
insert into test.contracts (type_id, client_id, datefrom, dateto)
values (1, 1, convert(date, '01.01.2012', 104), convert(date, '05.01.2012', 104))
,(1, 1, convert(date, '02.01.2012', 104), convert(date, '03.01.2012', 104))
,(1, 1, convert(date, '04.01.2012', 104), convert(date, '10.01.2012', 104))
,(1, 1, convert(date, '12.01.2012', 104), convert(date, '15.01.2012', 104))
,(1, 1, convert(date, '13.01.2012', 104), convert(date, '14.01.2012', 104))

declare
  @Type_Id    int   = 1,
  @DateBegin  date  = '20000601',
  @DateEnd    date  = '20010131'


select c1.client_id, c1.datefrom first_date
	, case when max(c1.dateto) > max(c2.dateto) then max(c1.dateto) else max(c2.dateto) end last_date
from test.contracts c1
	join test.contracts c2 on c1.client_id = c2.client_id and c1.datefrom < c2.datefrom and c1.dateto > c2.datefrom
where c1.type_id = @Type_Id
group by c1.client_id, c1.datefrom

