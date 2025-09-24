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
                <h2 class="text-center mb-4">Quên mật khẩu</h2>
                <form method="post" action="<%=request.getContextPath()%>/forgot-password">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email đã đăng ký</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Gửi yêu cầu đặt lại</button>
                </form>
                <div class="mt-3 text-center">
                    <a href="<%=request.getContextPath()%>/login">Quay lại đăng nhập</a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />
</body>
</html>
