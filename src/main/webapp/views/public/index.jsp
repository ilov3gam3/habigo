<%@ page import="java.util.List" %>
<%@ page import="Model.Room" %>
<%@ page import="Dao.RoomDao" %>
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
           class="img-fluid rounded shadow" />
    </div>


    <%
      // Lấy danh sách phòng mới nhất
      List<Room> rooms = new RoomDao().get5LatestRooms();
    %>

    <!-- Đề Xuất Nổi Bật -->
    <section class="mb-5">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h3>Đề Xuất Nổi Bật</h3>
        <a href="#" class="btn btn-primary btn-sm">Xem Tất Cả</a>
      </div>
      <div class="row">
        <% for (Room r : rooms) { %>
        <div class="col-md-3 mb-4">
          <div class="card h-100 shadow-sm">
            <img src="<%= r.getImages().iterator().next() != null ? request.getContextPath() + "/" + r.getImages().iterator().next() : "https://via.placeholder.com/300x200" %>"
                 class="card-img-top" alt="Room image">
            <div class="card-body">
              <h5 class="card-title"><%= r.getDescription() %></h5>
              <p class="card-text"><%= r.getDescription() %></p>
              <a href="<%=request.getContextPath()%>/room-detail?id=<%= r.getId() %>" class="btn btn-sm btn-primary">Xem chi tiết</a>
            </div>
          </div>
        </div>
        <% } %>
      </div>
    </section>

    <!-- Thành Phố Đà Nẵng -->
    <section class="mb-5">
      <h3 class="mb-4">Thành Phố Đà Nẵng</h3>
      <div class="row">
        <% for (Room r : rooms) { %>
        <div class="col-md-3 mb-4">
          <div class="card h-100 shadow-sm">
            <img src="<%= r.getImages().iterator().next() != null ? r.getImages().iterator().next() : "https://via.placeholder.com/300x200" %>"
                 class="card-img-top" alt="Room image">
            <div class="card-body">
              <h6 class="card-title"><%= r.getDescription() %></h6>
              <p class="text-muted mb-2">Giá chỉ: <strong><%= r.getPrice() %> VNĐ</strong></p>
              <a href="<%=request.getContextPath()%>/room-detail?id=<%= r.getId() %>" class="btn btn-sm btn-outline-primary">Xem chi tiết</a>
            </div>
          </div>
        </div>
        <% } %>
      </div>
    </section>

  </div>
</main>

<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />
</body>
</html>
