CREATE OR ALTER PROCEDURE ThemTacGia
	@HoTen NVARCHAR(50),
	@Email VARCHAR(30)
AS BEGIN
	INSERT INTO TacGia (HoTen, Email) VALUES
	(@HoTen, @Email)
	
	RETURN IDENT_CURRENT('TacGia')
END
GO


CREATE OR ALTER PROCEDURE ThemTheLoai
	@TenTheLoai NVARCHAR(30)
AS BEGIN
	INSERT INTO TheLoai (TenTheLoai) VALUES
	(@TenTheLoai)
	
	RETURN IDENT_CURRENT('TheLoai')
END
GO


CREATE OR ALTER PROCEDURE ThemNXB
	@TenNXB NVARCHAR(30),
	@SDT VARCHAR(10),
	@Email VARCHAR(30)
AS BEGIN 
	INSERT INTO NhaXuatBan (TenNXB, SDT, Email) VALUES
	(@TenNXB, @SDT, @Email)
	
	RETURN IDENT_CURRENT('NhaXuatBan')
END
GO


CREATE OR ALTER PROCEDURE ThemChucVu
	@TenChucVu NVARCHAR(30)
AS BEGIN 
	INSERT INTO ChucVu (TenChucVu) VALUES
	(@TenChucVu)
	
	RETURN IDENT_CURRENT('ChucVu')
END
GO


CREATE OR ALTER PROCEDURE ThemKhachHang
	@HoTen NVARCHAR(50),
	@DiaChi NVARCHAR(30),
	@SDT VARCHAR(10),
	@Email VARCHAR(30)
AS BEGIN
	INSERT INTO KhachHang (HoTen, DiaChi, SDT, Email) VALUES
	(@HoTen, @DiaChi, @SDT, @Email)
	
	RETURN IDENT_CURRENT('KhachHang')
END
GO


CREATE OR ALTER PROCEDURE ThemSach
	@TenSach NVARCHAR(80),
	@GiaNhap DECIMAL(19, 4),
	@SoTrang INT,
	@IDNxb NVARCHAR(30),
	@IDTheLoai NVARCHAR(MAX), -- 'The loai A, The loai B' -> STRING_SPLIT(@TenTheLoai, ',') 
	@IDTacGia NVARCHAR(MAX)  -- 'Tac gia A, Tac gia B' -> STRING_SPLIT(@TenTacGia, ',')
AS BEGIN
	IF (
		NOT EXISTS(SELECT * FROM NhaXuatBan nxb WHERE nxb.ID = @IDNxb) OR
		NOT EXISTS(SELECT * FROM TheLoai tl WHERE tl.ID = @IDTheLoai) OR
		NOT EXISTS(SELECT * FROM TacGia tg WHERE tg.ID = @IDTacGia)
	) BEGIN 
		THROW 1, N'ID không tồn tại trong 1 trong các bảng NhaXuatBan, TheLoai, TacGia', 1
	END
	
	INSERT INTO Sach (TenSach, GiaNhap, SoTrang, IDNhaXuatBan) VALUES
	(@TenSach, @GiaNhap, @SoTrang, @IDNxb)
	
	DECLARE @IDSach INT = IDENT_CURRENT('Sach')
	INSERT INTO TacGia_Sach (IDTacGia, IDSach) VALUES
	(@IDTacGia, @IDSach)
	INSERT INTO TheLoai_Sach (IDTheLoai, IDSach) VALUES
	(@IDTheLoai, @IDSach)
END
GO


CREATE OR ALTER PROCEDURE ThemNhanSu
	@HoTen NVARCHAR(50),
	@DiaChi NVARCHAR(50),
	@SDT VARCHAR(10),
	@Email VARCHAR(30),
	@UserName VARCHAR(30),
	@MatKhau CHAR(4),
	@TenChucVu NVARCHAR(30)
AS BEGIN 
	DECLARE @IDChucVu INT = -1
	
	SELECT TOP 1 @IDChucVu = cv.ID
	FROM ChucVu cv
	WHERE cv.TenChucVu = @TenChucVu
	
	IF @IDChucVu = -1
	BEGIN
		DECLARE @msg NVARCHAR(2046) = CONCAT('Khong co chuc vu ', @TenChucVu);
		THROW 50000, @msg, 1
	END
	
	INSERT INTO NhanSu (HoTen, DiaChi, SDT, Email, UserName, MatKhau, IDChucVu) VALUES
	(@HoTen, @DiaChi, @SDT, @Email, @UserName, @MatKhau, @IDChucVu)
	
	RETURN IDENT_CURRENT('NhanSu')
END
GO


CREATE OR ALTER PROCEDURE ThemLichSuNhapBan
	@IDSach VARCHAR(MAX), -- '#id1, #id2, ...'
	@SoLuong VARCHAR(MAX), -- '#sl1, #sl2, ...'
	@Gia VARCHAR(MAX) -- '#gia1, #gia2, ...'
AS BEGIN
	DECLARE @IDLichSu INT,
			@TonTruoc INT = 0,
			@IDSachCursor INT,
			@SoLuongCursor INT,
			@GiaCursor DECIMAL(19, 4),
			@countID INT,
			@countSL INT,
			@countG INT
	
	DECLARE @IDs TABLE(id INT IDENTITY, value INT)
	DECLARE @SLs TABLE(id INT IDENTITY, value INT)
	DECLARE @GIAs TABLE(id INT IDENTITY, value DECIMAL(19, 4))
	
	INSERT INTO @IDs (value) SELECT value FROM STRING_SPLIT(@IDSach, ',')
	INSERT INTO @SLs (value) SELECT value FROM STRING_SPLIT(@SoLuong, ',')
	INSERT INTO @GIAs (value) SELECT value FROM STRING_SPLIT(@Gia, ',')
	
	SELECT @countID = COUNT(ids.id) FROM @IDs ids
	SELECT @countSL = COUNT(sls.id) FROM @SLs sls
	SELECT @countG = COUNT(gs.id) FROM @GIAs gs
	IF @countID <> @countSL OR @countSL <> @countG
	BEGIN
		DECLARE @ERR_MSG NVARCHAR(MAX) = FORMATMESSAGE(N'Độ dài 2 mảng IDSach và SoLuong không bằng nhau (%d != %d)', @countID, @countG);
		THROW 50000, @ERR_MSG, 1
	END	
		
	BEGIN TRANSACTION NHAP_LICHSU
	
	DECLARE array_cursor CURSOR FOR
	SELECT ids.value, sls.value, gis.value
	FROM @IDs ids
	INNER JOIN @SLs sls ON ids.id = sls.id
	INNER JOIN @GIAs gis ON ids.id = gis.id
	
	OPEN array_cursor
	
	FETCH NEXT FROM array_cursor
	INTO @IDSachCursor, @SoLuongCursor, @GiaCursor
	
		INSERT INTO LichSuNhapBan (ThoiDiem) VALUES
		(GETDATE())
		
		SELECT @IDLichSu = IDENT_CURRENT('LichSuNhapBan')
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF EXISTS(
				SELECT *
				FROM LichSuNhapBan lsnbs
				INNER JOIN Sach_LichSuNhapBan slsnb ON lsnbs.ID = slsnb.IDLichSu
				WHERE slsnb.IDSach = @IDSachCursor
			)
			BEGIN
				
				WITH history AS (
					SELECT *
					FROM Sach_LichSuNhapBan slsnb 
					INNER JOIN LichSuNhapBan lsnbs ON slsnb.IDLichSu = lsnbs.ID
					WHERE slsnb.IDSach = @IDSachCursor
				)
				SELECT @TonTruoc = history.TonTruoc + history.SoLuong
				FROM history
				WHERE history.ThoiDiem >= ALL(SELECT history.ThoiDiem FROM history)
				
			END
			
			INSERT INTO Sach_LichSuNhapBan (IDSach, IDLichSu, TonTruoc, SoLuong, Gia) VALUES
			(@IDSachCursor, @IDLichSu, @TonTruoc, @SoLuongCursor, @GiaCursor)
			
			FETCH NEXT FROM array_cursor
			INTO @IDSachCursor, @SoLuongCursor, @GiaCursor
		END
		
	CLOSE array_cursor
	DEALLOCATE array_cursor
	
	COMMIT TRANSACTION NHAP_LICHSU	
	
	RETURN @IDLichSu
END
GO


CREATE OR ALTER PROCEDURE ThemHoaDon
	@SoTienTra DECIMAL(19, 4),
	@IDKhachHang INT,
	@IDNvThanhToan INT,
	@IDSach VARCHAR(MAX), -- '#id1, #id2, ...'
	@SoLuong VARCHAR(MAX) -- '#sl1, #sl2, ...'
AS BEGIN	
	-- Insert LichSu
	DECLARE @TiLeGia FLOAT = dbo.GetRangBuoc('GiaBanTrenGiaNhap'),
			@GIAs VARCHAR(MAX)
	DECLARE @ListGia TABLE(id INT IDENTITY, value DECIMAL(19, 4))
	DECLARE @ListSL TABLE(id INT IDENTITY, value INT)
	
	INSERT INTO @ListGia (value)
	SELECT s.GiaNhap * @TiLeGia
	FROM Sach s
	INNER JOIN STRING_SPLIT(@IDSach, ',') ids ON ids.value = s.ID
	
	SELECT @GIAs = STRING_AGG(g.value, ',')
	FROM @ListGia g
	
	
	INSERT INTO @ListSL (value)
	SELECT CASE WHEN sl.value < 0 THEN -1*sl.value ELSE sl.value END
	FROM STRING_SPLIT(@SoLuong, ',') sl
	
	SELECT @SoLuong = STRING_AGG(-1*sl.value, ',')
	FROM @ListSL sl
	
	DECLARE @IDLichSu INT
	EXEC @IDLichSu = ThemLichSuNhapBan
		@IDSach=@IDSach,
		@SoLuong=@SoLuong,
		@Gia=@GIAs 
	
	INSERT INTO HoaDon (SoTienTra, IDLichSu, IDNhanVienThanhToan, IDKhachHang) VALUES
	(@SoTienTra, @IDLichSu, @IDNvThanhToan, @IDKhachHang)
	
	DECLARE @ThanhTien DECIMAL(19, 4)
	SELECT @ThanhTien = SUM(g.value * sl.value)
	FROM @ListGia g
	INNER JOIN @ListSL sl ON sl.id = g.id
	
	RETURN @ThanhTien
END
GO


CREATE OR ALTER PROCEDURE ThemLichSuTinhNo
	@IDKhachHang INT,
	@SoTien DECIMAL(19, 4)
AS BEGIN 
	DECLARE @TongNoTruoc DECIMAL(19, 4) = 0
	DECLARE @History TABLE(ID INT, IDKhachHang INT, ThoiDiem DATETIME, TongNoTruoc DECIMAL(19, 4), SoTien DECIMAL(19, 4))
	
	INSERT INTO @History
	SELECT * FROM LichSuTinhNo lstn
	WHERE lstn.IDKhachHang = @IDKhachHang
	
	IF EXISTS(SELECT * FROM @History) 
	BEGIN 
		SELECT @TongNoTruoc = hst.TongNoTruoc + hst.SoTien
		FROM @History hst
		WHERE hst.ThoiDiem >= ALL(SELECT ThoiDiem FROM @History)
	END	
	
	BEGIN TRANSACTION NHAP_LICHSU
	
	INSERT INTO LichSuTinhNo (IDKhachHang, ThoiDiem, TongNoTruoc, SoTien) VALUES
	(@IDKhachHang, GETDATE(), @TongNoTruoc, @SoTien)
	
	COMMIT TRANSACTION NHAP_LICHSU
	
	RETURN IDENT_CURRENT('LichSuTinhNo')
END
GO