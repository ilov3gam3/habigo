package Model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "rooms")
public class Room extends DistributedEntity {
    @ManyToOne
    @JoinColumn(name = "landlord_id", nullable = false)
    private User landlord;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    private int provinceCode;
    private int districtCode;
    private int wardCode;
    private String street;
    @Column(length = 1500)
    private String mapEmbedUrl;
    @ElementCollection
    @CollectionTable(
            name = "room_images",
            joinColumns = @JoinColumn(name = "room_id")
    )
    @Column(name = "image_url")
    private Set<String> images;

    private String name;

    private int bedrooms;

    private int bathrooms;

    private Double price;

    private float area;
    @Column(columnDefinition = "VARCHAR(1500)")
    private String description;

    @ManyToMany
    private List<Utility> utilities;

    private boolean isAvailable = true;
}
