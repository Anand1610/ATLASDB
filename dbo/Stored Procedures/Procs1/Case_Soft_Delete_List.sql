-- =============================================
-- Author:		Tausif Kazi
-- Create date: 06/25/2019
-- Description:	Soft deleted case list
-- =============================================
CREATE PROCEDURE Case_Soft_Delete_List
	@s_a_DomainId varchar(50)
AS
BEGIN
	   
	SET NOCOUNT ON  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	Declare @CompanyType varchar(150)=''
	Select TOP 1 @CompanyType = LOWER(LTRIM(RTRIM(CompanyType))) from tbl_Client(NOLOCK) Where DomainId=@s_a_DomainId

  Select  tblcase.Case_Id,     
   (InjuredParty_LastName + ',' + InjuredParty_FirstName) as InjuredParty_Name,    
   (Attorney_LastName + ',' + Attorney_FirstName) as Attorney_Name,  
   (Adjuster_LastName + ',' + Adjuster_FirstName)  as Adjuster_Name,  
   iif(@CompanyType!='funding', a_att.Assigned_Attorney,
   SUBSTRING(ISNULL(STUFF((
		SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
				FROM tblAttorney_Case_Assignment aa (NOLOCK) 
				inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
				Where aa.Case_Id = tblcase.Case_Id  and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @s_a_DomainId 
		for xml path('')
	),1,0,''),','),1,(LEN(ISNULL(STUFF(
	(
		SELECT COALESCE(isnull(Attorney_FirstName, '') + SPACE(1) + isnull( Attorney_LastName,'')+', ',' - ')
				FROM tblAttorney_Case_Assignment aa (NOLOCK) 
				inner join tblAttorney_Master am (NOLOCK) on am.Attorney_Id = aa.Attorney_Id inner join tblAttorney_Type atp (NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id
				Where aa.Case_Id = tblcase.Case_Id and Lower(Attorney_Type) = 'plaintiff attorney' and aa.DomainId = @s_a_DomainId
		for xml path('')
	),1,0,''),',')))-1)	)  AS Assigned_Attorney,
   Provider_Name,    
   tblprovider.Provider_GroupName,  
   InsuranceCompany_Name,    
   convert(varchar, Accident_Date, 101) as Accident_Date,    
   convert(varchar, ISNULL(tblCase.DateOfService_Start,''),101) as DateOfService_Start,    
   convert(varchar, ISNULL(tblCase.DateOfService_End,''),101) as DateOfService_End,    
   Status,    
   Rebuttal_Status,  
   Ins_Claim_Number,    
   Policy_Number,  
    --convert(varchar, Date_BillSent, 101) as Date_BillSent,    
    convert(varchar, ISNULL(tblCase.Date_BillSent,''),101) as Date_BillSent ,  
   convert(decimal(38,2),(convert(money,convert(float,Claim_Amount)))) as Claim_Amount,    
   convert(decimal(38,2),(convert(money,convert(float,Paid_Amount)))) as Paid_Amount,   
  
   (select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK)  where tblTransactions.case_id=tblcase.Case_Id and DomainId=@s_a_DomainId and Transactions_Type in ('PreC','PreCToP'))[Voluntary_Payment],
  
   (select convert(decimal(38,2),(convert(money,convert(float,sum(transactions_amount))))) from tblTransactions (NOLOCK) where tblTransactions.case_id=tblcase.Case_Id and DomainId=@s_a_DomainId and Transactions_Type in ('C','I'))[Collection_Payment],  
  
   convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)- ISNULL(WriteOff,0)))) as Claim_Balance,    
   convert(decimal(38,2),(convert(money,convert(float,Fee_Schedule)))) as FS_Amount,    
   convert(decimal(38,2),(convert(money,convert(float,Fee_Schedule) - convert(float,Paid_Amount)- ISNULL(WriteOff,0)))) as FS_Balance,   
   -- dbo.fncGetBillNumber(tblCase.Case_id) As BillNumber,  
   (select top 1 bill_number from tblTreatment (NOLOCK) where ISNULL(bill_number,'') <> '' and case_id = tblcase.case_id and domainid = tblcase.DomainId) as BillNumber,  
   --'' as BillNumber,  
   convert(varchar, ISNULL(tblCase.Date_Opened,''),101) as Date_Opened,  
   IndexOrAAA_Number,    
   tblCase.Initial_Status,  
   (Select top 1 a.Case_Id FROM  tblCase a (NOLOCK) WHERE a.Provider_Id =tblcase.Provider_Id  and a.InjuredParty_LastName =tblcase.InjuredParty_LastName    
   and a.InjuredParty_FirstName = tblcase.InjuredParty_FirstName and  a.Accident_Date =tblcase.Accident_Date     
   and a.Case_Id <> tblcase.case_id) AS Similar_To_Case_ID    
   , AF.Name AttorneyFirmName
   , PF.Name PortfolioName    
   ,ISNULL(tblCase.case_code,'') AS Reference_CaseId  
   , DenialReasons_Type AS DenialReasons  
   ,sta.forum  
   ,sta.Final_Status  
   ,p.PacketID  
   ,StatusDisposition  
   ,DateDiff(dd,ISNULL(Date_Status_Changed,Date_Opened),GETDATE()) AS Status_Age  
   , DateDiff(dd,Date_Opened,GETDATE()) AS Case_Age  
   ,(select top 1 ChequeNo from tblTransactions (NOLOCK) where ISNULL(ChequeNo,'') <> '' and case_id = tblcase.case_id and domainid = tblcase.DomainID) as ChequeNo  
  From tblcase as tblcase  (NOLOCK)  
  left join tblprovider  as tblprovider (NOLOCK) on tblcase.provider_id=tblprovider.provider_id     
  left join tblinsurancecompany as tblinsurancecompany (NOLOCK) on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id     
  left join tbl_portfolio PF (NOLOCK)on tblcase.PortfolioId=PF.id     
  left join tbl_AttorneyFirm AF (NOLOCK) on tblcase.AttorneyFirmId=AF.id    
  --left join tblStatus sta (NOLOCK) on tblcase.Status=sta.Status_Type  AND tblcase.DomainId= sta.DomainId  
  left JOIN dbo.tblStatus sta (NOLOCK) on tblcase.Status=sta.Status_Type AND tblcase.DomainId= sta.DomainId  
  left join tblPacket p (NOLOCK) on tblcase.FK_Packet_ID = p.Packet_Auto_ID  
  left join tblAttorney att (NOLOCK) on tblcase.Attorney_Id = att.Attorney_Id  
  left join tblAdjusters adj (NOLOCK) on tblcase.Adjuster_Id = adj.Adjuster_Id  
   LEFT OUTER JOIN dbo.Assigned_Attorney a_att (NOLOCK) ON tblcase.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID
  -- left join tblTransactions tra (NOLOCK) on tblcase.case_id = tra.Case_Id  
  WHERE tblcase.DomainId= @s_a_DomainId  
     AND ISNULL(tblcase.IsDeleted,0) = 1
   order by case_autoid desc     
    
END
