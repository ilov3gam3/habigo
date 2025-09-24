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
                <h2 class="text-center mb-4">Đặt lại mật khẩu</h2>
                <%
                    String token = request.getParameter("token");
                    if (token == null) token = "";
                %>
                <form method="post" action="<%=request.getContextPath()%>/reset-password">
                    <input type="hidden" name="token" value="<%=token%>">
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu mới</label>
                        <input type="password" id="password" name="password" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Đặt lại mật khẩu</button>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />
</body>
</html>
