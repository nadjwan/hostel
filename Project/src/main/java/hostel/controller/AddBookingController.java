package hostel.controller;

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
import java.time.LocalDate;

import hostel.connection.ConnectionManager;

/**
 * Servlet implementation class AddBookingController
 */
public class AddBookingController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Connection con = null;
	static PreparedStatement ps = null;
	String today, cin, cout;
	int pax;
	double price;
	int uid, hid;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddBookingController() {
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
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		today = request.getParameter("today");
		cin = request.getParameter("cin");
		cout = request.getParameter("cout");
		pax = Integer.parseInt(request.getParameter("pax"));
		price = Double.parseDouble(request.getParameter("price"));
		uid = Integer.parseInt(request.getParameter("uid"));
		hid = Integer.parseInt(request.getParameter("hid"));
		HttpSession session = request.getSession();
		session.setAttribute("uid", uid);
		try {			
			//call getConnection() method
			con = ConnectionManager.getConnection();
			

			//3. create statement
			String sql = "INSERT INTO booking(booking_date,checkin_date,checkout_date,pax,price,status,user_id,hostel_id)VALUES(?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(sql);
			
			ps.setDate(1, java.sql.Date.valueOf(LocalDate.parse(today)));
			ps.setDate(2, java.sql.Date.valueOf(LocalDate.parse(cin)));
			ps.setDate(3, java.sql.Date.valueOf(LocalDate.parse(cout)));
			ps.setInt(4, pax);
			ps.setDouble(5, price);
			ps.setString(6, "Pending");
			ps.setInt(7, uid);
			ps.setInt(8, hid);

			//4. execute query
			ps.executeUpdate();

			//5. close connection
			con.close();
			out.println("<script type='text/javascript'>");
			out.println("alert"+"('Booking successful');");
			out.println("var newLocation = 'myBooking.jsp';");
			out.println("window.location = newLocation;");
			out.println("</script>");

		}catch(Exception e) {
			out.println("<body onload=\"alert('DB Error: "+e+"');\">");
		}
	}

}
