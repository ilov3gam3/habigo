<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Category" %>
<%@ page import="Model.Utility" %>
<%@ page import="Dao.UtilityDao" %>
<%@ page import="Dao.CategoryDao" %>
<%
    CategoryDao categoryDao = new CategoryDao();
    UtilityDao utilityDao = new UtilityDao();
    List<Category> categoryList = categoryDao.getAll();
    List<Utility> utilities = utilityDao.getAll();
    categoryDao.close();
    utilityDao.close();
%>

<div class="modal fade" id="addRoomModal" tabindex="-1" aria-labelledby="addRoomModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <!-- Header -->
            <div class="modal-header">
                <h5 class="modal-title" id="addRoomModalLabel">Thêm phòng mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>

            <!-- Body -->
            <div class="modal-body">
                <form action="<%=request.getContextPath()%>/landlord/room" method="post" enctype="multipart/form-data">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label">Tên</label>
                            <input type="text" name="name" class="form-control" required>
                        </div>
                        <!-- Category -->
                        <div class="col-md-6">
                            <label class="form-label">Loại phòng</label>
                            <select name="categoryId" class="form-select" required>
                                <option value="">-- Chọn loại phòng --</option>
                                <% for (Category c : categoryList) { %>
                                <option value="<%=c.getId()%>"><%=c.getName()%></option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Province -->
                        <div class="col-md-6">
                            <label class="form-label">Tỉnh/Thành phố</label>
                            <select name="provinceCode" id="provinceSelect" class="form-select" required>
                                <option value="">-- Chọn tỉnh/thành phố --</option>
                            </select>
                        </div>

                        <!-- District -->
                        <div class="col-md-6 d-none" id="districtWrapper">
                            <label class="form-label">Quận/Huyện</label>
                            <select name="districtCode" id="districtSelect" class="form-select" required>
                                <option value="">-- Chọn quận/huyện --</option>
                            </select>
                        </div>

                        <!-- Ward -->
                        <div class="col-md-6 d-none" id="wardWrapper">
                            <label class="form-label">Xã/Phường</label>
                            <select name="wardCode" id="wardSelect" class="form-select" required>
                                <option value="">-- Chọn xã/phường --</option>
                            </select>
                        </div>

                        <!-- Street -->
                        <div class="col-md-12">
                            <label class="form-label">Địa chỉ (đường, ngõ...)</label>
                            <input type="text" name="street" class="form-control" required>
                        </div>

                        <!-- Map Embed -->
                        <div class="col-md-12">
                            <label class="form-label">Google Maps Embed URL</label>
                            <input type="text" name="mapEmbedUrl" class="form-control">
                        </div>

                        <!-- Images -->
                        <div class="col-md-12">
                            <label class="form-label">Hình ảnh</label>
                            <input type="file" name="images" class="form-control" multiple accept="image/*" required>
                        </div>

                        <!-- Bedrooms, Bathrooms -->

                        <div class="col-md-4">
                            <label class="form-label">Phòng ngủ</label>
                            <input type="number" name="bedrooms" class="form-control" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Phòng tắm</label>
                            <input type="number" name="bathrooms" class="form-control" min="0" required>
                        </div>

                        <!-- Price & Area -->
                        <div class="col-md-6">
                            <label class="form-label">Giá (VNĐ)</label>
                            <input type="number" name="price" class="form-control" step="0.01" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Diện tích (m²)</label>
                            <input type="number" name="area" class="form-control" step="0.1" required>
                        </div>

                        <!-- Utilities -->
                        <div class="col-md-12">
                            <label for="select2-add-utilities" class="form-label">Tiện ích</label>
                            <select id="select2-add-utilities" name="utilityIds" class="form-select" multiple>
                                <% for (Utility u : utilities) { %>
                                <option value="<%=u.getId()%>"><%=u.getName()%></option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Description -->
                        <div class="col-md-12">
                            <label class="form-label">Mô tả</label>
                            <textarea name="description" rows="4" class="form-control"></textarea>
                        </div>
                    </div>

                    <div class="mt-4 text-end">
                        <button type="submit" class="btn btn-primary">Thêm phòng</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- JS load tỉnh/huyện/xã -->
<script>
    $(document).ready(function () {
        $('#select2-add-utilities').select2({
            placeholder: "Chọn tiện ích",
            width: '100%',
            dropdownParent: $('#addRoomModal')
        });
    });
    document.addEventListener("DOMContentLoaded", function () {
        const provinceSelect = document.getElementById("provinceSelect");
        const districtSelect = document.getElementById("districtSelect");
        const wardSelect = document.getElementById("wardSelect");
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
