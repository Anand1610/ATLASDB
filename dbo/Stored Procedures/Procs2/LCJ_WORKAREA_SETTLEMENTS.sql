CREATE PROCEDURE [dbo].[LCJ_WORKAREA_SETTLEMENTS]

(

@case_id varchar(100)

)

/*
**********************************************************************************************************************************
DATE:				CREATED BY:		PERPOSE:
25TH MAY 2006 2:34 PM 		MANOJ KUMAR ACHARYA	SHOW DETAILS OF A PERTICULAR GROUP
***********************************************************************************************************************************
*/

AS
DECLARE @group_id as integer
select @group_id=GROUP_ID FROM tblcase with(nolock) WHERE CASE_ID=@case_id
BEGIN
print convert(varchar, @group_id)
select
Distinct
/*Case_Id as Edit,*/
cas.Case_Id,
ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')     
                      AS InjuredParty_Name,
Provider_Name,
InsuranceCompany_Name,
convert(varchar, Accident_Date, 101) as Accident_Date,
convert(varchar, DateOfService_Start,101) as DateOfService_Start,
convert(varchar, DateOfService_End,101) as DateOfService_End,Status,
Ins_Claim_Number,
Claim_Amount,
CASE WHEN Settlement_Id is NULL Then
'not-settled'
ELSE
'settled'
END AS Settlement_Status,
'''' AS ClickMe/*,
Group_Case,*/
From tblcase cas with(nolock)  
INNER JOIN  dbo.tblInsuranceCompany INS WITH (NOLOCK) ON cas.InsuranceCompany_Id = INS.InsuranceCompany_Id 
					  INNER JOIN dbo.tblProvider pro WITH (NOLOCK) ON cas.Provider_Id = pro.Provider_Id 
					  LEFT OUTER JOIN  dbo.tblSettlements sett WITH (NOLOCK) ON cas.Case_Id = sett.Case_Id 

WHERE (@group_id <> 0 AND group_id=@group_id) or cas.case_id = @case_id and 		   
			     ISNULL(cas.IsDeleted,0) = 0
end

