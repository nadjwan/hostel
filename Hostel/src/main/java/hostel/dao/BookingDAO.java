package hostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import hostel.connection.ConnectionManager;
import hostel.model.Booking;

public class BookingDAO {
	static Connection con = null;
	static PreparedStatement ps = null;
	static Statement stmt = null;
	static ResultSet rs = null;
	
	public boolean addBooking(Booking b) {
		try {			
			//call getConnection() method
			con = ConnectionManager.getConnection();
			
			//3. create statement
			String sql = "INSERT INTO booking(booking_date,checkin_date,checkout_date,pax,price,status,user_id,hostel_id)VALUES(?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(sql);
			
			ps.setDate(1, java.sql.Date.valueOf(b.getBdate()));
			ps.setDate(2, java.sql.Date.valueOf(b.getCin()));
			ps.setDate(3, java.sql.Date.valueOf(b.getCout()));
			ps.setInt(4, b.getPax());
			ps.setDouble(5, b.getPrice());
			ps.setString(6, "Pending");
			ps.setInt(7, b.getUid());
			ps.setInt(8, b.getHid());

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
	public void cancelBooking(int id) {
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("UPDATE booking SET status=? WHERE booking_id=?");
			ps.setString(1, "Cancel");
			ps.setInt(2, id);
			
			ps.executeUpdate();
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	public boolean updateBooking(Booking b) {
		try {
			con = ConnectionManager.getConnection();
			ps = con.prepareStatement("UPDATE booking SET checkin_date=?, checkout_date=?, pax=?, price=? WHERE booking_id=?");
			ps.setDate(1, java.sql.Date.valueOf(b.getCin()));
			ps.setDate(2, java.sql.Date.valueOf(b.getCout()));
			ps.setInt(3, b.getPax());
			ps.setDouble(4, b.getPrice());
			ps.setInt(5, b.getBid());
			
			ps.executeUpdate();
			
			con.close();
			return true;
		}
		catch(Exception e){
			return false;
		}
	}
	public static Booking getBookingById(int id) {
		Booking b = new Booking();
		
		try {
			con  = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT b.booking_id,u.name,b.booking_date,b.checkin_date,b.checkout_date,h.hostel_name,b.pax,b.price,b.status,h.hostel_address,u.email FROM booking b JOIN hostel h ON b.hostel_id=h.hostel_id JOIN user u ON h.user_id=u.user_id WHERE b.booking_id=?");
			ps.setInt(1, id);
			
			rs = ps.executeQuery();
			if(rs.next()) {
				b.setBid(rs.getInt("booking_id"));
				b.setUname(rs.getString("name"));
				b.setBdate(rs.getString("booking_date"));
				b.setCin(rs.getString("checkin_date"));
				b.setCout(rs.getString("checkout_date"));
				b.setHname(rs.getString("hostel_name"));
				b.setPax(rs.getInt("pax"));
				b.setPrice(rs.getDouble("price"));
				b.setStatus(rs.getString("status"));
				b.setHadd(rs.getString("hostel_address"));
				b.setEmail(rs.getString("email"));
			}
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return b;
	}
	public void confirmBooking(int id) {
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("UPDATE booking SET status=? WHERE booking_id=?");
			ps.setString(1, "Confirmed");
			ps.setInt(2, id);
			
			ps.executeUpdate();
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	public static List<Booking> listBooking(int id){
		List<Booking> bookings = new ArrayList<Booking>();
		
		try {
			con = ConnectionManager.getConnection();
			
			stmt = con.createStatement();
			String sql = "SELECT b.booking_id, b.booking_date, b.checkin_date, b.checkout_date, b.pax, b.price, b.status, u.name, u.email, h.hostel_name FROM booking b JOIN user u ON b.user_id = u.user_id JOIN hostel h ON b.hostel_id = h.hostel_id WHERE h.user_id =" + id;
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				Booking b = new Booking();
				b.setUname(rs.getString("name"));
				b.setEmail(rs.getString("email"));
				b.setHname(rs.getString("hostel_name"));
				b.setBdate(rs.getString("booking_date"));
				b.setCin(rs.getString("checkin_date"));
				b.setCout(rs.getString("checkout_date"));
				b.setPax(rs.getInt("pax"));
				b.setPrice(rs.getDouble("price"));
				b.setStatus(rs.getString("status"));
				bookings.add(b);
			}
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return bookings;
	}
}
