<%@ page import="Model.Room" %>
<%@ page import="Model.Payment" %>
<%@ page import="Dao.RoomDao" %>
<%@ page import="Dao.PaymentDao" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<%@include file="../include/head.jsp" %>
<body>
<%@include file="../include/header.jsp" %>

<div class="w-100"
     style="height:200px; background:url('<%=request.getContextPath()%>/assets/img/banner.jpg') center/cover no-repeat;">
</div>

<main class="flex-fill">
    <div class="container py-4">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3">
                <div class="card shadow-sm p-3 mb-4 text-center">
                    <img src="<%=user.getAvatar()%>" class="rounded-circle mb-2 mx-auto d-block" width="100" height="100" alt="avatar">
                    <h5 class="mb-0"><%=user.getName()%></h5>
                    <small class="text-muted"><%=user.getEmail()%></small>
                    <div class="mt-3">
                        <a href="#" class="btn btn-primary w-100 mb-2" data-bs-toggle="modal"
                           data-bs-target="#profileModal">View profile</a>
                    </div>
                </div>
            </div>

            <!-- Content -->
            <div class="col-md-9">
                <div class="text-center mb-4">
                    <button class="btn btn-primary tab-btn" data-target="posts">Quản lý bài đăng</button>
                    <button class="btn btn-outline-primary tab-btn" data-target="history">Lịch sử giao dịch</button>
                </div>

                <div class="tab-content">
                    <!-- Tab bài đăng -->
                    <div id="posts" class="tab-pane active">
                        <button class="btn btn-outline-primary mb-3" data-bs-toggle="modal"
                                data-bs-target="#addRoomModal">Thêm phòng mới</button>

                        <%
                            RoomDao roomDao = new RoomDao();
                            PaymentDao paymentDao = new PaymentDao();

                            long purchasedNormal = paymentDao.countNormalSlots(user);
                            long purchasedPremium = paymentDao.countPremiumSlots(user);

                            long usedNormal = roomDao.countNormalRooms(user);
                            long usedPremium = roomDao.countPremiumRooms(user);

                            List<Room> rooms = roomDao.getRoomsOfUser(user);
                        %>

                        <div class="alert alert-info">
                            <strong>Normal slots:</strong> <%= usedNormal %> / <%= purchasedNormal + Config.freePost %> <br>
                            <strong>Premium slots:</strong> <%= usedPremium %> / <%= purchasedPremium %>
                        </div>

                        <div class="row">
                            <%
                                for (Room r : rooms) {
                                    String img = (r.getImages() != null && !r.getImages().isEmpty())
                                            ? request.getContextPath() + r.getImages().iterator().next()
                                            : request.getContextPath() + "/assets/img/no-image.png";
                            %>
                            <div class="col-md-4 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <img src="<%= img %>" class="card-img-top" style="height:200px; object-fit:cover;">
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title"><%= r.getName() %></h5>
                                        <p class="card-text mb-1"><strong>Giá:</strong>
                                            <%= r.getPrice() != 0 ? String.format("%,d VNĐ", r.getPrice()) : "Liên hệ" %></p>
                                        <p class="card-text mb-1"><strong>Diện tích:</strong> <%= r.getArea() %> m²</p>
                                        <p class="card-text mb-1"><strong>Phòng ngủ:</strong> <%= r.getBedrooms() %>,
                                            <strong>Phòng tắm:</strong> <%= r.getBathrooms() %></p>
                                        <p class="card-text text-muted" style="font-size: 0.9em;">
                                            <%= r.getStreet() %>
                                        </p>
                                        <div class="mt-auto">
                                            <div class="d-flex justify-content-between mb-2">
                                                <form action="<%=request.getContextPath()%>/landlord/change-status"
                                                      method="post" class="d-inline">
                                                    <input type="hidden" name="id" value="<%= r.getId() %>">
                                                    <button type="submit"
                                                            class="btn btn-sm <%= r.isAvailable() ? "btn-danger" : "btn-success" %>">
                                                        <%= r.isAvailable() ? "Ẩn" : "Hiển thị" %>
                                                    </button>
                                                </form>

                                                <form action="<%=request.getContextPath()%>/landlord/change-premium"
                                                      method="get" class="d-inline">
                                                    <input type="hidden" name="id" value="<%= r.getId() %>">
                                                    <button type="submit"
                                                            class="btn btn-sm <%= r.isPremium() ? "btn-secondary" : "btn-warning" %>">
                                                        <%= r.isPremium() ? "Bỏ Premium" : "Bật Premium" %>
                                                    </button>
                                                </form>

                                            </div>
                                            <button class="btn btn-sm btn-outline-primary w-100"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#updateRoomModal"
                                                    data-id="<%=r.getId()%>"
                                                    data-name="<%=r.getName()%>"
                                                    onclick="populateUpdateForm(this)">
                                                Cập nhật
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Tab lịch sử giao dịch -->
                    <div id="history" class="tab-pane">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5>Lịch sử giao dịch</h5>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#buySlotModal">
                                Mua thêm slot
                            </button>
                        </div>

                        <%
                            List<Payment> payments = new PaymentDao().getPaymentsOfLandlord(user);
                        %>
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>Mã giao dịch</th>
                                <th>Số lượng</th>
                                <th>Số tiền</th>
                                <th>Loại</th>
                                <th>Thời gian</th>
                                <th>Trạng thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Payment p : payments) { %>
                            <tr>
                                <td><%= p.getOrderInfo() %></td>
                                <td><%= p.getQuantity() %></td>
                                <td><%= String.format("%,d VNĐ", p.getAmount()) %></td>
                                <td><%= p.getCardType() != null ? p.getCardType() : "-" %></td>
                                <td><%= p.getPaid_at() != null ? p.getPaid_at().toString() : "-" %></td>
                                <td><%= p.getTransactionStatus().getDescription() %></td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../user/profile-modal.jsp" %>
<%@include file="../include/footer.jsp" %>
<%@include file="../include/js.jsp" %>
<%@include file="add-room-modal.jsp" %>
<%@include file="edit-room-modal.jsp" %>
<%@include file="buy-slot-modal.jsp" %> <!-- modal mua slot -->

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const buttons = document.querySelectorAll(".tab-btn");
        const panes = document.querySelectorAll(".tab-pane");

        buttons.forEach(btn => {
            btn.addEventListener("click", () => {
                buttons.forEach(b => b.classList.remove("btn-primary"));
                buttons.forEach(b => b.classList.add("btn-outline-primary"));
                panes.forEach(p => p.classList.remove("active"));

                btn.classList.remove("btn-outline-primary");
                btn.classList.add("btn-primary");
                document.getElementById(btn.dataset.target).classList.add("active");
            });
        });
    });
</script>

</body>
</html>
