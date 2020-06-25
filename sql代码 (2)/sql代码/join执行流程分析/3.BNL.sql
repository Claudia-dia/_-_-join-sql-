use test;

explain select * from table_two straight_join table_one on (table_two.a=table_one.b);
/*explain结果
+----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
| id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                              |
+----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
|  1 | SIMPLE      | table_two | NULL       | ALL  | a             | NULL | NULL    | NULL |  100 |   100.00 | NULL                                               |
|  1 | SIMPLE      | table_one | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 1000 |    10.00 | Using where; Using join buffer (Block Nested Loop) |
+----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
*/

select * from table_two straight_join table_one on (table_two.a=table_one.b);