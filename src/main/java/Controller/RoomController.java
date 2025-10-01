package Controller;

import Dao.CategoryDao;
import Dao.PaymentDao;
import Dao.RoomDao;
import Dao.UtilityDao;
import Model.*;
import Util.Config;
import Util.UploadImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

public class RoomController {
    @WebServlet("/landlord/room")
    @MultipartConfig
    public static class LandlordRoomServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long categoryId = Long.parseLong(req.getParameter("categoryId"));
            CategoryDao categoryDao = new CategoryDao();
            Category category = categoryDao.getById(categoryId);

            int provinceCode = Integer.parseInt(req.getParameter("provinceCode"));
            int districtCode = Integer.parseInt(req.getParameter("districtCode"));
            int wardCode = Integer.parseInt(req.getParameter("wardCode"));
            String street = req.getParameter("street");
            String mapEmbedUrl = req.getParameter("mapEmbedUrl");
            List<String> images = UploadImage.multipleFileUpload(req, "images");
            String name = req.getParameter("name");
            int bedrooms = Integer.parseInt(req.getParameter("bedrooms"));
            int bathrooms = Integer.parseInt(req.getParameter("bathrooms"));
            long price = Long.parseLong(req.getParameter("price"));
            float area = Float.parseFloat(req.getParameter("area"));
            String description = req.getParameter("description");

            List<Long> utilityIds = Optional.ofNullable(req.getParameterValues("utilityIds")).stream()
                    .flatMap(Arrays::stream)
                    .map(Long::parseLong)
                    .toList();

            UtilityDao utilityDao = new UtilityDao();
            List<Utility> utilities = utilityDao.getByIds(utilityIds);

            User landlord = (User) req.getSession().getAttribute("user");

            Room room = new Room();
            room.setLandlord(landlord);
            room.setCategory(category);
            room.setProvinceCode(provinceCode);
            room.setDistrictCode(districtCode);
            room.setWardCode(wardCode);
            room.setStreet(street);
            room.setMapEmbedUrl(mapEmbedUrl);
            room.setImages(new HashSet<>(images));
            room.setName(name);
            room.setBedrooms(bedrooms);
            room.setBathrooms(bathrooms);
            room.setPrice(price);
            room.setArea(area);
            room.setDescription(description);
            room.setUtilities(new HashSet<>(utilities));

            PaymentDao paymentDao = new PaymentDao();
            long purchasedSlots = paymentDao.countNormalSlots(landlord);
            paymentDao.close();

            long totalSlots = Config.freePost + purchasedSlots;

            RoomDao roomDao = new RoomDao();
            long availablePosts = roomDao.countNormalRooms(landlord);

            if (availablePosts < totalSlots) {
                room.setAvailable(true);
            } else {
                room.setAvailable(false);
            }
            room.setPremium(false);
            roomDao.save(room);

            // đóng dao
            categoryDao.close();
            utilityDao.close();
            roomDao.close();

            req.getSession().setAttribute("success", "Thêm phòng thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }

    @WebServlet("/landlord/update-room")
    @MultipartConfig
    public static class UpdateRoom extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long roomId = Long.parseLong(req.getParameter("roomId"));
            long categoryId = Long.parseLong(req.getParameter("categoryId"));

            CategoryDao categoryDao = new CategoryDao();
            Category category = categoryDao.getById(categoryId);

            int provinceCode = Integer.parseInt(req.getParameter("provinceCode"));
            int districtCode = Integer.parseInt(req.getParameter("districtCode"));
            int wardCode = Integer.parseInt(req.getParameter("wardCode"));
            String street = req.getParameter("street");
            String mapEmbedUrl = req.getParameter("mapEmbedUrl");

            String name = req.getParameter("name");
            int bedrooms = Integer.parseInt(req.getParameter("bedrooms"));
            int bathrooms = Integer.parseInt(req.getParameter("bathrooms"));
            long price = Long.parseLong(req.getParameter("price"));
            float area = Float.parseFloat(req.getParameter("area"));
            String description = req.getParameter("description");

            List<Long> utilityIds = Optional.ofNullable(req.getParameterValues("utilityIds")).stream()
                    .flatMap(Arrays::stream)
                    .map(Long::parseLong)
                    .toList();

            UtilityDao utilityDao = new UtilityDao();
            List<Utility> utilities = utilityDao.getByIds(utilityIds);

            User landlord = (User) req.getSession().getAttribute("user");

            RoomDao roomDao = new RoomDao();
            Room room = roomDao.getById(roomId);

            room.setLandlord(landlord);
            room.setCategory(category);
            room.setProvinceCode(provinceCode);
            room.setDistrictCode(districtCode);
            room.setWardCode(wardCode);
            room.setStreet(street);
            room.setMapEmbedUrl(mapEmbedUrl);

            if (req.getPart("image") != null && req.getPart("image").getSize() > 0) {
                List<String> images = UploadImage.multipleFileUpload(req, "images");
                room.setImages(new HashSet<>(images));
            }

            room.setName(name);
            room.setBedrooms(bedrooms);
            room.setBathrooms(bathrooms);
            room.setPrice(price);
            room.setArea(area);
            room.setDescription(description);
            room.setUtilities(new HashSet<>(utilities));
            room.setAvailable(true);

            roomDao.save(room);

            // đóng dao
            categoryDao.close();
            utilityDao.close();
            roomDao.close();

            req.getSession().setAttribute("success", "Cập nhật thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }

    @WebServlet("/room-detail")
    public static class RoomDetail extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/public/room-detail.jsp").forward(req, resp);
        }
    }

    @WebServlet("/search")
    public static class SearchRoom extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String searchString = request.getParameter("q");
            String categoryIdStr = request.getParameter("categoryId");
            String provinceCodeStr = request.getParameter("provinceCode");
            String[] utilityIdsStr = request.getParameterValues("utilities");
            String priceMinStr = request.getParameter("priceMin");
            String priceMaxStr = request.getParameter("priceMax");

            Long categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty())
                    ? Long.parseLong(categoryIdStr) : null;
            Integer provinceCode = (provinceCodeStr != null && !provinceCodeStr.isEmpty())
                    ? Integer.parseInt(provinceCodeStr) : null;

            Set<Long> utilityIds = null;
            if (utilityIdsStr != null && utilityIdsStr.length > 0) {
                utilityIds = new HashSet<>();
                for (String u : utilityIdsStr) {
                    utilityIds.add(Long.parseLong(u));
                }
            }

            Double priceMin = (priceMinStr != null && !priceMinStr.isEmpty())
                    ? Double.parseDouble(priceMinStr) : null;
            Double priceMax = (priceMaxStr != null && !priceMaxStr.isEmpty())
                    ? Double.parseDouble(priceMaxStr) : null;

            RoomDao roomDao = new RoomDao();
            CategoryDao categoryDao = new CategoryDao();
            UtilityDao utilityDao = new UtilityDao();

            List<Room> rooms = roomDao.searchRooms(searchString, categoryId, provinceCode, utilityIds, priceMin, priceMax);

            request.setAttribute("categoryList", categoryDao.getAll());
            request.setAttribute("utilities", utilityDao.getAll());
            request.setAttribute("rooms", rooms);

            // đóng dao
            roomDao.close();
            categoryDao.close();
            utilityDao.close();

            request.getRequestDispatcher("/views/public/search.jsp").forward(request, response);
        }
    }

    @WebServlet("/landlord/change-status")
    public static class ChangeStatus extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            User landlord = (User) req.getSession().getAttribute("user");

            RoomDao roomDao = new RoomDao();
            Room room = roomDao.getById(id);

            if (room == null || !room.getLandlord().equals(landlord)) {
                roomDao.close();
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền thay đổi phòng này");
                return;
            }

            if (!room.isAvailable()) {
                PaymentDao paymentDao = new PaymentDao();
                long purchasedSlots = paymentDao.countNormalSlots(landlord);
                paymentDao.close();

                long totalSlots = Config.freePost + purchasedSlots;
                long availablePosts = roomDao.countNormalRooms(landlord);

                if (availablePosts < totalSlots) {
                    room.setAvailable(true);
                    roomDao.update(room);
                } else {
                    roomDao.close();
                    req.getSession().setAttribute("error", "Bạn đã đạt giới hạn số bài hiển thị.");
                    resp.sendRedirect(req.getHeader("referer"));
                    return;
                }
            } else {
                room.setAvailable(false);
                roomDao.update(room);
            }

            roomDao.close();
            req.getSession().setAttribute("success", "Thay đổi trạng thái thành công.");
            resp.sendRedirect(req.getHeader("referer"));
        }
    }

    @WebServlet("/landlord/change-premium")
    public static class ChangePremiumServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long id = Long.parseLong(req.getParameter("id"));
            User landlord = (User) req.getSession().getAttribute("user");

            RoomDao roomDao = new RoomDao();
            PaymentDao paymentDao = new PaymentDao();

            Room room = roomDao.getById(id);

            if (room == null || !room.getLandlord().equals(landlord)) {
                roomDao.close();
                paymentDao.close();
                req.getSession().setAttribute("error", "Phòng không tồn tại hoặc bạn không có quyền.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }

            if (!room.isPremium()) {
                long purchasedPremiumSlots = paymentDao.countPremiumSlots(landlord);
                long premiumRooms = roomDao.countPremiumRooms(landlord);

                if (premiumRooms < purchasedPremiumSlots) {
                    room.setPremium(true);
                    roomDao.update(room);
                    req.getSession().setAttribute("success", "Bật Premium thành công.");
                } else {
                    req.getSession().setAttribute("error", "Bạn đã đạt giới hạn số bài Premium.");
                }
            } else {
                room.setPremium(false);
                roomDao.update(room);
                req.getSession().setAttribute("success", "Tắt Premium thành công.");
            }

            roomDao.close();
            paymentDao.close();

            resp.sendRedirect(req.getHeader("referer"));
        }
    }
}
