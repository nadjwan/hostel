<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
			<h2>Booking Now</h2>
			<hr>
		</div>
		<form action="search.jsp" method="post">
			<div class="w3-row-padding">
				<div class="w3-quarter">
					<label>City</label>
					<input class="w3-input w3-border" type="text" name="city" required>
				</div>
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
					<input class="w3-input w3-border" type="number" name="guest" value="1" step="1" required>
				</div>
			</div>
			<br>
			<div class="w3-row-padding">
				<div class="w3-col" style="width:37.5%"><p class="w3-center"></p></div>
				<div class="w3-col" style="width:25%"><input class="w3-button w3-theme w3-input" type="submit" value="Search" href="addBooking.html"></div>
				<div class="w3-col" style="width:37.5%"><p class="w3-center"></p></div>
			</div>
		</form>
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
			
			stmt = con.createStatement();
			String sql = "SELECT * FROM hostel WHERE user_id != " + uid;
			
			rs = stmt.executeQuery(sql);
			while(rs.next()){
				int hid = rs.getInt("hostel_id");
				String hname = rs.getString("hostel_name");
				double price = rs.getDouble("hostel_price");
		%>
			<ul class="w3-ul w3-border">
				<li><h2><%= rs.getString("hostel_name") %></h2></li>
				<li>RM<%= rs.getDouble("hostel_price") %></li>
				<li><%= rs.getString("hostel_address") %></li>
				<li><%= rs.getInt("pax") %> Guests</li>
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
				<li><%= rs.getString("description") %></li>
				<li><button onclick="document.getElementById('id<%= hid %>').style.display='block'" class="w3-button w3-theme">Check Availability</button></li>
			</ul>
			<div id="id<%= hid %>" class="w3-modal">
				<div class="w3-modal-content w3-card-4 w3-animate-top">
					<header class="w3-container w3-theme">
						<span onclick="document.getElementById('id<%= hid %>').style.display='none'" class="w3-button w3-display-topright">x</span>
						<h4><%= rs.getString("hostel_name") %></h4>
						<h5>Fill in the form</h5>
					</header>
					<div class="w3-container w3-padding">
						<form action="addBooking.jsp" method="post">
							<input type="hidden" name="hid" value="<%= hid %>">
							<input type="hidden" name="hname" value="<%= hname %>">
							<input type="hidden" name="price" value="<%= price %>">
							<label>Check-In Date</label>
							<input class="w3-input w3-border" type="date" name="checkin" required>
							<label>Check-Out Date</label>
							<input class="w3-input w3-border" type="date" name="checkout" required>
							<label>Guests</label>
							<input class="w3-input w3-border" type="number" step="1" name="pax" required>
							<br>
							<input class="w3-button w3-theme" type="submit" value="Submit">
						</form>
					</div>
				</div>
			</div>
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
		<hr>
	</div>
</body>
</html>
