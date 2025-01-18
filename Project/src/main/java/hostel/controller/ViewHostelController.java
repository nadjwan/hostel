package hostel.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import hostel.dao.HostelDAO;
import hostel.model.Hostel;

/**
 * Servlet implementation class ViewHostelController
 */
public class ViewHostelController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private HostelDAO dao;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewHostelController() {
        super();
        dao = new HostelDAO();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		request.setAttribute("h", HostelDAO.getHostelById(id));
		RequestDispatcher req = request.getRequestDispatcher("viewHostel.jsp");
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
