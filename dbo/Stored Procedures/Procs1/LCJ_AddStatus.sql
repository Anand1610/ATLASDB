CREATE PROCEDURE [dbo].[LCJ_AddStatus]
(

@DomainId				nvarchar(50),
@Status_Type			nvarchar(100),
@Status_Description		nvarchar(100),
@Status_Hierarchy		int,
@Final_Status			nvarchar(100),
@IsActive				nvarchar(10),
@forum				NVARCHAR(50),
@FILED_UNFILED NVARCHAR(50),
@hierarchy_Id			INT


)
AS
BEGIN
	
	BEGIN


		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblStatus 
		(
		DomainId,
		Status_Type,
		Status_Abr,
		Status_Description,
		Status_Hierarchy,
		Final_Status,
		IsActive,
		forum,
	  Filed_Unfiled,
		hierarchy_Id
		)

		VALUES(
		@DomainId,
		@Status_Type,
		@Status_Type,
		@Status_Description,
		@Status_Hierarchy,
		@Final_Status,
		@IsActive,
		@forum,		
		@FILED_UNFILED,	
		@hierarchy_Id	
		)					

		COMMIT TRAN

	END

END

