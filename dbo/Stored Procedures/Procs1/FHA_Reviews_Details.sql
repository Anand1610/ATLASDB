-- =============================================
-- Author:		Serge Rosenthal
-- ALTER date: 03/30/2009
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FHA_Reviews_Details] 
		@DomainId VARCHAR(50),
		@Case_id VARCHAR(50)  
AS
BEGIN
	
	SET NOCOUNT ON;

   SELECT     TblReviews.DomainId, TblReviews.Case_id, TblReviewingDoctor.Doctor_Name, TblReviews.Review_Date, tblServiceType.ServiceDesc, TblReviews.Review_Notes,TblReviews.User_id
FROM         TblReviewingDoctor AS TblReviewingDoctor INNER JOIN
                      TblReviews AS TblReviews ON TblReviewingDoctor.Doctor_id = TblReviews.Review_Doctor INNER JOIN
                      tblServiceType ON TblReviews.Service_type = tblServiceType.ServiceType_ID
WHERE TblReviews.Case_id=@CASE_ID
AND TblReviews.DomainId=@DomainId
	
END

