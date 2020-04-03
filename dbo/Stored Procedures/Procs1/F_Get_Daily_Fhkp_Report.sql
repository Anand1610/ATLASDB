
CREATE PROCEDURE [dbo].[F_Get_Daily_Fhkp_Report]   --[dbo].[F_Get_Daily_Fhkp_Report]      
(
	@type varchar(30)
)
AS  
	BEGIN
	IF(@type= 'ALL' OR @type = 'StatusSheet')
	BEGIN
	-----AAA STATUS SHEET-----
	SELECT Status,COUNT(*) AS Count FROM tblcase with(nolock)
	WHERE Status in ('AAA CONFIRMED','AAA FILE INCOMPLETE SCAN','AAA FILED','AAA HEARING SET','AAA LOST','AAA OPEN','AAA PACKAGE PRINTED',
	'AAA PACKAGE PRINTED AWAITING RE-PRINT','AAA PACKAGE READY TO PRINT','AAA PACKAGE READY TO SUBMIT','AAA PACKAGE-REJECTED','AAA PENDING','AAA PENDING / HOLD',
	'AAA PENDING HOLD-CIVIL RECO','AAA PENDING- RESOLVED','AAA PACKAGE READY','AAA SCANS READY TO SUBMIT','AAA OPEN/SCANNED','GBB')GROUP BY Status
	END
	IF(@type= 'ALL' OR @type = 'StatusBreakdown')
	BEGIN
	-----STATUS BREAKDOWN------
	SELECT case_id, 
	CONVERT(varchar,date_opened,101) date_opened,
	DATEDIFF(dd,date_opened,GETDATE()) [DATEDIF_OPENED],	
	status,	
	Old_Status,
	CONVERT(varchar,date_status_changed,101) as date_status_changed,
	DATEDIFF(dd,date_status_changed,GETDATE()) as [DATEDIFF_Status_Changed]
	FROM tblcase 
	WHERE Status ='AAA OPEN/SCANNED'
	END
	IF(@type= 'ALL' OR @type = 'JennBrown')
	BEGIN
	------JENN BROWN HOSP------
	SELECT provider_name,provider_groupname,
	status,count(*) AS COUNT
	FROM tblcase cas  with(nolock)
	INNER JOIN dbo.tblProvider pro WITH (NOLOCK) ON cas.Provider_Id = pro.Provider_Id
	WHERE Provider_GroupName 
	LIKE '%Jenn%' AND  ISNULL(cas.IsDeleted,0) = 0
	GROUP BY
	provider_name,provider_groupname,
	status
	END
	END

