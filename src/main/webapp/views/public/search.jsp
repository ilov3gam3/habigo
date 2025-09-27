<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.Room"%>
<%@page import="Model.Category"%>
<%@page import="Model.Utility"%>
<!doctype html>
<html lang="vi">
<%@include file="../include/head.jsp"%>
<body>
<%@include file="../include/header.jsp"%>

<main class="flex-fill">
  <div class="container py-5">
    <div class="row">
      <!-- Form search -->
      <div class="col-md-3">
        <div class="card shadow-sm">
          <div class="card-body">
            <%
              String q = request.getParameter("q");
              String categoryIdParam = request.getParameter("categoryId");
              String provinceCodeParam = request.getParameter("provinceCode");
              String priceMinParam = request.getParameter("priceMin");
              String priceMaxParam = request.getParameter("priceMax");
              String[] selectedUtilities = request.getParameterValues("utilities");
              java.util.Set<String> selectedUtilSet = new java.util.HashSet<>();
              if (selectedUtilities != null) {
                selectedUtilSet = new java.util.HashSet<>(java.util.Arrays.asList(selectedUtilities));
              }
            %>

            <form action="${pageContext.request.contextPath}/search" method="get" class="vstack gap-3">

              <!-- Search text -->
              <input type="text" name="q" class="form-control m-1" placeholder="Từ khóa (tên, mô tả)"
                     value="<%= q != null ? q : "" %>">

              <!-- Category -->
              <select name="categoryId" class="form-select">
                <option value="">-- Loại phòng --</option>
                <%
                  List<Category> categoryList = (List<Category>) request.getAttribute("categoryList");
                  if (categoryList != null) {
                    for (Category c : categoryList) {
                      String selected = (categoryIdParam != null && categoryIdParam.equals(String.valueOf(c.getId()))) ? "selected" : "";
                %>
                <option value="<%= c.getId() %>" <%= selected %>><%= c.getName() %></option>
                <%
                    }
                  }
                %>
              </select>

              <!-- Province -->
              <select name="provinceCode" id="provinceSelect" class="form-select" data-selected="<%= provinceCodeParam != null ? provinceCodeParam : "" %>">
                <option value="">-- Tỉnh/Thành phố --</option>
              </select>

              <!-- Price range -->
              <div class="d-flex gap-2">
                <input type="number" name="priceMin" class="form-control m-1" placeholder="Giá từ"
                       value="<%= priceMinParam != null ? priceMinParam : "" %>">
                <input type="number" name="priceMax" class="form-control m-1" placeholder="Đến"
                       value="<%= priceMaxParam != null ? priceMaxParam : "" %>">
              </div>

              <!-- Utilities -->
              <label class="fw-bold">Tiện ích</label>
              <%
                List<Utility> utilities = (List<Utility>) request.getAttribute("utilities");
                if (utilities != null) {
                  for (Utility u : utilities) {
                    boolean checked = selectedUtilSet.contains(String.valueOf(u.getId()));
              %>
              <div class="form-check">
                <input class="form-check-input" type="checkbox" name="utilities" value="<%= u.getId() %>"
                       id="util<%= u.getId() %>" <%= checked ? "checked" : "" %>>
                <label class="form-check-label" for="util<%= u.getId() %>"><%= u.getName() %></label>
              </div>
              <%
                  }
                }
              %>

              <button type="submit" class="btn btn-primary mt-3">
                <i class="bi bi-search"></i> Tìm kiếm
              </button>
            </form>
          </div>
        </div>
      </div>

      <!-- Kết quả -->
      <div class="col-md-9">
        <div class="row">
          <%
            List<Room> rooms = (List<Room>) request.getAttribute("rooms");
            if (rooms == null || rooms.isEmpty()) {
          %>
          <div class="col-12">
            <div class="alert alert-info">Không tìm thấy kết quả nào.</div>
          </div>
          <%
          } else {
            for (Room r : rooms) {
          %>
          <div class="col-md-6 mb-4">
            <div class="card h-100 shadow-sm">
              <% if (r.getImages() != null && !r.getImages().isEmpty()) { %>
              <img src="<%= request.getContextPath() + "/" + r.getImages().iterator().next() %>" class="card-img-top" alt="Ảnh phòng">
              <% } %>
              <div class="card-body">
                <h5 class="card-title"><%= r.getName() %></h5>
                <p class="card-text text-truncate"><%= r.getDescription() %></p>
                <p class="mb-1"><strong>Giá:</strong> <%= r.getPrice() %> VNĐ</p>
                <p class="mb-1"><strong>Diện tích:</strong> <%= r.getArea() %> m²</p>
                <p class="mb-1"><strong>Phòng ngủ:</strong> <%= r.getBedrooms() %> |
                  <strong>Phòng tắm:</strong> <%= r.getBathrooms() %></p>
                <a href="<%=request.getContextPath()%>/room-detail?id=<%=r.getId()%>" target="_blank">
                  <button class="btn btn-outline-primary m-1">Xem chi tiết</button>
                </a>
              </div>
            </div>
          </div>
          <%
              }
            }
          %>
        </div>
      </div>
    </div>
  </div>
</main>

<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/js.jsp"/>

<!-- Load provinces dynamically -->
<script>
  fetch("https://provinces.open-api.vn/api/v1/p/")
          .then(res => res.json())
          .then(data => {
            const select = document.getElementById("provinceSelect");
            data.forEach(p => {
              const opt = document.createElement("option");
              opt.value = p.code;
              opt.textContent = p.name;
              select.appendChild(opt);
            });
          });
</script>
</body>
</html>