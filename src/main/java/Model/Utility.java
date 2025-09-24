package Model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "utilities")
public class Utility extends DistributedEntity{
    @Column(columnDefinition = "VARCHAR(255)")
    private String name;
}
