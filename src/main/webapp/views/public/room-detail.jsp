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
                    <img id="mainImage" src="<%= request.getContextPath() + "/" + room.getImages().iterator().next() %>"
                         class="img-fluid rounded" style="max-height: 400px; object-fit: cover;">
                </div>

                <!-- Thumbnail -->
                <div class="d-flex gap-2 flex-wrap">
                    <% for(String img : room.getImages()) { img = request.getContextPath() + "/" + img; %>
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
                <h4 class="text-danger"><%= String.format("%,d", room.getPrice()) %> VND/tháng</h4>
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
                <p style="white-space: pre-line;"><%= room.getDescription() %></p>

                <p>
                    <strong>Trạng thái:</strong>
                    <% if(room.isAvailable()) { %>
                    <span class="text-success">Còn phòng</span>
                    <% } else { %>
                    <span class="text-danger">Hết phòng</span>
                    <% } %>
                </p>
                <p>
                    <strong>Chủ nhà:</strong>
                    <a href="<%=request.getContextPath()%>/profile?id=<%=room.getLandlord().getId()%>">
                        <span><%=room.getLandlord().getName()%></span>
                    </a>
                </p>
                <p>
                    <strong>Số điện thoại:</strong>
                    <span><%=room.getLandlord().getPhone()%></span>
                </p>
                <a href="<%=request.getContextPath()%>/views/user/chat.jsp?chatWith=<%=room.getLandlord().getId()%>">
                    <button class="btn btn-primary">Chat với chủ nhà</button>
                </a>
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
<script>
    document.getElementById("fromDate")?.addEventListener("change", updateEndDate);
    document.getElementById("months")?.addEventListener("change", updateEndDate);

    function updateEndDate() {
        const fromDateInput = document.getElementById("fromDate");
        const monthsInput = document.getElementById("months");
        const toDateInput = document.getElementById("toDate");

        if (fromDateInput.value && monthsInput.value) {
            const start = new Date(fromDateInput.value);
            start.setMonth(start.getMonth() + parseInt(monthsInput.value));
            // Giảm 1 ngày để kết thúc đúng
            start.setDate(start.getDate() - 1);

            toDateInput.value = start.toISOString().split("T")[0];
        }
    }
</script>

</body>
</html>
