
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Report_OpenCases] -- [dbo].[Report_OpenCases] 'localhost'
	-- Add the parameters for the stored procedure here
	@domainId				   nvarchar(50),
	@s_a_date_opened_FROM	VARCHAR(20)=''	,
	@s_a_date_Opened_To	VARCHAR(20)='',
	@s_a_UserID varchar(30)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT OPENED_BY,
		Count(cas.Case_Id) AS Case_Count
	FROM tblCase cas  WITH (NOLOCK)
	INNER JOIN tblprovider pro  WITH (NOLOCK) on cas.provider_id=pro.provider_id
	INNER JOIN tblinsurancecompany ins  WITH (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
	WHERE
		cas.domainId = @domainId
		AND (@s_a_UserID = '' OR OPENED_BY = @s_a_UserID )
		AND (@s_a_date_opened_FROM='' OR (Date_Opened Between CONVERT(datetime,@s_a_date_opened_FROM) And CONVERT(datetime,@s_a_date_Opened_To)))		
	GROUP BY OPENED_BY
	ORDER BY OPENED_BY	asc
	


    SELECT distinct
		cas.Case_Id	,Case_AutoId,
		  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') AS Provider_Name,  
		ins.InsuranceCompany_Name, 	
		cas.Status, 		
		cas.Initial_Status,
		cas.Claim_Amount,
		OPENED_BY
	FROM tblCase cas  WITH (NOLOCK)
	INNER JOIN tblprovider pro  WITH (NOLOCK) on cas.provider_id=pro.provider_id
	INNER JOIN tblinsurancecompany ins  WITH (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
	WHERE
		cas.domainId = @domainId
		AND (@s_a_UserID = '' OR OPENED_BY = @s_a_UserID )
		AND (@s_a_date_opened_FROM='' OR (Date_Opened Between CONVERT(datetime,@s_a_date_opened_FROM) And CONVERT(datetime,@s_a_date_Opened_To)))		
	ORDER BY Case_AutoId	desc
	
END
