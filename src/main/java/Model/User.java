package Model;

import Model.Constant.Role;
import Util.Config;
import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "users")
public class User extends DistributedEntity {
    @Column(unique = true, nullable = false)
    private String email;
    @Column(columnDefinition = "VARCHAR(255)")
    private String name;
    @Column(unique = true, nullable = false)
    private String phone;
    private String password;
    private String avatar;
    private String token;
    private boolean isVerified;
    private boolean isBlocked;
    @Enumerated(EnumType.STRING)
    private Role role;
    public String getAvatar(){
        if (this.avatar.startsWith("http")){
            return this.avatar;
        } else {
            return Config.app_url + Config.contextPath + this.avatar;
        }
    }
}
