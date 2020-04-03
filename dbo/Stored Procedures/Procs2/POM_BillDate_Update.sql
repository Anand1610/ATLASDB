-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[POM_BillDate_Update] 
	-- Add the parameters for the stored procedure here
	@DomainID nvarchar(500),
	@s_a_POMID INT,
	@s_a_Bill_Date DATETIME,
	@s_a_POM_Type VARCHAR(50),
	@s_a_UserName NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @i_l_result INT
	DECLARE @s_l_message VARCHAR(500)
	DECLARE @DESC VARCHAR(200)

    -- Insert statements for procedure here
	UPDATE TBLPOM 
	SET
	POM_Date_Bill_Send=@s_a_Bill_Date
	WHERE 
	DomainId=@DomainID
	AND POM_ID_new=@s_a_POMID

	IF @s_a_POM_Type = 'POM'
	BEGIN
		UPDATE tblTreatment 
		SET Date_BillSent=@s_a_Bill_Date
		WHERE DomainId=@DomainID
		AND Case_Id iN (Select tblPomCase.case_id from tblPomCase (NOLOCK)
						INNER JOIN tblPom ON tblPomCase.pom_id=tblPom.POM_ID_new
						WHERE tblPom.pom_id = @s_a_POMID and tblPom.DomainId = @DomainID)
	END
	
	SET @DESC='Date Bill Sent changed to '+CONVERT(VARCHAR, @s_a_Bill_Date, 120)  + ' for POM ID ='+ CONVERT(VARCHAR, @s_a_POMID, 120) 

	--exec LCJ_AddNotes @DomainId= @DomainId, @case_id='',@Notes_Type='Activity',@Ndesc = @DESC,@user_Id=@s_a_UserName,@ApplyToGroup = 0 

	SET @s_l_message	=  'Data Updated successfully'
	SET @i_l_result		=  0

	SELECT @s_l_message AS [Message], @i_l_result AS [RESULT]
END
