package hostel.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import hostel.dao.HostelDAO;

/**
 * Servlet implementation class ListHostelController
 */
public class ListHostelController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private HostelDAO dao;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ListHostelController() {
        super();
        dao = new HostelDAO();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int uid = Integer.parseInt(request.getParameter("uid"));
		
		request.setAttribute("hostels", HostelDAO.getAllHostel(uid));
		
		RequestDispatcher req = request.getRequestDispatcher("listHostel.jsp");
		req.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
