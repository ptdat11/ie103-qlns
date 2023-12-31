------ NHAP SACH ------
DECLARE @TongTien DECIMAL(19, 4)
--
EXEC @TongTien = NhapSach
	@IDSach='6, 12, 18', 
	@SoLuong='150, 160, 200', 
	@Gia='100000, -1, 200000'
--
PRINT(@TongTien)
SELECT * FROM Sach_LichSuNhapBan slsnb WHERE slsnb.IDLichSu = IDENT_CURRENT('LichSuNhapBanSach')


------ BAN SACH ------
DECLARE @ThanhTien DECIMAL(19, 4)
--
EXEC @ThanhTien = BanSach
	@IDKhachHang=1, 
	@IDNvThanhToan=3, 
	@IDSach='6, 12, 18', 
	@SoLuong='1, 2, 1', 
	@SoTienTra=200000
--
PRINT(@ThanhTien)
SELECT * FROM Sach_LichSuNhapBan slsnb WHERE slsnb.IDLichSu = IDENT_CURRENT('LichSuNhapBanSach')
SELECT * FROM HoaDon hd WHERE hd.ID = IDENT_CURRENT('HoaDon')
SELECT * FROM LichSuTinhNo lstn WHERE lstn.ID = IDENT_CURRENT('LichSuTinhNo')

DELETE Sach
WHERE ID = 100

------ LIET KE SACH ------
DECLARE @Keyword NVARCHAR(4000) = NULL,
		@gteGia DECIMAL(19, 4) = 0,
		@ltGia DECIMAL(19, 4) = 999999999999999.9999,
		@gteTon INT = 0,
		@ltTon INT = 2147483647,
		@IDNxb VARCHAR(MAX) = NULL -- '#id1, #id2, ...'
--
SELECT * FROM dbo.LietKeSach(@Keyword, @gteGia, @ltGia, @gteTon, @ltTon, @IDNxb)
--


------ BAO CAO TON KHO ------
DECLARE @From DATETIME = '1753-01-01 00:00:00.000',
		@To DATETIME = '9999-12-31 23:59:59.997'
--
SELECT * FROM dbo.BaoCaoTon(@From, @To)
--


------ BAO CAO TIEN NO ------
DECLARE @From DATETIME = '1753-01-01 00:00:00.000',
		@To DATETIME = '9999-12-31 23:59:59.997'
--
SELECT * FROM dbo.BaoCaoNo(@From, @To)


SELECT *
FROM sysusers
WHERE issqluser = 1
--