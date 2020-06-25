use test;

explain select * from t1 where a>=1 and a<=100;
/*未开启MRR时explain结果
+----+-------------+-------+------------+-------+---------------+------+---------+------+------+----------+-----------------------+
| id | select_type | table | partitions | type  | possible_keys | key  | key_len | ref  | rows | filtered | Extra                 |
+----+-------------+-------+------------+-------+---------------+------+---------+------+------+----------+-----------------------+
|  1 | SIMPLE      | t1    | NULL       | range | a             | a    | 5       | NULL |  100 |   100.00 | Using index condition |
+----+-------------+-------+------------+-------+---------------+------+---------+------+------+----------+-----------------------+
*/

#开启MRR
set optimizer_switch='mrr=on,mrr_cost_based=off';

explain select * from t1 where a>=1 and a<=100;
/*开启MRR时explain结果
+----+-------------+-------+------------+-------+---------------+------+---------+------+------+----------+----------------------------------+
| id | select_type | table | partitions | type  | possible_keys | key  | key_len | ref  | rows | filtered | Extra                            |
+----+-------------+-------+------------+-------+---------------+------+---------+------+------+----------+----------------------------------+
|  1 | SIMPLE      | t1    | NULL       | range | a             | a    | 5       | NULL |  100 |   100.00 | Using index condition; Using MRR |
+----+-------------+-------+------------+-------+---------------+------+---------+------+------+----------+----------------------------------+
*/


#比较开启和不开启MRR耗时
#开启Query Profiler功能
set profiling=1;

#在开启MRR情况下执行sql语句
select * from t2 where a>=1 and a<=100000;

#关闭MRR
set optimizer_switch='mrr=off,mrr_cost_based=on';

#在关闭MRR情况下执行sql语句
select * from t2 where a>=1 and a<=100000;

#查看sql语句的执行时间等信息
show profiles;
/*profiles表
+----------+------------+--------------------------------------------------+
| Query_ID | Duration   | Query                                            |
+----------+------------+--------------------------------------------------+
|        1 | 0.29138300 | select * from t2 where a>=1 and a<=100000        |
|        2 | 0.00021175 | set optimizer_switch='mrr=off,mrr_cost_based=on' |
|        3 | 0.56584875 | select * from t2 where a>=1 and a<=100000        |
+----------+------------+--------------------------------------------------+
*/