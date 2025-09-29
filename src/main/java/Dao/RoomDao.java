package Dao;

import Model.Room;
import Model.User;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;

import java.util.List;
import java.util.Set;

public class RoomDao extends GenericDao<Room> {
    public List<Room> getRoomsOfUser(User user) {
        TypedQuery<Room> typedQuery = entityManager.createQuery("select r from Room r LEFT JOIN FETCH r.images left join fetch r.utilities where r.landlord = :user", Room.class);
        typedQuery.setParameter("user", user);
        return typedQuery.getResultList();
    }
    public List<Room> get5LatestRooms(){
        TypedQuery<Room> typedQuery = entityManager.createQuery("select r from Room r order by r.id desc", Room.class);
        typedQuery.setMaxResults(5);
        return typedQuery.getResultList();
    }
    public List<Room> searchRooms(String searchString,
                                  Long categoryId,
                                  Integer provinceCode,
                                  Set<Long> utilityIds,
                                  Double priceMin,
                                  Double priceMax) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<Room> cq = cb.createQuery(Room.class);
        Root<Room> room = cq.from(Room.class);
        room.fetch("images", JoinType.LEFT);
        room.fetch("utilities", JoinType.LEFT);
        Predicate predicate = cb.or(
                cb.isTrue(room.get("isAvailable")),
                cb.isTrue(room.get("isPremium"))
        );

        // searchString
        if (searchString != null && !searchString.trim().isEmpty()) {
            String pattern = "%" + searchString.trim().toLowerCase() + "%";
            Predicate nameLike = cb.like(cb.lower(room.get("name")), pattern);
            Predicate descLike = cb.like(cb.lower(room.get("description")), pattern);
            predicate = cb.and(predicate, cb.or(nameLike, descLike));
        }

        // category
        if (categoryId != null) {
            predicate = cb.and(predicate,
                    cb.equal(room.get("category").get("id"), categoryId));
        }

        // provinceCode
        if (provinceCode != null) {
            predicate = cb.and(predicate,
                    cb.equal(room.get("provinceCode"), provinceCode));
        }

        // utilities
        if (utilityIds != null && !utilityIds.isEmpty()) {
            Join<Object, Object> utilJoin = room.join("utilities");
            predicate = cb.and(predicate,
                    utilJoin.get("id").in(utilityIds));
            cq.distinct(true);
        }

        // price range
        if (priceMin != null) {
            predicate = cb.and(predicate, cb.greaterThanOrEqualTo(room.get("price"), priceMin));
        }
        if (priceMax != null) {
            predicate = cb.and(predicate, cb.lessThanOrEqualTo(room.get("price"), priceMax));
        }

        cq.select(room).where(predicate);
        TypedQuery<Room> query = entityManager.createQuery(cq);

        return query.getResultList();
    }

    public long countAvailableRooms(User landlord, int a) {
        TypedQuery<Long> query = entityManager.createQuery(
                "select count(r) from Room r " +
                        "where r.landlord = :landlord and r.isAvailable = true",
                Long.class
        );
        query.setParameter("landlord", landlord);
        return query.getSingleResult();
    }
    // đếm các phòng hiển thị bình thường (available && not premium)
    public long countNormalRooms(User landlord) {
        TypedQuery<Long> query = entityManager.createQuery(
                "select count(r) from Room r " +
                        "where r.landlord = :landlord " +
                        "and r.isAvailable = true " +
                        "and r.isPremium = false",
                Long.class
        );
        query.setParameter("landlord", landlord);
        return query.getSingleResult();
    }

    // đếm các phòng hiển thị premium (available && premium)
    public long countPremiumRooms(User landlord) {
        TypedQuery<Long> query = entityManager.createQuery(
                "select count(r) from Room r " +
                        "where r.landlord = :landlord " +
                        "and r.isAvailable = true " +
                        "and r.isPremium = true",
                Long.class
        );
        query.setParameter("landlord", landlord);
        return query.getSingleResult();
    }
    public List<Room> getAllNormalRooms() {
        TypedQuery<Room> query = entityManager.createQuery(
                "SELECT DISTINCT r FROM Room r LEFT JOIN FETCH r.images left join fetch r.utilities " +
                        "WHERE r.isAvailable = true", Room.class
        );
        return query.getResultList();
    }

    public List<Room> getAllPremiumRooms() {
        TypedQuery<Room> query = entityManager.createQuery(
                "SELECT DISTINCT r FROM Room r LEFT JOIN FETCH r.images left join fetch r.utilities " +
                        "WHERE r.isPremium = true", Room.class
        );
        return query.getResultList();
    }

    public List<Room> getAllNormalAndPremium() {
        TypedQuery<Room> query = entityManager.createQuery(
                "SELECT DISTINCT r FROM Room r LEFT JOIN FETCH r.images left join fetch r.utilities " +
                        "WHERE r.isAvailable = true OR r.isPremium = true", Room.class
        );
        return query.getResultList();
    }
}
