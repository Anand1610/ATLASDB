create Procedure [dbo].[GetCaseDocuments]--GetDocumentReportForCases @DOMAINID='amt',@s_a_PortfolioId='1'
@DOMAINID varchar(20),
@s_a_PortfolioId varchar(max)= '',
@s_a_ProviderSel  varchar(max)= '',
@s_a_InsuranceSel  varchar(max)= ''

AS
BEGIN
SELECT 
 Cas.Case_Id, InsuredParty_FirstName, InsuredParty_LastName, Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,
(SUBSTRING(ISNULL(STUFF((
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) 
					on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id  and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DOMAINID
					
			for xml path('')
		),1,0,''),','),1,(LEN(ISNULL(STUFF(
		(
			SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
					FROM tblAttorney_Case_Assignment aa (NOLOCK) 
					inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) 
					on atp.Attorney_Type_ID = am.Attorney_Type_Id
					Where aa.Case_Id = cas.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = @DOMAINID
					
			for xml path('')
		),1,0,''),',')))-1)) AS Opposing_Counsel, cas.IndexOrAAA_Number, cas.Status
		,cas.InjuredParty_LastName,
cas.InjuredParty_FirstName,
isnull(Ins.InsuranceCompany_Name,'') [InsuranceCompany_Name],
isnull(pfl.Name,'')[Portfolio],
 isnull(tgs.NodeName,'NA') [NodeName], isnull(docimg.Filename,'NA')[Filename],isnull(docimg.FilePath,'NA')
from tblcase cas
left join tblInsuranceCompany Ins with(nolock)  on Ins.InsuranceCompany_Id =cas.InsuranceCompany_Id
left join tbl_Portfolio pfl with(nolock)  on pfl.Id=cas.PortfolioId 
left JOIN tblprovider pro (NOLOCK) on cas.provider_id=pro.provider_id and pro.DomainId= @DOMAINID 
LEFT outer JOIN  tblTags tgs   with(nolock)  on tgs.CASEID=cas.Case_Id
 left JOIN tblImageTag tblImg with(nolock)  ON tgs.Nodeid = tblImg.tagid
 left JOIN tblDocImages docimg with(nolock)  on tblImg.ImageID = docimg.ImageID
where cas.DomainId= @DOMAINID
AND  tgs.nodename in ('Correspondence' ,'Defense pleadings','DISCOVERY','MOTIONS/RESPONSES','Plaintiff pleadings','Proof of Notice','Checks and Releases','Settlement Letter')
AND (@s_a_PortfolioId = '0' OR @s_a_PortfolioId = '' OR cas.PortfolioId  IN (SELECT  cast(items as INT )  FROM dbo.STRING_SPLIT(@s_a_PortfolioId,',')))
AND (@s_a_InsuranceSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceSel,',')))
AND (@s_a_ProviderSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderSel,',')))
---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
AND tblImg.IsDeleted=0 AND docimg.IsDeleted=0
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude

order by cas.Case_Id,NodeName
END