CREATE PROCEDURE [dbo].[Get_Settlement_PivotReport] --[Get_Settlement_PivotReport] 1
(
	@DomainId NVARCHAR(50),
	@Type bit
)	
AS
BEGIN

	IF(@Type='1' ) -- Current settlement
	BEGIN
		SELECT 
			YEAR(date_opened) AS Date_Opened_Year,
			b.Case_Id,
			Insurancecompany_Name,
			Status, 
			CONVERT(MONEY,ISNULL(Claim_Amount,0)) aS Claim_Amount,
			CONVERT(MONEY,ISNULL(Paid_Amount,0)) AS Paid_Amount,
			CONVERT(MONEY,ISNULL(CONVERT(money, ISNULL(b.Claim_Amount, 0))       
                      - CONVERT(float, ISNULL(b.Paid_Amount, 0)),0)) As Balance_Amount,
			 CONVERT(MONEY,       
                      ISNULL(dbo.tblSettlements.Settlement_Amount, 0)) + CONVERT(MONEY, ISNULL(dbo.tblSettlements.Settlement_Int, 0)) AS Settlement_PI,		
			Settlement_AF,			
			CONVERT(decimal(38, 2),CASE WHEN CONVERT(money, ISNULL(b.Claim_Amount, 0))       
                      - CONVERT(float, ISNULL(b.Paid_Amount, 0)) < 1 THEN 0 ELSE ( CONVERT(MONEY,       
                      ISNULL(dbo.tblSettlements.Settlement_Amount, 0)) + CONVERT(MONEY, ISNULL(dbo.tblSettlements.Settlement_Int, 0))/CONVERT(money, ISNULL(b.Claim_Amount, 0))       
                      - CONVERT(float, ISNULL(b.Paid_Amount, 0))) END )AS Settlement_PI_Per,
			CONVERT(decimal(38, 2),CASE WHEN CONVERT(money, ISNULL(b.Claim_Amount, 0))       
                      - CONVERT(float, ISNULL(b.Paid_Amount, 0)) < 1 THEN 0 ELSE (Settlement_Af/CONVERT(money, ISNULL(b.Claim_Amount, 0))       
                      - CONVERT(float, ISNULL(b.Paid_Amount, 0))) END )AS Settlement_AF_Per,
			YEAR(Settlement_Date) AS Settlement_Year
		FROM tblCAsE b with(nolock)
		INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON b.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
		LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON b.Case_Id = dbo.tblSettlements.Case_Id 
		WHERE ISNULL(b.IsDeleted,0) = 0 AND
		YEAR(date_opened) >= 2007 and YEAR(Settlement_Date) is not null AND @DomainId = b.DomainId
	END
	ELSE ---- Expected Settlement
	BEGIN
		SELECT YEAR(date_opened) AS Date_Opened_Year,b.Case_Id,Insurancecompany_Name,
		CONVERT(MONEY,ISNULL(Claim_Amount,0))AS Claim_Amount ,CONVERT(MONEY,ISNULL(Paid_Amount,0)) AS Paid_Amount ,Status, 
		Settlement_Amount + Settlement_Int AS  Settlement_PI,Settlement_AF,YEAR(Settlement_Date) AS Settlement_Year
		FROM tblCAsE b with(nolock)  
		INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON b.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
		LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON b.Case_Id = dbo.tblSettlements.Case_Id 
		WHERE ISNULL(b.IsDeleted,0) = 0 AND
		YEAR(date_opened) >= 2007 and YEAR(Settlement_Date) is null AND @DomainId = b.DomainId
	END
END

