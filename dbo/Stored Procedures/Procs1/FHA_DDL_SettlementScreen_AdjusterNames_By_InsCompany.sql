-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FHA_DDL_SettlementScreen_AdjusterNames_By_InsCompany]      --[FHA_DDL_SettlementScreen_AdjusterNames_By_InsCompany] 'FH13-160361'
	-- Add the parameters for the stored procedure here
(
	@Case_Id VARCHAR(200)
)
AS
BEGIN
	DECLARE @ins_id INT
	SET NOCOUNT ON;
	
	SELECT @ins_id=InsuranceCompany_Id FROM TBLCASE WHERE Case_Id=@Case_Id
	
	CREATE TABLE #tmpAdjusters
	(Adjuster_Id int,Ins_id int, Adjuster_Name_Details varchar(200))
	
	insert into #tmpAdjusters

		SELECT    lcj.Adjuster_Id,adj.InsuranceCompany_Id, LTRIM(RTRIM(Upper(ISNULL(lcj.Adjuster_Name, '') + ' =>' + '[Adj.Ph#: ' + lcj.Adjuster_Phone +' / ' + 'Ins.Cpy: ' + ISNULL(InsuranceCompany_Name, '') + ' / ' + 'Ins.Cpy.Ph#: ' + InsuranceCompany_Local_Phone + ']'))) AS Adjuster_Name_Details
		FROM         LCJ_VW_DDL_AdjusterNames lcj INNER JOIN tblAdjusters adj ON lcj.Adjuster_Id=adj.Adjuster_Id 
		WHERE     (1 = 1 ) AND  adj.InsuranceCompany_Id=@ins_id-- AND (LastName <> '= ""') AND (FirstName <> '= ""')

	select Adjuster_Id,Ins_id, Adjuster_Name_Details from #tmpAdjusters 
	where Adjuster_Name_Details is not null order by Adjuster_Name_Details
	


END

