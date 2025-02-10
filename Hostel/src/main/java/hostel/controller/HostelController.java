package hostel.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import hostel.connection.ConnectionManager;
import hostel.dao.HostelDAO;
import hostel.model.Hostel;

/**
 * Servlet implementation class HostelController
 */
public class HostelController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Connection con = null;
	static PreparedStatement ps = null;
	static ResultSet rs = null;
	private HostelDAO dao;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public HostelController() {
        super();
        dao = new HostelDAO();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		if(action.equals("list")) {
			int uid = Integer.parseInt(request.getParameter("uid"));
			request.setAttribute("hostels", HostelDAO.getAllHostel(uid));
			RequestDispatcher req = request.getRequestDispatcher("listHostel.jsp");
			req.forward(request, response);
		}
		else if(action.equals("view")) {
			int id = Integer.parseInt(request.getParameter("id"));
			request.setAttribute("h", HostelDAO.getHostelById(id));
			RequestDispatcher req = request.getRequestDispatcher("viewHostel.jsp");
			req.forward(request, response);
		}
		else if(action.equals("update")) {
			int id = Integer.parseInt(request.getParameter("id"));
			request.setAttribute("h", HostelDAO.getHostelById(id));
			RequestDispatcher req = request.getRequestDispatcher("updateHostel.jsp");
			req.forward(request, response);
		}
		else if(action.equals("delete")) {
			HttpSession session = request.getSession(false);
			if(session != null) {
				Object obj = session.getAttribute("uid");
				if (obj != null) {
					int uid = Integer.parseInt(obj.toString());
					int id = Integer.parseInt(request.getParameter("id"));
					dao.deleteHostel(id);
					request.setAttribute("hostels", HostelDAO.getAllHostel(uid));
					RequestDispatcher req = request.getRequestDispatcher("listHostel.jsp");
					req.forward(request, response);
				}
				else {
					response.sendRedirect("loginPage.jsp");
				}
			}
			else {
				response.sendRedirect("loginPage.jsp");
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		Hostel h = new Hostel();
		h.setName(request.getParameter("name"));
		h.setAddress(request.getParameter("add"));
		h.setPrice(Double.parseDouble(request.getParameter("price")));
		h.setPax(Integer.parseInt(request.getParameter("pax")));
		h.setDesc(request.getParameter("desc"));
		h.setUserId(Integer.parseInt(request.getParameter("uid")));
		if(request.getParameter("id") != null) {
			h.setId(Integer.parseInt(request.getParameter("id")));
			dao.updateHostel(h);
			request.setAttribute("message", "Update successfully");
			request.setAttribute("hostels", HostelDAO.getAllHostel(h.getUserId()));
			
			RequestDispatcher req = request.getRequestDispatcher("listHostel.jsp");
			req.forward(request, response);
			
		}
		else {
			int id = Integer.parseInt(request.getParameter("uid"));
			int role = Integer.parseInt(request.getParameter("role"));
			
			if(role == 1) {
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
			dao.addHostel(h);
			request.setAttribute("message", "Hostel added successfully");
			request.setAttribute("hostels", HostelDAO.getAllHostel(h.getUserId()));
			
			RequestDispatcher req = request.getRequestDispatcher("listHostel.jsp");
			req.forward(request, response);
		}
	}

}
