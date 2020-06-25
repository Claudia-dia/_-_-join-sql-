use test;

explain select * from table_two join table_one on (table_one.a=table_two.a);
/*开启BKA时explain结果
+----+-------------+-----------+------------+------+---------------+------+---------+------------------+------+----------+-------------+
| id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref              | rows | filtered | Extra       |
+----+-------------+-----------+------------+------+---------------+------+---------+------------------+------+----------+-------------+
|  1 | SIMPLE      | table_two | NULL       | ALL  | a             | NULL | NULL    | NULL             |  100 |   100.00 | Using where |
|  1 | SIMPLE      | table_one | NULL       | ref  | a             | a    | 5       | test.table_two.a |    1 |   100.00 | NULL        |
+----+-------------+-----------+------------+------+---------------+------+---------+------------------+------+----------+-------------+
*/

#开启BKA
set optimizer_switch='mrr=on,mrr_cost_based=off,batched_key_access=on';

explain select * from table_two join table_one on (table_one.a=table_two.a);
/*开启BKA时explain结果
+----+-------------+-----------+------------+------+---------------+------+---------+------------------+------+----------+----------------------------------------+
| id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref              | rows | filtered | Extra                                  |
+----+-------------+-----------+------------+------+---------------+------+---------+------------------+------+----------+----------------------------------------+
|  1 | SIMPLE      | table_two | NULL       | ALL  | a             | NULL | NULL    | NULL             |  100 |   100.00 | Using where                            |
|  1 | SIMPLE      | table_one | NULL       | ref  | a             | a    | 5       | test.table_two.a |    1 |   100.00 | Using join buffer (Batched Key Access) |
+----+-------------+-----------+------------+------+---------------+------+---------+------------------+------+----------+----------------------------------------+
*/