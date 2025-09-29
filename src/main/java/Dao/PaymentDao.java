package Dao;

import Model.Constant.SlotType;
import Model.Constant.TransactionStatus;
import Model.Payment;
import Model.User;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class PaymentDao extends GenericDao<Payment>{
    public Payment findByOrderInfo(String orderInfo){
        TypedQuery<Payment> query = entityManager.createQuery("select p from Payment p where p.orderInfo = :orderInfo", Payment.class);
        query.setParameter("orderInfo", orderInfo);
        return query.getSingleResult();
    }
    public long countNormalSlots(User landlord) {
        TypedQuery<Long> query = entityManager.createQuery(
                "select coalesce(sum(p.quantity), 0) " +
                        "from Payment p " +
                        "where p.landlord = :landlord " +
                        "and p.transactionStatus = :status " +
                        "and p.slotType = :slotType",
                Long.class
        );
        query.setParameter("landlord", landlord);
        query.setParameter("status", TransactionStatus.SUCCESS);
        query.setParameter("slotType", SlotType.NORMAL);
        return query.getSingleResult();
    }
    public long countPremiumSlots(User landlord) {
        TypedQuery<Long> query = entityManager.createQuery(
                "select coalesce(sum(p.quantity), 0) " +
                        "from Payment p " +
                        "where p.landlord = :landlord " +
                        "and p.transactionStatus = :status " +
                        "and p.slotType = :slotType",
                Long.class
        );
        query.setParameter("landlord", landlord);
        query.setParameter("status", TransactionStatus.SUCCESS);
        query.setParameter("slotType", SlotType.PREMIUM);
        return query.getSingleResult();
    }
    public List<Payment> getPaymentsOfLandlord(User landlord){
        TypedQuery<Payment> paymentTypedQuery = entityManager.createQuery("select p from Payment p where p.landlord = :landlord", Payment.class);
        return paymentTypedQuery.setParameter("landlord", landlord).getResultList();
    }
}
