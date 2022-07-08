from datetime import datetime, timedelta
import config as conf


# update historical data for all date
def update_historical_data(cursor, date_list, table, column):
    for date in date_list:
        sql_str = f'''UPDATE `historical_data` as h
                SET		h.{column} = 
                (SELECT 	b.price
                FROM	{table} as b
                WHERE	b.date <= \'{date}\'
                ORDER BY b.date DESC LIMIT 1)
                WHERE h.date = \'{date}\';'''
        try:
            cursor.execute(sql_str)
        except Exception as err:
            print(err.args)
    print(date_list[-1])


# insert all date to historical data table
def insert_all_date(cursor, date_list):
    for i in range(len(date_list)):
        sql_str = f'INSERT INTO historical_data (`date`) VALUES (\"{date_list[i]}\");'
        try:
            cursor.execute(sql_str)
        except Exception as err:
            print(err.args)    


# generate a list of all dates between begin_date, end_date
def getBetweenDay(begin_date, end_date):
    date_list = []
    begin_date = datetime.strptime(begin_date, "%Y-%m-%d")
    end_date = datetime.strptime(end_date, "%Y-%m-%d")
    while begin_date <= end_date:
        date_str = begin_date.strftime("%Y-%m-%d")
        date_list.append(date_str)
        begin_date += timedelta(days=1)
    return date_list


def main():
    db, cursor = conf.connect_db()
    date_list = getBetweenDay('2015-10-1', '2022-06-27')
    insert_all_date(cursor=cursor, date_list=date_list)

    # 'target_name': ['table_name', 'column_name'] 
    target_dict = {'Bitcoin':['bitcoin_historical_data', 'bitcoin_price'],
                   'Gold':['gold_historical_data', 'gold_price'],
                   'Oil':['oil_historical_data', 'oil_price'] 
    }

    for key in target_dict.keys():

        table = target_dict[key][0]
        column = target_dict[key][1]
        update_historical_data(cursor=cursor, date_list=date_list, table=table, column=column)

    cursor.close()


if __name__ == '__main__':
    main()