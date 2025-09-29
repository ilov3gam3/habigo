<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="Model.User"%>
<%@ page import="Dao.UserDao" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Room" %>
<%@ page import="Dao.RoomDao" %>
<%@ page import="Model.Constant.Role" %>
<!doctype html>
<html lang="vi">
<%@include file="../include/head.jsp" %>
<body>
<%@include file="../include/header.jsp" %>

<main class="flex-fill">
    <div class="container py-5">
        <%
            long userId = Long.parseLong(request.getParameter("id"));
            User profile = new UserDao().getById(userId);
            List<Room> rooms = null;
            if (profile.getRole() == Role.LANDLORD) {
                rooms = new RoomDao().getRoomsOfUser(profile);
            }
        %>
        <div class="row justify-content-center">
            <div class="card shadow-lg border-0 rounded-3">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center mb-4">
                        <img src="<%= profile.getAvatar() %>" alt="Avatar"
                             class="rounded-circle border" style="width:100px;height:100px;object-fit:cover;">
                        <div class="ms-3">
                            <h4 class="mb-0"><%= profile.getName() %></h4>
                            <span class="badge bg-primary"><%= profile.getRole() %></span>
                        </div>
                    </div>

                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">
                            <i class="bi bi-envelope"></i>
                            <strong>Email:</strong> <%= profile.getEmail() %>
                        </li>
                        <li class="list-group-item">
                            <i class="bi bi-telephone"></i>
                            <strong>Số điện thoại:</strong> <%= profile.getPhone() %>
                        </li>
                        <li class="list-group-item">
                            <i class="bi bi-check-circle"></i>
                            <strong>Xác thực:</strong>
                            <% if (profile.isVerified()) { %>
                            <span class="text-success">Đã xác thực</span>
                            <% } else { %>
                            <span class="text-danger">Chưa xác thực</span>
                            <% } %>
                        </li>
                        <li class="list-group-item">
                            <i class="bi bi-shield-lock"></i>
                            <strong>Trạng thái:</strong>
                            <% if (profile.isBlocked()) { %>
                            <span class="text-danger">Bị khóa</span>
                            <% } else { %>
                            <span class="text-success">Hoạt động</span>
                            <% } %>
                        </li>
                        <a href="<%=request.getContextPath()%>/views/user/chat.jsp?chatWith=<%=profile.getId()%>">
                            <button type="button" class="btn btn-outline-primary">Nhắn tin với người này</button>
                        </a>
                    </ul>
                </div>
            </div>
        </div>

        <% if (rooms != null && !rooms.isEmpty()) { %>
        <!-- Danh sách phòng của landlord -->
        <section class="mb-5 mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>Phòng cho thuê của chủ nhà</h3>
                <a href="#" class="btn btn-primary btn-sm">Xem tất cả</a>
            </div>
            <div class="row">
                <% for (Room r : rooms) { %>
                <div class="col-md-3 mb-4 d-flex">
                    <div class="card shadow-sm h-100 w-100">
                        <!-- Ảnh cùng chiều cao -->
                        <img src="<%= r.getImages().iterator().hasNext() ? request.getContextPath() + "/" + r.getImages().iterator().next() : "https://via.placeholder.com/300x200" %>"
                             class="card-img-top"
                             alt="Room image"
                             style="height:200px; object-fit:cover;">

                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title" style="font-size:16px; font-weight:600; min-height:45px;">
                                <%= r.getName() %>
                            </h5>

                            <!-- Description rút gọn -->
                            <p class="card-text mb-3"
                               style="display:-webkit-box; -webkit-line-clamp:3; -webkit-box-orient:vertical; overflow:hidden; text-overflow:ellipsis; min-height:65px;">
                                <%= r.getDescription() %>
                            </p>

                            <!-- Nút luôn dính cuối -->
                            <div class="mt-auto">
                                <a href="<%=request.getContextPath()%>/room-detail?id=<%= r.getId() %>"
                                   class="btn btn-sm btn-primary">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </section>
        <% } %>
    </div>
</main>

<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />
</body>
</html>
