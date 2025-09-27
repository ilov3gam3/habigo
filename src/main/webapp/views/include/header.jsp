<%@ page import="Model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<% User user = (User) request.getSession().getAttribute("user"); %>
<header class="shadow-sm">
    <nav class="navbar navbar-expand-lg navbar-light bg-white">
        <div class="container">
            <!-- Logo -->
            <a class="navbar-brand fw-bold text-primary" href="<%=request.getContextPath()%>/">HabiGo</a>

            <!-- Menu toggle (mobile) -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <!-- Form search -->
            <form class="d-flex me-3" action="<%=request.getContextPath()%>/search" method="get">
                <input class="form-control rounded-pill px-3"
                       type="search"
                       name="q"
                       placeholder="Tìm phòng, căn hộ..."
                       aria-label="Search">
                <button class="btn btn-outline-primary rounded-pill ms-2" type="submit">
                    <i class="bi bi-search"></i>
                </button>
            </form>
            <!-- Menu -->
            <div class="collapse navbar-collapse" id="mainNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link active" href="#">Trang Chủ</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Phòng Trọ</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/find-roommate">Tìm người ở ghép</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Habigo AI</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Về Chúng Tôi</a></li>
                    <% if (user != null) { %>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/views/user/chat.jsp">Chat</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/logout">Đăng xuất</a></li>
                    <% } %>
                </ul>
                <%--thêm form search vào đây--%>
                <!-- Icons + Buttons -->
                <div class="d-flex align-items-center gap-3">
                    <% if (user == null) { %>
                    <a href="<%=request.getContextPath()%>/login" class="btn btn-outline-primary rounded-pill px-3">Đăng nhập</a>
                    <a href="<%=request.getContextPath()%>/register" class="btn btn-primary rounded-pill px-3">Đăng ký</a>
                    <% } else { %>
                    <a href="<%=request.getContextPath()%>/<%=user.getRole().toString().toLowerCase()%>/manage">
                        <div class="d-flex align-items-center gap-2">
                            <img src="<%= user.getAvatar() != null ? user.getAvatar() : request.getContextPath() + "/assets/img/default-avatar.png" %>"
                                 alt="avatar" class="rounded-circle" width="32" height="32">
                            <span><%= user.getName() %></span>
                        </div>
                    </a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>
</header>
