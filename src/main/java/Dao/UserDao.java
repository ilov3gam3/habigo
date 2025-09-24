package Dao;

import Model.User;
import jakarta.persistence.TypedQuery;

public class UserDao extends GenericDao<User> {
    public User findByEmail(String email) {
        TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
        query.setParameter("email", email);
        return query.getResultStream().findFirst().orElse(null);
    }

    public User findByPhone(String phone) {
        TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.phone = :phone", User.class);
        query.setParameter("phone", phone);
        return query.getResultStream().findFirst().orElse(null);
    }
    public User findByToken(String token){
        TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.token = :token", User.class);
        query.setParameter("token", token);
        return query.getResultStream().findFirst().orElse(null);
    }
    public User findByEmailExcept(String newEmail, Long excludeId) {
        TypedQuery<User> query = entityManager.createQuery(
                "SELECT u FROM User u WHERE u.email = :email AND u.id != :excludeId", User.class);
        query.setParameter("email", newEmail);
        query.setParameter("excludeId", excludeId);
        return query.getResultStream().findFirst().orElse(null);
    }

    public User findByPhoneExcept(String newPhone, Long excludeId) {
        TypedQuery<User> query = entityManager.createQuery(
                "SELECT u FROM User u WHERE u.phone = :phone AND u.id != :excludeId", User.class);
        query.setParameter("phone", newPhone);
        query.setParameter("excludeId", excludeId);
        return query.getResultStream().findFirst().orElse(null);
    }
}
