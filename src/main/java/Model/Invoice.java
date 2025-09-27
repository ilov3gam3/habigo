package Model;

import Model.Constant.InvoiceType;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "invoices")
public class Invoice extends DistributedEntity {
    private InvoiceType type;
    private long amount;
    private String description;
    // ==== Nhóm thông tin từ Casso ====
    private String reference;        // MA_GIAO_DICH_THU_NGHIEM
    private String transactionId;    // id Casso gửi về (đôi khi quan trọng để idempotent)
    private String accountNumber;    // 88888888 (số tài khoản nhận)
    private String bankName;         // VPBank
    private String bankAbbreviation; // VPB

    private String counterAccountName;   // NGUYEN VAN A
    private String counterAccountNumber; // 8888888888
    private String counterAccountBankId; // 970415
    private String counterAccountBankName; // VietinBank

    private LocalDateTime transactionDateTime; // 2025-09-27 19:09:03

    private Long runningBalance; // Số dư của tài khoản nhận sau giao dịch (thường chỉ để tham khảo)
    private String cassoRawData;
}
