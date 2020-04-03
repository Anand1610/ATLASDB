CREATE PROCEDURE [dbo].[LCJ_AddTrials]
(

			@Case_Id nvarchar(100),
			@Trial_Date DATETIME,
			@Trial_Status varchar(50),
			@Trial_Result varchar(50),
			@Trial_Type varchar(50),
			@Jury_Selection_Date DATETIME,
			@Judge_Name varchar(50),
			@Court_Cal_Number	varchar(50),
			@Not_Filed_Date DATETIME,
			@receipt_date datetime,
			@service_complete_date datetime,
			@Notes varchar(200)

)
AS
BEGIN

		INSERT INTO tblTrials
		(
			Case_Id,
			Trial_Date,
			Trial_Status,
			Trial_Result,
			Trial_Type,
			Jury_Selection_Date,
			Judge_Name,
			Notes,
			Court_Cal_Number,
			Not_Filed_Date,
			receipt_date,
			service_complete_date

		)

		VALUES(
		
			@Case_Id,
			Convert(nvarchar(15), @Trial_Date, 101),
			@Trial_Status,			
			@Trial_Result,
			@Trial_Type,
			Convert(nvarchar(15), @Jury_Selection_Date, 101),
			@Judge_Name,
			@Notes,
			@Court_Cal_Number,
			Convert(nvarchar(15), @Not_Filed_Date, 101),
			Convert(nvarchar(15), @receipt_date, 101),
			Convert(nvarchar(15), @service_complete_date, 101)

		)					


END

