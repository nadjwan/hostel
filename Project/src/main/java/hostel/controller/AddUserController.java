package hostel.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import hostel.connection.ConnectionManager;

/**
 * Servlet implementation class AddUserController
 */
public class AddUserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Connection con = null;
	static PreparedStatement ps = null;
	static Statement stmt = null;
	static ResultSet rs = null;
	static Connection con1 = null;
	static Statement stmt1 = null;
	static ResultSet rs1 = null;
	int id, role;
	String name, email, pass, password;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddUserController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		String action = request.getParameter("action");
		int uid = Integer.parseInt(request.getParameter("uid"));
		if(action.equals("delete")) {
			//SELECT COUNT(booking_id) AS bid FROM booking b JOIN hostel h ON b.hostel_id = h.hostel_id WHERE h.user_id = 4 AND b.checkin_date > CURDATE() AND status = 'Confirmed';
			//SELECT COUNT(booking_id) as bid FROM booking WHERE user_id = 5 AND status = 'Confirmed' AND checkin_date > CURDATE()
			int check1 = 0;
			int check2 = 0;
			try {
				con = ConnectionManager.getConnection();
				
				stmt = con.createStatement();
				String sql = "SELECT COUNT(booking_id) as bid FROM booking WHERE user_id = "+ uid +" AND status = 'Confirmed' AND checkin_date > CURDATE()";
				rs = stmt.executeQuery(sql);
				if(rs.next()) {
					check1 = rs.getInt("bid");
				}
				con.close();
			}
			catch(Exception e) {
				e.printStackTrace();
			}
			try {
				con = ConnectionManager.getConnection();
				
				stmt = con.createStatement();
				String sql = "SELECT COUNT(booking_id) AS bid FROM booking b JOIN hostel h ON b.hostel_id = h.hostel_id WHERE h.user_id = "+ uid +" AND b.checkin_date > CURDATE() AND status = 'Confirmed'";
				rs = stmt.executeQuery(sql);
				if(rs.next()) {
					check2 = rs.getInt("bid");
				}
				con.close();
			}
			catch(Exception e) {
				e.printStackTrace();
			}
			if(check1 > 0 || check2 > 0) {
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('Cannot delete account');");
				out.println("var newLocation = 'profilePage.jsp';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
			else {
				try {
					con = ConnectionManager.getConnection();
					
					ps = con.prepareStatement("DELETE FROM user WHERE user_id=?");
					ps.setInt(1, uid);
					ps.executeUpdate();
					con.close();
					out.println("<script type='text/javascript'>");
					out.println("alert"+"('User deleted successfully');");
					out.println("var newLocation = 'loginPage.jsp';");
					out.println("window.location = newLocation;");
					out.println("</script>");
				}
				catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
		
		name = request.getParameter("name");
		email = request.getParameter("email");
		pass = request.getParameter("pass");
		password = request.getParameter("password");
		role = 1;
		
		if(request.getParameter("uid") != null) {
			id = Integer.parseInt(request.getParameter("uid"));
			if(pass.equals(password)) {
				try {
					con = ConnectionManager.getConnection();
					
					ps = con.prepareStatement("SELECT email FROM user WHERE email = ? AND user_id != ?");
					ps.setString(1, email);
					ps.setInt(2, id);
					
					rs = ps.executeQuery();
					
					if(rs.next()) {
						out.println("<script type='text/javascript'>");
						out.println("alert"+"('Email already exist');");
						out.println("var newLocation = 'profilePage.jsp';");
						out.println("window.location = newLocation;");
						out.println("</script>");
					}
					else {
						try {
							con = ConnectionManager.getConnection();
							
							String sql = "UPDATE user SET name=?,email=?,password=? WHERE user_id=?";
							ps = con.prepareStatement(sql);
							
							ps.setString(1, name);
							ps.setString(2, email);
							ps.setString(3, password);
							ps.setInt(4, id);
							
							ps.executeUpdate();
							
							con.close();
							out.println("<script type='text/javascript'>");
							out.println("alert"+"('Update successfully');");
							out.println("var newLocation = 'homePage.jsp';");
							out.println("window.location = newLocation;");
							out.println("</script>");
						}
						catch(Exception e) {
							out.println("<body onload=\"alert('DB Error: "+e+"');\">");
						}
					}
					con.close();
				}
				catch(Exception e) {
					e.printStackTrace();
				}
			}
			else {
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('Password not match');");
				out.println("var newLocation = 'profilePage.jsp';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
		}
		else {
			if(pass.equals(password)) {
				try {
					con = ConnectionManager.getConnection();
					
					ps = con.prepareStatement("SELECT * FROM user WHERE email=?");
					ps.setString(1, email);
					
					rs = ps.executeQuery();
					
					if(rs.next()) {
						out.println("<script type='text/javascript'>");
						out.println("alert"+"('Account already exist');");
						out.println("var newLocation = 'registerPage.html';");
						out.println("window.location = newLocation;");
						out.println("</script>");
					}
					else {
						try {
							con = ConnectionManager.getConnection();
							
							String sql = "INSERT INTO user(name,email,password,role)VALUES(?,?,?,?)";
							ps = con.prepareStatement(sql);
							
							ps.setString(1, name);
							ps.setString(2, email);
							ps.setString(3, password);
							ps.setInt(4, role);
							
							ps.executeUpdate();
							
							con.close();
							out.println("<script type='text/javascript'>");
							out.println("alert"+"('Data insert to database');");
							out.println("var newLocation = 'loginPage.jsp';");
							out.println("window.location = newLocation;");
							out.println("</script>");
						}
						catch(Exception e) {
							out.println("<body onload=\"alert('DB Error: "+e+"');\">");
						}
					}
					con.close();
				}
				catch(Exception e) {
					e.printStackTrace();
				}
			}
			else {
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('Password not match');");
				out.println("var newLocation = 'registerPage.html';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
		}
	}

}