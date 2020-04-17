CREATE PROCEDURE [dbo].[SP_DELETE_NODE]

@NODEID NVARCHAR(20)=NULL

AS 
BEGIN

begin transaction deletenode

IF NOT EXISTS(SELECT IMAGEID FROM TBLIMAGETAG
WHERE 

---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  IsDeleted=0 AND   
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
TAGID IN(SELECT NODEID FROM TBLTAGS
WHERE NODEID=@NODEID))

	BEGIN

		DELETE FROM TBLTAGS
		WHERE NODEID=@NODEID

		if @@error<>0
			begin
				rollback transaction deletenode
				return 0
			end
		
		commit transaction deletenode
		return 1
	END
ELSE

	BEGIN
		 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
      
  
  --DELETE FROM TBLDOCIMAGES  
  --WHERE IMAGEID IN (SELECT IMAGEID FROM TBLIMAGETAG  
  --WHERE TAGID IN(SELECT NODEID FROM TBLTAGS  
  --WHERE NODEID=@NODEID))  
  
  
  --DELETE FROM TBLIMAGETAG  
  --WHERE TAGID IN(SELECT NODEID FROM TBLTAGS  
  --WHERE NODEID=@NODEID)  
  
  
  UPDATE TBLDOCIMAGES SET IsDeleted=1  
  WHERE IMAGEID IN (SELECT IMAGEID FROM TBLIMAGETAG  
  WHERE TAGID IN(SELECT NODEID FROM TBLTAGS  
  WHERE NODEID=@NODEID))  
  
  
  UPDATE TBLIMAGETAG SET IsDeleted=1  
  WHERE TAGID IN(SELECT NODEID FROM TBLTAGS  
  WHERE NODEID=@NODEID)  
  
  ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  

		DELETE FROM TBLTAGS
		WHERE NODEID=@NODEID

		if @@error<>0
					begin
						rollback transaction deletenode
						return 0
					end
				
				commit transaction deletenode
				return 1

	END



END

