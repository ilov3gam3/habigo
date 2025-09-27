package Model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "roommate_posts")
public class RoommatePost extends DistributedEntity {
    @ManyToOne
    @JoinColumn(name = "tenant_id", nullable = false)
    private User tenant;
    @Column(columnDefinition = "VARCHAR(5000)")
    private String description;
    private String genderRequirement;
    private Double budget;
    @Column(columnDefinition = "VARCHAR(255)")
    private String location;
    @Column(columnDefinition = "VARCHAR(255)")
    private String duration;
}
