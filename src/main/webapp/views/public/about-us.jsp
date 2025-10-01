<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<%@include file="../include/head.jsp" %>
<body>
<%@include file="../include/header.jsp" %>

<!-- Main content -->
<main class="flex-fill">
    <div class="container py-5">
        <div class="row align-items-center">
            <!-- Cột ảnh -->
            <div class="col-md-6 mb-4 mb-md-0">
                <img src="<%=request.getContextPath()%>/assets/images/about-us.jpg"
                     alt="About us"
                     class="img-fluid rounded shadow">
            </div>

            <!-- Cột text -->
            <div class="col-md-6">
                <h2 class="mb-4">Câu chuyện của chúng tôi</h2>
                <p>
                    Chúng tôi là một đội ngũ trẻ trung, năng động, với mục tiêu mang lại
                    những sản phẩm và dịch vụ chất lượng cao nhất đến khách hàng.
                    Với kinh nghiệm và đam mê, chúng tôi luôn nỗ lực đổi mới, sáng tạo
                    để tạo nên giá trị bền vững và niềm tin cho cộng đồng.
                </p>
                <p>
                    HABIGO là nền tảng kết nối người thuê và chủ trọ, mang đến trải nghiệm tìm phòng nhanh chóng, uy
                    tín, tiết kiệm. Thông tin được cập nhật liên tục, đa dạng phân khúc giá, đảm bảo an toàn và minh
                    bạch.
                </p>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/js.jsp"/>
</body>
</html>
