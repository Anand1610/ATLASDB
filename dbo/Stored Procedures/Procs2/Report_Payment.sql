CREATE PROCEDURE [dbo].[Report_Payment]  -- [Report_Payment] 'af',@s_a_Transactions_Type_mul='af,D'
 @domainId       nvarchar(50),  
 @s_a_Transactions_Date_From VARCHAR(20)='' ,  
 @s_a_Transactions_Date_To VARCHAR(20)='',  
 @s_a_InjuredName VARCHAR(100) = '',  
 @s_a_Transactions_Type VARCHAR(10) ='0',  
 @s_a_ProviderName varchar(100)='0',  
 @s_a_ProviderGroup varchar(100)='',  
 @s_a_InitialStatus varchar(100)='',  
 @s_a_CheckNo varchar(100)='',  
 @s_a_BatchNo varchar(100)='',  
 @s_a_Report_Type varchar(100)='',  
 @s_a_Note varchar(100)='',  
 @s_a_Date_Of_Service_Start VARCHAR(20)='',  
 @s_a_Date_Of_Service_End VARCHAR(20)='' ,
 @s_a_Portfolio_Id INT=0,
 @s_a_Transactions_Type_mul VARCHAR(1000) =''

  
AS  
BEGIN  

    
	select tre.Case_Id,
max(tre.BILL_NUMBER) BILL_NUMBER,
min(tre.DateOfService_Start) [DateOfService_Start],
max(tre.DateOfService_End) [DateOfService_End],
max(tre.Date_BillSent) Date_BillSent,
max(tre.SERVICE_TYPE) SERVICE_TYPE
into #temp
 from tblTreatment tre where tre.DomainId=@domainId
 group by tre.Case_Id




   

select  
trans.Transactions_Id,   
trans.Case_Id as Case_Id,
tre.BILL_NUMBER AS BILL_NUMBER,
tre.DateOfService_Start AS DateOfService_Start,  
tre.DateOfService_End AS DateOfService_End, 
pro.Provider_Name  AS Provider_Name, 

cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,
LTRIM(RTRIM(LEFT(ins.InsuranceCompany_Name,15))) AS InsuranceCompany_Name,   
  cas.IndexOrAAA_Number,
   (CASE WHEN Date_AAA_Arb_Filed IS NULL OR Date_AAA_Arb_Filed = '' THEN ''
				ELSE convert(varchar(10), Date_AAA_Arb_Filed,101)
				END
		) AS Date_AAA_Arb_Filed,
	(CASE WHEN Date_Index_Number_Purchased IS NULL OR Date_Index_Number_Purchased = '' THEN ''
				ELSE convert(varchar(10), Date_Index_Number_Purchased,101)
				END
		) AS Date_Index_Number_Purchased,
   trans.ChequeNo,  
   trans.CheckDate,  
pro.Provider_Local_Address  AS Provider_Local_Address,
  convert(decimal(38,2),trans.Transactions_Amount) AS Transactions_Amount,  
 CONVERT(VARCHAR(10),(tre.Date_BillSent), 101) AS BillDate_submitted,
    CONVERT(VARCHAR(10), trans.Transactions_Date, 101) AS Payment_date,  
   trans.Transactions_Type,  
   transtype.Report_Type,  
   (tre.SERVICE_TYPE) AS SERVICE_TYPE,  
   trans.BatchNo,  
   trans.Transactions_Description,  
   trans.User_Id,  
     convert(decimal(38,2),(convert(money,convert(float,(cas.Claim_Amount))))) as Claim_Amount,  
   convert(decimal(38,2),(convert(money,convert(float,(cas.Paid_Amount))))) as Paid_Amount,  
   convert(decimal(38,2),(convert(money,convert(float,(cas.Claim_Amount)) - convert(float,(cas.Paid_Amount))))) as Claim_Balance,  
   convert(decimal(38,2),(convert(money,convert(float,(cas.Fee_Schedule))))) as Fee_Schedule,  
   convert(decimal(38,2),(convert(money,convert(float,(cas.Fee_Schedule)) - convert(float,(cas.Paid_Amount))))) as FS_Balance,  
   (cas.Initial_Status) AS Initial_Status,  
   (pro.Provider_GroupName) AS Provider_GroupName,
 isnull(convert(decimal(38,2),(select sum(isnull(tblTransactions.Transactions_Amount,0)) from tblTransactions(NOLOCK) where tblTransactions.DomainId= cas.DomainId and tblTransactions.case_id = cas.Case_Id and tblTransactions.Transactions_Type IN ('C','PreC','ProCToP'))),0) AS Paid_Principal ,  
   convert(decimal(38,2),(convert(money,convert(float,(cas.Claim_Amount)) - convert(float,(select isnull( sum(isnull(tblTransactions.Transactions_Amount,0)),0) 
   from tblTransactions(NOLOCK) where tblTransactions.DomainId= cas.DomainId and tblTransactions.case_id = cas.Case_Id and tblTransactions.Transactions_Type IN ('C','PreC','ProCToP
')))))) as Calim_Pricipal_Balance  ,
case when cas.portfolioid is null or cas.portfolioid =0 then '' else  ISNULL(port.Name,'') end AS PortfolioName
  FROM  tblCase cas with(nolock)  
  JOIN tblprovider pro with(nolock) on cas.provider_id=pro.provider_id   
  JOIN tblinsurancecompany ins with(nolock) on cas.insurancecompany_id=ins.insurancecompany_id  
 LEFT JOIN #temp tre with(nolock) on tre.Case_Id= cas.Case_Id  
  JOIN tblTransactions trans with(nolock) on cas.case_id = trans.Case_Id  
--  LEFT JOIN tblOperatingDoctor doc with(nolock) on  doc.Doctor_Id =tre.Doctor_Id   
  JOIN tblTransactionType transtype with(nolock) on trans.Transactions_Type=transtype.payment_value
  left join  tbl_Portfolio port on port.id=cas.PortfolioId
	
  WHERE  
   cas.DomainId =@domainId  AND ISNULL(cas.IsDeleted, 0) = 0  and ((@domainId='JL' and Transactions_Type!='FFB') OR @domainId!='JL')
   AND ((@s_a_Transactions_Date_From='' or @s_a_Transactions_Date_To='') OR (trans.Transactions_Date Between CONVERT(datetime,@s_a_Transactions_Date_From) And CONVERT(datetime,@s_a_Transactions_Date_To)))    
   AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%' 
 OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')  
   AND (@s_a_ProviderName = '0' OR cas.Provider_Id = @s_a_ProviderName)  
   AND (@s_a_ProviderGroup = '' OR Provider_GroupName = @s_a_ProviderGroup)  
   AND (@s_a_InitialStatus= '' OR Initial_Status = @s_a_InitialStatus)  
   AND (@s_a_CheckNo ='' OR trans.ChequeNo like '%'+ @s_a_CheckNo + '%')  
   AND (@s_a_BatchNo ='' OR trans.BatchNo like '%'+ @s_a_BatchNo + '%')  
   AND (@s_a_Transactions_Type = '0' OR trans.Transactions_Type = @s_a_Transactions_Type) 
    AND (@s_a_Transactions_Type_mul = '' OR trans.Transactions_Type in( select items from [dbo].[STRING_SPLIT](@s_a_Transactions_Type_mul,',')) ) 
   AND (@s_a_Report_Type='' OR transtype.Report_Type=@s_a_Report_Type)  
   AND (@s_a_Note='' OR trans.Transactions_Description like '%'+@s_a_Note+'%')  
   AND ((@s_a_Date_Of_Service_Start='' OR @s_a_Date_Of_Service_End='') OR   
   (convert(datetime,tre.DateOfService_Start)>=convert(datetime,@s_a_Date_Of_Service_Start)  
   and convert(datetime,tre.DateOfService_End)<=convert(datetime,@s_a_Date_Of_Service_End)  
   
   ))  
   AND   ((@s_a_Portfolio_Id = 0 ) OR port.Id = @s_a_Portfolio_Id) 
  
  order by trans.Case_Id,tre.BILL_NUMBER 

  OPTION (RECOMPILE)  

END  