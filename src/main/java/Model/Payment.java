package Model;

import Model.Constant.SlotType;
import Model.Constant.TransactionStatus;
import jakarta.persistence.*;
import lombok.*;

import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "payments")
@ToString
public class Payment extends DistributedEntity{

    @ManyToOne
    @JoinColumn(name = "landlord_id")
    private User landlord;
    private long amount;
    @Enumerated(EnumType.STRING)
    private SlotType slotType;
    private int quantity;
    public String txnRef;
    public String orderInfo;
    public String bankCode;
    public String transactionNo;
    @Enumerated(EnumType.STRING)
    public TransactionStatus transactionStatus;
    public String cardType;
    public String bankTranNo;
    public Timestamp paid_at;
}
