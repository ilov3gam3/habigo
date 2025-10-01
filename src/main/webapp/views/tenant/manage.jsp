<%@ page import="java.util.List" %>
<%@ page import="Model.RoommatePost" %>
<%@ page import="Dao.RoommatePostDao" %>
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
            <!-- Nút mở modal -->
            <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#createPostModal">
              + Tạo bài đăng
            </button>

            <!-- Danh sách bài đăng -->
            <div class="row">
              <%
                RoommatePostDao roommatePostDao = new RoommatePostDao();
                List<RoommatePost> posts = roommatePostDao.getPostsOfUser(user);
                roommatePostDao.close();
                if (posts == null || posts.isEmpty()) {
              %>
              <div class="col-12">
                <div class="alert alert-info">Bạn chưa có bài đăng nào. Hãy tạo mới!</div>
              </div>
              <%
              } else {
                for (RoommatePost post : posts) {
              %>
              <div class="col-md-6 mb-3">
                <div class="card shadow-sm h-100">
                  <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-person-lines-fill"></i> Bài đăng tìm bạn cùng trọ</h5>
                    <p class="card-text"><%= post.getDescription() %></p>

                    <ul class="list-unstyled mb-3">
                      <li><strong>Giới tính yêu cầu:</strong> <%= post.getGenderRequirement() %></li>
                      <li><strong>Ngân sách:</strong> <%= post.getBudget() %> VNĐ</li>
                      <li><strong>Địa điểm:</strong> <%= post.getLocation() %></li>
                      <li><strong>Thời gian ở:</strong> <%= post.getDuration() %></li>
                    </ul>
                  </div>
                  <%--<div class="card-footer d-flex justify-content-end gap-2">
                    <a href="#" class="btn btn-sm btn-outline-secondary">
                      <i class="bi bi-pencil-square"></i> Sửa
                    </a>
                    <a href="#" class="btn btn-sm btn-outline-danger">
                      <i class="bi bi-trash"></i> Xóa
                    </a>
                  </div>--%>
                </div>
              </div>
              <%
                  }
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
<%@include file="create-post-modal.jsp" %>
<%@include file="../include/footer.jsp" %>
<%@include file="../include/js.jsp" %>
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
