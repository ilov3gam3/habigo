<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<jsp:include page="../include/head.jsp" />
<body>
<jsp:include page="../include/header.jsp" />

<main class="flex-fill">
  <div class="container py-5">
    <div class="row justify-content-center">
      <div class="col-md-5">
        <h2 class="text-center mb-4">Đăng nhập</h2>
        <form method="post" action="<%=request.getContextPath()%>/login">
          <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" id="email" name="email" class="form-control" required>
          </div>
          <div class="mb-3">
            <label for="password" class="form-label">Mật khẩu</label>
            <input type="password" id="password" name="password" class="form-control" required>
          </div>
          <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
          <a href="<%=request.getContextPath()%>/google/oauth" class="btn btn-outline-danger w-100 mt-2">
            <i class="bi bi-google"></i> Đăng nhập bằng Google
          </a>
        </form>
        <div class="mt-3 text-center">
          <a href="<%=request.getContextPath()%>/forgot-password">Quên mật khẩu?</a>
        </div>
        <div class="mt-3 text-center">
          Chưa có tài khoản?
          <a href="<%=request.getContextPath()%>/register">Đăng ký</a>
        </div>
      </div>
    </div>
  </div>
</main>

<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />
</body>
</html>
