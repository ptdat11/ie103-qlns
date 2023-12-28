CREATE OR ALTER PROCEDURE NhapSach
	@IDSach VARCHAR(MAX), -- '#id1, #id2, ...'
	@SoLuong VARCHAR(MAX), -- '#sl1, #sl2, ...'
	@Gia VARCHAR(MAX) -- '#gia1, #gia2, ...'
AS BEGIN
	
	DECLARE @IDs TABLE(id INT IDENTITY, value INT)
	DECLARE @GIAs TABLE(id INT IDENTITY, value DECIMAL(19, 4))
	DECLARE @GIAs_by_IDs TABLE(id INT, gia DECIMAL(19, 4))
	
	INSERT INTO @IDs (value)
	SELECT value FROM STRING_SPLIT(@IDSach, ',')
	INSERT INTO @GIAs (value)
	SELECT value FROM STRING_SPLIT(@Gia, ',')
	
	INSERT INTO @GIAs_by_IDs (id, gia)
	SELECT ids.value, CASE 
		WHEN gs.value = -1 THEN s.GiaNhap
		ELSE gs.value
	END
	FROM @IDs ids
	INNER JOIN @GIAs gs ON ids.id = gs.id
	INNER JOIN Sach s ON s.ID = ids.value
	
	SELECT @Gia = STRING_AGG(gs.gia, ',') FROM @GIAs_by_IDs gs
	
	BEGIN TRANSACTION FEATURE
	
	SAVE TRANSACTION NHAP_SACH
	
	UPDATE Sach
	SET GiaNhap = gs.gia
	FROM @GIAs_by_IDs gs
	WHERE gs.id = Sach.ID 
	
	EXEC ThemLichSuNhapBanSach
		@IDSach=@IDSach, 
		@SoLuong=@SoLuong, 
		@Gia=@Gia 
	
	COMMIT TRANSACTION FEATURE
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
	WITH temp AS (
		SELECT 
			s.ID, s.TenSach, s.GiaNhap, s.SoTrang, 
			nxb.ID AS IDNXB, nxb.TenNXB, 
--			tl.ID AS IDTL, tl.TenTheLoai,
	--		STRING_AGG(tl.TenTheLoai, ', ') AS TheLoai, 
			slsnb.TonTruoc + slsnb.SoLuong AS Ton, 
			lsnbs.ThoiDiem
		FROM Sach s 
		INNER JOIN NhaXuatBan nxb ON nxb.ID = s.IDNhaXuatBan
--		INNER JOIN TheLoai_Sach tls ON tls.IDSach = s.ID
--		INNER JOIN TheLoai tl ON tl.ID = tls.IDTheLoai
		LEFT JOIN Sach_LichSuNhapBan slsnb ON s.ID = slsnb.IDSach
		INNER JOIN LichSuNhapBanSach lsnbs ON lsnbs.ID = slsnb.IDLichSu 
	), temp1 AS (
		SELECT *
		FROM temp t1
		WHERE t1.ThoiDiem = (
			SELECT MAX(t2.ThoiDiem)
			FROM temp t2
			WHERE t2.ID = t1.ID
		)	
	)
	SELECT t.ID, t.TenSach, t.GiaNhap, t.SoTrang, t.TenNXB, t.Ton
	FROM temp1 t
	WHERE 
		(dbo.Levenshtein(@Keyword, t.TenSach, 10) < 4 OR 
		CHARINDEX(@Keyword, t.TenSach) > 0 OR 
		@Keyword IS NULL)
		AND
		(@gteGia <= t.GiaNhap AND t.GiaNhap < @ltGia)
		AND
		(@gteTon <= t.Ton AND t.Ton < @ltTon)
		AND
		(t.IDNXB IN (SELECT value FROM STRING_SPLIT(@IDNxb, ',')) OR @IDNxb IS NULL)
	

DECLARE @Keyword NVARCHAR(4000) = NULL,
		@gteGia DECIMAL(19, 4) = 0,
		@ltGia DECIMAL(19, 4) = 999999999999999.9999,
		@gteTon INT = 0,
		@ltTon INT = 2147483647,
		@IDNxb VARCHAR(MAX) = NULL -- '#id1, #id2, ...'
SELECT * FROM dbo.LietKeSach(@Keyword, @gteGia, @ltGia, @gteTon, @ltTon, @IDNxb)
