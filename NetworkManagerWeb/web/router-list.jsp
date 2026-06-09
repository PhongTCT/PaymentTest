<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Models.RouterDTO"%>
<%
    ArrayList<RouterDTO> routers = (ArrayList<RouterDTO>) request.getAttribute("routers");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Routers</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="h3 mb-0">Routers</h1>
            <a class="btn btn-primary" href="MainController?action=routerAdd">Add Router</a>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>IP</th>
                            <th>MAC</th>
                            <th>Model</th>
                            <th>Firmware</th>
                            <th>Status</th>
                            <th>Location</th>
                            <th>Room</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (routers != null && !routers.isEmpty()) {
                                for (RouterDTO router : routers) {
                        %>
                        <tr>
                            <td><%= router.getRouterId() %></td>
                            <td><%= router.getRouterName() %></td>
                            <td><%= router.getIpAddress() %></td>
                            <td><%= router.getMacAddress() %></td>
                            <td><%= router.getModel() %></td>
                            <td><%= router.getFirmware() %></td>
                            <td><span class="badge text-bg-secondary"><%= router.getStatus() %></span></td>
                            <td><%= router.getLocation() %></td>
                            <td><%= router.getRoomId() %></td>
                            <td>
                                <a class="btn btn-sm btn-outline-primary" href="MainController?action=routerEdit&id=<%= router.getRouterId() %>">Edit</a>
                                <a class="btn btn-sm btn-outline-danger" href="MainController?action=routerDelete&id=<%= router.getRouterId() %>">Delete</a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="10" class="text-center text-muted py-4">No routers found.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
