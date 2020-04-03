CREATE PROCEDURE [dbo].[Case_Soft_Delete]
	@s_a_DomainId varchar(50),
	@s_a_CaseIds varchar(max),
	@b_a_IsDeleted bit,
	@s_a_UserId varchar(150)
AS
BEGIN
	
	SET NOCOUNT ON;

			 DECLARE @tblSoftDeleteCase AS TABLE
			 (
				CASE_ID VARCHAR(50),
				DomainID VARCHAR(50)
			 )

			 Insert into @tblSoftDeleteCase
			 Select value, @s_a_DomainId From string_split(@s_a_CaseIds,',')

			 Update tblcase 
			 Set IsDeleted = @b_a_IsDeleted
			 Where DomainId = @s_a_DomainId and Case_Id in (Select CASE_ID From @tblSoftDeleteCase)

			 IF @b_a_IsDeleted = 1
			 BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				select 'Case soft deleted', 'Activity', 1, CASE_ID, GETDATE(), @s_a_UserId, DomainID 
				FROM @tblSoftDeleteCase
			 END
			 ELSE
			 BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				select 'Case soft delete reverted', 'Activity', 1, CASE_ID, GETDATE(), @s_a_UserId, DomainID 
				FROM @tblSoftDeleteCase
			 END

END
