create database BookLibrary
go
use BookLibrary
go

create table Books (
BookID int primary key ,
Title nvarchar(200),
Author nvarchar(100),
ISBN varchar(50),
Image varchar(150),
Summary nvarchar(300)
)

create table Users (
UserID varchar(20) primary key,
FullName nvarchar(100),
Email varchar(30),
Address nvarchar(200)
)

create table Loans(
LoanID int primary key,
UserID varchar(20) ,
BookID int,
DueDate datetime,
Creatd datetime,
Modified datetime
constraint fk_Loans foreign key (UserID) references Users(UserID),
constraint fk_book_Loans foreign key (BookID) references Books(BookID)
)


insert into Books values 
(001,'Kinh Dien Ve Khoi Nghiep','Bill Aulet','A111','KDVKN','24 buoc khoi su kinh doanh thanh cong'),
(002,'Tri tue Do Thai','Eran Katz','A112','TTDT','Nguoi Do Thai sang tao'),
(003,'Chi Pheo','Nam Cao','A113','CP','tai hien buc tranh chan thuc nong thon Viet Nam truoc 1945'),
(004,'Khong Gia Dinh','Hector Malot','A114','KGD','Ke ve 1 cau be khong cha me bi bo roi')

insert into Users values
(101,'Anh','anh1234@gamil.com','Ha Dong,Ha Noi'),
(102,'Duy','duy1234@gmail.com','Yen Phong,Bac Ninh'),
(103,'Lan','lan1234@gmail.com','Dong Da,Ha Noi'),
(104,'Minh','minh1234@gmail.com','Phu Luong,Thai Nguyen')

insert into Loans values
(3000,'101','001','20220105','20211220','20220101'),
(4000,'102','002','20220104','20220110','20220106'),
(3500,'103','003','20220114','20211231','20220106'),
(2000,'104','004','20220116','20211220','20220106')
--cau 2
alter table Books
add constraint UQ_Books_ISBN UNIQUE(ISBN)
--cau 4
select Title from Books where Title like 'M'+'%'
--c5
create index  IX_Book_Info on Books(Title)
--c6
create view  View_DueDate as
select Users.UserID,FullName,Email,Address,Duedate from Users
join Loans on Users.UserID=Loans.UserID where DueDate>'20220110'
--c7
create view View_TopLoan as	
select Books.BookID,Title,ISBN,Loans.LoanID from Loans 
join Books on Loans.BookID=Books.BookID

select  count(LoanID),BookID
from View_TopLoan
group by BookID order by  count(LoanID) desc
--c8
if OBJECT_ID('sp_BookAuthor') is not null
drop procedure sp_BookAuthor;
go
create proc sp_BookAuthor (@name nvarchar (100))
as
    begin 
	if(exists(select * from Books where Author=@name))
	select Title,ISBN,Image,Summary from Books 
	end;

exec sp_BookAuthor 'Nam Cao'
