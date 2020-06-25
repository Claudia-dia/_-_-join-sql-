use test;

explain select * from t1 join t2 on (t1.b=t2.b) where t2.b>=1 and t2.b<=2000;
/*explain结果
+----+-------------+-------+------------+------+---------------+------+---------+------+--------+----------+----------------------------------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows   | filtered | Extra                                              |
+----+-------------+-------+------------+------+---------------+------+---------+------+--------+----------+----------------------------------------------------+
|  1 | SIMPLE      | t1    | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   1000 |   100.00 | Using where                                        |
|  1 | SIMPLE      | t2    | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 899415 |     1.11 | Using where; Using join buffer (Block Nested Loop) |
+----+-------------+-------+------------+------+---------------+------+---------+------+--------+----------+----------------------------------------------------+
*/

#开启Query Profiler功能
set profiling=1;

#按BNL算法执行查询操作
select * from t1 join t2 on (t1.b=t2.b) where t2.b>=1 and t2.b<=2000;

#建立临时表temp_t，在b字段上建立索引
create temporary table temp_t(
	id int primary key, 
	a int, 
	b int,
	index(b)
)engine=innodb;

#向临时表插入数据
insert into temp_t select * from t2 where b>=1 and b<=2000;

#在表t1和临时表temp_t上再做join操作
select * from t1 join temp_t on (t1.b=temp_t.b);

#查看sql语句的执行时间等信息
show profiles;
/*profiles结果
+----------+-------------+--------------------------------------------------------------------------------------------+
| Query_ID | Duration    | Query                                                                                      |
+----------+-------------+--------------------------------------------------------------------------------------------+
|       13 | 62.23565975 | select * from t1 join t2 on (t1.b=t2.b) where t2.b>=1 and t2.b<=2000                       |
|       14 |  0.00846425 | create temporary table temp_t(id int primary key,a int,b int,index(b))engine=innodb 		  |
|       15 |  0.53847400 | insert into temp_t select * from t2 where b>=1 and b<=2000                                 |
|       16 |  0.00511275 | select * from t1 join temp_t on (t1.b=temp_t.b)                                            |
+----------+-------------+--------------------------------------------------------------------------------------------+
*/
