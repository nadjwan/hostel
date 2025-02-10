<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	DecimalFormat df = new DecimalFormat("0.00");
	String name = "";
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
                    <td><c:out value="${b.bid}" /></td>
                </tr>
                <tr>
                    <th>Name</th>
                    <td><%= name %></td>
                </tr>
                <tr>
                    <th>Booking Date</th>
                    <td><c:out value="${b.bdate}" /></td>
                </tr>
                <tr>
                    <th>Check-in Date</th>
                    <td><c:out value="${b.cin}" /></td>
                </tr>
                <tr>
                    <th>Check-out Date</th>
                    <td><c:out value="${b.cout}" /></td>
                </tr>
                <tr>
                    <th>Hostel Name</th>
                    <td><c:out value="${b.hname}" /></td>
                </tr>
                <tr>
                    <th>Number of beds</th>
                    <td><c:out value="${b.pax}" /></td>
                </tr>
                <tr>
                    <th>Total Amount</th>
                    <td>RM<c:out value="${b.price}" /></td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td><c:out value="${b.status}" /></td>
                </tr>
            </table>
        </div>
        <div class="button-container">
            <button onclick="window.print()">Print Receipt</button>
            <button onclick="window.location.href='myBooking.jsp'">Go to My Booking</button>
        </div>
        <div class="footer">
            <p><c:out value="${b.hadd}" /></p>
            <p>Email: <c:out value="${b.email}" /> | Name: <c:out value="${b.uname}" /></p>
        </div>
    </div>
</body>
</html>