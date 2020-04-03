-- =============================================
-- Author:		Name
-- ALTER date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Get_AllActionList]
AS
BEGIN
    select '' as Action_id,'Select Action' as Action_Type union	
	select distinct Action_id,Action_Type from tblAction where Action_Type <>''
END
select * from TblReviewingDoctor

