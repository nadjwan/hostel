package hostel.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import hostel.dao.ReviewDAO;
import hostel.model.Review;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet implementation class ReviewController
 */
public class ReviewController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ReviewDAO dao;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReviewController() {
        super();
        dao = new ReviewDAO();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		int rid = Integer.parseInt(request.getParameter("rid"));
		if(action.equals("delete")) {
			int hid = Integer.parseInt(request.getParameter("hid"));
			dao.deleteReview(rid);
			RequestDispatcher req = request.getRequestDispatcher("HostelController?action=view&id=" + hid);
			req.forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		Review r = new Review();
		r.setRating(Integer.parseInt(request.getParameter("rating")));
		r.setComment(request.getParameter("review"));
		r.setBid(Integer.parseInt(request.getParameter("bid")));
		dao.addReview(r);
		out.println("<script type='text/javascript'>");
		out.println("alert"+"('Review has been added!');");
		out.println("var newLocation = 'myBooking.jsp';");
		out.println("window.location = newLocation;");
		out.println("</script>");
	}

}
