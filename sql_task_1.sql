use TestDB

delete from testdoc.accounts
delete from testdoc.contracts

-- ���������
-- ������ 1 v08 (������� v07)
-- ��������� �������� ������
if object_id('tempdb..#data') is not null drop table #data
select * 
	into #data
from (
	-- ���������� �������� �� ������ �������� (datefrom > dateto) [�� �������������]
	select '0' docno, convert(date, '02.01.2001', 104) datefrom, convert(date, '01.01.2001', 104) dateto, t.*
	from (
		select '1', convert(datetime, '01.01.2001 23:00:00', 104), convert(datetime, '01.01.2001 23:40:00', 104) 
	) t(number, datetimefrom, datetimeto)
	union
	-- �������� ��������� 1 ����
	select '1' docno, convert(date, '01.01.2001', 104) datefrom, convert(date, '01.01.2001', 104) dateto, t.*
	from (
		-- ���� ������ � ������ � ������� �������� ��������
		select '1', convert(datetime, '01.01.2001 23:00:00', 104), convert(datetime, '01.01.2001 23:40:00', 104) 
		-- ���� ������ � ������ �� ������ �������� �������� (err1)
		union select '2', convert(datetime, '31.12.2000 23:00:00', 104), convert(datetime, '31.12.2000 23:40:00', 104)
		-- ���� ������ � ������ ����� ��������� �������� �������� (err2)
		union select '3', convert(datetime, '02.02.2001 00:00:00', 104), convert(datetime, '02.02.2001 23:40:00', 104)
		-- ���� ������ � �� ������ �� ������ �������� �������� (err1)
		union select '4', convert(datetime, '31.12.2000 23:30:00', 104), null
		-- ���� ������ � �� ������ ����� ��������� �������� �������� (err3)
		union select '5', convert(datetime, '02.02.2001 02:00:00', 104), null
		-- ���� ������ � �� ������ �� ����� �������� ��������
		union select '6', convert(datetime, '01.01.2001 02:00:00', 104), null
	) t(number, datetimefrom, datetimeto)
	union
	select '2' docno, convert(date, '01.01.2001', 104) datefrom, convert(date, '01.02.2001', 104) dateto, t.*
	from (
		select '1', convert(datetime, '01.01.2001 23:00:00', 104), convert(datetime, '01.01.2001 23:40:00', 104) 
	) t(number, datetimefrom, datetimeto)
) g

insert into testdoc.contracts(docno, datefrom, dateto)
select d.docno, d.datefrom, d.dateto
from #data d
where not exists (select 1 from testdoc.contracts c where d.docno = c.docno)
group by docno, datefrom, dateto

insert into testdoc.accounts(contract_id, number, datetimefrom, datetimeto)
select c.id, d.number, d.datetimefrom, d.datetimeto
from #data d
	join testdoc.contracts c on d.docno = c.docno
where not exists (select 1 from testdoc.accounts a where a.number = d.number and a.contract_id = c.id)

-- �����
select c.docno, a.number
	,case when c.datefrom > a.datetimefrom then 1 else 0 end err1				-- �������� �� ������ �������� ��������
	,case when c.datefrom > a.datetimeto then 1 else 0 end err2					-- �������� �� ������ �������� ��������
	,case when c.dateto < cast(a.datetimefrom as date) then 1 else 0 end err3	-- �������� ����� ��������� �������� ��������
	,case when c.dateto < cast(a.datetimeto as date) then 1 else 0 end err4		-- �������� ����� ��������� �������� ��������
from testdoc.contracts c
	join testdoc.accounts a on c.id = a.contract_id

select c.docno, a.number
from testdoc.contracts c
	join testdoc.accounts a on c.id = a.contract_id
where a.datetimefrom < c.datefrom
	or a.datetimeto < c.datefrom
	or a.datetimefrom >= dateadd(dd, 1, c.dateto) 
	or a.datetimeto >= dateadd(dd, 1, c.dateto)
	or (a.datetimeto is null and c.dateto is not null)

select 
	case when convert(date, '01.01.2001', 104) < null then 1 else 0 end
	,cast(convert(datetime, '01.01.2001 14:30:00', 104) as date)
	,dateadd(dd, 1, convert(date, '01.01.2001', 104))