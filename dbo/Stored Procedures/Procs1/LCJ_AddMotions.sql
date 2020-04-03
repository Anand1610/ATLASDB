CREATE PROCEDURE [dbo].[LCJ_AddMotions]
(
			@DomainId NVARCHAR(50),
			@Case_Id nvarchar(100),
			@Motion_Date DATETIME,
			@Motion_Status varchar(30),
			@Our_Motion_Type varchar(100),
			@Defendent_Motion_Type varchar(100),
			@Opposition_Due_Date DATETIME,
			@Reply_Due_Date DATETIME,
			@cross_motion char(10),
			@whose_motion nvarchar(10),
			@room nvarchar(50),
			@part nvarchar(50),
			@judge_name nvarchar(50),
			@time_duration varchar(50),
			@Notes varchar(200)


)
AS
BEGIN
	
	BEGIN


		
			
		INSERT INTO tblMotions 
		(
			DomainId,
			Case_Id,
			Motion_Date,
			Motion_Status,
			Our_Motion_Type,
			Defendent_Motion_Type,
			Opposition_Due_Date,
			Reply_Due_Date,
			cross_motion,
			whose_motion,
			room,
			part,
			judge_name,
			time_duration,
			Notes

		)

		VALUES(
			@DomainId,
			@Case_Id,
			Convert(nvarchar(15), @Motion_Date, 101),
			@Motion_Status,			
			@Our_Motion_Type,
			@Defendent_Motion_Type,
			Convert(nvarchar(15), @Opposition_Due_Date, 101),
			Convert(nvarchar(15), @Reply_Due_Date, 101),
			@cross_motion,
			@whose_motion,
			@room,
			@part,
			@judge_name,
			Convert(nvarchar(15), @time_duration, 101),
			@Notes
		)					

		

	END -- END of ELSE	

END

