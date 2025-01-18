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
import java.sql.Statement;

import hostel.connection.ConnectionManager;

import java.sql.ResultSet;

/**
 * Servlet implementation class LoginServlet
 */
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Connection con = null;
	static PreparedStatement ps = null;
	static Statement stmt = null;
	static ResultSet rs = null;
	String email, password;
	int id, role;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
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
		
		email = request.getParameter("email");
		password = request.getParameter("pass");
		
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT * FROM user WHERE email=? AND password=?");
			ps.setString(1, email);
			ps.setString(2, password);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				id = rs.getInt("user_id");
				HttpSession session = request.getSession();
				session.setAttribute("uid", id);
				//response.sendRedirect("homePage.jsp?uid="+id);
				response.sendRedirect("homePage.jsp");
			}
			else {
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('Wrong email or password');");
				out.println("var newLocation = 'loginPage.jsp';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
			con.close();
		}
		catch(Exception e) {
			out.println("<body onload=\"alert('DB Error: " + e + "');\">");
		}
	}

}
