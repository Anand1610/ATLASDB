-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Auto_Update_Denial]
AS
BEGIN
	
	--UPDATE TBLCASE 
	--	SET DenialReasons_Type = ''
---	 UPDATE Denial in tblCASE by comma separated			
		DECLARE @tblDenial AS TABLE 
		(
			DomainID VARCHAR(50),
			CaseID VARCHAR(50),
			DenialReason VARCHAR(2000)
		)

		INSERT INTO @tblDenial
		SELECT Distinct Case_Id, tre.DomainId, tblDenialReasons.DenialReasons_Type  from tbltreatment tre (nolock)
		INNER JOIN tblDenialReasons (nolock) on tre.DenialReason_ID = tblDenialReasons.DenialReasons_Id
		-- WHERE tre.DomainId NOT IN ('AF')
		UNION
		SELECT Distinct Case_Id, tre.DomainId, tblDenialReasons.DenialReasons_Type from tblTreatment tre (nolock)
		INNER JOIN TXN_tblTreatment (nolock) on tre.Treatment_Id = TXN_tblTreatment.Treatment_Id
		INNER JOIN tblDenialReasons (nolock) on TXN_tblTreatment.DenialReasons_Id = tblDenialReasons.DenialReasons_Id
		-- WHERE tre.DomainId NOT IN ('AF')

		DECLARE @tblDenial_final AS TABLE 
		(
			DomainID VARCHAR(50),
			CaseID VARCHAR(50),
			DenialReason VARCHAR(2000)
		)
		INSERT INTO @tblDenial_final
		SELECT Distinct CaseID, DomainID, LTRIM(RTRIM((SELECT COALESCE(CAST(DenialReason AS VARCHAR(MAX))+', ','') 
		FROM @tblDenial where DomainID = a.DomainID and CaseID = a.CaseID FOR XML PATH(''))))
		FROM @tblDenial a

		--select CaseID,DomainID, LEFT(DenialReason, LEN(ltrim(rtrim(DenialReason))) - 1) AS DenialReason from @tblDenial_final

		UPDATE TBLCASE 
		SET DenialReasons_Type = LEFT(DenialReason, LEN(ltrim(rtrim(DenialReason))) - 1)
		FROM tblCase cas (nolock)
		INNER JOIN @tblDenial_final td on cas.Case_Id= td.CaseID and cas.DomainId = td.DomainID
		WHERE ISNULL(DenialReasons_Type,'') <> LEFT(ISNULL(DenialReason,''), LEN(ltrim(rtrim(DenialReason))) - 1)

		

END
