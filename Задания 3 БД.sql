/*1 задание*/
create generator gen_manufacturer;
set generator gen_manufacturer to 5;
create generator gen_model;
set generator gen_model to 5;
create generator gen_options;
set generator gen_options to 137;
create generator gen_fio_name;
set generator gen_fio_name to 18;
create generator gen_status;
set generator gen_status to 5;
create generator gen_post_clerk;
set generator gen_post_clerk to 7;
create generator gen_basic_equipment;
set generator gen_basic_equipment to 5;
create generator gen_clerk;
set generator gen_clerk to 4;
create generator gen_client;
set generator gen_client to 4;
create generator gen_contract;
set generator gen_contract to 4;
create generator gen_characteristics;
set generator gen_characteristics to 4;

set term !!;
create trigger bef_ins_manufacturer for manufacturer
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_manufacturer,1);
end!!
create trigger bef_ins_model for model
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_model,1);
end!!
create trigger bef_ins_options for options
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_options,1);
end!!
create trigger bef_ins_fio_name for fio_name
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_fio_name,1);
end!!
create trigger bef_ins_status for status
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_status,1);
end!!
create trigger bef_ins_post_clerk for post_clerk
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_post_clerk,1);
end!!
create trigger bef_ins_basic_equipment for basic_equipment
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_basic_equipment,1);
end!!
create trigger bef_ins_clerk for clerk
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_clerk,1);
end!!
create trigger bef_ins_client for client
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_client,1);
end!!
create trigger bef_ins_contract for contract
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_contract,1);
end!!
create trigger bef_ins_characteristics for characteristics
before insert as
begin
if (new.id is null) then 
new.id = gen_id(gen_characteristics,1);
end!!
set term ;!!

/*2 задание*/
create exception error_ordered_options 'Ошибка добавления заказанных опций';

set term !!;
create trigger check_ordered_options for ordered_options
before insert as
declare variable i integer;
declare variable j integer;
begin
i=new.id_options;
j=new.id_contract;
if (not exists (select * from (contract a inner join available_options b 
on a.id_basic_equipment=b.id_basic_equipment and b.id_options=:i and a.id=:j))) then 
exception error_ordered_options;
end!!
set term ;!!
/*
Проверка
insert into ordered_options values (1,122,39000,39000);
insert into ordered_options values (1,160,39000,39000);
*/

/*3 задание*/
create table log_contract (
updater_name varchar(25) not null,
type_update varchar(10) not null check (type_update = 'Добавление' or type_update = 'Изменение' or type_update = 'Удаление'),
change_date timestamp not null, 
id_contract integer not null,
old_date varchar(200),
new_date varchar(200));

set term !!;
create trigger aft_ins_contract for contract
after insert as
declare variable n_vin varchar(20);
declare variable n_date_delivery varchar(15);
declare variable n_date_receipt varchar(15);
begin
if (new.vin_cars is null) then
begin n_vin='Отсутствует'; end
else 
begin n_vin=new.vin_cars; end
if (new.date_delivery is null) then
begin n_date_delivery='Отсутствует'; end
else 
begin n_date_delivery=cast(new.date_delivery as varchar(15)); end
if (new.date_receipt is null) then
begin n_date_receipt='Отсутствует'; end
else 
begin n_date_receipt=cast(new.date_receipt as varchar(15)); end
insert into log_contract values (user,'Добавление','now',new.id,
null, 
cast(new.id_model as varchar(15)) || '; ' || 
cast(new.id_basic_equipment as varchar(15)) || '; ' || 
cast(new.id_client as varchar(15)) || '; ' || 
cast(new.id_clerk as varchar(15)) || '; ' || 
cast(new.status as varchar(15)) || '; ' ||
cast(new.price as varchar(15)) || '; ' || 
cast(new.cost as varchar(15)) || '; ' || 
:n_vin || '; ' || 
cast(new.date_conclusion as varchar(15)) || '; ' ||
:n_date_delivery || '; ' || 
:n_date_receipt);
end!!

create trigger aft_upd_contract for contract
after update as
declare variable o_vin varchar(20);
declare variable o_date_delivery varchar(15);
declare variable o_date_receipt varchar(15);
declare variable n_vin varchar(20);
declare variable n_date_delivery varchar(15);
declare variable n_date_receipt varchar(15);
begin
if (old.vin_cars is null) then
begin o_vin='Отсутствует'; end
else 
begin o_vin=old.vin_cars; end
if (old.date_delivery is null) then
begin o_date_delivery='Отсутствует'; end
else 
begin o_date_delivery=cast(old.date_delivery as varchar(15)); end
if (old.date_receipt is null) then
begin o_date_receipt='Отсутствует'; end
else 
begin o_date_receipt=cast(old.date_receipt as varchar(15)); end

if (new.vin_cars is null) then
begin n_vin='Отсутствует'; end
else 
begin n_vin=new.vin_cars; end
if (new.date_delivery is null) then
begin n_date_delivery='Отсутствует'; end
else 
begin n_date_delivery=cast(new.date_delivery as varchar(15)); end
if (new.date_receipt is null) then
begin n_date_receipt='Отсутствует'; end
else 
begin n_date_receipt=cast(new.date_receipt as varchar(15)); end

insert into log_contract values (user,'Изменение','now',new.id,
cast(old.id_model as varchar(15)) || '; ' || 
cast(old.id_basic_equipment as varchar(15)) || '; ' || 
cast(old.id_client as varchar(15)) || '; ' || 
cast(old.id_clerk as varchar(15)) || '; ' || 
cast(old.status as varchar(15)) || '; ' ||
cast(old.price as varchar(15)) || '; ' || 
cast(old.cost as varchar(15)) || '; ' || 
:o_vin || '; ' || 
cast(old.date_conclusion as varchar(15)) || '; ' ||
:o_date_delivery || '; ' || 
:o_date_receipt, 

cast(new.id_model as varchar(15)) || '; ' || 
cast(new.id_basic_equipment as varchar(15)) || '; ' || 
cast(new.id_client as varchar(15)) || '; ' || 
cast(new.id_clerk as varchar(15)) || '; ' || 
cast(new.status as varchar(15)) || '; ' ||
cast(new.price as varchar(15)) || '; ' || 
cast(new.cost as varchar(15)) || '; ' || 
:n_vin || '; ' || 
cast(new.date_conclusion as varchar(15)) || '; ' ||
:n_date_delivery || '; ' || 
:n_date_receipt);
end!!

create trigger aft_del_contract for contract
after delete as
declare variable o_vin varchar(20);
declare variable o_date_delivery varchar(15);
declare variable o_date_receipt varchar(15);
begin
if (old.vin_cars is null) then
begin o_vin='Отсутствует'; end
else 
begin o_vin=old.vin_cars; end
if (old.date_delivery is null) then
begin o_date_delivery='Отсутствует'; end
else 
begin o_date_delivery=cast(old.date_delivery as varchar(15)); end
if (old.date_receipt is null) then
begin o_date_receipt='Отсутствует'; end
else 
begin o_date_receipt=cast(old.date_receipt as varchar(15)); end

insert into log_contract values (user,'Удаление','now',old.id,
cast(old.id_model as varchar(15)) || '; ' || 
cast(old.id_basic_equipment as varchar(15)) || '; ' || 
cast(old.id_client as varchar(15)) || '; ' || 
cast(old.id_clerk as varchar(15)) || '; ' || 
cast(old.status as varchar(15)) || '; ' ||
cast(old.price as varchar(15)) || '; ' || 
cast(old.cost as varchar(15)) || '; ' || 
:o_vin || '; ' || 
cast(old.date_conclusion as varchar(15)) || '; ' ||
:o_date_delivery || '; ' || 
:o_date_receipt, 
null);
end!!
set term ;!!
/*
insert into contract values (5,1,3,4,4,4,851500,851500,'3D9GP25B05G108757','2012/3/13','2012/4/21',null);
update contract set price=1000000 where id=5;
delete from contract where id=5;
*/

/*4 задание*/
create procedure add_basic_equipment (name_model varchar(20),name varchar(25),price integer,cost integer)
returns (res smallint) as
declare variable i integer;
begin
  if (exists (select * from model where model.name=:name_model))then 
  begin
  i=gen_id(gen_basic_equipment,1);
  insert into basic_equipment values (:i,(select id from model where model.name=:name_model),:name,:price,:cost);
  res=:i;
  suspend;
  end
  else
  begin
  res=-1;
  suspend;
  end  
end;
/*
Проверка 
execute procedure add_basic_equipment ('Fiesta','Trend NEW',657000,657000)
*/

/*6 задание*/
create procedure characteristics_cars (vin_cars varchar(20))
returns (name_characteristics varchar(30), value_characteristics decimal(10,3)) as
begin
  for 
  select k.name, i.value_characteristics
  from (((((contract a
  inner join options_equipment b on a.id_basic_equipment=b.id_basic_equipment and a.vin_cars=:vin_cars)
  inner join ordered_options c on a.id=c.id_contract)
  inner join options d on b.id_options=d.id or c.id_options=d.id)
  inner join characteristics_equipment i on i.id_basic_equipment=a.id_basic_equipment and i.id_options=d.id)
  inner join characteristics k on k.id=i.id_characteristics)
  union 
  select l.name, j.value_characteristics
  from (((((warehouse e
  inner join options_equipment f on e.id_basic_equipment=f.id_basic_equipment and e.vin=:vin_cars)
  inner join installed_options g on e.vin=g.vin_warehouse)
  inner join options h on f.id_options=h.id or g.id_options=h.id)
  inner join characteristics_equipment j on j.id_basic_equipment=e.id_basic_equipment and j.id_options=h.id)
  inner join characteristics l on l.id=j.id_characteristics)
  into :name_characteristics, :value_characteristics
  do
  suspend; 
end;
/*
Проверка
execute procedure characteristics_cars ('3D9GP25B05G104567')
*/

/*7 задание*/
create view view_car_options (vin, name, description) as 
select a.vin_cars, d.name, d.description
from (((contract a
inner join options_equipment b on a.id_basic_equipment=b.id_basic_equipment)
inner join ordered_options c on a.id=c.id_contract)
inner join options d on b.id_options=d.id or c.id_options=d.id)
union 
select e.vin, h.name, h.description 
from (((warehouse e
inner join options_equipment f on e.id_basic_equipment=f.id_basic_equipment)
inner join installed_options g on e.vin=g.vin_warehouse)
inner join options h on f.id_options=h.id or g.id_options=h.id)
