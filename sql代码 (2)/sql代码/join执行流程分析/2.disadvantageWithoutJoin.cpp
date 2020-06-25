#include <mysql++.h>
#include <iostream>
  
using namespace std;
int main()
{
  const char* db = 0, *server = 0, *user = 0, *password = "";
  db = "test";
  server = "localhost";
  user = "root";
  password = "";
     
  mysqlpp::Connection conn(false);
  //连接数据库
  if (conn.connect(db, server, user, password)) 
  {
    cout << "connect db succeed. " << endl;
    mysqlpp::Query query = conn.query("SELECT * FROM table_two");
	//首先执行select * from table_two，查出表table_two的所有数据。
    if (mysqlpp::StoreQueryResult res = query.store()) 
    {
      cout.setf(ios::left);
      cout << setw(31) << "table_two.id" <<
      setw(10) << "table_two.a" <<
      setw(10) << "table_two.b" <<
      setw(31) << "table_one.id" <<                 
      setw(10) << "table_one.a" <<
      setw(10) << "table_one.b"	<< endl;
 
      mysqlpp::StoreQueryResult::const_iterator it;
      for (it = res.begin(); it != res.end(); ++it) 
      {
        mysqlpp::Row row = *it;
		//从每一行R取出字段a的值，拼接sql语句进行查询
		mysqlpp::Query query2 = conn.query("SELECT * FROM table_one WHERE table_one.a=%0q");
		query2.parse();
		mysqlpp::SimpleResult res2 = query.execute(row[1].c_str());
		
		if(!res2.empty())
		{
			//连接查询结果
			for(int i=0;i<res2.size();i++)
			{
				cout << setw(30) << row[0] << ' ' <<
				setw(9) << row[1] << ' ' <<
				setw(9) << row[2] << ' ' <<
				setw(30) << res2[0] << ' ' <<
				setw(9) << res2[1] << ' ' <<
				setw(9) << res2[2] << ' ' <<
				endl;
			}
      }
    }
  } 
  else 
  {
      cout << "connect db fail. " << endl;
  }
  return 0;
}