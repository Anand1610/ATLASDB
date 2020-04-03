CREATE PROCEDURE [dbo].[Report_AAA_Docs_Delay] -- Report_AAA_Docs_Delay 'GLF' ,3890
	@DomainId varchar(50),
	@i_a_provider_id int
AS
BEGIN
	    SET NOCOUNT ON;

		select  distinct cas.case_id,
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,
		Provider_Name  as Provider_Name,
		ins.InsuranceCompany_Name,
		CONVERT(VARCHAR(10),Accident_Date,101) AS Accident_Date,
		CONVERT(VARCHAR(10),cas.DateOfService_Start,101) AS DateOfService_Start,
		CONVERT(VARCHAR(10),cas.DateOfService_End,101) AS DateOfService_End,
		cas.Status, 
		convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount)))) as Claim_Amount,
		(select top 1 Notes_Desc FROM tblNotes(NOLOCK)  WHERE Case_Id = cas.case_id and domainid = cas.DomainId and Notes_Type = 'Delay Arb' order by notes_id desc) as Delay_Notes,
		'...' as UpdateStatus
 from tblcase cas (NOLOCK)
 inner join tblprovider Pr (NOLOCK) ON cas.provider_Id=Pr.provider_Id
 INNER JOIN dbo.tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
 where cas.domainid = @DomainId 
	AND cas.provider_Id = @i_a_provider_id
	AND cas.status IN('AAA DOCS DELAY')
END
