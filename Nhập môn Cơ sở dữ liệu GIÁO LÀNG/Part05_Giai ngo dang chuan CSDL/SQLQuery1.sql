--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 01 + 02- Giải ngố về dạng chuẩn CSDL

CREATE DATABASE DBDESIGN_GIAINGONF
USE DBDESIGN_GIAINGONF

--DẠNG PHI CHUẨN 
CREATE TABLE StudentNoNF
(
	Id char(8),
	FullName nvarchar(25),
	DOB date,
	PAddress nvarchar(40),
	MajorID char(2), 
	MajorName nvarchar(30)
)
-- TABLE KHÔNG ĐẠT CHUẨN, CHƯA ĐẠT CHUẨN 1, 1NF, FIRST NORMALIZATION 
SELECT * FROM StudentNoNF
INSERT INTO StudentNoNF VALUES ('SE123456', N'AN NGUYỄN', '2001-1-1', N'TP. HỒ CHÍ MINH', 'SE', N'KĨ THUẬT PHẦN MỀM')
INSERT INTO StudentNoNF VALUES ('SE123457', N'BÌNH LÊ', '2001-2-1', N'ĐỒNG NAI', 'SE', N'KĨ THUẬT PHẦN MỀM')
INSERT INTO StudentNoNF VALUES ('SE123458', N'CƯỜNNG VÕ', '2001-3-1', N'BÌNH DƯƠNG', 'SE', N'SOFTWARE ENGINEERING')
INSERT INTO StudentNoNF VALUES ('SE123458', N'DŨNG PHẠM', '2001-1-1', N'TIỀN GIANG', 'GD', N'ĐỒ HỌA-TRUYỀN THÔNG')

-- Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 02 - Giải ngố về dạng chuẩn CSDL
-- CÓ VẤN ĐỀ VỚI TABLE NÀY, THIẾT KẾ NÀY
-- TABLE KO CÓ KEY, KO GÀI 1 RÀNG BUỘC, HAY ĐIỀU KIỆN NÀO ĐÓ THÌ 
--		LINH HOẠT THOẢI MÁI NHẬP DATA MÀ KO SỢ BỊ BẮT LỖI 
--		MỌI DATA LUÔN CÓ SẴN TRONG 1 TABLE, VÀI TABLE, câu lệnh SELECT cực nhanh, ko cần JOIN 
-- VẤN ĐỀ:
--		LÀM SAO TÌM RA ĐC 1 SV NÀO ĐÓ, TÌM/WHERE THEO TÊN -> TRÙNG TÊN
--		muốn tìm chính xác ai đó thì phải where nhiều cột hơn
--		where theo mã số, thì có vài mã số trùng -> hoài nghi data luôn 
--			-> SELECTION ANOMALY 
--		XÓA DATA
--		xóa dòng Dũng Phạm, mất cái gì ??? mất luôn chuyên ngành GD, ko còn hiện diện
--		trong dssv, lỗi này xh do thông tin của chuyên ngành đi kèm với thông tin sv
--		lẽ ra thông tin chuyên ngành phải nằm riêng chỗ khác, sv có kết nối tới CN mới là đúng 
--			-> DELETE ANOMALY 
--		UPDATE DATA/ INSERT DATA
--		do thiết kế của ta gộp nhiều cụm info khác biệt vào trong 1 table, lệch data 
--		SE KTPM, SE Software Engineering, SE Kĩ thuật phần mềm 
--		inconsistency, ko nhất quán, ko đồng bộ, mặc dù nhìn = mắt thì là 1, máy thì coi là khác 
--			-> UPDATE ANOMALY 

--	CHỐT HẠ: 1 THIẾT KẾT TỐT, THÌ CÁC THAO TÁC CRUD CÓ XUẤT HIỆN ÍT NHẤT HIỆN TƯỢNG ANOMALY
--			 THIẾT KẾ SẼ BỊ ANOMALY NẾU TA CỐ GOM NHIỀU THỰC THỂ DATA KHÁC NHAU VÀO TRONG 1 TABLE 
--			 CHUẨN ĐỂ LẤY CONSISTENCY 
--	THỰC TẾ: NGƯỜI TA CÓ THỂ PHI CHUẨN, KO CÀI RÀNG BUỘC NHIỀU TRÊN CSDL, ĐỂ LẤY PERFORMANCE 
--																		  NoSQL tiếp cận theo hướng này 

/*	GIẢI QUYẾT VẤN ĐỀ SELECTION, LẤY DATA - THÔNG QUA KHÁI NIỆM KEY
	CANDIDATE KEY, COMPOSITE KEY (key gồm nhiều cột), SUPER KEY, SURROGATE KEY, NATURAL KEY 
	PRIMARY KEY
	KEY: LÀ 1 CỘT, HAY VÀI CỘT TRONG 1 TBALE MÀ GIÁ TRỊ CỦA NÓ LÀ DUY NHẤT TRÊN TẤT CẢ CÁC DÒNG
	VALUE TRONG CỘT KEY CẤM TRÙNG, ĐƯỢC LỢI LÀ: DÙNG NÓ LẤY RA DUY NHẤT 1 DÒNG
	KEY DÙNG CHO WHERE, ĐỂ TÌM 1 THÔNG TIN DUY NHẤT, ĐẠI DIỆN CHO 1 DÒNG KHÁC BIỆT VỚI DÒNG CÒN LẠI,
	DÙNG ĐỂ NHẬN DIỆN 1 OBJECT, ĐỐI TƯỢNG DỮ LIỆU
	dùng MSSV -> tìm ra duy nhất 1 sv
	1 chìa khóa -> mở 1 cánh cửa  

	1 TABLE VỀ LÝ THUYẾT CÓ N KEY, NHIỀU CỘT HAY CỤM CỘT ĐÓNG VAI TRÒ KEY ĐƯỢC MÀ 
	Table Student(Id, Name, Address, Email, Phone,...)
				  K					   K      K
				  3 cột này đc gọi là 3 key khác nhau, 3 key ứng viên, candidate key 
	Thường người ta có xu hướng lấy 1 key nào đó làm key default, mặc định dùng nó làm key 
	Key chính, PRIMARY KEY xuất hiện 

	Key này ngoài đời đang dùng cho tiện việc quản lí, ko phải là con số vô hồn tự tăng NATURAL KEY 
	TỰ TĂNG ĐẢM BẢO RÕ RÀNG KO TRÙNG, VÔ NGHĨA, CHỈ CON SỐ THÔI, KEY NÀY GỌI LÀ SURROGATE KEY
	(DÙNG SỐ INT, LONG TỰ TĂNG, DÙNG DÃY HEXA RẤT DÀI) 

	PK, K là như nhau
	PK có 2 loại: đơn thuộc tính, đa thuộc tính (nhiều cột gom lại tạo nên giá trị duy nhất)
	
	Lưu thông tin các căn hộ bán/cho thuê 
	Apartment (Tên-bulding, Số-phòng, Diện-tích, Giá-thuê, Giá-bán...)
				SGTower			101
				SGTower			102
				Landmark		101
				Innovation		101

	Key đâu, 2 cột mới tạo nên sự duy nhất, key phức hợp, 2 cột làm key, chứ ko phải 2 key 
	COMPOSITE KEY, gom vài cột để xác định sự duy nhất 
	CỒNG KỀNH, GIẢM PERFORMANCE CỦA DBMS
	thường trng n tình huống, người ta sẽ THÊM CỘT GIÁ TRỊ TỰ TĂNG, PHẾ 2 TAHNWGF NÀY LÀM CANDIDATE KEY 

	CỘT DATA: CỘT ĐƠN TRỊ - SINGLE VALUE, CỘT ĐA TRỊ - MULTI-VALUE, CỘT PHỨC HỢP - COMPOSITE VALUE 
	CỘT ĐƠN TRỊ: CỘT CHỨA 1 VALUE, 1 Ý NGHĨA 
				VD: năm sinh, điểm TB, tổng tiền, giảm giá 
	CỘT ĐA TRỊ: TRONG CỘT LƯU NHIỀU DATA ĐỘC LẬP NHAU, CÙNG TƯƠNG ĐƯƠNG Ý NGHĨA 
				VD: số điện thoại 
					091x; 902y; 903z | 094
	nhét nhiều value vào trong 1  CELL CHO TIỆN, GỌN
	người ta dùng thêm delimeter/dấu phân cách để phân tách các value 
	trong cột đa trị (dấu ; dấu - dấu xổ đứng |
	Cell này chứa các giá trị tương đương: 091x 092y đều là sđt

	CỘT PHỨC HỢP: trong cột lưu nhiều thành phần data, mỗi tp một vai trò và tất cả thành phần 
	gom lại thành 1 ý nghĩa mới, từng tp có ý nghĩa riêng
				VD:					cột địa chỉ 
					1/1 Lê Lợi, Phường Cầu Ông Lãnh, Q.1, TP.HCM 
					--1 địa chỉ gồm nhiều miếng info khác nhau về ý nghĩa, gom lại ra 1 ý ngĩa khác 
					
	* ĐẶC BIỆT: CỘT VỪA MULTI-VALUED VỪA COMPOSITE
	VD:								cột địa chỉ 
					1/1 Lê Lợi, P.COL, Q.1, TP.HCM | 5 Man thiện, P. TP. Thủ Đức  
						đ/c thường trú						đ/c tạm trú 
					2 địa chỉ, mỗi địa chỉ lại là composite 
*/
-----------------------------------------------------------------------------------
-- Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 04 - Giải ngố về dạng chuẩn CSDL

/*	TA CÓ NHIỀU CÁCH ĐÁNH GIÁ CHẤT LƯỢNG 1 CSDL THEO TIÊU CHÍ CÓ TỒN TẠI ANOMALY HAY KO 
	TỨC LÀ ĐÁNH GIÁ CSDL QUA VIỆC THÊM XÓA SỬA LẤY DATA NÓ CÓ GÂY RA NHỮNG BẤT THƯỜNG NÀO KO
	NGƯỜI TA CHIA > 4 MỨC ĐÁNH GIÁ, MỖI MỨC ĐC GỌI LÀ DẠNG CHUẨN CSDL - NORMALIZATION FORM - NF
	1NF, 2NF, 3NF, BCNF, 4NF, 5NF, 6NF (tranh luận...)
		-> càng cao thì càng tốt ANOMALY, giảm thiểu những hiệu ứng thao tác data 
		-> giá phải trả: performance bị ảnh hưởng 
		   càng chuẩn cao, càng TÁCH BẢNG nhiều, thằng nào chuyên việc thằng đó
		   mỗi table lưu đúng giá trị mình cần, tính phân mảnh của table rất lớn 
		   tách bảng nhiều, JOIN nhiều, tốn RAM, xử lí 
	MỨC SAU BAO HÀM PHẢI THỎA MỨC TRƯỚC
	NẾU MUỐN LÀ 2NF, THÌ PHẢI LÀ 1NF TRƯỚC ĐÃ
	TABLE NÀO ĐAT CHUẨN 3, CHẮC CHẮN PHẢI ĐẠT CHUẨN 1 VÀ 2 TRƯỚC ĐÓ 
	
	CHUẨN CỦA 1 DATABASE SẼ TÍNH THEO CHUẨN THẤP NHẤT CỦA CÁC TABLE MÀ NẰM TRONG DATABASE NÀY 
	DB QLBH giả sử có 10 table T1 T2 T3..., hầu hết các table đều đạt 3NF, chỉ có 1 table đạt 2 NF, vậy DB đạt chuẩn 2

	THỰC TẾ THỰC HÀNH, THÌ NGƯỜI TA ƯU THÍCH CHUẨN 3, ĐỦ ỔN CHO THAO TÁC ANOMALY 
											HIỆU NĂNG ĐỦ TỐT 
	NÂNG DẠNG CHUẨN TỨC LÀ TÁCH BẢNG - DECOMPOSITION/PHÂN TÁCH ĐỂ ĐẢM BẢO BỚT ANOMALY 
	CÒN 1 DẠNG KHÁC: PHI CHUẨN, CHỦ ĐỘNG THIẾT KẾ CHUẨN THẤP, ĐẠT MỤC TIÊU DATA AVAILABLE TRONG 1 BẢNG NÀO ĐÓ
								ĐỠ PHẢI JOIN 
								GIÁ PHẢI TRẢ: CODE PHẢI KIỂM TRA RÀNG BUỘC DỮ LIỆU (BUSINESS LOGIC), THAY VÌ ĐỂ DATABASE LO 
											  CÂU LỆNH IF TRONG CODE 
	
	RELATIONAL ALGEBRA: ĐẠI SỐ QUAN HỆ, TOÁN TOÀN CHƠI VỚI TABLE, CHỈ QUAN TÂM ĐẾN CỘT - RELATION 
	R(ABCDE) A KEY, FD: A -> BCDE, B -> CDE, HỎI CHUẨN MẤY
	OrderDetail(SEQ,.....SL, ĐG), SELECT * FROM .... WHERE SEQ = DÒNG BẤT KÌ TRONG ĐƠN HÀNG 
								  SEQ -> CỘT CÒN LẠI 

	OrderDetail(SEQ,.....SL, ĐG, TT)   SL, ĐG -> TT (DO SL * ĐG = TT)
												 TT BỊ PHỤ THUỘC HÀM (CÁCH TÍNH) VÀO CỘT KHÁC 
									   FD: HÀM TÍNH TOÁN, FUNCTIONAL DEPENDENCY 
									   Y = F(X) = X^2
											X -> Y THEO QUY TẮC BÌNH PHƯƠNG 
									   FD: X -> Y 

	
*/
------------------------------------------------------------------------------

--	* DẠNG CHUẨN 1: MỘT TABLE ĐẠT DẠNG CHUẨN NẾU TABLE CÓ (MỆNH ĐỀ AND)
--					PHẢI CÓ 1 PK 
--					KHÔNG CHỨA CỘT ĐA TRỊ - KO MULTI-VALUED 		

--	BÌNH LUẬN
--	Nếu table có key, PK, dễ dàng tìm đc 1 dòng, từ key lôi ra đc 1 thực thể data, 1 đối tượng dữ liệu
--	Ưu: Cột đa trị tiện dụng trong việc lưu trữ info, do gom data vào trong 1 table 
--	Nhược: yêu cầu tìm kiếm và thống kê bị trục trặc 1 chút 

--  VÍ DỤ MINH HỌA  
--  Phần mềm CRM - Customer Relationship Management, HRM - Human Resourse Management 
--  Tôi muốn lưu trữ thông tin nhân viên/kh, gồm số điện thoại liên lạc (cá nhân, để bàn, công ty), 
--	email(công ty, cá nhân, email làm dự án k/h)
--	account login vào các hệ thống...

-- 0NF 
CREATE TABLE CustomerNoNF 
(
	Id char(10) PRIMARY KEY,
	--FullName nvarchar(50) -> COMPOSITE FIELD: GỒM LAST VÀ FIRST - 2 Ý NGHĨA KHÁC NHAU
	FirstName nvarchar(15),	-- ta tách vì ta muốn sort chấp tên Việt
	LastName nvarchar(15),  -- hay tên nước ngoài. Full name ko sort đc 
	Address nvarchar(60),	-- composite 
	Phone varchar(40),		-- lưu các số phone -- ĐA TRỊ 
	Email varchar(50)		-- lưu các email -- ĐA TRỊ 
)
SELECT * FROM CustomerNoNF
INSERT INTO CustomerNoNF VALUES 
('HCM0001', N'AN', N'NGUYỄN', N'1 LÊ LỢI, P.CẦU KHO, Q1, TP.HCM | ... Q.GV, TP.HCM', '090xxx | 091xxx | 0281xxx', 'an@...; an@...'),
('HCM0002', N'BÌNH', N'LÊ', N'1 QUANG TRUNG, P.1, Q.GV, HCM | ... Q.GÒ VẤP, HCM', '092xxx | 093xxx | 094xxx', 'binh@...-binh2001@...'),
('ĐNI0001', N'CƯỜNG', N'VÕ', N'1 VÕ NGUYÊN GIÁP, PLBT, ĐỒNG NAI|...Q.12, TP.HCM', '096xxx', 'cuongvo@')

-- UI của app nhập hồ sơ k/h n/v có ô nhập địa chỉ: [gõ đ/c 1 ;|- đ/c 2]
-- UI								  nhập phone  : [gõ p1, p2; p3]

-- * BL
-- 1 cell Phone, đ/c, email chứa tất cả thông tin ta cần!!! tiện cho việc lấy ra, SELECT
-- DẠNG CHUẨN THẤP, PERFORMANCE NHANH, VÌ CÓ SẴN TRONG 1 TABLE 

-- NHƯNG NẾU TA QUAN TÂM THÊM/ CHI TIẾT TỪNG MIẾNG INFO: 
--							   tìm số di động của ai đó, tìm số đt ở nhà 
--							   tìm email cá nhân, liệt kê hết ra email cá nhân...
-- GỘP N DATA VÀO TRONG 1 CELL, QUY ƯỚC "NGẦM" GHI LỜI NHẮC TRÊN MÀN HÌNH NHẬP 
--								tiềm ẩn sai sót do nhầm lẫn thứ tự
--								bay màu ý nghĩa riêng: đ/c tạm trú, thường trú ngang nhau rồi 
-- ANOMALY ĐÃ XH LIÊN QUAN NHẬP DATA - UPDATE/INSERT ANOMALY 
--									   DELIMITER DÙNG KO NHẤT QUÁN ,;|- 
--									   CHECK QUA CODE, MANF HÌNH NHẬP 
-- NHÌN DỮ LIỆU ĐA NGHĨA HƠN -> CÓ VẤN ĐỀ VỚI ĐA TRỊ 

---------------------------------------------------------------------------------------------
-- Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 04 - Giải ngố về dạng chuẩn CSDL

-- ĐỂ NÂNG CHUẨN, ĐẠT CHUẨN 1, TỨC LÀ TRÁNH BỊ VẤN ĐỀ ĐA TRỊ ĐÃ NÊU Ở TRÊN, 
-- TRÁNH BỊ THỐNG KÊ, NHẬP DATA BAY MÀU Ý NGHĨA, LỘN XỘN DELIMETER 
-- NÂNG CHUẨN 1, LOẠI BỎ ĐA TRỊ 
-- 2 KĨ THUẬT: TÁCH CỘT		           VÀ TÁCH BẢNG. ĐA PHẦN GIANG HỒ CHỌN GIẢI PHÁP TÁCH DÒNG/BẢNG  
--			   MỞ RỘNG THEO CHIỀU NGANG   MỞ RỘNG THEO CHIỀU DỌC (xịn sò, linh hoạt, cần gì thì thêm dòng) 

CREATE TABLE Customer1NFV1 
(
	Id char(10) PRIMARY KEY,
	FirstName nvarchar(15),	
	LastName nvarchar(15),  
	Address nvarchar(60),	-- composite 
	HomePhone varchar(11),		-- lưu 1 số phone
	WorkPhone varchar(11),
	CellPhone varchar(11),
	PerEmail varchar(30),		-- lưu 1 email 
	ComEmail varchar(30)
)--CHUẨN 1NF RỒI ĐÓ: CÓ PK + KO ĐA TRỊ 

SELECT * FROM Customer1NFV1
INSERT INTO Customer1NFV1 VALUES 
('HCM0001', N'AN', N'NGUYỄN', N'1 LÊ LỢI, P.CẦU KHO, Q1, TP.HCM | ... Q.GV, TP.HCM', '090xxx', '091xxx', '0281xxx', 'an@...', 'an@...'),
('HCM0002', N'BÌNH', N'LÊ', N'1 QUANG TRUNG, P.1, Q.GV, HCM | ... Q.GÒ VẤP, HCM', '092xxx', '093xxx', '094xxx', 'binh@...', 'binh2001@...'),
('ĐNI0001', N'CƯỜNG', N'VÕ', N'1 VÕ NGUYÊN GIÁP, PLBT, ĐỒNG NAI|...Q.12, TP.HCM', '096xxx', NULL, NULL, 'cuongvo@', NULL)

-- * BL 
--	Khi tách cột hàm ý mẫu số chung của hầu hết là 3 cột phone, 2 cột email 
--	Giải pháp tách cột là giải pháp bị cột NULL, ko mang giá trị/chưa xác định giá trị 
--	Nếu có người có lố hơn 2 email, 2 sim 2 sóng, chết mẹ thêm cột nữa, và null nữa
--	Thêm cột là sửa form nhập, sửa UI, cấu trúc table  

--	ƯU ĐIỂM: muốn lấy phone nào, email nào, select cột đó!!!
--  THỐNG KÊ/LIỆT KÊ EMAIL LÀM VIỆC 
SELECT Id, FirstName + ' ' + LastName AS FullName, ComEmail FROM Customer1NFV1 ORDER BY FullName DESC

-- TÁCH CỘT DỄ LÀM, NHƯNG GIÁ PHẢI TRẢ LÀ CÓ THẬT:
-- SỬA FORM/PAGE, THÊM Ô NHẬP, NULL TRONG DATABASE 
-- CUỘC SỐNG, APP VẬN HÀNH, DỮ LIỆU THAY ĐỔI, MỞ RỘNG CHIỀU NGANG KO ĐÁP ỨNG TỐT, 
-- VÌ THÊM CỘT, SỬA CODE CHẮC CHẮN 
-- CHỈ LÀ THÊM DỮ LIỆU THÔI MÀ, TABLE ĐC THIẾT KẾ ĐỂ LƯU VÀ THÊM DỮ LIỆU
-- TA NÊN TIẾP CẬN THEO CHIỀU DỌC, NÊN MỞ RỘNG THEO CHIỀU DỌC, THÊM DATA LÀ THÊM DÒNG HOY, 
-- KO ẢNH HƯỞNG CẤU TRÚC TABLE LÀ TỐT NHẤT, KO CẦN SỬA UI, KO CẦN SỬA CODE 

-- TÁCH BẢNG, SINH RA VÊNH DATA -> KHÓA NGOẠI SẼ XUẤT HIỆN 
-- JOIN SẼ XUẤT HIỆN: JOIN =, KO BẰNG (OUTER JOIN), TÍCH ĐỀ-CÁC 

------------------------------------------------------------------------------------------
-- Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 05 - Giải ngố về dạng chuẩn CSDL
CREATE TABLE Customer1NF_V2 
(
	Id char(10) PRIMARY KEY,
	FirstName nvarchar(15),	
	LastName nvarchar(15),  
	Address nvarchar(60),	-- composite 
)
-- TA SẼ CẦN THÊM 1 BẢNG LƯU SỐ PHONE, 1 BẢNG LƯU EMAIL, SAU NÀY NẾU THÊM DATA THÌ THÊM DÒNG, 
-- NULL KO XUẤT HIỆN VÌ AI CÓ NHIỀU PHONE NHIỀU DÒNG, AI ÍT PHONE THÌ ÍT DÒNG 
-- KHI TÁCH BẢNG, PHONE, EMAIL NGAOIF VIỆC LƯU DATA 090x, an@... thì ta cần lưu ý thêm về
-- Ý NGHĨA CỦA DATA: cột HomePhone -> ý nghĩa, PerEmail:		an@
--												ý nghĩa data 	data 	

-- ĐEM Ý NGHĨA DATA SANG BẢNG MỚI 

CREATE TABLE PhoneEmail  --thiết kế dở 
(
	HomePhone varchar(11),		
	WorkPhone varchar(11),
	CellPhone varchar(11),
	PerEmail varchar(30),		
	ComEmail varchar(30)
)
CREATE TABLE Phone1NF_V2_1  
(	
--	dùng PhoneNumber làm OK ổn, nhưng bị varchar 
--	thực ra ta cần 1 key hoy mà, có ý nghĩa hay ko với table này ko quan trọng lắm
--	hiếm khi ta where key này - ta dùng key thay thế, số tự tăng, SURROGATE KEY  
	Seq int IDENTITY(1,5) PRIMARY KEY, -- số khởi đầu và bước nhảy 
	PhoneNumber varchar(11),		
	PhoneDesc nvarchar(20), --diễn tả ý nghĩa số phone 
							--chính là thông qua tên cột cách cũ!
)
SELECT * FROM Phone1NF_V2_1
-- THIẾT KẾ TÁCH BẢNG NÓ CÓ 1 VẤN ĐỀ LÀ DỮ LIỆU BỊ PHÂN MẢNH, DEFAULT KO 
-- KẾT NỐI GIỮA CÁC TABLE ĐỂ TÁI NHẬP LẠI DATA GỐC TRƯỚC KHI BỊ TÁCH
-- TA CẦN THÊM CỘT ĐỂ MÓC NỐI LẠI DỮ LIỆU, THAM CHIẾU LẠI DÒNG DỮ LIỆU GỐC TRƯỚC KHI TÁCH 
-- BÀI NÀY, THÌ NGOÀI Ý NGHĨA LOẠI PHONE, CẦN THAM CHIẾU VỀ
-- TABLE CUSTOMER ĐỂ NÓI RẰNG PHONE NÀY CỦA AI??? - THAM CHIẾU REFERENCE 

CREATE TABLE Phone1NF_V2_2
(	
	Seq int IDENTITY(1,5) PRIMARY KEY, 
	PhoneNumber varchar(11),		
	PhoneDesc nvarchar(20),
	CID char(10)
)

INSERT INTO Customer1NF_V2 VALUES 
('HCM0001', N'AN', N'NGUYỄN', N'1 LÊ LỢI, P.CẦU KHO, Q1, TP.HCM | ... Q.GV, TP.HCM'),
('HCM0002', N'BÌNH', N'LÊ', N'1 QUANG TRUNG, P.1, Q.GV, HCM | ... Q.GÒ VẤP, HCM' ),
('ĐNI0001', N'CƯỜNG', N'VÕ', N'1 VÕ NGUYÊN GIÁP, PLBT, ĐỒNG NAI|...Q.12, TP.HCM')

INSERT INTO Phone1NF_V2_2 VALUES ('090xxx', 'Home Phone', 'HCM0001')
INSERT INTO Phone1NF_V2_2 VALUES ('091xxx', 'Work Phone', 'HCM0001')
INSERT INTO Phone1NF_V2_2 VALUES ('092xxx', 'Cell Phone', 'HCM0001')
INSERT INTO Phone1NF_V2_2 VALUES ('092xxx', 'Cell Phone', 'HCM0002')
INSERT INTO Phone1NF_V2_2 VALUES ('093xxx', N'Di động', 'HCM0002')
INSERT INTO Phone1NF_V2_2 VALUES ('094xxx', 'Công ty', 'HCM0002')
INSERT INTO Phone1NF_V2_2 VALUES ('096xxx', 'Cá nhân', 'ĐNI0001')
INSERT INTO Phone1NF_V2_2 VALUES ('097xxx', 'Cá nhân', 'LA0001')

SELECT * FROM Phone1NF_V2_2
SELECT * FROM Customer1NF_V2
/*

HCM0001   	AN		NGUYỄN	1 LÊ LỢI, P.CẦU KHO, Q1, TP.HCM | ... Q.GV, TP.HCM
HCM0002   	BÌNH	LÊ		1 QUANG TRUNG, P.1, Q.GV, HCM | ... Q.GÒ VẤP, HCM
ÐNI0001   	CƯỜNG	VÕ		1 VÕ NGUYÊN GIÁP, PLBT, ĐỒNG NAI|...Q.12, TP.HCM

1	090xxx	Home Phone	HCM0001   
6	091xxx	Work Phone	HCM0001   
11	092xxx	Cell Phone	HCM0001   
16	092xxx	Cell Phone	HCM0002   
21	093xxx	Di động		HCM0002   
26	094xxx	Công ty		HCM0002   
31	096xxx	Cá nhân		ÐNI0001   
36	097xxx	Cá nhân		LA0001   <---- ko có ở bảng 1, ko ai cấm 
				^
				|
			ko đồng nhất
*/

CREATE TABLE Phone1NF_V2_3
(	
	Seq int IDENTITY(1,5) PRIMARY KEY, 
	PhoneNumber varchar(11),		
	PhoneDesc nvarchar(20),
	CID char(10) REFERENCES Customer1NF_V2(Id)
	--CID char(10),
	--CONSTRAINT FK_Phone1NF_V2_3_Customer1NF_V2 FOREIGN KEY(CID) REFERENCES Customer1NF_V2(Id)
)

INSERT INTO Phone1NF_V2_3 VALUES ('092xxx', 'Cell Phone', 'HCM0002')
INSERT INTO Phone1NF_V2_3 VALUES ('093xxx', N'Di động', 'HCM0002')
INSERT INTO Phone1NF_V2_3 VALUES ('094xxx', 'Công ty', 'HCM0002')
INSERT INTO Phone1NF_V2_3 VALUES ('096xxx', 'Cá nhân', 'ĐNI0001')--vô 
INSERT INTO Phone1NF_V2_3 VALUES ('097xxx', 'Cá nhân', 'LA0001') --vào cái đầu mày 

SELECT * FROM Phone1NF_V2_3
SELECT * FROM Customer1NF_V2
SELECT c.*, p.PhoneNumber FROM Customer1NF_V2 c INNER JOIN Phone1NF_V2_3 p ON c.Id = p.CID
SELECT c.*, p.PhoneNumber FROM Customer1NF_V2 c, Phone1NF_V2_3 p WHERE c.Id = p.CID

SELECT c.*, p.PhoneNumber FROM Customer1NF_V2 c LEFT JOIN Phone1NF_V2_3 p ON c.Id = p.CID
/*
HCM0001   	AN	NGUYỄN	1 LÊ LỢI, P.CẦU KHO, Q1, TP.HCM | ... Q.GV, TP.HCM	NULL
HCM0002   	BÌNH	LÊ	1 QUANG TRUNG, P.1, Q.GV, HCM | ... Q.GÒ VẤP, HCM	092xxx
HCM0002   	BÌNH	LÊ	1 QUANG TRUNG, P.1, Q.GV, HCM | ... Q.GÒ VẤP, HCM	093xxx
HCM0002   	BÌNH	LÊ	1 QUANG TRUNG, P.1, Q.GV, HCM | ... Q.GÒ VẤP, HCM	094xxx
ÐNI0001   	CƯỜNG	VÕ	1 VÕ NGUYÊN GIÁP, PLBT, ĐỒNG NAI|...Q.12, TP.HCM	096xxx
*/

----------------------------------------------------------------------
--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 06 - Giải ngố về dạng chuẩn CSDL

--PHÂN TÍCH TIẾP: TRONG CỘT DỮ LIỆU, CÓ NHỮNG CỘT TẬP DATA LÀ VÔ CHỪNG
--(tên người vô chừng, địa chỉ nhà vô chừng, điểm số,...
--CÓ NHỮNG CỘT TẬP DATA (DỮ LIỆU NHẬP VÀO) LÀ 1 TẬP XÁC ĐỊNH CÁC GIÁ TRỊ CÓ TRƯỚC 
--(tên quốc gia, múi giờ, danh sách ngân hàng, tên học kì, thành phố, tỉnh,...)
-- KHI ĐÓ NẾU BẮT NGƯỜI DÙNG NHẬP LẠI DATA ĐÃ BIẾT TRƯỚC NÀY 
-- THÌ HOÀN TOÀN KO TỐT, SẼ GÂY NHÀM CHÁN -> DẪN ĐẾN VIẾT TẮT
-- GÂY NÊN INCONSISTENCY - KO NHẤT QUÁN 
-- TPHCM, TP.HCM, TP. HCM -> là 1 nhưng gõ 3 cách, 3 data khác nhau 
-- TÁCH BẢNG ĐỂ NGƯỜI TA CHỈ CHỌN 1 TRONG NHỮNG CÓ SẴN 
--				UI -> COMBOBOX, DROPDOWN LIST 
-- hãy chọn ds quốc gia, tỉnh thành, quận huyện 

CREATE TABLE Customer1NF 
(
	Id char(10) PRIMARY KEY,
	FirstName nvarchar(15),	
	LastName nvarchar(15),  
	Address nvarchar(60),	-- composite 
)
CREATE TABLE Phone1NF
(	
	Seq int IDENTITY(1,5) PRIMARY KEY, 
	PhoneNumber varchar(11),		
	--PhoneDesc nvarchar(20) --gõ thoải mái, gây nên inconsistency 
							 --tách bảng thì phải có cách join lại
							 --đề phòng gõ lung tung - FK xuất hiện
							 --số phone này là thuộc loại nào 
							 --tham chiếu sang bảng PhoneType 
	PTID char(2) REFERENCES PhoneType1NF(PhoneTypeID),
	CID char(10) REFERENCES Customer1NF(Id)
)

-- 1-N mới xuất hiện, type này sẽ có nhiều số phone 
-- Type -> 1 N tới Phone, vì 1 loại di động có n số 
--									số công ty có n só 
CREATE TABLE PhoneType1NF
(	PhoneTypeID char(2) PRIMARY KEY, --DD, HM, WR, SD 
	PhoneDesc nvarchar(20) --diễn tả ý nghĩa số phone, 
							--ko cho người dùng thường gõ các loại phone 
							--mà phải chọn từ combo box 
)
--ĐẠT CHUẨN 3 LUÔN RỒI ĐÓ 

--------------------------------------------------------------------------
--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 07 - Giải ngố về dạng chuẩn CSDL

--CUSTOMER ----------<- PHONE  ->--------- TYPE (DD, HP, WK, SD)
--	C1				  N1, N2, N3				DD
--	C2				  N1, N2				    HP
--	C3				  N1						WK
--	C4 -------------------------------------------
--	--------------------------------------------SD 

INSERT INTO Customer1NF(Id) VALUES ('C1')
INSERT INTO Customer1NF(Id) VALUES ('C2')
INSERT INTO Customer1NF(Id) VALUES ('C3')
INSERT INTO Customer1NF(Id) VALUES ('C4')

INSERT INTO PhoneType1NF VALUES 
		('DD', N'Di động'), ('HP', N'Để bàn nhà'), ('WK', N'Công ty'), ('SD', N'Sugar Daddy')

SELECT * FROM Customer1NF
SELECT * FROM PhoneType1NF
DELETE PhoneType1NF -- DO THIẾU N'' NÊN PHẢI XÓA LÀM LẠI 
-- table Type, City, Học-Kì (Fall, Spring, Summer) đôi khi đc gọi tên là 
-- LOOKUP TABLE, giá trị có sẵn cung cấp cho ai đó SELECT CHỌN MÀ DÙNG  

INSERT INTO Phone1NF VALUES ('C1 NO1', 'C1', 'DĐ') -- gẫy, loại phone cà chớn 
INSERT INTO Phone1NF VALUES ('C1 NO1', 'DD', 'C1') -- vào 
INSERT INTO Phone1NF(PhoneNumber, CID, PTID) VALUES ('C1 NO2', 'C1', 'DD') -- vào
INSERT INTO Phone1NF(PhoneNumber, CID, PTID) VALUES ('C1 NO3', 'C1', 'DD') -- vào
INSERT INTO Phone1NF(PhoneNumber, CID, PTID) VALUES ('C2 NO1', 'C2', 'HP') 
INSERT INTO Phone1NF(PhoneNumber, CID, PTID) VALUES ('C2 NO2', 'C2', 'HP') 
INSERT INTO Phone1NF(PhoneNumber, CID, PTID) VALUES ('C3 NO1', 'C3', 'WK') 

SELECT * FROM Phone1NF
SELECT * FROM Customer1NF
SELECT * FROM PhoneType1NF

--1. Liệt kê thông tin khách hàng, gồm số phone, loại phone để tiện liên lạc 
SELECT c.Id, p.PhoneNumber, p.PTID FROM Customer1NF c INNER JOIN Phone1NF p ON c.Id = p.CID 
												-- hụt mất c4 anh ta chưa có phone 
--xài left join lấy những anh chàng ko thỏa công thức join = 
--lấy nốt những thằng chưa bằng/tìm thấy bên kia. Ko thấy bên kia để NULL 
SELECT c.Id, p.PhoneNumber, p.PTID FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID 
/*
C1    C1 NO2	DD
C1    C1 NO3	DD
C2    C2 NO1	HP
C2    C2 NO2	HP
C3    C3 NO1	WK
C4    NULL		NULL
*/
--ta cần lấy thêm info: LOẠI PHONE chi tiết diễn giả là gì 
--CẦN JOIN THÊM VỚI TYPE 
--2. Liệt kê info k/h gồm số phone, loại phone, diễn giải loại phone 
SELECT c.Id, p.PhoneNumber, t.* FROM Customer1NF c, Phone1NF p, PhoneType1NF t 
													WHERE c.Id = p.CID AND p.PTID = t.PhoneTypeID
													--mất C4 và SD 
SELECT c.Id, p.PhoneNumber, p.PTID, t.PhoneDesc FROM Customer1NF c INNER JOIN Phone1NF p ON c.Id = p.CID 
														INNER JOIN PhoneType1NF t ON p.PTID = t.PhoneTypeID
													--mất C4 và SD 
			--do chỉ tập trung vào match những thằng có xuất hiện ở 2 nên join 
SELECT c.Id, p.PhoneNumber, t.* FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID 
												   FULL JOIN PhoneType1NF t ON p.PTID = t.PhoneTypeID
/*
C1     C1 NO3	DD		Di động
C2     C2 NO1	HP		Để bàn nhà
C2     C2 NO2	HP		Để bàn nhà
C3     C3 NO1	WK		Công ty
C4     NULL		NULL	NULL
NULL   NULL		NULL	Sugar Daddy
*/
-- THỐNG KÊ NÂNG CAO, MÀ ĐỂ ĐA TRỊ HOK LÀM ĐC 
--3. LIỆT KÊ CHO TUI BIẾT, ĐẾM XEM MỖI KHÁCH HÀNG CÓ BAO NHIÊU SỐ PHONE
--							 ĐA TRỊ PHẢI CẮT CHUỖI ĐỂ ĐẾM, CẮT THEO DELIMITER 
-- XÀI CÁC HÀM AGGREGATION - GOM NHÓM MÀ ĐẾM - COUNT() MAX() MIN() AVG() SUM() 

SELECT COUNT(*) AS NumOfPhones FROM Customer1NF c, Phone1NF p WHERE c.Id = p.CID --đếm tổng số phone = 6
SELECT COUNT(*) AS NumOfPhones FROM Phone1NF --TƯƠNG ĐƯƠNG 6 LUÔN 
	--CÁCH VIẾT TRÊN, ÉO CHIA NHÓM MÀ ĐẾM, ĐẾM SẠCH TABLE CÓ GÌ, TABLE 1 NHÓM 
	
	-- MỖI K/H CÓ BN SỐ PHONE, MỖI - CHIA NHÓM K/H RA MÀ ĐẾM
	--							    CHIA THEO ID K/H MÀ ĐẾM 
	-- CHIA NHÓM MÀ ĐẾM GỌI LÀ GROUP BY 
SELECT CID, COUNT(*) AS NumOfPhones FROM Phone1NF GROUP BY CID 
/*
CID		NumOfPhones
C1        	3
C2        	2
C3        	1
*/
--	GHI CHÚ SIÊU QUAN TRỌNG 
--		KHI XÀI CÁC HÀM AGG THÌ NẾU BÊN MỆNH ĐỀ SELECT CÓ CỘT NÀO XUẤT HIỆN VÀ KO NẰM TRONG HÀM 
--		thì thì thì thì CỘT ĐÓ BẮT BUỘC PHẢI XUẤT HIỆN TRONG MỆNH ĐỀ GROUP BY 

SELECT c.Id, COUNT(*) AS [No Phones] FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID GROUP BY c.Id
/*
CID		No Phones
C1        	3
C2        	2
C3        	1
C4        	1
*/
SELECT c.Id, COUNT(p.PhoneNumber) AS [No Phones] FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID GROUP BY c.Id
/*
CID		No Phones
C1        	3
C2        	2
C3        	1
C4        	0
*/

--	GHI CHÚ SIÊU QUAN TRỌNG TIẾP THEO 
--		 FILTER, LỌC LẠI SAU KHI GOM NHÓM, WHERE SAU GOM NHÓM 
--										   KHÁC VỚI WHERE KHI ĐANG GOM NHÓM 
--4. Hãy đếm số phone của kh 1 và 2 
	-- WHERE RỒI ĐẾM, LẤY RA ĐC 2 KH RỒI ĐẾM 
SELECT c.Id, COUNT(p.PhoneNumber) AS [No Phones] FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID 
WHERE c.Id = 'C1' OR c.Id = 'C2' GROUP BY c.Id 
	--ĐẾM XONG MỚI WHERE 
SELECT c.Id, COUNT(p.PhoneNumber) AS [No Phones] FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID 
GROUP BY c.Id HAVING c.Id = 'C1' OR c.Id = 'C2'

--5. Liệt kê dùm tui trong các k/h c1, c2, k/h nào có từ 3 phone trở lên 
--ĐẾM XONG CÁI ĐÃ, RỒI FILTER LẠI, GOM XONG TỒI MỚI WHERE, FILTER
--KO ĐC DÙNG 2 TỪ WHERE, FILTER SAU GOM -> HAVING 

SELECT p.CID, COUNT(*) FROM Phone1NF p WHERE p.CID IN ('C1', 'C2')
GROUP BY P.CID  HAVING COUNT(p.PhoneNumber) > 2

SELECT c.Id, COUNT(p.PhoneNumber) AS [No Phones] FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID 
WHERE c.Id = 'C1' OR c.Id = 'C2' GROUP BY c.Id  
HAVING COUNT(p.PhoneNumber) > 2

--tui mún in luôn cả mã k/h, tên k/h
--phải join với cust, group by thêm do hiển thị thêm cột ngoài cột đếm 
--GOM THEO MÃ K/H + TÊN K/H 
SELECT c.Id, c.FirstName + ' ' + c.LastName AS FullName, COUNT(p.PhoneNumber) AS [No Phones] FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID 
GROUP BY c.Id, c.FirstName, c.LastName

SELECT c.Id, c.FirstName + ' ' + c.LastName AS FullName, COUNT(p.PhoneNumber) AS [No Phones] FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID 
GROUP BY c.Id, c.FirstName, c.LastName --RA FULLNAME NULL HẾT VÌ NULL + NULL = NULL
/*
ID		   FullName	  No Phones 	
C1        	NULL		3
C2        	NULL		2
C3        	NULL		1
C4        	NULL		0
*/
UPDATE Customer1NF SET FirstName = N'C Một' WHERE Id = 'C1'
UPDATE Customer1NF SET FirstName = N'C Hai' WHERE Id = 'C2'
UPDATE Customer1NF SET FirstName = N'C Ba' WHERE Id = 'C3'
UPDATE Customer1NF SET FirstName = N'C Bốn' WHERE Id = 'C4'

SELECT * FROM Customer1NF
SELECT c.Id, c.FirstName + ' ' + c.LastName AS FullName, COUNT(p.PhoneNumber) AS [No Phones] FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID 
GROUP BY c.Id, c.FirstName, c.LastName --CŨNG RA FULLNAME NULL HẾT VÌ NULL + BẤT KÌ = NULL  _^_
									   -- muốn ko null thì phải sửa cả lastname nữa 

--6. Liệt các số di động của tất cả các khách hàng 
SELECT * FROM Phone1NF
UPDATE Phone1NF SET PTID = 'DD' WHERE Seq = '26'

SELECT * FROM Phone1NF WHERE PTID = 'DD'
SELECT c.Id, c.FirstName, p.PhoneNumber, p.PTID FROM Customer1NF c, Phone1NF p WHERE c.Id = p.CID AND p.PTID = 'DD'
SELECT c.Id, c.FirstName, p.PhoneNumber, p.PTID FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID WHERE p.PTID = 'DD'

--cho 9 điểm, điểm 10 phải là where 'Di động' kìa, nay đang where mã DD 
--JOIN 3 BẢNG 
SELECT c.Id, c.FirstName, p.PhoneNumber, t.* FROM Customer1NF c LEFT JOIN Phone1NF p ON c.Id = p.CID 
FULL JOIN PhoneType1NF t ON t.PhoneTypeID = p.PTID
WHERE t.PhoneDesc = N'Di động'
WHERE t.PhoneDesc = 'Di động' --NIỆM DO THIẾU N 

SELECT c.Id, c.FirstName, p.PhoneNumber, t.* FROM Customer1NF c JOIN Phone1NF p ON c.Id = p.CID 
JOIN PhoneType1NF t ON t.PhoneTypeID = p.PTID
WHERE p.PTID = (SELECT t.PhoneTypeID FROM PhoneType1NF t WHERE t.PhoneDesc = N'Di động')

SELECT c.Id, c.FirstName, p.PhoneNumber, t.* FROM Customer1NF c JOIN Phone1NF p ON c.Id = p.CID 
JOIN PhoneType1NF t ON t.PhoneTypeID = p.PTID
WHERE p.PTID IN (SELECT t.PhoneTypeID FROM PhoneType1NF t WHERE t.PhoneDesc = N'Di động' OR t.PhoneDesc = N'Để bàn nhà')

------------------------------------ END OF 1NF ----------------------------------------
/*  CHUẨN 2NF, CHUẨN 3NF, CHUẨN BCNF, CHUẨN 4, CHUẨN 5, CHUẨN 6 ĐỀU DỰA TRÊN 
	1 NGUYÊN TẮC: KO MUỐN THẤY, KO MUỐN XUẤT HIỆN TRONG TABLE CHỨA THÔNG TIN 
	CỦA TABLE KHÁC
					BẠN ĐANG CÓ Ý ĐỊNH GỘP VÀI TABLE TRONG 1 TABLE
    CHUẨN 2 3 BCNF... GIÚP HẠN CHẾ VIỆC GỘP TABLE TRONG 1 TABLE
	VIỆC UPDATE DATA SẼ BỊ KHỐN NẠN KHI CÓ VÀI TABLE TRONG 1 TABLE 
	OOP: TRONG 1 OBJECT CÓ CHỨA NHIỀU OBJECT KHÁC (OOP THAM CHIẾU, TÁCH CLASS RỒI)
												  (CSDL GỘP LÀ VI PHẠM CHUẨN)
												  (TÁCH BẢNG MỚI TỐT ~ THAM CHIẾU)
	
	TRIẾT LÍ THIẾT KẾ TABLE: MỖI TABLE CHỈ NÊN LÀ LIÊN QUAN INFO CỦA 1 NHÓM 
	ĐỐI TƯỢNG CÙNG KIỂU, KO GOM THÔNG TIN LẠ VÀO, LẠ -> TÁCH BẢNG 

	NÂNG DẠNG CHUẨN CHẲNG QUA LÀ TÁCH BẢNG, TÁCH NHỮNG CỘT KO PHÙ HỢP RA BẢNG KHÁC 
	TÁCH BẢNG GỌI LÀ: DECOMPOSITION 
	TÁCH THÌ LẠI PHẢI JOIN, REFERENCES KHÓA NGOẠI 

	VD VIỆC GỘP BẢNG TRONG 1 BẢNG
	Lưu trữ HSSV 
	chưa đạt chuẩn 3, chứa phụ thuộc bắc cầu 
	| ID |Name|Address|...|MajorID|MajorName|
	 SE1	.....			SE		KTPM
	 SE2	.....			SE		Software Engineering 
	 SE3	.....			IB		International ...


class Student {
	String id,
	Major major 
}
class Major{
	String id, 
	String name
}
							FK 
	 |ID |Name|Address|...|MajorID|
	  SE1	.....			SE		
	  SE2	.....			SE		
	 |MajorID|MajorName|
	  SE		Software Engineering 
	  IB		International ...
*/