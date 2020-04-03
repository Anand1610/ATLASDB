CREATE PROCEDURE [dbo].[F_M_Defendant_Retrieve]
		(
			@i_a_Defendant_id					NVARCHAR(50)
		)

AS
BEGIN
	 IF (@i_a_Defendant_id<>0)	
		BEGIN
			SELECT * FROM tblDefendant WHERE Defendant_Id=@i_a_Defendant_id ORDER BY Defendant_DisplayName
		END
		
	 IF (@i_a_Defendant_id=0)	
		BEGIN
			SELECT * FROM tblDefendant where Defendant_Id <>'0' ORDER BY Defendant_DisplayName
		END
END

