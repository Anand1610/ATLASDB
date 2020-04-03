

CREATE Procedure [dbo].[GetDocumentReport]--GetDocumentReport @DOMAINID='amt',@CASEID='AMT19-103288'
@DOMAINID varchar(20),
@CASEID varchar(50)

AS
BEGIN
WITH CTE AS (
select Cas.Case_Id, InsuredParty_FirstName, InsuredParty_LastName,InsuranceCompany_Id, Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,
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

	from tblcase cas with(nolock) 
INNER JOIN tblprovider pro (NOLOCK) on cas.provider_id=pro.provider_id where  cas.case_id=@CASEID and cas.DomainId= @DOMAINID and pro.DomainId= @DOMAINID)

,CTE2 as (

SELECT * FROm
(select tgs.CASEID, docimg.Filename, tgs.NodeName from tblTags tgs with(nolock) 
INNER JOIN tblImageTag tblImg with(nolock)  ON tgs.Nodeid = tblImg.tagid
INNER JOIN tblDocImages docimg with(nolock)  on tblImg.ImageID = docimg.ImageID
where tgs.nodename in ('Correspondence' ,'Defense pleadings','DISCOVERY','MOTIONS/RESPONSES','Plaintiff pleadings','Proof of Notice','Checks and Releases','Settlement Letter')
and tgs.caseid=@CASEID and tgs.DomainId=@DOMAINID 
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
FROM CTE LEFT JOIN CTE2 ON CTE.Case_Id = CTE2.CaseID
END
 
