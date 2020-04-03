CREATE PROCEDURE [dbo].[Get_Previous_Posting_All]
	 @FromDate Datetime,
	 @ToDate Datetime,
	 @DomainId varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	 
	 SELECT a.provider_name,
		   a.Funding_Company,
		   a.Vendor_Name,
		   ROUND(ISNULL(final_remit,0.00), 2) AS Final_Remit,
		   '' AS Final_Remit_Word,
		   Account_Id,
		   ROUND(ISNULL(Gross_Amount,0.00), 2) AS Gross_Amount,
		   ROUND(ISNULL(b.VENDOR_FEE,0.00), 2) AS VENDORFEE,
		   '' AS VENDORFEE_Word,
		   ROUND((ISNULL(Gross_Amount,0.00) - ISNULL(final_remit,0.00)), 2) AS Gross_Remit_Diff,
		   '' AS Gross_Remit_Diff_Word,
		   ISNULL(LawFirmName,'') AS LawFirmName,
		   ROUND(ISNULL(convert (money,a.Vendor_Fee),0), 2) AS Vendor_Service
		   FROM tblprovider a inner join TBLCLIENTACCOUNT b on a.provider_id=b.provider_id 
		   left outer join tbl_Client ON tbl_Client.DomainId = a.DomainId 
		   WHERE a.DomainId = @DomainId and
		   cast(floor(convert( float,b.account_date)) as datetime)>= @FromDate and 
		   cast(floor(convert( float,b.account_date)) as datetime) <= @ToDate
		   order by provider_name,account_date
END
