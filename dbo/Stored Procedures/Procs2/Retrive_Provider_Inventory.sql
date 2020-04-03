CREATE PROCEDURE [dbo].[Retrive_Provider_Inventory] 
	@i_a_Provider_Id int,
	@s_a_provider_group varchar(50),
	@s_a_DomainId nvarchar(50),
	@s_a_InventoryType nvarchar(500)
	
AS
BEGIN

IF(@s_a_InventoryType = 'Year_Opened')
	BEGIN
	Select OpenedYear
      ,Count(Case_Id) As CountofCase
	  ,ISNULL(Sum(CONVERT(float, Claim_Amount)),0) As SumOfFees 	 
	  from (Select  Year(Date_Opened) As OpenedYear
			,Case_Id
			, Year(Date_Opened) as  StatusYear,
			Claim_Amount		
	  from tblCase C (NOLOCK) INNER JOIN dbo.tblProvider (NOLOCK) ON C.Provider_Id = dbo.tblProvider.Provider_Id AND c.DomainId=tblProvider.DomainId  where  (@i_a_provider_id = 0 OR tblProvider.Provider_Id = @i_a_provider_id )  and (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group) AND C.DomainId=@s_a_DomainId) A group by OpenedYear,StatusYear order by OpenedYear
	  END
--------------------------------------------------------------------------------------

-------------------Inventory By Earliest Service Year---------------------------------
IF(@s_a_InventoryType = 'Earliest_Service_Year')
BEGIN
 Select A.Year_Start AS OpenedYear
		 ,Count(A.Case_Id) As CountofCase
		,Sum(Convert(money, Claim_Amount)) As SumOfFees 		
  From
  (Select Treatment_Id, Case_Id, Year(DateOfService_Start) As Year_Start, Claim_Amount, DateOfService_Start from tblTreatment T (NOLOCK)
  where Case_Id in (Select Case_Id from tblCase C (NOLOCK)
  INNER JOIN dbo.tblProvider (NOLOCK) ON C.Provider_Id = dbo.tblProvider.Provider_Id AND c.DomainId=tblProvider.DomainId
  
   where    (@i_a_provider_id = 0 OR tblProvider.Provider_Id = @i_a_provider_id)  and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group AND c.DomainId=@s_a_DomainId)) 
  and (DateOfService_Start = (Select Min(DateOfService_Start) from tblTreatment TT (NOLOCK) Where TT.Case_Id = T.Case_Id AND TT.DomainId=T.DomainId)
   or DateOfService_Start is null) AND T.DomainId=@s_a_DomainId) A group by Year_Start order by Year_Start
   END
--------------------------------------------------------------------------------------

--------------------Open Inventory By Status------------------------------------------
IF(@s_a_InventoryType = 'Status_Open')
BEGIN
SELECT DISTINCT Upper(ISNULL(Status_Type, '')) AS Status_Type	
	, COUNT(Case_Id)  As CountOfCase
	FROM tblStatus S (NOLOCK)
	INNER JOIN tblcase C  (NOLOCK)ON S.Status_Type = C.Status AND C.DomainId=S.DomainId
	INNER JOIN dbo.tblProvider (NOLOCK) ON C.Provider_Id = dbo.tblProvider.Provider_Id  AND c.DomainId=tblProvider.DomainId
	WHERE   S.Final_Status='open' 
	 and   (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id )  
	 and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)
	 AND c.DomainId=@s_a_DomainId	 
	GROUP BY Status_Type
	order by Status_Type
	END
--------------------------------------------------------------------------------------

-------------------Open Inventory By Carrier------------------------------------------
IF(@s_a_InventoryType = 'Carrier_Open')
BEGIN
    Select (Select InsuranceCompany_Name from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_Name
	,(Select InsuranceCompany_Id from tblInsuranceCompany I (NOLOCK) Where  C.InsuranceCompany_Id=I.InsuranceCompany_Id AND I.DomainId=@s_a_DomainId) As InsuranceCompany_ID	
			,count(C.Case_Id) As CountOfCase
			,ISNULL((Select sum(Convert(money,T.Claim_Amount)) From tblTreatment T (NOLOCK) where T.Case_Id in 
			(Select Case_Id from tblCase TC (NOLOCK) INNER JOIN dbo.tblProvider (NOLOCK) ON TC.Provider_Id = dbo.tblProvider.Provider_Id AND TC.DomainId=tblProvider.DomainId  Where  (@i_a_provider_id = 0 OR TC.Provider_Id = @i_a_provider_id )  and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group) AND TC.DomainId=@s_a_DomainId and TC.InsuranceCompany_Id=C.InsuranceCompany_Id)),0.00) As SumOfFees
			,0.00 AS Settlement_PI
	from tblCase C (NOLOCK)  left outer join tblStatus S (NOLOCK) on C.Status = S.Status_Type AND C.DomainId=S.DomainId	
	where   Provider_Id=@i_a_Provider_Id AND C.DomainId=@s_a_DomainId   and S.Final_Status='open' group by C.InsuranceCompany_Id
END
--------------------------------------------------------------------------------------
 
------------------Resolved Inventory By Earliest Service Year and Date Opened---------
IF(@s_a_InventoryType = 'Resolved_ServiceYr_DtOpen')
BEGIN
 Select  Year(T.DateOfService_Start) As Year_Start
        ,Year(C.Date_Opened) As OpenedYear
		,'' AS  ResolvedYear        
        ,Count(T.Case_Id) As CountofCase
        ,Sum(T.Claim_Amount) SumOfFees
		,(Sum(Convert(money,S.Settlement_Amount)) + Sum(Convert(money,S.Settlement_Int))) As Settlement_PI		
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
   group by  Year(T.DateOfService_Start),  Year(C.Date_Opened) order by Year_Start
   END
------------------------------------------------------------------------------------------


----------------Resolved Inventory By Date Opened and Earliest Service Year---------------
IF(@s_a_InventoryType = 'Resolved_DtOpen_ServiceYr')
BEGIN
Select Year(T.DateOfService_Start) As Year_Start
        ,Year(C.Date_Opened) As OpenedYear  
		,'' AS  ResolvedYear       
        ,Count(T.Case_Id) As CountofCase
        ,Sum(T.Claim_Amount) SumOfFees
		,(Sum(Convert(money,S.Settlement_Amount)) + Sum(Convert(money,S.Settlement_Int))) As Settlement_PI
	from tblTreatment T (NOLOCK)
   left join tblCase C (NOLOCK) on T.Case_Id = C.Case_Id AND T.DomainId=C.DomainId left join tblSettlements S (NOLOCK) on T.Treatment_Id = S.Treatment_Id AND T.DomainId=S.DomainId
   left join tblStatus ST (NOLOCK) on C.Status = ST.Status_Type AND C.DomainId=ST.DomainId
   left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId 
   where T.Case_Id in (Select Case_Id from tblCase (NOLOCK)  where  (@i_a_provider_id = 0 OR Provider_Id = @i_a_provider_id )   
   AND tblcase.DomainId=@s_a_DomainId  and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) 
   and (T.DateOfService_Start = (Select Min(DateOfService_Start) from tblTreatment TT (NOLOCK) Where TT.Case_Id = T.Case_Id)
   or T.DateOfService_Start is null) 
   and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,S.Settlement_Amount)+Convert(money,S.Settlement_Int))>0
   AND T.DomainId=@s_a_DomainId
   group by    Year(C.Date_Opened) ,Year(T.DateOfService_Start) order by Year_Start
END
------------------------------------------------------------------------------------------

-----------------Resolved Inventory By Resolved Year and Date Opened----------------------
 IF(@s_a_InventoryType = 'Resolved_ResolveYr_DtOpen')
BEGIN
 Select Year(S.Settlement_Date) As ResolvedYear
        ,Year(C.Date_Opened) As OpenedYear 
		,'' As Year_Start        
        ,Count(T.Case_Id) As CountofCase
        ,Sum(T.Claim_Amount) SumOfFees
		,(Sum(Convert(money,S.Settlement_Amount)) + Sum(Convert(money,S.Settlement_Int))) As Settlement_PI		
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
   group by  Year(S.Settlement_Date), Year(C.Date_Opened) order by ResolvedYear
   END
-------------------------------------------------------------------------------------------------------

-----------------Resolved Inventory By Resolved Year and Earliest Service Year-------------
IF(@s_a_InventoryType = 'Resolved_ResolveYr_ServiceYr')
BEGIN
 Select  Year(T.DateOfService_Start) As Year_Start
		,  Year(S.Settlement_Date) As ResolvedYear
		--ResolvedYear
              , '' AS OpenedYear  
        ,Count(T.Case_Id) As CountofCase
        ,Sum(T.Claim_Amount) SumOfFees
		,(Sum(Convert(money,S.Settlement_Amount)) + Sum(Convert(money,S.Settlement_Int))) As Settlement_PI
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
   group by  Year(S.Settlement_Date), Year(T.DateOfService_Start) order by ResolvedYear
END
-------------------------------------------------------------------------------------------

-----------------Resolved Inventory By Resolved Year and Date Opened and Earliest Service Year-------
IF(@s_a_InventoryType = 'Resolved_ResolveYr_DtOpen_ServiceYr')
BEGIN
 Select Year(S.Settlement_Date) As ResolvedYear
		,Year(C.Date_Opened) As OpenedYear 
        ,Year(T.DateOfService_Start) As Year_Start         
        ,Count(T.Case_Id) As CountofCase
        ,Sum(T.Claim_Amount) SumOfFees
		,(Sum(Convert(money,S.Settlement_Amount)) + Sum(Convert(money,S.Settlement_Int))) As Settlement_PI
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
   group by  Year(S.Settlement_Date), Year(C.Date_Opened), Year(T.DateOfService_Start)  order by ResolvedYear
   END
-----------------------------------------------------------------------------------------------------

----------------Resolved Inventory By Resolved Year and Earliest Service Year and Date Opened--------
IF(@s_a_InventoryType = 'Resolved_ResolveYr_ServiceYr_DtOpen')
BEGIN
Select Year(S.Settlement_Date) As ResolvedYear
		, Year(C.Date_Opened) As OpenedYear   
        ,Year(T.DateOfService_Start) As Year_Start         
        ,Count(T.Case_Id) As CountofCase
        ,Sum(T.Claim_Amount) SumOfFees
		,(Sum(Convert(money,S.Settlement_Amount)) + Sum(Convert(money,S.Settlement_Int))) As Settlement_PI
	from tblTreatment T (NOLOCK)
   left join tblCase C (NOLOCK) on T.Case_Id = C.Case_Id AND C.DomainId=T.DomainId left join tblSettlements S (NOLOCK) on T.Treatment_Id = S.Treatment_Id AND T.DomainId=S.DomainId
   left join tblStatus ST (NOLOCK) on C.Status = ST.Status_Type AND C.DomainId=ST.DomainId
   left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id ANd C.DomainId=tblProvider.DomainId
   where T.Case_Id in (Select Case_Id from tblCase (NOLOCK) where (@i_a_provider_id = 0 OR Provider_Id = @i_a_provider_id )  
    AND tblcase.DomainId=@s_a_DomainId and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) 
   and (T.DateOfService_Start = (Select Min(DateOfService_Start) from tblTreatment TT (NOLOCK) Where TT.Case_Id = T.Case_Id)
   or T.DateOfService_Start is null) 
   and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,S.Settlement_Amount)+Convert(money,S.Settlement_Int))>0
   AND T.DomainId=@s_a_DomainId
   group by  Year(S.Settlement_Date), Year(T.DateOfService_Start),Year(C.Date_Opened)  order by ResolvedYear
   END
-----------------------------------------------------------------------------------------------------



-----------------Resolved Inventory By Carrier--------------------------------------------
IF(@s_a_InventoryType = 'Resolved_Carrier')
BEGIN

	Select InsuranceCompany_Name,
	InsuranceCompany_Id
	      ,Count(Case_Id) As CountOfCase
		  ,Sum(CONVERT(float, Claim_Amount)) As SumOfFees
		  ,Sum(Settlement_PI) As Settlement_PI 		   
    From
    (Select I.InsuranceCompany_Name	
	      ,C.InsuranceCompany_Id
	      ,C.Case_Id
		  , Claim_Amount
		  --,(Select sum(Fee_Schedule) From tblTreatment T where T.Case_Id=C.Case_Id) As Fee_Schedule
		  ,(Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) As Settlement_PI
		  from tblCase C (NOLOCK) left outer join tblStatus S (NOLOCK) on C.Status = S.Status_Type AND C.DomainId=S.DomainId
	left join tblInsuranceCompany I (NOLOCK) on C.InsuranceCompany_Id = I.InsuranceCompany_Id AND C.DomainId=I.DomainId
	left join tblSettlements ST (NOLOCK) on C.Case_Id = ST.Case_Id AND C.DomainId=ST.DomainId
	left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
	where  (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id )  AND C.DomainId=@s_a_DomainId    and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)	
	and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,ST.Settlement_Amount)+Convert(money,ST.Settlement_Int))>0)
	
	 A
	group by InsuranceCompany_Id, InsuranceCompany_Name
END
-------------------------------------------------------------------------------------------

-----------------Open Inventory By Year Opened---------------------------------------------
IF(@s_a_InventoryType = 'Open_YrOpen')
BEGIN
	Select OpenedYear
          ,Count(Case_Id) As CountOfCase
		  ,ISNULL(Sum(Settlement_PI),0.00) As Settlement_PI
		  ,iif(Final_Status='Awaiting','Awaiting Resolution', Concat('Resolved in ',Settled_Year)) As ResolvedIn
		  ,Sum(CONVERT(float, Claim_Amount)) As SumOfFees 
		  From
			 (Select Year(Date_Opened) As OpenedYear
		      ,C.Case_Id
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
	 (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) A group by OpenedYear, Settled_Year, Final_Status order by OpenedYear, ResolvedIn

END
-------------------------------------------------------------------------------------------

--------------------------------All Cases By Final Settlement Status-----------------------
IF(@s_a_InventoryType = 'Status_Final')
BEGIN
 Select Count(Case_Id) As CountOfCase
        ,ISNULL(Sum(Settlement_PI),0.00) As Settlement_PI
		,Sum(CONVERT(float, Claim_Amount)) As SumOfFees
		,Final_Status 
		, '' AS OpenedYear
		,'' AS ResolvedYear
		, '' AS ResolvedMonth
		from
       (Select C.Case_Id
			  ,(Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) As Settlement_PI
			  ,Claim_Amount
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
	 and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) A group by Final_Status
END
-------------------------------------------------------------------------------------------

-------------------------------In Play and Settled-Closed Cases By Year Opened-------------
IF(@s_a_InventoryType = 'InPlay_SettleClose_YrOpen')
BEGIN
Select  OpenedYear
        ,Count(Case_Id) As CountOfCase
        ,ISNULL(Sum(Settlement_PI),0.00) As Settlement_PI
		,Sum(CONVERT(float, Claim_Amount)) As SumOfFees
		,Final_Status 
		,'' AS ResolvedYear
		, '' AS ResolvedMonth
		from
       (Select Year(Date_Opened) As OpenedYear, C.Case_Id
			  ,(iif(Convert(money,ST.Settlement_Amount) is null, 0, Convert(money,ST.Settlement_Amount)) + iif(Convert(money,ST.Settlement_Int) is null, 0, Convert(money,ST.Settlement_Int))) As Settlement_PI	       
			  ,Claim_Amount
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
	 AND C.DomainId=@s_a_DomainId    and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) A where Final_Status like '%(In Play)%' or Final_Status ='Settled-Closed'
	 group by OpenedYear, Final_Status order by OpenedYear
END
-------------------------------------------------------------------------------------------

------------------------------In Play and Settled-Closed Cases By Year Opened and Settlement Year--------------------
IF(@s_a_InventoryType = 'InPlay_SettleClose_YrOpen_SettleYr')
BEGIN
 Select  OpenedYear
        ,ResolvedYear
        ,Count(Case_Id) As CountOfCase
        ,ISNULL(Sum(Settlement_PI),0.00) As Settlement_PI
		,Sum(CONVERT(float, Claim_Amount)) As SumOfFees
		,Final_Status 
		, '' AS ResolvedMonth
		from
       (Select Year(Date_Opened) As OpenedYear, Year(Settlement_Date) As ResolvedYear, C.Case_Id
			  ,(iif(Convert(money,ST.Settlement_Amount) is null, 0, Convert(money,ST.Settlement_Amount)) + iif(Convert(money,ST.Settlement_Int) is null, 0, Convert(money,ST.Settlement_Int))) As Settlement_PI	       
			  ,Claim_Amount
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
	where   (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id ) AND C.DomainId=@s_a_DomainId	
	 and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)) A where Final_Status like '%(In Play)%' or Final_Status ='Settled-Closed'
	 group by OpenedYear, ResolvedYear, Final_Status order by OpenedYear, ResolvedYear, Final_Status
END
---------------------------------------------------------------------------------------------------------------------

-------------------------------Resolved Inventory By Quarter-------------------------------
IF(@s_a_InventoryType = 'Resolved_Quarter')
BEGIN
	Select ResolvedYear
		  ,ResolvedMonth
		  ,Count(Case_Id) As CountOfCase
		  ,iif(Sum(CONVERT(float, Claim_Amount)) is null, 0,  Sum(CONVERT(float, Claim_Amount))) As SumOfFees
		  ,iif(Sum(Settlement_PI) is null, 0, Sum(Settlement_PI)) As Settlement_PI 
		  ,'' AS OpenedYear
		  , '' AS Final_Status
		  from
          (Select Year(Settlement_Date) As ResolvedYear
          ,Convert(Char(3), Settlement_Date, 0) As ResolvedMonth
	      ,C.Case_Id
		  , Claim_Amount
		  --,(Select sum(Fee_Schedule) From tblTreatment T (NOLOCK) where T.Case_Id=C.Case_Id) As Fee_Schedule
		  ,(Convert(money,ST.Settlement_Amount) + Convert(money,ST.Settlement_Int)) As Settlement_PI
	from tblCase C (NOLOCK)  left outer join tblStatus S (NOLOCK) on C.Status = S.Status_Type AND C.DomainId=S.DomainId
	left join tblSettlements ST (NOLOCK) on C.Case_Id = ST.Case_Id AND C.DomainId=ST.DomainId
	left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
	where   (@i_a_provider_id = 0 OR C.Provider_Id = @i_a_provider_id ) AND C.DomainId=@s_a_DomainId   and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group)
	and (Final_Status ='OPEN' or Final_Status Like 'CLOSED%') and (Convert(money,ST.Settlement_Amount)+Convert(money,ST.Settlement_Int))>0	
	) A group by ResolvedYear, ResolvedMonth order by ResolvedYear
	END
-------------------------------------------------------------------------------------------

--------------------------Invoices By CloseOut Date----------------------------------------
IF(@s_a_InventoryType = 'CloseOut_Dt')
BEGIN
	Select Year(Account_Date) As AccountYear
		  ,Convert(Char(3), Account_Date, 0) As AccountMonth
		  ,Sum(isnull(gross_amount,0.00)) as gross_amount 		  
		  from tblclientaccount (NOLOCK) left join tblProvider (NOLOCK) ON tblProvider.Provider_Id =tblclientaccount.Provider_Id AND tblProvider.DomainId=tblClientAccount.DomainId
		   Where   (@i_a_provider_id = 0 OR tblProvider.Provider_Id = @i_a_provider_id )  AND tblClientAccount.DomainId=@s_a_DomainId		   
		  group by  Year(Account_Date), Convert(Char(3), Account_Date, 0)
END
-------------------------------------------------------------------------------------------

-----------------------Full Inventory------------------------------------------------------
-- Update Page By As Per Needs
IF(@s_a_InventoryType = 'Inventory_Full')
BEGIN
		Select Final_Status AS Final_Status
			   ,Count(Case_Id) As CountOfCase
			   , '' AS OpenedYear
			   ,'' AS ResolvedYear	
			   , 0.00 AS Settlement_PI
			   ,0.00 AS SumOfFees	
			   , '' AS ResolvedMonth	   
			   from tblCase C (NOLOCK) left outer join tblStatus S (NOLOCK) on C.Status = S.Status_Type AND C.DomainId=S.DomainId 
			   left join tblProvider (NOLOCK) ON tblProvider.Provider_Id = C.Provider_Id AND C.DomainId=tblProvider.DomainId
			   where (@i_a_provider_id = 0 OR tblProvider.Provider_Id = @i_a_provider_id ) AND C.DomainId=@s_a_DomainId			  
			     and  (@s_a_provider_group = '' OR tblProvider.Provider_GroupName = @s_a_provider_group) group by Final_Status
END
------------------------------------------------------------------------------------------------
END