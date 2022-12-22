/*
	Thiết kế ERD và DDL (SQL Server) để lưu trữ thông tin về 
	các seminar, buổi giảng phụ đạo của các thầy cô bên bộ môn SE. 

	Mỗi giảng viên có thể tổ chức nhiều seminar/buổi phụ đạo khác nhau  
	mỗi seminar/buổi phụ đạo chỉ do một giảng viên phụ trách  
    Thông tin lưu trữ bao gồm: mã số giảng viên, tên giảng viên, email, phone, 
							   bộ môn (SE, CF, ITS, Incubator), ngày giờ seminar/phụ đạo, 
							   loại hình tổ chức (seminar, phụ đạo, workshop), chủ đề, 
							   tóm tắt nội dung, phòng học (nếu tiến hành offline), 
							   online-link (nếu tiến hành online), sĩ số dự kiến
*/
-- CHIẾN LƯỢC: GOM 1 BẢNG
-- XEM: ĐA TRỊ, COMPOSITE, LOOKUP, LẶP LẠI TRÊN 1 NHÓM CỘT
--		TÁCH THÊM DÒNG TỐT HƠN THÊM CỘT KHI CẦN THÊM DATA)

CREATE DATABASE DBDESIGN_ACTIVITIES 
USE DBDESIGN_ACTIVITIES

CREATE TABLE ACTIVITY_V1
(
	Lect ID char(8),
	LectName nvarchar(30), --composite, tách nếu mún sort 
	Email varchar(50),
	Phone char(11),
	Major varchar(30),
	StartDate datetime, --ngày giờ
	ActType nvarchar(30), --workshop, seminar, phụ đạo 
	Topic nvarchar(30), --Giới thiệu về ArrayList 
	Intro nvarchar(250),
	Room nvarchar(50), --lưu hyperlink của Zoom, Meet, phòng 
	Seats int
)
SELECT * FROM ACTIVITY_V1

INSERT INTO ACTIVITY_V1 VALUES
	('00000001', N'HÒA.ĐNT', 'hoadnt@', '090x', 'CF', '2021-11-3', 'Seminar',
	  N'Nhập môn Machine Learning', N'...', N'Phòng seminar Thư viện ĐH FPT HCM', 100 )
INSERT INTO ACTIVITY_V1 VALUES
	('00000001', N'HÒA.ĐNT', 'hoadnt@', '090x', 'CF', '2021-11-3', 'seminar',
	  N'Giới thiệu về YOLO V4', N'...', N'Phòng seminar Thư viện ĐH FPT HCM', 100 )
INSERT INTO ACTIVITY_V1 VALUES
	('00000001', N'HÒA.ĐNT', 'hoadnt@', '090x', 'CF', '2021-12-3 08:00:00', 'Worhshop',
	  N'Giới thiệu về YOLO V4 (part 2)', N'...', N'Phòng seminar Thư viện FUHCM', 100 )

/* Bảng V1
LectID	   LectName Email	Phone	  Major			StartDate		ActType				Topic					Intro				Room					Seats
00000001	HÒA.ĐNT	hoadnt@	090x       	CF	2021-11-03 00:00:00.000	Seminar		Nhập môn Machine Learning		...		Phòng seminar Thư viện ĐH FPT HCM	100
00000001	HÒA.ĐNT	hoadnt@	090x       	CF	2021-11-03 00:00:00.000	seminar		Giới thiệu về YOLO V4			...		Phòng seminar Thư viện ĐH FPT HCM	100
00000001	HÒA.ĐNT	hoadnt@	090x       	CF	2021-12-03 08:00:00.000	Worhshop	Giới thiệu về YOLO V4 (part 2)	...		Phòng seminar Thư viện FUHCM		100
*/

CREATE TABLE LECTURER_V2
(
	LectID char(8) PRIMARY KEY,
	LectName nvarchar(30), 
	Email varchar(50),
	Phone char(11),
	Major varchar(30),
)
CREATE TABLE ACTIVITY_V2
(
	SEQ int IDENTITY PRIMARY KEY,
	StartDate datetime, --ngày giờ
	ActType nvarchar(30), --workshop, seminar, phụ đạo, coi chừng gõ WORKSHOP ko ai cấm gõ Training 
						  --mùi của LOOKUP 
	Topic nvarchar(30), --Giới thiệu về ArrayList 
	Intro nvarchar(250),
	Room nvarchar(50), --lưu hyperlink của Zoom, Meet, phòng 
	Seats int,

	--vì tách bảng rồi nên phải có FK 
	LectID char(8) REFERENCES Lecturer_V2(LectID)
)
SELECT * FROM ACTIVITY_V2
SELECT * FROM LECTURER_V2

INSERT INTO LECTURER_V2 
	VALUES ('00000001', N'HÒA.ĐNT', 'hoadnt@', '090x', 'CF')

INSERT INTO ACTIVITY_V2 VALUES
	('2021-11-3 08:30:00', 'Seminar',
	  N'Nhập môn Machine Learning', N'...', N'Phòng seminar Thư viện ĐH FPT HCM', 100,'00000001')
INSERT INTO ACTIVITY_V2 VALUES
	('2021-11-3', 'seminar',
	  N'Giới thiệu về YOLO V4', N'...', N'Phòng seminar Thư viện ĐH FPT HCM', 100,'00000001')
INSERT INTO ACTIVITY_V2 VALUES
	('2021-12-3 08:00:00', 'Worhshop',
	  N'Giới thiệu về YOLO V4 (part 2)', N'...', N'Phòng seminar Thư viện FUHCM', 100,'00000001')


/*Bảng V2 
LectID		LectName	Email		Phone		Major 
00000001	HÒA.ĐNT		hoadnt@		090x       	CF

SEQ			StartDate		ActType				Topic				   Intro				Room					Seats
1	2021-11-03 08:30:00.000	Seminar		Nhập môn Machine Learning		...	Phòng seminar Thư viện ĐH FPT HCM	100	00000001
2	2021-11-03 00:00:00.000	seminar		Giới thiệu về YOLO V4			...	Phòng seminar Thư viện ĐH FPT HCM	100	00000001
3	2021-12-03 08:00:00.000	Worhshop	Giới thiệu về YOLO V4 (part 2)	...	Phòng seminar Thư viện FUHCM		100	00000001

*/