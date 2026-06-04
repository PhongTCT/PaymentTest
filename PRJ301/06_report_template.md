---
title: "Bao cao do an — Mau bao cao Tieng Viet"
tags: [prj301, planning, report, vietnamese]
created: 2026-05-26
---

# Mau Bao Cao Do An PRJ301

> [!note]
> Day la mau bao cao bang Tieng Viet cho do an PRJ301 — He thong quan ly mang trong truong dai hoc. Cac ban hay dien noi dung cu the vao tung phan.

---

## Trang bia

```text
TRUONG DAI HOC ............
KHOA CONG NGHE THONG TIN

BAO CAO DO AN
MON: PRJ301 — Lap trinh Web voi Java

TEN DE TAI: He thong Quan ly Mang trong Truong Dai hoc
            (University Network Management System)

Giang vien huong dan: ................................
Sinh vien thuc hien:
  - Sinh vien A: ................................
  - Sinh vien B: ................................
  - Sinh vien C: ................................
  - Sinh vien D: ................................
  
Nam hoc: 2025-2026
```

---

## Loi cam on

> Huong dan: Cam on giang vien huong dan, truong, khoa, va cac ban cung nhom da ho tro trong qua trinh thuc hien do an.

---

## Mucluc

> Huong dan: Tu dong tao muc luc trong Word bang cach dung Heading 1, 2, 3. Sau do: References → Table of Contents.

---

## Chuong 1: Gioi thieu de tai

### 1.1 Dat van de

> Huong dan: Trinh bay ly do chon de tai. Tai sao quan ly mang trong truong dai hoc la can thiet? Van de nao dang gap phai (quang ly thu cong, khong co he thong trung tam, kho kiem tra trang thai thiet bi)?

Vi du:

```text
Trong moi truong truong dai hoc, he thong mang la nen tang quan trong cho hoat dong 
giang day, nghien cuu va quan ly. Tuy nhien, nhieu truong van quan ly mang bang phuong 
phap thu cong, dan den kho khan trong viec kiem tra trang thai thiet bi, xu ly su co, 
va bao duong dinh ky. De tai nay nham xay dung mot he thong Web giup quan ly va giam 
sat he thong mang mot cach hieu qua.
```

### 1.2 Muc tieu cua de tai

> Huong dan: Liệt kê 3-5 mục tiêu cụ thể.

Vi du:

1. Xay dung he thong Web quan ly cac thiet bi mang (Router, AP, Switch)
2. Cho phep giam sat su dung bang thong va phan tich WiFi
3. Ho tro sinh vien gui bao cao su co qua he thong ticket
4. Quan ly lich bao duong va canh bao su co
5. Phan quyen truy cap theo vai tro (Admin, Technician, Viewer)

### 1.3 Pham vi va gioi han

> Huong dan: Mo ta pham vi ung dung va nhung gi khong lam.

```text
- Pham vi: Quan ly thiet bi mang, giam sat, bao cao, ticket, bao duong
- Gioi han: Khong ket noi voi thiet bi that (simulation), khong tich hop SNMP
```

### 1.4 Cong nghe su dung

> Huong dan: Bang tom tat cong nghe.

| Thanh phan | Cong nghe |
|---|---|
| IDE | NetBeans 13 |
| JDK | JDK 8 |
| Server | Apache Tomcat 9 |
| Backend | Servlet/JSP (javax.servlet.*) |
| Database | MySQL 8.0 |
| Build | Ant |
| JDBC | mysql-connector-java-8.0.33.jar |

---

## Chuong 2: Phan tich yeu cau (dung Computational Thinking)

### 2.1 Phan tich bang Computational Thinking

> [!important]
> Day la phan QUAN TRONG NHAT cua bao cao. Trinh bay day du 4 trụ cột CT.

#### 2.1.1 Decomposition (Phan tich de quy)

> Huong dan: Mo ta cach phan tich he thanh cac phan nho. Tham khao [[01_CT_analysis]].

Vi du:

```text
He thong duoc phan tich thanh 5 phan chinh:
1. Xac thuc va phan quyen (Authentication & Authorization)
2. Quan ly thiet bi (Device Management)
3. Giam sat mang (Network Monitoring)
4. Quan ly co so ha tang (Infrastructure Management)
5. Ho tro va bao duong (Support & Maintenance)
```

> Them so do Mermaid tu [[01_CT_analysis]] vao day.

#### 2.1.2 Pattern Recognition (Nhan dien mau)

> Huong dan: Trinh bay cac mau lap lai trong he thong.

```text
Cac mau chinh:
- Mau CRUD: insert/update/delete/findAll — ap dung cho 16 model
- Mau Status: ONLINE/OFFLINE, ACTIVE/INACTIVE, OPEN/CLOSED
- Mau Role-based: Admin/Technician/Viewer
- Mau Date tracking: createdAt, loginTime, recordTime
```

#### 2.1.3 Abstraction (Tong quat hoa)

> Huong dan: Mo ta 3 lop (Presentation → Controller → DAO) va vai tro cua DTO.

```text
He thong su dung kien truc 3 lop:
- Lop Trinh dien (JSP): Hien thi du lieu, nhan input
- Lop Dieu khien (Servlet): Xu ly HTTP, kiem tra du lieu
- Lop Truy cap du lieu (DAO): Thao tac voi MySQL

DTO (Data Transfer Object) la doi tuong trung gian, giu du lieu di giua cac lop.
```

> Them so do Mermaid tu [[01_CT_analysis]].

#### 2.1.4 Algorithm Design (Thiet ke thuat toan)

> Huong dan: Mo ta cac thuat toan chinh. Them flowchart Mermaid.

Cac thuat toan can mo ta:
1. Dang nhap va phan quyen
2. Chan/Mo khoa thiet bi
3. Kich hoat canh bao
4. Xu ly ticket ho tro

> Sao chep cac flowchart tu [[01_CT_analysis]].

### 2.2 Yeu cau chuc nang

> Huong dan: Liệt kê cac chuc nang theo vai tro. Tham khao [[05_feature_list]].

**Admin:**
- Quan ly tai khoan nguoi dung
- Quan ly thiet bi mang (CRUD)
- Giam sat bang thong va WiFi analytics
- Quan ly ticket va lich bao duong
- Xem nhat ki he thong

**Technician:**
- Xem va cap nhat trang thai thiet bi
- Chan/mo khoa thiet bi sinh vien
- Xu ly ticket ho tro
- Xem canh bao va lich bao duong

**Viewer:**
- Xem trang thai mang
- Gui ticket bao cao su co
- Xem lich bao duong

### 2.3 Yeu cau phi chuc nang

> Huong dan: Mo ta cac yeu cau ve hieu suat, bao mat, su dung.

```text
- Hieu suat: Trang tai trong < 3 giây
- Bao mat: Mat khau ma hoa, phan quyen theo vai tro
- Tuong thich: Chrome, Firefox, Edge
- Giao dien: Responsive, de su dung
```

---

## Chuong 3: Thiet ke he thong

### 3.1 Sơ đồ luồng dữ liệu (ERD)

> Huong dan: Chen so do ERD tu [[02_erd_database]]. Giai thich cac bang va moi quan he.

```text
He thong gom 16 bang du lieu:
[Liệt kê tất cả 16 bảng và mô tả ngắn gọn]
```

> Chen mermaid ERD tu [[02_erd_database]].

### 3.2 Kien truc he thong

> Huong dan: Mo ta kien truc 3 lop. Chen so do tu [[04_system_architecture]].

```text
Kien truc he thong gom 3 lop:
1. Lop Trinh dien (JSP + CSS + JS)
2. Lop Dieu khien (Servlet)
3. Lop Du lieu (DAO + MySQL)
```

### 3.3 Cau truc thu muc

> Huong dan: Chen cau truc thu muc tu [[04_system_architecture]].

### 3.4 Thiet ke giao dien

> Huong dan: Chen screenshot cac man hinh chinh.

Can screenshot:
- [ ] Trang dang nhap
- [ ] Dashboard
- [ ] Danh sach thiet bi
- [ ] Form them/sua thiet bi
- [ ] Bang giam sat
- [ ] Danh sach ticket
- [ ] Lich bao duong
- [ ] Canh bao

---

## Chuong 4: Cai dat va trien khai

### 4.1 Moi truong phat trien

> Huong dan: Mo ta cach cai dat NetBeans, Tomcat, MySQL. Tham khao [[PRJ301_Project_Setup_Guide]].

### 4.2 Cai dat co so du lieu

> Huong dan: Chen script SQL tu [[02_erd_database]]. Mo ta cach chay script.

### 4.3 Cac buoc cai dat

> Huong dan: Huong dan tung buoc.

```text
1. Cai dat JDK 8 va NetBeans 13
2. Dang ky Tomcat 9 trong NetBeans
3. Tao project Java Web (Ant)
4. Them MySQL Connector/J vao Libraries
5. Tao database va chay script SQL
6. Copy code vao project
7. Chay project tren Tomcat
```

### 4.4 Ma nguon — Cac lop chinh

> Huong dan: Trinh bay ma nguon cua cac lop quan trong nhat.

Can bao gom:
- `DBContext.java` — Ket noi database
- `UserDAO.java` — Truy van nguoi dung
- `LoginServlet.java` — Xu ly dang nhap
- `Router.java` — DTO mau

> Tham khao [[07_coding_guide]] de co mau day du.

---

## Chuong 5: Ket qua va danh gia

### 5.1 Ket qua thuc hien

> Huong dan: Tom tat nhung gi da lam duoc.

```text
- Da hoan thanh 16 model (DTO + DAO)
- Da hoan thanh 15 Servlet va 30+ JSP
- Dang nhap va phan quyen hoat dong
- CRUD cho tat ca thiet bi hoat dong
- Giam sat bang thong va analytics hoat dong
- He thong ticket va bao duong hoat dong
```

### 5.2 Huong dan su dung

> Huong dan: Mo ta cach su dung he thong cho tung vai tro.

### 5.3 Huong dan phat trien

> Huong dan: De xuat cac huong phat trien tiep theo.

```text
1. Ket noi voi thiet bi that qua SNMP
2. Them bieu do (Chart.js) cho analytics
3. Xuat bao cao ra PDF
4. Them thong bao qua email
5. Trien khai len server that
```

### 5.4 Bai hoc rut ra

> Huong dan: Mo ta nhung gi nhom hoc duoc tu do an.

```text
- Quan ly code trong nhom can Git
- Database design quan trong truoc khi code
- Computational Thinking giup phan tich de bai ro rang
- Servlet/JSP la nen tang tot cho ung dung Web
```

---

## Tai lieu tham khao

> Huong dan: Liệt kê cac tai lieu tham khao.

1. Java Servlet Specification 3.1
2. MySQL 8.0 Reference Manual
3. Apache Tomcat 9 Documentation
4. NetBeans IDE Documentation
5. Giang vien — Bai giang PRJ301

---

## Phu luc

> Huong dan: Chen them cac phu luc neu can.

- Phu luc A: Script SQL day du
- Phu luc B: Ma nguong cac lop chinh
- Phu luc C: Screenshot he thong
- Phu luc D: Phan cong cong viec chi tiet

---

## Huong dan viet bao cao

> [!tip]
> **Luu y khi viet bao cao:**
> - Su dung Heading 1 cho moi chuong (Chuong 1, 2, 3...)
> - Su dung Heading 2 cho moi muc (2.1, 2.2...)
> - Chen hinh anh voi caption ro rang
> - Danh so trang tu trang 1
> - Font: Times New Roman, size 13
> - Can le 2 trai, 2 phai, 2 tren, 2 duoi
> - In hai mat neu co the

---

## Lien ket

- [[00_project_overview]] — Tong quan de tai
- [[01_CT_analysis]] — Phan tich CT day du
- [[02_erd_database]] — ERD va SQL
- [[03_team_assignment]] — Phan cong nhom
- [[05_feature_list]] — Danh sach chuc nang
- [[07_coding_guide]] — Huong dan lap trinh
