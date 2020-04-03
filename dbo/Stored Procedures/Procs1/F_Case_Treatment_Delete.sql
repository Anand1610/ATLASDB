CREATE PROCEDURE [dbo].[F_Case_Treatment_Delete]
(
	@i_a_TreatmentId	INT,
	@s_a_UserName		VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @i_l_result					INT
	DECLARE @s_l_message				NVARCHAR(500)
	DECLARE @s_l_Notes VARCHAR(200)
	
	
	DECLARE @s_l_DOS_START VARCHAR(12)
	DECLARE @s_l_DOS_END VARCHAR(12)
	DECLARE @s_l_CASE_ID VARCHAR(50)

	SET @s_l_DOS_START = (SELECT CONVERT(VARCHAR(20),DateOfService_Start,100) from tblTreatment where Treatment_Id =  @i_a_TreatmentId)
	SET @s_l_DOS_END = (SELECT CONVERT(VARCHAR(20),DateOfService_End,100) from tblTreatment where Treatment_Id =  @i_a_TreatmentId)
	SET @s_l_CASE_ID = (SELECT Case_Id from tblTreatment where Treatment_Id = @i_a_TreatmentId)

	SET @s_l_Notes = 'Bill deleted for DOS ' + @s_l_DOS_START + ' - ' + @s_l_DOS_END
	EXEC F_Add_Activity_Notes @s_l_CASE_ID,'Activity',@s_l_Notes,@s_a_UserName,0

	DELETE FROM tblTreatment WHERE Treatment_Id = @i_a_TreatmentId
	DELETE FROM TXN_tblTreatment WHERE Treatment_Id = @i_a_TreatmentId
	DELETE FROM TXN_CASE_Treating_Doctor WHERE Treatment_Id = @i_a_TreatmentId
	DELETE FROM TXN_CASE_PEER_REVIEW_DOCTOR WHERE Treatment_Id = @i_a_TreatmentId
	
	SET @s_l_message	=  'Bills details deleted successfuly'
	SET @i_l_result		=  ''
		

	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

