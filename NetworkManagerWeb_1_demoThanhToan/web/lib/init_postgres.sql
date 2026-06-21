-- PostgreSQL schema converted from SQL Server
-- Auto-run on first deploy

CREATE TABLE IF NOT EXISTS "Role" (
    role_id     SERIAL PRIMARY KEY,
    role_name   VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS "User" (
    user_id   SERIAL PRIMARY KEY,
    username  VARCHAR(50)  NOT NULL UNIQUE,
    password  VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email     VARCHAR(100),
    status    VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS UserRole (
    user_id     INT NOT NULL,
    role_id     INT NOT NULL,
    assigned_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_userrole_user FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_userrole_role FOREIGN KEY (role_id) REFERENCES "Role"(role_id)
);

CREATE TABLE IF NOT EXISTS PaymentTransaction (
    payment_id     BIGSERIAL PRIMARY KEY,
    order_id       VARCHAR(100) NOT NULL UNIQUE,
    user_id        INT NOT NULL,
    amount         BIGINT NOT NULL,
    currency       VARCHAR(3) NOT NULL DEFAULT 'VND',
    status         VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    provider       VARCHAR(20) NOT NULL DEFAULT 'VNPAY',
    order_info     VARCHAR(255),
    client_ip      VARCHAR(45),
    bank_code      VARCHAR(30),
    transaction_no VARCHAR(50),
    response_code  VARCHAR(10),
    vnp_pay_date   VARCHAR(14),
    created_at     TIMESTAMP NOT NULL DEFAULT NOW(),
    paid_at        TIMESTAMP,
    CONSTRAINT ck_payment_amount CHECK (amount > 0),
    CONSTRAINT ck_payment_status CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED')),
    CONSTRAINT fk_payment_user FOREIGN KEY (user_id) REFERENCES "User"(user_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_payment_transaction_no
    ON PaymentTransaction(transaction_no)
    WHERE transaction_no IS NOT NULL AND status = 'SUCCESS';

CREATE TABLE IF NOT EXISTS PremiumSubscription (
    user_id         INT PRIMARY KEY,
    plan_code       VARCHAR(30) NOT NULL DEFAULT 'PREMIUM_MONTHLY',
    status          VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    started_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    expires_at      TIMESTAMP NOT NULL,
    last_payment_id BIGINT,
    CONSTRAINT ck_subscription_status CHECK (status IN ('ACTIVE', 'EXPIRED', 'CANCELLED')),
    CONSTRAINT fk_subscription_user FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_subscription_payment FOREIGN KEY (last_payment_id) REFERENCES PaymentTransaction(payment_id)
);

CREATE TABLE IF NOT EXISTS Room (
    room_id   SERIAL PRIMARY KEY,
    room_name VARCHAR(100) NOT NULL,
    building  VARCHAR(100),
    floor     INT DEFAULT 1,
    capacity  INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Router (
    router_id   SERIAL PRIMARY KEY,
    router_name VARCHAR(100) NOT NULL,
    ip_address  VARCHAR(45) UNIQUE,
    mac_address VARCHAR(50) UNIQUE,
    model       VARCHAR(100),
    firmware    VARCHAR(100),
    status      VARCHAR(30) NOT NULL DEFAULT 'ONLINE',
    location    VARCHAR(150),
    room_id     INT,
    CONSTRAINT fk_router_room FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE IF NOT EXISTS AccessPoint (
    ap_id           SERIAL PRIMARY KEY,
    ap_name         VARCHAR(100) NOT NULL,
    ssid            VARCHAR(100),
    ip_address      VARCHAR(45) UNIQUE,
    connected_users INT NOT NULL DEFAULT 0,
    status          VARCHAR(30) NOT NULL DEFAULT 'ONLINE',
    location        VARCHAR(150),
    room_id         INT,
    CONSTRAINT fk_ap_room FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE IF NOT EXISTS Switch (
    switch_id   SERIAL PRIMARY KEY,
    switch_name VARCHAR(100) NOT NULL,
    total_ports INT NOT NULL DEFAULT 0,
    used_ports  INT NOT NULL DEFAULT 0,
    ip_address  VARCHAR(45) UNIQUE,
    status      VARCHAR(30) NOT NULL DEFAULT 'ONLINE',
    room_id     INT,
    CONSTRAINT fk_switch_room FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE IF NOT EXISTS NetworkDevice (
    device_id   SERIAL PRIMARY KEY,
    device_name VARCHAR(100) NOT NULL,
    mac_address VARCHAR(50) UNIQUE,
    ip_address  VARCHAR(45),
    owner       VARCHAR(100),
    device_type VARCHAR(50),
    status      VARCHAR(30) NOT NULL DEFAULT 'ALLOWED',
    room_id     INT,
    CONSTRAINT fk_device_room FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE IF NOT EXISTS VLAN (
    vlan_id   SERIAL PRIMARY KEY,
    vlan_name VARCHAR(100) NOT NULL,
    subnet    VARCHAR(50),
    purpose   VARCHAR(255),
    room_id   INT,
    CONSTRAINT fk_vlan_room FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE IF NOT EXISTS IPAddressManagement (
    ip_id      SERIAL PRIMARY KEY,
    ip_address VARCHAR(45) NOT NULL UNIQUE,
    status     VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',
    device_id  INT UNIQUE,
    CONSTRAINT fk_ip_device FOREIGN KEY (device_id) REFERENCES NetworkDevice(device_id)
);

CREATE TABLE IF NOT EXISTS BandwidthUsage (
    usage_id       SERIAL PRIMARY KEY,
    upload_speed   FLOAT NOT NULL DEFAULT 0,
    download_speed FLOAT NOT NULL DEFAULT 0,
    record_time    TIMESTAMP NOT NULL DEFAULT NOW(),
    device_id      INT NOT NULL,
    CONSTRAINT fk_bandwidth_device FOREIGN KEY (device_id) REFERENCES NetworkDevice(device_id)
);

CREATE TABLE IF NOT EXISTS WiFiAnalytics (
    analytics_id   SERIAL PRIMARY KEY,
    total_users    INT NOT NULL DEFAULT 0,
    peak_users     INT NOT NULL DEFAULT 0,
    avg_speed      FLOAT NOT NULL DEFAULT 0,
    analytics_date DATE NOT NULL,
    ap_id          INT NOT NULL,
    CONSTRAINT fk_wifi_ap FOREIGN KEY (ap_id) REFERENCES AccessPoint(ap_id)
);

CREATE TABLE IF NOT EXISTS NetworkAlert (
    alert_id   SERIAL PRIMARY KEY,
    alert_type VARCHAR(50) NOT NULL,
    message    VARCHAR(255) NOT NULL,
    severity   VARCHAR(20) NOT NULL DEFAULT 'INFO',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    router_id  INT,
    ap_id      INT,
    switch_id  INT,
    CONSTRAINT fk_alert_router  FOREIGN KEY (router_id)  REFERENCES Router(router_id),
    CONSTRAINT fk_alert_ap      FOREIGN KEY (ap_id)      REFERENCES AccessPoint(ap_id),
    CONSTRAINT fk_alert_switch  FOREIGN KEY (switch_id)  REFERENCES Switch(switch_id)
);

CREATE TABLE IF NOT EXISTS SupportTicket (
    ticket_id    SERIAL PRIMARY KEY,
    title        VARCHAR(150) NOT NULL,
    description  TEXT,
    status       VARCHAR(30) NOT NULL DEFAULT 'OPEN',
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by   INT NOT NULL,
    device_id    INT,
    CONSTRAINT fk_ticket_user   FOREIGN KEY (created_by) REFERENCES "User"(user_id),
    CONSTRAINT fk_ticket_device FOREIGN KEY (device_id)  REFERENCES NetworkDevice(device_id)
);

CREATE TABLE IF NOT EXISTS MaintenanceSchedule (
    maintenance_id SERIAL PRIMARY KEY,
    title          VARCHAR(150) NOT NULL,
    description    TEXT,
    start_time     TIMESTAMP NOT NULL,
    end_time       TIMESTAMP,
    status         VARCHAR(30) NOT NULL DEFAULT 'PLANNED'
);

CREATE TABLE IF NOT EXISTS MaintenanceRouter (
    maintenance_id INT NOT NULL,
    router_id      INT NOT NULL,
    PRIMARY KEY (maintenance_id, router_id),
    CONSTRAINT fk_maintrouter_maint  FOREIGN KEY (maintenance_id) REFERENCES MaintenanceSchedule(maintenance_id) ON DELETE CASCADE,
    CONSTRAINT fk_maintrouter_router FOREIGN KEY (router_id)      REFERENCES Router(router_id)
);

CREATE TABLE IF NOT EXISTS MaintenanceAccessPoint (
    maintenance_id INT NOT NULL,
    ap_id          INT NOT NULL,
    PRIMARY KEY (maintenance_id, ap_id),
    CONSTRAINT fk_maintap_maint FOREIGN KEY (maintenance_id) REFERENCES MaintenanceSchedule(maintenance_id) ON DELETE CASCADE,
    CONSTRAINT fk_maintap_ap    FOREIGN KEY (ap_id)          REFERENCES AccessPoint(ap_id)
);

CREATE TABLE IF NOT EXISTS MaintenanceSwitch (
    maintenance_id INT NOT NULL,
    switch_id      INT NOT NULL,
    PRIMARY KEY (maintenance_id, switch_id),
    CONSTRAINT fk_maintswitch_maint  FOREIGN KEY (maintenance_id) REFERENCES MaintenanceSchedule(maintenance_id) ON DELETE CASCADE,
    CONSTRAINT fk_maintswitch_switch FOREIGN KEY (switch_id)      REFERENCES Switch(switch_id)
);

CREATE TABLE IF NOT EXISTS AuthenticationLog (
    log_id       SERIAL PRIMARY KEY,
    username     VARCHAR(50) NOT NULL,
    login_status VARCHAR(20) NOT NULL,
    ip_address   VARCHAR(45),
    login_time   TIMESTAMP NOT NULL DEFAULT NOW(),
    user_id      INT,
    CONSTRAINT fk_authlog_user FOREIGN KEY (user_id) REFERENCES "User"(user_id)
);

CREATE TABLE IF NOT EXISTS SystemLog (
    log_id       SERIAL PRIMARY KEY,
    action       VARCHAR(100) NOT NULL,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    details      TEXT,
    performed_by INT,
    CONSTRAINT fk_syslog_user FOREIGN KEY (performed_by) REFERENCES "User"(user_id)
);

-- ===================== SEED DATA =====================

INSERT INTO "Role" (role_name, description) VALUES
('Admin',      'Toàn quyền truy cập hệ thống'),
('Technician', 'Quản lý, bảo trì và hỗ trợ thiết bị mạng'),
('Viewer',     'Chỉ được xem thông tin và sử dụng chức năng cơ bản')
ON CONFLICT DO NOTHING;

INSERT INTO "User" (username, password, full_name, email, status) VALUES
('admin',    'hashed_admin01', 'Quản trị viên hệ thống',  'admin@university.edu',      'ACTIVE'),
('tech01',   'hashed_tech01',  'Nguyễn Văn An',           'nv.an@university.edu',      'ACTIVE'),
('tech02',   'hashed_tech02',  'Trần Minh Đức',           'tm.duc@university.edu',     'ACTIVE'),
('tech03',   'hashed_tech03',  'Lê Thị Hoa',              'lt.hoa@university.edu',     'ACTIVE'),
('viewer01', 'hashed_view01',  'Phạm Quốc Bảo',           'pq.bao@university.edu',     'ACTIVE'),
('viewer02', 'hashed_view02',  'Hoàng Thị Mai',           'ht.mai@university.edu',     'ACTIVE'),
('viewer03', 'hashed_view03',  'Vũ Thanh Long',           'vt.long@university.edu',    'ACTIVE'),
('viewer04', 'hashed_view04',  'Đặng Thị Thu',            'dt.thu@university.edu',     'ACTIVE'),
('viewer05', 'hashed_view05',  'Bùi Văn Khánh',           'bv.khanh@university.edu',   'ACTIVE'),
('viewer06', 'hashed_view06',  'Ngô Thị Lan',             'nt.lan@university.edu',     'ACTIVE'),
('tech04',   'hashed_tech04',  'Đinh Văn Phúc',           'dv.phuc@university.edu',    'ACTIVE'),
('viewer07', 'hashed_view07',  'Trương Thị Ngọc',         'tt.ngoc@university.edu',    'INACTIVE'),
('viewer08', 'hashed_view08',  'Cao Văn Hiếu',            'cv.hieu@university.edu',    'ACTIVE'),
('viewer09', 'hashed_view09',  'Lâm Thị Phương',          'lt.phuong@university.edu',  'ACTIVE'),
('viewer10', 'hashed_view10',  'Mai Văn Thành',           'mv.thanh@university.edu',   'INACTIVE')
ON CONFLICT DO NOTHING;

INSERT INTO UserRole (user_id, role_id) VALUES
(1,1),(2,2),(3,2),(4,2),(11,2),
(5,3),(6,3),(7,3),(8,3),(9,3),(10,3),(12,3),(13,3),(14,3),(15,3)
ON CONFLICT DO NOTHING;

INSERT INTO Room (room_name, building, floor, capacity) VALUES
('Phòng A101','Tòa nhà A',1,40),('Phòng A102','Tòa nhà A',1,35),
('Phòng A201','Tòa nhà A',2,40),('Phòng A202','Tòa nhà A',2,30),
('Phòng A301','Tòa nhà A',3,25),('Phòng B101','Tòa nhà B',1,50),
('Phòng B102','Tòa nhà B',1,45),('Phòng B201','Tòa nhà B',2,40),
('Phòng B202','Tòa nhà B',2,35),('Phòng C101','Tòa nhà C',1,60),
('Phòng C201','Tòa nhà C',2,55),('Phòng C301','Tòa nhà C',3,50),
('Phòng máy chủ A','Tòa nhà A',0,10),('Phòng máy chủ B','Tòa nhà B',0,10),
('Phòng thực hành mạng','Tòa nhà C',1,30)
ON CONFLICT DO NOTHING;

INSERT INTO Router (router_name, ip_address, mac_address, model, firmware, status, location, room_id) VALUES
('Core-Router-01',  '10.0.0.1',   'AA:00:00:00:00:01','Cisco ASR 1001', '16.9','ONLINE',     'Phòng máy chủ A',13),
('Core-Router-02',  '10.0.0.2',   'AA:00:00:00:00:02','Cisco ASR 1001', '16.9','ONLINE',     'Phòng máy chủ B',14),
('BldA-Router-01',  '192.168.1.1','AA:00:00:00:01:01','Cisco 2901',     '15.7','ONLINE',     'Tòa nhà A',NULL),
('BldA-Router-02',  '192.168.1.2','AA:00:00:00:01:02','Cisco 2901',     '15.7','ONLINE',     'Tòa nhà A',NULL),
('BldB-Router-01',  '192.168.2.1','AA:00:00:00:02:01','MikroTik RB750', '6.49','ONLINE',     'Tòa nhà B',NULL),
('BldB-Router-02',  '192.168.2.2','AA:00:00:00:02:02','MikroTik RB750', '6.49','ONLINE',     'Tòa nhà B',NULL),
('BldC-Router-01',  '192.168.3.1','AA:00:00:00:03:01','TP-Link TL-R600','1.3', 'ONLINE',     'Tòa nhà C',NULL),
('BldC-Router-02',  '192.168.3.2','AA:00:00:00:03:02','TP-Link TL-R600','1.3', 'MAINTENANCE','Tòa nhà C',NULL),
('Lab-Router-01',   '192.168.4.1','AA:00:00:00:04:01','Cisco 1941',     '15.5','ONLINE',     'Phòng thực hành mạng',15),
('Lab-Router-02',   '192.168.4.2','AA:00:00:00:04:02','Cisco 1941',     '15.5','OFFLINE',    'Phòng thực hành mạng',15),
('BldA-Floor2-RT',  '192.168.1.3','AA:00:00:00:01:03','Ubiquiti ER-X',  '2.0', 'ONLINE',     'Tòa nhà A - Tầng 2',NULL),
('BldA-Floor3-RT',  '192.168.1.4','AA:00:00:00:01:04','Ubiquiti ER-X',  '2.0', 'ONLINE',     'Tòa nhà A - Tầng 3',NULL),
('BldB-Floor2-RT',  '192.168.2.3','AA:00:00:00:02:03','Ubiquiti ER-X',  '2.0', 'ONLINE',     'Tòa nhà B - Tầng 2',NULL),
('BldC-Floor2-RT',  '192.168.3.3','AA:00:00:00:03:03','Ubiquiti ER-X',  '2.0', 'ONLINE',     'Tòa nhà C - Tầng 2',NULL),
('Backup-Router-01','10.0.1.1',   'AA:00:00:00:FF:01','Cisco 2911',     '15.6','OFFLINE',    'Phòng máy chủ A',13)
ON CONFLICT DO NOTHING;

INSERT INTO AccessPoint (ap_name, ssid, ip_address, connected_users, status, location, room_id) VALUES
('AP-A1-01', 'UniWiFi-A1', '192.168.10.11',22,'ONLINE', 'Tòa nhà A - Phòng A101',1),
('AP-A1-02', 'UniWiFi-A1', '192.168.10.12',18,'ONLINE', 'Tòa nhà A - Phòng A102',2),
('AP-A2-01', 'UniWiFi-A2', '192.168.10.21',30,'ONLINE', 'Tòa nhà A - Phòng A201',3),
('AP-A2-02', 'UniWiFi-A2', '192.168.10.22',15,'ONLINE', 'Tòa nhà A - Phòng A202',4),
('AP-A3-01', 'UniWiFi-A3', '192.168.10.31',8, 'ONLINE', 'Tòa nhà A - Phòng A301',5),
('AP-B1-01', 'UniWiFi-B1', '192.168.10.41',40,'ONLINE', 'Tòa nhà B - Phòng B101',6),
('AP-B1-02', 'UniWiFi-B1', '192.168.10.42',35,'ONLINE', 'Tòa nhà B - Phòng B102',7),
('AP-B2-01', 'UniWiFi-B2', '192.168.10.51',20,'ONLINE', 'Tòa nhà B - Phòng B201',8),
('AP-B2-02', 'UniWiFi-B2', '192.168.10.52',5, 'OFFLINE','Tòa nhà B - Phòng B202',9),
('AP-C1-01', 'UniWiFi-C1', '192.168.10.61',50,'ONLINE', 'Tòa nhà C - Phòng C101',10),
('AP-C2-01', 'UniWiFi-C2', '192.168.10.71',45,'ONLINE', 'Tòa nhà C - Phòng C201',11),
('AP-C3-01', 'UniWiFi-C3', '192.168.10.81',28,'ONLINE', 'Tòa nhà C - Phòng C301',12),
('AP-Lab-01','UniWiFi-Lab','192.168.10.91',12,'ONLINE', 'Phòng thực hành mạng',15),
('AP-Lab-02','UniWiFi-Lab','192.168.10.92',6, 'ONLINE', 'Phòng thực hành mạng',15),
('AP-Srv-01','UniWiFi-Srv','192.168.10.99',2, 'ONLINE', 'Phòng máy chủ A',13)
ON CONFLICT DO NOTHING;

INSERT INTO Switch (switch_name, total_ports, used_ports, ip_address, status, room_id) VALUES
('SW-Core-01',48,40,'10.0.2.1',     'ONLINE',     13),
('SW-Core-02',48,38,'10.0.2.2',     'ONLINE',     14),
('SW-A1-01',  24,18,'192.168.20.11','ONLINE',      1),
('SW-A1-02',  24,12,'192.168.20.12','ONLINE',      2),
('SW-A2-01',  24,20,'192.168.20.21','ONLINE',      3),
('SW-A3-01',  16,8, '192.168.20.31','ONLINE',      5),
('SW-B1-01',  48,36,'192.168.20.41','ONLINE',      6),
('SW-B1-02',  48,30,'192.168.20.42','ONLINE',      7),
('SW-B2-01',  24,15,'192.168.20.51','ONLINE',      8),
('SW-B2-02',  24,5, '192.168.20.52','MAINTENANCE', 9),
('SW-C1-01',  48,42,'192.168.20.61','ONLINE',     10),
('SW-C2-01',  48,38,'192.168.20.71','ONLINE',     11),
('SW-C3-01',  24,20,'192.168.20.81','ONLINE',     12),
('SW-Lab-01', 24,14,'192.168.20.91','ONLINE',     15),
('SW-Srv-01', 16,10,'192.168.20.99','ONLINE',     13)
ON CONFLICT DO NOTHING;

INSERT INTO NetworkDevice (device_name, mac_address, ip_address, owner, device_type, status, room_id) VALUES
('Laptop-NguyenVanAn', 'CC:00:00:00:01:01','192.168.30.11','Nguyễn Văn An',  'Laptop',        'ALLOWED',1),
('Laptop-TranMinhDuc', 'CC:00:00:00:01:02','192.168.30.12','Trần Minh Đức',  'Laptop',        'ALLOWED',1),
('Phone-LeThiHoa',     'CC:00:00:00:02:01','192.168.30.21','Lê Thị Hoa',     'Điện thoại',    'ALLOWED',3),
('Laptop-PhamQuocBao', 'CC:00:00:00:02:02','192.168.30.22','Phạm Quốc Bảo', 'Laptop',        'ALLOWED',3),
('Tablet-HoangThiMai', 'CC:00:00:00:03:01','192.168.30.31','Hoàng Thị Mai',  'Máy tính bảng', 'ALLOWED',6),
('Laptop-VuThanhLong', 'CC:00:00:00:03:02','192.168.30.32','Vũ Thanh Long',  'Laptop',        'ALLOWED',6),
('Phone-DangThiThu',   'CC:00:00:00:04:01','192.168.30.41','Đặng Thị Thu',   'Điện thoại',    'ALLOWED',8),
('Laptop-BuiVanKhanh', 'CC:00:00:00:04:02','192.168.30.42','Bùi Văn Khánh', 'Laptop',        'ALLOWED',8),
('Desktop-NgoThiLan',  'CC:00:00:00:05:01','192.168.30.51','Ngô Thị Lan',    'Máy tính bàn',  'ALLOWED',10),
('Laptop-DinhVanPhuc', 'CC:00:00:00:05:02','192.168.30.52','Đinh Văn Phúc', 'Laptop',        'ALLOWED',10),
('Phone-TruongThiNgoc','CC:00:00:00:06:01','192.168.30.61','Trương Thị Ngọc','Điện thoại',   'BLOCKED',11),
('Laptop-CaoVanHieu',  'CC:00:00:00:06:02','192.168.30.62','Cao Văn Hiếu',   'Laptop',        'ALLOWED',11),
('Tablet-LamThiPhuong','CC:00:00:00:07:01','192.168.30.71','Lâm Thị Phương', 'Máy tính bảng', 'ALLOWED',15),
('Laptop-MaiVanThanh', 'CC:00:00:00:07:02','192.168.30.72','Mai Văn Thành',  'Laptop',        'ALLOWED',15),
('Thiet-bi-la-01',     'CC:00:00:00:FF:01','192.168.30.99','Không xác định', 'Không xác định','BLOCKED',1)
ON CONFLICT DO NOTHING;

INSERT INTO IPAddressManagement (ip_address, status, device_id) VALUES
('192.168.30.11','ASSIGNED',1),('192.168.30.12','ASSIGNED',2),
('192.168.30.21','ASSIGNED',3),('192.168.30.22','ASSIGNED',4),
('192.168.30.31','ASSIGNED',5),('192.168.30.32','ASSIGNED',6),
('192.168.30.41','ASSIGNED',7),('192.168.30.42','ASSIGNED',8),
('192.168.30.51','ASSIGNED',9),('192.168.30.52','ASSIGNED',10),
('192.168.30.61','ASSIGNED',11),('192.168.30.62','ASSIGNED',12),
('192.168.30.71','ASSIGNED',13),('192.168.30.72','ASSIGNED',14),
('192.168.30.99','ASSIGNED',15)
ON CONFLICT DO NOTHING;

INSERT INTO BandwidthUsage (upload_speed, download_speed, record_time, device_id) VALUES
(45.2,120.5,NOW() - INTERVAL '90 minutes',1),(38.7,95.3, NOW() - INTERVAL '85 minutes',2),
(22.1,55.8, NOW() - INTERVAL '80 minutes',3),(60.4,180.2,NOW() - INTERVAL '75 minutes',4),
(15.3,40.1, NOW() - INTERVAL '70 minutes',5),(80.0,250.0,NOW() - INTERVAL '65 minutes',6),
(12.5,30.7, NOW() - INTERVAL '60 minutes',7),(55.9,140.3,NOW() - INTERVAL '55 minutes',8),
(90.1,300.5,NOW() - INTERVAL '50 minutes',9),(25.4,70.2, NOW() - INTERVAL '45 minutes',10),
(5.1, 10.3, NOW() - INTERVAL '40 minutes',11),(70.3,200.1,NOW() - INTERVAL '35 minutes',12),
(33.6,88.4, NOW() - INTERVAL '30 minutes',13),(48.2,130.7,NOW() - INTERVAL '25 minutes',14),
(18.9,50.6, NOW() - INTERVAL '20 minutes',1);

INSERT INTO WiFiAnalytics (total_users, peak_users, avg_speed, analytics_date, ap_id) VALUES
(22,35,85.5, CURRENT_DATE - 14,1),(18,28,72.3, CURRENT_DATE - 13,2),
(30,45,90.1, CURRENT_DATE - 12,3),(15,22,65.8, CURRENT_DATE - 11,4),
(8, 12,50.2, CURRENT_DATE - 10,5),(40,58,110.4,CURRENT_DATE -  9,6),
(35,50,95.7, CURRENT_DATE -  8,7),(20,30,78.3, CURRENT_DATE -  7,8),
(5, 8, 40.1, CURRENT_DATE -  6,9),(50,70,125.6,CURRENT_DATE -  5,10),
(45,62,115.2,CURRENT_DATE -  4,11),(28,40,88.9,CURRENT_DATE -  3,12),
(12,18,60.4, CURRENT_DATE -  2,13),(6,10, 45.3,CURRENT_DATE -  1,14),
(2, 4, 30.0, CURRENT_DATE,       15);

INSERT INTO NetworkAlert (alert_type, message, severity, router_id, ap_id, switch_id) VALUES
('Mất kết nối','Core-Router-02 bị mất kết nối đường truyền chính','CRITICAL',2,NULL,NULL),
('Mất kết nối','AP-B2-02 bị ngắt kết nối bất thường','CRITICAL',NULL,9,NULL),
('Mất kết nối','SW-B2-02 không phản hồi sau sự cố nguồn điện','CRITICAL',NULL,NULL,10),
('Hiệu năng','CPU của BldA-Router-01 đang sử dụng ở mức cao','WARNING',3,NULL,NULL),
('Hiệu năng','AP-C1-01 vượt quá số lượng người dùng kết nối tối đa','WARNING',NULL,10,NULL),
('Hiệu năng','Băng thông của SW-Core-01 vượt quá 90%','WARNING',NULL,NULL,1),
('Hiệu năng','Lab-Router-02 phát hiện mất gói dữ liệu','WARNING',10,NULL,NULL),
('Bảo mật','Phát hiện thiết bị lạ trong VLAN-Student-A1','CRITICAL',NULL,1,NULL),
('Bảo mật','Nhiều lần đăng nhập thất bại qua BldB-Router-01','WARNING',5,NULL,NULL),
('Cấu hình','Firmware của BldC-Router-02 đã lỗi thời','INFO',8,NULL,NULL),
('Cấu hình','AP-A3-01 bị tắt phát SSID','INFO',NULL,5,NULL),
('Cấu hình','SW-A3-01 bị sai cấu hình cổng mạng','INFO',NULL,NULL,6),
('Mất kết nối','Backup-Router-01 đang ngoại tuyến, chưa kích hoạt dự phòng','WARNING',15,NULL,NULL),
('Hiệu năng','Tốc độ trung bình của AP-Lab-01 giảm dưới 30 Mbps','WARNING',NULL,13,NULL),
('Bảo mật','SW-C1-01 phát hiện hành vi MAC flooding','CRITICAL',NULL,NULL,11);

INSERT INTO SupportTicket (title, description, status, created_by, device_id) VALUES
('WiFi chậm tại phòng A101','Sinh viên phản ánh tốc độ mạng thấp vào giờ cao điểm','OPEN',5,NULL),
('Không kết nối được UniWiFi-B1','Điện thoại không thể xác thực vào mạng B1','IN_PROGRESS',6,3),
('Lỗi xác thực Eduroam','SSID eduroam trả về lỗi xác thực 802.1X','OPEN',7,NULL),
('Trùng địa chỉ IP trong phòng Lab','Hai thiết bị đang dùng cùng IP 192.168.30.71','RESOLVED',8,13),
('Laptop bị chặn bất thường','Laptop bị chặn truy cập mạng mà không có thông báo','OPEN',9,2),
('Cổng switch không hoạt động','Cổng số 12 trên SW-A1-01 không có tín hiệu','IN_PROGRESS',10,NULL),
('Mất tín hiệu tại phòng A301','Tín hiệu AP-A3-01 rất yếu ở cuối phòng','OPEN',5,NULL),
('Router khởi động lại liên tục','Lab-Router-02 tự khởi động lại mỗi 10 phút','RESOLVED',6,NULL),
('Sai cấu hình VLAN','Thiết bị trong VLAN-Lab không truy cập được VLAN-Server','OPEN',7,NULL),
('Cảnh báo thiết bị lạ','Unknown-Device-01 xuất hiện trong mạng, cần kiểm tra','IN_PROGRESS',8,15),
('Băng thông bị giới hạn','Tốc độ tải xuống của thiết bị bị giới hạn còn 10 Mbps','OPEN',9,8),
('AP B202 ngoại tuyến','AP-B2-02 đã ngoại tuyến từ sáng nay','OPEN',10,NULL),
('Không in được qua mạng','Máy in không truy cập được từ VLAN-Staff-A','RESOLVED',5,NULL),
('Kết nối chậm tại C301','Mạng tầng 3 tòa nhà C bị mất gói không ổn định','OPEN',6,NULL),
('Địa chỉ MAC bị chặn','Thiết bị có MAC CC:00:00:00:06:01 bị chặn truy cập mạng','IN_PROGRESS',7,11);

INSERT INTO MaintenanceSchedule (title, description, start_time, end_time, status) VALUES
('Nâng cấp firmware Core Router','Nâng cấp Core-Router-01 và Core-Router-02 lên phiên bản IOS mới nhất','2026-06-01 22:00','2026-06-02 01:00','PLANNED'),
('Thay thế switch tòa nhà A','Thay SW-A1-02 bằng thiết bị switch 48 cổng mới','2026-06-03 08:00','2026-06-03 12:00','PLANNED'),
('Kiểm tra phần cứng AP-B2-02','Kiểm tra và sửa chữa AP-B2-02 sau sự cố mất kết nối','2026-05-28 09:00','2026-05-28 11:00','COMPLETED'),
('Bảo trì router phòng Lab','Khởi động lại Lab-Router-02 theo lịch sau khi cập nhật bản vá','2026-05-27 22:00','2026-05-27 23:00','COMPLETED'),
('Cập nhật firmware router tòa nhà C','Cập nhật BldC-Router-02 để vá lỗi bảo mật','2026-06-05 20:00','2026-06-05 22:00','PLANNED'),
('Kiểm tra nguồn SW-B2-02','Kiểm tra UPS và bộ nguồn của SW-B2-02','2026-06-04 14:00','2026-06-04 16:00','PLANNED'),
('Kiểm tra dây mạng tòa nhà A','Kiểm tra và dán nhãn toàn bộ dây mạng tại tòa nhà A','2026-06-07 08:00','2026-06-07 17:00','PLANNED'),
('Cập nhật firmware hàng loạt AP','Cập nhật toàn bộ Access Point lên firmware v3.2.1','2026-06-08 22:00','2026-06-09 02:00','PLANNED'),
('Kiểm tra router dự phòng','Thử nghiệm chuyển đổi dự phòng với Backup-Router-01','2026-06-10 10:00','2026-06-10 12:00','PLANNED'),
('Kiểm tra cổng SW-Core-01','Kiểm tra và dọn dẹp các cổng mạng không sử dụng trên SW-Core-01','2026-06-06 09:00','2026-06-06 11:00','PLANNED'),
('Cấu hình lại VLAN phòng Lab','Cấu hình lại VLAN-Lab để hỗ trợ subnet mới','2026-06-11 20:00','2026-06-11 23:00','PLANNED'),
('Khảo sát tín hiệu AP tòa nhà B','Khảo sát vùng phủ sóng WiFi trong tòa nhà B','2026-06-12 08:00','2026-06-12 17:00','PLANNED'),
('Kiểm tra làm mát phòng máy chủ','Kiểm tra hệ thống làm mát tại phòng máy chủ A','2026-05-30 10:00','2026-05-30 12:00','IN_PROGRESS'),
('Dọn dẹp vùng địa chỉ IP','Xóa DHCP lease cũ và cập nhật bảng quản lý IP','2026-06-02 09:00','2026-06-02 11:00','PLANNED'),
('Cập nhật bảo mật toàn bộ switch','Cài đặt bản vá bảo mật cho toàn bộ switch','2026-06-15 22:00','2026-06-16 02:00','PLANNED');

INSERT INTO MaintenanceRouter (maintenance_id, router_id) VALUES
(1,1),(1,2),(4,10),(5,8),(9,15),(3,7),(6,5),(7,3),(7,4),(10,1),(11,9),(12,6),(13,15),(14,3),(15,2);

INSERT INTO MaintenanceAccessPoint (maintenance_id, ap_id) VALUES
(3,9),(8,1),(8,2),(8,3),(8,6),(8,10),(12,6),(12,7),(12,8),(12,9),(7,1),(7,3),(11,13),(14,15),(9,13);

INSERT INTO MaintenanceSwitch (maintenance_id, switch_id) VALUES
(2,4),(6,10),(10,1),(15,1),(15,2),(15,3),(15,7),(15,11),(7,3),(7,4),(11,14),(12,7),(12,8),(13,15),(14,3);

INSERT INTO AuthenticationLog (username, login_status, ip_address, user_id) VALUES
('admin',   'SUCCESS','192.168.1.100',1),('tech01',  'SUCCESS','192.168.1.101',2),
('tech02',  'SUCCESS','192.168.2.101',3),('tech03',  'SUCCESS','192.168.2.102',4),
('viewer01','SUCCESS','192.168.3.101',5),('viewer02','SUCCESS','192.168.3.102',6),
('viewer03','SUCCESS','192.168.10.50',7),('admin',   'SUCCESS','192.168.1.100',1),
('tech01',  'FAILED', '192.168.1.101',NULL),('hacker01','FAILED','10.10.10.1',NULL),
('hacker01','FAILED', '10.10.10.1',  NULL),('hacker02','FAILED','10.10.10.2',NULL),
('viewer07','SUCCESS','192.168.3.107',12),('tech04',  'SUCCESS','192.168.2.111',11),
('unknown', 'FAILED', '172.16.99.1', NULL);

INSERT INTO SystemLog (action, details, performed_by) VALUES
('Đăng nhập','Admin đăng nhập từ địa chỉ 192.168.1.100',1),
('Đăng nhập','tech01 đăng nhập từ địa chỉ 192.168.1.101',2),
('Cập nhật thiết bị','Cập nhật trạng thái AP-B2-02 thành OFFLINE',2),
('Cập nhật thiết bị','Cập nhật trạng thái SW-B2-02 thành MAINTENANCE',3),
('Tạo cảnh báo','Tạo cảnh báo CRITICAL cho sự cố Core-Router-02',1),
('Tạo ticket','Tạo ticket hỗ trợ: WiFi chậm tại phòng A101',5),
('Xử lý ticket','Ticket ID 4 đã được xử lý: sửa lỗi trùng IP trong phòng Lab',2),
('Cập nhật router','Cập nhật firmware BldC-Router-02 lên phiên bản 1.3.1',4),
('Tạo lịch bảo trì','Tạo lịch bảo trì: Nâng cấp firmware Core Router',1),
('Chặn thiết bị','Chặn thiết bị CC:00:00:00:FF:01 do MAC không xác định',2),
('Chặn thiết bị','Chặn thiết bị CC:00:00:00:06:01 do vi phạm chính sách',3),
('Cập nhật VLAN','Cập nhật subnet VLAN-Lab thành 192.168.20.0/24',1),
('Xóa IP','Đánh dấu IP 192.168.30.99 là IP cũ cần kiểm tra',4),
('Đăng nhập','tech04 đăng nhập từ địa chỉ 192.168.2.111',11),
('Đăng xuất','Phiên đăng nhập của Admin đã đóng sau 2 giờ không hoạt động',1);
