package Dao;

import Model.RoommatePost;
import Model.User;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class RoommatePostDao extends GenericDao<RoommatePost>{
    public List<RoommatePost> getPostsOfUser(User user){
        TypedQuery<RoommatePost> roommatePostTypedQuery = entityManager.createQuery("select r from RoommatePost r where r.tenant = :user", RoommatePost.class);
        roommatePostTypedQuery.setParameter("user", user);
        return roommatePostTypedQuery.getResultList();
    }
    public List<RoommatePost> getAllWithUser() {
        return entityManager.createQuery("SELECT r FROM RoommatePost r JOIN FETCH r.tenant", RoommatePost.class)
                .getResultList();
    }
    public List<RoommatePost> get5NewestWithUser() {
        return entityManager.createQuery("SELECT r FROM RoommatePost r JOIN FETCH r.tenant order by r.id desc", RoommatePost.class)
                .setMaxResults(5)
                .getResultList();
    }
}
