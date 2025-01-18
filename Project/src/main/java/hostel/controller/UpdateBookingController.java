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
import java.sql.Statement;
import java.time.LocalDate;

import hostel.connection.ConnectionManager;

/**
 * Servlet implementation class updateBookingController
 */
public class UpdateBookingController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateBookingController() {
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
		int bid = Integer.parseInt(request.getParameter("bid"));
		if(action.equals("cancel")) {
			try {
				con = ConnectionManager.getConnection();
				
				ps = con.prepareStatement("UPDATE booking SET status=? WHERE booking_id=?");
				ps.setString(1, "Cancel");
				ps.setInt(2, bid);
				
				ps.executeUpdate();
				con.close();
				response.sendRedirect("myBooking.jsp");
			}
			catch(Exception e){
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('" + e + "');");
				out.println("var newLocation = 'myBooking.jsp';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
		}
		else if(action.equals("confirm")) {
			try {
				con = ConnectionManager.getConnection();
				
				ps = con.prepareStatement("UPDATE booking SET status=? WHERE booking_id=?");
				ps.setString(1, "Confirmed");
				ps.setInt(2, bid);
				
				ps.executeUpdate();
				con.close();
				response.sendRedirect("home.jsp");
			}
			catch(Exception e){
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('" + e + "');");
				out.println("var newLocation = 'myBooking.jsp';");
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
		LocalDate today = LocalDate.now();
		int bid = Integer.parseInt(request.getParameter("bid"));
		int hid = Integer.parseInt(request.getParameter("hid"));
		double price = Double.parseDouble(request.getParameter("price"));
		LocalDate cin = LocalDate.parse(request.getParameter("checkin"));
		LocalDate cout = LocalDate.parse(request.getParameter("checkout"));
		int pax = Integer.parseInt(request.getParameter("pax"));
		
		int day = Integer.parseInt(request.getParameter("checkout").substring(8)) - Integer.parseInt(request.getParameter("checkin").substring(8));
		double totalPrice = price * day * pax;
		if(cin.isBefore(today.plusDays(2)) || cout.isBefore(cin.plusDays(1))){
			out.println("<script type='text/javascript'>");
			out.println("alert"+"('Date is invalid');");
			out.println("var newLocation = 'myBooking.jsp';");
			out.println("window.location = newLocation;");
			out.println("</script>");
		}
		else {
			try{
				con = ConnectionManager.getConnection();
				String sql = "SELECT * FROM hostel h LEFT JOIN (SELECT b.hostel_id, SUM(b.pax) AS booked_beds FROM booking b WHERE ((b.checkin_date BETWEEN ? AND ?) OR (b.checkout_date BETWEEN ? AND ?) OR (? BETWEEN b.checkin_date AND b.checkout_date)) AND b.status IN ('Confirmed','Pending') GROUP BY b.hostel_id) AS booking_summary ON h.hostel_id = booking_summary.hostel_id WHERE h.hostel_id=? AND (h.pax - COALESCE(booking_summary.booked_beds, 0)) >= ?";
				ps = con.prepareStatement(sql);
				ps.setDate(1, java.sql.Date.valueOf(cin));
				ps.setDate(2, java.sql.Date.valueOf(cout));
				ps.setDate(3, java.sql.Date.valueOf(cin));
				ps.setDate(4, java.sql.Date.valueOf(cout));
				ps.setDate(5, java.sql.Date.valueOf(cin));
				ps.setInt(6, hid);
				ps.setInt(7, pax);
				
				rs = ps.executeQuery();
				if(!rs.isBeforeFirst()){
					out.println("<script type='text/javascript'>");
					out.println("alert"+"('Not available');");
					out.println("var newLocation = 'myBooking.jsp';");
					out.println("window.location = newLocation;");
					out.println("</script>");
				}
				else {
					try {
						con = ConnectionManager.getConnection();
						ps = con.prepareStatement("UPDATE booking SET checkin_date=?, checkout_date=?, pax=?, price=? WHERE booking_id=?");
						ps.setDate(1, java.sql.Date.valueOf(cin));
						ps.setDate(2, java.sql.Date.valueOf(cout));
						ps.setInt(3, pax);
						ps.setDouble(4, totalPrice);
						ps.setInt(5, bid);
						
						ps.executeUpdate();
						
						con.close();
						out.println("<script type='text/javascript'>");
						out.println("alert"+"('Update Successfully');");
						out.println("var newLocation = 'myBooking.jsp';");
						out.println("window.location = newLocation;");
						out.println("</script>");
					}
					catch(Exception e){
						out.println("<script type='text/javascript'>");
						out.println("alert"+"('" + e + "');");
						out.println("var newLocation = 'myBooking.jsp';");
						out.println("window.location = newLocation;");
						out.println("</script>");
					}
				}
				con.close();
			}
			catch(Exception e){
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('" + e + "');");
				out.println("var newLocation = 'myBooking.jsp';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
		}
	}

}
