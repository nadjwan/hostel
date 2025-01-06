<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	Connection con = null;
	PreparedStatement ps = null;
	Statement stmt = null;
	ResultSet rs = null;
	String name = "";
	int role = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Home</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-theme-blue.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css">
<script src="https://kit.fontawesome.com/8e0546c9b9.js" crossorigin="anonymous"></script>

</head>
<body>
	<div class="w3-bar w3-theme">
		
		<%
		int uid = Integer.parseInt(request.getParameter("uid"));
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
		<a href="homePage.jsp?uid=<%= uid %>" class="w3-bar-item w3-button w3-padding-16">Home</a>
		<a href="#" class="w3-bar-item w3-button w3-padding-16">My Booking</a>
		<a href="#" class="w3-bar-item w3-button w3-padding-16">Edit Booking</a>
		<a href="#" class="w3-bar-item w3-button w3-padding-16">Profile</a>
		<% if(role == 1){ %>
		<a href="addHostel.jsp?uid=<%= uid %>" class="w3-bar-item w3-button w3-padding-16">Want to be owner?</a>
		<% }else{ %>
		<a href="home.jsp?uid=<%= uid %>" class="w3-bar-item w3-button w3-padding-16">Go to Owner Page</a>
		<% } %>
		<a href="loginPage.jsp" class="w3-bar-item w3-button w3-padding-16">Logout</a>
	</div>
	
	<div class="w3-container">
		<hr>
		<div class="w3-center">
			<h2>Booking Now</h2>
			<hr>
		</div>
		<div class="w3-row-padding">
			<form action="#" method="post">
				<div class="w3-quarter">
					<label>Check In</label>
					<input class="w3-input w3-border" type="date" name="checkin" required>
				</div>
				<div class="w3-quarter">
					<label>Check Out</label>
					<input class="w3-input w3-border" type="date" name="checkout" required>
				</div>
				<div class="w3-quarter">
					<label>Guest</label>
					<input class="w3-input w3-border" type="number" name="guest" value="1" step="1">
				</div>
				<div class="w3-quarter">
					<br>
					<input class="w3-button w3-theme w3-input" type="submit" value="Search" href="addBooking.html">
				</div>
			</form>
		</div>
	</div>
	
	<div class="w3-container">
		<div class="w3-center">
			<h2>Hostel List</h2>
			<hr>
		</div>
		<div class="w3-responsive w3-card">
			<ul class="w3-ul w3-border">
				<li><h2>Ahmad Homestay</h2></li>
				<li>RM300 per night</li>
				<li>Terrace</li>
				<li>Jasin</li>
				<li>4 Guests</li>
				<li><i class="fa-regular fa-star"></i> 3.8</li>
				<li><button class="w3-button w3-theme">Check Availability</button></li>
			</ul>
			<ul class="w3-ul w3-border">
				<li><h2>Albab Hostel</h2></li>
				<li>RM50 per night</li>
				<li>Dorm</li>
				<li>Bemban</li>
				<li>1 Guest</li>
				<li><i class="fa-regular fa-star"></i> 4.3</li>
				<li><button class="w3-button w3-theme">Check Availability</button></li>
			</ul>
		</div>
		<hr>
	</div>
</body>
</html>