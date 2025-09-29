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
            Category category = new CategoryDao().getById(categoryId);
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
            List<Long> utilityIds = Optional.ofNullable(req.getParameterValues("utilityIds")).stream().flatMap(Arrays::stream)
                    .map(Long::parseLong)
                    .toList();
            List<Utility> utilities = new UtilityDao().getByIds(utilityIds);
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
            room.setUtilities(utilities);
            long purchasedSlots = new PaymentDao().countNormalSlots(landlord);
            long totalSlots = Config.freePost + purchasedSlots;
            long availablePosts = new RoomDao().countNormalRooms(landlord);
            if (availablePosts < totalSlots) {
                room.setAvailable(true);
            } else {
                room.setAvailable(false);
            }
            room.setPremium(false);
            new RoomDao().save(room);
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
            Category category = new CategoryDao().getById(categoryId);
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
            List<Long> utilityIds = Optional.ofNullable(req.getParameterValues("utilityIds")).stream().flatMap(Arrays::stream)
                    .map(Long::parseLong)
                    .toList();
            List<Utility> utilities = new UtilityDao().getByIds(utilityIds);
            User landlord = (User) req.getSession().getAttribute("user");

            Room room = new RoomDao().getById(roomId);
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
            room.setUtilities(utilities);
            room.setAvailable(true);
            new RoomDao().save(room);
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
    public static class SearchRoom extends HttpServlet{
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

            // gán categories và utilities cho form
            request.setAttribute("categoryList", categoryDao.getAll());
            request.setAttribute("utilities", utilityDao.getAll());
            request.setAttribute("rooms", rooms);

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
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền thay đổi phòng này");
                return;
            }

            if (!room.isAvailable()) {
                // đang false, muốn bật lên true -> kiểm tra quota
                long purchasedSlots = new PaymentDao().countNormalSlots(landlord);
                long totalSlots = Config.freePost + purchasedSlots;
                long availablePosts = roomDao.countNormalRooms(landlord);

                if (availablePosts < totalSlots) {
                    room.setAvailable(true);  // còn slot thì bật
                    roomDao.update(room);
                } else {
                    req.getSession().setAttribute("error", "Bạn đã đạt giới hạn số bài hiển thị.");
                    resp.sendRedirect(req.getHeader("referer"));
                    return;
                }
            } else {
                // đang true, muốn tắt -> luôn cho phép
                room.setAvailable(false);
                roomDao.update(room);
            }
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
                req.getSession().setAttribute("error", "Phòng không tồn tại hoặc bạn không có quyền.");
                resp.sendRedirect(req.getHeader("referer"));
                return;
            }

            if (!room.isPremium()) {
                // đang false, muốn bật premium -> kiểm tra quota
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
                // đang true, muốn tắt premium -> luôn cho phép
                room.setPremium(false);
                roomDao.update(room);
                req.getSession().setAttribute("success", "Tắt Premium thành công.");
            }

            resp.sendRedirect(req.getHeader("referer"));
        }
    }

}
