<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
	Connection con1 = null;
	PreparedStatement ps1 = null;
	ResultSet rs1 = null;
	Connection con = null;
	PreparedStatement ps = null;
	Statement stmt = null;
	ResultSet rs = null;
	String name = "";
	int role = 0;
	int uid = 0;
	Object uidObj = session.getAttribute("uid");
	if(uidObj != null){
		uid = Integer.parseInt(uidObj.toString());
	}
	else{
		response.sendRedirect("loginPage.jsp");
	}
	
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	LocalDate today = LocalDate.now();
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
		out.println("var newLocation = 'homePage.jsp';");
		out.println("window.location = newLocation;");
		out.println("</script>");
	}
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
			out.println("var newLocation = 'homePage.jsp';");
			out.println("window.location = newLocation;");
			out.println("</script>");
		}
		con.close();
	}
	catch(Exception e){
		out.println("<script type='text/javascript'>");
		out.println("alert"+"('" + e + "');");
		out.println("var newLocation = 'homePage.jsp';");
		out.println("window.location = newLocation;");
		out.println("</script>");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Booking</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-theme-blue.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css">
<link rel="stylesheet" href="gradient.css">
<script src="https://kit.fontawesome.com/8e0546c9b9.js" crossorigin="anonymous"></script>
</head>
<body>
	<div class="w3-bar w3-theme-gradient">
		
		<%
		//int uid = Integer.parseInt(request.getParameter("uid"));
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT * FROM user WHERE user_id=?");
			ps.setInt(1, uid);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				name = rs.getString("name");
				role = rs.getInt("role");
			}
			con.close();
		}
		catch(Exception e) {
			name = e.toString();
		}
		%>
		<div class="w3-rest w3-bar-item w3-padding-16">Welcome <%= name %></div>
		<a href="homePage.jsp" class="w3-bar-item w3-button w3-padding-16">Home</a>
		<a href="myBooking.jsp" class="w3-bar-item w3-button w3-padding-16">My Booking</a>
		<a href="profilePage.jsp" class="w3-bar-item w3-button w3-padding-16">Profile</a>
		<% if(role == 1){ %>
		<a href="addHostel.jsp" class="w3-bar-item w3-button w3-padding-16">Want to be owner?</a>
		<% }else{ %>
		<a href="home.jsp" class="w3-bar-item w3-button w3-padding-16">Go to Owner Page</a>
		<% } %>
		<a href="LogoutServlet" class="w3-bar-item w3-button w3-padding-16">Logout</a>
	</div>
	
	<div class="w3-container">
		<hr>
		<div class="w3-center">
			<h2><%= request.getParameter("hname") %></h2>
			<hr>
		</div>
		<div class="w3-responsive">
			<form action="AddBookingController" method="post">
				<input type="hidden" name="today" value="<%= formatter.format(today) %>">
				<label>Check-In Date</label>
				<input class="w3-input" type="text" name="cin" value="<%= formatter.format(cin) %>" readonly>
				<br>
				<label>Check-Out Date</label>
				<input class="w3-input" type="text" name="cout" value="<%= formatter.format(cout) %>" readonly>
				<br>
				<label>Total Guests</label>
				<input class="w3-input" type="number" name="pax" value="<%= pax %>" readonly>
				<br>
				<label>Total Price</label>
				<input class="w3-input" type="number" name="price" value="<%= totalPrice %>" readonly>
				<br>
				<input type="hidden" name="uid" value="<%= uid %>">
				<input type="hidden" name="hid" value="<%= hid %>">
				<input class="w3-button w3-theme" type="submit" value="Submit">
			</form>
		</div>
	</div>
	<%
		double rating = 0.0;
		try{
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT AVG(r.rating) AS average_rating FROM Review r JOIN Booking b ON r.booking_id = b.booking_id WHERE b.hostel_id=?");
			ps.setInt(1, hid);
			
			rs = ps.executeQuery();
			if(rs.next()){
				rating = rs.getDouble("average_rating");
			}
			con.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		if(rating != 0.0){
	%>
	<div class="w3-container">
		<hr>
		<div class="w3-center">
			<h2>Review</h2>
			<hr>
		</div>
		<div class="w3-responsive w3-card">
			<%
				try{
					con = ConnectionManager.getConnection();
					
					String sql = "SELECT r.rating, r.comment, r.booking_id FROM Review r JOIN Booking b ON r.booking_id = b.booking_id WHERE b.hostel_id=?";
					ps = con.prepareStatement(sql);
					ps.setInt(1, hid);
					rs = ps.executeQuery();
					while(rs.next()){
						con1 = ConnectionManager.getConnection();
						String sql1 = "SELECT u.name FROM booking b JOIN user u ON b.user_id=u.user_id WHERE b.booking_id=?";
						ps1 = con1.prepareStatement(sql1);
						ps1.setInt(1, rs.getInt("booking_id"));
						rs1 = ps1.executeQuery();
						while(rs1.next()){
			%>
			<ul class="w3-ul w3-border">
				<li><h3><%= rs1.getString("name") %></h3></li>
				<li><%= rs.getInt("rating") %></li>
				<li><%= rs.getString("comment") %></li>
			</ul>
			<%
						}
						con1.close();
					}
					con.close();
				}
				catch(Exception e){
			%>
			<p><%= e %></p>
			<%
				}
			%>
		</div>
		<hr>
	</div>
	<%
		}
	%>
</body>
</html>