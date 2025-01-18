<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Home</title>
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
	DecimalFormat df = new DecimalFormat("0.00");
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
	
	<div class="w3-row-padding w3-center w3-margin-top">
		<div class="w3-quarter">
			<div class="w3-card w3-container">
				<h6>Total Booking</h6>
				<%
					int totalBooking = 0;
					try{
						con = ConnectionManager.getConnection();
						
						ps = con.prepareStatement("SELECT SUM(b.pax) AS total_pax FROM hostel h JOIN booking b ON h.hostel_id = b.hostel_id WHERE h.user_id = ? AND b.status = ?");
						ps.setInt(1, uid);
						ps.setString(2, "Confirmed");
						
						rs = ps.executeQuery();
						if(rs.next()){
							totalBooking = rs.getInt("total_pax");
						}
						con.close();
					}
					catch(Exception e){
						out.print("<p>" + e + "</p>");
					}
				%>
				<p><%= totalBooking %></p>
			</div>
		</div>
		
		<div class="w3-quarter">
			<div class="w3-card w3-container">
				<h6>Total Income</h6>
				<%
					double totalIncome = 0;
					try{
						con = ConnectionManager.getConnection();
						
						ps = con.prepareStatement("SELECT SUM(b.price) AS total_price FROM hostel h JOIN booking b ON h.hostel_id = b.hostel_id WHERE h.user_id = ? AND b.status = ?");
						ps.setInt(1, uid);
						ps.setString(2, "Confirmed");
						
						rs = ps.executeQuery();
						if(rs.next()){
							totalIncome = rs.getInt("total_price");
						}
						con.close();
					}
					catch(Exception e){
						out.print("<p>" + e + "</p>");
					}
				%>
				<p>RM<%= df.format(totalIncome) %></p>
			</div>
		</div>
		
		<div class="w3-quarter">
			<div class="w3-card w3-container">
				<h6>Last Month Booking</h6>
				<%
					int monthBooking = 0;
					try{
						con = ConnectionManager.getConnection();
						
						ps = con.prepareStatement("SELECT SUM(b.pax) AS month_pax FROM hostel h JOIN booking b ON h.hostel_id = b.hostel_id WHERE h.user_id = ? AND b.status = ? AND MONTH(b.checkin_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) AND YEAR(b.checkin_date) = YEAR(CURDATE() - INTERVAL 1 MONTH)");
						ps.setInt(1, uid);
						ps.setString(2, "Confirmed");
						
						rs = ps.executeQuery();
						if(rs.next()){
							monthBooking = rs.getInt("month_pax");
						}
						con.close();
					}
					catch(Exception e){
						out.print("<p>" + e + "</p>");
					}
				%>
				<p><%= monthBooking %></p>
			</div>
		</div>
		
		<div class="w3-quarter">
			<div class="w3-card w3-container">
				<h6>Last Month Income</h6>
				<%
					double monthPrice = 0;
					try{
						con = ConnectionManager.getConnection();
						
						ps = con.prepareStatement("SELECT SUM(b.price) AS month_price FROM hostel h JOIN booking b ON h.hostel_id = b.hostel_id WHERE h.user_id = ? AND b.status = ? AND MONTH(b.checkin_date) = MONTH(CURDATE() - INTERVAL 1 MONTH) AND YEAR(b.checkin_date) = YEAR(CURDATE() - INTERVAL 1 MONTH)");
						ps.setInt(1, uid);
						ps.setString(2, "Confirmed");
						
						rs = ps.executeQuery();
						if(rs.next()){
							monthPrice = rs.getInt("month_price");
						}
						con.close();
					}
					catch(Exception e){
						out.print("<p>" + e + "</p>");
					}
				%>
				<p>RM<%= df.format(monthPrice) %></p>
			</div>
		</div>
	</div>
	<%
		int tb = 0;
		try{
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT SUM(b.booking_id) AS total FROM booking b JOIN hostel h ON b.hostel_id=h.hostel_id WHERE h.user_id=?");
			ps.setInt(1, uid);
			rs=ps.executeQuery();
			if(rs.next()){
				tb = rs.getInt("total");
			}
			con.close();
		}
		catch(Exception e){
			out.print("<p>" + e + "</p>");
		}
		if(tb > 0){
	%>
	<div class="w3-container">
		<hr>
		<div class="w3-center">
			<h2>Hostel Booking</h2>
			<hr>
		</div>
		<div class="w3-responsive w3-card-4">
			<table class="w3-table w3-striped w3-bordered">
				<thead>
					<tr class="w3-theme">
  						<th>Guest Name</th>
  						<th>Guest Email</th>
  						<th>Hostel Name</th>
  						<th>Booking Date</th>
  						<th>Check-in date</th>
  						<th>Check-out date</th>
  						<th>Number of beds</th>
  						<th>Price</th>
  						<th>Status</th>
					</tr>
				</thead>
				<tbody>
				<%
					try{
						con = ConnectionManager.getConnection();
						stmt = con.createStatement();
						String sql = "SELECT b.booking_id, b.booking_date, b.checkin_date, b.checkout_date, b.pax, b.price, b.status, u.name, u.email, h.hostel_name FROM booking b JOIN user u ON b.user_id = u.user_id JOIN hostel h ON b.hostel_id = h.hostel_id WHERE b.checkin_date > CURDATE() AND h.user_id = " + uid;
						rs = stmt.executeQuery(sql);
						while(rs.next()){
				%>
					<tr>
						<td><%= rs.getString("name") %></td>
						<td><%= rs.getString("email") %></td>
  						<td><%= rs.getString("hostel_name") %></td>
  						<td><%= rs.getString("booking_date") %></td>
  						<td><%= rs.getString("checkin_date") %></td>
  						<td><%= rs.getString("checkout_date") %></td>
  						<td><%= rs.getInt("pax") %></td>
  						<td>RM<%= df.format(rs.getDouble("price")) %></td>
  						<%
  							if(rs.getString("status").equals("Pending")){
  						%>
  						<td><a class="w3-button w3-theme" id="<%= rs.getInt("booking_id") %>" onclick="confirmation(this.id)">Confirm</a></td>
  						<%
  							}
  							else{
  						%>
  						<td><%= rs.getString("status") %></td>
  						<%
  							}
  						%>
					</tr>
				<%
						}
						con.close();
					}
					catch(Exception e){
				%>
					<tr>
						<td><%= e %></td>
					</tr>
				<%
					}
				%>
				</tbody>
			</table>
			<script>
				function confirmation(id){					  		 
		  			console.log(id);
		  			var r = confirm("Confirm the booking?");
		  			if (r == true) {				 		  
			  			location.href = 'UpdateBookingController?action=confirm&bid=' + id;
			  			alert("Booking successfully confirm");			
		  			} else {				  
		      			return false;	
		  			}
				}
			</script>
		</div>
	</div>
	<%
		}
		else{
	%>
	<div class="w3-container">
		<hr>
		<div class="w3-center">
			<h2>No Incoming Booking</h2>
			<hr>
		</div>
	</div>
	<%
		}
	%>
</body>
</html>
