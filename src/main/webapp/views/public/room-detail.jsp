<%@ page import="Model.Room" %>
<%@ page import="Dao.RoomDao" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<%@ include file="../include/head.jsp" %>
<body>
<%@ include file="../include/header.jsp" %>

<main class="flex-fill">
    <div class="container py-5">
        <%
            Long roomId = Long.parseLong(request.getParameter("id"));
            Room room = new RoomDao().getById(roomId);
        %>

        <div class="row">
            <!-- Hình ảnh -->
            <div class="col-md-6">
                <!-- Ảnh chính -->
                <div class="border rounded mb-3 text-center">
                    <img id="mainImage" src="<%= room.getImages().iterator().next() %>"
                         class="img-fluid rounded" style="max-height: 400px; object-fit: cover;">
                </div>

                <!-- Thumbnail -->
                <div class="d-flex gap-2 flex-wrap">
                    <% for(String img : room.getImages()) { %>
                    <img src="<%= img %>"
                         class="img-thumbnail thumb-img"
                         style="width: 80px; height: 80px; object-fit: cover; cursor: pointer;"
                         onclick="document.getElementById('mainImage').src=this.src">
                    <% } %>
                </div>
            </div>

            <!-- Thông tin phòng -->
            <div class="col-md-6">
                <h3><%= room.getName() %></h3>
                <h4 class="text-danger"><%= String.format("%,.0f", room.getPrice()) %> VND/tháng</h4>
                <p><strong>Diện tích:</strong> <%= room.getArea() %> m²</p>
                <p><strong>Phòng ngủ:</strong> <%= room.getBedrooms() %></p>
                <p><strong>Phòng tắm:</strong> <%= room.getBathrooms() %></p>
                <p><strong>Địa chỉ:</strong>
                    <%= room.getStreet() %>,
                    Phường <%= room.getWardCode() %>,
                    Quận <%= room.getDistrictCode() %>,
                    Tỉnh <%= room.getProvinceCode() %>
                </p>
                <p><strong>Tiện ích:</strong>
                    <% if(room.getUtilities() != null) {
                        for(var uti : room.getUtilities()) { %>
                    <span class="badge bg-secondary"><%= uti.getName() %></span>
                    <% }} %>
                </p>
                <p><strong>Mô tả:</strong></p>
                <p><%= room.getDescription() %></p>

                <p>
                    <strong>Trạng thái:</strong>
                    <% if(room.isAvailable()) { %>
                    <span class="text-success">Còn phòng</span>
                    <% } else { %>
                    <span class="text-danger">Hết phòng</span>
                    <% } %>
                </p>
            </div>
        </div>

        <!-- Bản đồ -->
        <div class="mt-5">
            <h5>Vị trí phòng</h5>
            <div class="ratio ratio-16x9">
                <%= room.getMapEmbedUrl() %>
            </div>
        </div>

    </div>
</main>

<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/js.jsp"/>
</body>
</html>
