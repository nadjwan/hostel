<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="hostel.connection.ConnectionManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta charset="ISO-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Receipt</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .receipt-container {
            max-width: 600px;
            margin: auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .header, .footer {
            text-align: center;
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }
        .footer {
            border-top: 1px solid #ddd;
            border-bottom: none;
        }
        .details {
            margin: 20px 0;
        }
        .details table {
            width: 100%;
            border-collapse: collapse;
        }
        .details table, .details th, .details td {
            border: 1px solid #ddd;
        }
        .details th, .details td {
            padding: 10px;
            text-align: left;
        }
        .button-container {
            text-align: center;
            margin-top: 20px;
        }
        .button-container button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            margin: 0 10px;
        }
        .button-container button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
	<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	int uid = 0;
	Object uidObj = session.getAttribute("uid");
	if(uidObj != null){
		uid = Integer.parseInt(uidObj.toString());
	}
	else{
		response.sendRedirect("loginPage.jsp");
	}
	int bid = Integer.parseInt(request.getParameter("bid"));
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	Connection con1 = null;
	PreparedStatement ps1 = null;
	ResultSet rs1 = null;
	DecimalFormat df = new DecimalFormat("0.00");
	String bdate = "";
	String cin = "";
	String cout = "";
	String status = "";
	int pax = 0;
	int hid = 0;
	double price = 0.0;
	String name = "";
	String hname = "";
	String address = "";
	String email = "";
	String oname = "";
	try{
		con = ConnectionManager.getConnection();
		ps = con.prepareStatement("SELECT * FROM booking WHERE booking_id=?");
		ps.setInt(1, bid);
		rs = ps.executeQuery();
		if(rs.next()){
			bdate = rs.getString("booking_date");
			cin = rs.getString("checkin_date");
			cout = rs.getString("checkout_date");
			pax = rs.getInt("pax");
			price = rs.getDouble("price");
			status = rs.getString("status");
			hid = rs.getInt("hostel_id");
		}
		con.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
	try{
		con = ConnectionManager.getConnection();
		ps = con.prepareStatement("SELECT * FROM user WHERE user_id=?");
		ps.setInt(1, uid);
		rs = ps.executeQuery();
		if(rs.next()){
			name = rs.getString("name");
		}
		con.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
	try{
		con = ConnectionManager.getConnection();
		ps = con.prepareStatement("SELECT * FROM hostel WHERE hostel_id=?");
		ps.setInt(1, hid);
		rs = ps.executeQuery();
		if(rs.next()){
			hname = rs.getString("hostel_name");
			address = rs.getString("hostel_address");
			con1 = ConnectionManager.getConnection();
			ps1 = con1.prepareStatement("SELECT * FROM user WHERE user_id=?");
			ps1.setInt(1, rs.getInt("user_id"));
			rs1 = ps1.executeQuery();
			if(rs1.next()){
				email = rs1.getString("email");
				oname = rs1.getString("name");
			}
			con1.close();
		}
		con.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
	%>
    <div class="receipt-container">
        <div class="header">
            <h1>Booking Receipt</h1>
            <p>Thank you for your booking!</p>
        </div>
        <div class="details">
            <h2>Booking Details</h2>
            <table>
                <tr>
                    <th>Booking ID</th>
                    <td><%= bid %></td>
                </tr>
                <tr>
                    <th>Name</th>
                    <td><%= name %></td>
                </tr>
                <tr>
                    <th>Booking Date</th>
                    <td><%= bdate %></td>
                </tr>
                <tr>
                    <th>Check-in Date</th>
                    <td><%= cin %></td>
                </tr>
                <tr>
                    <th>Check-out Date</th>
                    <td><%= cout %></td>
                </tr>
                <tr>
                    <th>Hostel Name</th>
                    <td><%= hname %></td>
                </tr>
                <tr>
                    <th>Number of beds</th>
                    <td><%= pax %></td>
                </tr>
                <tr>
                    <th>Total Amount</th>
                    <td>RM<%= df.format(price) %></td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td><%= status %></td>
                </tr>
            </table>
        </div>
        <div class="button-container">
            <button onclick="window.print()">Print Receipt</button>
            <button onclick="window.location.href='myBooking.jsp'">Go to My Booking</button>
        </div>
        <div class="footer">
            <p><%= address %></p>
            <p>Email: <%= email %> | Name: <%= oname %></p>
        </div>
    </div>
</body>
</html>