use test;
#建立表t1、t2
create table t1(id int primary key, a int, b int, index(a));

create table t2 like t1;
/*表t1、t2格式如下表
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | NO   | PRI | NULL    |       |
| a     | int(11) | YES  | MUL | NULL    |       |
| b     | int(11) | YES  |     | NULL    |       |
+-------+---------+------+-----+---------+-------+
*/

#定义存储过程
#向表t1插入1000条数据，且数据在a字段逆序
#向表t2插入1000000条数据
delimiter ;;
create procedure jdata()
begin
  declare i int;
  set i=1;
  while(i<=1000)do
    insert into t1 values(i, 1001-i, i);
    set i=i+1;
  end while;
  
  set i=1;
  while(i<=1000000)do
    insert into t2 values(i, i, i);
    set i=i+1;
  end while;
end;;
delimiter ;

call jdata();