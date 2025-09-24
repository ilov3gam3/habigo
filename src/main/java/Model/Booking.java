package Model;

import Model.Constant.Status;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "bookings")
public class Booking extends DistributedEntity {
    @ManyToOne
    @JoinColumn(name = "tenant_id", nullable = false)
    private User tenant; // Người thuê (role = TENANT)

    @ManyToOne
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @Column(nullable = false)
    private LocalDate startDate;

    @Column(nullable = true)
    private LocalDate endDate;

    @Column(nullable = false)
    private Double pricePerMonth;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Status status;
}
