package Dao;

import Model.Room;
import Model.User;
import jakarta.persistence.TypedQuery;

import java.util.List;

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
}
