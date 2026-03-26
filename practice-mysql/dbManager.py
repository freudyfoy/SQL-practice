import sqlite3

connection = sqlite3.connect('chinook.db')
print("Connect success")
cursor = connection.execute("SELECT * FROM customers;")

for row in cursor:
    print(f"CustomerID: {row[0]} "
          f"FirstName: {row[1]} "
          f"LastName: {row[2]} ")

connection.close()