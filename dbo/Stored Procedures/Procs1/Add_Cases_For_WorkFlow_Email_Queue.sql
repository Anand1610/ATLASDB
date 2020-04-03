--Add_Cases_For_WorkFlow_Email_Queue 'localhost'
CREATE PROCEDURE [dbo].[Add_Cases_For_WorkFlow_Email_Queue]
	--@s_a_DomainId varchar(50)
AS
BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	    Insert into tblCaseWorkflowTriggerQueue
		(Case_Id, DomainId, TriggerTypeId, InProgress, IsProcessed, IsDeleted, CreatedBy, CreatedDate)

		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Answer Settlement Demand Letter' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
			from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Proof_of_Service_Date is not null and DATEDIFF(Day,Proof_of_Service_Date, GETDATE()) >32 and Date_Answer_Received is null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
									where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Answer Settlement Demand Letter' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Notice of Deposition' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
			from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Scheduling_Order_Issue_Date is not null and DATEDIFF(Day,Scheduling_Order_Issue_Date, GETDATE()) > 40 and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and ISNULL((SELECT COUNT(wl.WitnessId) FROM tblCaseWitnessList wl WHERE wl.Case_Id = cd.Case_Id AND wl.DomainId = cd.DomainId),0) = 0
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
									where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Notice of Deposition' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Discovery Cutoff' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
			from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Discovery_Cutoff_Date is not null and Convert(varchar(50), Discovery_Cutoff_Date, 101) = Convert(varchar(50), GETDATE(), 101) and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
									where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Discovery Cutoff' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Witness List Pending Cases' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
			from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Scheduling_Order_Issue_Date is not null and DATEDIFF(Day,Scheduling_Order_Issue_Date, GETDATE()) >30 and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and ISNULL((SELECT COUNT(wl.WitnessId) FROM tblCaseWitnessList wl WHERE wl.Case_Id = cd.Case_Id AND wl.DomainId = cd.DomainId),0) = 0
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
									where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Witness List Pending Cases' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Plaintiff Response to Defense Discovery Due Today' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Defense_Discovery_Receipt_Date is not null and DATEDIFF(Day,Defense_Discovery_Receipt_Date, GETDATE()) >25 and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Plaintiff Response to Defense Discovery Due Today' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Discovery Stipulation' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE()
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Defense_Discovery_Receipt_Date is not null and Plaintiff_Discovery_Responses_Completed_Date is null and DATEDIFF(Day,Defense_Discovery_Receipt_Date, GETDATE()) >32 and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Discovery Stipulation' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Defense Deposition Date' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Defense_Deposition_Date is not null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId 
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Defense Deposition Date' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Plaintiff Deposition Date' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE()
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Plaintiff_Deposition_Date is not null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId 
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Plaintiff Deposition Date' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Client Release F/U' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Release_Received_Date is not null and Client_Release_Execution_Request_Date is null and DATEDIFF(Day,Release_Received_Date, GETDATE()) >5 and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Client Release F/U' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Settlement F/U Letter' and Lower(AssociatedEntity)='opposing counsel attorney' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Release_Received_Date is null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId 
			and DATEDIFF(Day, Settlement_Date, GETDATE()) > 5 
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Settlement F/U Letter' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0 and Lower(t.AssociatedEntity)='opposing counsel attorney') 
			--and (Select isnull(sum(isnull(Transactions_Amount,0)),0) as Transactions_Amount from tblTransactions where Case_Id=cd.Case_Id and DomainId = @s_a_DomainId) = 0
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
			--add conditon to check payment sum of transaction amount = 0
		UNION
		
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Payment Reminder Letter' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Payment_Received_Date is null and DATEDIFF(Day,Client_Release_Execution_Request_Date, GETDATE()) >14 and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Payment Reminder Letter' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Case Evaluation Date' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where CASE_EVALUATION_DATE is not null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Case Evaluation Date' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Case Evaluation Summary Due' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where CASE_EVALUATION_DATE is not null  and 21 < DATEDIFF(Day, GETDATE(), CASE_EVALUATION_DATE) and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Case Evaluation Summary Due' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Case Evaluation Summary Due Date' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Case_Evaluation_Summary_Due_Date is not null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Case Evaluation Summary Due Date' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Case Evaluation Summary Due Date Reminder' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Case_Evaluation_Summary_Due_Date is not null and Convert(varchar(20), Case_Evaluation_Summary_Due_Date,101) =  Convert(varchar(20), GETDATE(),101) and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Case Evaluation Summary Due Date Reminder' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Case Evaluation Accept/Reject Pending' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Case_Evaluation_Status_Date is null and CASE_EVALUATION_DATE is not null and DATEDIFF(Day,CASE_EVALUATION_DATE, GETDATE()) > 10 and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Case Evaluation Accept/Reject Pending' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Facilitation Date' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Facilitation_Date is not null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Facilitation Date' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Facilitation Summary Due' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Facilitation_Date is not null  and 14 < DATEDIFF(Day, GETDATE(), Facilitation_Date) and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Facilitation Summary Due' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Facilitation Summary Due Date' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Facilitation_Summary_Due_Date is not null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Facilitation Summary Due Date' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Facilitation Summary Due Date Reminder' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Facilitation_Summary_Due_Date is not null and Convert(varchar(20), Facilitation_Summary_Due_Date,101) =  Convert(varchar(20), GETDATE(),101) and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Facilitation Summary Due Date Reminder' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Settlement Conference Date' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Settlement_Conference_Date is not null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Settlement Conference Date' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Trial Date' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Trial_Date is not null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Trial Date' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Final Trial Notebook' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Trial_Date is not null  and 21 < DATEDIFF(Day, GETDATE(), Trial_Date) and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Final Trial Notebook' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Defense Answer to Our Discovery Are Due Today' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Plaintiff_Propounded_Discovery_Sent_Date is not null  and DATEDIFF(Day, Plaintiff_Propounded_Discovery_Sent_Date, GETDATE()) > 32 and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Defense Answer to Our Discovery Are Due Today' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Defense Answers to our Discovery' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Defense_Answers_to_our_Discovery_Completed_Date is null and Defense_Answer_To_Discovery_Due_Date is not null and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Defense Answers to our Discovery' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		UNION
		Select Case_Id, cd.DomainId, (Select top 1 Id from tblTriggerType where LTRIM(RTRIM(Name)) = 'Plaintiff Discovery Package' and DomainId = cd.DomainId) as TriggerTypeId, 0,0,0, cd.CreatedBy, GETDATE() 
		from tblCase_Date_Details cd inner join tbl_Client cl on cl.DomainId = cd.DomainId
			where Pretrial_Conf_Date is not null  and DATEDIFF(Day, Pretrial_Conf_Date, GETDATE()) > 2 and lower(cl.CompanyType) = 'funding' --DomainId = @s_a_DomainId
			and Case_Id not in (Select Case_Id from tblCaseWorkflowTriggerQueue q inner join tblTriggerType t on t.Id = q.TriggerTypeId
			where Case_Id=cd.Case_Id and LTRIM(RTRIM(Name)) = 'Plaintiff Discovery Package' and q.DomainId = cd.DomainId and Isnull(q.IsDeleted,0) = 0)
			and 
			(ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=cd.Case_Id and cas.DomainId=cd.DomainId),0)!=2)
			and
			(Select count(aa.Attorney_Id) from tblAttorney_Case_Assignment aa (NOLOCK) inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id 
			 Where aa.Case_Id =cd.Case_Id and aa.DomainId = cd.DomainId and Isnull(IsOutsideAttorney,0) != 1)>0
		
		
END
