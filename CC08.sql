

//创建内侧表
create table CC08_in_table(
id int(10) not null auto_increment,
in_position varchar(10) not null,
public_num varchar(20) not null,
private_num varchar(10)not null,
isbroken0 tinyint not null default 0,
primary key(id),
unique key in_position(in_position),
unique key private_num(private_num),
unique key public_num(public_num)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

//创建外侧表
 create table CC08_out_table(id int(10) not null auto_increment,
 line_order varchar(50),
 out_position varchar(10) not null,
 isbroken1 tinyint not null default 0,
 VHF_order varchar(20),
 F1201_J8_order varchar(5),
 F1103_J3_order varchar(10),
 F3105_J17_order varchar(10),
 F1112_J6_order varchar(10),
 sound_position varchar(30) not null,
 primary key(id),
 unique key out_position(out_position),
 unique key sound_position(sound_position)
 )ENGINE=InnoDB DEFAULT CHARSET=utf8;
 


//创建点配表
 create table point_position_table(id int(10) not null auto_increment,
 point_position varchar(50),
 point_location varchar(20),
 point_room varchar(20),
 isbroken2 tinyint not null default 0,
 primary key(id),
 unique key point_position (point_position)
 )ENGINE=InnoDB DEFAULT CHARSET=utf8;  

 phone_table.status!=101 and phone_table.status!=102 and phone_table.status!=103 and phone_table.status!=111 and
 
 //创建电话关系表
 
 create table phone_table(id int(10) not null auto_increment,
 private_num varchar(10),
 out_position varchar(10),
 point_position varchar(30),
 phone_name varchar(50),
 phone_room varchar(10),
 phone_department varchar(30),
 ishotline tinyint not null default 0,
 remark varchar(100),
 submitter varchar(10) not null,
 modify_time varchar(30) not null,
 last_time varchar(30) default null,    
 status int(10),                      
 primary key(id), 
 foreign key(private_num) references CC08_in_table(private_num),
 foreign key(out_position) references CC08_out_table(out_position),
 foreign key(point_position) references point_position_table(point_position)
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;
 //status:  101表示新增未审核，102表示修改未审核，103表示删除未审核，100代表审核通过，110代表审核未通过,111代表删除
 //before_id仅在修改审核时传递，用于找到审核未通过时的原信息。
 
 
 
//创建用户表
create table login_user(id int(10) not null auto_increment,
username varchar(30) not null,
password varchar(30) not null,
primary key(id),
user_type tinyint not null,
unique key username(username))
ENGINE=InnoDB DEFAULT CHARSET=utf8;

创建外侧弹出数据表
create table CC08_out_table_pop(id int(10) not null auto_increment,
 line_order varchar(50),
 out_position varchar(10) not null,
 primary key(id)
 )ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
 复制数据
insert into CC08_out_table_pop(line_order,out_position) select line_order,out_position from CC08_out_table;
 
 
 
 创建点配弹出数据表
create table point_position_table_pop(id int(10) not null auto_increment,
 point_position varchar(50) not null,
 primary key(id)
 )ENGINE=InnoDB DEFAULT CHARSET=utf8;

 复制数据
 insert into point_position_table_pop(point_position) select point_position from point_position_table;
 
 
导入数据库
1、在/etc/mysql/my.cnf文件中加入以下命令后重启进程：
[mysqld]
secure_file_priv=/home/demon/tools/mysql/data/test
2、将要导入的csv文件放入该文件夹，id和表名都要相同，然后进入数据库中，输入该命令
load data local infile '/home/demon/tools/mysql/data/test/test.csv' into table test fields terminated by ',' optionally enclosed by '"' escaped by '"' lines terminated by '\r\n' ignore 1 lines;
3、中文格式问题utf8（csv文件用txt打开，然后用utf8保存）
查看show variables like 'char%';  应该均为utf8
[client]
default-character-set=utf8

[mysqld]
hello world
character-set-server=utf8
collation-server=utf8_general_ci
secure_file_priv=/home/demon/tools/mysql/data/test

[mysql]
default-character-set=utf8


导出数据库
grant file on *.* to demon ;   对damon赋予文件操作权利
select * into outfile '/home/demon/tools/mysql/data/test/phone_table.csv' fields terminated by ',' lines terminated by '\r\n' from (select 'id','private_num','out_position','point_position','phone_name','phone_room','phone_department','ishotline','remark','submitter','modify_time','last_time','status' union select id,private_num,out_position,point_position,phone_name,phone_room,phone_department,ishotline,remark,submitter,modify_time,last_time,status from phone_table) b;
