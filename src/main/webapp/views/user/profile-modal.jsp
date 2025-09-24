<%@page contentType="text/html" pageEncoding="UTF-8" %>
<div class="modal fade" id="profileModal" tabindex="-1" aria-labelledby="profileModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <!-- Header -->
      <div class="modal-header">
        <h5 class="modal-title" id="profileModalLabel">Quản lý hồ sơ</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>

      <!-- Body -->
      <div class="modal-body">
        <!-- Tab buttons -->
        <ul class="nav nav-tabs mb-3" id="profileTab" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#info" type="button">
              Cập nhật thông tin
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="avatar-tab" data-bs-toggle="tab" data-bs-target="#avatar" type="button">
              Thay avatar
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="password-tab" data-bs-toggle="tab" data-bs-target="#password" type="button">
              Đổi mật khẩu
            </button>
          </li>
        </ul>

        <!-- Tab content -->
        <div class="tab-content">
          <!-- Form cập nhật thông tin -->
          <div class="tab-pane fade show active" id="info" role="tabpanel">
            <form action="<%=request.getContextPath()%>/user/profile" method="post">
              <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" value="<%=user.getEmail()%>" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Tên</label>
                <input type="text" name="name" class="form-control" value="<%=user.getName()%>" required>
              </div>
              <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
            </form>
          </div>

          <!-- Form thay avatar -->
          <div class="tab-pane fade" id="avatar" role="tabpanel">
            <form action="<%=request.getContextPath()%>/update-avatar" method="post" enctype="multipart/form-data">
              <div class="mb-3 text-center">
                <img src="<%=user.getAvatar()%>" alt="avatar" class="rounded-circle mb-3" width="100" height="100">
                <input type="file" name="avatar" accept="image/*" class="form-control" required>
              </div>
              <button type="submit" class="btn btn-primary">Cập nhật avatar</button>
            </form>
          </div>

          <!-- Form đổi mật khẩu -->
          <div class="tab-pane fade" id="password" role="tabpanel">
            <form action="<%=request.getContextPath()%>/change-password" method="post">
              <div class="mb-3">
                <label class="form-label">Mật khẩu cũ</label>
                <input type="password" name="oldPassword" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Mật khẩu mới</label>
                <input type="password" name="newPassword" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Xác nhận mật khẩu mới</label>
                <input type="password" name="confirmPassword" class="form-control" required>
              </div>
              <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
            </form>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
      </div>
    </div>
  </div>
</div>
