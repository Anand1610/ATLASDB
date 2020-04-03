-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Retrive_Amount_Provider_Report] -- Retrive_Amount_Provider_Report 'GLF'
	@s_a_DomainId varchar(50)
AS
BEGIN

	SET NOCOUNT ON;

    Select P.Provider_Id,P.Provider_Name
	, iif(Provider_Type is null, '', Provider_Type) As Provider_Type
	, Sum(Convert(money, C.Claim_Amount)) As Total_Claim_Amount
	, (Select sum(Transactions_Amount) From tbltransactions where Provider_Id=P.Provider_Id and Transactions_Type in ('C','PRI-C', 'I')) As TotalCollection
	, (Select sum(Transactions_Amount) From tbltransactions where Provider_Id=P.Provider_Id and Transactions_Type in ('AF')) As AttorneyFees
	from tblcase C inner join tblprovider P on P.Provider_Id=C.Provider_Id where P.DomainId = @s_a_DomainId
	group by P.Provider_Id, P.Provider_Name, Provider_Type order by P.Provider_Name
END
