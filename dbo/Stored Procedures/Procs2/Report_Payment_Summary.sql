-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Report_Payment_Summary] 
	-- Add the parameters for the stored procedure here
	@domainId				   nvarchar(50),
	@s_a_Transactions_Date_From	VARCHAR(20)=''	,
	@s_a_Transactions_Date_To	VARCHAR(20)='',
	@s_a_InjuredName	VARCHAR(100)	=	'',
	@s_a_Transactions_Type VARCHAR(10) ='0',
	@s_a_ProviderName varchar(100)='0',
	@s_a_ProviderGroup varchar(100)='',
	@s_a_InitialStatus varchar(100)='',
	@s_a_CheckNo varchar(100)='',
	@s_a_BatchNo varchar(100)='',
	@s_a_Report_Type varchar(100)='',
	@s_a_Note varchar(100)='',
	@s_a_Date_Of_Service_Start VARCHAR(20)='',
	@s_a_Date_Of_Service_End VARCHAR(20)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	  SELECT DISTINCT 'Voluntary' AS SummaryType,
	 max(pro.Provider_Name) AS Provider_Name,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) where DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('PreC'))),0.00) AS Principal ,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) where DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('PreI'))),0.00) AS Intrest,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) where DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('PreC','PreI'))),0.00) AS Total
		FROM  dbo.tblCase cas with(nolock)
		INNER JOIN dbo.tblprovider pro with(nolock) on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins with(nolock) on cas.insurancecompany_id=ins.insurancecompany_id
		INNER JOIN dbo.tblTreatment tre with(nolock) on tre.Case_Id= cas.Case_Id
		INNER JOIN tblTransactions trans with(nolock) on cas.case_id = trans.Case_Id
		LEFT JOIN tblOperatingDoctor doc with(nolock) on  doc.Doctor_Id =tre.Doctor_Id 
	    INNER JOIN tblTransactionType transtype with(nolock) on trans.Transactions_Type=transtype.payment_value

		WHERE
			cas.DomainId =@domainId
			AND ((@s_a_Transactions_Date_From='' or @s_a_Transactions_Date_To='') OR (trans.Transactions_Date Between CONVERT(datetime,@s_a_Transactions_Date_From) And CONVERT(datetime,@s_a_Transactions_Date_To)))		
			AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
			AND (@s_a_ProviderName = '0' OR cas.Provider_Id = @s_a_ProviderName)
			AND (@s_a_ProviderGroup = '' OR Provider_GroupName = @s_a_ProviderGroup)
			AND (@s_a_InitialStatus= '' OR Initial_Status = @s_a_InitialStatus)
			AND (@s_a_CheckNo ='' OR trans.ChequeNo like '%'+ @s_a_CheckNo + '%')
			AND (@s_a_BatchNo ='' OR trans.BatchNo like '%'+ @s_a_BatchNo + '%')
			AND (@s_a_Transactions_Type = '0' OR trans.Transactions_Type = @s_a_Transactions_Type)
			AND (@s_a_Report_Type='' OR transtype.Report_Type=@s_a_Report_Type)
			AND (@s_a_Note='' OR trans.Transactions_Description like '%'+@s_a_Note+'%')
			AND ((@s_a_Date_Of_Service_Start='' OR @s_a_Date_Of_Service_End='') OR 
			(convert(datetime,tre.DateOfService_Start)>=convert(datetime,@s_a_Date_Of_Service_Start)
			and convert(datetime,tre.DateOfService_End)<=convert(datetime,@s_a_Date_Of_Service_End)
			))
			Group by 
			trans.Transactions_Id
			, trans.ChequeNo
			, trans.CheckDate
			, trans.Transactions_Amount
			, trans.Transactions_Date
			, trans.Transactions_Type
			, trans.BatchNo
			, trans.Transactions_Description
			, trans.User_Id
			, cas.DomainId
			, cas.Case_Id
			, transtype.Report_Type
			,pro.Provider_Id
			
			UNION
			SELECT DISTINCT 'Voluntary Direct' AS SummaryType,
	 max(pro.Provider_Name) AS Provider_Name,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) where DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('PreCToP'))),0.00) AS Principal ,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) where DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('ID'))),0.00) AS Intrest,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) where DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('PreCToP','ID'))),0.00) AS Total
		FROM  dbo.tblCase cas with(nolock)
		INNER JOIN dbo.tblprovider pro with(nolock) on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins with(nolock) on cas.insurancecompany_id=ins.insurancecompany_id
		INNER JOIN dbo.tblTreatment tre with(nolock) on tre.Case_Id= cas.Case_Id
		INNER JOIN tblTransactions trans with(nolock) on cas.case_id = trans.Case_Id
		LEFT JOIN tblOperatingDoctor doc with(nolock) on  doc.Doctor_Id =tre.Doctor_Id 
	    INNER JOIN tblTransactionType transtype with(nolock) on trans.Transactions_Type=transtype.payment_value

		WHERE
			cas.DomainId =@domainId
			AND ((@s_a_Transactions_Date_From='' or @s_a_Transactions_Date_To='') OR (trans.Transactions_Date Between CONVERT(datetime,@s_a_Transactions_Date_From) And CONVERT(datetime,@s_a_Transactions_Date_To)))		
			AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
			AND (@s_a_ProviderName = '0' OR cas.Provider_Id = @s_a_ProviderName)
			AND (@s_a_ProviderGroup = '' OR Provider_GroupName = @s_a_ProviderGroup)
			AND (@s_a_InitialStatus= '' OR Initial_Status = @s_a_InitialStatus)
			AND (@s_a_CheckNo ='' OR trans.ChequeNo like '%'+ @s_a_CheckNo + '%')
			AND (@s_a_BatchNo ='' OR trans.BatchNo like '%'+ @s_a_BatchNo + '%')
			AND (@s_a_Transactions_Type = '0' OR trans.Transactions_Type = @s_a_Transactions_Type)
			AND (@s_a_Report_Type='' OR transtype.Report_Type=@s_a_Report_Type)
			AND (@s_a_Note='' OR trans.Transactions_Description like '%'+@s_a_Note+'%')
			AND ((@s_a_Date_Of_Service_Start='' OR @s_a_Date_Of_Service_End='') OR 
			(convert(datetime,tre.DateOfService_Start)>=convert(datetime,@s_a_Date_Of_Service_Start)
			and convert(datetime,tre.DateOfService_End)<=convert(datetime,@s_a_Date_Of_Service_End)
			))
			Group by 
			trans.Transactions_Id
			, trans.ChequeNo
			, trans.CheckDate
			, trans.Transactions_Amount
			, trans.Transactions_Date
			, trans.Transactions_Type
			, trans.BatchNo
			, trans.Transactions_Description
			, trans.User_Id
			, cas.DomainId
			, cas.Case_Id
			, transtype.Report_Type
			,pro.Provider_Id
			
			UNION
			SELECT DISTINCT 'Settlement' AS SummaryType,
	 max(pro.Provider_Name) AS Provider_Name,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) INNER join tblSettlements (NOLOCK) Sett ON tblTransactions.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id  where tblTransactions.DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('C') AND Set_Ty.Settlement_Type IN ('Settled/Court','Settled/Phone'))),0.00) AS Principal ,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) INNER join tblSettlements (NOLOCK) Sett ON tblTransactions.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id where tblTransactions.DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('I') AND Set_Ty.Settlement_Type IN ('Settled/Court','Settled/Phone'))),0.00) AS Intrest,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) INNER join tblSettlements (NOLOCK) Sett ON tblTransactions.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id where tblTransactions.DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('C','I') AND Set_Ty.Settlement_Type IN ('Settled/Court','Settled/Phone'))),0.00) AS Total
		FROM  dbo.tblCase cas with(nolock)
		INNER JOIN dbo.tblprovider pro with(nolock) on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins with(nolock) on cas.insurancecompany_id=ins.insurancecompany_id
		INNER JOIN dbo.tblTreatment tre with(nolock) on tre.Case_Id= cas.Case_Id
		INNER JOIN tblTransactions trans with(nolock) on cas.case_id = trans.Case_Id
		LEFT JOIN tblOperatingDoctor doc with(nolock) on  doc.Doctor_Id =tre.Doctor_Id 
	    INNER JOIN tblTransactionType transtype with(nolock) on trans.Transactions_Type=transtype.payment_value

		WHERE
			cas.DomainId =@domainId
			AND ((@s_a_Transactions_Date_From='' or @s_a_Transactions_Date_To='') OR (trans.Transactions_Date Between CONVERT(datetime,@s_a_Transactions_Date_From) And CONVERT(datetime,@s_a_Transactions_Date_To)))		
			AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
			AND (@s_a_ProviderName = '0' OR cas.Provider_Id = @s_a_ProviderName)
			AND (@s_a_ProviderGroup = '' OR Provider_GroupName = @s_a_ProviderGroup)
			AND (@s_a_InitialStatus= '' OR Initial_Status = @s_a_InitialStatus)
			AND (@s_a_CheckNo ='' OR trans.ChequeNo like '%'+ @s_a_CheckNo + '%')
			AND (@s_a_BatchNo ='' OR trans.BatchNo like '%'+ @s_a_BatchNo + '%')
			AND (@s_a_Transactions_Type = '0' OR trans.Transactions_Type = @s_a_Transactions_Type)
			AND (@s_a_Report_Type='' OR transtype.Report_Type=@s_a_Report_Type)
			AND (@s_a_Note='' OR trans.Transactions_Description like '%'+@s_a_Note+'%')
			AND ((@s_a_Date_Of_Service_Start='' OR @s_a_Date_Of_Service_End='') OR 
			(convert(datetime,tre.DateOfService_Start)>=convert(datetime,@s_a_Date_Of_Service_Start)
			and convert(datetime,tre.DateOfService_End)<=convert(datetime,@s_a_Date_Of_Service_End)
			))
			Group by 
			trans.Transactions_Id
			, trans.ChequeNo
			, trans.CheckDate
			, trans.Transactions_Amount
			, trans.Transactions_Date
			, trans.Transactions_Type
			, trans.BatchNo
			, trans.Transactions_Description
			, trans.User_Id
			, cas.DomainId
			, cas.Case_Id
			, transtype.Report_Type
			,pro.Provider_Id
			
			UNION
			SELECT DISTINCT 'Awarded' AS SummaryType,
	 max(pro.Provider_Name) AS Provider_Name,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) INNER join tblSettlements (NOLOCK) Sett ON tblTransactions.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id  where tblTransactions.DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('C') AND Set_Ty.Settlement_Type NOT IN ('Settled/Court','Settled/Phone'))),0.00) AS Principal ,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) INNER join tblSettlements (NOLOCK) Sett ON tblTransactions.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id where tblTransactions.DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('I') AND Set_Ty.Settlement_Type NOT IN ('Settled/Court','Settled/Phone'))),0.00) AS Intrest,
			ISNULL(convert(decimal(38,2),(select sum(Transactions_Amount) from tblTransactions(NOLOCK) INNER join tblSettlements (NOLOCK) Sett ON tblTransactions.Case_Id=Sett.Case_Id INNER JOIN tblSettlement_Type (NOLOCK) Set_Ty ON Sett.Settled_Type=Set_Ty.SettlementType_Id where tblTransactions.DomainId= cas.DomainId AND tblTransactions.Provider_Id=pro.Provider_Id  and Transactions_Type IN ('C','I') AND Set_Ty.Settlement_Type NOT IN ('Settled/Court','Settled/Phone'))),0.00) AS Total
		FROM  dbo.tblCase cas with(nolock)
		INNER JOIN dbo.tblprovider pro with(nolock) on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins with(nolock) on cas.insurancecompany_id=ins.insurancecompany_id
		INNER JOIN dbo.tblTreatment tre with(nolock) on tre.Case_Id= cas.Case_Id
		INNER JOIN tblTransactions trans with(nolock) on cas.case_id = trans.Case_Id
		LEFT JOIN tblOperatingDoctor doc with(nolock) on  doc.Doctor_Id =tre.Doctor_Id 
	    INNER JOIN tblTransactionType transtype with(nolock) on trans.Transactions_Type=transtype.payment_value

		WHERE
			cas.DomainId =@domainId
			AND ((@s_a_Transactions_Date_From='' or @s_a_Transactions_Date_To='') OR (trans.Transactions_Date Between CONVERT(datetime,@s_a_Transactions_Date_From) And CONVERT(datetime,@s_a_Transactions_Date_To)))		
			AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
			AND (@s_a_ProviderName = '0' OR cas.Provider_Id = @s_a_ProviderName)
			AND (@s_a_ProviderGroup = '' OR Provider_GroupName = @s_a_ProviderGroup)
			AND (@s_a_InitialStatus= '' OR Initial_Status = @s_a_InitialStatus)
			AND (@s_a_CheckNo ='' OR trans.ChequeNo like '%'+ @s_a_CheckNo + '%')
			AND (@s_a_BatchNo ='' OR trans.BatchNo like '%'+ @s_a_BatchNo + '%')
			AND (@s_a_Transactions_Type = '0' OR trans.Transactions_Type = @s_a_Transactions_Type)
			AND (@s_a_Report_Type='' OR transtype.Report_Type=@s_a_Report_Type)
			AND (@s_a_Note='' OR trans.Transactions_Description like '%'+@s_a_Note+'%')
			AND ((@s_a_Date_Of_Service_Start='' OR @s_a_Date_Of_Service_End='') OR 
			(convert(datetime,tre.DateOfService_Start)>=convert(datetime,@s_a_Date_Of_Service_Start)
			and convert(datetime,tre.DateOfService_End)<=convert(datetime,@s_a_Date_Of_Service_End)
			))
			Group by 
			trans.Transactions_Id
			, trans.ChequeNo
			, trans.CheckDate
			, trans.Transactions_Amount
			, trans.Transactions_Date
			, trans.Transactions_Type
			, trans.BatchNo
			, trans.Transactions_Description
			, trans.User_Id
			, cas.DomainId
			, cas.Case_Id
			, transtype.Report_Type
			,pro.Provider_Id
			OPTION	(RECOMPILE)
END
