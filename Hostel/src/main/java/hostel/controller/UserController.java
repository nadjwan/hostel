package hostel.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import hostel.connection.ConnectionManager;
import hostel.dao.UserDAO;
import hostel.model.User;

/**
 * Servlet implementation class UserController
 */
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO dao;
	static Connection con = null;
	static PreparedStatement ps = null;
	static Statement stmt = null;
	static ResultSet rs = null;
	private int uid, role;
	private String name, email, pass, password;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserController() {
        super();
        dao = new UserDAO();
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
		if(action.equals("update")) {
			request.setAttribute("u", UserDAO.getUserById(uid));
			RequestDispatcher req = request.getRequestDispatcher("profilePage.jsp");
			req.forward(request, response);
		}
		else if(action.equals("delete")) {
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
				out.println("alert"+"('Unable to delete account');");
				out.println("var newLocation = 'UserController?action=update&uid=" + uid + "';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
			else {
				dao.deleteUser(uid);
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('Account successfully deleted');");
				out.println("var newLocation = 'registerPage.html';");
				out.println("window.location = newLocation;");
				out.println("</script>");
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
		
		if(request.getParameter("uid") != null) {
			HttpSession session = request.getSession();
			Object oj = session.getAttribute("uid");
			int user = 0;
			if(oj != null) {
				user = Integer.parseInt(oj.toString());
			}
			else {
				response.sendRedirect("loginPage.jsp");
			}
			uid = Integer.parseInt(request.getParameter("uid"));
			User u = new User();
			u.setUid(user);
			u.setName(name);
			u.setEmail(email);
			u.setPassword(password);
			if(pass.equals(password)) {
				try {
					con = ConnectionManager.getConnection();
					
					ps = con.prepareStatement("SELECT email FROM user WHERE email = ? AND user_id != ?");
					ps.setString(1, email);
					ps.setInt(2, user);
					
					rs = ps.executeQuery();
					
					if(rs.next()) {
						out.println("<script type='text/javascript'>");
						out.println("alert"+"('Email already exist');");
						out.println("var newLocation = 'UserController?action=update&uid=" + user + "';");
						out.println("window.location = newLocation;");
						out.println("</script>");
					}
					else {
						if(dao.updateUser(u)) {
							out.println("<script type='text/javascript'>");
							out.println("alert"+"('Update successfully');");
							out.println("var newLocation = 'homePage.jsp';");
							out.println("window.location = newLocation;");
							out.println("</script>");
						}
						else {
							out.println("<script type='text/javascript'>");
							out.println("alert"+"('Something went wrong!');");
							out.println("var newLocation = 'UserController?action=update&uid=" + user + "';");
							out.println("window.location = newLocation;");
							out.println("</script>");
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
				out.println("var newLocation = 'UserController?action=update&uid=" + user + "';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
		}
		else if(request.getParameter("login") != null) {
			uid = dao.login(email, password);
			if(uid > 0) {
				HttpSession session = request.getSession();
				session.setAttribute("uid", uid);
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('Login successfully');");
				out.println("var newLocation = 'homePage.jsp';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
			else {
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('Wrong email or password');");
				out.println("var newLocation = 'loginPage.jsp';");
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
						User u = new User();
						u.setName(name);
						u.setEmail(email);
						u.setPassword(password);
						if(dao.addUser(u)) {
							out.println("<script type='text/javascript'>");
							out.println("alert"+"('Register successfully');");
							out.println("var newLocation = 'loginPage.jsp';");
							out.println("window.location = newLocation;");
							out.println("</script>");
						}
						else {
							out.println("<script type='text/javascript'>");
							out.println("alert"+"('Something went wrong!');");
							out.println("var newLocation = 'registerPage.html';");
							out.println("window.location = newLocation;");
							out.println("</script>");
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
