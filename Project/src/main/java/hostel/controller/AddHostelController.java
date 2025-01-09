package hostel.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import hostel.connection.ConnectionManager;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;


import hostel.dao.HostelDAO;
import hostel.model.Hostel;

/**
 * Servlet implementation class AddHostelController
 */
public class AddHostelController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private HostelDAO dao;
	static Connection con = null;
	static PreparedStatement ps = null;
	static Statement stmt = null;
	static ResultSet rs = null;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddHostelController() {
        super();
        dao = new HostelDAO();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("uid"));
		
		if(id == 1) {
			try {			
				//call getConnection() method
				con = ConnectionManager.getConnection();

				//3. create statement
				ps = con.prepareStatement("UPDATE user SET role=? WHERE user_id=?");
				ps.setInt(1, 2);
				ps.setInt(2, id);

				//4. execute query
				ps.executeUpdate();

				//5. close connection
				con.close();

			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		Hostel h = new Hostel();
		h.setName(request.getParameter("name"));
		h.setAddress(request.getParameter("add"));
		h.setPrice(Double.parseDouble(request.getParameter("price")));
		h.setPax(Integer.parseInt(request.getParameter("pax")));
		h.setDesc(request.getParameter("desc"));
		h.setUserId(Integer.parseInt(request.getParameter("uid")));
		
		dao.addHostel(h);
		
		request.setAttribute("hostels", HostelDAO.getAllHostel(h.getUserId()));
		
		RequestDispatcher req = request.getRequestDispatcher("listHostel.jsp");
		req.forward(request, response);
	}

}
