create database 's2itm:d:\sb\is10\Baz_AK.ib'
  user 'Baz_AK' 
  password 'aletra' 
  page_size=1024;

create table manufacturer ( 
  id smallint not null primary key,
  name varchar(20) not null unique);

create table model (
  id smallint not null primary key,
  name varchar(20) not null, 
  id_manufacturer integer not null references manufacturer(id),
  unique(name,id_manufacturer));

create table options (
  id smallint not null primary key, 
  name varchar(50) not null unique,
  owner smallint not null references options(id),
  description varchar(250));

create table fio_name (
  id integer not null primary key, 
  name varchar(30) not null,
  owner integer not null references fio_name(id), 
  unique(name,owner));

create table status (
  id smallint not null primary key, 
  name varchar(30) not null unique);   
  
create table post_clerk (
  id smallint not null primary key,
  name varchar(30) not null unique);

create table basic_equipment (
  id integer not null primary key, 
  id_model integer not null references model(id),
  name varchar(25) not null, 
  price integer not null check (price>=0),
  cost integer not null check (cost>=0), 
  unique(name,id_model));

create table options_equipment(
  id_basic_equipment integer not null references basic_equipment(id), 
  id_options integer not null references options(id),
  unique(id_basic_equipment,id_options));     
  
create table available_options(
  id_basic_equipment integer not null references basic_equipment(id),
  id_options integer not null references options(id),
  price integer not null check (price>=0),  
  cost integer not null check (cost>=0), 
  unique(id_basic_equipment,id_options));
  
create table clerk (
  id smallint not null primary key, 
  first_name smallint not null references fio_name(id) check (first_name in (select id FROM fio_name WHERE owner=1)),
  second_name smallint not null references fio_name(id) check (second_name in (select id FROM fio_name WHERE owner=2)), 
  middle_name smallint not null references fio_name(id) check (middle_name in (select id FROM fio_name WHERE owner=3)),
  post smallint not null references post_clerk(id), 
  birthday date not null,
  unique(first_name,second_name,middle_name,birthday));

create table client (
  id integer not null primary key, 
  first_name smallint not null references fio_name(id) check (first_name in (select id FROM fio_name WHERE owner=1)), 
  second_name smallint not null references fio_name(id) check (second_name in (select id FROM fio_name WHERE owner=2)),
  middle_name smallint not null references fio_name(id) check (middle_name in (select id FROM fio_name WHERE owner=3)),
  passport_number varchar(10) not null unique, 
  telephone varchar(15) not null,
  birthday date not null,
  gender varchar(1) not null check (gender='�' or gender='�'), 
  unique(first_name,second_name,middle_name,birthday));

create table contract (
  id integer not null primary key, 
  id_model integer not null references model(id), 
  id_basic_equipment integer not null references basic_equipment(id), 
  id_client integer not null references client(id), 
  id_clerk integer not null references clerk(id), 
  status smallint not null references status(id),
  price integer not null check (price>=0), 
  cost integer not null check (cost>=0), 
  vin_cars varchar(20),
  date_conclusion date not null,
  date_delivery date,
  date_receipt date);
  
create table ordered_options(
  id_contract integer not null references contract(id), 
  id_options integer not null references options(id), 
  price integer not null check (price>=0), 
  cost integer not null check (cost>=0), 
  unique(id_contract,id_options));
  
create table characteristics (
  id smallint not null primary key, 
  name varchar(30) not null unique); 

create table characteristics_equipment(
  id_basic_equipment integer not null references basic_equipment(id),
  id_options integer not null references options(id),
  id_characteristics integer not null references characteristics(id),
  value_characteristics decimal(10,3) not null,  
  unique(id_basic_equipment,id_options,id_characteristics));

create table warehouse (
  vin varchar(20) not null primary key,
  id_model integer not null references model(id),
  id_basic_equipment integer not null references basic_equipment(id),
  price integer not null check (price>=0),
  cost integer not null check (price>=0));

create table installed_options(
  vin_warehouse varchar(20) not null references warehouse(vin),
  id_options integer not null references options(id),
  price integer not null check (price>=0),
  cost integer not null check (price>=0),
  unique(vin_warehouse,id_options));
  
create index date_conc on contract(date_conclusion);
create index date_rec on contract(date_receipt);
create index date_del on contract(date_delivery);
 
/*���������� ��������������*/
insert into manufacturer values (1,'Ford');
insert into manufacturer values (2,'Toyota');
insert into manufacturer values (3,'Nissan');
insert into manufacturer values (4,'Mersades');
insert into manufacturer values (5,'Chevrolet');

/*���������� �������*/
insert into model values (1,'Fiesta',1); 
insert into model values (2,'Focus',1); 
insert into model values (3,'Mondeo',1); 
insert into model values (4,'Kuga',1); 
insert into model values (5,'Galaxy',1); 

/*���������� �����*/
insert into options values (1,'�����',1,null);
insert into options values (2,'��������� � �����������',2,null);
insert into options values (3,'���� ������',3,null);
insert into options values (4,'������� ������',4,null);
insert into options values (5,'�����',5,null);
insert into options values (101,'������� 3 ��.',1,null);
insert into options values (102,'������� 5 ��.',1,null);
insert into options values (103,'1,4 � (96 �.�.), 4 ����',2,'������');
insert into options values (104,'1,4 � (96 �.�.), 5 ����',2,'������');
insert into options values (105,'1,6 � (120 �.�.), 5 ����',2,'������');
insert into options values (106,'1.6 � (134 �.�.), 5 ����',2,'������');
insert into options values (107,'Colorado Red',3,'���� ����������� �������');
insert into options values (108,'Frozen White',3,'���� �������� �����');
insert into options values (109,'Vision (Metallic)',3,'���� ������� (��������)');
insert into options values (110,'Panther Black (Metallic)',3,'���� ������ ������� (��������)');
insert into options values (111,'Hot Magenta (Metallic)',3,'���� ������� ��������� (��������)');
insert into options values (112,'Ecrin, Syracuse',4,'����� Ecrin, ���� Syracuse');
insert into options values (113,'���������� Sony',5,'CD/MP3 + AM/FM �����, 3" ��������� ������� ������ �����, 6 ���������, RDS ����� �������������� �������, ���������� ������������� � �������� ������, Bluetooth, ��������� ���������� (����. ��.), ���� AUX, USB-����');
insert into options values (114,'����� "�����������"',5,'�����������, ���������� ''Titanium''');
insert into options values (115,'����� "Trend Plus"',5,'�����������, �������� ��������������� ����, �������������� �������� ������, 15'' ������������� �������� �����, �������� ���������');
insert into options values (116,'����� "Titanium Plus"',5,'������-��������, ���������� Sony, �������� ���������');
insert into options values (117,'����� "���������"',5,'������ ������� ��������, ������������� ����������� ������� ������');
insert into options values (118,'������ �����',5,'�������������� �������� �������, �������������� �������� ������');
insert into options values (119,'�������� ��������������� ����',5,null);
insert into options values (120,'���������� ������ ������� ������������ �������',5,null);
insert into options values (121,'�������� � ������ ������� ��������',5,null);
insert into options values (122,'�����������',5,null);
insert into options values (123,'������-��������',5,null);
insert into options values (124,'������� ��������������� ���. �������� ���������',5,null);
insert into options values (125,'�������������� �������� �������',5,null);
insert into options values (126,'�������������� �������� ������',5,null);
insert into options values (127,'����� ������� ������� ������������',5,'�������� �������� ������� ������������ ��������');
insert into options values (128,'����� ������� ������ ������������',5,'�������� �������� ������� ������������ ��������');
insert into options values (129,'������� �������� ������������ (IVD)',5,'�������� ������� ������ ��� ���������� ���������� (EBA), ������� ������������� ��������� ������ (EBD), ������������ ������ � ������� ������� �������/������ ������������');
insert into options values (130,'����� ������������ �5',5,'����������� �����, ������������� ���������� ����������� ������ � ����� ��������������� �������, �������������� ������������');
insert into options values (131,'��������������� ��������� ������',5,null);
insert into options values (132,'������������� � ���������� ��� �������� ����������',5,null);
insert into options values (133,'�������� ���������',5,null);
insert into options values (134,'�������� � ������ ��������� ��������� �������',5,null);
insert into options values (135,'����������� ���������� ����� �� ������� ��������',5,null);
insert into options values (136,'����������� ������ �����������',5,null);
insert into options values (137,'���������� Trend',5,'CD/MP3+AM/FM �����, 6���������, ������� �� �� ������� ������, ���� ��� ������������� ������� ���������� (AUX), USB-����, ������������������� ������� (RDS)');

/*���������� ���*/
insert into fio_name values (1,'���',1); 
insert into fio_name values (2,'�������',2);
insert into fio_name values (3,'��������',3);
insert into fio_name values (4,'������',1);
insert into fio_name values (5,'�������',2); 
insert into fio_name values (6,'��������',3);
insert into fio_name values (7,'�������',1);
insert into fio_name values (8,'��������',2); 
insert into fio_name values (9,'����������',3);
insert into fio_name values (10,'����',1);
insert into fio_name values (11,'������',2); 
insert into fio_name values (12,'��������',3);
insert into fio_name values (13,'����',1);
insert into fio_name values (14,'���������',2); 
insert into fio_name values (15,'��������������',3);
insert into fio_name values (16,'������',1);
insert into fio_name values (17,'������',2); 
insert into fio_name values (18,'��������',3);

/*���������� �������*/
insert into status values (1,'�������');
insert into status values (2,'���������');
insert into status values (3,'�������');
insert into status values (4,'�������');
insert into status values (5,'���������');

/*���������� ����������*/
insert into post_clerk values (1,'�����������');
insert into post_clerk values (2,'������� �����������');
insert into post_clerk values (3,'�������� ����');
insert into post_clerk values (4,'�������� �� ��������');
insert into post_clerk values (5,'������� ��������');
insert into post_clerk values (6,'������������� ����������');
insert into post_clerk values (7,'������');

/*���������� ������� ������������*/
insert into basic_equipment values (1,1,'Trend',597000,597000);
insert into basic_equipment values (2,1,'Titanium',663500,663500);
insert into basic_equipment values (3,1,'Sport Limited Edition',735500,735500);
insert into basic_equipment values (4,2,'Ambiente',532000,532000);
insert into basic_equipment values (5,2,'Trend',610500,610500);

/*����� ������������*/
insert into options_equipment values (1,137);
insert into options_equipment values (3,137);
insert into options_equipment values (2,133);
insert into options_equipment values (3,133);
insert into options_equipment values (2,122);
insert into options_equipment values (3,123);

/*���������� ��������� �����*/
insert into available_options values (1,113,21000,21000);
insert into available_options values (2,113,10700,10700);
insert into available_options values (3,113,14500,14500);
insert into available_options values (1,122,23000,23000);
insert into available_options values (1,123,39000,39000);
insert into available_options values (2,123,12000,12000);
insert into available_options values (1,133,4000,4000);

/*���������� ��������*/
insert into clerk values (1,4,5,6,1,'1992/12/12');
insert into clerk values (2,7,8,9,2,'1992/6/24');
insert into clerk values (3,7,5,12,6,'1992/5/18');
insert into clerk values (4,13,17,15,7,'1992/5/18');

/*���������� ��������*/
insert into client values (1,13,14,15,'3123654123',89099121345,'1992/12/7','�');
insert into client values (2,10,11,12,'3123621312',89034531345,'1984/9/14','�');
insert into client values (3,16,17,18,'3125641314',89435311345,'1976/6/21','�');
insert into client values (4,4,8,12,'3123646411',89089514566,'1967/3/28','�');

/*���������� ���������*/
insert into contract values (1,1,1,1,1,1,672500,672500,null,'2012/11/11',null,null);
insert into contract values (2,1,2,2,2,2,751000,751000,null,'2012/12/12','2012/12/24',null);
insert into contract values (3,1,2,3,3,3,872700,872700,'1D4GP25B03B108775','2012/4/2','2012/5/2','2012/5/6');
insert into contract values (4,1,3,4,4,4,851500,851500,'3D9GP25B05G108757','2012/3/13','2012/4/21',null);

/*���������� ��������� �����*/
insert into ordered_options values (1,113,21000,21000);
insert into ordered_options values (1,123,39000,39000);
insert into ordered_options values (1,133,4000,4000);
insert into ordered_options values (2,113,10700,10700);
insert into ordered_options values (3,123,12000,12000);
insert into ordered_options  values (4,113,14500,14500);

/*���������� �������������*/
insert into characteristics values (1,'������ �� 100 ��/�');
insert into characteristics values (2,'������������ ��������');
insert into characteristics values (3,'����� ��������� ���������');
insert into characteristics values (4,'������� ���������� ����');

/*���������� ������� ������������� ��� ����� ��� ������������*/
insert into characteristics_equipment values (1,103,1,9.8);
insert into characteristics_equipment values (1,103,2,169);
insert into characteristics_equipment values (1,102,3,15);
insert into characteristics_equipment values (1,102,4,50);

/*������ �� ������*/
insert into warehouse values ('3D9GP25B05G104567',1,1,751500,751500);
insert into warehouse values ('3D9GP25B05G101234',1,2,851500,851500);

/*�����  ����� �� ������*/
insert into installed_options values ('3D9GP25B05G101234',113,21000,21000);
insert into installed_options values ('3D9GP25B05G104567',113,10700,10700);
insert into installed_options values ('3D9GP25B05G101234',102,0,0);
insert into installed_options values ('3D9GP25B05G104567',101,0,0);
insert into installed_options values ('3D9GP25B05G101234',104,0,0);
insert into installed_options values ('3D9GP25B05G104567',103,0,0);
insert into installed_options values ('3D9GP25B05G101234',107,0,0);
insert into installed_options values ('3D9GP25B05G104567',107,0,0);
commit;

/*version 3.3 final*/
