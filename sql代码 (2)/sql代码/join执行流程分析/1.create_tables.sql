#创建test数据库
create database test;

use test;

#建表一
CREATE TABLE `table_one` (
  `id` int(11) NOT NULL,
  `a` int(11) DEFAULT NULL,
  `b` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `a` (`a`)
) ENGINE=InnoDB;

#建表二
create table table_two like table_one;

/*表table_one、table_two格式如下表
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | NO   | PRI | NULL    |       |
| a     | int(11) | YES  | MUL | NULL    |       |
| b     | int(11) | YES  |     | NULL    |       |
+-------+---------+------+-----+---------+-------+
*/

#定义过程，像表一插入1000条数据
delimiter ;;
create procedure idata()
begin
  declare i int;
  set i=1;
  while(i<=1000)do
    insert into table_one values(i, i, i);
    set i=i+1;
  end while;
end;;
delimiter ;

#调用过程
call idata();

#向表二插入100条数据
insert into table_two (select * from table_one where id<=100);