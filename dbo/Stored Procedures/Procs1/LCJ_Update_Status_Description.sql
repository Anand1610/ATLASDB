CREATE PROCEDURE [dbo].[LCJ_Update_Status_Description]
(
	@DomainId				nvarchar(50),
	@Status_ID				int,
	@Status_Type			nvarchar(100),
	@Status_Description		nvarchar(100),
	@Status_Hierarchy		int,
	@Final_Status			nvarchar(100),
	@IsActive				nvarchar(10),
	@forum				NVARCHAR(50),
	@FILED_UNFILED NVARCHAR(50),
	@hierarchy_Id				nvarchar(10)
)
AS
BEGIN
	
	BEGIN
		update tblStatus 
		set 
			DomainId=@DomainId,
			Status_Type=@Status_Type,
			Status_Abr=@Status_Type,
			Status_Description = @Status_Description,
			Status_Hierarchy=@Status_Hierarchy,
			Final_Status=@Final_Status,
			IsActive=@IsActive,
			forum=@forum,
			Filed_Unfiled=@FILED_UNFILED,
			hierarchy_Id=@hierarchy_Id
		where Status_ID = @Status_ID
		AND DomainId=@DomainId

	END

END

