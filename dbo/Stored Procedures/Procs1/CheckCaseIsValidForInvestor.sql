
CREATE PROCEDURE [dbo].[CheckCaseIsValidForInvestor]
	@DomainID VARCHAR(50),
	@CaseId VARCHAR(50),
	@UserName VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  DECLARE @INVESTOR_ID AS VARCHAR(100)

create table #Temp(Case_ID varchar(55))
DECLARE Cur CURSOR LOCAL FOR

SELECT  InvestorId FROM tbl_Investor 
WHERE UserId =(SELECT UserId FROM ISSUETRACKER_USERS	WHERE UserName =@UserName and DomainId =@DomainID)

OPEN Cur
FETCH NEXT FROM Cur INTO @INVESTOR_ID

WHILE @@FETCH_STATUS <> -1
BEGIN
insert into #Temp
SELECT CASE_ID FROM TBLCASE 
			WHERE 	CASE_ID =@CaseId and DomainId = @DomainID
			AND PortfolioId in(select PortfolioId from tbl_InvestorPortfolio where InvestorId=@INVESTOR_ID)

FETCH NEXT FROM Cur INTO @INVESTOR_ID
END
CLOSE Cur
DEALLOCATE Cur
select * from #Temp
END
