<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="router" value="${requestScope.router}" />
<c:set var="formRouter" value="${requestScope.formRouter}" />
<c:set var="returnTo" value="${requestScope.returnTo}" />
<c:set var="editMode" value="${not empty router}" />
<c:choose>
    <c:when test="${editMode}">
        <c:set var="valueRouter" value="${router}" />
    </c:when>
    <c:otherwise>
        <c:set var="valueRouter" value="${formRouter}" />
    </c:otherwise>
</c:choose>
<c:set var="statusValue" value="${valueRouter.status}" />
<c:if test="${empty statusValue}">
    <c:set var="statusValue" value="ONLINE" />
</c:if>
<c:set var="roomIdValue" value="${valueRouter.roomId}" />
<c:if test="${empty roomIdValue}">
    <c:set var="roomIdValue" value="0" />
</c:if>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${editMode}">Edit Router</c:when>
            <c:otherwise>Add Router</c:otherwise>
        </c:choose>
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-4">
        <h1 class="h3 mb-3">
            <c:choose>
                <c:when test="${editMode}">Edit Router</c:when>
                <c:otherwise>Add Router</c:otherwise>
            </c:choose>
        </h1>

        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger">
                <c:out value="${requestScope.error}" />
            </div>
        </c:if>

        <form class="card p-4" action="MainController" method="post">
            <c:choose>
                <c:when test="${editMode}">
                    <input type="hidden" name="action" value="routerUpdate">
                    <input type="hidden" name="routerId" value="${router.routerId}">
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="action" value="routerInsert">
                </c:otherwise>
            </c:choose>

            <c:if test="${not empty returnTo}">
                <input type="hidden" name="returnTo" value="${returnTo}">
            </c:if>

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Router Name</label>
                    <input class="form-control" type="text" name="routerName" value="${valueRouter.routerName}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">IP Address</label>
                    <input class="form-control" type="text" name="ipAddress" value="${valueRouter.ipAddress}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">MAC Address</label>
                    <input class="form-control" type="text" name="macAddress" value="${valueRouter.macAddress}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Model</label>
                    <input class="form-control" type="text" name="model" value="${valueRouter.model}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Firmware</label>
                    <input class="form-control" type="text" name="firmware" value="${valueRouter.firmware}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Status</label>
                    <input class="form-control" type="text" name="status" value="${statusValue}">
                </div>
                <div class="col-md-8">
                    <label class="form-label">Location</label>
                    <input class="form-control" type="text" name="location" value="${valueRouter.location}">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Room ID</label>
                    <input class="form-control" type="number" name="roomId" value="${roomIdValue}">
                </div>
            </div>

            <div class="mt-4">
                <button class="btn btn-primary" type="submit">Save</button>
                <c:choose>
                    <c:when test="${returnTo eq 'dashboard'}">
                        <a class="btn btn-secondary" href="staffDashboard.jsp?page=routers">Cancel</a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn btn-secondary" href="MainController?action=routerList">Cancel</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </form>
    </div>
</body>
</html>
