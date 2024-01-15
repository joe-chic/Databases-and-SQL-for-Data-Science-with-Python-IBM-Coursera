import os
os.add_dll_directory("C:\\DB2\\BIN\\")

# Which is the difference beetween the libraries?
import ibm_db  # low level ~ in trial
import ibm_db_dbi # high level ~ in trial
import pandas as pd
from tabulate import tabulate

# Environment variables with credential information.
dsn_driver = os.environ['DSN_DRIVER']
dsn_database = os.environ['DSN_DATABASE']
dsn_hostname = os.environ['DSN_HOSTNAME']
dsn_port = os.environ['DSN_PORT']
dsn_protocol = 'TCPIP'
dsn_uid = os.environ['DSN_UID']
dsn_pwd = os.environ['DSN_PWD']
dsn_security = 'SSL'

dsn = (
    "DRIVER={0};"
    "DATABASE={1};"
    "HOSTNAME={2};"
    "PORT={3};"
    "PROTOCOL={4};"
    "UID={5};"
    "PWD={6};"
    "SECURITY={7};").format(dsn_driver, dsn_database, dsn_hostname, dsn_port, dsn_protocol, dsn_uid, dsn_pwd,dsn_security)

#print the connection string to check correct values are specified
print(dsn)

# Create connection object
try:
    Connection = ibm_db.connect(dsn,'','')
    server = ibm_db.server_info(Connection)
    Conn = ibm_db_dbi.Connection(Connection)
    print('\nConnected to the database:',dsn_database,'as user:',dsn_uid,'on host: ',dsn_hostname,'\n')

    Cursor = Conn.cursor()

    Cursor.execute('SELECT * FROM EMPLOYEES')
    Results = Cursor.fetchall()
    print(Results,'\n')

    '''
    stmt = ibm_db.exec_immediate(Connection,(
                                        "CREATE TABLE Trucks(serial_no VARCHAR(20) PRIMARY KEY NOT NULL," 
                                        "model VARCHAR(20) NOT NULL,"
                                        "manufacturer VARCHAR(20) NOT NULL,"
                                        "Engine_size VARCHAR(20) NOT NULL,"
                                        "Truck_size VARCHAR(20) NOT NULL)"
                                    )
                                )
    
    stmt = ibm_db.exec_immediate(Connection,(
                                        'INSERT INTO Trucks(serial_no,model,manufacturer,Engine_size,Truck_size) '
                                        'VALUES(\'A1234\', \'Lonestar\', \'International Trucks\', \'Cummins ISX15\', \'Class 8\');'
                                    )
                                )
    '''
                                
    stmt = ibm_db.exec_immediate(Connection,'SELECT * FROM Trucks')
    var_pd = pd.read_sql('SELECT * FROM Trucks',con=Conn)
    var_pd = tabulate(var_pd,headers='keys',tablefmt='psql')
    print(ibm_db.fetch_both(stmt),'\n')
    print(var_pd)


    Cursor.close()
    Conn.close()

except Exception as e:
    print('There was a mistake with your database:', e)