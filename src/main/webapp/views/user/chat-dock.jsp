<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Util.Config" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chat - Messenger</title>
  <style>
    body, html {
      margin: 0;
      padding: 0;
      height: 100%;
    }
    #cometchat {
      width: 100%;
      height: 100vh; /* Chiếm toàn bộ màn hình */
    }
  </style>
</head>
<body>
<!-- Container cho widget -->
<%--<div id="cometchat" style="width:100%; height:100vh;"></div>--%>

<!-- Nhúng script từ CometChat -->
<script defer src="https://cdn.jsdelivr.net/npm/@cometchat/chat-embed@latest/dist/main.js"></script>
<div id="cometChatMount"></div>

<script>
  const COMETCHAT_CREDENTIALS = {
    appID:     "<%=Config.comet_chat_app_id%>",
    appRegion: "<%=Config.comet_chat_app_region%>",
    authKey:   "61c745c12967f118b58089b74492b8b818532417",
  };

  const COMETCHAT_LAUNCH_OPTIONS = {
    targetElementID: "cometChatMount",   // Element ID to mount the widget
    isDocked:        true,               // true = floating bubble, false = embedded
    width:           "100%",            // Widget width
    height:          "100vh",            // Widget height

    // Optional advanced settings:
    // variantID:        "YOUR_VARIANT_ID",    // Variant configuration ID
    // chatType:         "user",               // "user" or "group"
    // defaultChatID:    "uid_or_guid",        // UID or GUID to open chat by default
    // dockedAlignment:  "right",              // For docked mode: "left" or "right"
  };

  const COMETCHAT_USER_UID = "<%=%>"; // Replace with your actual user UID

  window.addEventListener("DOMContentLoaded", () => {
    CometChatApp.init(COMETCHAT_CREDENTIALS)
            .then(() => {
              console.log("[CometChat] Session cleared");
              return CometChatApp.logout().catch(() => {});
            })
            .then(() => {
              console.log("[CometChat] Initialized successfully");
              return CometChatApp.login({ uid: COMETCHAT_USER_UID });
            })
            .then(user => {
              console.log("[CometChat] Logged in as:", user);
              return CometChatApp.launch(COMETCHAT_LAUNCH_OPTIONS);
            })
            .then(() => {
              console.log("[CometChat] Chat launched!");
            })
            .catch(error => {
              console.error("[CometChat] Error:", error);
            });
  });
</script>
</body>
</html>

