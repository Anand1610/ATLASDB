CREATE PROCEDURE [dbo].[F_M_Attorney_Retrieve]
		(
			@i_a_attorney_auto_id	INT
		)

AS
BEGIN
	 IF (@i_a_attorney_auto_id<>0)	
		BEGIN
			SELECT tblAttorney.Attorney_AutoId,tblAttorney.Attorney_Id,tblAttorney.Attorney_LastName,tblAttorney.Attorney_FirstName,tblAttorney.Attorney_Address,tblAttorney.Attorney_City,tblAttorney.Attorney_State,tblAttorney.Attorney_Zip,tblAttorney.Attorney_Phone,tblAttorney.Attorney_Fax,tblAttorney.Attorney_Email,tblAttorney.Defendant_Id,tblDefendant.Defendant_Name
		    FROM tblAttorney INNER JOIN tblDefendant ON tblAttorney.Defendant_Id=tblDefendant.Defendant_id WHERE tblAttorney.Attorney_AutoId=@i_a_attorney_auto_id ORDER BY tblAttorney.Attorney_FirstName
		END
		
	 IF (@i_a_attorney_auto_id=0)	
		BEGIN
			SELECT tblAttorney.Attorney_AutoId,tblAttorney.Attorney_Id,tblAttorney.Attorney_LastName,tblAttorney.Attorney_FirstName,tblAttorney.Attorney_Address,tblAttorney.Attorney_City,tblAttorney.Attorney_State,tblAttorney.Attorney_Zip,tblAttorney.Attorney_Phone,tblAttorney.Attorney_Fax,tblAttorney.Attorney_Email,tblAttorney.Defendant_Id,tblDefendant.Defendant_Name
		    FROM tblAttorney INNER JOIN tblDefendant ON tblAttorney.Defendant_Id=tblDefendant.Defendant_id  ORDER BY tblAttorney.Attorney_FirstName
		END
END

