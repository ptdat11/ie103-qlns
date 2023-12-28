--CREATE DATABASE QLNS
--ALTER DATABASE QLNS SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--DROP DATABASE QLNS
USE QLNS;

EXEC uspDropAllTables
EXEC uspCreateTables
EXEC uspApplyConstraints 

-- Sample records
INSERT INTO CaiDatRangBuoc (MinSoLuongNhap, MaxTonTruocNhap, MinTonSauBan, GiaBanTrenGiaNhap, MaxTienNo, ThuQuaTienNo) VALUES
(150, 300, 20, 1.05, 1000000, 0)

INSERT INTO NhaXuatBan (TenNXB, SDT, Email) VALUES
(N'Thế Giới', NULL, 'helloworld@gmail.com'),
(N'Hội Nhà Văn', NULL, 'vanvn2021@gmail.com'),
(N'Hà Nội', '02438252916', 'vanthu_nxbhn@hanoi.gov.vn'),
(N'Phụ Nữ', '02439710717', 'truyenthongvaprnxbpn@gmail.com'),
(N'Dân Trí', '02466860751', 'nxbdantri@gmail.com'),
(N'Lao Động', NULL, 'info@nxblaodong.com.vn'),
(N'Thông Tấn', '02439330202', 'tinhoc@ttxvn.vn'),
(N'Tri Thức', '0838323839', 'lienhe@nxbtrithuc.com.vn'),
(N'Khai Minh', '0971998312', 'khaiminhbook@gmail.com'),
(N'Hồng Đức', '0439260024', NULL),
(N'Văn Học', '02437161518', 'info@nxbvanhoc.com.vn')


INSERT INTO TacGia (HoTen, Email) VALUES
(N'Trương Vĩnh Ký', NULL),
(N'Yuval Noah Harari', 'yuvalharari@gmail.com'),
(N'Erin Hunter', NULL),
(N'Phan Cuồng', NULL),
(N'Nguyễn Tuân', NULL),
(N'Phan Việt', NULL),
(N'Nguyễn Ngọc Tiến', NULL),
(N'Tâm Bùi', NULL),
(N'Đinh Vũ Hoàng Nguyên', NULL),
(N'Phạm Gia Hiền', NULL),
(N'Thạch Lam', NULL),
(N'Hoàng Nhật', NULL),
(N'Trần Vũ', NULL),
(N'Đinh Hằng', NULL),
(N'Trần Thị Cúc Phương', NULL),
(N'Hiểu Tuyết', NULL),
(N'Zihua Nguyễn', NULL),
(N'Rob Eastaway', NULL),
(N'Park Jae Yeon', NULL),
(N'Trần Vàng Sao', NULL)


INSERT INTO Sach (TenSach, SoTrang, GiaNhap, IDNhaXuatBan) VALUES
(N'Bài Giảng Lịch Sử An Nam', 424, 190000, 1),
(N'Homo Deus lược sử tương lai',NULL, 225000, 1),
(N'Người Đài Bắc', 313, 179000, 3),
(N'Tật xấu người Việt', 384, 149000, 2),
(N'Những lối đi dưới hàng cây tăm tối', 292, 85000, 11),
(N'Nam Hoa Kinh', 334, 109000, 11),
(N'Hội hè miên man', 318, 115000, 11),
(N'Đồi thỏ', 494, 169000, 2),
(N'Trở lại Babylon tuyển tập truyện ngắn Anh - Mỹ', 473, 150000, 11),
(N'Biên niên ký Sao Hỏa', 402, 16500, 11),
(N'Con Trai (phần thứ tư của Người truyền ký ức)', 425, 15800, 2),
(N'Tiếng kèn thiên nga', 241, 8000, 2),
(N'Lời của Nietzsche cho người trẻ - Tập 2', 276, 10800, 1),
(N'Infinite Dendrogram 5 - Những người kết nối các khả năng', 248, 11500, 3),
(N'Dám bị ghét', 333, 11900, 5),
(N'Bác sĩ Jekyll và ông Hyde', 160, 6200, 2),
(N'Romeo và Juliet', 160, 5800, 2),
(N'Phương trình mầu nhiệm', 371, 16900, 7),
(N'Nỗi niềm của thám tử Galileo', 336, 14600, 3),
(N'Chuyện tình hài lãng mạn không thể chê vào đâu 2', 216, 11800, 3),
(N'Giấc mơ tiên tri', 245, 11800, 3),
(N'Cuộc đời và số phận', 826, 46000, 2),
(N'Jane Eyre', 540, 17900, 11),
(N'Lắng nghe gió hát', 192, 8800, 2),
(N'Nàng Thợ may Tinh linh (Hariko no Otome)', 304, 13800, 3),
(N'Vượn trần trụi', 400, 13800, 2),
(N'Faust - Johann WolfGang Von Goethe', 604, 20000, 11),
(N'Lá thư hè', 167, 5200, 11),
(N'Người đao phủ thành Đại La', 338, 13800, 2),
(N'Chuyện một cậu bé', 434, 16800, 2),
(N'Thời gian của ma', 309, 14800, 3),
(N'Thư gửi nhà tiểu thuyết trẻ', 161, 10900, 2),
(N'Dã ngoại nơi Mặt sau của Thế giới (Otherside Picnic) 3', 327, 15000, 3),
(N'Sáu người đi khắp thế gian - Tập 2', 565, 16500, 11),
(N'Quái vật trong quán đồ nướng', 393, 15800, 3),
(N'Chàng trai chuyển kiếp và cô gái thiên tài 1', 261, 13500, 4),
(N'Ba gã cùng thuyền', 262, 8800, 11),
(N'Lời của Nietzsche cho người trẻ - Tập 1', 280, 10800, 1),
(N'Bóng ma trong nhà hát', 360, 12000, 11),
(N'Lược sử khoa học', 364, 15900, 1),
(N'Diệt chủng', 585, 27900, 2),
(N'Vật chứa linh hồn', 420, 20000, 4),
(N'Lời nhắn cuối cùng', 400, 16000, 3),
(N'Cha và Con (Ivan Turgenev)', 405, 12000, 11),
(N'Điềm lành - Những lời tiên tri tuyệt đích và chuẩn xác của phù thủy Agnes Nutter', 448, 22000, 4),
(N'Bọ tuyết', 336, 13500, 4),
(N'Em sẽ đến cùng cơn mưa', 332, 10800, 11),
(N'Vùng đất quỷ tha ma bắt', 413, 16800, 4),
(N'Thú tội', 245, 9900, 2),
(N'Thị trấn bị nguyền rủa - HEX', 446, 22200, 4),
(N'Thiên nga và dơi', 641, 26900, 3),
(N'Ca trực - Silo Tháp Giống #2', 643, 27200, 2),
(N'Hội nghị của bầy chim - Tập V của Trại trẻ đặc biệt của cô Peregrine', 420, 16500, 2),
(N'Hãy về với cha', 466, 17900, 3),
(N'Người truyền tin (phần thứ ba của Người truyền ký ức)', 189, 10000, 2),
(N'Truyện ma (M.R.James)', 457, 14900, 2),
(N'Ngụy chứng của Solomon - Tập 2 Quyết định', 611, 30000, 5),
(N'Momo (Michael Ende)', 278, 9000, 2),
(N'Hãy đi đặt người canh gác', 304, 12500, 11),
(N'Chiếc hộp Pandora', 521, 24900, 11),
(N'Một thoáng ta rực rỡ ở nhân gian ( Bìa cứng)', 306, 19500, 2),
(N'Và rồi núi vọng', 512, 14800, 2),
(N'Tội ác và hình phạt', 600, 30000, 3),
(N'Tàn lửa', 484, 18500, 3),
(N'Anne tóc đỏ làng Avonlea', 404, 11200, 2),
(N'Trúc thư dao 1 - Nước Tần - Có nàng tên Thập', 528, 17900, 3),
(N'Dịch bệnh Atlantis', 496, 19500, 2),
(N'Tâm hồn cao thượng', 432, 15000, 4),
(N'Tâm hồn cao thượng (Bìa cứng)', 434, 22000, 4),
(N'9 màu chia ly', 256, 12000, 2),
(N'Bàn về âm nhạc - Trò chuyện cùng Seiji Ozawa', 400, 16800, 5),
(N'Cô gái mặc váy tím', 160, 9500, 3),
(N'Mã mẫu tử', 381, 18000, 1),
(N'AI THẢ CÁC THẦN RA?', 412, 17900, 2),
(N'Sáng trăng', 188, 7500, 4),
(N'Không ai sống giống ai trong cuộc đời này', 316, 14500, 2),
(N'Ăn dặm không nước mắt (TB 2023)', 176, 120000, 1),
(N'Sổ tay ăn dặm của mẹ', 267, 99000, 1),
(N'Chó và mèo dưới lăng kính khoa học', 62, 125000, 1),
(N'Từ điển chức quan Việt Nam', 678, 250000, 7),
(N'Địa chính trị của loài muỗi - Khái lược về toàn cầu hóa', 328, 108000, 3),
(N'Nghệ thuật sống hạnh phúc gặt thành công', 396, 129000, 1),
(N'Nhân vật nổi tiếng thế giới– Các lãnh tụ lẫy lừng', 126, 149000, 3),
(N'Công thức hạnh phúc', 164, 88000, 1),
(N'Sống khỏe không rủi ro', 348, 118000, 5),
(N'Lịch lãm như một quý ông', 128, 108000, 1),
(N'Nhân vật nổi tiếng thế giới – Văn hóa và nghệ thuật', 126, 149000, 3),
(N'Nhân vật nổi tiếng thế giới – Khoa học và phát minh', 126, 149000, 3),
(N'Sổ tay mẹ bầu ( TB 2019)', 260, 82000, 6),
(N'Ba bài pháp thoại', 121, 69000, 2),
(N'Lịch sử chính trị cho thanh thiếu niên', 127, 118000, 6),
(N'Buông tay để con bay - Giải pháp để con tự lập & mẹ tự do', 250, 100000, 1),
(N'Dịch từ tiếng yêu sang tiếng việt ( TB 2019)', 211, 85000, 2),
(N'Thủ thỉ kiến thức lớp 3', 195, 85000, 1),
(N'Nhật ký học làm bánh (tập 1)', 220, 105000, 1),
(N'Tín ngưỡng thờ Mẫu Tứ phủ - Chốn thiêng nơi cõi thực (TB 2019)', 151, 138000, 1),
(N'Thủ thỉ kiến thức lớp 4', 199, 88000, 1),
(N'Sức mạnh của người mẹ Nhật', 276, 95000, 1),
(N'Tarot nhập môn', 455, 120000, 3),
(N'How Food Works - Hiểu hết về thức ăn', 255, 300000, 1),
(N'Cool Series - Toán học siêu hay', 112, 85000, 1)


--INSERT INTO TacGia_Sach (IDTacGia, IDSach) VALUES
--(1, 1),
--(2, 2)

INSERT INTO TheLoai (TenTheLoai) VALUES
(N'Văn học Việt Nam'),
(N'Văn học nước ngoài'),
(N'Sách tham khảo'),
(N'Sách thiếu nhi')

INSERT INTO TheLoai_Sach (IDSach, IDTheLoai) VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 1),
(3, 3),
(3, 4)

INSERT INTO ChucVu (TenChucVu) VALUES
(N'CEO'),
(N'CTO'),
(N'CFO'),
(N'Thu ngân'),
(N'Bảo vệ')


INSERT INTO NhanSu (HoTen, DiaChi, SDT, Email, Username, MatKhau, IDChucVu) VALUES
(N'Mr.CEO', N'123 Đường Thánh Gióng', '1234567890', 'mrceo@gmail.com', 'ceo', '1234', 1),
(N'Nguyễn Thu Ngân', N'124 Đường Ngô Quyền', '0123456789', 'ntn@gmail.com', 'thungan', '4ktu', 4),
(N'Lê Minh Huy', N'172 Đường Lý Thánh Tôn', '0234135789', 'lmh@gmail.com', 'thungan2', 'vkll', 4),
(N'Đặng Nguyễn Tiến', N'568 Đường Phát Tài', '0155686868', 'imrich@gmail.com', 'cto', '6868', 2),
(N'Mai Tao Giàu', N'921 Đường Số Khổ', '0524212121', 'ffo@gmail.com', 'cfo', 'asdf', 3),
(N'Nguyễn Thế Minh', N'143 Phường Linh Trung', '0123224356', 'randommail@gmail.com', 'thungan3', '1234', 4),
(N'Lê Huy Hoàng', N'234 Đường Lận Đận', '2381274362', 'bv@gmail.com', 'bv', '0123', 5),
(N'Bảo Thị Vệ', N'234 Đường Giàu Sang', '2330974362', 'bv1@gmail.com', 'bv1', '1234', 5),
(N'Bành Bảo Vệ', N'234 Đường Phú Quý', '9830974362', 'bv2@gmail.com', 'bv2', '2345', 5),
(N'Lê Thị Bảo', N'234 Đường Tài Vận', '3710974362', 'bv3@gmail.com', 'bv3', '1234', 5)

INSERT INTO KhachHang (HoTen, DiaChi, SDT, Email) VALUES
(N'Nguyễn Văn A', N'100 Địa Ngục', '0000000001', 'nva@gmail.com'),
(N'Phạm Thị B', N'1024 Nước Mẽo', '0000000002', 'ptb@gmail.com')
