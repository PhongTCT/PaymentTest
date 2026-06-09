<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.RouterDTO"%>
<%
    RouterDTO router = (RouterDTO) request.getAttribute("router");
    boolean editMode = router != null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= editMode ? "Edit Router" : "Add Router" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-4">
        <h1 class="h3 mb-3"><%= editMode ? "Edit Router" : "Add Router" %></h1>

        <form class="card p-4" action="MainController" method="post">
            <input type="hidden" name="action" value="<%= editMode ? "routerUpdate" : "routerInsert" %>">
            <% if (editMode) { %>
            <input type="hidden" name="routerId" value="<%= router.getRouterId() %>">
            <% } %>

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Router Name</label>
                    <input class="form-control" type="text" name="routerName" value="<%= editMode ? router.getRouterName() : "" %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">IP Address</label>
                    <input class="form-control" type="text" name="ipAddress" value="<%= editMode ? router.getIpAddress() : "" %>">
                </div>
                <div class="col-md-6">
                    <label class="form-label">MAC Address</label>
                    <input class="form-control" type="text" name="macAddress" value="<%= editMode ? router.getMacAddress() : "" %>">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Model</label>
                    <input class="form-control" type="text" name="model" value="<%= editMode ? router.getModel() : "" %>">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Firmware</label>
                    <input class="form-control" type="text" name="firmware" value="<%= editMode ? router.getFirmware() : "" %>">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Status</label>
                    <input class="form-control" type="text" name="status" value="<%= editMode ? router.getStatus() : "ONLINE" %>">
                </div>
                <div class="col-md-8">
                    <label class="form-label">Location</label>
                    <input class="form-control" type="text" name="location" value="<%= editMode ? router.getLocation() : "" %>">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Room ID</label>
                    <input class="form-control" type="number" name="roomId" value="<%= editMode ? router.getRoomId() : 0 %>">
                </div>
            </div>

            <div class="mt-4">
                <button class="btn btn-primary" type="submit">Save</button>
                <a class="btn btn-secondary" href="MainController?action=routerList">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>
