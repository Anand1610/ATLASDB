CREATE PROCEDURE [dbo].[Billing_Packet_Case_Counts] 
	-- Add the parameters for the stored procedure here
	@DomainID NVARCHAR(50),
	@chkProvider bit,
	@chkInsurance bit,
	@chkARB bit,
	@chkLIT bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Condition NVARCHAR(500)
    -- Insert statements for procedure here
	

	IF(@chkProvider = 1 AND  @chkInsurance = 0)
	BEGIN
		-- PRINT '1'
		SELECT DISTINCT
		  t.Provider_Name + ISNULL(' [ ' + t.Provider_Groupname + ' ]','') as Provider_Name,
		  '' AS InsuranceCompany_Name,t.Provider_Id,0 AS InsuranceCompany_Id,
		  (SELECT Count(Case_Id)  FROM  dbo.Auto_Billing_Packet_Info ct (NOLOCK)
		   WHERE ct.Provider_Name = t.Provider_Name) AS CaseCount
		FROM
		  dbo.Auto_Billing_Packet_Info t (NOLOCK)
		  left join tblProvider p (NOLOCK) on p.Provider_Id = t.Provider_Id
		  where t.DomainId=@DomainID AND  t.case_id like 'ACT%'
		  and (((@chkARB = 1 and p.packet_type='ARB') or (@chkLIT = 1 and p.packet_type='LIT')) 
		      or ((@chkARB = 0 or p.packet_type='ARB') and (@chkLIT = 0 or p.packet_type='LIT')))
	END

	IF(@chkProvider = 0 AND  @chkInsurance = 1)
	BEGIN
		--PRINT '2'
		SELECT DISTINCT
		  '' as Provider_Name,
		  t.InsuranceCompany_Name,0 AS Provider_Id,t.InsuranceCompany_Id,
		  (SELECT Count(Case_Id)  FROM  dbo.Auto_Billing_Packet_Info ct (NOLOCK)
		   WHERE ct.InsuranceCompany_Name = t.InsuranceCompany_Name) AS CaseCount
		FROM
		  dbo.Auto_Billing_Packet_Info t (NOLOCK)
		   left join tblProvider p (NOLOCK) on p.Provider_Id = t.Provider_Id
		  where t.DomainId=@DomainID AND  t.case_id like 'ACT%'
		  and (((@chkARB = 1 and p.packet_type='ARB') or (@chkLIT = 1 and p.packet_type='LIT')) 
		      or ((@chkARB = 0 or p.packet_type='ARB') and (@chkLIT = 0 or p.packet_type='LIT')))

	END

	IF(@chkProvider = 1 AND  @chkInsurance = 1)
	BEGIN
		--PRINT '3'
		SELECT DISTINCT
		  t.Provider_Name + ISNULL(' [ ' + t.Provider_Groupname + ' ]','') as Provider_Name,
		  t.InsuranceCompany_Name,t.Provider_Id,t.InsuranceCompany_Id,
		  (SELECT Count(Case_Id)  FROM  dbo.Auto_Billing_Packet_Info ct (NOLOCK)
		   WHERE ct.Provider_Name = t.Provider_Name AND ct.InsuranceCompany_Name = t.InsuranceCompany_Name) AS CaseCount
		FROM
		  dbo.Auto_Billing_Packet_Info t (NOLOCK)
		   left join tblProvider p (NOLOCK) on p.Provider_Id = t.Provider_Id
		  where t.DomainId = @DomainID AND  t.Initial_Status = 'Active'
		  and (((@chkARB = 1 and p.packet_type='ARB') or (@chkLIT = 1 and p.packet_type='LIT')) 
		      or ((@chkARB = 0 or p.packet_type='ARB') and (@chkLIT = 0 or p.packet_type='LIT')))
	END

	
			
				
				
END
