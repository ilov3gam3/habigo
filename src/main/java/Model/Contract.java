package Model;

import Model.Constant.Status;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "contracts")
public class Contract extends DistributedEntity {
    @ManyToOne
    @JoinColumn(name = "tenant_id", nullable = false)
    private User tenant;

    @ManyToOne
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @Column(nullable = false)
    private LocalDate startDate;

    private LocalDate endDate;

    private long price;

    private Status status;

    @OneToMany
    private List<Invoice> invoices;

}
