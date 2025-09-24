<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%--<%@ page import="java.util.List" %>--%>
<%--<%@ page import="Model.Category" %>--%>
<%--<%@ page import="Model.Utility" %>--%>
<%--<%@ page import="Dao.UtilityDao" %>--%>
<%--<%@ page import="Dao.CategoryDao" %>--%>
<%--<%--%>
<%--    List<Category> categoryList = new CategoryDao().getAll();--%>
<%--    List<Utility> utilities = new UtilityDao().getAll();--%>
<%--%>--%>

<div class="modal fade" id="updateRoomModal" tabindex="-1" aria-labelledby="updateRoomModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <!-- Header -->
            <div class="modal-header">
                <h5 class="modal-title" id="updateRoomModalLabel">Cập nhật phòng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>

            <!-- Body -->
            <div class="modal-body">
                <form id="updateRoomForm" action="<%=request.getContextPath()%>/landlord/update-room" method="post" enctype="multipart/form-data">
                    <!-- Hidden field để biết đang edit room nào -->
                    <input type="hidden" name="roomId" id="update-roomId">

                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Tên</label>
                            <input type="text" name="name" id="update-name" class="form-control" required>
                        </div>
                        <!-- Category -->
                        <div class="col-md-6">
                            <label class="form-label">Loại phòng</label>
                            <select name="categoryId" id="update-categoryId" class="form-select" required>
                                <option value="">-- Chọn loại phòng --</option>
                                <% for (Category c : categoryList) { %>
                                <option value="<%=c.getId()%>"><%=c.getName()%></option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Province -->
                        <div class="col-md-6">
                            <label class="form-label">Tỉnh/Thành phố</label>
                            <select name="provinceCode" id="update-provinceSelect" class="form-select" required>
                                <option value="">-- Chọn tỉnh/thành phố --</option>
                            </select>
                        </div>

                        <!-- District -->
                        <div class="col-md-6 d-none" id="update-districtWrapper">
                            <label class="form-label">Quận/Huyện</label>
                            <select name="districtCode" id="update-districtSelect" class="form-select" required>
                                <option value="">-- Chọn quận/huyện --</option>
                            </select>
                        </div>

                        <!-- Ward -->
                        <div class="col-md-6 d-none" id="update-wardWrapper">
                            <label class="form-label">Xã/Phường</label>
                            <select name="wardCode" id="update-wardSelect" class="form-select" required>
                                <option value="">-- Chọn xã/phường --</option>
                            </select>
                        </div>

                        <!-- Street -->
                        <div class="col-md-12">
                            <label class="form-label">Địa chỉ (đường, ngõ...)</label>
                            <input type="text" name="street" id="update-street" class="form-control" required>
                        </div>

                        <!-- Map Embed -->
                        <div class="col-md-12">
                            <label class="form-label">Google Maps Embed URL</label>
                            <input type="text" name="mapEmbedUrl" id="update-mapEmbedUrl" class="form-control">
                        </div>

                        <!-- Images -->
                        <div class="col-md-12">
                            <label class="form-label">Hình ảnh (bỏ trống nếu không đổi)</label>
                            <input type="file" name="images" class="form-control" multiple accept="image/*">
                        </div>

                        <!-- Bedrooms, Bathrooms -->
                        <div class="col-md-4">
                            <label class="form-label">Phòng ngủ</label>
                            <input type="number" name="bedrooms" id="update-bedrooms" class="form-control" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Phòng tắm</label>
                            <input type="number" name="bathrooms" id="update-bathrooms" class="form-control" min="0" required>
                        </div>

                        <!-- Price & Area -->
                        <div class="col-md-6">
                            <label class="form-label">Giá (VNĐ)</label>
                            <input type="number" name="price" id="update-price" class="form-control" step="0.01" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Diện tích (m²)</label>
                            <input type="number" name="area" id="update-area" class="form-control" step="0.1" required>
                        </div>

                        <!-- Utilities -->
                        <div class="col-md-12">
                            <label for="update-utilityIds" class="form-label">Tiện ích</label>
                            <select name="utilityIds" id="update-utilityIds" class="form-select" multiple>
                                <% for (Utility u : utilities) { %>
                                <option value="<%=u.getId()%>"><%=u.getName()%></option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Description -->
                        <div class="col-md-12">
                            <label class="form-label">Mô tả</label>
                            <textarea name="description" id="update-description" rows="4" class="form-control"></textarea>
                        </div>
                    </div>

                    <div class="mt-4 text-end">
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const provinceSelect = document.getElementById("update-provinceSelect");
        const districtSelect = document.getElementById("update-districtSelect");
        const wardSelect = document.getElementById("update-wardSelect");
        const districtWrapper = document.getElementById("districtWrapper");
        const wardWrapper = document.getElementById("wardWrapper");
        // Load provinces
        fetch("https://provinces.open-api.vn/api/v1/p/")
            .then(res => res.json())
            .then(data => {
                data.forEach(p => {
                    const option = document.createElement("option");
                    option.value = p.code;
                    option.textContent = p.name;
                    provinceSelect.appendChild(option);
                });
            });

        // Khi chọn tỉnh -> load district
        provinceSelect.addEventListener("change", function () {
            const provinceCode = this.value;
            districtSelect.innerHTML = '<option value="">-- Chọn quận/huyện --</option>';
            wardSelect.innerHTML = '<option value="">-- Chọn xã/phường --</option>';
            wardWrapper.classList.add("d-none");

            if (!provinceCode) {
                districtWrapper.classList.add("d-none");
                return;
            }

            fetch("https://provinces.open-api.vn/api/v1/d/")
                .then(res => res.json())
                .then(data => {
                    data.filter(d => d.province_code == provinceCode).forEach(d => {
                        const option = document.createElement("option");
                        option.value = d.code;
                        option.textContent = d.name;
                        districtSelect.appendChild(option);
                    });
                    districtWrapper.classList.remove("d-none");
                });
        });

        // Khi chọn district -> load ward
        districtSelect.addEventListener("change", function () {
            const districtCode = this.value;
            wardSelect.innerHTML = '<option value="">-- Chọn xã/phường --</option>';

            if (!districtCode) {
                wardWrapper.classList.add("d-none");
                return;
            }

            fetch("https://provinces.open-api.vn/api/v1/w/")
                .then(res => res.json())
                .then(data => {
                    data.filter(w => w.district_code == districtCode).forEach(w => {
                        const option = document.createElement("option");
                        option.value = w.code;
                        option.textContent = w.name;
                        wardSelect.appendChild(option);
                    });
                    wardWrapper.classList.remove("d-none");
                });
        });
    });
</script>

<script>
    async function populateUpdateForm(button) {
        // Lấy dữ liệu từ attribute
        const id = button.dataset.id;
        const categoryId = button.dataset.category;
        const provinceCode = button.dataset.province;
        const districtCode = button.dataset.district;
        const wardCode = button.dataset.ward;
        const street = decodeAttr(button.dataset.street || "");
        const mapEmbedUrl = decodeAttr(button.dataset.map || "");
        const name = button.dataset.name;
        const bedrooms = button.dataset.bedrooms;
        const bathrooms = button.dataset.bathrooms;
        const price = button.dataset.price;
        const area = button.dataset.area;
        const description = decodeAttr(button.dataset.description || "");
        const utilityIds = button.dataset.utilities;

        // Gán vào form
        document.getElementById("update-roomId").value = id;
        document.getElementById("update-categoryId").value = categoryId;
        document.getElementById("update-street").value = street;
        document.getElementById("update-mapEmbedUrl").value = mapEmbedUrl;
        document.getElementById("update-name").value = name;
        document.getElementById("update-bedrooms").value = bedrooms;
        document.getElementById("update-bathrooms").value = bathrooms;
        document.getElementById("update-price").value = price;
        document.getElementById("update-area").value = area;
        document.getElementById("update-description").value = description;

        // Utilities (multi-select)
        const utilities = utilityIds ? utilityIds.split(",") : [];
        const select = document.getElementById("update-utilityIds");
        [...select.options].forEach(opt => {
            opt.selected = utilities.includes(opt.value);
        });
        $('#update-utilityIds').select2({
            placeholder: "Chọn tiện ích",
            width: '100%',
            dropdownParent: $('#updateRoomModal')
        });

        // ---- Province / District / Ward xử lý async ----
        const provinceSelect = document.getElementById("update-provinceSelect");
        const districtSelect = document.getElementById("update-districtSelect");
        const wardSelect = document.getElementById("update-wardSelect");
        const districtWrapper = document.getElementById("update-districtWrapper");
        const wardWrapper = document.getElementById("update-wardWrapper");

        // Chọn sẵn tỉnh
        if (provinceCode) {
            provinceSelect.value = provinceCode;

            // Load district theo provinceCode
            const districts = await fetch("https://provinces.open-api.vn/api/v1/d/")
                .then(res => res.json());
            districtSelect.innerHTML = '<option value="">-- Chọn quận/huyện --</option>';
            districts.filter(d => d.province_code == provinceCode).forEach(d => {
                const option = document.createElement("option");
                option.value = d.code;
                option.textContent = d.name;
                districtSelect.appendChild(option);
            });
            districtWrapper.classList.remove("d-none");

            // Chọn sẵn district
            if (districtCode) {
                districtSelect.value = districtCode;

                // Load ward theo districtCode
                const wards = await fetch("https://provinces.open-api.vn/api/v1/w/")
                    .then(res => res.json());
                wardSelect.innerHTML = '<option value="">-- Chọn xã/phường --</option>';
                wards.filter(w => w.district_code == districtCode).forEach(w => {
                    const option = document.createElement("option");
                    option.value = w.code;
                    option.textContent = w.name;
                    wardSelect.appendChild(option);
                });
                wardWrapper.classList.remove("d-none");

                // Chọn sẵn ward
                if (wardCode) {
                    wardSelect.value = wardCode;
                }
            }
        }
    }

    function decodeAttr(value) {
        if (!value) return "";
        return decodeURIComponent(value).replace(/\+/g, " ");
    }
</script>
