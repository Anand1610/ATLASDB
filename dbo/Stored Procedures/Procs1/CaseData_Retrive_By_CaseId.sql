CREATE PROCEDURE [dbo].[CaseData_Retrive_By_CaseId]  -- [CaseData_Retrive_By_CaseId] 'glf18-102242','glf'
     @s_a_Case_Id nVARCHAR(50)='',
	 @s_a_domain_id nVARCHAR(50)
  
AS    
BEGIN
    SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	declare @dt_settlement DATETIME
	declare @dt_paid_full DATETIME
	declare @dt_withdrawn DATETIME
	declare @dt_opened DATETIME
	declare @i_case_age INT
	declare @Min_DOS_Start DATETIME
    declare @Max_DOS_End DATETIME
	

	select  @Min_DOS_Start=min(DateOfService_Start),
			@Max_DOS_End=max(DateOfService_End)
	from tbltreatment (NOLOCK) where Case_Id = @s_a_Case_Id  
	

	set @dt_settlement = (select top 1 settlement_date from tblsettlements (NOLOCK) where case_id = @s_a_Case_Id)
	set @dt_paid_full = (select top 1 NOTES_DATE from TBLNOTES (NOLOCK) where DomainId =  cast(@s_a_domain_id as varchar(50)) 
																		AND case_id = cast(@s_a_Case_Id as varchar(50)) 
																		AND notes_desc like '%to paid-full%' ORDER BY NOTES_DATE DESC)
	set @dt_withdrawn = (select top 1 NOTES_DATE from TBLNOTES (NOLOCK) where DomainId =  cast(@s_a_domain_id as varchar(50)) 
																		AND case_id = cast(@s_a_Case_Id as varchar(50)) 
																		AND notes_desc like '%to WITHDRAWN%' ORDER BY NOTES_DATE DESC)
	select @dt_opened=date_opened from tblcase (NOLOCK) cas
	WHERE cas.DomainId =  cast(@s_a_domain_id as varchar(50)) 
	AND cas.Case_Id = cast(@s_a_Case_Id as varchar(50))
	
	if(@dt_settlement IS NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,getdate())
	END
	else IF(@dt_settlement IS NOT NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,@dt_settlement)
	END
	ELSE IF(@dt_paid_full IS NOT NULL AND @dt_settlement IS NULL AND @dt_withdrawn IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,@dt_paid_full)
	END
	ELSE IF(@dt_withdrawn IS NOT NULL AND @dt_paid_full IS NULL AND @dt_settlement IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,@dt_withdrawn)
	END
	ELSE
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,getdate())	
	END
    
   IF @s_a_domain_id = 'AMT' 
   BEGIN
	 select     
		    cas.Case_ID
		  , ISNULL(pro.Provider_Name,'N/A')Provider_Name
		  , ISNULL(ins.InsuranceCompany_Name,'N/A')InsuranceCompany_Name
		  , ISNULL(cas.Claim_Amount, '0.00')Claim_Amount
		  , ISNULL(cas.Fee_Schedule, '0.00')Fee_Schedule 
		  , ISNULL(cas.Paid_Amount, '0.00')Paid_Amount
		  , ISNULL(convert(nvarchar,@Min_DOS_Start,101),'N/A')[DOS_Start]
          , ISNULL(convert(nvarchar,@Max_DOS_End,101),'N/A') [DOS_End]
		  , cas.Initial_Status as Initial_Status
		  , cas.Status as Status
          , ISNULL(@i_case_age,'')[case_age]
		  , (select  ISNULL(convert(nvarchar,sum((Total_Collection+Pre_Interest)-(Deductible+Voluntary_AF))),'N/A') from tblTransactions tr WITH(NOLOCK) LEFT JOIN tbl_Voluntary_Payment VP WITH(NOLOCK) ON tr.Case_Id=VP.Case_Id AND VP.Transactions_Id=tr.Transactions_Id where tr.Case_Id=cas.Case_Id and tr.DomainId=cas.DomainId and tr.Transactions_Type in ('PreC','PreCToP')and VP.Payment_Type='V')[Voluntary_Payment]
		  , (select ISNULL(convert(nvarchar,sum((Litigated_Collection+Litigated_Interest)-(Litigation_Fees+Court_Fees))),'N/A') from tblTransactions tr WITH(NOLOCK) LEFT JOIN tbl_Voluntary_Payment VP WITH(NOLOCK) ON tr.Case_Id=VP.Case_Id AND VP.Transactions_Id=tr.Transactions_Id where tr.Case_Id=cas.Case_Id and tr.DomainId=cas.DomainId and tr.Transactions_Type in ('C','I') and VP.Payment_Type='L')[Collection_Payment]
		  , (Convert(decimal(18,2),ISNULL(cas.Claim_Amount, '0')) - Convert(decimal(18,2),ISNULL(cas.Paid_Amount, '0'))) as Total_Balance
		  --, @Balance as Total_Balance
		 --,(isnull(SUM(trmt.Claim_Amount),0) - isnull(SUM(trmt.Paid_Amount),0) - (select ISNULL(sum(Transactions_Amount),0) from tblTransactions tr where tr.Case_Id=cas.Case_Id and tr.DomainId=cas.DomainId and tr.Transactions_Type in ('C','I')))[Total_Balance]
     from tblcase cas (NOLOCK)
     INNER JOIN tblProvider pro (NOLOCK) on pro.DomainId= @s_a_domain_id AND cas.provider_id=pro.provider_id 
     INNER JOIN tblInsuranceCompany ins (NOLOCK) on ins.DomainId= @s_a_domain_id AND cas.insurancecompany_id=ins.insurancecompany_id 
	 --LEFT OUTER JOIN tblTreatment trmt (NOLOCK) ON  cas.Case_Id=  trmt.Case_Id
     WHERE cas.DomainId =  cast(@s_a_domain_id as varchar(50)) 
	 AND cas.Case_Id = cast(@s_a_Case_Id as varchar(50))
     GROUP BY 
		cas.Case_ID
		,cas.DomainId
	 , pro.Provider_Name
	 , ins.InsuranceCompany_Name
	 , cas.Initial_Status 
	 , cas.Status
	 , cas.Claim_Amount
	 , cas.Fee_Schedule
	 , cas.Paid_Amount
      END
	 ELSE
	 BEGIN
	 select     
		    cas.Case_ID
		  , ISNULL(pro.Provider_Name,'N/A')Provider_Name
		  , ISNULL(ins.InsuranceCompany_Name,'N/A')InsuranceCompany_Name
		  , ISNULL(cas.Claim_Amount, '0.00') AS Claim_Amount
		  , ISNULL(cas.Fee_Schedule, '0.00') AS Fee_Schedule
		  , ISNULL(cas.Paid_Amount, '0.00') AS Paid_Amount
		  , ISNULL(convert(nvarchar,@Min_DOS_Start,101),'N/A')[DOS_Start]
          , ISNULL(convert(nvarchar,@Max_DOS_End,101),'N/A') [DOS_End]
		  , cas.Initial_Status as Initial_Status
		  , cas.Status as Status
          , ISNULL(@i_case_age,'')[case_age]
		  , (select  ISNULL(convert(nvarchar,sum((Transactions_Amount))),'N/A') from tblTransactions tr  where tr.Case_Id=cas.Case_Id and tr.DomainId=cas.DomainId and tr.Transactions_Type in ('PreC','PreCToP'))[Voluntary_Payment]
		  , (select ISNULL(convert(nvarchar,sum((Transactions_Amount))),'N/A') from tblTransactions tr  where tr.Case_Id=cas.Case_Id and tr.DomainId=cas.DomainId and tr.Transactions_Type in ('C','I'))[Collection_Payment]
		  , (Convert(decimal(18,2),ISNULL(cas.Claim_Amount, '0')) - Convert(decimal(18,2),ISNULL(cas.Paid_Amount, '0')) - SUM(ISNULL(trmt.DeductibleAmount,0.00))) as Total_Balance
		 --, @Balance as Total_Balance
		 --,(isnull(SUM(trmt.Claim_Amount),0) - isnull(SUM(trmt.Paid_Amount),0) - (select ISNULL(sum(Transactions_Amount),0) from tblTransactions tr where tr.Case_Id=cas.Case_Id and tr.DomainId=cas.DomainId and tr.Transactions_Type in ('C','I')))[Total_Balance]
     from tblcase cas (NOLOCK)
     INNER JOIN tblProvider pro (NOLOCK) on pro.DomainId= @s_a_domain_id AND  cas.provider_id=pro.provider_id 
     INNER JOIN tblInsuranceCompany ins (NOLOCK) on ins.DomainId= @s_a_domain_id AND cas.insurancecompany_id=ins.insurancecompany_id 
	 LEFT OUTER JOIN tblTreatment trmt (NOLOCK) ON  cas.Case_Id=  trmt.Case_Id
     WHERE cas.DomainId =  cast(@s_a_domain_id as varchar(50)) 
	 AND cas.Case_Id = cast(@s_a_Case_Id as varchar(50))
     GROUP BY 
		cas.Case_ID
		,cas.DomainId
	 , pro.Provider_Name
	 , ins.InsuranceCompany_Name
	 , cas.Initial_Status 
	 , cas.Status
	 , cas.Claim_Amount
	 , cas.Fee_Schedule
	 , cas.Paid_Amount
	 END    
          
END

