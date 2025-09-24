package Util;

import Dao.CategoryDao;
import Dao.UtilityDao;
import Model.Category;
import Model.Utility;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.List;

@WebListener
public class StartListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        Config.contextPath = sce.getServletContext().getContextPath();
        CategoryDao categoryDao = new CategoryDao();
        if (categoryDao.getAll().isEmpty()){
            Category category1 = new Category("Nhà ở");
            Category category2 = new Category("Căn hộ");
            Category category3 = new Category("Đất đai");
            Category category4 = new Category("Chung cư");
            Category category5 = new Category("Phòng trọ giá rẻ");
            categoryDao.saveAll(List.of(category1, category2, category3, category4, category5));
        }
        UtilityDao utilityDao = new UtilityDao();
        if (utilityDao.getAll().isEmpty()){
            Utility utility1 = new Utility("Bữa sáng miễn phí");
            Utility utility2 = new Utility("Đỗ xe miễn phí");
            Utility utility3 = new Utility("View biển");
            Utility utility4 = new Utility("View sông");
            Utility utility5 = new Utility("Đưa đón sân bay miễn phí");
            Utility utility6 = new Utility("Free wifi");
            Utility utility7 = new Utility("Điều hòa");
            Utility utility8 = new Utility("Spa");
            Utility utility9 = new Utility("Bar");
            utilityDao.saveAll(List.of(utility1, utility2, utility3, utility4, utility5, utility6, utility7, utility8, utility9));
        }
    }
}
