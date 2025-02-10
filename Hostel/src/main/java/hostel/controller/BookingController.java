package hostel.controller;

import jakarta.servlet.RequestDispatcher;
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
import java.time.LocalDate;

import hostel.connection.ConnectionManager;
import hostel.dao.BookingDAO;
import hostel.model.Booking;

/**
 * Servlet implementation class BookingController
 */
public class BookingController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Connection con = null;
	static PreparedStatement ps = null;
	static ResultSet rs = null;
	BookingDAO dao;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingController() {
        super();
        dao = new BookingDAO();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		//int bid = Integer.parseInt(request.getParameter("bid"));
		if(action.equals("cancel")) {
			int bid = Integer.parseInt(request.getParameter("bid"));
			dao.cancelBooking(bid);
			response.sendRedirect("myBooking.jsp");
		}
		else if(action.equals("receipt")) {
			int bid = Integer.parseInt(request.getParameter("bid"));
			request.setAttribute("b", BookingDAO.getBookingById(bid));
			RequestDispatcher req = request.getRequestDispatcher("receipt.jsp");
			req.forward(request, response);
		}
		else if(action.equals("confirm")) {
			int bid = Integer.parseInt(request.getParameter("bid"));
			dao.confirmBooking(bid);
			response.sendRedirect("home.jsp");
		}
		else if(action.equals("list")) {
			int uid = Integer.parseInt(request.getParameter("uid"));
			request.setAttribute("bookings", BookingDAO.listBooking(uid));
			RequestDispatcher req = request.getRequestDispatcher("listBooking.jsp");
			req.forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		if(request.getParameter("bid") != null) {
			LocalDate today = LocalDate.now();
			int bid = Integer.parseInt(request.getParameter("bid"));
			int hid = Integer.parseInt(request.getParameter("hid"));
			double price = Double.parseDouble(request.getParameter("price"));
			LocalDate cin = LocalDate.parse(request.getParameter("checkin"));
			LocalDate cout = LocalDate.parse(request.getParameter("checkout"));
			int pax = Integer.parseInt(request.getParameter("pax"));
			
			int day = Integer.parseInt(request.getParameter("checkout").substring(8)) - Integer.parseInt(request.getParameter("checkin").substring(8));
			double totalPrice = price * day * pax;
			
			Booking b = new Booking();
			b.setBid(bid);
			b.setCin(cin.toString());
			b.setCout(cout.toString());
			b.setPax(pax);
			b.setPrice(totalPrice);
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
						if(dao.updateBooking(b)) {
							out.println("<script type='text/javascript'>");
							out.println("alert"+"('Update successfully');");
							out.println("var newLocation = 'myBooking.jsp';");
							out.println("window.location = newLocation;");
							out.println("</script>");
						}
						else {
							out.println("<script type='text/javascript'>");
							out.println("alert"+"('Something went wrong!');");
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
		else {
			Booking b = new Booking();
			b.setBdate(request.getParameter("today"));
			b.setCin(request.getParameter("cin"));
			b.setCout(request.getParameter("cout"));
			b.setPax(Integer.parseInt(request.getParameter("pax")));
			b.setPrice(Double.parseDouble(request.getParameter("price")));
			b.setUid(Integer.parseInt(request.getParameter("uid")));
			b.setHid(Integer.parseInt(request.getParameter("hid")));
			if(dao.addBooking(b)) {
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('Booking successfully');");
				out.println("var newLocation = 'homePage.jsp';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
			else {
				out.println("<script type='text/javascript'>");
				out.println("alert"+"('Something went wrong!');");
				out.println("var newLocation = 'loginPage.jsp';");
				out.println("window.location = newLocation;");
				out.println("</script>");
			}
		}
	}

}
