use test;

explain select * from table_two straight_join table_one on (table_one.a=table_two.a);
/*explain结果
+----+-------------+-----------+------------+------+---------------+------+---------+------------------+------+----------+-------------+
| id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref              | rows | filtered | Extra       |
+----+-------------+-----------+------------+------+---------------+------+---------+------------------+------+----------+-------------+
|  1 | SIMPLE      | table_two | NULL       | ALL  | a             | NULL | NULL    | NULL             |  100 |   100.00 | Using where |
|  1 | SIMPLE      | table_one | NULL       | ref  | a             | a    | 5       | test.table_two.a |    1 |   100.00 | NULL        |
+----+-------------+-----------+------------+------+---------------+------+---------+------------------+------+----------+-------------+
*/

select * from table_two straight_join table_one on (table_one.a=table_two.a);

#非join方法，见文件2.disadvantageWithoutJoin.cpp