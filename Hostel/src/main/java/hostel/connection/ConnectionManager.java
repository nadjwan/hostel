package hostel.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionManager {
	static Connection con;
	
	private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
	
	private static final String DB_CONNECTION = "jdbc:mysql://localhost/hostel";
	
	private static final String DB_USER = "root";
	
	private static final String DB_PASSWORD = "";
	
	public static Connection getConnection() {
		try {
			Class.forName(DB_DRIVER);
			
			try {
				con = DriverManager.getConnection(DB_CONNECTION, DB_USER, DB_PASSWORD);
			}
			catch(SQLException e) {
				e.printStackTrace();
			}
		}
		catch(ClassNotFoundException e) {
			e.printStackTrace();
		}
		return con;
	}
}