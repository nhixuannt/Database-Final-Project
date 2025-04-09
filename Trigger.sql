--Trigger

--1/ sdtnv của bảng NHAN_VIEN và sdtkh của bảng KHACH_HANG chỉ chứa giá trị số
--Trigger bảng NHAN_VIEN
CREATE TRIGGER trg_sdtnv
ON NHAN_VIEN
AFTER INSERT, UPDATE
AS
BEGIN
DECLARE @sdtnv VARCHAR(12);
SELECT @sdtnv = sdtnv
FROM inserted
IF @sdtnv LIKE '%[^0-9]%'
BEGIN
   	PRINT (N'Số điện thoại nhân viên phải là chữ số')
   	ROLLBACK TRANSACTION
END
END

--Trigger bảng KHACH_HANG
CREATE TRIGGER trg_sdtkh
ON KHACH_HANG
AFTER INSERT, UPDATE
AS
BEGIN
DECLARE @sdtkh VARCHAR(12);
SELECT @sdtkh = sdtkh
FROM inserted
IF @sdtkh LIKE '%[^0-9]%'
BEGIN
   	PRINT (N'Số điện thoại khách hàng phải là chữ số')
   	ROLLBACK TRANSACTION
END
END

--2/ Nhân viên phải có độ tuổi từ 18 tuổi trở lên
CREATE TRIGGER trg_tuoinv
ON NHAN_VIEN
AFTER INSERT, UPDATE
AS
BEGIN
DECLARE @tuoi INT;
SELECT @tuoi = YEAR(GETDATE()) - YEAR(NGAYSINH)
FROM inserted
IF @tuoi <= 18
BEGIN
   	PRINT (N'Nhân viên không được bé hơn 18 tuổi')
   	ROLLBACK TRANSACTION
END
END

--3/Có một và chỉ một nhân viên Quản lý trong bảng NHAN_VIEN
CREATE TRIGGER tr_nvquanly ON NHAN_VIEN
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @sonvqly INT;
    SELECT @sonvqly = COUNT(*) FROM NHAN_VIEN NV
    WHERE macv IN (SELECT NV.macv
                	FROM NHAN_VIEN NV
                	JOIN CHUC_VU CV ON NV.macv = CV.macv               	         	WHERE CV.tencv = N'Nhân viên quản lý'
                	);
IF @sonvqly > 1 OR @sonvqly = 0
    BEGIN
    	PRINT (N'Có một và chỉ một nhân viên quản lý trong bảng nhân viên.');
    	ROLLBACK TRANSACTION;
    END
END

--4/ Chỉ nhân viên Thu ngân mới thực hiện thu tiền và lập hóa đơn
--Trigger bảng HOA_DON
CREATE TRIGGER trg_nvthungan ON HOA_DON
AFTER INSERT, UPDATE
AS
BEGIN
   	DECLARE @manv CHAR(3)
   	SELECT @manv = manv
   	FROM inserted
   	IF @manv NOT IN (SELECT NV.manv
                       	FROM NHAN_VIEN NV JOIN CHUC_VU CV
                       	ON NV.macv = CV.macv
                       	WHERE CV.tencv = 'Nhân viên thu ngân'
                       	)
   	BEGIN
         	PRINT (N'Chỉ có nhân viên thu ngân mới được lập hóa đơn')
         	ROLLBACK TRANSACTION
  	END
END
 
--Trigger bảng NHAN_VIEN
CREATE TRIGGER tr_nvthungan ON NHAN_VIEN
AFTER UPDATE, DELETE
AS
BEGIN
   	DECLARE @manv char(3), @macv char(3)
   	SELECT @manv = manv , @macv = macv
   	FROM deleted
   	IF  @manv  IN (SELECT manv
                             	FROM HOA_DON)                 	
                       	
   	BEGIN
         	PRINT (N'Không xóa hoặc sửa nhân viên thu ngân, hóa đơn chỉ có thể do nhân viên thu ngân thực hiện.');
         	ROLLBACK TRANSACTION
   	END
END

--5/Chỉ nhân viên Bán hàng thực hiện hỗ trợ tư vấn cho khách hàng
--Trigger bảng HOA_DON
CREATE TRIGGER trg_nvbanhang ON KHACH_HANG
AFTER INSERT, UPDATE
AS
BEGIN
   	DECLARE @manv CHAR(3)
   	SELECT @manv = manv
   	FROM inserted
   	IF @manv NOT IN (SELECT NV.manv
                       	FROM NHAN_VIEN NV JOIN CHUC_VU CV
                       	ON NV.macv = CV.macv
                       	WHERE CV.tencv = 'Nhân viên bán hàng'
                       	)
   	BEGIN
         	PRINT (N'Chỉ có nhân viên bán hàng mới thực hiện tư vấn khách hàng')
         	ROLLBACK TRANSACTION
   	END
END
 
--Trigger bảng NHAN_VIEN
CREATE TRIGGER tr_nvbanhang ON NHAN_VIEN
AFTER UPDATE
AS
BEGIN
   	DECLARE @manv char(3), @macv char(3)
		SELECT @manv = manv , @macv = macv
   	FROM deleted
   	IF  @manv  IN (SELECT manv
                             	FROM KHACH_HANG)                     	
                       	
   	BEGIN
         	PRINT (N'Không sửa nhân viên bán hàng, hách hàng chỉ được hỗ trợ tư vấn bởi nhân viên bán hàng.');
         	ROLLBACK TRANSACTION
   	END
END

--6/Chỉ nhân viên kiểm kho mới thực hiện kiểm kho
--Trigger bảng PHIEU_KIEM_TON_KHO
CREATE TRIGGER trg_rb6pktk ON PHIEU_KIEM_TON_KHO
AFTER INSERT, UPDATE
AS
BEGIN
   	DECLARE @manv CHAR(3)
   	SELECT @manv = manv
   	FROM inserted
   	IF @manv NOT IN (SELECT NV.manv
                             	FROM NHAN_VIEN NV JOIN CHUC_VU CV
                             	ON NV.macv = CV.macv
                             	WHERE CV.tencv = N'Nhân viên kiểm tra kho'
                   	 	)
   	BEGIN
     	 	PRINT (N'Chỉ có nhân viên kiểm kho mới thực hiện kiểm kho ')
     	 	ROLLBACK TRANSACTION
   	END
END
 
--Trigger bảng NHAN_VIEN
CREATE TRIGGER trg_rb6nv ON NHAN_VIEN
AFTER UPDATE
AS
BEGIN
   	DECLARE @manv char(3), @macv char(3)
   	SELECT @manv = manv , @macv = macv
   	FROM deleted
   	IF  @manv  IN (SELECT manv
               	FROM PHIEU_KIEM_TON_KHO)                 	 	
                   	 	
   	BEGIN
     	 	PRINT (N'Không sửa nhân viên kiểm tra kho, việc kiểm kho đang được nhân viên kiểm tra kho đảm nhận.');
     	 	ROLLBACK TRANSACTION
   	END
END

--7/Chỉ nhân viên kiểm kho mới thực hiện lập phiếu nhập hàng
--Trigger bảng PHIEU_NHAP_HANG
CREATE TRIGGER trg_rb7pnh ON PHIEU_NHAP_HANG
AFTER INSERT, UPDATE
AS
BEGIN
   	DECLARE @manv CHAR(3)
   	SELECT @manv = manv
   	FROM inserted
   	IF @manv NOT IN (SELECT NV.manv
                             	FROM NHAN_VIEN NV JOIN CHUC_VU CV
                             	ON NV.macv = CV.macv
                             	WHERE CV.tencv = N'Nhân viên kiểm tra kho'
                   	 	)
   	BEGIN
     	 	PRINT (N'Chỉ có nhân viên kiểm kho mới thực hiện lập phiếu nhập hàng')
     	 	ROLLBACK TRANSACTION
   	END
END
 
--Trigger bảng NHAN_VIEN
CREATE TRIGGER trg_rb7nv ON NHAN_VIEN
AFTER UPDATE
AS
BEGIN
   	DECLARE @manv char(3), @macv char(3)
   	SELECT @manv = manv , @macv = macv
   	FROM deleted
   	IF  @manv  IN (SELECT manv
               	FROM PHIEU_NHAP_HANG)                 	
                   	 	
   	BEGIN
     	 	PRINT (N'Không sửa nhân viên kiểm tra kho, việc nhập hàng đang được nhân viên kiểm tra kho đảm nhận.');
     	 	ROLLBACK TRANSACTION
   	END
END

--8/Mỗi khách hàng chỉ có một mã thẻ duy nhất
--Trigger bảng NHAN_VIEN
CREATE TRIGGER trg_rb8 ON KHACH_HANG
AFTER INSERT, UPDATE
AS
BEGIN
   	DECLARE @mathe CHAR(5)
   	DECLARE @solgmathe INT
   	SELECT @mathe = mathe FROM inserted
   	SELECT @solgmathe = COUNT(*) FROM KHACH_HANG
   	WHERE @mathe = mathe
   	IF @solgmathe <> 1
   	BEGIN
         	PRINT(N'Mỗi khách hàng chỉ sở hữu duy nhất một thẻ khách hàng')
         	ROLLBACK TRANSACTION
   	END
END

--9/ Khách hàng có tổng điểm tích lũy bé hơn hoặc bằng 4 chỉ có thể là hạng Đồng
CREATE TRIGGER trg_rb9 ON THE_KHACH_HANG
AFTER insert, update
AS
BEGIN
   	DECLARE @diemtichluy int, @hangthe nvarchar(10);
   	SELECT @diemtichluy = diemtichluy, @hangthe = hangthe FROM inserted
   	IF @diemtichluy <= 4 AND @hangthe <> N'D'
   	BEGIN
         	PRINT (N'Khách hàng có số điểm tích lũy bé hơn hoặc bằng 4 chỉ có thể là hạng Đồng.');
         	ROLLBACK TRANSACTION
   	END
END

--10/Khách hàng có tổng điểm tích lũy lớn hơn hoặc bằng 5 và bé hơn hoặc bằng 9 chỉ có thể là hạng Bạc
CREATE TRIGGER trg_rb10 ON THE_KHACH_HANG
AFTER insert, update
AS
BEGIN
   	DECLARE @diemtichluy int, @hangthe nvarchar(10);
   	SELECT @diemtichluy = diemtichluy, @hangthe = hangthe FROM inserted
   	IF @diemtichluy >= 5 AND @diemtichluy <= 9 AND @hangthe <> N'B'
   	BEGIN
         	PRINT (N'Khách hàng có tổng điểm tích lũy lớn hơn hoặc bằng 5 và bé hơn hoặc bằng 9 chỉ có thể là hạng Bạc.');
         	ROLLBACK TRANSACTION
   	END
END

--11/Khách hàng có tổng điểm tích lũy lớn hơn hoặc bằng 10 và bé hơn 20 chỉ có thể là hạng Vàng
CREATE TRIGGER trg_rb11 ON THE_KHACH_HANG
AFTER insert, update
AS
BEGIN
   	DECLARE @diemtichluy int, @hangthe nvarchar(10);
   	SELECT @diemtichluy = diemtichluy, @hangthe = hangthe FROM inserted
   	IF @diemtichluy >= 10 AND @diemtichluy <= 20 AND @hangthe <> N'V'
   	BEGIN
         	PRINT (N'Khách hàng có tổng điểm tích lũy lớn hơn hoặc bằng 10 và bé hơn 20 chỉ có thể là hạng Vàng.');
         	ROLLBACK TRANSACTION
   	END
END

--12/Khách hàng có tổng điểm tích lũy lớn hơn hoặc bằng 20 và bé hơn hoặc bằng 30 chỉ có thể là hạng Bạch kim 
CREATE TRIGGER trg_rb12 ON THE_KHACH_HANG
AFTER insert, update
AS
BEGIN
   	DECLARE @diemtichluy int, @hangthe nvarchar(10);
   	SELECT @diemtichluy = diemtichluy, @hangthe = hangthe FROM inserted
   	IF @diemtichluy > 20 AND @diemtichluy <= 30 AND @hangthe <> N'BK'
   	BEGIN
         	PRINT (N'  Khách hàng có tổng điểm tích lũy lớn hơn 20 và bé hơn hoặc bằng 30 chỉ có thể là hạng Bạch kim.');
         	ROLLBACK TRANSACTION
   	END
END

--13/ Khách hàng có tổng điểm tích lũy lớn hơn 30 chỉ có thể là hạng Kim cương 
CREATE TRIGGER trg_rb13 ON THE_KHACH_HANG
AFTER insert, update
AS
BEGIN
   	DECLARE @diemtichluy int, @hangthe nvarchar(10);
   	SELECT @diemtichluy = diemtichluy, @hangthe = hangthe FROM inserted
   	IF @diemtichluy > 30 AND @hangthe <> N'KC'
   	BEGIN
         	PRINT (N'  Khách hàng có tổng điểm tích lũy lớn hơn 30 chỉ có thể là hạng Kim Cương.');
         	ROLLBACK TRANSACTION
   	END
END

--