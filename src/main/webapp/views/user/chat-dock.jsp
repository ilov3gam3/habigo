<%@ page import="Util.Config" %>
<%@ page import="Model.User" %>
<% User user = (User) request.getSession().getAttribute("user"); %>
<% if (user != null) { %>
<div id="cometChatMount"></div>
<script defer src="https://cdn.jsdelivr.net/npm/@cometchat/chat-embed@latest/dist/main.js"></script>
<script>
  const COMETCHAT_CREDENTIALS = {
    appID:     "<%=Config.comet_chat_app_id%>",
    appRegion: "<%=Config.comet_chat_app_region%>",
    authKey:   "61c745c12967f118b58089b74492b8b818532417",
  };

  const COMETCHAT_LAUNCH_OPTIONS = {
    targetElementID: "cometChatMount",   // Element ID to mount the widget
    isDocked:        true,               // true = floating bubble, false = embedded
    width:  "400px",   // embedded: full
    height: "600px",  // embedded: full chiều cao
    theme: "light",

    // Optional advanced settings:
    // variantID:        "YOUR_VARIANT_ID",    // Variant configuration ID
    // chatType:         "user",               // "user" or "group"
    // defaultChatID:    "uid_or_guid",        // UID or GUID to open chat by default
    // dockedAlignment:  "right",              // For docked mode: "left" or "right"
  };

  const COMETCHAT_USER_UID = "<%=user.getId()%>"; // Replace with your actual user UID

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
<% } %>
