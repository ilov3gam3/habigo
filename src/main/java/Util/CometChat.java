package Util;

import Model.User;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class CometChat {
    public static void register(User user) throws IOException {
        URL url = new URL("https://" + Config.comet_chat_app_id + ".api-"
                + Config.comet_chat_app_region + ".cometchat.io/v3/users");

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("apikey", Config.comet_chat_app_api_key);
        conn.setDoOutput(true);

        // JSON metadata
        JSONObject privateMeta = new JSONObject();
        privateMeta.put("email", "user@email.com");
        privateMeta.put("contactNumber", "0123456789");

        JSONObject metadata = new JSONObject();
        metadata.put("@private", privateMeta);

        // JSON payload
        JSONObject payload = new JSONObject();
        payload.put("uid", user.getId().toString());
        payload.put("name", user.getEmail());
        payload.put("avatar", user.getAvatar());
        payload.put("link", user.getAvatar());
        payload.put("role", "default");
        payload.put("statusMessage", "Hello " + user.getEmail());
        payload.put("metadata", metadata);
        payload.put("tags", new JSONArray());
        payload.put("withAuthToken", true);

        // Send request
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = payload.toString().getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        // Read response
        int responseCode = conn.getResponseCode();
        InputStream is = (responseCode < HttpURLConnection.HTTP_BAD_REQUEST) ? conn.getInputStream() : conn.getErrorStream();

        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            System.out.println("CometChat response: " + response);
        }
    }


    public static void updateUser(User user, boolean unsetAvatar) throws IOException {
        String uid = user.getId().toString();
        URL url = new URL("https://" + Config.comet_chat_app_id + ".api-"
                + Config.comet_chat_app_region + ".cometchat.io/v3/users/" + uid);

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("PUT");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("apikey", Config.comet_chat_app_api_key);
        conn.setDoOutput(true);

        // JSON metadata
        JSONObject privateMeta = new JSONObject();
        privateMeta.put("email", user.getEmail());
        privateMeta.put("contactNumber", user.getPhone()); // giả sử User có trường này

        JSONObject metadata = new JSONObject();
        metadata.put("@private", privateMeta);

        // JSON payload
        JSONObject payload = new JSONObject();
        payload.put("name", user.getEmail()); // bạn có thể đổi thành user.getName() nếu muốn
        payload.put("avatar", user.getAvatar());
        payload.put("link", user.getAvatar());
        payload.put("role", "default");
        payload.put("statusMessage", "Hello " + user.getEmail());
        payload.put("metadata", metadata);

        // Ví dụ gắn tag
        JSONArray tags = new JSONArray();
        tags.put("tenant");
        payload.put("tags", tags);

        // Send request
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = payload.toString().getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        // Read response
        int responseCode = conn.getResponseCode();
        InputStream is = (responseCode < HttpURLConnection.HTTP_BAD_REQUEST)
                ? conn.getInputStream()
                : conn.getErrorStream();

        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            System.out.println("CometChat update response: " + response);
        }
    }


    public static String getAuthToken(User user) {
        try {
            String uid = user.getId().toString();
            String urlStr = "https://" + Config.comet_chat_app_id + ".api-" + Config.comet_chat_app_region + ".cometchat.io/v3/users/" + uid + "/auth_tokens";

            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            conn.setRequestProperty("apiKey", Config.comet_chat_app_api_key);
            conn.setRequestProperty("Accept", "application/json");

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String inputLine;
                StringBuilder response = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                JSONObject json = new JSONObject(response.toString());
                JSONArray data = json.getJSONArray("data");

                if (data.length() > 0) {
                    JSONObject tokenObj = data.getJSONObject(0);
                    return tokenObj.getString("authToken");
                }
            } else {
                System.err.println("Failed : HTTP error code : " + responseCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // trả null nếu không lấy được
    }
}
