CREATE LOGIN ChuNSLogin
WITH PASSWORD = 'yourStrong(!)Password';

CREATE LOGIN QuanLyLogin
WITH PASSWORD = 'yourStrong(!)Password';

CREATE LOGIN NhanVienLogin
WITH PASSWORD = 'yourStrong(!)Password';

CREATE ROLE ChuNS
CREATE ROLE QuanLy 
CREATE ROLE NhanVien

CREATE USER Dat FOR LOGIN NhanVienLogin
ALTER ROLE NhanVien ADD MEMBER Dat


-- NhanVien
GRANT SELECT ON dbo.NhanSu TO NhanVien
GRANT SELECT ON dbo.ChucVu TO NhanVien
GRANT SELECT ON dbo.CaiDatRangBuoc TO NhanVien
GRANT SELECT, INSERT, UPDATE ON dbo.Sach TO NhanVien
GRANT SELECT, INSERT, UPDATE ON dbo.NhaXuatBan TO NhanVien
GRANT SELECT, INSERT, UPDATE ON dbo.TheLoai TO NhanVien
GRANT SELECT, INSERT, UPDATE ON dbo.TacGia TO NhanVien
GRANT SELECT, INSERT, UPDATE ON dbo.KhachHang TO NhanVien
GRANT SELECT, INSERT ON dbo.LichSuTinhNo TO NhanVien
GRANT SELECT, INSERT ON dbo.HoaDon TO NhanVien
GRANT SELECT, INSERT ON dbo.LichSuNhapBan TO NhanVien
GRANT SELECT, INSERT ON dbo.Sach_LichSuNhapBan TO NhanVien

DENY DELETE ON dbo.Sach TO NhanVien
DENY DELETE ON dbo.NhaXuatBan TO NhanVien
DENY DELETE ON dbo.TheLoai TO NhanVien
DENY DELETE ON dbo.TacGia TO NhanVien
DENY DELETE ON dbo.NhanSu TO NhanVien
DENY DELETE ON dbo.ChucVu TO NhanVien
DENY DELETE, UPDATE ON dbo.KhachHang TO NhanVien
DENY DELETE, UPDATE ON dbo.LichSuTinhNo TO NhanVien
DENY DELETE, UPDATE ON dbo.HoaDon TO NhanVien
DENY DELETE, UPDATE ON dbo.LichSuNhapBan TO NhanVien
DENY DELETE, UPDATE ON dbo.Sach_LichSuNhapBan TO NhanVien
DENY DELETE, INSERT, UPDATE ON dbo.CaiDatRangBuoc TO NhanVien


-- QuanLy
GRANT SELECT ON dbo.ChucVu TO QuanLy
GRANT SELECT, INSERT ON dbo.HoaDon TO QuanLy
GRANT SELECT, INSERT ON dbo.LichSuTinhNo TO QuanLy
GRANT SELECT, INSERT ON dbo.LichSuNhapBan TO QuanLy
GRANT SELECT, INSERT ON dbo.Sach_LichSuNhapBan TO QuanLy
GRANT SELECT, INSERT, UPDATE ON dbo.NhanSu TO QuanLy
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Sach TO QuanLy
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.NhaXuatBan TO QuanLy
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.TheLoai TO QuanLy
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.TacGia TO QuanLy
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.CaiDatRangBuoc TO QuanLy

DENY DELETE ON dbo.NhanSu TO QuanLy
DENY DELETE ON dbo.ChucVu TO QuanLy
DENY DELETE, UPDATE ON dbo.LichSuTinhNo TO QuanLy
DENY DELETE, UPDATE ON dbo.HoaDon TO QuanLy
DENY DELETE, UPDATE ON dbo.LichSuNhapBan TO QuanLy
DENY DELETE, UPDATE ON dbo.Sach_LichSuNhapBan TO QuanLy


-- ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.Sach TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.NhaXuatBan TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.TheLoai TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.TacGia TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.NhanSu TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.ChucVu TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.ChiTietHoaDon TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.LichSuTinhNo TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.HoaDon TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.LichSuNhapBan TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.Sach_LichSuNhapBan TO ChuNS
GRANT SELECT, INSERT, DELETE, UPDATE ON dbo.Sach_CaiDatRangBuoc TO ChuNS
