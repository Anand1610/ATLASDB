﻿/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Provider_Status_Details_Retrive] 
	-- Add the parameters for the stored procedure here
	@s_a_Provider_ID INT, 
	@s_a_Status VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @s_a_Status = 'all'
	BEGIN
	  select vw.*,ISNULL(Transactions_Amount,'0.00') Transactions_Amount from LCJ_VW_CaseDetailsForClientReport vw LEFT OUTER JOIN ( SELECT distinct Case_Id as CaseID, ISNULL(sum(Transactions_Amount),'0.00') AS Transactions_Amount FROM tblTransactions WHERE Transactions_Type in ('C','I')  Group by Case_Id) T on T.CaseID = VW.Case_Id where vw.provider_id=@s_a_Provider_ID and status <> 'IN ARB OR LIT' order by Initial_Status, insurancecompany_name asc
	END
	ELSE
	BEGIN
	select vw.*,ISNULL(Transactions_Amount,'0.00') Transactions_Amount from LCJ_VW_CaseDetailsForClientReport vw LEFT OUTER JOIN ( SELECT distinct Case_Id as CaseID, ISNULL(sum(Transactions_Amount),'0.00') AS Transactions_Amount FROM tblTransactions WHERE Transactions_Type in ('C','I')  Group by Case_Id) T on T.CaseID = VW.Case_Id where vw.provider_id=@s_a_Provider_ID and status <> 'IN ARB OR LIT' and Initial_Status=@s_a_Status order by Initial_Status, insurancecompany_name asc
	END
END