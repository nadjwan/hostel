<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
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
<title>Profile</title>
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
		try {
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT role FROM user WHERE user_id=?");
			ps.setInt(1, uid);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				role = rs.getInt("role");
			}
			con.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		%>
		<div class="w3-rest w3-bar-item w3-padding-16">Welcome <c:out value="${u.name}" /></div>
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
			<h2>Profile</h2>
			<hr>
		</div>
		<div class="w3-responsive">
			<form action="UserController" method="post">
				<input type="hidden" name="uid" value="<c:out value="${u.uid}" />">
				<label>Name</label>
				<input class="w3-input" type="text" name="name" value="<c:out value="${u.name}" />" required>
				<br>
				<label>Email</label>
				<input class="w3-input" type="text" name="email" value="<c:out value="${u.email}" />" required>
				<br>
				<label>Password</label>
				<input class="w3-input" type="password" name="pass" value="<c:out value="${u.password}" />" required>
				<br>
				<label>Confirmation Password</label>
				<input class="w3-input" type="password" name="password" value="<c:out value="${u.password}" />" required>
				<br>
				<input class="w3-button w3-theme" type="submit" value="Submit">
			</form>
			<br>
			<a class="w3-button w3-red" id="<%= uid %>" onclick="confirmation(this.id)">Delete Account</a>
			<script>
				function confirmation(id){					  		 
		  			console.log(id);
		  			var r = confirm("Are you sure want to delete this account?");
		  			if (r == true) {				 		  
			  			location.href = 'UserController?action=delete&uid=' + id;
		  			} else {
		      			return false;	
		  			}
				}
			</script>
		</div>
		<br>
	</div>
</body>
</html>