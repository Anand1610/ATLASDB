CREATE PROCEDURE Get_Workflow_Daily_Report 
	@s_a_DomainId Varchar(50),
	@s_a_App_URL varchar(500)
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
				
				Set @s_a_App_URL = REPLACE(REPLACE(@s_a_App_URL, 'XXX',@s_a_DomainId),'/LSCaseManager/Files/','')
					
				Select 
					 N.Case_Id AS [Case ID]
					,ISNULL(InjuredParty_FirstName,'') + ' ' + ISNULL(InjuredParty_LastName,'') AS [Injured Name]	
					,P.Provider_Name As [Provider]
					,I.InsuranceCompany_Name as [Insurance Company]
					,C.Initial_Status AS [Case Status]
					,C.Status AS [Current Status]
					,CRT.Court_Name AS [Court Name]
					,(SUBSTRING(ISNULL(STUFF(	(SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
						FROM tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
						inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id Where Case_Id = C.Case_Id 
						and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = C.DomainId and isnull(Attorney_Email,'') != '' for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF((SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
						FROM tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
						inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id	Where Case_Id = C.Case_Id 
						and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = C.DomainId and isnull(Attorney_Email,'') != '' for xml path('')),1,0,''),',')))-1)) AS [Plaintiff Attorney]	
					,(SUBSTRING(ISNULL(STUFF(	(SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
						FROM tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
						inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id Where Case_Id = C.Case_Id 
						and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = C.DomainId and isnull(Attorney_Email,'') != '' for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF((SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
						FROM tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
						inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id	Where Case_Id = C.Case_Id 
						and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = C.DomainId and isnull(Attorney_Email,'') != '' for xml path('')),1,0,''),',')))-1)) AS [Opposing Counsel]
						,ISNULL(A.Adjuster_FirstName,'') +' ' + ISNULL(A.Adjuster_LastName,'') AS Adjuster
						,N.Notes_Desc AS [Workflow Activity]
						,Convert(Varchar(50), N.Notes_Date, 101) AS [Activity Date]
						,N.User_Id AS [Activity Done By]
						,(SUBSTRING(ISNULL(STUFF((
								SELECT COALESCE(isnull(DI.Filename,'')+',',' - ')
								from tblCaseWorkflowAttachments CWA INNER JOIN tblDocImages DI ON DI.ImageID=CWA.AttachmentImageID
								Where CWA.WorkflowQueue_Id = Q.Id
								for xml path('')),1,0,''),','),1,
							(LEN(ISNULL(STUFF((
								SELECT COALESCE(isnull(DI.Filename,'')+',',' - ')
								from tblCaseWorkflowAttachments CWA INNER JOIN tblDocImages DI ON DI.ImageID=CWA.AttachmentImageID
								Where CWA.WorkflowQueue_Id = Q.Id
								for xml path('')),1,0,''),',')))-1)) As [Activity Document Name]
						,(SUBSTRING(ISNULL(STUFF((
								SELECT COALESCE(isnull(@s_a_App_URL + REPLACE((VirtualBasePath+'/'+FilePath+Filename),'\','/'),'')+',',' - ')
								from tblCaseWorkflowAttachments CWA INNER JOIN tblDocImages DI ON DI.ImageID=CWA.AttachmentImageID
								LEFT JOIN tblBasePath B ON B.BasePathId = DI.BasePathId
								Where CWA.WorkflowQueue_Id = Q.Id
								for xml path('')),1,0,''),','),1,
							(LEN(ISNULL(STUFF((
								SELECT COALESCE(isnull(@s_a_App_URL + REPLACE((VirtualBasePath+'/'+FilePath+Filename),'\','/'),'')+',',' - ')
								from tblCaseWorkflowAttachments CWA INNER JOIN tblDocImages DI ON DI.ImageID=CWA.AttachmentImageID
								LEFT JOIN tblBasePath B ON B.BasePathId = DI.BasePathId
								Where CWA.WorkflowQueue_Id = Q.Id
								for xml path('')),1,0,''),',')))-1)) As [Activity Document Link]
						--,D.Filename AS [Activity Document Name]
						--,@s_a_App_URL + REPLACE((VirtualBasePath+'/'+FilePath+Filename),'\','/') AS [Activity Document Link]
				from 
					tblNotes N INNER JOIN tblcase C ON C.Case_Id = N.Case_Id and C.DomainId = N.DomainId
					LEFT JOIN tblProvider P ON P.Provider_Id = C.Provider_Id
					LEFT JOIN tblInsuranceCompany I ON I.InsuranceCompany_Id = C.InsuranceCompany_Id
					LEFT JOIN tblCourt CRT ON CRT.Court_Id = C.Court_Id
					LEFT JOIN tblAdjusters A ON A.Adjuster_Id = C.Adjuster_Id
					LEFT JOIN tblCaseWorkflowTriggerQueue Q ON Q.Id = N.WorkflowQueueID and N.WorkflowQueueID is not null
					--LEFT JOIN tblDocImages D ON D.ImageID = Q.AttachmentImageID and Q.AttachmentImageID is not null
					--LEFT JOIN tblBasePath B ON B.BasePathId = D.BasePathId
					LEFT JOIN tbl_Portfolio PF ON PF.Id = C.PortfolioId
			    where 
					Lower(Notes_Type) = 'workflow' and N.DomainId = @s_a_DomainId 
					and Convert(Varchar(50),Notes_Date, 101) = CONVERT(Varchar(50), GetDate(), 101)
					and 
					Not Exists(Select * from tblWorkflowDailyReport Where Convert(varchar(50), Sent_Date, 101) = Convert(varchar(50), GETDATE(), 101) and DomainId = @s_a_DomainId)
					and ISNULL(Portfolio_Type,0) != 2
					and (Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
							Where aa.Case_Id =C.Case_Id and aa.DomainId = @s_a_DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
				Order by Notes_ID ASC
END
