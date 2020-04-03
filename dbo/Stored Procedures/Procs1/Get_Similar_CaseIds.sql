-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Similar_CaseIds] 
	@s_a_CaseId varchar(50),
	@s_a_DomainId varchar(50),
	@i_a_PageSize int = 5,
	@i_a_PageNumber int =1
AS
BEGIN
	
	SET NOCOUNT ON;

    Select 
	 cas.Case_Id
	,cas.Status 
	FROM tblCase cas (NOLOCK) 
	inner join tblCase cas_s (NOLOCK) on
			cas.Provider_Id =cas_s.Provider_Id  
			and cas.InjuredParty_LastName = cas_s.InjuredParty_LastName
			and cas.InjuredParty_FirstName = cas_s.InjuredParty_FirstName 
			and  cas.Accident_Date =cas_s.Accident_Date 
			and cas.DomainId = cas_s.DomainId
			and cas.Case_Id <> cas_s.case_id
    inner join tblprovider (NOLOCK) pro on cas.provider_id=pro.provider_id
    inner join tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
    where cas_s.Case_Id =@s_a_CaseId and cas_s.DomainId = @s_a_DomainId
	and  cas.CASE_ID NOT LIKE 'ACT%'
	ORDER BY cas.Case_Id
	OFFSET @i_a_PageSize * (@i_a_PageNumber - 1) ROWS
    FETCH NEXT @i_a_PageSize ROWS ONLY;

	Select 
	  CEILING(CAST(count(cas.Case_Id) As float)/CAST(@i_a_PageSize As float)) As TotalPages
	FROM tblCase cas(NOLOCK) 
	inner join tblCase cas_s on
			cas.Provider_Id =cas_s.Provider_Id  
			and cas.InjuredParty_LastName = cas_s.InjuredParty_LastName
			and cas.InjuredParty_FirstName = cas_s.InjuredParty_FirstName 
			and  cas.Accident_Date =cas_s.Accident_Date 
			and cas.DomainId = cas_s.DomainId
			and cas.Case_Id <> cas_s.case_id
    inner join tblprovider (NOLOCK) pro on cas.provider_id=pro.provider_id
    inner join tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id = ins.insurancecompany_id
    where cas_s.Case_Id = @s_a_CaseId and cas_s.DomainId = @s_a_DomainId
	and  cas.CASE_ID NOT LIKE 'ACT%'


END
