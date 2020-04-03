--Get_Case_Workflow_Trigger_Queue 'localhost'
CREATE PROCEDURE Get_Case_Workflow_Trigger_Queue
	--@s_a_DomainId varchar(50)
AS
BEGIN	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	IF(ISNULL((SELECT COUNT(*) FROM tblCaseWorkflowTriggerQueue WHERE ISNULL(IsProcessed,0) = 0 AND ISNULL(InProgress,0) = 1),0) < 2)
	BEGIN
	    Select TOP 2
			 q.Id as Queue_Id
			,q.Case_Id
			,q.DomainId
			,TriggerTypeId
			,t.Name as TriggerType
			,AssociatedEntity
			--,template_name
			--,template_file_name
			--,template_path
			--,template_tag_array
			--,TemplateId
			,EmailSubject as MotionType
			,EntityName = CASE LOWER(AssociatedEntity)
					WHEN 'adjuster' THEN (Select top 1 (isnull(Adjuster_FirstName, '') +' '+ isnull(Adjuster_LastName, '')) From tblAdjusters adj(NOLOCK) where adj.Adjuster_Id = cas.Adjuster_Id) 
					WHEN 'plaintiff attorney' THEN 
						SUBSTRING(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),',')))-1)		
					WHEN 'opposing counsel attorney' THEN 
						SUBSTRING(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),',')))-1)	
					WHEN 'provider' THEN 
					      (Select top 1 Provider_Name from tblProvider p (NOLOCK) Where p.Provider_Id = cas.Provider_Id)
					ELSE ''
				END
		  ,EmailAddress = CASE AssociatedEntity
					WHEN 'adjuster' THEN (Select top 1 Adjuster_Email From tblAdjusters adj(NOLOCK) where adj.Adjuster_Id = cas.Adjuster_Id) 
					WHEN 'plaintiff attorney' THEN 
					    SUBSTRING(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),',')))-1)
					WHEN 'opposing counsel attorney' THEN 
					    SUBSTRING(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),',')))-1)	
					WHEN 'provider' THEN 
					      (Select top 1 Provider_Email from tblProvider p (NOLOCK) Where p.Provider_Id = cas.Provider_Id)
					ELSE ''
				END
			,(Select Top 1 UserId from IssueTracker_Users usr where usr.UserName = q.CreatedBy and usr.DomainId = q.DomainId) as UserId
			,event_date=(CASE 
			 WHEN Lower(t.Name) = 'defense deposition date' THEN cdd.Defense_Deposition_Date
			 WHEN Lower(t.Name) = 'plaintiff deposition date' THEN cdd.Plaintiff_Deposition_Date 
			 WHEN Lower(t.Name) = 'case evaluation date' THEN cdd.CASE_EVALUATION_DATE 
			 WHEN Lower(t.Name) = 'case evaluation summary due date' THEN cdd.Case_Evaluation_Summary_Due_Date 
			 WHEN Lower(t.Name) = 'facilitation date' THEN cdd.Facilitation_Date 
			 WHEN Lower(t.Name) = 'facilitation summary due date' THEN cdd.Facilitation_Summary_Due_Date 
			 WHEN Lower(t.Name) = 'settlement conference date' THEN cdd.Settlement_Conference_Date 
			 WHEN Lower(t.Name) = 'trial date' THEN cdd.trial_date 
			 WHEN isnull(q.MotionMappingId,0) != 0 THEN (Select top 1 MotionHearingDate from tblCaseDateMotionMapping where Id = q.MotionMappingId)
			 ELSE NULL END)
		    ,ISNULL(InjuredParty_FirstName,'') + ' ' + ISNULL(InjuredParty_LastName,'') AS Patient_Name
			,ISNULL(ins.InsuranceCompany_SuitName, ins.InsuranceCompany_Name) AS InsCompany_Name
			,ISNULL(crt.Court_Name,'') AS Court_Name
			,ISNULL(crt.Court_Venue,'') AS Court_Venue
			,ISNULL(arb.ARBITRATOR_NAME,'') AS ARBITRATOR_NAME
			,ISNULL(cas.Ins_Claim_Number,'') AS Ins_Claim_Number
			,(Select top 1 (isnull(Adjuster_FirstName, '') +' '+ isnull(Adjuster_LastName, '')) From tblAdjusters adj(NOLOCK) where adj.Adjuster_Id = cas.Adjuster_Id) as Adjuster_Name
			,(Select top 1 Adjuster_Email From tblAdjusters adj(NOLOCK) where adj.Adjuster_Id = cas.Adjuster_Id) as Adjuster_Email
			,CounselAttorney_Name=SUBSTRING(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),',')))-1)	
			,CounselAttorney_Email=SUBSTRING(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),',')))-1)
			,EmailFrom
			,Password
			,SMTP_Port_Number
			,SMTP_Server_Name
			,isSSLEnabled
			,ReplyToEmailId
			,reverse(stuff(reverse(ISNULL(NULLIF(  
				SUBSTRING(ISNULL(STUFF(	(
								SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
									for xml path('')
									),1,0,''),','),1,(LEN(ISNULL(STUFF(	(
								SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
								for xml path('')
									),1,0,''),',')))-1),'')+',','') +
				 SUBSTRING(ISNULL(STUFF(	(
								SELECT COALESCE(isnull(IU.Email,'')+',',' - ')
									FROM tblTriggerCC TC (NOLOCK) 
									inner join tblTriggerType TP (NOLOCK) on TP.Id = TC.TriggerTypeId 
									inner join IssueTracker_Users IU (NOLOCK) on IU.UserId = TC.UserId
									Where TP.ID = q.TriggerTypeId and TC.DomainId = q.DomainId and isnull(IU.Email,'') != '' 
									for xml path('')
									),1,0,''),','),1,(LEN(ISNULL(STUFF(	(
								SELECT COALESCE(isnull(IU.Email,'')+',',' - ')
							        FROM tblTriggerCC TC (NOLOCK) 
									inner join tblTriggerType TP (NOLOCK) on TP.Id = TC.TriggerTypeId 
									inner join IssueTracker_Users IU (NOLOCK) on IU.UserId = TC.UserId
									Where TP.ID = q.TriggerTypeId and TC.DomainId = q.DomainId and isnull(IU.Email,'') != '' 
							for xml path('')
						),1,0,''),',')))-1)), 1, 1, '')) As EmailCC
			--,iif(AssociatedEntity ='plaintiff attorney','',  
			--SUBSTRING(ISNULL(STUFF(	(
			--					SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
			--						FROM tblAttorney_Case_Assignment aa (NOLOCK) 
			--						inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
			--						Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
			--				for xml path('')
			--			),1,0,''),','),1,(LEN(ISNULL(STUFF(	(
			--				SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
			--						FROM tblAttorney_Case_Assignment aa (NOLOCK) 
			--						inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
			--						Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
			--				for xml path('')
			--			),1,0,''),',')))-1)) As EmailCC
			, '' AS EmailBCC
			,iif(Lower(t.Name) = 'notice of deposition',  
			 SUBSTRING(ISNULL(STUFF(	(
								SELECT COALESCE(isnull(Email,'')+',',' - ')
									FROM IssueTracker_Users U (NOLOCK) 
									Where U.DomainId = q.DomainId and isnull(Email,'') != '' and Isnull(IsSecretary,0) = 1
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(	(
							SELECT COALESCE(isnull(Email,'')+',',' - ')
									FROM IssueTracker_Users U (NOLOCK) 
									Where U.DomainId = q.DomainId and isnull(Email,'') != '' and Isnull(IsSecretary,0) = 1
							for xml path('')
						),1,0,''),',')))-1),'') As SecretaryEmail
			,pl_attorney_name=(SELECT TOP 1 isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1)
			,c.LawFirmName
		from 
			tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId 
			--left join tbl_template_word tw on tw.pk_template_id = t.TemplateId
			inner join tblcase cas(NOLOCK) on cas.Case_Id = q.Case_Id
			LEFT JOIN tblCase_Date_Details cdd ON cdd.Case_Id = cas.Case_Id AND cdd.DomainId = cas.DomainId
			LEFT JOIN tblInsuranceCompany ins ON ins.InsuranceCompany_Id = cas.InsuranceCompany_Id and ins.DomainId = cas.DomainId
			LEFT JOIN tblCourt crt ON crt.Court_Id = cas.Court_Id and crt.DomainId = cas.DomainId
			LEFT JOIN TblArbitrator arb ON arb.ARBITRATOR_ID = cas.Arbitrator_ID and arb.DomainId = cas.DomainId
			LEFT JOIN tblDomainEmailSettings ems ON ems.Domain_Id = q.DomainId
			LEFT JOIN tbl_Client c ON c.DomainId = q.DomainId
		WHERE
			ISNULL(IsProcessed,0)	=	0	AND 
			ISNULL(InProgress,0)	=	0	AND
			ISNULL(q.IsDeleted, 0)	=	0	AND
			q.Id not in (Select QueueSourceId from tblTriggerTypeErrorLog tel (NOLOCK) Where ISNULL(IsResolved,0) = 0 and tel.DomainId = q.DomainId and tel.QueueType = 1)
			--q.DomainId = @s_a_DomainId  
			AND
			((Lower(AssociatedEntity) = 'adjuster' and Adjuster_Id is not null and isnull((Select top 1 Adjuster_Email From tblAdjusters adj(NOLOCK) where adj.Adjuster_Id = cas.Adjuster_Id), '')!='') or
			(Lower(AssociatedEntity) = 'plaintiff attorney' and 
			 SUBSTRING(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK) 
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),',')))-1) !='') or
			(Lower(AssociatedEntity) = 'opposing counsel attorney' and 
			(SUBSTRING(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),','),1,(LEN(ISNULL(STUFF(
						(
							SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
									FROM tblAttorney_Case_Assignment aa (NOLOCK)
									inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
									Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
							for xml path('')
						),1,0,''),',')))-1)	!='') and  
						(ISNULL((Select TOP 1 ISNULL(Attorney_BAR_Number,'') FROM tblAttorney_Case_Assignment aa (NOLOCK)
						inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
						Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and Isnull(IsOutsideAttorney,0) != 1),'') != '')
						and 
						(ISNULL((Select TOP 1 ISNULL(Attorney_Address,'') FROM tblAttorney_Case_Assignment aa (NOLOCK)
						inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
						Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and Isnull(IsOutsideAttorney,0) != 1),'') != '')
						and 
						(ISNULL((Select TOP 1 ISNULL(Attorney_City,'') FROM tblAttorney_Case_Assignment aa (NOLOCK)
						inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
						Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and Isnull(IsOutsideAttorney,0) != 1),'') != '')
						and 
						(ISNULL((Select TOP 1 ISNULL(Attorney_State,'') FROM tblAttorney_Case_Assignment aa (NOLOCK)
						inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
						Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and Isnull(IsOutsideAttorney,0) != 1),'') != '')
						and
						(ISNULL((Select TOP 1 ISNULL(Attorney_Zip,'') FROM tblAttorney_Case_Assignment aa (NOLOCK)
						inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
						Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and Isnull(IsOutsideAttorney,0) != 1),'') != '')
						) 
				--		or
				--		(Lower(t.Name) in ('1st settlement f/u letter', '2nd settlement f/u letter') 
				--		and (
				--		(Adjuster_Id is not null and ISNULL((Select top 1 ISNULL(Adjuster_Email,'') From tblAdjusters adj(NOLOCK) where adj.Adjuster_Id = cas.Adjuster_Id),'')!='')
				--		or
				--		(ISNULL((SELECT TOP 1 isnull(Attorney_Email,'') FROM tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
				--								Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1), '')!=''))
				--		and ((isnull((Select top 1 Adjuster_Email From tblAdjusters adj(NOLOCK) where adj.Adjuster_Id = cas.Adjuster_Id), '')!='') or 
				--		SUBSTRING(ISNULL(STUFF(
				--					(
				--						SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
				--								FROM tblAttorney_Case_Assignment aa (NOLOCK)
				--								inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
				--								Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
				--						for xml path('')
				--					),1,0,''),','),1,(LEN(ISNULL(STUFF(
				--					(
				--						SELECT COALESCE(isnull(Attorney_Email,'')+',',' - ')
				--								FROM tblAttorney_Case_Assignment aa (NOLOCK)
				--								inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
				--								Where aa.Case_Id = q.Case_Id and Lower(Attorney_Type) = 'opposing counsel' and aa.DomainId = q.DomainId and isnull(Attorney_Email,'') != '' and Isnull(IsOutsideAttorney,0) != 1
				--						for xml path('')
				--					),1,0,''),',')))-1) !=''))
				or
			  (Lower(AssociatedEntity) = 'provider' and Provider_Id is not null and isnull((Select top 1 isnull(Provider_Email,'') from tblProvider p (NOLOCK) Where p.Provider_Id = cas.Provider_Id),'')!='')
			 )
		order by q.Id ASC
	END
	ELSE 
	BEGIN
	    Select TOP 1
			q.Id AS Queue_Id
			,Case_Id
			,q.DomainId
			,TriggerTypeId
			,t.Name AS TriggerType
			,AssociatedEntity
			--,template_name
			--,template_file_name
			--,template_path
			--,template_tag_array
			--,TemplateId
			,'' AS AttorneyName
			,'' AS EmailAddress
			,null AS UserId
			,null AS event_date
			,'' AS Patient_Name
			,'' AS InsCompany_Name
			,'' AS Court_Name
			,'' AS Court_Venue
			,'' AS ARBITRATOR_NAME
			,'' AS Adjuster_Name
			,'' AS Adjuster_Email
			,'' AS CounselAttorney_Name
			,'' AS CounselAttorney_Email
			,'' AS EmailFrom
			,'' AS Password
			,'' AS SMTP_Port_Number
			,'' AS SMTP_Server_Name
			,0 AS isSSLEnabled
			,'' AS ReplyToEmailId
		from 
			tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId 
			--left join tbl_template_word tw on tw.pk_template_id = t.TemplateId
		WHERE
			ISNULL(IsProcessed,0)	=	-1	AND 
			ISNULL(InProgress,0)	=	-1	
			--q.DomainId = @s_a_DomainId
		order by q.Id ASC

	END
    
END
