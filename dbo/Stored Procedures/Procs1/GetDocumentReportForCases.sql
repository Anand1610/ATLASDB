

CREATE Procedure [dbo].[GetDocumentReportForCases]--GetDocumentReportForCases @DOMAINID='amt',@s_a_PortfolioId='1'
@DOMAINID varchar(20),
@s_a_PortfolioId varchar(max)= '',
@s_a_ProviderSel  varchar(max)= '',
@s_a_InsuranceSel  varchar(max)= ''

AS
BEGIN


(select  Case_Id into #tempCase from tblcase cas (nolock)
where cas.DomainId= @DOMAINID
and (@s_a_PortfolioId = '0' OR @s_a_PortfolioId = '' OR cas.PortfolioId  IN (SELECT  cast(items as INT )  FROM dbo.STRING_SPLIT(@s_a_PortfolioId,',')))
AND (@s_a_InsuranceSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceSel,',')))
AND (@s_a_ProviderSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderSel,','))))


;WITH CTE AS (
select Cas.Case_Id, InsuredParty_FirstName, InsuredParty_LastName, Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,
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
		),1,0,''),',')))-1)) AS Opposing_Counsel, cas.IndexOrAAA_Number, Status
		,cas.InjuredParty_LastName,
cas.InjuredParty_FirstName,
isnull(Ins.InsuranceCompany_Name,'') [InsuranceCompany_Name],
isnull(pfl.Name,'')[Portfolio]
	from tblcase cas with(nolock) 
	join #tempCase t1 on cas.Case_Id=t1.Case_Id
	left join tblInsuranceCompany Ins with(nolock)  on Ins.InsuranceCompany_Id =cas.InsuranceCompany_Id
	left join tbl_Portfolio pfl with(nolock)  on pfl.Id=cas.PortfolioId 
    left JOIN tblprovider pro (NOLOCK) on cas.provider_id=pro.provider_id and pro.DomainId= @DOMAINID where   cas.DomainId= @DOMAINID )


,CTE2 as (

SELECT * FROm
(select tc.Case_Id, docimg.Filename, tgs.NodeName 
from  tblTags tgs  with(nolock) 
right join #tempCase tc  with(nolock)  on tgs.CASEID=tc.Case_Id
left JOIN tblImageTag tblImg with(nolock)  ON tgs.Nodeid = tblImg.tagid

  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		 AND tblImg.IsDeleted=0  
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
left JOIN tblDocImages docimg with(nolock)  on tblImg.ImageID = docimg.ImageID

  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		  AND docimg.IsDeleted=0
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
where tgs.nodename in ('Correspondence' ,'Defense pleadings','DISCOVERY','MOTIONS/RESPONSES','Plaintiff pleadings','Proof of Notice','Checks and Releases','Settlement Letter')
 and tgs.DomainId=@DOMAINID 

)
AS DocumentTable
PIVOT (count([Filename]) FOR [NodeName] IN ([Correspondence],[Defense pleadings],[DISCOVERY],[MOTIONS/RESPONSES],[Plaintiff pleadings],[Proof of Notice],[Checks and Releases] ,[Settlement Letter]))a)


SELECT CTE.*, 
isnull([Correspondence],0) [Correspondence] ,
isnull([Defense pleadings],0) [Defense Pleadings],
isnull([DISCOVERY],0) [Discovery],
isnull([MOTIONS/RESPONSES],0) [Motions/Responses],
isnull([Plaintiff pleadings],0) [Plaintiff Pleadings],
isnull([Proof of Notice],0) [Proof of Notice],
isnull([Checks and Releases],0) [Checks and Release],
isnull([Settlement Letter] ,0) [Settlement Letter],
'ALL'[ALL]
FROM CTE LEFT JOIN CTE2 ON CTE.Case_Id = CTE2.Case_Id
END
 
