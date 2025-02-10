package hostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import hostel.connection.ConnectionManager;
import hostel.model.Review;

public class ReviewDAO {
	static Connection con = null;
	static PreparedStatement ps = null;
	static Statement stmt = null;
	static ResultSet rs = null;
	
	public void addReview(Review r) {
		try {
			con = ConnectionManager.getConnection();
			
			String sql = "INSERT INTO review(rating,comment,booking_id)VALUES(?,?,?)";
			ps = con.prepareStatement(sql);
			ps.setInt(1, r.getRating());
			ps.setString(2, r.getComment());
			ps.setInt(3, r.getBid());
			
			ps.executeUpdate();
			
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void deleteReview(int id) {
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("DELETE FROM review WHERE review_id=?");
			ps.setInt(1, id);
			
			ps.executeUpdate();
			
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
}
