<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Util.Config" %>
<!DOCTYPE html>
<html lang="vi">
<%@include file="../include/head.jsp" %>
<body>
<!-- Container cho widget -->
<%--<div id="cometchat" style="width:100%; height:100vh;"></div>--%>
<%@include file="../include/header.jsp" %>
<!-- Nhúng script từ CometChat -->
<script defer src="https://cdn.jsdelivr.net/npm/@cometchat/chat-embed@latest/dist/main.js"></script>
<div class="container" id="cometChatMount"></div>
<% if (user != null) { %>
<script>
    const COMETCHAT_CREDENTIALS = {
        appID:     "<%=Config.comet_chat_app_id%>",
        appRegion: "<%=Config.comet_chat_app_region%>",
        authKey:   "61c745c12967f118b58089b74492b8b818532417",
    };
    const COMETCHAT_LAUNCH_OPTIONS = {
        targetElementID: "cometChatMount",   // Element ID to mount the widget
        isDocked:        false,               // true = floating bubble, false = embedded
        width:  "100%",   // docked: nhỏ gọn, embedded: full
        height: "95vh",  // docked: cao vừa phải, embedded: full chiều cao
        theme: "light",
        <% if (request.getRequestURI().endsWith("/chat.jsp")) { %>
        <% if (request.getParameter("chatWith") != null) { %>
        chatType: "user",              // "user" hoặc "group"
        defaultChatID: "<%=request.getParameter("chatWith")%>",    // UID (người dùng) hoặc GUID (nhóm)
        <% } %>
        <% } %>

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
<% } else { %>
<h1>Vui lòng đăng nhập</h1>
<% } %>
<jsp:include page="../include/footer.jsp" />
<jsp:include page="../include/js.jsp" />
</body>
</html>


