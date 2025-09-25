<%@page contentType="text/html" pageEncoding="UTF-8" %>

<!-- Main JS File -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.css"
      integrity="sha512-3pIirOrwegjM6erE5gPSwkUzO+3cTjpnV9lexlNZqvupR64iZBnOOTiiLPb9M36zpMScbmUNIcHUqKD47M719g=="
      crossorigin="anonymous" referrerpolicy="no-referrer"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"
        integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw=="
        crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    <%
    String flashSuccess = (String) session.getAttribute("success");
    String flashError = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
    %>
    toastr.options = {
      closeButton: true,
      progressBar: true,
      positionClass: "toast-top-right",
      timeOut: "5000"
    };
    <% if (flashError != null) { %>
    toastr.error("<%= flashError %>", "Lỗi");
    <% } %>
    <% if (flashSuccess != null) { %>
    toastr.success("<%= flashSuccess %>", "Thành công");
    <% } %>
  });
</script>
<% if (!request.getRequestURI().endsWith("/chat.jsp")) { %>
<jsp:include page="../user/chat-dock.jsp" />
<% } %>