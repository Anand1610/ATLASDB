CREATE PROCEDURE [dbo].[F_Report_AAA_HearingSet_DatePassed]
AS
BEGIN
		select distinct c.case_id [Case_Id], 
		PacketId as [Packet_Id],
		InjuredParty_FirstName + ' ' + InjuredParty_LastName [Patient_Name],
		prov.Provider_SuitName[Provider],
		ins.insurancecompany_name[Insurance],
		(select Insurance_group_name from mst_insurance_groups where PK_insurance_group_id=ins.FK_INSURANCE_GROUP_ID)[Insurance_Group],
		prov.Provider_GroupName[Provider_GroupName],
		IndexOrAAA_Number[IndexOrAAA_Number],
		c.Claim_Amount[Claim_Amount],
		c.Fee_Schedule[Fee_Schedule],
		Paid_Amount[Paid_Amount],
		(convert(decimal(38,2),c.Claim_Amount)-convert(decimal(38,2),c.Paid_Amount))[Claim_Balance],
		c.Fee_Schedule-c.Paid_Amount[FS_Balance],
		(select Court_Name from tblcourt where Court_Id=c.Court_Id) [Court_Name],
		c.Status[Status],
		c.Initial_status,
		(select CaseType from MST_PacketCaseType m where m.PK_CaseType_Id=c.FK_CaseType_Id) [CaseType],
		(select clientpriority_level_name from tblclientprioritylevel l where l.pk_clientpriority_level_id=prov.fk_clientpriority_level_id)[Client_Priority_Level],
		convert(varchar,Accident_Date,101) [accident_date],
		Ins_Claim_Number[Ins_Claim_Number],
		CONVERT(NVARCHAR(12),CONVERT(DATETIME, c.DATEOFSERVICE_START), 101) + '-' +
		CONVERT(NVARCHAR(12), CONVERT(DATETIME, c.DATEOFSERVICE_END), 101) AS [DOS_Range],
		(select top 1 Defendant_Name from tblDefendant where Defendant_id=c.Defendant_Id)[Defendant_Name],
		CONVERT(VARCHAR,DATE_STATUS_CHANGED,101)[DATE_STATUS_CHANGED],
		DateDiff(dd,ISNULL(Date_Status_Changed,Date_Opened),GETDATE())[Status_Age],
		DateDiff(dd,Date_Opened,GETDATE())[Case_Age],
		c.Date_AAA_Arb_Filed[Date_AAA_Arb_Filed],c.batchcode as BatchNumber,
		(select top 1 convert(varchar,Event_Date,101) from tblevent where Case_id=c.case_id and eventstatusid=32 and event_date >  getdate() order by Event_Date desc) [Latest_Hearing_Date],
		(select top 1 Assigned_To from tblevent where Case_id=c.case_id and eventstatusid=32 and event_date >  getdate() order by Event_Date desc)[Latest_Assigned_To],
		(select top 1 notes_desc from tblnotes where Case_id=c.case_id and Notes_Type='pending' and User_Id='gmercogliano' order by notes_date desc)[Latest_noteBy_gmercogliano]
		from tblcase c 
		inner join tblinsurancecompany ins on ins.insurancecompany_id=c.insurancecompany_id
		inner join tblprovider prov on c.provider_id=prov.provider_id
		left join tblPacket (NOLOCK) on c.FK_Packet_ID=tblPacket.Packet_auto_id  
		left outer join tblstatus s on s.status_type=c.status
		where (status ='AAA HEARING SET') and ((select top 1 convert(varchar,Event_Date,101) from tblevent where Case_id=c.case_id and  eventstatusid=32 order by Event_Date desc) > getdate())

END
