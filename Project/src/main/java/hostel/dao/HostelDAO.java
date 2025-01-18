package hostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import hostel.connection.ConnectionManager;
import hostel.model.Hostel;

public class HostelDAO {
	static Connection con = null;
	static PreparedStatement ps = null;
	static Statement stmt = null;
	static ResultSet rs = null;
	
	int id;
	String name, address;
	double price;
	int pax;
	String desc;
	int user_id;
	
	public void addHostel(Hostel h) {
		name = h.getName();
		address = h.getAddress();
		price = h.getPrice();
		pax = h.getPax();
		desc = h.getDesc();
		user_id = h.getUserId();
		
		try {			
			//call getConnection() method
			con = ConnectionManager.getConnection();
			

			//3. create statement
			String sql = "INSERT INTO hostel(hostel_name,hostel_address,hostel_price,pax,description,user_id)VALUES(?,?,?,?,?,?)";
			ps = con.prepareStatement(sql);
			
			ps.setString(1, name);
			ps.setString(2, address);
			ps.setDouble(3, price);
			ps.setInt(4, pax);
			ps.setString(5, desc);
			ps.setInt(6, user_id);

			//4. execute query
			ps.executeUpdate();
			
			//System.out.println("Insert successfully");
			
			//5. close connection
			con.close();

		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public static List<Hostel> getAllHostel(int id){
		List<Hostel> hostels = new ArrayList<Hostel>();
		
		try {
			con = ConnectionManager.getConnection();
			
			stmt = con.createStatement();
			String sql = "SELECT * FROM hostel WHERE user_id=" + id;
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				Hostel h = new Hostel();
				h.setId(rs.getInt("hostel_id"));
				h.setName(rs.getString("hostel_name"));
				h.setAddress(rs.getString("hostel_address"));
				h.setPrice(rs.getDouble("hostel_price"));
				h.setPax(rs.getInt("pax"));
				h.setDesc(rs.getString("description"));
				h.setUserId(rs.getInt("user_id"));
				hostels.add(h);
			}
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return hostels;
	}
	
	public static Hostel getHostelById(int id) {
		Hostel h = new Hostel();
		
		try {
			con  = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT * FROM hostel WHERE hostel_id=?");
			ps.setInt(1, id);
			
			rs = ps.executeQuery();
			if(rs.next()) {
				h.setId(rs.getInt("hostel_id"));
				h.setName(rs.getString("hostel_name"));
				h.setAddress(rs.getString("hostel_address"));
				h.setPrice(rs.getDouble("hostel_price"));
				h.setPax(rs.getInt("pax"));
				h.setDesc(rs.getString("description"));
				h.setUserId(rs.getInt("user_id"));
			}
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return h;
	}
	
	public void deleteHostel(int id) {
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("DELETE FROM hostel WHERE hostel_id=?");
			ps.setInt(1, id);
			
			ps.executeUpdate();
			
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void updateHostel(Hostel bean) {
		id = bean.getId();
		name = bean.getName();
		address = bean.getAddress();
		price = bean.getPrice();
		pax = bean.getPax();
		desc = bean.getDesc();
		
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("UPDATE hostel SET hostel_name=?,hostel_address=?,hostel_price=?,pax=?,description=? WHERE hostel_id=?");
			ps.setString(1, name);
			ps.setString(2, address);
			ps.setDouble(3, price);
			ps.setInt(4, pax);
			ps.setString(5, desc);
			ps.setInt(6, id);
			
			ps.executeUpdate();
			
			//System.out.println("Successfully Update");
			
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
}
