package Util;

import Dao.CategoryDao;
import Dao.RoomDao;
import Dao.UserDao;
import Dao.UtilityDao;
import Model.Category;
import Model.Constant.Role;
import Model.Room;
import Model.User;
import Model.Utility;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.HashSet;
import java.util.List;

@WebListener
public class StartListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        Config.contextPath = sce.getServletContext().getContextPath();
        init();
    }

    public void init() {
        CategoryDao categoryDao = new CategoryDao();
        Category category1 = new Category("Nhà ở");
        Category category2 = new Category("Căn hộ");
        Category category3 = new Category("Đất đai");
        Category category4 = new Category("Chung cư");
        Category category5 = new Category("Phòng trọ giá rẻ");
        if (categoryDao.getAll().isEmpty()){
            categoryDao.saveAll(List.of(category1, category2, category3, category4, category5));
        }
        UtilityDao utilityDao = new UtilityDao();
        Utility utility1 = new Utility("Bữa sáng miễn phí");
        Utility utility2 = new Utility("Đỗ xe miễn phí");
        Utility utility3 = new Utility("View biển");
        Utility utility4 = new Utility("View sông");
        Utility utility5 = new Utility("Đưa đón sân bay miễn phí");
        Utility utility6 = new Utility("Free wifi");
        Utility utility7 = new Utility("Điều hòa");
        Utility utility8 = new Utility("Spa");
        Utility utility9 = new Utility("Bar");
        if (utilityDao.getAll().isEmpty()){
            utilityDao.saveAll(List.of(utility1, utility2, utility3, utility4, utility5, utility6, utility7, utility8, utility9));
        }
        UserDao userDao = new UserDao();
        User admin = new User("admin@gmail.com", "Đây là admin", "0123456789", "$2a$10$36po8UFhG659JAZ/K./RqOkszfb5wE4H0iDMfJreIaHtRnhzL72oa", "/assets/images/default-avatar.jpg", null, true, false, Role.ADMIN);
        User tenant = new User("tenant@gmail.com", "Đây là tenant", "0123456788", "$2a$10$36po8UFhG659JAZ/K./RqOkszfb5wE4H0iDMfJreIaHtRnhzL72oa", "/assets/images/default-avatar.jpg", null, true, false, Role.TENANT);
        User landlord = new User("landlord@gmail.com", "Đây là landlord", "0123456787", "$2a$10$36po8UFhG659JAZ/K./RqOkszfb5wE4H0iDMfJreIaHtRnhzL72oa", "/assets/images/default-avatar.jpg", null, true, false, Role.LANDLORD);
        if (userDao.getAll().isEmpty()){
            userDao.saveAll(List.of(admin, tenant, landlord));
            // các mk đều là 123456
            try {
                CometChat.register(admin);
                CometChat.register(tenant);
                CometChat.register(landlord);
            } catch (Exception e){
                e.printStackTrace();
            }
        }
        landlord = userDao.findFirstLandlord();
        if (landlord == null) {
            landlord = new User("landlord@gmail.com", "Đây là landlord", "0123456787", "$2a$10$36po8UFhG659JAZ/K./RqOkszfb5wE4H0iDMfJreIaHtRnhzL72oa", "/assets/images/default-avatar.jpg", null, true, false, Role.LANDLORD);
            userDao.save(landlord);
        }
        RoomDao roomDao = new RoomDao();
        if (roomDao.getAll().isEmpty()){
            // create room1
            Room room1 = new Room();
            room1.setLandlord(landlord);
            room1.setCategory(category2);
            room1.setProvinceCode(48);
            room1.setDistrictCode(492);
            room1.setWardCode(20254);
            room1.setStreet("320 đường 2 tháng 9");
            room1.setMapEmbedUrl("<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3834.181500196532!2d108.2189159408836!3d16.05606862013387!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3142196dc2abe2ab%3A0x2bb39e805a9c9b8b!2zQ8SCTiBI4buYIENBTyBD4bqkUCBUSEUgTVVTRSBTw5RORyBIw4BO!5e0!3m2!1svi!2s!4v1758976405500!5m2!1svi!2s\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>");
            room1.setImages(new HashSet<>(List.of("/assets/uploads/room1_1.png", "/assets/uploads/room1_2.jpg")));
            room1.setName("The Muse Đà Nẵng");
            room1.setBedrooms(2);
            room1.setBathrooms(2);
            room1.setPrice(10000000);
            room1.setArea(80);
            room1.setDescription("""
                Tên thương mại dự án: The Muse Đã Nẵng
                Vị trí: Lô A2-1 đường Lê Văn Duyệt, phường Nại Hiên Đông, quận Sơn Trà, TP. Đà Nẵng
                Chủ đầu tư: Công ty Cổ phần Tập đoàn Đông Đô
                Tổng diện tích: 7.167 m2
                Mật độ xây dựng: 45%
                Quy mô: Gồm 2 tòa tháp 36 tầng có chung khối đế và 02 tầng hầm.
                Tổng số căn hộ:  1.196 căn hộ chung cư có 2 – 3 PN.
                Diện tích căn hộ trung bình: 70 m2 – 99,2 m2
                Loại hình phát triển: Căn hộ hiện đại
                Pháp lý: Sổ hồng sở hữu lâu dài
                Dự kiến bàn giao nhà: Quý II/2024
                """);
            room1.setUtilities(new HashSet<>(List.of(utility1, utility2, utility4, utility5, utility7, utility8, utility9)));
            room1.setAvailable(true);
            roomDao.save(room1);

            // create room2
            Room room2 = new Room();
            room2.setLandlord(landlord);
            room2.setCategory(category2);
            room2.setProvinceCode(48);
            room2.setDistrictCode(492);
            room2.setWardCode(20257);
            room2.setStreet("179/20 đường Nguyễn Văn Linh");
            room2.setMapEmbedUrl("<iframe src=\"https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d7668.229845386942!2d108.2048553!3d16.0595251!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x314219ca067e08c9%3A0x91531c1d5eb42c26!2zVGltZXMgQXBhcnRtZW50IMSQw6AgTuG6tW5n!5e0!3m2!1svi!2s!4v1758977987237!5m2!1svi!2s\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>");
            room2.setImages(new HashSet<>(List.of("/assets/uploads/room2_1.jpg", "/assets/uploads/room2_2.webp", "/assets/uploads/room2_3.webp", "/assets/uploads/room2_4.webp")));
            room2.setName("Times Apartment Đà Nẵng");
            room2.setBedrooms(1);
            room2.setBedrooms(1);
            room2.setPrice(5000000);
            room2.setArea(50);
            room2.setDescription("""
                🔥 𝐓𝐈𝐌𝐄𝐒 𝐇𝐎𝐓𝐄𝐋 &𝐀𝐏𝐀𝐑𝐓𝐌𝐄𝐍𝐓 🔥 - Một sản phẩm của 𝐓𝐢𝐦𝐞𝐬 𝐓𝐫𝐚𝐯𝐞𝐥
                 CĂN HỘ SÁT BIỂN ĐÀ NẴNG, MỚI 100%, ƯU ĐÃI CỰC TỐT!
                 🏖 Vị trí đắc địa, 𝗰𝗵𝗶̉ 𝗺𝗮̂́𝘁 𝟮-𝟯 𝗽𝗵𝘂́𝘁 đ𝗶 𝗯𝗼̣̂ 𝗿𝗮 𝗯𝗶𝗲̂̉𝗻
                 🏖 Trang bị đầy đủ cơ sở vật chất tiện nghi hiện đại, nội thất cao cấp, 𝗺𝗼̛́𝗶 𝟭𝟬𝟬%
                 ✓ Điều hòa, wifi riêng từng phòng, TV Samsung màn hình Led, tủ lạnh, máy giặt sấy, lò vi sóng, bình siêu tốc, máy sấy tóc
                 ✓ Có thang máy
                 ✓ Tiện nghi bếp trang bị đầy đủ
                 🏖 Nhiều tiện tích MIỄN PHÍ:
                 ✓ Wifi, nước, máy nước nóng, truyền hình cáp và bãi đậu xe
                 ✓ Dịch vụ dọn phòng miễn phí 1 lần/1 tuần
                 ✓ Lắp đặt CCTV toàn tòa nhà. Bảo mật 24/7
                 🏖 Có nhiều dạng phòng từ 𝟯𝟬-𝟱𝟬𝗺𝟮, phù hợp cho gia đình từ 3-5 người, cặp đôi, người có nhu cầu công tác, nghĩ dưỡng tại Đà Nẵng.
                 🏖 Cafe rooftop ngắm biển từ sáng đến đêm
                 Times Hotel & Apartment chắn chắn làm thoả mãn những tín đồ đang tìm chốn nghỉ dưỡng và tận hưởng không gian làm việc yên bình tại thành phố biển xinh đẹp.
                """);
            room2.setUtilities(new HashSet<>(List.of(utility2, utility3, utility4, utility5, utility6, utility7, utility8, utility9)));
            room2.setAvailable(true);
            roomDao.save(room2);
        }
    }
}
