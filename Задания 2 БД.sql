/*1 задание*/
select a.name as first_name, b.name as second_name, c.name as middle_name, d.birthday , d.gender
from (((client d 
inner join fio_name a on d.first_name=a.id) 
inner join fio_name b on d.second_name=b.id) 
inner join fio_name c on d.middle_name=c.id)
order by d.birthday; 

/*2 задание*/
select a.name || ' ' || b.name || ' ' || c.name as name, d.birthday , e.name as post
from ((((clerk d 
inner join fio_name a on d.first_name=a.id) 
inner join fio_name b on d.second_name=b.id) 
inner join fio_name c on d.middle_name=c.id) 
inner join post_clerk e on e.id=d.post)
order by a.name, b.name, c.name;

/*3 задание*/
select distinct a.name as model
from (model a 
inner join contract b on a.id=b.id_model and b.date_conclusion between '2012/11/10' and '2012/11/12')
order by a.name;

/*4 задание*/
select c.name as manufacturer, b.name as model, d.name as equipment, e.name as carcass, f.name as motor, g.name as color , a.price as price
from (((((((((warehouse a 
inner join model b on a.id_model=b.id)
inner join manufacturer c on b.id_manufacturer=c.id) 
inner join basic_equipment d on a.id_basic_equipment=d.id)
inner join installed_options h on a.vin=h.vin_warehouse) 
inner join installed_options i on a.vin=i.vin_warehouse)
inner join installed_options j on a.vin=j.vin_warehouse)
inner join options e on h.id_options=e.id and e.owner=1)
inner join options f on i.id_options=f.id and f.owner=2)
inner join options g on j.id_options=g.id and g.owner=3);

/*5 задание*/
select a.name || ' ' || b.name || ' ' || c.name as name, e.name as post, count(f.id) as cars
from (((((clerk d
inner join fio_name a on d.first_name=a.id)
inner join fio_name b on d.second_name=b.id)
inner join fio_name c on d.middle_name=c.id)
inner join post_clerk e on e.id=d.post)
left join contract f on f.id_clerk=d.id)
where e.name != 'Уволен'
group by a.name, b.name, c.name, e.name
order by cars desc, name;

/*6 задание*/
select a.name || ' ' || b.name || ' ' || c.name as name 
from ((((((contract e 
inner join client d on d.id=e.id_client)
inner join fio_name a on a.id=d.first_name)
inner join fio_name b on b.id=d.second_name)
inner join fio_name c on c.id=d.middle_name)
inner join model f on e.id_model=f.id and f.name='Fiesta')
inner join manufacturer g on f.id_manufacturer=g.id and g.name='Ford') 
order by a.name, b.name, c.name;

/*7 задание*/
select a.name as manufacturer, count(c.id) as cars
from ((manufacturer a
inner join model b on b.id_manufacturer=a.id)
left join contract c on c.id_model=b.id)
where extract(year from c.date_conclusion)=extract(year from current_date)
group by a.name;

/*11 задание*/
select a.name as name 
from ((options a 
inner join options_equipment b on a.id=b.id_options)
inner join basic_equipment c on b.id_basic_equipment=c.id and c.name = 'Sport Limited Edition');

/*12 задание*/
select a.id as number_contract, b.name as model_car, c.name as equipment, a.id_client, a.id_clerk, e.name as status, a.price, a.cost, a.date_conclusion, a.date_delivery, a.date_receipt
from ((((contract a
inner join model b on a.id_model=b.id)
inner join basic_equipment c on a.id_basic_equipment=c.id)
inner join client d on a.id_client=d.id and d.passport_number='3123646411')
inner join status e on a.status=e.id);

/*13 задание*/
select a.name as manufacturer, b.name as model, e.name as motor, f.value_characteristics as value_characteristics
from (((((manufacturer a
inner join model b on b.id_manufacturer=a.id)
inner join basic_equipment c on c.id_model=b.id)
inner join available_options d on d.id_basic_equipment=c.id)
inner join options e on e.id=d.id_options and owner=2)
inner join characteristics_equipment f on f.id_basic_equipment=c.id and f.id_options=d.id_options and f.id_characteristics=1 and f.value_characteristics<10)
order by f.value_characteristics desc;

/*------------15 задание*/
select a.name as manufacturer, b.name as model, count(c.id) as basic_equipment
from ((manufacturer a
inner join model b on b.id_manufacturer=a.id)
left join basic_equipment c on c.id_model=b.id)
group by a.name, b.name;

/*18 задание*/
select a.name as name 
from ((((options a 
inner join available_options b on a.id=b.id_options) 
inner join basic_equipment c on b.id_basic_equipment=c.id and c.name = 'Trend') 
inner join model d on c.id_model=d.id and d.name='Fiesta')
inner join manufacturer e on d.id_manufacturer=e.id and e.name='Ford')
order by a.name;

/*20 задание*/
select a.name || ' ' || b.name || ' ' || c.name as name, e.date_conclusion, e.id as number_contract, f.name as model, g.name as manufacturer
from ((((((contract e 
inner join client d on d.id=e.id_client and d.passport_number = '3123654123')
inner join fio_name a on a.id=d.first_name)
inner join fio_name b on b.id=d.second_name)
inner join fio_name c on c.id=d.middle_name)
inner join model f on e.id_model=f.id)
inner join manufacturer g on f.id_manufacturer=g.id)
where e.date_conclusion between '2012/11/10' and '2012/11/12'
order by e.date_conclusion;

/*21 задание*/
delete from contract where id=5;

/*23 задание*/
update client set second_name=(select id from fio_name where name='Астахов') where id=2;

/*24 задание*/
update contract set vin_cars='1D4GP25B03B108775' where vin_cars='1D4GP25B03B108776';

/*25 задание*/
update contract set date_receipt='2012/11/15',status=(select id from status where name='Получен')  where id=1;