<%@page contentType="text/html" pageEncoding="UTF-8" %>
<div class="modal fade" id="createPostModal" tabindex="-1" aria-labelledby="createPostModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/tenant/post" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="createPostModalLabel">Tạo bài đăng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">

                    <div class="mb-3">
                        <label for="description" class="form-label">Nội dung</label>
                        <textarea class="form-control" id="description" name="description" rows="4" maxlength="1500" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="genderRequirement" class="form-label">Yêu cầu giới tính</label>
                        <select class="form-select" id="genderRequirement" name="genderRequirement">
                            <option value="Any">Không yêu cầu</option>
                            <option value="Male">Nam</option>
                            <option value="Female">Nữ</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="budget" class="form-label">Ngân sách (VNĐ)</label>
                        <input type="number" step="0.01" class="form-control" id="budget" name="budget" required>
                    </div>

                    <div class="mb-3">
                        <label for="location" class="form-label">Địa điểm</label>
                        <input type="text" class="form-control" id="location" name="location" maxlength="255" required>
                    </div>

                    <div class="mb-3">
                        <label for="duration" class="form-label">Thời gian ở</label>
                        <input type="text" class="form-control" id="duration" name="duration" maxlength="255" required>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Đăng bài</button>
                </div>
            </form>
        </div>
    </div>
</div>