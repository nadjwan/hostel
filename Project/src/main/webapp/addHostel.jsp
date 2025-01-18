<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-theme-lime.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css">
<script src="https://kit.fontawesome.com/8e0546c9b9.js" crossorigin="anonymous"></script>
<title>Add Hostel</title>
</head>
<body>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
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
	if(role == 2){
%>
	<div class="w3-bar w3-theme">
		<div class="w3-bar-item w3-padding-16">Welcome <%= name %></div>
		<a href="home.jsp" class="w3-bar-item w3-button w3-padding-16">Home</a>
		<div class="w3-dropdown-hover">
    		<button class="w3-button w3-padding-16">Hostel <i class="fa fa-caret-down"></i></button>
    		<div class="w3-dropdown-content w3-card-4 w3-bar-block">
      			<a href="addHostel.jsp" class="w3-bar-item w3-button">Add</a>
      			<a href="ListHostelController?uid=<%= uid %>" class="w3-bar-item w3-button">List</a>
    		</div>
  		</div>
  		<a href="listBooking.jsp" class="w3-bar-item w3-button w3-padding-16">Bookings</a>
  		<a href="profilePage.jsp" class="w3-bar-item w3-button w3-padding-16">Profile</a>
  		<a href="homePage.jsp" class="w3-bar-item w3-button w3-padding-16">Go to Customer Page</a>
  		<a href="LogoutServlet" class="w3-bar-item w3-button w3-padding-16">Logout</a>
	</div>
<%
	}
%>
	<div class="w3-container">
		<hr>
		<div class="w3-center">
			<h2>Add Hostel</h2>
			<hr>
		</div>
		<div class="w3-responsive">
			<form action="AddHostelController" method="post">
				<label>Hostel Name</label>
				<input class="w3-input" type="text" name="name" required>
				<br>
				<label>Hostel Address</label>
				<input class="w3-input" type="text" name="add" required>
				<br>
				<label>Hostel Price</label>
				<input class="w3-input" type="number" step="0.1" name="price" required>
				<br>
				<label>Number of pax</label>
				<input class="w3-input" type="number" step="1" name="pax" required>
				<br>
				<label>Description</label>
				<input class="w3-input" type="text" name="desc" required>
				<br>
				<input type="hidden" name="uid" value="<%= uid %>">
				<input type="hidden" name="role" value="<%= role %>">
				<input class="w3-button w3-theme" type="submit" value="Submit">
			</form>
		</div>
	</div>
	<br>
</body>
</html>