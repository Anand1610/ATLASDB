-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPortfolio_By_UserId] 
	@i_a_UserId int,
	@s_a_DomainId Varchar(50)
AS
BEGIN
	Declare @s_a_UserType varchar(10);
	SET NOCOUNT ON;

	 Select @s_a_UserType = LTRIM(RTRIM(UserType)) from IssueTracker_Users(NOLOCK) where userid = @i_a_UserId

	 IF(@s_a_UserType = 'I')
	 BEGIN
	  SELECT '0' as ID,' ---Select Portfolio--- ' as Name
	  UNION
      Select Id,Name from  [dbo].[tbl_portfolio](NOLOCK) where DomainId=@s_a_DomainId and 
	  Id in (Select PortfolioId from tbl_InvestorPortfolio(NOLOCK) where InvestorId in (select InvestorId from tbl_Investor(NOLOCK) where userid = @i_a_UserId))
	 END
	 ELSE
	 BEGIN
	  SELECT '0' as ID,' ---Select Portfolio--- ' as Name
	  UNION
      Select Id,Name from  [dbo].[tbl_portfolio](NOLOCK) where DomainId=@s_a_DomainId
	 END

END
