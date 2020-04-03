CREATE PROCEDURE [dbo].[Report_Active_Delay] 
	-- Add the parameters for the stored procedure here
	@DomainID varchar(50),
	@i_a_provider_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select  distinct cas.case_id,
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,
		Provider_Name  as Provider_Name,
		ins.InsuranceCompany_Name,
		CONVERT(VARCHAR(10),Accident_Date,101) AS Accident_Date,
		CONVERT(VARCHAR(10),cas.DateOfService_Start,101) AS DateOfService_Start,
		CONVERT(VARCHAR(10),cas.DateOfService_End,101) AS DateOfService_End,
		cas.Status, 
		convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount)))) as Claim_Amount,
		(select top 1 Notes_Desc FROM tblNotes(NOLOCK)  WHERE Case_Id = cas.case_id and domainid = cas.DomainId and Notes_Type = 'Delay' order by notes_id desc) as Delay_Notes,
		'...' as UpdateStatus
 from tblcase cas (NOLOCK)
 inner join tblprovider Pr (NOLOCK) ON cas.provider_Id=Pr.provider_Id
 INNER JOIN dbo.tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
 where cas.domainid = @DomainID 
 AND cas.provider_Id = @i_a_provider_id
 AND cas.status IN('ACTIVE BILLING DELAYED','ACTIVE BILLING DELAYED 60','ACTIVE BILLING DELAYED 90','ACTIVE BILLING DELAYED 120')
 


END
