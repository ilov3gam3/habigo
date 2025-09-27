package Dao;

import Model.Room;
import Model.User;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;

public class RoomDao extends GenericDao<Room> {
    public List<Room> getRoomsOfUser(User user) {
        TypedQuery<Room> typedQuery = entityManager.createQuery("select r from Room r where r.landlord = :user", Room.class);
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

        Predicate predicate = cb.isTrue(room.get("isAvailable"));

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

    public int getAvailableRooms(Long roomId, LocalDate startDate, LocalDate endDate) {
        // Đếm số hợp đồng giao thoa trong khoảng thời gian
        Long booked = entityManager.createQuery(
                        "SELECT COUNT(c) " +
                                "FROM Contract c " +
                                "WHERE c.room.id = :roomId " +
                                "AND c.startDate <= :endDate " +
                                "AND c.endDate >= :startDate", Long.class)
                .setParameter("roomId", roomId)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getSingleResult();

        // Lấy tổng số phòng có sẵn
        Room room = entityManager.find(Room.class, roomId);
        int total = room.getQuantity();

        return total - booked.intValue();
    }

}
