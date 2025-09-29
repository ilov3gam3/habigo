package Controller;

import Dao.RoomDao;
import Model.Room;
import Model.User;
import Model.Utility;
import Util.CometChat;
import Util.Config;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class AIController {
    @WebServlet("/ask-room-ai")
    @MultipartConfig
    public static class AskRoomAI extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/public/AI.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            String promptUser = req.getParameter("prompt");
            List<Room> rooms = new RoomDao().getAllNormalAndPremium(); // cần hàm này

            JSONArray roomArray = new JSONArray();
            for (Room r : rooms) {
                JSONObject obj = new JSONObject();
                obj.put("id", r.getId());
                obj.put("name", r.getName());
                obj.put("price", r.getPrice());
                obj.put("area", r.getArea());
                obj.put("bedrooms", r.getBedrooms());
                obj.put("bathrooms", r.getBathrooms());
                obj.put("utilities", String.join(",", r.getUtilities().stream().map(Utility::getName).toList()));

                // Lấy tên tỉnh, quận, xã
                String province = getProvinceName(r.getProvinceCode());
                String district = getDistrictName(r.getDistrictCode());
                String ward = getWardName(r.getWardCode());
                String location = String.format("%s, %s, %s, %s",
                        r.getStreet() != null ? r.getStreet() : "",
                        ward, district, province);
                obj.put("location", location.trim());

                roomArray.put(obj);
            }

            String prompt = String.format("""
        Danh sách phòng hiện có:
        %s

        Yêu cầu của người dùng:
        %s

        Nhiệm vụ:
        1. Phân tích yêu cầu người dùng bằng tiếng Việt.
        2. Chọn ra tối đa 5 phòng phù hợp nhất (theo id).
        3. Trả về JSON:
        {
          "analysis": "Phân tích bằng tiếng Việt...",
          "recommendedIds": [id1, id2, ...]
        }
        """, roomArray.toString(2), promptUser);

            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json");

            try {
                System.out.println(prompt);
                String aiResponse = askAI(prompt);

                // parse response AI -> JSON object
                JSONObject result = new JSONObject(aiResponse);
                // attach lại room list để FE render
                result.put("rooms", roomArray);

                resp.getWriter().write(result.toString());
            } catch (Exception e) {
                e.printStackTrace();
                resp.getWriter().write("{\"error\":\"Lỗi khi sử dụng AI\"}");
            }
        }

        private String getProvinceName(int code) throws IOException {
            return fetchName("https://provinces.open-api.vn/api/v1/p/" + code);
        }

        private String getDistrictName(int code) throws IOException {
            return fetchName("https://provinces.open-api.vn/api/v1/d/" + code);
        }

        private String getWardName(int code) throws IOException {
            return fetchName("https://provinces.open-api.vn/api/v1/w/" + code);
        }

        private String fetchName(String urlStr) throws IOException {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            if (conn.getResponseCode() != 200) return "";

            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                JSONObject json = new JSONObject(sb.toString());
                return json.optString("name", "");
            }
        }

        private String askAI(String promptText) throws Exception {
            String apiKey = Config.gemini_api_key;
            JSONObject payload = new JSONObject();
            JSONArray contents = new JSONArray();
            JSONArray parts = new JSONArray();
            JSONObject textPart = new JSONObject();
            textPart.put("text", promptText);
            parts.put(textPart);
            JSONObject content = new JSONObject();
            content.put("parts", parts);
            contents.put(content);
            payload.put("contents", contents);

            String urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("X-goog-api-key", apiKey);
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(payload.toString().getBytes(StandardCharsets.UTF_8));
            }

            StringBuilder responseStr = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) responseStr.append(line.trim());
            }

            JSONObject responseBody = new JSONObject(responseStr.toString());
            JSONArray candidates = responseBody.getJSONArray("candidates");
            if (!candidates.isEmpty()) {
                JSONObject contentObj = candidates.getJSONObject(0).getJSONObject("content");
                JSONArray partsArray = contentObj.getJSONArray("parts");
                String rawText = partsArray.getJSONObject(0).getString("text");

                rawText = rawText.replace("```json", "").replace("```", "").trim();
                System.out.println(rawText);
                return rawText;
            }
            return "{\"analysis\":\"Không có phản hồi từ AI\",\"recommendedIds\":[]}";
        }
    }
}
