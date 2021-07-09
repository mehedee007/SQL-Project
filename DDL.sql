USE master
GO
Drop Database IDB_Scholarship_Project
DECLARE @syspath nvarchar(256);
SET @syspath = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
      FROM master.sys.master_files
      WHERE database_id = 1 AND file_id = 1);
EXECUTE ('CREATE DATABASE IDB_Scholarship_Project
ON PRIMARY(NAME = IDB_Scholarship_Project_data, FILENAME = ''' + @syspath + 'IDB_Scholarship_Project_data.mdf'', SIZE = 30MB, MAXSIZE = Unlimited, FILEGROWTH = 5%)
LOG ON (NAME = IDB_Scholarship_Project_log, FILENAME = ''' + @syspath + 'IDB_Scholarship_Project_log.ldf'', SIZE = 15MB, MAXSIZE = 200MB, FILEGROWTH = 2MB)'
);
GO







---- (Create Database)
--USE master
--IF DB_ID ('IDB_Scholarship_Project') IS NOT NULL
--DROP DATABASE IDB_Scholarship_Project
--CREATE DATABASE IDB_Scholarship_Project
--GO
USE IDB_Scholarship_Project
GO

-- (Create Table)
DROP TABLE IF EXISTS CourseDetails
Create TABLE CourseDetails
(
CourseID INT PRIMARY KEY IDENTITY,
CourseName NVARCHAR (40) NOT NULL,
Duration NVARCHAR (30),
seatavailability Int,
Demand NVARCHAR (3)
);
GO

--------------------Alter Table


Alter Table CourseDetails
Alter Column Demand Varchar
Go
Alter Table CourseDetails
Drop column Demand
Go






Select * From CourseDetails

CREATE TABLE TSP
(
TSPID INT PRIMARY KEY IDENTITY (101, 1),
TSPName NVARCHAR (MAX),
TSPLocation NVARCHAR (200),
Manager NVARCHAR (50) SPARSE NULL,
ContactNumber VARCHAR (15) ,
Email VARCHAR (30) ,
);
GO



CREATE TABLE TrainerList
(
TrainerID INT PRIMARY KEY IDENTITY (201, 1),
TrainerName NVARCHAR (50) NOT NULL,
TrainerContact VARCHAR (15),
TrainerEmail VARCHAR (60) 
);
GO



-----Create Index

Create Nonclustered Index ixEmail
On Trainerlist(TrainerID)
Go

-----------CREATE SEQUENCE

CREATE SEQUENCE sq_Trainee
START WITH 127500
INCREMENT BY 1
MINVALUE 127500
MAXVALUE 999999
NO CYCLE;
GO



Create TABLE Trainees
(
TraineeID INT PRIMARY KEY,-- Sequence
TraineeFName NVARCHAR (50) NOT NULL,
TraineeLName NVARCHAR (50) SPARSE NULL,
TraineeContact VARCHAR (15) CHECK (TraineeContact LIKE '016%' OR TraineeContact LIKE '019%'OR TraineeContact LIKE '015%' OR TraineeContact LIKE '018%'),
Email VARCHAR (30) CHECK (Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
IdentifierContact VARCHAR (15) SPARSE NULL
);
GO


Create TABLE EnrollmentInfo
(
AdmissionSerial INT IDENTITY (20201,1) PRIMARY KEY,
CourseID INT FOREIGN KEY REFERENCES CourseDetails (CourseID) ,
TrainerID INT FOREIGN KEY REFERENCES TrainerList (TrainerID) ON UPDATE CASCADE,
TSPID INT FOREIGN KEY REFERENCES TSP (TSPID),
TraineeID  INT UNIQUE FOREIGN KEY REFERENCES Trainees (TraineeID) ON UPDATE CASCADE ,
StartDate DATETIME DEFAULT SYSDATETIME ()
);
GO
---------Create store procedure for insert/update/delete/Error handling/input peramiter/output peramiter/Transaction/Rollback/If/Else etc
Create PROC SP_EnrollmentInfo
@AdmissionSerial INT,
@CourseID INT,
@TrainerID INT,
@TSPID INT,
@TraineeID  INT,
--@StartDate DATETIME,
@operation VARCHAR(10),
@message VARCHAR (150) Output
As
Begin
Set NoCount On
    Begin Try

    Begin Transaction
		If (@operation='Insert')
		Begin
		Insert into EnrollmentInfo (CourseID,TrainerID,TSPID,TraineeID)
		Values(@CourseID,@TrainerID,@TSPID,@TraineeID)
		End

		If (@operation='Update')
		Begin
		Update EnrollmentInfo Set CourseID=@CourseID,TrainerID=@TrainerID,TSPID=@TSPID,TraineeID=@TraineeID
		Where AdmissionSerial=@AdmissionSerial
		End

		If (@operation='Delete')
		Begin
		Delete From EnrollmentInfo 
		Where AdmissionSerial=@AdmissionSerial
		End
		Set @message='Your information has been recorded,Thanks stay with us'
		
	    Commit Transaction
   End Try
    Begin Catch
    RollBack Transaction
   Select
	  
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
    End Catch
End
Go

Select * from CourseDetails
select * from TrainerList
Select * from TSP
Select * from Trainees







--create Function (tabular) /join
Select * from EnrollmentInfo
Go
Create Function fn_GetInfo 
(@traineeid int)
Returns table
As

Return(Select TraineeFName,TraineeContact,CourseName,TSPName,TSPLocation
		From Trainees
		Join EnrollmentInfo
		On Trainees.TraineeID=Enrollmentinfo.TraineeID
		Join TSP
		on TSP.TSPId=Enrollmentinfo.TSPid
		Join CourseDetails
		on CourseDetails.CourseID=Enrollmentinfo.CourseID
		Where trainees.TraineeID=@traineeid)
Go

Select * From dbo.fn_GetInfo(127500)
Go
-----------------------Scaler Function/Aggreget function
Create FUNCTION fn_CourseName
(
@Coursname VarChar (15)
)
RETURNS int
AS
BEGIN

    RETURN (Select count(CourseName)
From Trainees
		Join EnrollmentInfo
		On Trainees.TraineeID=Enrollmentinfo.TraineeID
		Join TSP
		on TSP.TSPId=Enrollmentinfo.TSPid
		Join CourseDetails
		on CourseDetails.CourseID=Enrollmentinfo.CourseID
		Where @Coursname=CourseName)
END
Go
Print dbo.fn_CourseName('C#')
Go
---------
Create VIEW vw_Trainee
With Encryption 
AS
    Select TraineeFName,TraineeContact,CourseName,TSPName,TSPLocation
		From Trainees
		Join EnrollmentInfo
		On Trainees.TraineeID=Enrollmentinfo.TraineeID
		Join TSP
		on TSP.TSPId=Enrollmentinfo.TSPid
		Join CourseDetails
		on CourseDetails.CourseID=Enrollmentinfo.CourseID
Go

Select * from dbo.vw_Trainee
Go
--------------Create Schema
Create schema Cu
Go
Drop Schema Cu
Go

-----------------Create Table for Trigger---------
Create Table Audit
(
Audit Int identity,
ActionType VarChar (100),
ActionTime datetime
)
Go
--------------Create Trigger For Insert----

Go
Create Trigger tri_AfterInsert on dbo.trainerlist
For Insert 
As
Declare
@TrainerID INT,
@TrainerName NVARCHAR (50) ,
@TrainerContact VARCHAR (15),
@TrainerEmail VARCHAR (60),
@actiontype varchar (100),
@actiontime datetime

Select @TrainerID=i.TrainerID From Inserted i
Select @TrainerName=i.TrainerName From Inserted i
Select @TrainerContact=i.TrainerContact From Inserted i
Select @TrainerEmail=i.TrainerEmail From Inserted i
Set @actiontype='Inserted Successfull....After Insert trigger Fired'

Insert into Audit(ActionType,ActionTime)
Values (@actiontype,Getdate())
Go

Insert into dbo.trainerlist Values ('Minu','01823 000 724', 'Minu@gmail.com')

--------------Create Trigger For update----
Go
Create Trigger tri_AfterUpdate on dbo.trainerlist
For update
As
Declare
@TrainerID INT,
@TrainerName NVARCHAR (50) ,
@TrainerContact VARCHAR (15),
@TrainerEmail VARCHAR (60),
@actiontype varchar (100),
@actiontime datetime

Select @TrainerID=i.TrainerID From Inserted i
Select @TrainerName=i.TrainerName From Inserted i
Select @TrainerContact=i.TrainerContact From Inserted i
Select @TrainerEmail=i.TrainerEmail From Inserted i
Set @actiontype='Updated Successfull....After Update trigger Fired'

Insert into Audit(ActionType,ActionTime)
Values (@actiontype,Getdate())
Go

--------------------Create Trigger For Delete----

Go
Create Trigger tri_Afterdelet on dbo.trainerlist
For Delete
As
Declare
@TrainerID INT,
@TrainerName NVARCHAR (50) ,
@TrainerContact VARCHAR (15),
@TrainerEmail VARCHAR (60),
@actiontype varchar (100),
@actiontime datetime

Select @TrainerID=d.TrainerID From deleted d
Select @TrainerName=d.TrainerName From deleted d
Select @TrainerContact=d.TrainerContact From deleted d
Select @TrainerEmail=d.TrainerEmail From deleted d
Set @actiontype='Deleted Successfull....After Deleted trigger Fired'

Insert into Audit(ActionType,ActionTime)
Values (@actiontype,Getdate())
Go

-----------Create Trigger Instead of Insert
Create Trigger tri_InsteadOfInsert on dbo.CourseDetails
Instead Of Insert
AS
Declare
@CourseID INT ,
@CourseName NVARCHAR (40) ,
@Duration NVARCHAR (30),
@seatavailability Int,
@actiontype varchar (100),
@actiontime datetime

Select @CourseID=i.CourseID From Inserted i
Select @CourseName=i.CourseName From Inserted i
Select @Duration=i.Duration From Inserted i
Select @seatavailability=i.seatavailability From Inserted i
Set @actiontype='Inserted Successfull....Insted of Insert  trigger Fired'


Begin
	Begin tran
	If (@seatavailability>100)
		Begin
		Raiserror ('Seat must be  Must Be >=10',16,1)
		Rollback
		End
	Else
		Begin
		Insert Into CourseDetails(CourseName,Duration,seatavailability) 
		values (@CourseName,@Duration,@seatavailability)

		Insert into Audit(ActionType,ActionTime)
		  Values (@actiontype,Getdate())

		End
	Commit tran

End
Go
-------------------------update
Create Trigger tri_InsteadOfUpdate on dbo.CourseDetails
Instead Of Update
AS
Declare
@CourseID INT ,
@CourseName NVARCHAR (40) ,
@Duration NVARCHAR (30),
@seatavailability Int,
@actiontype varchar (100),
@actiontime datetime

Select @CourseID=i.CourseID From Inserted i
Select @CourseName=i.CourseName From Inserted i
Select @Duration=i.Duration From Inserted i
Select @seatavailability=i.seatavailability From Inserted i
Set @actiontype='updated Successfull....Insted of Update  trigger Fired'


Begin
	Begin tran
	If (@seatavailability<10)
		Begin
		Raiserror ('Seat must be  Must Be >=10',16,1)
		Rollback
		End
	Else
		Begin
		Update CourseDetails set CourseName=@CourseName,Duration=@Duration,seatavailability=@seatavailability 
		Where CourseID=@CourseID

		Insert into Audit(ActionType,ActionTime)
		Values (@actiontype,Getdate())

		End
	Commit tran

End
Go

Create Trigger tri_InsteadOfDelete on dbo.CourseDetails
Instead Of Delete
AS
Declare
@CourseID INT ,
@CourseName NVARCHAR (40) ,
@Duration NVARCHAR (30),
@seatavailability Int,
@actiontype varchar (100),
@actiontime datetime

Select @CourseID=D.CourseID From deleted D
Select @CourseName=D.CourseName From deleted D
Select @Duration=D.Duration From deleted D
Select @seatavailability=D.seatavailability From deleted D
Set @actiontype='Deleted Successfull....Insted of Deleted  trigger Fired'


Begin
	Begin tran
	If (@seatavailability<50)
		Begin
		Raiserror ('Seat must be  Must Be >=50',16,1)
		Rollback
		End
	Else
		Begin
		Delete From  CourseDetails 
		Where CourseID=@CourseID

		Insert into Audit(ActionType,ActionTime)
		Values (@actiontype,Getdate())

		End
	Commit tran

End
Go

--Select * from CourseDetails
--Delete from CourseDetails
--Where CourseID=1









