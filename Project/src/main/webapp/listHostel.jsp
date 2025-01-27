<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<% 
    String message = (String) request.getAttribute("message");
    if (message != null) { 
%>
    <script type="text/javascript">
        alert('<%= message %>');
    </script>
<% 
    } 
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>List Hostel</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-theme-lime.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css">
<script src="https://kit.fontawesome.com/8e0546c9b9.js" crossorigin="anonymous"></script>
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
int uid = 0;
Object uidObj = session.getAttribute("uid");
if(uidObj != null){
	uid = Integer.parseInt(uidObj.toString());
}
else{
	response.sendRedirect("loginPage.jsp");
}
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
<div class="w3-container">
		<hr>
		<div class="w3-center">
			<h2>My Hostel</h2>
			<hr>
		</div>
		<div class="w3-responsive w3-card-4">
			<table class="w3-table w3-striped w3-bordered">
				<thead>
					<tr class="w3-theme">
  						<th>Hostel Name</th>
  						<th>Hostel Price</th>
  						<th>Number of pax</th>
  						<th></th>
  						<th></th>
  						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${hostels}" var="h" varStatus="hostels">
					<tr>
            			<td><c:out value="${h.name}"/></td>
            			<td><c:out value="${h.price}"/></td> 
            			<td><c:out value="${h.pax}" /></td> 
            			<td><a class="w3-button w3-green" href="ViewHostelController?id=<c:out value="${h.id}"/>">View</a></td>
            			<td><a class="w3-button w3-blue" href="UpdateHostelController?id=<c:out value="${h.id}"/>">Update</a></td>
            			<td><button class="w3-button w3-red" id="<c:out value="${h.id}"/>" onclick="confirmation(this.id)">Delete</button></td>  
        			</tr>
        			</c:forEach>
				</tbody>
			</table>
			<script>
				function confirmation(id){					  		 
		  			console.log(id);
		  			var r = confirm("Are you sure you want to delete?");
		  			if (r == true) {				 		  
			  			location.href = 'DeleteHostelController?id=' + id;
			  			alert("Hostel successfully deleted");			
		  			} else {				  
		      			return false;	
		  			}
				}
			</script>
		</div>
	</div>
</body>
</html>
