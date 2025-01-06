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
	int role;
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
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
		name = request.getParameter("name");
		email = request.getParameter("email");
		pass = request.getParameter("pass");
		password = request.getParameter("password");
		role = 1;
		
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