package Model.Constant;

public enum Status {
    PENDING, // contract được tạo
    DEPOSITED, // tenant cọc
    NEGOTIATING, // landlord chuyển trạng thái qua đàm phán
    CANCELLED, // ai là ng được cancel
    CONFIRMED, // ai là ng được confirm
    PAID // sau khi confirm tenant paid
}
