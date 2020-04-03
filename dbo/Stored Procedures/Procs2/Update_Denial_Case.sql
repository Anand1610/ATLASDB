-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Update_Denial_Case]
@Caseid Varchar(50)
AS
BEGIN
	
	    UPDATE top(1) TBLCASE 
		SET DenialReasons_Type = ''
		where case_Id= @Caseid

---	 UPDATE Denial in tblCASE by comma separated			
		DECLARE @tblDenial AS TABLE 
		(
			DomainID VARCHAR(50),
			CaseID VARCHAR(50),
			DenialReason VARCHAR(2000)
		)

		INSERT INTO @tblDenial
		SELECT Distinct Case_Id, tre.DomainId, tblDenialReasons.DenialReasons_Type  from tbltreatment tre
		INNER JOIN tblDenialReasons on tre.DenialReason_ID = tblDenialReasons.DenialReasons_Id and tre.Case_Id =@Caseid
		UNION
		SELECT Distinct Case_Id, tre.DomainId, tblDenialReasons.DenialReasons_Type from tblTreatment tre
		INNER JOIN TXN_tblTreatment on tre.Treatment_Id = TXN_tblTreatment.Treatment_Id
		INNER JOIN tblDenialReasons on TXN_tblTreatment.DenialReasons_Id = tblDenialReasons.DenialReasons_Id and tre.Case_Id =@Caseid
		

		DECLARE @tblDenial_final AS TABLE 
		(
			DomainID VARCHAR(50),
			CaseID VARCHAR(50),
			DenialReason VARCHAR(2000)
		)
		INSERT INTO @tblDenial_final
		SELECT Distinct CaseID, DomainID, LTRIM(RTRIM((SELECT COALESCE(CAST(DenialReason AS VARCHAR(MAX))+', ','') 
		FROM			@tblDenial where DomainID = a.DomainID and CaseID = a.CaseID FOR XML PATH(''))))
		FROM @tblDenial a

		--select CaseID,DomainID, LEFT(DenialReason, LEN(ltrim(rtrim(DenialReason))) - 1) AS DenialReason from @tblDenial_final

		UPDATE top(1) TBLCASE 
		SET DenialReasons_Type = LEFT(DenialReason, LEN(ltrim(rtrim(DenialReason))) - 1)
		FROM tblCase cas
		INNER JOIN @tblDenial_final td on cas.Case_Id= td.CaseID and cas.DomainId = td.DomainID
		WHERE ISNULL(DenialReasons_Type,'') <> LEFT(ISNULL(DenialReason,''), LEN(ltrim(rtrim(DenialReason))) - 1)
	    and  cas.Case_Id =@Caseid
		

END
