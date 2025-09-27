package Controller;

import Dao.ContractDao;
import Dao.RoomDao;
import Model.Constant.Status;
import Model.Contract;
import Model.Room;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

public class ContractController {
    @WebServlet("/tenant/create-contract")
    public static class CreateContract extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            User tenant = (User) req.getSession().getAttribute("tenant");
            long id = Long.parseLong(req.getParameter("id"));
            Room room = new RoomDao().getById(id);
            LocalDate startDate = LocalDate.parse(req.getParameter("fromDate"));
            LocalDate endDate = LocalDate.parse(req.getParameter("toDate"));
            Contract contract = new Contract();
            contract.setTenant(tenant);
            contract.setStartDate(startDate);
            contract.setEndDate(endDate);
            contract.setRoom(room);
            contract.setPrice(room.getPrice());
            contract.setStatus(Status.PENDING);
            new ContractDao().save(contract);
            req.getSession().setAttribute("success", "Tạo hợp đồng thành công, vui lòng thanh toán phí đặt cọc.");
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    @WebServlet("/landlord/change-contract-status")
    public static class ChangeContractStatus extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            Contract contract = new ContractDao().getById(id);
            contract.setStatus(Status.valueOf(req.getParameter("status")));
            new ContractDao().update(contract);
            req.getSession().setAttribute("success", "Tạo hợp đồng thành công, vui lòng thanh toán phí đặt cọc.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
