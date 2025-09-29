<%@ page import="Util.Config" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<div class="modal fade" id="buySlotModal" tabindex="-1" aria-labelledby="buySlotModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form method="get" action="<%=request.getContextPath()%>/tenant/get-vnpay-url" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="buySlotModalLabel">Mua thêm slot</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="slotType" class="form-label">Loại slot</label>
                    <select class="form-select" name="slotType" id="slotType" required>
                        <option value="NORMAL">Normal (<%=Config.pricePerPost%>/slot)</option>
                        <option value="PREMIUM">Premium (<%=Config.premiumPrice%>/slot)</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="quantity" class="form-label">Số lượng</label>
                    <input type="number" name="quantity" id="quantity" class="form-control" min="1" value="1" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Thanh toán</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </form>
    </div>
</div>
