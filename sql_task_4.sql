delete from testcars.routes
delete from testcars.cars
delete from testcars.points
-- cars
set identity_insert testcars.cars on
insert into testcars.cars(id, capacity)
values (1, 125), (2, 250), (3, 350), (4, 400)
set identity_insert testcars.cars off
-- points
set identity_insert testcars.points on
insert into testcars.points(id, type_id)
values (1, 'D'), (2, 'D'), (3, 'S'), (4, 'S'), (5, 'S')
set identity_insert testcars.points off

insert into testcars.routes(point_id, car_id, load, arrivaltime, departuretime)
values 
-- машина 2 - маршрут 1 (3,4) - заезд на склад
 (1, 2, 100, convert(datetime, '01.01.2016 08:30:00', 104), convert(datetime, '01.01.2016 09:00:00', 104))
,(3, 2, -20, convert(datetime, '01.01.2016 09:30:00', 104), convert(datetime, '01.01.2016 10:00:00', 104))
,(4, 2, -30, convert(datetime, '01.01.2016 10:30:00', 104), convert(datetime, '01.01.2016 11:00:00', 104))

-- машина 2 - маршрут 2 (3,4,5) - заезд на склад
,(2, 2, 100, convert(datetime, '02.01.2016 08:30:00', 104), convert(datetime, '02.01.2016 09:00:00', 104))
,(3, 2, -50, convert(datetime, '02.01.2016 09:30:00', 104), convert(datetime, '02.01.2016 10:00:00', 104))
,(4, 2, -50, convert(datetime, '02.01.2016 10:30:00', 104), convert(datetime, '02.01.2016 11:00:00', 104))
,(5, 2, -50, convert(datetime, '02.01.2016 11:30:00', 104), convert(datetime, '02.01.2016 12:00:00', 104))

-- машина 2 - маршрут 1 (3,4) - без заезда на склад
,(3, 2, -50, convert(datetime, '03.01.2016 09:30:00', 104), convert(datetime, '03.01.2016 10:00:00', 104))
,(4, 2, -50, convert(datetime, '03.01.2016 10:30:00', 104), convert(datetime, '03.01.2016 11:00:00', 104))
-- машина 2 - маршрут 1 (3,4,5) - без заезда на склад
,(3, 2, -50, convert(datetime, '04.01.2016 09:30:00', 104), convert(datetime, '04.01.2016 10:00:00', 104))
,(4, 2, -50, convert(datetime, '04.01.2016 10:30:00', 104), convert(datetime, '04.01.2016 11:00:00', 104))
,(5, 2, -50, convert(datetime, '04.01.2016 11:30:00', 104), convert(datetime, '04.01.2016 12:00:00', 104))

-- машина 3 - маршрут 2 (3,4,5) - заезд на склад
,(2, 3, 120, convert(datetime, '02.01.2016 08:30:00', 104), convert(datetime, '02.01.2016 09:30:00', 104))
,(3, 3, -50, convert(datetime, '02.01.2016 11:30:00', 104), convert(datetime, '02.01.2016 11:40:00', 104))
,(4, 3, -50, convert(datetime, '02.01.2016 12:30:00', 104), convert(datetime, '02.01.2016 12:40:00', 104))
,(5, 3, -50, convert(datetime, '02.01.2016 13:30:00', 104), convert(datetime, '02.01.2016 13:40:00', 104))
-- машина 3 - маршрут 1 (3,4) - заезд на склад в текущем дне
,(2, 3, 120, convert(datetime, '02.01.2016 14:30:00', 104), convert(datetime, '02.01.2016 14:40:00', 104))
,(3, 3, -50, convert(datetime, '02.01.2016 15:30:00', 104), convert(datetime, '02.01.2016 15:40:00', 104))
,(4, 3, -50, convert(datetime, '02.01.2016 16:30:00', 104), convert(datetime, '02.01.2016 16:40:00', 104))
-- машина 3 - маршрут 3 (4,5) - заезд на склад в текущем дне
,(2, 3, 120, convert(datetime, '02.01.2016 17:30:00', 104), convert(datetime, '02.01.2016 17:40:00', 104))
,(4, 3, -50, convert(datetime, '02.01.2016 18:30:00', 104), convert(datetime, '02.01.2016 18:40:00', 104))
,(5, 3, -50, convert(datetime, '02.01.2016 19:30:00', 104), convert(datetime, '02.01.2016 19:40:00', 104))

if object_id('tempdb..#trips') is not null 
	drop table #trips
;with trips as
(
	select 
		case 
			-- новая поездка внутри дня
			when p.type_id = 'D' then 1 
			-- новая поездка в следующем дне без заезда на склад
			else rank() over(partition by r.car_id, cast(r.arrivaltime as date) order by r.arrivaltime) 
		end trip_point_index
		,r.id
		,r.car_id
		,r.point_id
		,p.type_id
		,r.arrivaltime
		-- если точка является магазином, то нужно брать время прибытия для включения точки в маршрут
		,case when p.type_id = 'S' then r.arrivaltime else r.departuretime end departuretime
	from testcars.routes r
		join testcars.points p on r.point_id = p.id
)
select t.id
	,t.car_id
	,t.arrivaltime
	,t.departuretime
	-- время прибытия на точку следующего маршрута (нужно для получения всех точек поездки)
	,lead(t.arrivaltime) over (partition by t.car_id order by t.arrivaltime) next_arrivaltime
	into #trips
from trips t 
where t.trip_point_index = 1

-- routes
select t.id routeid, (
		select concat(r.Point_Id, ',')
		from testcars.routes r
		where t.car_id = r.car_id and t.departuretime <= r.arrivaltime and (t.next_arrivaltime is null or t.next_arrivaltime > r.arrivaltime)
		for xml path('') 
	) 
from #trips t

select * from #trips
-- routes
select t.id routeid, r.*
from #trips t
	join testcars.routes r on r.car_id = t.car_id
	-- включение точки в маршрут
where t.departuretime <= r.arrivaltime and (t.next_arrivaltime is null or t.next_arrivaltime > r.arrivaltime)



;with cte as
(
	select r.id routeid
		,r.car_id -- идентификатор машины
		,p.id -- идентификатор маршрута
		,p.type_id
		,c.capacity
		,sum(r.load) over (partition by r.car_id order by r.arrivaltime) departure_load
		,sum(r.load) over (partition by r.car_id order by r.arrivaltime rows between unbounded preceding and 1 preceding) arrival_load
	from testcars.routes r
		join testcars.cars c on r.car_id = c.id
		join testcars.points p on r.point_id = p.id
)
select c.routeid, cast(c.departure_load as real) / cast(c.capacity as real) perc, c.arrival_load
from cte c
where type_id = 'D'
