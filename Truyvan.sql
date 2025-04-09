--TRUY VẤN DỮ LIỆU
--1/Truy vấn một bảng:  Danh sách thông tin khách hàng có giới tính là nữ
SELECT *
FROM KHACH_HANG
WHERE gioitinh= N'Nữ'

--2/Truy vấn nhiều bảng: Danh sách nhân viên thu ngân
SELECT CV.tencv, NV.*
FROM CHUC_VU CV, NHAN_VIEN NV
WHERE NV.macv=CV.macv AND tencv=N'Nhân viên thu ngân'

--3/Truy vấn có điều kiện: Danh sách thông tin khách hàng có điểm tích lũy từ 15 đến 30 
--và được sắp xếp theo thứ tự alphabet của tên khách hàng
SELECT TKH.diemtichluy, TKH.hangthe, KH.*
FROM KHACH_HANG KH
JOIN THE_KHACH_HANG TKH ON TKH.mathe = KH.mathe
WHERE TKH.diemtichluy BETWEEN 15 AND 30
ORDER BY tenkh

--4/Truy vấn có tính toán: Danh sách những nhân viên nam có mức lương cao hơn 
--mức lương trung bình của các nhân viên trong cửa hàng
DECLARE @luongtb REAL
SELECT @luongtb = AVG (mucluong) FROM NHAN_VIEN
SELECT * FROM NHAN_VIEN WHERE mucluong > @luongtb and gioitinh = N'Nam'

--5/Truy vấn gom nhóm (GROUP BY): 

--a) Danh sách họ và tên khách hàng thuộc hóa đơn có số lượng sản phẩm nhiều nhất
SELECT mahd, makh,hotenkh FROM 
(SELECT tongsl,mahd,TH.makh, hokh + ' ' + tenkh as hotenkh FROM 
 (SELECT tongsl, TSL.mahd , makh FROM 
  (SELECT SUM (soluong) AS tongsl , mahd FROM CHI_TIET_HD GROUP BY mahd)AS TSL      
  JOIN HOA_DON ON TSL.mahd = HOA_DON.mahd ) as TH 
 JOIN KHACH_HANG ON KHACH_HANG.makh = TH.makh) AS TONGHOP
JOIN (SELECT MAX (tongsl) as SLLN from 
      (SELECT SUM (soluong) AS tongsl ,mahd  
       FROM CHI_TIET_HD GROUP BY mahd ) AS TSL1 ) as TONG 
ON SLLN = tongsl

--b)Danh sách họ và tên khách hàng thuộc hóa đơn có số lượng sản phẩm ít nhất
SELECT mahd, makh,hotenkh FROM 
(SELECT tongsl,mahd,TH.makh, hokh + ' ' + tenkh AS hotenkh FROM 
 (SELECT tongsl, TSL.mahd , makh FROM 
  (SELECT SUM (soluong) AS tongsl , mahd FROM CHI_TIET_HD GROUP BY mahd)AS TSL      
  JOIN HOA_DON ON TSL.mahd = HOA_DON.mahd ) AS TH 
 JOIN KHACH_HANG ON KHACH_HANG.makh = TH.makh) AS TONGHOP
JOIN (SELECT MIN (tongsl) AS SLLN from 
      (SELECT SUM (soluong) AS tongsl ,mahd  
       FROM CHI_TIET_HD GROUP BY mahd ) AS TSL1 ) as TONG 
ON SLLN = tongsl

--6/Truy vấn gom nhóm có điều kiện (HAVING):

--a) Danh sách những sản phẩm thuộc nhiều hơn 1 hóa đơn
SELECT * FROM 
( SELECT COUNT (mahd) AS SLHD, masp from CHI_TIET_HD
GROUP BY masp
HAVING COUNT (mahd) > 1 ) AS SL JOIN SAN_PHAM
ON SAN_PHAM.masp = SL.masp

--b) Danh sách hạng thẻ và số lượng khách hàng thuộc hạng thẻ đó có số điểm tích lũy 
--trung bình của hạng thẻ trên 20 điểm
SELECT hangthe, COUNT (THE_KHACH_HANG.mathe) as SLKH,AVG (diemtichluy) AS DTLTB FROM THE_KHACH_HANG
GROUP BY hangthe 
HAVING AVG (diemtichluy) > 20

--7/ Truy vấn có giao, hội, trừ: 

--a) Danh sách mô tả công việc của mỗi nhân viên trong cửa hàng
SELECT manv, honv, tennv, motacv FROM NHAN_VIEN
LEFT JOIN CHUC_VU ON NHAN_VIEN.macv = CHUC_VU.macv
INTERSECT
SELECT manv, honv, tennv, motacv FROM NHAN_VIEN
RIGHT JOIN CHUC_VU ON NHAN_VIEN.macv = CHUC_VU.macv;

--b) Danh sách loại sản phẩm của từng sản phẩm
SELECT tensp, tenloaisp FROM SAN_PHAM	
	LEFT JOIN LOAI_SAN_PHAM ON SAN_PHAM.maloaisp = LOAI_SAN_PHAM.maloaisp
UNION
SELECT tensp, tenloaisp FROM SAN_PHAM	
	RIGHT JOIN LOAI_SAN_PHAM ON SAN_PHAM.maloaisp = LOAI_SAN_PHAM.maloaisp;

--c) Danh sách mã sản phẩm không có trong phiếu nhập hàng
SELECT masp FROM SAN_PHAM
EXCEPT SELECT masp FROM PHIEU_NHAP_HANG;

--8/ Truy vấn con : Danh sách họ tên nhân viên làm nhân viên thu ngân
SELECT honv, tennv FROM NHAN_VIEN
WHERE macv IN (SELECT macv FROM CHUC_VU WHERE macv = 'C03');
