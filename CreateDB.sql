CREATE DATABASE QL_BH
GO
CREATE TABLE NHAN_VIEN
(
manv CHAR(3) PRIMARY KEY,
honv NVARCHAR(20) NOT NULL,
tennv NVARCHAR(10) NOT NULL,
gioitinh NVARCHAR(3) CHECK (gioitinh IN (N'Nam', N'Nữ')),
ngaysinh DATE NOT NULL,
diachi NVARCHAR(45) NOT NULL,
sdtnv VARCHAR(12) NOT NULL,
ngaydilam DATE NOT NULL,
mucluong REAL DEFAULT(4000000),
macv CHAR(3),
)

CREATE TABLE CHUC_VU
(
macv CHAR(3) PRIMARY KEY,
tencv NVARCHAR(50) NOT NULL,
motacv NVARCHAR(150),
)

CREATE TABLE KHACH_HANG
(
makh CHAR(5) PRIMARY KEY,
hokh NVARCHAR(20) NOT NULL,
tenkh NVARCHAR(10) NOT NULL,
gioitinh NVARCHAR(3) CHECK (gioitinh IN (N'Nam', N'Nữ')),
ngaysinh DATE NOT NULL,
diachi NVARCHAR(45),
sdtkh VARCHAR(12),
mathe CHAR(5),
manv CHAR(3),
)

CREATE TABLE THE_KHACH_HANG
(
mathe CHAR(5) PRIMARY KEY,
diemtichluy INT NOT NULL,
hangthe NVARCHAR(10),
)

CREATE TABLE UU_DAI
(
hangthe NVARCHAR(10) PRIMARY KEY,
tyleud FLOAT NOT NULL,
)
CREATE TABLE NHAN_HIEU
( 
manh nvarchar(20) primary key,
tennh nvarchar (30) NOT NULL,
sdtnh varchar(12) NOT NULL,
)

CREATE TABLE LOAI_SAN_PHAM
(
maloaisp char (5) primary key,
tenloaisp nvarchar (20),
)

CREATE TABLE SAN_PHAM
(
masp char(5), 
size char(5),
tensp nvarchar(30) NOT NULL,
chatlieu nvarchar(10) NOT NULL,
sohienhanh int NOT NULL,
giaban real,
giagoc real,
maloaisp char (5),
manh nvarchar(20),
primary key (masp,maloaisp, size),
)

CREATE TABLE HOA_DON
(
mahd char(5) primary key,
ngaylaphd date NOT NULL,
manv char(3),
makh char (5),
hangthe nvarchar (10),
tongtienhd real,
tongtienphaitra real,
)

CREATE TABLE CHI_TIET_HD
(
mahd char (5),
masp char(5),
size char (5),
soluong INT,
primary key (masp, size, mahd),
)

CREATE TABLE PHIEU_DAT_HANG
(
maphieudat CHAR(5) PRIMARY KEY,
ngaydat DATE NOT NULL,
tongtiendat INT,
manv CHAR(3),
masp CHAR(5),
size CHAR(5),
soluongdat INT,
manh NVARCHAR(20),
)

CREATE TABLE PHIEU_NHAP_HANG
(
maphieunhap CHAR(5) PRIMARY KEY,
ngaygiao DATE NOT NULL,
soluongnhap INT,
manv CHAR(3),
masp CHAR(5),
size CHAR(5),
maphieudat CHAR(5),
)

CREATE TABLE PHIEU_KIEM_TON_KHO
(
maphieukth CHAR(6) PRIMARY KEY,
ngaykiem DATE NOT NULL,
manv CHAR(3),
)

CREATE TABLE CHI_TIET_TK
(
masp CHAR(5) NOT NULL,
size CHAR(5) NOT NULL,
maphieukth CHAR(6) NOT NULL,
soluongdat INT NOT NULL,
shhtruocbs INT NOT NULL,
primary key (masp, size, maphieukth)
)



