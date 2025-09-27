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
                <!-- Form kiểm tra phòng trống -->
                <form method="get" action="room-detail" class="border p-3 rounded mb-3">
                    <input type="hidden" name="id" value="<%= roomId %>"/>
                    <div class="mb-2">
                        <label for="fromDate" class="form-label">Ngày bắt đầu</label>
                        <input type="date" id="fromDate" name="fromDate" class="form-control"
                               value="<%= request.getParameter("fromDate") != null ? request.getParameter("fromDate") : "" %>"
                               required>
                    </div>
                    <div class="mb-2">
                        <label for="months" class="form-label">Số tháng thuê</label>
                        <select id="months" name="months" class="form-select">
                            <% for(int i=1;i<=12;i++){ %>
                            <option value="<%=i%>" <%= (request.getParameter("months")!=null && request.getParameter("months").equals(String.valueOf(i))) ? "selected" : "" %>>
                                <%=i%>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-2">
                        <label for="toDate" class="form-label">Ngày kết thúc</label>
                        <input type="date" id="toDate" name="toDate" class="form-control"
                               value="<%= request.getParameter("toDate") != null ? request.getParameter("toDate") : "" %>"
                               readonly>
                    </div>
                    <button type="submit" class="btn btn-outline-success">Kiểm tra phòng trống</button>

                    <%
                        String fromDateStr = request.getParameter("fromDate");
                        String toDateStr = request.getParameter("toDate");
                        if(fromDateStr != null && toDateStr != null){
                            java.time.LocalDate fromDate = java.time.LocalDate.parse(fromDateStr);
                            java.time.LocalDate toDate = java.time.LocalDate.parse(toDateStr);
                            int available = new Dao.RoomDao().getAvailableRooms(roomId, fromDate, toDate);

                            if(available > 0){
                    %>
                    <p class="mt-2 text-success"><%= available %> phòng còn trống</p>
                    <!-- Nút thuê ngay, submit sang servlet đặt phòng -->
                    <% if (user == null) { %>
                    <button type="button" onclick="toastr.info('Vui lòng đăng nhập')" class="btn btn-primary">
                        Thuê ngay
                    </button>
                    <% } else { %>
                    <button type="submit" formaction="rent-room" formmethod="post" class="btn btn-primary">
                        Thuê ngay
                    </button>
                    <% } %>

                    <%  } else { %>
                    <p class="mt-2 text-danger">Hết phòng</p>
                    <%  }
                    } %>
                </form>
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
