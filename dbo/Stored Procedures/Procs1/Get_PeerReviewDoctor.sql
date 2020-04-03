-- =============================================
-- Author:		Name
-- ALTER date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Get_PeerReviewDoctor]
@DomainId NVARCHAR(50)
AS
BEGIN
    select '' as Doctor_id,'--Select Doctor--' as Doctor_Name union	
	select distinct Doctor_id,Doctor_Name from TblReviewingDoctor where Active=1 and DomainId=@DomainId order by 2
END


