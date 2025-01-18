package hostel.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import hostel.dao.HostelDAO;
import hostel.model.Hostel;

/**
 * Servlet implementation class DeleteHostelController
 */
public class DeleteHostelController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private HostelDAO dao;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteHostelController() {
        super();
        dao = new HostelDAO();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
