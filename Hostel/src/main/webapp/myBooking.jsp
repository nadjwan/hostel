<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
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
	LocalDate today = LocalDate.now();
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
	double hprice = 0.0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>My Booking</title>
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
	<%
		int cbo = 0;
		try{
			con = ConnectionManager.getConnection();
			
			ps = con.prepareStatement("SELECT COUNT(booking_id) AS count FROM booking WHERE user_id=?");
			ps.setInt(1, uid);
			rs = ps.executeQuery();
			if(rs.next()){
				cbo = rs.getInt("count");
			}
			con.close();
		}
		catch(Exception e){
			out.print("<p>" + e + "</p>");
		}
		if(cbo > 0){
	%>
	<div class="w3-container">
  		<hr>
  		<div class="w3-center">
    		<h2>My Booking</h2>
    		<hr>
  		</div>
		<div class="w3-responsive w3-card-4">
			<table class="w3-table w3-striped w3-bordered">
				<thead>
					<tr class="w3-theme">
  						<th>Hostel Name</th>
  						<th>Check-in date</th>
  						<th>Check-out date</th>
  						<th>Pax</th>
  						<th>Price (RM)</th>
  						<th>Status</th>
  						<th></th>
  						<th></th>
					</tr>
				</thead>
				 <tbody>
                    <%
                        try {
                            con = ConnectionManager.getConnection();
                            String sql = "SELECT * FROM booking WHERE user_id=?";
                            ps = con.prepareStatement(sql);
                            ps.setInt(1, uid);
                            rs = ps.executeQuery();
                            while(rs.next()){
                                int bid = rs.getInt("booking_id");
                                int hid = rs.getInt("hostel_id");
                                String status = rs.getString("status");
                                LocalDate cin = rs.getDate("checkin_date").toLocalDate();
                    %>
                    <tr>
                    <%
                                con1 = ConnectionManager.getConnection();
                                String sql1 = "SELECT * FROM hostel WHERE hostel_id=?";
                                ps1 = con1.prepareStatement(sql1);
                                ps1.setInt(1, hid);
                                rs1 = ps1.executeQuery();
                                while(rs1.next()){
                                    hprice = rs1.getDouble("hostel_price");
                    %>
                        <td><%= rs1.getString("hostel_name") %></td>
                    <%
                                }
                    %>
                        <td><%= cin %></td>
                        <td><%= rs.getDate("checkout_date") %></td>
                        <td><%= rs.getInt("pax") %></td>
                        <td><%= rs.getDouble("price") %></td>
                        <td><%= status %></td>
                        <%
                            if (!"cancel".equalsIgnoreCase(status)) {
                                if(cin.isAfter(today) && status.equals("Pending")){
                        %>
                        <td><button onclick="document.getElementById('id0<%= bid %>').style.display='block'" class="w3-button w3-theme">Edit</button></td>
                        <div id="id0<%= bid %>" class="w3-modal">
                            <div class="w3-modal-content w3-card-4 w3-animate-top">
                                <header class="w3-container w3-theme">
                                    <span onclick="document.getElementById('id0<%= bid %>').style.display='none'" class="w3-button w3-display-topright">x</span>
                                    <h4>Booking ID: <%= bid %></h4>
                                    <h5>Fill in the form</h5>
                                </header>
                                <div class="w3-container w3-padding">
                                    <form action="BookingController" method="post">
                                        <input type="hidden" name="bid" value="<%= rs.getInt("booking_id") %>">
                                        <input type="hidden" name="hid" value="<%= hid %>">
                                        <input type="hidden" name="price" value="<%= hprice %>">
                                        <label>Check-In Date</label>
                                        <input class="w3-input w3-border" type="date" name="checkin" value="<%= rs.getString("checkin_date") %>" required>
                                        <label>Check-Out Date</label>
                                        <input class="w3-input w3-border" type="date" name="checkout" value="<%= rs.getString("checkout_date") %>" required>
                                        <label>Guests</label>
                                        <input class="w3-input w3-border" type="number" step="1" name="pax" value="<%= rs.getInt("pax") %>" required>
                                        <br>
                                        <input class="w3-button w3-theme" type="submit" value="Submit">
                                    </form>
                                </div>
                            </div>
                        </div>
                        <td><button class="w3-button w3-red" id="<%= bid %>" onclick="confirmation(this.id)">Cancel</button></td>
                        <% } else { %>
                        <td><a class="w3-button w3-blue" href="BookingController?action=receipt&bid=<%= rs.getInt("booking_id") %>">Receipt</a></td>
                        <%
    // Add this logic inside the main while loop where you iterate through bookings
    boolean hasReview = false;
    String reviewText = "";
    int reviewId = 0;

    try {
        String reviewSql = "SELECT * FROM review WHERE booking_id=?";
        PreparedStatement reviewPs = con.prepareStatement(reviewSql);
        reviewPs.setInt(1, bid);
        ResultSet reviewRs = reviewPs.executeQuery();
        if (reviewRs.next()) {
            hasReview = true;
            reviewText = reviewRs.getString("comment");
            reviewId = reviewRs.getInt("review_id");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
                        <td>
    <% if (hasReview) { %>
    <!-- Button to View Review -->
    <button onclick="document.getElementById('viewReview<%= reviewId %>').style.display='block'" class="w3-button w3-blue">Review</button>

    <!-- Modal to View Review -->
    <div id="viewReview<%= reviewId %>" class="w3-modal">
        <div class="w3-modal-content w3-card-4 w3-animate-top">
            <header class="w3-container w3-theme">
                <span onclick="document.getElementById('viewReview<%= reviewId %>').style.display='none'" class="w3-button w3-display-topright">x</span>
                <h4>Review</h4>
            </header>
            <div class="w3-container w3-padding">
                <p><strong>Your Review:</strong></p>
                <p><%= reviewText %></p>
            </div>
        </div>
    </div>
    <% } else { %>
    <!-- Button to Add Review -->
    <button onclick="document.getElementById('addReview<%= bid %>').style.display='block'" class="w3-button w3-blue">Review</button>

    <!-- Modal to Add Review -->
    <div id="addReview<%= bid %>" class="w3-modal">
        <div class="w3-modal-content w3-card-4 w3-animate-top">
            <header class="w3-container w3-theme">
                <span onclick="document.getElementById('addReview<%= bid %>').style.display='none'" class="w3-button w3-display-topright">x</span>
                <h4>Add Review</h4>
            </header>
            <div class="w3-container w3-padding">
                <form action="ReviewController" method="post">
                    <input type="hidden" name="bid" value="<%= bid %>">
                    <label for="rating">Rating (1-5)</label>
                    <input class="w3-input w3-border" type="number" name="rating" min="1" max="5" required>
                    <label for="review">Your Review</label>
                    <textarea class="w3-input w3-border" name="review" rows="4" required></textarea>
                    <br>
                    <input class="w3-button w3-theme" type="submit" value="Submit">
                </form>
            </div>
        </div>
    </div>
    <% } %>
</td>
                        <% } %>
                        <% } else { %>
                        <td></td>
                        <td></td>
                        <% } %>
                    </tr>
                    <%
                            }
                        } catch(Exception e) {
                    %>
                    <tr><td colspan="8"><%= e %></td></tr>
                    <%
                        }
                    %>
                </tbody>
			</table>
			<script>
				function confirmation(id){					  		 
		  			console.log(id);
		  			var r = confirm("Are you sure you want to delete?");
		  			if (r == true) {				 		  
			  			location.href = 'BookingController?action=cancel&bid=' + id;
			  			alert("Booking successfully cancel");			
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
			<h2>Please make a reservation first</h2>
			<hr>
		</div>
	</div>
	<%
		}
	%>
</body>
</html>