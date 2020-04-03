-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Auto_Packet_Case_Counts] 
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
		SELECT DISTINCT
		  t.Provider_Name + ISNULL(' [ ' + t.Provider_Groupname + ' ]','') as Provider_Name
		  , t.provider_id
		  , '' AS InsuranceCompany_Name,t.Provider_Id
		  ,	0 AS InsuranceCompany_Id
		  , COUNT(case_id)  AS CaseCount
		FROM
		  dbo.Auto_Packet_Info t
		   left join tblProvider p on p.Provider_Id = t.Provider_Id
		  where t.DomainId=@DomainID
		    and (((@chkARB = 1 and p.packet_type='ARB') or (@chkLIT = 1 and p.packet_type='LIT')) 
		      or ((@chkARB = 0 or p.packet_type='ARB') and (@chkLIT = 0 or p.packet_type='LIT')))
		GROUP BY t.provider_id
		, t.Provider_Name
		, t.Provider_Groupname
	END

	IF(@chkProvider = 0 AND  @chkInsurance = 1)
	BEGIN
		 SELECT DISTINCT
		  '' as Provider_Name
		  , 0 AS Provider_Id
		  , t.InsuranceCompany_Name
		  , t.InsuranceCompany_Id
		  , COUNT(case_id) AS CaseCount
		FROM
		  dbo.Auto_Packet_Info t 
		   left join tblProvider p on p.Provider_Id = t.Provider_Id
		  where t.DomainId=@DomainID 
		    and (((@chkARB = 1 and p.packet_type='ARB') or (@chkLIT = 1 and p.packet_type='LIT')) 
		      or ((@chkARB = 0 or p.packet_type='ARB') and (@chkLIT = 0 or p.packet_type='LIT')))
		GROUP BY InsuranceCompany_Id
			, t.InsuranceCompany_Name
	END

	IF(@chkProvider = 1 AND  @chkInsurance = 1)
	BEGIN
		SELECT DISTINCT
		  t.Provider_Name + ISNULL(' [ ' + t.Provider_Groupname + ' ]','') as Provider_Name
		  , t.Provider_Id
		  , t.InsuranceCompany_Name
		  , t.InsuranceCompany_Id
		  , COUNT(case_id) AS CaseCount
		FROM
		  dbo.Auto_Packet_Info t 
		   left join tblProvider p on p.Provider_Id = t.Provider_Id
		  where t.DomainId=@DomainID
		    and (((@chkARB = 1 and p.packet_type='ARB') or (@chkLIT = 1 and p.packet_type='LIT')) 
		      or ((@chkARB = 0 or p.packet_type='ARB') and (@chkLIT = 0 or p.packet_type='LIT')))
		GROUP BY 
			  t.Provider_name
			, t.Provider_id
			, t.Provider_Groupname
			, InsuranceCompany_Name
			, InsuranceCompany_Id
	END

	
			
				
				
END
