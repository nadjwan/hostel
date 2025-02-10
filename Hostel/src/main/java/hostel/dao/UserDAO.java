package hostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import hostel.connection.ConnectionManager;
import hostel.model.User;

public class UserDAO {
	static Connection con = null;
	static PreparedStatement ps = null;
	static Statement stmt = null;
	static ResultSet rs = null;
	
	public boolean addUser(User u) {
		try {			
			//call getConnection() method
			con = ConnectionManager.getConnection();
			
			//3. create statement
			String sql = "INSERT INTO user(name,email,password,role)VALUES(?,?,?,?)";
			ps = con.prepareStatement(sql);
			
			ps.setString(1, u.getName());
			ps.setString(2, u.getEmail());
			ps.setString(3, u.getPassword());
			ps.setInt(4, 1);

			//4. execute query
			ps.executeUpdate();
			
			//5. close connection
			con.close();
			return true;

		}catch(Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public int login(String email, String password) {
		int uid = 0;
		try {
			con  = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT * FROM user WHERE email=? AND password=?");
			ps.setString(1, email);
			ps.setString(2, password);
			
			rs = ps.executeQuery();
			if(rs.next()) {
				uid = rs.getInt("user_id");
			}
			con.close();
			return uid;
		}
		catch(Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	public static User getUserById(int id) {
		User u = new User();
		try {
			con  = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT * FROM user WHERE user_id=?");
			ps.setInt(1, id);
			
			rs = ps.executeQuery();
			if(rs.next()) {
				u.setName(rs.getString("name"));
				u.setEmail(rs.getString("email"));
				u.setPassword(rs.getString("password"));
				u.setRole(rs.getInt("role"));
			}
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return u;
	}
	
	public boolean updateUser(User u) {
		try {
			con = ConnectionManager.getConnection();
			
			String sql = "UPDATE user SET name=?,email=?,password=? WHERE user_id=?";
			ps = con.prepareStatement(sql);
			
			ps.setString(1, u.getName());
			ps.setString(2, u.getEmail());
			ps.setString(3, u.getPassword());
			ps.setInt(4, u.getUid());
			
			ps.executeUpdate();
			
			con.close();
			return true;
		}
		catch(Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public void deleteUser(int id) {
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("DELETE FROM user WHERE user_id=?");
			ps.setInt(1, id);
			
			ps.executeUpdate();
			
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
}
