<%@ page import="Model.RoommatePost" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<%@include file="../include/head.jsp" %>
<body>
<%@include file="../include/header.jsp" %>

<main class="flex-fill">
    <div class="container py-5">
        <h2 class="mb-4 text-center">Tìm bạn cùng phòng</h2>

        <div class="row">
            <div class="col-12">
                <%
                    List<RoommatePost> posts = (List<Model.RoommatePost>) request.getAttribute("roommatePosts");
                    if (posts != null && !posts.isEmpty()) {
                        for (int i = posts.size() - 1; i >= 0; i--) {
                            Model.RoommatePost post = posts.get(i);
                %>
                <div class="card mb-4 shadow-sm">
                    <div class="card-body">
                        <!-- Header: Tên + giới tính yêu cầu -->
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-person-circle me-2"></i>
                                <a href="<%=request.getContextPath()%>/profile?id=<%=post.getTenant().getId()%>">
                                    <%= post.getTenant().getName() %>
                                </a>
                            </h5>
                            <span class="badge bg-primary"><%= post.getGenderRequirement() %></span>
                        </div>

                        <!-- Description -->
                        <p class="card-text"><%= post.getDescription() %></p>

                        <!-- Info row -->
                        <div class="row text-muted small">
                            <div class="col-md-3">
                                <i class="bi bi-geo-alt-fill me-1"></i> <%= post.getLocation() %>
                            </div>
                            <div class="col-md-3">
                                <i class="bi bi-cash-stack me-1"></i> Ngân sách: <%= post.getBudget() %> VNĐ
                            </div>
                            <div class="col-md-3">
                                <i class="bi bi-clock-history me-1"></i> <%= post.getDuration() %>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="alert alert-info">Chưa có bài đăng nào.</div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />
</body>
</html>
