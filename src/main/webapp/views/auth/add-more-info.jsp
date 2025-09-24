<%@ page import="Model.User" %>
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
                <h2 class="text-center mb-4">Hoàn tất thông tin</h2>
                <% User temp = (User) request.getSession().getAttribute("tempUser"); %>
                <form method="post" action="<%=request.getContextPath()%>/add-more-info">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" id="email" name="email" class="form-control" disabled value="<%=temp.getEmail()%>" >
                    </div>
                    <div class="mb-3">
                        <label for="name" class="form-label">Tên</label>
                        <input type="text" id="name" name="name" class="form-control" disabled value="<%=temp.getName()%>" >
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input type="password" id="password" name="password" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input type="text" id="phone" name="phone" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="role" class="form-label">Bạn là</label>
                        <select class="form-control" name="role" id="role">
                            <option value="LANDLORD">Tôi là người cho thuê</option>
                            <option value="TENANT">Tôi là người thuê trọ</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Cập nhật thông </button>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />
</body>
</html>
