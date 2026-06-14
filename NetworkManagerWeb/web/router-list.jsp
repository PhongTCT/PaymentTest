<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
            <div>
                <a class="btn btn-secondary" href="staffDashboard.jsp">Back Dashboard</a>
                <a class="btn btn-primary" href="MainController?action=routerAdd">Add Router</a>
            </div>
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
                        <c:choose>
                            <c:when test="${not empty routers}">
                                <c:forEach var="router" items="${routers}">
                                    <tr>
                                        <td>${router.routerId}</td>
                                        <td><c:out value="${router.routerName}" /></td>
                                        <td><c:out value="${router.ipAddress}" /></td>
                                        <td><c:out value="${router.macAddress}" /></td>
                                        <td><c:out value="${router.model}" /></td>
                                        <td><c:out value="${router.firmware}" /></td>
                                        <td>
                                            <form action="MainController" method="post" class="d-flex gap-2">
                                                <input type="hidden" name="action" value="routerUpdateStatus">
                                                <input type="hidden" name="id" value="${router.routerId}">
                                                <select class="form-select form-select-sm" name="status">
                                                    <option value="ONLINE" ${router.status eq 'ONLINE' ? 'selected' : ''}>ONLINE</option>
                                                    <option value="OFFLINE" ${router.status eq 'OFFLINE' ? 'selected' : ''}>OFFLINE</option>
                                                    <option value="MAINTENANCE" ${router.status eq 'MAINTENANCE' ? 'selected' : ''}>MAINTENANCE</option>
                                                </select>
                                                <button class="btn btn-sm btn-outline-success" type="submit">Update</button>
                                            </form>
                                        </td>
                                        <td><c:out value="${router.location}" /></td>
                                        <td>${router.roomId}</td>
                                        <td>
                                            <a class="btn btn-sm btn-outline-primary" href="MainController?action=routerEdit&id=${router.routerId}">Edit</a>
                                            <a class="btn btn-sm btn-outline-warning" href="MainController?action=routerRestart&id=${router.routerId}">Restart</a>
                                            <a class="btn btn-sm btn-outline-danger" href="MainController?action=routerDelete&routerId=${router.routerId}">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="10" class="text-center text-muted py-4">No routers found.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
