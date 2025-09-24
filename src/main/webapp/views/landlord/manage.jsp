<%@ page import="Model.Room" %>
<%@ page import="Dao.RoomDao" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<%@include file="../include/head.jsp" %>
<body>
<%@include file="../include/header.jsp" %>
<!-- Banner -->
<div class="w-100"
     style="height:200px; background:url('<%=request.getContextPath()%>/assets/img/banner.jpg') center/cover no-repeat;">
</div>

<main class="flex-fill">
    <div class="container py-4">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3">
                <div class="card shadow-sm p-3 mb-4">
                    <div class="text-center">
                        <img src="<%=user.getAvatar()%>" class="rounded-circle mb-2"
                             width="100" height="100" alt="avatar">
                        <h5 class="mb-0"><%=user.getName()%></h5>
                        <small class="text-muted"><%=user.getEmail()%></small>
                        <div class="mt-3">
                            <a href="#" class="btn btn-primary w-100 mb-2" data-bs-toggle="modal" data-bs-target="#profileModal">
                                View profile
                            </a>
                        </div>
                    </div>
                    <div class="mt-3">
                        <p class="fw-bold">Welcome, <%=user.getName()%></p>
                        <p class="small text-muted">Tìm các thông điệp, mẹo và liên kết quan trọng đến các tài nguyên
                            hữu ích ở đây</p>
                    </div>
                </div>
            </div>

            <!-- Content -->
            <div class="col-md-9">
                <div class="text-center mb-4">
                    <button class="btn btn-primary tab-btn" data-target="posts">Quản lý bài đăng</button>
                    <button class="btn btn-outline-primary tab-btn" data-target="history">Lịch sử giao dịch</button>
                    <button class="btn btn-outline-primary tab-btn" data-target="profile">Hồ sơ cá nhân</button>
                    <button class="btn btn-outline-primary tab-btn" data-target="service">Dịch vụ</button>
                    <button class="btn btn-outline-primary tab-btn" data-target="ads">Quảng cáo</button>
                </div>

                <div class="tab-content">
                    <div id="posts" class="tab-pane active">
                        <button class="btn btn-outline-primary mb-3" data-bs-toggle="modal" data-bs-target="#addRoomModal">
                            Thêm phòng mới
                        </button>

                        <div class="row">
                            <% List<Room> rooms = new RoomDao().getRoomsOfUser(user); %>
                            <%
                                for (Room r : rooms) {
                                    // Lấy ảnh đầu tiên nếu có
                                    String img = (r.getImages() != null && !r.getImages().isEmpty())
                                            ? request.getContextPath() + "/" + r.getImages().iterator().next()
                                            : request.getContextPath() + "/assets/img/no-image.png";
                            %>
                            <div class="col-md-4 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <img src="<%= img %>" class="card-img-top" alt="Room Image" style="height:200px; object-fit:cover;">
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title"><%= r.getName() %></h5>
                                        <p class="card-text mb-1"><strong>Giá:</strong>
                                            <%= r.getPrice() != null ? String.format("%,.0f VNĐ", r.getPrice()) : "Liên hệ" %></p>
                                        <p class="card-text mb-1"><strong>Diện tích:</strong> <%= r.getArea() %> m²</p>
                                        <p class="card-text mb-1"><strong>Phòng ngủ:</strong> <%= r.getBedrooms() %>,
                                            <strong>Phòng tắm:</strong> <%= r.getBathrooms() %></p>
                                        <p class="card-text text-muted" style="font-size: 0.9em;">
                                            <%= r.getStreet() %>, <%= r.getWardCode() %>,
                                            <%= r.getDistrictCode() %>, <%= r.getProvinceCode() %>
                                        </p>
                                        <div class="mt-auto d-flex justify-content-between">
                                            <button class="btn btn-sm btn-warning"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#updateRoomModal"
                                                    data-id="<%=r.getId()%>"
                                                    data-category="<%=r.getCategory() != null ? r.getCategory().getId() : ""%>"
                                                    data-province="<%=r.getProvinceCode()%>"
                                                    data-district="<%=r.getDistrictCode()%>"
                                                    data-ward="<%=r.getWardCode()%>"
                                                    data-street="<%=URLEncoder.encode(r.getStreet() != null ? r.getStreet() : "", StandardCharsets.UTF_8)%>"
                                                    data-map="<%=URLEncoder.encode(r.getMapEmbedUrl() != null ? r.getMapEmbedUrl() : "", StandardCharsets.UTF_8)%>"
                                                    data-name="<%=r.getName()%>"
                                                    data-bedrooms="<%=r.getBedrooms()%>"
                                                    data-bathrooms="<%=r.getBathrooms()%>"
                                                    data-price="<%=r.getPrice()%>"
                                                    data-area="<%=r.getArea()%>"
                                                    data-description="<%=URLEncoder.encode(r.getDescription() != null ? r.getDescription() : "", StandardCharsets.UTF_8)%>"
                                                    data-utilities="<%= String.join(",", r.getUtilities().stream().map(u -> u.getId().toString()).toList()) %>"
                                                    onclick="populateUpdateForm(this)">
                                                Cập nhật
                                            </button>
                                            <form action="LockRoomServlet" method="post" class="d-inline">
                                                <input type="hidden" name="roomId" value="<%= r.getId() %>">
                                                <button type="submit" class="btn btn-danger">Khóa</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    <div id="history" class="tab-pane">
                        <p>Nội dung lịch sử giao dịch...</p>
                    </div>
                    <div id="profile" class="tab-pane">
                        <p>Nội dung hồ sơ cá nhân...</p>
                    </div>
                    <div id="service" class="tab-pane">
                        <p>Nội dung dịch vụ...</p>
                    </div>
                    <div id="ads" class="tab-pane">
                        <p>Nội dung quảng cáo...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<!-- Modal -->
<%@include file="../user/profile-modal.jsp" %>
<%@include file="../include/footer.jsp" %>
<%@include file="../include/js.jsp" %>
<%@include file="add-room-modal.jsp" %>
<%@include file="edit-room-modal.jsp" %>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const buttons = document.querySelectorAll(".tab-btn");
        const panes = document.querySelectorAll(".tab-pane");

        buttons.forEach(btn => {
            btn.addEventListener("click", () => {
                // reset tất cả button
                buttons.forEach(b => {
                    b.classList.remove("btn-primary");
                    b.classList.add("btn-outline-primary");
                });
                // reset tất cả tab content
                panes.forEach(p => p.classList.remove("active"));

                // active cho button vừa bấm
                btn.classList.remove("btn-outline-primary");
                btn.classList.add("btn-primary");

                // active cho tab content tương ứng
                document.getElementById(btn.dataset.target).classList.add("active");
            });
        });
    });
</script>

</body>
</html>
