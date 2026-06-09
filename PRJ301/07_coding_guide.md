---
title: "Coding Guide - Implement One Model End-to-End"
tags: [prj301, planning, coding, guide, tutorial]
created: 2026-05-26
updated: 2026-06-07
---

# Coding Guide: Implement One Model End-to-End

This guide uses `Router` as the example and is synchronized with `Network2.sql`.

Important current schema facts:

- Database is **SQL Server**, not MySQL.
- There are **20 tables**: 16 main tables and 4 junction tables.
- `Router` has `room_id`, so the Java model must have `roomId`.
- `User` has no `role` field. Roles are managed by `UserRole`.
- SQL Server reserved/problematic table names must be written as `[User]` and `[Switch]`.

---

## Overview: The 5 Steps

```mermaid
flowchart LR
    A[1. Create DTO] --> B[2. Create DAO]
    B --> C[3. Create Servlet]
    C --> D[4. Create JSP]
    D --> E[5. Test and Wire Navigation]
```

| Step | File | Package/Folder |
|---|---|---|
| 1 | `Router.java` | `com.networksim.model` |
| 2 | `RouterDAO.java` | `com.networksim.dao` |
| 3 | `RouterServlet.java` | `com.networksim.controller` |
| 4 | `router/list.jsp`, `router/form.jsp` | `Web Pages/router/` |
| 5 | navigation/web.xml/filter | `Web Pages/WEB-INF/` |

---

## Step 0: DBContext for SQL Server

```java
package com.networksim.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    private static final String URL =
            "jdbc:sqlserver://localhost:1433;"
            + "databaseName=network_simulation_db;"
            + "encrypt=true;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASSWORD = "your_password_here";

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

> If the database name is still `network_simulation_db3`, either rename it in SQL Server or update the JDBC URL.

---

## Step 1: Create the DTO

File: `com/networksim/model/Router.java`

```java
package com.networksim.model;

public class Router {

    private int routerId;
    private String routerName;
    private String ipAddress;
    private String macAddress;
    private String model;
    private String firmware;
    private String status;
    private String location;
    private Integer roomId;

    public Router() {
    }

    public Router(int routerId, String routerName, String ipAddress,
                  String macAddress, String model, String firmware,
                  String status, String location, Integer roomId) {
        this.routerId = routerId;
        this.routerName = routerName;
        this.ipAddress = ipAddress;
        this.macAddress = macAddress;
        this.model = model;
        this.firmware = firmware;
        this.status = status;
        this.location = location;
        this.roomId = roomId;
    }

    public int getRouterId() {
        return routerId;
    }

    public void setRouterId(int routerId) {
        this.routerId = routerId;
    }

    public String getRouterName() {
        return routerName;
    }

    public void setRouterName(String routerName) {
        this.routerName = routerName;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getMacAddress() {
        return macAddress;
    }

    public void setMacAddress(String macAddress) {
        this.macAddress = macAddress;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getFirmware() {
        return firmware;
    }

    public void setFirmware(String firmware) {
        this.firmware = firmware;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }
}
```

Use `Integer` instead of `int` for nullable FK columns such as `room_id`.

---

## Step 2: Create the DAO

File: `com/networksim/dao/RouterDAO.java`

```java
package com.networksim.dao;

import com.networksim.model.Router;
import com.networksim.util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class RouterDAO {

    public boolean insert(Router r) {
        String sql = "INSERT INTO Router "
                + "(router_name, ip_address, mac_address, model, firmware, status, location, room_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setRouterParams(ps, r);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Router r) {
        String sql = "UPDATE Router SET router_name=?, ip_address=?, mac_address=?, "
                + "model=?, firmware=?, status=?, location=?, room_id=? "
                + "WHERE router_id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setRouterParams(ps, r);
            ps.setInt(9, r.getRouterId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Router WHERE router_id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Router findById(int id) {
        String sql = "SELECT * FROM Router WHERE router_id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Router> findAll() {
        List<Router> list = new ArrayList<>();
        String sql = "SELECT * FROM Router ORDER BY router_id";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Router> findByRoom(int roomId) {
        List<Router> list = new ArrayList<>();
        String sql = "SELECT * FROM Router WHERE room_id=? ORDER BY router_id";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE Router SET status=? WHERE router_id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void setRouterParams(PreparedStatement ps, Router r) throws SQLException {
        ps.setString(1, r.getRouterName());
        ps.setString(2, r.getIpAddress());
        ps.setString(3, r.getMacAddress());
        ps.setString(4, r.getModel());
        ps.setString(5, r.getFirmware());
        ps.setString(6, r.getStatus());
        ps.setString(7, r.getLocation());
        if (r.getRoomId() == null) {
            ps.setNull(8, Types.INTEGER);
        } else {
            ps.setInt(8, r.getRoomId());
        }
    }

    private Router mapRow(ResultSet rs) throws SQLException {
        Router r = new Router();
        r.setRouterId(rs.getInt("router_id"));
        r.setRouterName(rs.getString("router_name"));
        r.setIpAddress(rs.getString("ip_address"));
        r.setMacAddress(rs.getString("mac_address"));
        r.setModel(rs.getString("model"));
        r.setFirmware(rs.getString("firmware"));
        r.setStatus(rs.getString("status"));
        r.setLocation(rs.getString("location"));

        int roomId = rs.getInt("room_id");
        r.setRoomId(rs.wasNull() ? null : roomId);
        return r;
    }
}
```

---

## Step 3: Session and Role Check

Do not use `user.getRole()`. The correct pattern is:

```java
User loggedUser = SessionUtil.getLoggedUser(request);
if (loggedUser == null) {
    response.sendRedirect("login");
    return;
}

if (!SessionUtil.hasRole(request, "Admin", "Technician")) {
    response.sendRedirect("router?action=list&msg=access_denied");
    return;
}
```

`LoginServlet` must load role names from `UserRoleDAO`:

```java
List<String> roles = userRoleDAO.findRoleNamesByUser(user.getUserId());
session.setAttribute("loggedUser", user);
session.setAttribute("roles", roles);
```

---

## Step 4: Create the Servlet

File: `com/networksim/controller/RouterServlet.java`

```java
package com.networksim.controller;

import com.networksim.dao.RouterDAO;
import com.networksim.model.Router;
import com.networksim.model.User;
import com.networksim.util.SessionUtil;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RouterServlet", urlPatterns = {"/router"})
public class RouterServlet extends HttpServlet {

    private final RouterDAO routerDAO = new RouterDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedUser = SessionUtil.getLoggedUser(request);
        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                if (!SessionUtil.hasRole(request, "Admin")) {
                    response.sendRedirect("router?action=list&msg=access_denied");
                    return;
                }
                request.getRequestDispatcher("router/form.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteRouter(request, response);
                break;
            default:
                listRouters(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        User loggedUser = SessionUtil.getLoggedUser(request);
        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }

        if (!SessionUtil.hasRole(request, "Admin")) {
            response.sendRedirect("router?action=list&msg=access_denied");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addRouter(request, response);
        } else if ("edit".equals(action)) {
            editRouter(request, response);
        } else {
            response.sendRedirect("router?action=list");
        }
    }

    private void listRouters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Router> routers = routerDAO.findAll();
        request.setAttribute("routerList", routers);
        request.getRequestDispatcher("router/list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Router router = routerDAO.findById(id);
        request.setAttribute("router", router);
        request.getRequestDispatcher("router/form.jsp").forward(request, response);
    }

    private void addRouter(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Router router = extractRouterFromForm(request);
        if (router.getStatus() == null || router.getStatus().trim().isEmpty()) {
            router.setStatus("ONLINE");
        }
        response.sendRedirect(routerDAO.insert(router)
                ? "router?action=list&msg=added"
                : "router?action=list&msg=error");
    }

    private void editRouter(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Router router = extractRouterFromForm(request);
        router.setRouterId(Integer.parseInt(request.getParameter("routerId")));
        response.sendRedirect(routerDAO.update(router)
                ? "router?action=list&msg=updated"
                : "router?action=list&msg=error");
    }

    private void deleteRouter(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!SessionUtil.hasRole(request, "Admin")) {
            response.sendRedirect("router?action=list&msg=access_denied");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        response.sendRedirect(routerDAO.delete(id)
                ? "router?action=list&msg=deleted"
                : "router?action=list&msg=error");
    }


    private Router extractRouterFromForm(HttpServletRequest request) {
        Router router = new Router();
        router.setRouterName(request.getParameter("routerName"));
        router.setIpAddress(request.getParameter("ipAddress"));
        router.setMacAddress(request.getParameter("macAddress"));
        router.setModel(request.getParameter("model"));
        router.setFirmware(request.getParameter("firmware"));
        router.setStatus(request.getParameter("status"));
        router.setLocation(request.getParameter("location"));
        router.setRoomId(parseNullableInt(request.getParameter("roomId")));
        return router;
    }

    private Integer parseNullableInt(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        return Integer.valueOf(value);
    }
}
```

---

## Step 5: JSP Notes

`router/form.jsp` must include `roomId` because `Router.room_id` exists in the database.

```jsp
<tr>
    <td>Room ID:</td>
    <td>
        <input type="number" name="roomId"
               value="<%= isEdit && router.getRoomId() != null ? router.getRoomId() : "" %>">
    </td>
</tr>
```

For a better UI, load `RoomDAO.findAll()` in the servlet and render a `<select>` instead of asking the user to type the room ID manually.

In JSP, avoid `loggedUser.getRole()`. Use roles stored in session:

```jsp
<%
    java.util.List<String> roles = (java.util.List<String>) session.getAttribute("roles");
    boolean isAdmin = roles != null && roles.contains("Admin");
%>
```

---

## Step 6: Implement Junction Tables

Junction tables do not need normal auto-increment IDs. Use composite keys.

### UserRoleDAO required methods

```java
assignRole(int userId, int roleId)
removeRole(int userId, int roleId)
findRolesByUser(int userId)
findRoleNamesByUser(int userId)
findUsersByRole(int roleId)
```

### Maintenance junction DAO methods

```java
MaintenanceRouterDAO.addRouter(int maintenanceId, int routerId)
MaintenanceRouterDAO.removeRouter(int maintenanceId, int routerId)
MaintenanceRouterDAO.findRoutersByMaintenance(int maintenanceId)

MaintenanceAccessPointDAO.addAP(int maintenanceId, int apId)
MaintenanceAccessPointDAO.removeAP(int maintenanceId, int apId)
MaintenanceAccessPointDAO.findAPsByMaintenance(int maintenanceId)

MaintenanceSwitchDAO.addSwitch(int maintenanceId, int switchId)
MaintenanceSwitchDAO.removeSwitch(int maintenanceId, int switchId)
MaintenanceSwitchDAO.findSwitchesByMaintenance(int maintenanceId)
```

---

## Step 7: Replicate the Pattern for All Tables

Current table list:

| Owner | Tables |
|---|---|
| Member A | `User`, `Role`, `UserRole`, `AuthenticationLog`, `SystemLog` |
| Member B | `Router`, `AccessPoint`, `Switch`, `NetworkDevice` |
| Member C | `Room`, `VLAN`, `IPAddressManagement`, `SupportTicket` |
| Member D | `BandwidthUsage`, `WiFiAnalytics`, `NetworkAlert`, `MaintenanceSchedule`, `MaintenanceRouter`, `MaintenanceAccessPoint`, `MaintenanceSwitch` |

Special FK fields to include in DTO/DAO/form:

| Table | Important FK fields |
|---|---|
| Router | `room_id` |
| AccessPoint | `room_id` |
| Switch | `room_id` |
| NetworkDevice | `room_id` |
| VLAN | `room_id` |
| IPAddressManagement | `device_id` |
| SupportTicket | `created_by`, `device_id` |
| BandwidthUsage | `device_id` |
| WiFiAnalytics | `ap_id` |
| NetworkAlert | `router_id`, `ap_id`, `switch_id` |
| AuthenticationLog | `user_id` |
| SystemLog | `performed_by` |

---

## Common Mistakes to Avoid

| Mistake | Why It Is Bad | Fix |
|---|---|---|
| Using MySQL JDBC URL/driver | The script is SQL Server | Use `jdbc:sqlserver` and SQL Server driver |
| Adding `role` to `User` | Conflicts with schema | Use `UserRole` |
| Forgetting nullable FK handling | `rs.getInt()` returns 0 for NULL | Use `rs.wasNull()` |
| Forgetting `roomId` in device DTOs | Data does not match schema | Add `Integer roomId` |
| Writing `[User]` as `User` in SQL Server | Can cause syntax issues | Use `[User]` |
| Writing `[Switch]` as `Switch` in SQL Server | Can cause syntax issues | Use `[Switch]` |
| Returning null list | JSP can fail or require extra checks | Return empty `ArrayList` |
| Putting SQL in Servlet/JSP | Breaks MVC separation | Keep SQL in DAO |
| Building SQL by concatenating user input | SQL injection risk | Use `PreparedStatement` |
| Redirecting without logging important actions | Hard to audit | Insert `SystemLog` for sensitive changes |

---

## Testing Checklist

1. Build project successfully.
2. Verify `DBContext.getConnection()` connects to SQL Server.
3. Login as `admin`.
4. Check `UserRoleDAO.findRoleNamesByUser(1)` returns `Admin`.
5. Router list loads.
6. Add router with and without `roomId`.
7. Edit router status and room.
8. Delete only as Admin.
9. Verify Viewer cannot access mutation actions.
10. Check SQL Server data after each operation.

---

## Related Documents

- `Network2.sql` - Current SQL Server schema
- `03_team_assignment_updated.md` - Current team assignment
- `04_system_architecture.md` - Folder structure and shared utilities
- `05_feature_list.md` - Features by role

