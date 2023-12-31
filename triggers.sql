CREATE OR ALTER TRIGGER KiemTraSoLuongNhap
ON Sach_LichSuNhapBan
AFTER INSERT
AS BEGIN
	DECLARE @MinSL INT = dbo.GetRangBuoc('MinSoLuongNhap'),
			@SoLuong INT,
			@IDSach INT
			
	SELECT @SoLuong = inserted.SoLuong, @IDSach = inserted.IDSach
	FROM inserted
	
	IF (
		@SoLuong < @MinSL AND
		@SoLuong > 0
	)
	BEGIN
		DECLARE @ERR_MSG NVARCHAR(MAX) = FORMATMESSAGE(N'Số lượng nhập phải ít nhất là %d với sách có ID %d', @MinSL, @IDSach); 
		RAISERROR(@ERR_MSG, 16, 2)
		ROLLBACK TRANSACTION FEATURE
	END
END
GO


CREATE OR ALTER TRIGGER KiemTraTonTruocNhap
ON Sach_LichSuNhapBan
AFTER INSERT
AS BEGIN
	DECLARE @MaxTon INT = dbo.GetRangBuoc('MaxTonTruocNhap'),
			@SoLuong INT,
			@TonTruoc INT,
			@IDSach INT
	
	SELECT @TonTruoc = inserted.TonTruoc, @SoLuong = inserted.SoLuong, @IDSach = inserted.IDSach
	FROM inserted
	
	IF (
		@TonTruoc >= 300 AND 
		@SoLuong > 0
	) BEGIN 
		DECLARE @ERR_MSG NVARCHAR(MAX) = FORMATMESSAGE(N'Số lượng tồn trước khi nhập phải bé hơn %d với sách có ID %d', @MaxTon, @IDSach); 
		RAISERROR(@ERR_MSG, 16, 1)
		ROLLBACK TRANSACTION FEATURE 
	END	
END
GO


CREATE OR ALTER TRIGGER KiemTraTonSauBan
ON Sach_LichSuNhapBan
AFTER INSERT
AS BEGIN
	DECLARE @MinTon INT = dbo.GetRangBuoc('MinTonSauBan'),
			@SoLuong INT,
			@TonSau INT,
			@IDSach INT
	
	SELECT @SoLuong = inserted.SoLuong, @TonSau = inserted.SoLuong + inserted.TonTruoc, @IDSach = inserted.IDSach
	FROM inserted
	
	IF (
		@TonSau < @MinTon AND
		@SoLuong < 0
	) BEGIN 
		DECLARE @ERR_MSG NVARCHAR(MAX) = FORMATMESSAGE(N'Lượng tồn sau khi bán phải lớn hơn hoặc bằng %d với sách có ID %d', @MinTon, @IDSach); 
		RAISERROR(@ERR_MSG, 16, 1)
		ROLLBACK TRANSACTION FEATURE
	END	
END
GO
 

CREATE OR ALTER TRIGGER KiemTraMaxNo
ON LichSuTinhNo
AFTER INSERT
AS BEGIN
	DECLARE @MaxNo DECIMAL(19, 4) = dbo.GetRangBuoc('MaxTienNo'),
			@NoSau DECIMAL(19, 4),
			@IDKh INT
			
	SELECT @NoSau = inserted.TongNoTruoc + inserted.SoTien, @IDKh = inserted.IDKhachHang
	FROM inserted
	
	IF @NoSau > @MaxNo
	BEGIN
		DECLARE @MaxNo1 VARCHAR(MAX) = CAST(@MaxNo AS DECIMAL(19))
		DECLARE @ERR_MSG NVARCHAR(MAX) = FORMATMESSAGE(N'Số tiền nợ của khách hàng với ID %d không được quá %sđ', @IDKh, @MaxNo1);
		RAISERROR(@ERR_MSG, 16, 1)
		ROLLBACK TRANSACTION FEATURE
	END	
END
GO


CREATE OR ALTER TRIGGER KiemTraThuQuaNo
ON LichSuTinhNo
AFTER INSERT
AS BEGIN
	DECLARE @ChoPhep BIT = dbo.GetRangBuoc('ThuQuaTienNo'),
			@IDKh INT,
			@TongNoTruoc VARCHAR(MAX),
			@TongNoSau DECIMAL(19, 4)
	
	SELECT @IDKh = inserted.IDKhachHang, @TongNoTruoc = CAST(inserted.TongNoTruoc AS DECIMAL(19, 0)), @TongNoSau = inserted.TongNoTruoc + inserted.SoTien
	FROM inserted
	
	IF @ChoPhep = 0 AND	@TongNoSau < 0
	BEGIN 
		DECLARE @ERR_MSG NVARCHAR(MAX) = FORMATMESSAGE(N'Không thể thu quá tiền nợ (%sđ) của khách hàng với ID %d', @TongNoTruoc, @IDKh);
		RAISERROR(@ERR_MSG, 16, 1)
		ROLLBACK TRANSACTION FEATURE
	END	
END
GO
