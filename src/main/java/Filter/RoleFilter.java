package Filter;

import Model.Constant.Role;
import Model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/customer/*", "/restaurant/*"})
public class RoleFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Phòng hờ, nhưng AuthFilter sẽ bắt trường hợp này
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String uri = req.getRequestURI();
        Role role = user.getRole();

        // Kiểm tra role với đường dẫn
        if (uri.startsWith(req.getContextPath() + "/admin") && role != Role.ADMIN
                || uri.startsWith(req.getContextPath() + "/tenant") && role != Role.TENANT
                || uri.startsWith(req.getContextPath() + "/landlord") && role != Role.LANDLORD) {
            req.getSession().setAttribute("flash_error", "Bạn không có quyền truy cập tài nguyên này.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        filterChain.doFilter(request, response);
    }
}
