package Controller;

import Dao.RoommatePostDao;
import Model.RoommatePost;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class RoommatePostController {
    @WebServlet("/tenant/post")
    public static class RoommatePostServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            RoommatePostDao roommatePostDao = new RoommatePostDao();
            User user = (User) req.getSession().getAttribute("user");
            String description = req.getParameter("description");
            String genderRequirement = req.getParameter("genderRequirement");
            Double budget = Double.parseDouble(req.getParameter("budget"));
            String location = req.getParameter("location");
            String duration = req.getParameter("duration");
            RoommatePost roommatePost = new RoommatePost();
            roommatePost.setDescription(description);
            roommatePost.setGenderRequirement(genderRequirement);
            roommatePost.setBudget(budget);
            roommatePost.setLocation(location);
            roommatePost.setDuration(duration);
            roommatePost.setTenant(user);
            req.getSession().setAttribute("success", "Đăng bài thành công.");
            resp.sendRedirect(req.getContextPath() + "/tenant/post");
        }
    }
}
