-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Case_Search_DataEntryList] 
	-- Add the parameters for the stored procedure here
	@DomainID nvarchar(50),
	@Provider_Id    nvarchar(100),
	@InjuredParty_LastName  nvarchar(200)='',  
    @InjuredParty_FirstName  nvarchar(200)='',
	@Accident_Date  nvarchar(100) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select top 10 Case_Id,InjuredParty_FirstName,InjuredParty_LastName,convert(varchar, Accident_Date, 101) as Accident_Date,Status,Ins_Claim_Number,convert(varchar, DateOfService_Start, 101) as DateOfService_Start,convert(varchar, DateOfService_End, 101) as DateOfService_End,Claim_Amount,Provider_Name
	 from tblcase 
	 inner join tblprovider on tblcase.provider_Id=tblprovider.provider_Id
	where tblcase.DomainId=@DomainID AND tblcase.Provider_Id=@Provider_Id
	AND (convert(varchar, Accident_Date, 101) like '%' + @Accident_Date + '%') 
	AND(@InjuredParty_LastName = '' or InjuredParty_LastName Like '%' + @InjuredParty_LastName + '%' OR InjuredParty_FirstName Like '%' + @InjuredParty_LastName + '%') 
	AND (@InjuredParty_FirstName = '' or InjuredParty_FirstName Like '%' + @InjuredParty_FirstName + '%' OR InjuredParty_LastName Like '%' + @InjuredParty_FirstName + '%') 
	ORDER By DateOfService_Start DESC


END
