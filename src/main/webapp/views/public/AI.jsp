<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<%@include file="../include/head.jsp" %>
<body>
<%@include file="../include/header.jsp" %>

<!-- Main content -->
<main class="flex-fill">
  <div class="container py-5">
    <h3 class="mb-4 text-center">Tìm phòng bằng AI</h3>
    <form id="aiSearchForm" class="mb-4">
      <div class="mb-3">
        <label for="prompt" class="form-label">Nhập yêu cầu của bạn</label>
        <textarea id="prompt" name="prompt" class="form-control" rows="3"
                  placeholder="Ví dụ: Mình muốn phòng dưới 3 triệu, gần Đại học Bách Khoa, có chỗ để xe..."></textarea>
      </div>
      <button type="submit" class="btn btn-primary">Tìm phòng</button>
    </form>

    <!-- Kết quả AI -->
    <div id="aiResult" style="display:none;">
      <h5>Kết quả gợi ý:</h5>
      <pre id="analysis"></pre>
      <div id="rooms" class="row"></div>
    </div>
  </div>
</main>

<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />

<script>
  document.getElementById("aiSearchForm").addEventListener("submit", async function(e){
    e.preventDefault();
    const prompt = document.getElementById("prompt").value.trim();
    if(!prompt) return alert("Vui lòng nhập yêu cầu!");

    const res = await fetch("<%=request.getContextPath()%>/ask-room-ai", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ prompt })
    });

    const data = await res.json();

    document.getElementById("aiResult").style.display = "block";
    document.getElementById("analysis").textContent = data.analysis || "Không có phân tích.";

    const roomContainer = document.getElementById("rooms");
    roomContainer.innerHTML = "";

    if(data.recommendedIds && data.recommendedIds.length > 0){
      data.recommendedIds.forEach(id => {
        const room = data.rooms.find(r => r.id === id);
        if(room){
          const div = document.createElement("div");
          div.className = "col-md-4 mb-3";
          div.innerHTML = `
            <div class="card h-100 shadow-sm">
              <div class="card-body">
                <h5 class="card-title">${room.name}</h5>
                <p class="card-text"><strong>Giá:</strong> ${room.price.toLocaleString()} VNĐ</p>
                <p class="card-text"><strong>Địa chỉ:</strong> ${room.location}</p>
                <p class="card-text"><strong>Diện tích:</strong> ${room.area} m²</p>
                <p class="card-text"><strong>PN:</strong> ${room.bedrooms}, <strong>WC:</strong> ${room.bathrooms}</p>
                <p class="card-text"><strong>Tiện ích:</strong> ${room.utilities}</p>
              </div>
            </div>`;
          roomContainer.appendChild(div);
        }
      });
    } else {
      roomContainer.innerHTML = "<p>Không tìm thấy phòng phù hợp.</p>";
    }
  });
</script>

</body>
</html>
