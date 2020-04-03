-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LCJ_Get_Existing_Bills] -- [LCJ_Get_Existing_Bills] 'GLF18-100001', 'localhost'
	-- Add the parameters for the stored procedure here
	@Case_Id nvarchar(100),
	@DomainId nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select 0 as Treatment_Id, '---Select---' as Description
	Union
	Select	 Treatment_Id
			, Convert(VARCHAR,DateOfService_Start,101) +' - '+ Convert(VARCHAR,DateOfService_End,101)
			  + ' Claim Amout - ' + CONVERT(VARCHAR,ISNULL(claim_amount,0)) 
			  + ' Bill Number - ' + CONVERT(VARCHAR,ISNULL(BILL_NUMBER,''))  AS Description
			  from tblTreatment 
	where  domainid=@DomainId and case_ID=@Case_Id
END
