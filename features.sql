CREATE OR ALTER PROCEDURE NhapSach
	@IDSach VARCHAR(MAX), -- '#id1, #id2, ...'
	@SoLuong VARCHAR(MAX), -- '#sl1, #sl2, ...'
	@Gia VARCHAR(MAX) -- '#gia1, #gia2, ...'
AS BEGIN
	
	DECLARE @IDs TABLE(id INT IDENTITY, value INT)
	DECLARE @SLs TABLE(id INT IDENTITY, value INT)
	DECLARE @GIAs TABLE(id INT IDENTITY, value DECIMAL(19, 4))
	DECLARE @TblTongQuat TABLE(id INT, sl INT, gia DECIMAL(19, 4))
	
	INSERT INTO @IDs (value)
	SELECT value FROM STRING_SPLIT(@IDSach, ',')
	INSERT INTO @SLs (value)
	SELECT value FROM STRING_SPLIT(@SoLuong, ',')
	INSERT INTO @GIAs (value)
	SELECT value FROM STRING_SPLIT(@Gia, ',')
	
	INSERT INTO @TblTongQuat (id, sl, gia)
	SELECT ids.value, sls.value, CASE 
		WHEN gs.value = -1 THEN s.GiaNhap
		ELSE gs.value
	END
	FROM @IDs ids
	INNER JOIN @SLs sls ON ids.id = sls.id
	INNER JOIN @GIAs gs ON ids.id = gs.id
	INNER JOIN Sach s ON s.ID = ids.value
	
	SELECT @Gia = STRING_AGG(gs.gia, ',') FROM @TblTongQuat gs
	
	BEGIN TRANSACTION FEATURE
	
	SAVE TRANSACTION NHAP_SACH
	
	UPDATE Sach
	SET GiaNhap = gs.gia
	FROM @TblTongQuat gs
	WHERE gs.id = Sach.ID 
	
	EXEC ThemLichSuNhapBanSach
		@IDSach=@IDSach, 
		@SoLuong=@SoLuong, 
		@Gia=@Gia 
	
	COMMIT TRANSACTION FEATURE
	
	DECLARE @TongTien DECIMAL(19, 4)
	SELECT @TongTien = SUM(tq.sl * tq.gia)
	FROM @TblTongQuat tq
	
	RETURN @TongTien
END
GO


CREATE OR ALTER PROCEDURE BanSach
	@IDKhachHang INT,
	@IDNvThanhToan INT,
	@IDSach VARCHAR(MAX), -- '#id1, #id2, ...'
	@SoLuong VARCHAR(MAX), -- '#sl1, #sl2, ...'
	@SoTienTra DECIMAL(19, 4)
AS BEGIN 
	BEGIN TRANSACTION FEATURE
	
	SAVE TRANSACTION BAN_SACH
	
		DECLARE @ThanhTien DECIMAL(19, 4)
		
		EXEC @ThanhTien = ThemHoaDon
			@SoTienTra=@SoTienTra, 
			@IDKhachHang=@IDKhachHang, 
			@IDNvThanhToan=@IDNvThanhToan,
			@IDSach=@IDSach, 
			@SoLuong=@SoLuong
		
		DECLARE @Diff DECIMAL(19, 4) = @ThanhTien - @SoTienTra
		IF @Diff <> 0
		BEGIN
			EXEC ThemLichSuTinhNo 
				@IDKhachHang=@IDKhachHang,
				@SoTien=@Diff
		END
	COMMIT TRANSACTION FEATURE
	
	RETURN @ThanhTien
END
GO


CREATE OR ALTER FUNCTION LietKeSach(
	@Keyword NVARCHAR(4000) = NULL,
	@gteGia DECIMAL(19, 4) = 0,
	@ltGia DECIMAL(19, 4) = 999999999999999.9999,
	@gteTon INT = 0,
	@ltTon INT = 2147483647,
	@IDNxb VARCHAR(MAX) = NULL -- '#id1, #id2, ...'
) RETURNS TABLE
AS
RETURN 
	SELECT lsgn.ID, lsgn.TenSach, lsgn.GiaNhap, lsgn.SoTrang, nxb.TenNXB, ISNULL(lsgn.TonTruoc + lsgn.SoLuong, 0) AS Ton
	FROM LichSuNhapBanGanNhat lsgn
	LEFT JOIN NhaXuatBan nxb ON nxb.ID = lsgn.IDNhaXuatBan
	WHERE 
		(dbo.Levenshtein(@Keyword, lsgn.TenSach, 10) < 4 OR 
		CHARINDEX(@Keyword, lsgn.TenSach) > 0 OR 
		@Keyword IS NULL)
		AND
		(@gteGia <= lsgn.GiaNhap AND lsgn.GiaNhap < @ltGia)
		AND
		(@gteTon <= lsgn.TonTruoc + lsgn.SoLuong AND lsgn.TonTruoc + lsgn.SoLuong < @ltTon OR lsgn.TonTruoc + lsgn.SoLuong IS NULL)
		AND
		(lsgn.IDNhaXuatBan IN (SELECT value FROM STRING_SPLIT(@IDNxb, ',')) OR @IDNxb IS NULL)
GO


CREATE OR ALTER FUNCTION BaoCaoTon(
	@From DATETIME = '1753-01-01 00:00:00.000',
	@To DATETIME = '9999-12-31 23:59:59.997'
) RETURNS TABLE
AS 
RETURN
	WITH temp AS (
		SELECT *
		FROM LichSuNhapBan ls
		WHERE ls.ThoiDiem BETWEEN @From AND @To OR ls.ThoiDiem IS NULL
	)
	SELECT t1.ID, t1.TenSach, t2.TonTruoc, t1.TonSau
	FROM (
		SELECT lsgn.ID, lsgn.TenSach, ISNULL(lsgn.TonTruoc + lsgn.SoLuong, 0) AS TonSau
		FROM temp lsgn
		WHERE lsgn.ThoiDiem = (
			SELECT MAX(ls1.ThoiDiem) 
			FROM LichSuNhapBan ls1
			WHERE lsgn.ID = ls1.ID
		) OR lsgn.ThoiDiem IS NULL
	) t1
	INNER JOIN (
		SELECT ls.ID, ISNULL(ls.TonTruoc, 0) AS TonTruoc
		FROM temp ls
		WHERE ls.ThoiDiem = (
			SELECT MIN(ls2.ThoiDiem) 
			FROM LichSuNhapBan ls2
			WHERE ls.ID = ls2.ID
		) OR ls.ThoiDiem IS NULL
	) t2 ON t1.ID = t2.ID


CREATE OR ALTER FUNCTION BaoCaoNo (
	@From DATETIME = '1753-01-01 00:00:00.000',
	@To DATETIME = '9999-12-31 23:59:59.997'
) RETURNS TABLE
AS 
RETURN
	WITH temp AS (
		SELECT *
		FROM LichSuNo ls
		WHERE ls.ThoiDiem BETWEEN @From AND @To OR ls.ThoiDiem IS NULL
	)
	SELECT truoc.*, sau.TongNoSau
	FROM (
		SELECT t1.ID, t1.HoTen, ISNULL(t1.TongNoTruoc, 0) AS TongNoTruoc
		FROM temp t1
		WHERE t1.ThoiDiem = (
			SELECT MIN(t0.ThoiDiem)
			FROM temp t0
			WHERE t0.ID = t1.ID
		) OR t1.ThoiDiem IS NULL
	) truoc
	INNER JOIN (
		SELECT t2.ID, ISNULL(t2.TongNoTruoc + t2.SoTien, 0) AS TongNoSau
		FROM temp t2
		WHERE t2.ThoiDiem = (
			SELECT MAX(t0.ThoiDiem)
			FROM temp t0
			WHERE t0.ID = t2.ID
		) OR t2.ThoiDiem IS NULL
	) sau ON truoc.ID = sau.ID
	
SELECT * FROM dbo.BaoCaoNo(DEFAULT, DEFAULT)
