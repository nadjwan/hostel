<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>View Hostel</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-theme-lime.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css">
<script src="https://kit.fontawesome.com/8e0546c9b9.js" crossorigin="anonymous"></script>
</head>
<body>
<%
Connection con = null;
PreparedStatement ps = null;
Statement stmt = null;
ResultSet rs = null;
String name = "";
	int uid = Integer.parseInt(request.getParameter("uid"));
%>
	<div class="w3-bar w3-theme">
	<%
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT * FROM user WHERE user_id=?");
			ps.setInt(1, uid);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				name = rs.getString("name");
			}
			con.close();
		}
		catch(Exception e) {
			name = e.toString();
		}
		%>
		<div class="w3-bar-item w3-padding-16">Welcome <%= name %></div>
		<a href="home.jsp?uid=<%= uid %>" class="w3-bar-item w3-button w3-padding-16">Home</a>
		<div class="w3-dropdown-hover">
    		<button class="w3-button w3-padding-16">Hostel <i class="fa fa-caret-down"></i></button>
    		<div class="w3-dropdown-content w3-card-4 w3-bar-block">
      			<a href="addHostel.jsp?uid=<%= uid %>" class="w3-bar-item w3-button">Add</a>
      			<a href="ListHostelController?uid=<%= uid %>" class="w3-bar-item w3-button">List</a>
    		</div>
  		</div>
  		<a href="#" class="w3-bar-item w3-button w3-padding-16">Bookings</a>
  		<a href="#" class="w3-bar-item w3-button w3-padding-16">Review</a>
  		<a href="#" class="w3-bar-item w3-button w3-padding-16">Profile</a>
  		<a href="homePage.jsp?uid=<%= uid %>" class="w3-bar-item w3-button w3-padding-16">Go to Customer Page</a>
  		<a href="loginPage.jsp" class="w3-bar-item w3-button w3-padding-16">Logout</a>
	</div>
<div class="w3-container">
		<hr>
		<div class="w3-center">
			<h2>View Hostel</h2>
			<hr>
		</div>
		<div class="w3-responsive w3-card-4">
			<table class="w3-table w3-striped w3-bordered">
				<tbody>
					<tr>
						<td style="width: 150px">Hostel ID</td>
						<td style="width: 3px">:</td>
						<td><c:out value="${h.id}" /></td>
					</tr>
					<tr>
						<td>Hostel Name</td>
						<td>:</td>
						<td><c:out value="${h.name}" /></td>
					</tr>
					<tr>
						<td>Hostel Address</td>
						<td>:</td>
						<td><c:out value="${h.address}" /></td>
					</tr>
					<tr>
						<td>Hostel Price</td>
						<td>:</td>
						<td><c:out value="${h.price}" /></td>
					</tr>
					<tr>
						<td>Number of pax</td>
						<td>:</td>
						<td><c:out value="${h.pax}" /></td>
					</tr>
					<tr>
						<td>Description</td>
						<td>:</td>
						<td><c:out value="${h.desc}" /></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>