CREATE OR ALTER VIEW LichSuNhapBan
AS
WITH temp AS (
	SELECT s.ID, s.TenSach, s.GiaNhap, s.SoTrang, s.IDNhaXuatBan, lsnbs.ID AS IDLichSu, slsnb.TonTruoc, slsnb.SoLuong, lsnbs.ThoiDiem
	FROM Sach s 
	LEFT JOIN Sach_LichSuNhapBan slsnb ON s.ID = slsnb.IDSach
	LEFT JOIN LichSuNhapBanSach lsnbs ON slsnb.IDLichSu = lsnbs.ID
)
SELECT *
FROM temp t


CREATE OR ALTER VIEW LichSuNhapBanGanNhat
AS 
SELECT *
FROM LichSuNhapBan ls
WHERE ls.ThoiDiem = (
	SELECT MAX(ls1.ThoiDiem)
	FROM LichSuNhapBan ls1
	WHERE ls1.ID = ls.ID
) OR ls.ThoiDiem IS NULL


CREATE OR ALTER VIEW LichSuNo
AS
	SELECT kh.ID, kh.HoTen, ISNULL(lstn.TongNoTruoc, 0) AS TongNoTruoc, ISNULL(lstn.SoTien, 0) AS SoTien, ISNULL(lstn.ThoiDiem, 0) AS ThoiDiem
	FROM KhachHang kh 
	LEFT JOIN LichSuTinhNo lstn ON kh.ID = lstn.IDKhachHang