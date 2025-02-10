<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
String city = request.getParameter("city");
LocalDate cin = LocalDate.parse(request.getParameter("checkin"), formatter);
LocalDate cout = LocalDate.parse(request.getParameter("checkout"), formatter);
int guest = Integer.parseInt(request.getParameter("guest"));
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
	if(cin.isBefore(LocalDate.now().plusDays(2)) || cout.isBefore(cin.plusDays(1))){
		out.println("<script type='text/javascript'>");
		out.println("alert"+"('Date is invalid');");
		out.println("var newLocation = 'homePage.jsp';");
		out.println("window.location = newLocation;");
		out.println("</script>");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Search</title>
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
		<a href="UserController?action=update&uid=<%= uid %>" class="w3-bar-item w3-button w3-padding-16">Profile</a>
		<% if(role == 1){ %>
		<a href="addHostel.jsp" class="w3-bar-item w3-button w3-padding-16">Want to be owner?</a>
		<% }else{ %>
		<a href="home.jsp" class="w3-bar-item w3-button w3-padding-16">Go to Owner Page</a>
		<% } %>
		<a href="loginPage.jsp" class="w3-bar-item w3-button w3-padding-16">Logout</a>
	</div>
	
	<div class="w3-container">
		<hr>
		<div class="w3-center">
			<h2>Hostel List</h2>
			<hr>
		</div>
		<div class="w3-responsive w3-card">
			<%
				try{
					con = ConnectionManager.getConnection();
					String sql = "SELECT * FROM hostel h LEFT JOIN (SELECT b.hostel_id, SUM(b.pax) AS booked_beds FROM booking b WHERE ((b.checkin_date BETWEEN ? AND ?) OR (b.checkout_date BETWEEN ? AND ?) OR (? BETWEEN b.checkin_date AND b.checkout_date)) AND b.status IN ('Confirmed','Pending') GROUP BY b.hostel_id) AS booking_summary ON h.hostel_id = booking_summary.hostel_id WHERE LOWER(h.hostel_address) LIKE '%" + city + "%' AND (h.pax - COALESCE(booking_summary.booked_beds, 0)) >= ?";
					ps = con.prepareStatement(sql);
					ps.setDate(1, java.sql.Date.valueOf(cin));
					ps.setDate(2, java.sql.Date.valueOf(cout));
					ps.setDate(3, java.sql.Date.valueOf(cin));
					ps.setDate(4, java.sql.Date.valueOf(cout));
					ps.setDate(5, java.sql.Date.valueOf(cin));
					ps.setInt(6, guest);
					
					rs = ps.executeQuery();
					while(rs.next()){
						int hid = rs.getInt("hostel_id");
						String hname = rs.getString("hostel_name");
			%>
			<ul class="w3-ul w3-border">
				<li><h2><%= rs.getString("hostel_name") %></h2></li>
				<li>RM<%= rs.getDouble("hostel_price") %></li>
				<li><%= rs.getString("hostel_address") %></li>
				<li><%= rs.getInt("pax") %> Guests</li>
				<li><%= rs.getString("description") %></li>
				<%
				try{
					con1 = ConnectionManager.getConnection();
					String sql1 = "SELECT AVG(r.rating) AS average_rating FROM Review r JOIN Booking b ON r.booking_id = b.booking_id WHERE b.hostel_id=?";
					ps1 = con.prepareStatement(sql1);
					ps1.setInt(1, hid);
					rs1 = ps1.executeQuery();
					if(rs1.next()){
						double rating = rs1.getDouble("average_rating");
						if(rating != 0.0){
				%>
				<li><i class="fa-regular fa-star"></i> <%= rating %></li>
				<%
						}
						else{
				%>
				<li><i class="fa-regular fa-star"></i> No rating yet</li>
				<%
						}
					}
					con1.close();
				}
				catch(Exception e){
				%>
				<li><i class="fa-regular fa-star"></i> <%= e %></li>
				<%
				}
				%>
				<li>
				<form action="addBooking.jsp" method="post">
					<input type="hidden" name="hid" value="<%= hid %>">
					<input type="hidden" name="hname" value="<%= hname %>">
					<input type="hidden" name="price" value="<%= rs.getDouble("hostel_price") %>">
					<input type="hidden" name="checkin" value="<%= cin %>">
					<input type="hidden" name="checkout" value="<%= cout %>">
					<input type="hidden" name="pax" value="<%= guest %>">
					<input class="w3-button w3-theme" type="submit" value="Book Now">
				</form>
				</li>
			</ul>
			<%
					}
					con.close();
				}
			catch(Exception e){
			%>
			<ul class="w3-ul w3-border">
				<li><%= e %></li>
			</ul>
		<%
		}
		%>
		</div>
	</div>
</body>
</html>