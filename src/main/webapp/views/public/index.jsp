<%@ page import="java.util.List" %>
<%@ page import="Model.Room" %>
<%@ page import="Dao.RoomDao" %>
<%@ page import="Model.Utility" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="Model.RoommatePost" %>
<%@ page import="Dao.RoommatePostDao" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<%@include file="../include/head.jsp" %>
<body>
<%@include file="../include/header.jsp" %>

<!-- Main content -->
<main class="flex-fill">
    <div class="container py-5">
        <!-- Banner -->
        <div class="mb-5 text-center">
            <img src="<%=request.getContextPath()%>/assets/images/home-page-banner.png"
                 alt="Banner"
                 class="img-fluid rounded shadow"/>
        </div>


        <%
            // Lấy danh sách phòng mới nhất
            List<Room> normalRooms = new RoomDao().getAllNormalRooms();
            List<Room> premiumRooms = new RoomDao().getAllPremiumRooms();
            // Lấy bài đăng mới nhất
            List<RoommatePost> roommatePosts = new RoommatePostDao().get5NewestWithUser();
        %>

        <!-- Bài Normal -->
        <section class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>Đề Xuất Nổi Bật</h3>
                <a href="#" class="btn btn-primary btn-sm">Xem Tất Cả</a>
            </div>
            <div class="row">
                <% for (Room r : premiumRooms) { %>
                <div class="col-md-3 mb-4 d-flex">
                    <div class="card shadow-sm h-100 w-100">
                        <!-- Ảnh cùng chiều cao -->
                        <img src="<%= r.getImages().iterator().next() != null ? request.getContextPath() + "/" + r.getImages().iterator().next() : "https://via.placeholder.com/300x200" %>"
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

        <!-- Bài premium -->
        <section class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>Đề Xuất Nổi Bật</h3>
                <a href="#" class="btn btn-primary btn-sm">Xem Tất Cả</a>
            </div>
            <div class="row">
                <% for (Room r : normalRooms) { %>
                <div class="col-md-3 mb-4 d-flex">
                    <div class="card shadow-sm h-100 w-100">
                        <!-- Ảnh cùng chiều cao -->
                        <img src="<%= r.getImages().iterator().next() != null ? request.getContextPath() + "/" + r.getImages().iterator().next() : "https://via.placeholder.com/300x200" %>"
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

        <%-- tìm bạn phòng--%>
        <section class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3>5 bài đăng mới nhất</h3>
                <a href="#" class="btn btn-primary btn-sm">Xem Tất Cả</a>
            </div>
            <div class="row">
                <div class="col-12">
                    <%
                        if (roommatePosts != null && !roommatePosts.isEmpty()) {
                            for (int i = 0; i < roommatePosts.size(); i++) {
                                Model.RoommatePost post = roommatePosts.get(i);
                    %>
                    <div class="card mb-4 shadow-sm">
                        <div class="card-body">
                            <!-- Header: Tên + giới tính yêu cầu -->
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h5 class="card-title mb-0">
                                    <i class="bi bi-person-circle me-2"></i>
                                    <a href="<%=request.getContextPath()%>/profile?id=<%=post.getTenant().getId()%>">
                                        <%= post.getTenant().getName() %>
                                    </a>
                                </h5>
                                <span class="badge bg-primary"><%= post.getGenderRequirement() %></span>
                            </div>

                            <!-- Description -->
                            <p class="card-text"><%= post.getDescription() %></p>

                            <!-- Info row -->
                            <div class="row text-muted small">
                                <div class="col-md-3">
                                    <i class="bi bi-geo-alt-fill me-1"></i> <%= post.getLocation() %>
                                </div>
                                <div class="col-md-3">
                                    <i class="bi bi-cash-stack me-1"></i> Ngân sách: <%= post.getBudget() %> VNĐ
                                </div>
                                <div class="col-md-3">
                                    <i class="bi bi-clock-history me-1"></i> <%= post.getDuration() %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <div class="alert alert-info">Chưa có bài đăng nào.</div>
                    <%
                        }
                    %>
                </div>
            </div>
        </section>
    </div>
</main>

<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/js.jsp"/>
</body>
</html>
