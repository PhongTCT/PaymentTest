---
title: "Team Assignment and Sprint Plan"
tags: [prj301, planning, team, sprint]
created: 2026-05-26
---

# Team Assignment and Sprint Plan

## 1. Team Overview

| Item | Detail |
|---|---|
| **Course** | PRJ301 — Java Web Application Development |
| **Team Size** | 4 members |
| **Total Models** | 16 (4 per member) |
| **Project** | University Network Management System |

---

## 2. Model Assignment Table

| Member | Models | Category |
|---|---|---|
| **Member A** | User, Role, AuthenticationLog, SystemLog | Auth & Logging |
| **Member B** | Router, AccessPoint, Switch, NetworkDevice | Core Devices |
| **Member C** | Room, VLAN, IPAddressManagement, SupportTicket | Infrastructure & Support |
| **Member D** | BandwidthUsage, WiFiAnalytics, NetworkAlert, MaintenanceSchedule | Monitoring & Scheduling |

### Balance Check

| Member | Core Entity | Analytics/Log | Support/Mgmt |
|---|---|---|---|
| A | User | AuthenticationLog, SystemLog | Role |
| B | Router, AccessPoint, Switch | — | NetworkDevice |
| C | Room | — | VLAN, IPAddressManagement, SupportTicket |
| D | — | BandwidthUsage, WiFiAnalytics, NetworkAlert | MaintenanceSchedule |

---

## 3. Detailed Reference per Member

### 3.1 Member A — Auth & Logging

#### User

| Field    | Type   |
| -------- | ------ |
| userId   | int    |
| username | String |
| password | String |
| fullName | String |
| email    | String |
| role     | String |
| status   | String |

**DAO Methods:** `login()`, `insert()`, `update()`, `delete()`, `findById()`, `findAll()`, `changePassword()`

#### Role

| Field       | Type   |
| ----------- | ------ |
| roleId      | int    |
| roleName    | String |
| description | String |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`, `assignRole()`

#### AuthenticationLog

| Field | Type |
|---|---|
| logId | int |
| username | String |
| loginStatus | String |
| ipAddress | String |
| loginTime | Date |

**DAO Methods:** `insert()`, `findByUser()`, `findFailedAttempts()`

#### SystemLog

| Field | Type |
|---|---|
| logId | int |
| action | String |
| performedBy | String |
| createdAt | Date |
| details | String |

**DAO Methods:** `insert()`, `findAll()`, `findByDate()`

**Servlets to build:** `LoginServlet`, `UserServlet`, `RoleServlet`
**JSPs to build:** `login.jsp`, `user-list.jsp`, `user-form.jsp`, `role-list.jsp`, `system-log.jsp`

---

### 3.2 Member B — Core Devices

#### Router

| Field | Type |
|---|---|
| routerId | int |
| routerName | String |
| ipAddress | String |
| macAddress | String |
| model | String |
| firmware | String |
| status | String |
| location | String |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findById()`, `findAll()`, `updateStatus()`, `restartRouter()`

#### AccessPoint

| Field | Type |
|---|---|
| apId | int |
| apName | String |
| ssid | String |
| ipAddress | String |
| connectedUsers | int |
| status | String |
| location | String |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`, `countConnectedUsers()`, `updateSSID()`

#### Switch

| Field | Type |
|---|---|
| switchId | int |
| switchName | String |
| totalPorts | int |
| usedPorts | int |
| ipAddress | String |
| status | String |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`, `updatePortUsage()`

#### NetworkDevice

| Field | Type |
|---|---|
| deviceId | int |
| deviceName | String |
| macAddress | String |
| ipAddress | String |
| owner | String |
| deviceType | String |
| status | String |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findByMAC()`, `blockDevice()`, `unblockDevice()`

**Servlets to build:** `RouterServlet`, `AccessPointServlet`, `SwitchServlet`, `NetworkDeviceServlet`
**JSPs to build:** `router-list.jsp`, `router-form.jsp`, `ap-list.jsp`, `ap-form.jsp`, `switch-list.jsp`, `switch-form.jsp`, `device-list.jsp`, `device-form.jsp`

---

### 3.3 Member C — Infrastructure & Support

#### Room

| Field | Type |
|---|---|
| roomId | int |
| roomName | String |
| building | String |
| floor | int |
| capacity | int |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`

#### VLAN

| Field | Type |
|---|---|
| vlanId | int |
| vlanName | String |
| subnet | String |
| purpose | String |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findAll()`

#### IPAddressManagement

| Field | Type |
|---|---|
| ipId | int |
| ipAddress | String |
| assignedTo | String |
| status | String |

**DAO Methods:** `assignIP()`, `releaseIP()`, `findAvailableIP()`

#### SupportTicket

| Field | Type |
|---|---|
| ticketId | int |
| title | String |
| description | String |
| createdBy | String |
| status | String |
| createdDate | Date |

**DAO Methods:** `insert()`, `updateStatus()`, `assignTechnician()`, `findAll()`

**Servlets to build:** `RoomServlet`, `VLANServlet`, `IPServlet`, `TicketServlet`
**JSPs to build:** `room-list.jsp`, `room-form.jsp`, `vlan-list.jsp`, `vlan-form.jsp`, `ip-list.jsp`, `ticket-list.jsp`, `ticket-form.jsp`

---

### 3.4 Member D — Monitoring & Scheduling

#### BandwidthUsage

| Field | Type |
|---|---|
| usageId | int |
| deviceName | String |
| uploadSpeed | double |
| downloadSpeed | double |
| recordTime | Date |

**DAO Methods:** `insert()`, `findByDate()`, `findTopUsage()`, `generateReport()`

#### WiFiAnalytics

| Field | Type |
|---|---|
| analyticsId | int |
| totalUsers | int |
| peakUsers | int |
| avgSpeed | double |
| analyticsDate | Date |

**DAO Methods:** `generateDailyAnalytics()`, `generateMonthlyAnalytics()`, `findAll()`

#### NetworkAlert

| Field | Type |
|---|---|
| alertId | int |
| alertType | String |
| message | String |
| severity | String |
| createdAt | Date |

**DAO Methods:** `insert()`, `findAll()`, `resolveAlert()`

#### MaintenanceSchedule

| Field | Type |
|---|---|
| maintenanceId | int |
| title | String |
| description | String |
| startTime | Date |
| endTime | Date |
| status | String |

**DAO Methods:** `insert()`, `update()`, `delete()`, `findUpcoming()`

**Servlets to build:** `BandwidthServlet`, `WiFiAnalyticsServlet`, `AlertServlet`, `MaintenanceServlet`
**JSPs to build:** `bandwidth-list.jsp`, `bandwidth-form.jsp`, `analytics-dashboard.jsp`, `alert-list.jsp`, `maintenance-list.jsp`, `maintenance-form.jsp`

---

## 4. Database Table Ownership

| Table | Owner |
|---|---|
| User | Member A |
| Role | Member A |
| AuthenticationLog | Member A |
| SystemLog | Member A |
| Router | Member B |
| AccessPoint | Member B |
| Switch | Member B |
| NetworkDevice | Member B |
| Room | Member C |
| VLAN | Member C |
| IPAddressManagement | Member C |
| SupportTicket | Member C |
| BandwidthUsage | Member D |
| WiFiAnalytics | Member D |
| NetworkAlert | Member D |
| MaintenanceSchedule | Member D |

---

## 5. Sprint Plan

### Week 1: Setup + Models (Foundation)

| Task | Owner | Deliverable |
|---|---|---|
| Create NetBeans project, register Tomcat 9 | All | Project runs on localhost |
| Create database + all 16 tables | All (each creates their own) | Tables exist in MySQL |
| Create DBConnection utility | Member A (lead) | `DBContext.java` works |
| Create all 16 DTO classes | Each member creates their own | `com.networksim.model.*` |
| Create all 16 DAO interfaces | Each member creates their own | `com.networksim.dao.*` |
| Create base JSP layout (header, footer, nav) | Member C | `layout.jsp` |

### Week 2: CRUD + UI (Core Features)

| Task | Owner | Deliverable |
|---|---|---|
| Implement Login (User DAO + LoginServlet + login.jsp) | Member A | Login works end-to-end |
| Implement Router CRUD (list + form) | Member B | Router CRUD works |
| Implement Room CRUD | Member C | Room CRUD works |
| Implement BandwidthUsage CRUD | Member D | Bandwidth CRUD works |
| Implement Role management | Member A | Role CRUD works |
| Implement AccessPoint, Switch CRUD | Member B | AP + Switch CRUD works |
| Implement VLAN, IP, Ticket CRUD | Member C | All 4 models CRUD works |
| Implement WiFiAnalytics, Alert, Maintenance | Member D | All 4 models CRUD works |
| Implement AuthenticationLog, SystemLog | Member A | Logging works |

### Week 3: Integration + Features

| Task | Owner | Deliverable |
|---|---|---|
| Implement NetworkDevice block/unblock | Member B | Block/unblock works |
| Wire up role-based access in all Servlets | Member A | Role check works |
| Connect SupportTicket to technicians | Member C | Ticket assignment works |
| Build monitoring dashboard | Member D | Analytics page works |
| Integrate all modules on dashboard.jsp | All | Dashboard links to all features |
| Cross-model testing | All | No broken links or SQL errors |

### Week 4: Report + Demo

| Task | Owner | Deliverable |
|---|---|---|
| Write CT analysis sections | All | Report Chapter 2 done |
| Write system design sections | All | Report Chapter 3 done |
| Take screenshots of all features | All | 15+ screenshots saved |
| Prepare demo script | Member A (lead) | Demo flow documented |
| Practice demo | All | Team runs through demo |
| Submit report + demo | All | Final submission |

---

## 6. Shared Responsibilities

These items are shared across all members — coordinate before building:

| Item | Who Builds | Notes |
|---|---|---|
| `DBContext.java` | Member A | All DAOs depend on this |
| `BaseDAO` interface | Member A | Optional but recommended |
| `layout.jsp` (header/footer) | Member C | All JSPs include this |
| `SessionUtil.java` | Member A | Session helper for all Servlets |
| `web.xml` mappings | Member B | Servlet URL mappings |
| `style.css` | Member D | Shared CSS for all pages |
| `dashboard.jsp` | All | Each member adds their module link |

---

## 7. Communication Rules

> [!tip]
> - Push code to shared Git repo daily
> - Pull before starting work each day
> - If you change `DBContext.java` or `web.xml`, notify the team immediately
> - Test your own CRUD before merging
> - Use the same database name: `network_simulation_db`

---

## 8. Related Documents

- [[00_project_overview]] — Project overview
- [[02_erd_database]] — Database schema and SQL
- [[04_system_architecture]] — Folder structure and naming conventions
- [[07_coding_guide]] — How to implement one model end-to-end
