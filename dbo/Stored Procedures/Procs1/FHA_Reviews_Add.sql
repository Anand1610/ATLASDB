-- =============================================
-- Author:		Serge Rosenthal
-- ALTER date: 03/30/2009
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FHA_Reviews_Add]
@DomainId nvarchar(50),@Doctor int,@Service_Type tinyint,@Case_id varchar(50), @Review_Date varchar(20), @Review_Notes varchar (500),@user_id varchar(50)
AS
DECLARE @Notes varchar(200)
BEGIN
	
	SET NOCOUNT ON;
INSERT INTO TBLREVIEWS (Case_id,Review_Doctor,Review_Date,Service_Type,Review_Notes,DomainId)
VALUES (@CASE_ID,@DOCTOR,@REVIEW_DATE,@SERVICE_TYPE,@REVIEW_NOTES,@DomainId)

SET @NOTES = 'PEER REVIEW INFORMATION ADDED FOR THIS CASE'

EXEC lcj_addnotes @DomainId=@DomainId,@case_id=@case_id,@notes_type='Activity',@NDesc=@notes,@user_id=@user_id,@applytogroup=0

 END

