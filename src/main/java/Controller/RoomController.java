package Controller;

import Dao.CategoryDao;
import Dao.RoomDao;
import Dao.UtilityDao;
import Model.Category;
import Model.Room;
import Model.User;
import Model.Utility;
import Util.UploadImage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;

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
            double price = Double.parseDouble(req.getParameter("price"));
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
            room.setAvailable(true);
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
            double price = Double.parseDouble(req.getParameter("price"));
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
}
