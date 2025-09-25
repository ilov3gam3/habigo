package Controller;

import Dao.UserDao;
import Model.Constant.Role;
import Model.User;
import Util.CometChat;
import Util.Config;
import Util.Mail;
import Util.UploadImage;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class UserController {
    @WebServlet("/login")
    public static class LoginServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            User user = new UserDao().findByEmail(email);
            if (user == null) {
                req.getSession().setAttribute("error", "Tài khoản hoặc mật khẩu không đúng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            if (!BCrypt.checkpw(password, user.getPassword())) {
                req.getSession().setAttribute("error", "Tài khoản hoặc mật khẩu không đúng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            if (!user.isVerified()){
                req.getSession().setAttribute("error", "Tài khoản chưa được kích hoạt.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            if (user.isBlocked()){
                req.getSession().setAttribute("error", "Tài khoản đã bị khóa.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            req.getSession().setAttribute("user", user);
            req.getSession().setAttribute("success", "Đăng nhập thành công.");
            if (user.getRole() == Role.LANDLORD){
                resp.sendRedirect(req.getContextPath() + "/landlord/manage");
                return;
            }
            if (user.getRole() == Role.TENANT){
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
            if (user.getRole() == Role.ADMIN){
                resp.sendRedirect(req.getContextPath() + "/admin/manage");
            }
        }
    }
    @WebServlet("/register")
    public static class RegisterServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            UserDao userDao = new UserDao();
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            if (!password.equals(confirmPassword)) {
                req.getSession().setAttribute("error", "Mật khẩu không trùng khớp.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            String email = req.getParameter("email");
            if (userDao.findByEmail(email)!=null) {
                req.getSession().setAttribute("error", "Email đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            String phone = req.getParameter("phone");
            if (userDao.findByPhone(phone)!=null) {
                req.getSession().setAttribute("error", "Số điện thoại đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            String token = UUID.randomUUID().toString();
            // send mail
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            executorService.submit(() -> {
                try {
                    String url = Config.app_url + req.getContextPath() + "/verify-email?token=" + token;
                    String html = "Chúc mừng bạn đã đăng kí thành công, vui lòng nhấn vào <a href='url'>đây</a> để xác thực email của bạn.".replace("url", url);
                    Mail.send(email, "Đăng kí tài khoản", html);
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            });
            executorService.shutdown();
            // end send mail
            User user = new User();
            user.setEmail(email);
            user.setName(req.getParameter("name"));
            user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setAvatar("/assets/images/default-avatar.jpg");
            user.setPhone(phone);
            user.setToken(token);
            user.setVerified(false);
            user.setBlocked(false);
            Role role = Role.valueOf(req.getParameter("role"));
            user.setRole(role);
            userDao.save(user);
            // start register user in comet chat
            CometChat.register(user);
            // end register user in comet chat
            req.getSession().setAttribute("success", "Đăng kí thành công, vui lòng kiểm tra email.");
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
    @WebServlet("/verify-email")
    public static class VerifyServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String token = req.getParameter("token");
            User user = new UserDao().findByToken(token);
            if (user != null) {
                user.setToken(null);
                user.setVerified(true);
                new UserDao().update(user);
                req.getSession().setAttribute("success", "Xác thực tài khoản thành công.");
            } else {
                req.getSession().setAttribute("error", "Token không tồn tại hoặc không hợp lệ");
            }
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
    @WebServlet("/logout")
    public static class LogoutServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
    @WebServlet("/forgot-password")
    public static class ForgotPassword extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            User user = new UserDao().findByEmail(email);
            if (user != null) {
                String uuid = UUID.randomUUID().toString();
                user.setToken(uuid);
                new UserDao().update(user);
                // send mail
                ExecutorService executorService = Executors.newSingleThreadExecutor();
                executorService.submit(() -> {
                    try {
                        String url = Config.app_url + req.getContextPath() + "/reset-password?token=" + uuid;
                        String html = "Vui lòng nhấn vào <a href='url'>đây</a> để lấy lại mật khẩu của bạn.".replace("url", url);
                        Mail.send(email, "Lấy lại mật khẩu", html);
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                });
                executorService.shutdown();
                // end send mail
            }
            req.getSession().setAttribute("success", "Vui lòng kiểm tra email");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
    @WebServlet("/reset-password")
    public static class ResetPassword extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String token = req.getParameter("token");
            User user = new UserDao().findByToken(token);
            if (user != null) {
                String password = req.getParameter("password");
                String re_password = req.getParameter("confirmPassword");
                if (password.equals(re_password) && !password.isEmpty()) {
                    user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
                    new UserDao().update(user);
                    req.getSession().setAttribute("success", "Đặt lại mật khẩu thành công.");
                    resp.sendRedirect(req.getContextPath() + "/login");
                } else {
                    req.getSession().setAttribute("error", "Mật khẩu không khớp.");
                    resp.sendRedirect(req.getHeader("referer"));
                }
            } else {
                req.getSession().setAttribute("error", "Token không tồn tại.");
                resp.sendRedirect(req.getHeader("referer"));
            }
        }
    }
    @WebServlet("/change-password")
    public static class ChangePasswordServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String oldPassword = req.getParameter("oldPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");
            UserDao userDao = new UserDao();
            User user = (User) req.getSession().getAttribute("user");
            if (!BCrypt.checkpw(oldPassword, user.getPassword())) {
                req.getSession().setAttribute("error", "Mật khẩu cũ không đúng.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                req.getSession().setAttribute("error", "Mật khẩu không trùng khớp.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            userDao.update(user);
            req.getSession().setAttribute("success", "Đã cập nhật mật khẩu.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
    @WebServlet("/update-avatar")
    @MultipartConfig
    public static class UpdateAvatarServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            try {
                String filename = UploadImage.saveImage(req, "avatar");
                User user = (User) req.getSession().getAttribute("user");
                user.setAvatar(filename);
                new UserDao().update(user);
                req.getSession().setAttribute("user", user);
            } catch (ServletException e){
                e.printStackTrace();
                req.getSession().setAttribute("warning", "File tải lên phải là 1 ảnh");
            }
            req.getSession().setAttribute("success", "Cập nhật thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
    @WebServlet("/google/oauth")
    public static class GoogleOauthServlet extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            GoogleAuthorizationCodeFlow googleAuthorizationCodeFlow = new GoogleAuthorizationCodeFlow.Builder(
                    new NetHttpTransport(),
                    new JacksonFactory(),
                    Config.google_oauth_client_id,
                    Config.google_oauth_client_secret,
                    Arrays.asList("openid", "profile", "email")
            ).build();
            String loginUrl = googleAuthorizationCodeFlow.newAuthorizationUrl()
                    .setRedirectUri(new Config().google_oauth_redirect_uri)
                    .build();
            resp.sendRedirect(loginUrl);
        }
    }
    @WebServlet("/login-google")
    public static class LoginGoogle extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String authorizationCode = req.getParameter("code");
            UserDao userDao = new UserDao();
            GoogleTokenResponse googleTokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    new JacksonFactory(),
                    "https://oauth2.googleapis.com/token",
                    Config.google_oauth_client_id,
                    Config.google_oauth_client_secret,
                    authorizationCode,
                    new Config().google_oauth_redirect_uri
            ).execute();
            GoogleIdToken googleIdToken = googleTokenResponse.parseIdToken();
            GoogleIdToken.Payload payload = googleIdToken.getPayload();
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            String avatar = (String) payload.get("picture");
            User user = userDao.findByEmail(email);
            if (user == null) {
                user = new User();
                user.setEmail(email);
                user.setName(name);
                user.setAvatar(avatar);
                req.getSession().setAttribute("tempUser", user);
                resp.sendRedirect(req.getContextPath() + "/add-more-info");
            } else {
                req.getSession().setAttribute("user", user);
                if (user.getRole() == Role.LANDLORD){
                    resp.sendRedirect(req.getContextPath() + "/landlord/manage");
                    return;
                }
                if (user.getRole() == Role.TENANT){
                    resp.sendRedirect(req.getContextPath() + "/");
                    return;
                }
                if (user.getRole() == Role.ADMIN){
                    resp.sendRedirect(req.getContextPath() + "/admin/manage");
                }
            }
        }
    }
    @WebServlet("/add-more-info")
    public static class AddMoreInfoServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/auth/add-more-info.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            UserDao userDao = new UserDao();
            User tempUser = (User) req.getSession().getAttribute("tempUser");
            if (tempUser == null) {
                req.getSession().setAttribute("error", "Đã có lỗi xảy ra.");
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            String phone = req.getParameter("phone");
            tempUser.setPhone(phone);
            if (userDao.findByPhone(phone) != null) {
                req.getSession().setAttribute("tempUser", tempUser);
                req.getSession().setAttribute("error", "Số điện thoại đã được sử dụng");
                resp.sendRedirect(req.getContextPath() + "/add-more-info");
                return;
            }
            if (!confirmPassword.equals(password)) {
                req.getSession().setAttribute("tempUser", tempUser);
                req.getSession().setAttribute("error", "Mật khẩu không trùng khớp");
                resp.sendRedirect(req.getContextPath() + "/add-more-info");
                return;
            }
            tempUser.setVerified(true);
            tempUser.setBlocked(false);
            tempUser.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            Role role = Role.valueOf(req.getParameter("role"));
            tempUser.setRole(role);
            userDao.save(tempUser);
            // start register user in comet chat
            CometChat.register(tempUser);
            // end register user in comet chat
            req.getSession().setAttribute("user", tempUser);
            req.getSession().setAttribute("success", "Đăng nhập thành công.");
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
    /*@WebServlet("/admin/user")
    public static class AdminUserServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            List<User> users = new UserDao().getAll();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/views/admin/user.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            UserDao userDao = new UserDao();
            String email = req.getParameter("email");
            if (userDao.findByEmail(email) != null) {
                req.getSession().setAttribute("error", "Email đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                return;
            }
            String phone = req.getParameter("phone");
            if (userDao.findByPhone(phone) != null) {
                req.getSession().setAttribute("error", "Số điện thoại đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/admin/user");
                return;
            }
            String password = req.getParameter("password");
            String avatar = "/assets/img/default-avatar.jpg";
            Role role = Role.valueOf(req.getParameter("role"));
            User user = new User();
            user.setEmail(email);
            user.setPhone(phone);
            user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setAvatar(avatar);
            user.setRole(role);
            user.setVerified(true);
            user.setBlocked(false);
            userDao.save(user);
            req.getSession().setAttribute("success", "Thêm mới người dùng thành .");
            resp.sendRedirect(req.getContextPath() + "/admin/user");
        }
    }*/
    @WebServlet("/landlord/manage")
    public static class LandlordManageServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/landlord/manage.jsp").forward(req, resp);
        }
    }
    @WebServlet("/admin/manage")
    public static class AdminManageServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/admin/manage.jsp").forward(req, resp);
        }
    }
    @WebServlet("/tenant/manage")
    public static class TenantManageServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/tenant/manage.jsp").forward(req, resp);
        }
    }
    @WebServlet("/user/profile")
    public static class UserProfile extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            User user = (User) req.getSession().getAttribute("user");
            UserDao userDao = new UserDao();
            if (userDao.findByEmailExcept(email, user.getId()) != null) {
                req.getSession().setAttribute("error", "Email đã được sử dụng.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            if (userDao.findByPhoneExcept(phone, user.getId()) != null) {
                req.getSession().setAttribute("error", "Số điện thoại đã được sử dụng.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }
            user.setPhone(phone);
            user.setEmail(email);
            userDao.update(user);
            req.getSession().setAttribute("user", user);
            req.getSession().setAttribute("success", "Cập nhật thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
    @WebServlet("/admin/user")
    public static class AdminAddUserServlet extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            UserDao userDao = new UserDao();
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            if (!password.equals(confirmPassword)) {
                req.getSession().setAttribute("error", "Mật khẩu không trùng khớp.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            String email = req.getParameter("email");
            if (userDao.findByEmail(email)!=null) {
                req.getSession().setAttribute("error", "Email đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            String phone = req.getParameter("phone");
            if (userDao.findByPhone(phone)!=null) {
                req.getSession().setAttribute("error", "Số điện thoại đã được sử dụng.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            User user = new User();
            user.setEmail(email);
            user.setName(req.getParameter("name"));
            user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setAvatar("/assets/images/default-avatar.jpg");
            user.setPhone(phone);
            user.setVerified(true);
            user.setBlocked(false);
            Role role = Role.valueOf(req.getParameter("role"));
            user.setRole(role);
            userDao.save(user);
            // start register user in comet chat
            CometChat.register(user);
            // end register user in comet chat
            req.getSession().setAttribute("success", "Tạo tài khoản thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
