CREATE procedure [dbo].[checkimage]
@imageid int
as
begin
SELECT
 COUNT(*) FROM tbldocimages (nolock)
 where imageid=@imageid 
  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
 and IsDeleted =0
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
 end

