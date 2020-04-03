CREATE PROCEDURE [dbo].[LCJ_Motion_Report]

(
	@court_id		    nvarchar(100),
	@start_date		    datetime,
	@end_date            datetime
)

AS

 
	BEGIN

		select tblMotions.motion_date,court_venue,Ins_Claim_Number,Attorney_FileNumber,Provider_Name,
		InsuranceCompany_Name,Defendant_Name,ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'') as 
		InjuredParty_Name,cas.Motion_Status,Our_Motion_Type,
		defendent_motion_type,Opposition_Due_Date,Reply_Due_Date,Claim_Amount,Paid_Amount, 
		(convert(int,Claim_Amount) - convert(int,Paid_Amount)) as Outstanding_Amount
		 from tblMotions with(nolock)
		LEFT OUTER JOIN tblcase cas with(nolock)
		on cas.Case_id = tblMotions.Case_id
		INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
        INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 
		LEFT OUTER JOIN  dbo.tblDefendant WITH (NOLOCK) ON cas.Defendant_Id = dbo.tblDefendant.Defendant_id
		LEFT OUTER JOIN  dbo.tblCourt WITH (NOLOCK) ON cas.Court_Id = dbo.tblCourt.Court_Id 
		where cas.court_id = @court_id
		and tblMotions.motion_date >= @start_date and tblMotions.motion_date <=@end_date
		AND ISNULL(cas.IsDeleted,0) = 0
	END

