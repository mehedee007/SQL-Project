use IDB_Scholarship_Project
Go
-------insert into Coursedetails
insert Into Coursedetails Values
('C#','13Month',30),
								('WDPF','12month',30),
								('GAVE','9month',40),
								('NT','10month',30),
								('DBA','12month',50)
								Select * from Coursedetails
								--Truncate Table Coursedetails
								--Drop Table Coursedetails
----------------------Insert Into TSP

Insert Into TSP Values  ('Macro','Wasa','Aminul','01825363630','aminul@gmail.com'),
						('Daffodil','Agrabad','Shorab','01735063630','Shorab@gmail.com'),
						('NVIT','Muradpur','Azizul','01953233637','azizul@gmail.com'),
						('ZTE','Golpahar','Mohiuddin','01825363722','mohiuddin@gmail.com'),
						('EDUNAS','Sitakunda','Rasel','01825363642','rasel@gmail.com')

------------Insert TrainerList
						
Insert TrainerList Values('Miraj','01575 323 323', 'miraz@gmail.com'),
('Foysal','01932 578 320', 'foysal@gmail.com'),
('Wahid','01575 329 573', 'wahid@gmail.com'),
('Akram','01775 323 932', 'akram@gmail.com'),
('Amin','01823 000 723', 'amin@gmail.com')


------------Insert into Trainees-----------

Insert into Trainees values (Next Value For sq_Trainee,'Mehedee','Hasan','01535 905 856','mehedee@gmail.com', '01535 905 857' )
Insert into Trainees values (Next Value For sq_Trainee,'Arosh','Pradhan','01635 905 856','arosh@gmail.com', '01735 905 859' )
Insert into Trainees values (Next Value For sq_Trainee,'Mahadi','Foysal','01835 905 856','magadi@gmail.com', '01735 005 557' )
Insert into Trainees values (Next Value For sq_Trainee,'Iqramul','Hoque','01535 755 223','iqramul@gmail.com', '01535 755 238' )
Insert into Trainees values (Next Value For sq_Trainee,'Moin','Uddin','01535 905 350','moin@gmail.com', '01535 905 258' )
Insert into Trainees values (Next Value For sq_Trainee,'Fahad','Ahmed','01535 328 789','fahad@gmail.com', '01535 357 987' )
Insert into Trainees values (Next Value For sq_Trainee,'Amdad','Ullah','01535 909258','Amdad@gmail.com', '01535 897 235' )
Insert into Trainees values (Next Value For sq_Trainee,'Golam','Sorwar','0165 905 856','golam@gmail.com', '01950 905 857' )
Insert into Trainees values (Next Value For sq_Trainee,'Jasim','Uddin','01835 905 859','jasim@gmail.com', '015300 857 805' )
Insert into Trainees values (Next Value For sq_Trainee,'Kaisar','Hamid','01837 958 7226','kaisar@yahoo.com', '01713 328 857' )
Use IDB_Scholarship_Project
-------------------enrolmentinfo
use IDB_Scholarship_Project
Declare @Outputmessage Varchar (150)
Exec SP_EnrollmentInfo @AdmissionSerial=20201, @CourseID=1,@TrainerID=201,@TSPID=101,@TraineeID=127500,@operation='Insert',@message= @Outputmessage output
Select @Outputmessage
Go
Declare @Outputmessage Varchar (150)
Exec SP_EnrollmentInfo @AdmissionSerial=20202, @CourseID=1,@TrainerID=201,@TSPID=101,@TraineeID=127501,@operation='Insert',@message= @Outputmessage output
Select @Outputmessage
Go
Declare @Outputmessage Varchar (150)
Exec SP_EnrollmentInfo @AdmissionSerial=20203, @CourseID=2,@TrainerID=201,@TSPID=101,@TraineeID=127502,@operation='Insert',@message= @Outputmessage output
Select @Outputmessage
Go
Declare @Outputmessage Varchar (150)
Exec SP_EnrollmentInfo @AdmissionSerial=20204, @CourseID=3,@TrainerID=201,@TSPID=101,@TraineeID=127503,@operation='Insert',@message= @Outputmessage output
Select @Outputmessage
Go
Declare @Outputmessage Varchar (150)
Exec SP_EnrollmentInfo @AdmissionSerial=20205, @CourseID=4,@TrainerID=201,@TSPID=101,@TraineeID=127504,@operation='Insert',@message= @Outputmessage output
Select @Outputmessage
Go
Declare @Outputmessage Varchar (150)
Exec SP_EnrollmentInfo @AdmissionSerial=20206, @CourseID=4,@TrainerID=201,@TSPID=101,@TraineeID=127505,@operation='Insert',@message= @Outputmessage output
Select @Outputmessage
Go
Declare @Outputmessage Varchar (150)
Exec SP_EnrollmentInfo @AdmissionSerial=20207, @CourseID=2,@TrainerID=201,@TSPID=101,@TraineeID=127506,@operation='Insert',@message= @Outputmessage output
Select @Outputmessage
Go
Declare @Outputmessage Varchar (150)
Exec SP_EnrollmentInfo @AdmissionSerial=20208, @CourseID=5,@TrainerID=201,@TSPID=101,@TraineeID=127507,@operation='Insert',@message= @Outputmessage output
Select @Outputmessage

select * from CourseDetails

----------Group by /having/orderby/Aggreget function etc/ join
Select TSPName,count(CourseName)
From Trainees
		Join EnrollmentInfo
		On Trainees.TraineeID=Enrollmentinfo.TraineeID
		Join TSP
		on TSP.TSPId=Enrollmentinfo.TSPid
		Join CourseDetails
		on CourseDetails.CourseID=Enrollmentinfo.CourseID
		Group by TSPName
		having count(CourseName)>2
		Order by TSPName Desc
		Go
--------------Cta


With CTATest As

(
   Select TSPName,count(CourseName) As Totalcourse
From Trainees
		Join EnrollmentInfo
		On Trainees.TraineeID=Enrollmentinfo.TraineeID
		Join TSP
		on TSP.TSPId=Enrollmentinfo.TSPid
		Join CourseDetails
		on CourseDetails.CourseID=Enrollmentinfo.CourseID
		Group by TSPName
)
Select * From CTATest

------------------------Case

Select CourseName, Duration, seatavailability,
    Case
        When seatavailability > 30
            Then 'Hard'
        When seatavailability <= 50
            Then 'Easy'
        Else 'Avg'
    End As Stutus
From CourseDetails
Where seatavailability > 15;


-----------------
DROP TABLE IF EXISTS Courseinformation
Create TABLE Courseinformation
(
CourseID INT PRIMARY KEY,
CourseName NVARCHAR (40) NOT NULL,
Duration NVARCHAR (30),
seatavailability Int,

);
GO
Insert into Courseinformation Values(1,'C#','13Month',30),
								(2,'WDPF','12month',30),
								(3,'GAVE','9month',60),
								(4,'NT','10month',30),
								(5,'CDB','12month',50)
Merge into Courseinformation AS TT
using Coursedetails  AS St
on ST.courseId = TT.courseId
when matched 
  then
  Update set
     Coursename= ST.courseId
   
When not matched Then
  Insert (courseId, Coursename)
  Values (ST.courseId, ST.Coursename)
when not matched by source Then
    Delete
    ;
		