-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Retrive_Provider_Inventory_Details] 
	-- Add the parameters for the stored procedure here
	@i_a_Provider_Id INT,
	@s_a_provider_group varchar(50),
	@s_a_InventoryType nvarchar(500),
	@s_a_DomainId nvarchar(50),
	@s_a_Status VARCHAR(500),
	@s_a_Year VARCHAR(50),
	@i_a_Insurance_Id INT,
	@s_a_Start_Yr varchar(50),
	@s_a_Open_Yr varchar(50),
	@s_a_Resolve_Yr varchar(50),
	@s_a_Resolve_Month VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@s_a_InventoryType = 'Year_Opened')
	BEGIN
	Select Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
			, Year(Date_Opened) as  StatusYear
	  from tblCase C (NOLOCK) INNER JOIN dbo.tblProvider (NOLOCK) ON C.Provider_Id = dbo.tblProvider.Provider_Id AND c.DomainId=tblProvider.DomainId  where  (@i_a_Provider_Id = 0 OR tblProvider.Provider_Id = @i_a_Provider_Id )  and (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group) AND C.DomainId=@s_a_DomainId AND Year(Date_Opened)=@s_a_Year
	END

	IF(@s_a_InventoryType = 'Earliest_Service_Year')
	BEGIN
	Select T.Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			(Select Provider_Name from tblProvider (NOLOCK) WHERE tblProvider.Provider_Id=tblcase.Provider_Id AND tblcase.DomainId=tblProvider.DomainId) AS Provider_Name,
			(Select Provider_GroupName from tblProvider (NOLOCK) WHERE tblProvider.Provider_Id=tblcase.Provider_Id AND tblcase.DomainId=tblProvider.DomainId) AS Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  tblcase.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),tblcase.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),tblcase.DateOfService_End, 111)) AS DOS
				,ISNULL(T.Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
 from tblTreatment T (NOLOCK) INNER JOIN tblCase  (NOLOCK) ON tblcase.Case_Id=T.Case_Id
  where T.Case_Id in (Select Case_Id from tblCase C (NOLOCK)
  INNER JOIN dbo.tblProvider (NOLOCK) ON C.Provider_Id = dbo.tblProvider.Provider_Id AND c.DomainId=tblProvider.DomainId
  
   where    (@i_a_provider_id = 0 OR tblProvider.Provider_Id = @i_a_provider_id)  and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group AND c.DomainId=@s_a_DomainId)) 
  and (T.DateOfService_Start = (Select Min(DateOfService_Start) from tblTreatment TT (NOLOCK) Where TT.Case_Id = T.Case_Id AND TT.DomainId=T.DomainId)
   or T.DateOfService_Start is null) AND Year(T.DateOfService_Start)=@s_a_Year AND T.DomainId=@s_a_DomainId
	END

	IF(@s_a_InventoryType = 'Status_Open')
	BEGIN
	SELECT Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
	FROM tblStatus S (NOLOCK)
	INNER JOIN tblcase C  (NOLOCK)ON S.Status_Type = C.Status AND C.DomainId=S.DomainId
	INNER JOIN dbo.tblProvider (NOLOCK) ON C.Provider_Id = dbo.tblProvider.Provider_Id  AND c.DomainId=tblProvider.DomainId
	WHERE   S.Final_Status='open' 
	 and   (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id )  
	 and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)
	 AND c.DomainId=@s_a_DomainId
	 AND c.Status=@s_a_Status
	 
	order by Status_Type
	END

	IF(@s_a_InventoryType = 'Carrier_Open')
	BEGIN
	Select C.Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(C.Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
	from tblCase C (NOLOCK)  inner join tblProvider (NOLOCK) ON c.Provider_Id=tblProvider.Provider_Id INNER JOIN tblTreatment (NOLOCK) T ON C.Case_Id=T.Case_Id  left outer join tblStatus S (NOLOCK) on C.Status = S.Status_Type AND C.DomainId=S.DomainId	
	where   C.Provider_Id=@i_a_Provider_Id AND C.DomainId=@s_a_DomainId  and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)  and S.Final_Status='open'  AND InsuranceCompany_Id=@i_a_Insurance_Id 
	END

	IF(@s_a_InventoryType = 'Resolved_Carrier')
	BEGIN
	Select C.Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			I.InsuranceCompany_Name As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(C.Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
		  from tblCase C (NOLOCK) left outer join tblStatus S (NOLOCK) on C.Status = S.Status_Type AND C.DomainId=S.DomainId
	left join tblInsuranceCompany I (NOLOCK) on C.InsuranceCompany_Id = I.InsuranceCompany_Id AND C.DomainId=I.DomainId
	left join tblSettlements ST (NOLOCK) on C.Case_Id = ST.Case_Id AND C.DomainId=ST.DomainId
	left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
	where  (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id )   AND C.DomainId=@s_a_DomainId    and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)	
	and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,ST.Settlement_Amount)+Convert(money,ST.Settlement_Int))>0 AND I.InsuranceCompany_Id=@i_a_Insurance_Id
	END

	IF(@s_a_InventoryType = 'Resolved_ServiceYr_DtOpen' OR @s_a_InventoryType = 'Resolved_DtOpen_ServiceYr')
	BEGIN
	
Select C.Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(C.Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number		
	from tblTreatment T (NOLOCK)
   left join tblCase C (NOLOCK) on T.Case_Id = C.Case_Id AND T.DomainId=C.DomainId left join tblSettlements S (NOLOCK) on T.Treatment_Id = S.Treatment_Id AND T.DomainId=S.DomainId 
   left join tblStatus ST (NOLOCK) on C.Status = ST.Status_Type AND C.DomainId=ST.DomainId 
  left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
   where T.Case_Id in (Select Case_Id from tblCase (NOLOCK)  where   (@i_a_provider_id = 0 OR Provider_Id = @i_a_provider_id )   
	  AND tblcase.DomainId=@s_a_DomainId   and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) 
   and (T.DateOfService_Start = (Select Min(DateOfService_Start) from tblTreatment TT (NOLOCK) Where TT.Case_Id = T.Case_Id)
   or T.DateOfService_Start is null) 
   and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,S.Settlement_Amount)+Convert(money,S.Settlement_Int))>0
   AND T.DomainId=@s_a_DomainId
   AND (@s_a_Start_Yr = '' OR Year(T.DateOfService_Start) = @s_a_Start_Yr ) 
    AND (@s_a_Open_Yr = '' OR Year(C.Date_Opened) = @s_a_Open_Yr )   
    order by T.DateOfService_Start
	END

	IF(@s_a_InventoryType = 'Resolved_ResolveYr_DtOpen')
	BEGIN
	Select C.Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(C.Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number		
	from tblTreatment T (NOLOCK)
   left join tblCase C (NOLOCK) on T.Case_Id = C.Case_Id AND C.DomainId=T.DomainId left join tblSettlements S (NOLOCK) on T.Treatment_Id = S.Treatment_Id AND T.DomainId=S.DomainId
   left join tblStatus ST (NOLOCK) on C.Status = ST.Status_Type AND C.DomainId=ST.DomainId
   left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
   where T.Case_Id in (Select Case_Id from tblCase (NOLOCK)  where  (@i_a_provider_id = 0 OR Provider_Id = @i_a_provider_id )  
   AND tblcase.DomainId=@s_a_DomainId  and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) 
   and (T.DateOfService_Start = (Select Min(DateOfService_Start) from tblTreatment TT (NOLOCK) Where TT.Case_Id = T.Case_Id)
   or T.DateOfService_Start is null) 
   and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,S.Settlement_Amount)+Convert(money,S.Settlement_Int))>0
   AND T.DomainId=@s_a_DomainId
  AND (@s_a_Open_Yr = '' OR Year(C.Date_Opened) = @s_a_Open_Yr )  
  AND (@s_a_Resolve_Yr = '' OR Year(S.Settlement_Date) = @s_a_Resolve_Yr )
   order by Settlement_Date
	END

	IF(@s_a_InventoryType = 'Resolved_ResolveYr_ServiceYr')
	BEGIN
	Select  C.Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(C.Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
	from tblTreatment T (NOLOCK)
   left join tblCase C (NOLOCK) on T.Case_Id = C.Case_Id AND T.DomainId=C.DomainId left join tblSettlements S (NOLOCK) on T.Treatment_Id = S.Treatment_Id AND T.DomainId=S.DomainId
   left join tblStatus ST (NOLOCK) on C.Status = ST.Status_Type AND C.DomainId=ST.DomainId
   left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
   where T.Case_Id in (Select Case_Id from tblCase (NOLOCK)  where (@i_a_provider_id = 0 OR Provider_Id = @i_a_provider_id )   
    AND tblcase.DomainId=@s_a_DomainId  and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) 
   and (T.DateOfService_Start = (Select Min(DateOfService_Start) from tblTreatment TT (NOLOCK) Where TT.Case_Id = T.Case_Id)
   or T.DateOfService_Start is null) 
   and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,S.Settlement_Amount)+Convert(money,S.Settlement_Int))>0
   AND T.DomainId=@s_a_DomainId
  AND (@s_a_Resolve_Yr = '' OR Year(S.Settlement_Date) = @s_a_Resolve_Yr )
  AND (@s_a_Start_Yr = '' OR Year(T.DateOfService_Start) = @s_a_Start_Yr ) 
   order by Settlement_Date
	END

	IF(@s_a_InventoryType = 'Resolved_ResolveYr_DtOpen_ServiceYr' OR @s_a_InventoryType = 'Resolved_ResolveYr_ServiceYr_DtOpen')
	BEGIN
	Select C.Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(C.Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
	from tblTreatment T (NOLOCK)
   left join tblCase C (NOLOCK) on T.Case_Id = C.Case_Id AND C.DomainId=T.DomainId left join tblSettlements S (NOLOCK) on T.Treatment_Id = S.Treatment_Id AND T.DomainId=S.DomainId
   left join tblStatus ST (NOLOCK) on C.Status = ST.Status_Type AND C.DomainId=ST.DomainId
   left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
   where T.Case_Id in (Select Case_Id from tblCase (NOLOCK)  where  (@i_a_provider_id = 0 OR Provider_Id = @i_a_provider_id )   
    AND tblcase.DomainId=@s_a_DomainId  and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) 
   and (T.DateOfService_Start = (Select Min(DateOfService_Start) from tblTreatment TT (NOLOCK) Where TT.Case_Id = T.Case_Id)
   or T.DateOfService_Start is null) 
   and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,S.Settlement_Amount)+Convert(money,S.Settlement_Int))>0
   AND T.DomainId=@s_a_DomainId
   AND (@s_a_Resolve_Yr = '' OR Year(S.Settlement_Date) = @s_a_Resolve_Yr )
  AND (@s_a_Start_Yr = '' OR Year(T.DateOfService_Start) = @s_a_Start_Yr )
   AND (@s_a_Open_Yr = '' OR Year(C.Date_Opened) = @s_a_Open_Yr ) 
    order by Settlement_Date
	END

	IF(@s_a_InventoryType = 'Open_YrOpen')
	BEGIN
	Select Case_Id 
,PatientName
 ,Provider_Name,
Provider_GroupName
,OpenedDate
,DOS
,Claim_Amount
, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
				,Final_Status
		  From
			 (Select Year(Date_Opened) As OpenedYear
		      ,C.Case_Id
			  ,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName
			   ,Provider_Name,
			Provider_GroupName,
			CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
			, Status
				, IndexOrAAA_Number
			  ,(Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) As Settlement_PI
			  ,Year(Settlement_Date) As Settled_Year
			  ,Claim_Amount
			  --,(Select sum(Fee_Schedule) From tblTreatment T (NOLOCK) where T.Case_Id=C.Case_Id AND C.DomainId=T.DomainId) As Fee_Schedule
			  ,CASE 
			  WHEN Final_Status ='OPEN' AND ISNULL(Settlement_Date,'')='' THEN 'Awaiting'
			  WHEN Final_Status Like 'CLOSED%' AND ISNULL(Settlement_Date,'')='' THEN 'Awaiting'
			  WHEN Final_Status ='OPEN' AND (Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) > 0 THEN 'Settled'
			  WHEN (Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) = 0 AND ISNULL(Settlement_Date,'')<> '' THEN 'Awaiting'
			  WHEN Final_Status Like 'CLOSED%' AND (Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) > 0 THEN 'Settled'
		  END AS Final_Status
	from tblCase C (NOLOCK) left join tblStatus S (NOLOCK) on C.Status=S.Status_Type AND C.DomainId=S.DomainId  
	left join tblSettlements ST (NOLOCK) on C.Case_Id = ST.Case_Id AND C.DomainId=ST.DomainId
	left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
	where  (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id ) AND C.DomainId=@s_a_DomainId   
	 and
	 (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) A WHERE (@s_a_Open_Yr = '' OR Year(OpenedDate) = @s_a_Open_Yr )
	 AND (iif(Final_Status='Awaiting','Awaiting Resolution', Concat('Resolved in ',Settled_Year))=@s_a_Status)
	END

	IF(@s_a_InventoryType = 'Status_Final')
	BEGIN
	Select Case_Id
			,PatientName,
			Provider_Name,
			Provider_GroupName,
			InsuranceCompany_Name
			,OpenedDate
			,DOS
				,Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
		,Final_Status 
		
		from
       (Select C.Case_Id
	   ,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
	   Provider_Name,
			Provider_GroupName,
			C.InsuranceCompany_Id,
			CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate,
			CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
			  ,(Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) As Settlement_PI
			  ,Claim_Amount
			  , Status
				, IndexOrAAA_Number,
				(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			  --,(Select sum(Fee_Schedule) From tblTreatment T (NOLOCK) where T.Case_Id=C.Case_Id AND C.DomainId=T.DomainId) As Fee_Schedule
			  ,CASE 
			  WHEN Final_Status ='OPEN' AND ISNULL(Settlement_Date,'')='' THEN '(In Play) Awaiting Resolution'
			  WHEN Final_Status Like 'CLOSED%' AND ISNULL(Settlement_Date,'')='' THEN 'Closed Without Resolution'
			  WHEN Final_Status ='OPEN' AND (Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) > 0 THEN '(In Play) Settled-Open Awaiting Payment'
			  WHEN (Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) = 0 AND ISNULL(Settlement_Date,'')<> '' THEN 'Settled-Loss'
			  WHEN Final_Status Like 'CLOSED%' AND (Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) > 0 THEN 'Settled-Closed'
		  END AS Final_Status
	from tblCase C (NOLOCK) left join tblStatus S (NOLOCK) on C.Status=S.Status_Type AND C.DomainId=S.DomainId  
	left join tblSettlements ST (NOLOCK) on C.Case_Id = ST.Case_Id AND C.DomainId=ST.DomainId
	left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
	where    (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id ) AND C.DomainId=@s_a_DomainId 	
	 and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group))   A WHERE Final_Status=@s_a_Status
	END

	IF(@s_a_InventoryType = 'InPlay_SettleClose_YrOpen' OR @s_a_InventoryType = 'InPlay_SettleClose_YrOpen_SettleYr')
BEGIN

 Select  Case_Id
		,PatientName,
		 Provider_Name,
			Provider_GroupName,
			OpenedDate,
			DOS       
		, Claim_Amount
		, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number
		,Final_Status 
		
		from
       (Select Year(Date_Opened) As OpenedYear, C.Case_Id,
	   CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
	   Provider_Name,
			Provider_GroupName,
			CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate,
			CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
			  ,(iif(Convert(money,ST.Settlement_Amount) is null, 0, Convert(money,ST.Settlement_Amount)) + iif(Convert(money,ST.Settlement_Int) is null, 0, Convert(money,ST.Settlement_Int))) As Settlement_PI	       
			  ,Claim_Amount
			  , Status
				, IndexOrAAA_Number
			  --,(Select sum(Fee_Schedule) From tblTreatment T (NOLOCK) where T.Case_Id=C.Case_Id AND C.DomainId=T.DomainId) As Fee_Schedule
			  ,CASE 
			  WHEN Final_Status ='OPEN' AND ISNULL(Settlement_Date,'')='' THEN '(In Play) Awaiting Resolution'
			  WHEN Final_Status Like 'CLOSED%' AND ISNULL(Settlement_Date,'')='' THEN 'Closed Without Resolution'
			  WHEN Final_Status ='OPEN' AND (Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) > 0 THEN '(In Play) Settled-Open Awaiting Payment'
			  WHEN (Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) = 0 AND ISNULL(Settlement_Date,'')<> '' THEN 'Settled-Loss'
			  WHEN Final_Status Like 'CLOSED%' AND (Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) > 0 THEN 'Settled-Closed'
		  END AS Final_Status
	from tblCase C (NOLOCK) left join tblStatus S (NOLOCK) on C.Status=S.Status_Type AND C.DomainId=S.DomainId  
	left join tblSettlements ST (NOLOCK) on C.Case_Id = ST.Case_Id AND C.DomainId=ST.DomainId
	left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
	where    (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id )	
	 AND C.DomainId=@s_a_DomainId    and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) A where Final_Status=@s_a_Status
	 AND (@s_a_Open_Yr = '' OR OpenedYear = @s_a_Open_Yr )
	  order by OpenedYear
END
IF(@s_a_InventoryType = 'Resolved_Quarter')
BEGIN

Select    Case_Id
		  ,PatientName
		   ,Provider_Name,
			Provider_GroupName
			,OpenedDate
			,DOS
		  , Claim_Amount
		  , '' AS Vol_Pay_Amt
		,'' AS Vol_Pay_Dt
		,'' AS Coll_Amt
		,'' AS Coll_Dt
		 , Status
				, IndexOrAAA_Number
		  , '' AS Final_Status
		  from
          (Select Year(Settlement_Date) As ResolvedYear,
		  CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
		  Provider_Name,
			Provider_GroupName,
			CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
			, Status
				, IndexOrAAA_Number
          ,Convert(Char(3), Settlement_Date, 0) As ResolvedMonth
	      ,C.Case_Id
		  , Claim_Amount
		  --,(Select sum(Fee_Schedule) From tblTreatment T (NOLOCK) where T.Case_Id=C.Case_Id) As Fee_Schedule
		  ,(Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) As Settlement_PI
	from tblCase C (NOLOCK)  left outer join tblStatus S (NOLOCK) on C.Status = S.Status_Type AND C.DomainId=S.DomainId
	left join tblSettlements ST (NOLOCK) on C.Case_Id = ST.Case_Id AND C.DomainId=ST.DomainId
	left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.
	Provider_Id AND C.DomainId=tblProvider.DomainId
	where   (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id ) AND C.DomainId=@s_a_DomainId   and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)
	and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,ST.Settlement_Amount)+Convert(money,ST.Settlement_Int))>0	
	) A WHERE  (@s_a_Resolve_Yr = '' OR ResolvedYear = @s_a_Resolve_Yr ) AND (@s_a_Resolve_Month = '' OR ResolvedMonth = @s_a_Resolve_Month )  order by ResolvedYear
END
IF(@s_a_InventoryType = 'Inventory_Full')
BEGIN
Select Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number	   
			   from tblCase C (NOLOCK) left outer join tblStatus S (NOLOCK) on C.Status = S.Status_Type AND C.DomainId=S.DomainId 
			   left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
			   where (@i_a_provider_id = 0 OR tblProvider.Provider_Id = @i_a_provider_id ) AND C.DomainId=@s_a_DomainId			  
			     and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group) AND Final_Status=@s_a_Status
END

IF(@s_a_InventoryType = 'Inventory_Full')
BEGIN
Select Case_Id
			,CONCAT(InjuredParty_FirstName,' ',InjuredParty_LastName) AS PatientName,
			Provider_Name,
			Provider_GroupName,
			(Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
			,CONVERT(VARCHAR(10),Date_Opened, 111) As OpenedDate
			,CONCAT(CONVERT(VARCHAR(10),C.DateOfService_Start, 111),' - ',CONVERT(VARCHAR(10),C.DateOfService_End, 111)) AS DOS
				,ISNULL(Claim_Amount,0.00) AS Claim_Amount
				, '' AS Vol_Pay_Amt
				,'' AS Vol_Pay_Dt
				,'' AS Coll_Amt
				,'' AS Coll_Dt
				, Status
				, IndexOrAAA_Number	   
			   from tblCase C (NOLOCK) left outer join tblStatus S (NOLOCK) on C.Status = S.Status_Type AND C.DomainId=S.DomainId 
			   left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
			   where (@i_a_provider_id = 0 OR tblProvider.Provider_Id = @i_a_provider_id ) AND C.DomainId=@s_a_DomainId			  
			     and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group) AND Final_Status=@s_a_Status

END


END
