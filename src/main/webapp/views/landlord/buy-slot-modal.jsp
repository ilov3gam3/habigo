<%@ page import="Util.Config" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<style>
    .blinking {
        animation: blinker 1s linear infinite;
    }

    @keyframes blinker {
        50% {
            opacity: 0.5;
        }
    }
</style>
<div class="modal fade" id="buySlotModal" tabindex="-1" aria-labelledby="buySlotModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form id="buySlotForm" class="modal-content">
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
                <div class="mb-3">
                    <label for="method" class="form-label">Phương thức thanh toán</label>
                    <select class="form-select" id="method" name="method" required>
                        <option value="VNPAY">VNPay</option>
                        <option value="QR">Chuyển khoản QR</option>
                    </select>
                </div>
                <!-- Khu vực hiển thị QR code -->
                <div id="qrArea" class="text-center mt-3"></div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Thanh toán</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const form = document.getElementById("buySlotForm");
        form.addEventListener("submit", async (e) => {
            e.preventDefault();

            const slotType = document.getElementById("slotType").value;
            const quantity = document.getElementById("quantity").value;
            const method = document.getElementById("method").value;
            const qrArea = document.getElementById("qrArea");
            qrArea.innerHTML = ""; // clear cũ

            if (method === "VNPAY") {
                // đi luồng VNPay cũ
                window.location.href = `<%=request.getContextPath()%>/tenant/get-vnpay-url?slotType=\${slotType}&quantity=\${quantity}`;
            } else {
                // Gọi servlet QR
                const formData = new FormData();
                formData.append("slotType", slotType);
                formData.append("quantity", quantity);

                const res = await fetch("<%=request.getContextPath()%>/tenant/casso-create", {
                    method: "POST",
                    body: formData
                });
                const data = await res.json();

                // Hiện QR code + nút kiểm tra
                                qrArea.innerHTML = `
                    <div class="d-flex flex-column align-items-center">
                        <p class="mb-2">Quét QR để thanh toán:</p>
                        <img src="\${data.qrCode}" class="w-100 mb-3" style="max-width:300px;">
                        <button id="checkPaymentBtn" type="button" class="btn btn-success mt-2">Kiểm tra giao dịch</button>
                    </div>
                `;

                const checkBtn = document.getElementById("checkPaymentBtn");
                checkBtn.addEventListener("click", () => {
                    // disable nút + thêm hiệu ứng nhấp nháy
                    checkBtn.disabled = true;
                    checkBtn.classList.add("blinking");
                    checkBtn.innerText = "Đang kiểm tra...";

                    const interval = setInterval(async () => {
                        const r = await fetch("<%=request.getContextPath()%>/tenant/check-payment?orderInfo=" + data.orderInfo);
                        const j = await r.json();
                        if (j.status === "SUCCESS") {
                            clearInterval(interval);
                            toastr.success("Thanh toán thành công!");
                            const modal = bootstrap.Modal.getInstance(document.getElementById("buySlotModal"));
                            modal.hide();
                            setTimeout(() => window.location.reload(), 1000);
                        }
                    }, 1000);
                });

            }
        });
    });
</script>
