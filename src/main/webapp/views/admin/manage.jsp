<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.User" %>
<%@ page import="Dao.UserDao" %>
<!doctype html>
<html lang="vi">
<%@include file="../include/head.jsp" %>
<body>
<%@include file="../include/header.jsp" %>
<!-- Main content -->
<main class="flex-fill">
  <div class="container py-5">
    <div class="row col-12">
      <div class="text-center mb-4">
        <button class="btn btn-primary tab-btn" data-target="users">Quản lý người dùng</button>
        <button class="btn btn-outline-primary tab-btn" data-target="history">Lịch sử giao dịch</button>
      </div>
      <div class="tab-content">
        <!-- USERS TAB -->
        <div id="users" class="tab-pane active">
          <%
            List<User> users = new UserDao().getAll();
          %>
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h4>Danh sách người dùng</h4>
            <!-- Nút mở modal thêm user -->
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addUserModal">
              Thêm User
            </button>
          </div>
          <table class="table table-bordered table-hover">
            <thead class="table-light">
            <tr>
              <th>ID</th>
              <th>Tên</th>
              <th>Email</th>
              <th>SĐT</th>
              <th>Role</th>
              <th>Trạng thái</th>
            </tr>
            </thead>
            <tbody>
            <% if (users != null && !users.isEmpty()) {
              for (User u : users) { %>
            <tr>
              <td><%= u.getId() %></td>
              <td><%= u.getName() %></td>
              <td><%= u.getEmail() %></td>
              <td><%= u.getPhone() %></td>
              <td><%= u.getRole() %></td>
              <td>
                <% if (u.isBlocked()) { %>
                <span class="badge bg-danger">Blocked</span>
                <% } else { %>
                <span class="badge bg-success">Active</span>
                <% } %>
              </td>
            </tr>
            <% }
            } else { %>
            <tr>
              <td colspan="6" class="text-center">Chưa có người dùng nào</td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>

        <!-- HISTORY TAB -->
        <div id="history" class="tab-pane">
          history
        </div>
      </div>
    </div>
  </div>
</main>
<%@include file="add-user-modal.jsp" %>
<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />
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
