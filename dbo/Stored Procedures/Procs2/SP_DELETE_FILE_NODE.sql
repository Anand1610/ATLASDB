CREATE PROCEDURE [dbo].[SP_DELETE_FILE_NODE]

@NODEID NVARCHAR(20)=NULL

AS 
BEGIN

begin transaction deletenode

IF NOT EXISTS(SELECT IMAGEID FROM TBLIMAGETAG
			WHERE IMAGEID=@NODEID
			  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
             AND  IsDeleted=0   
             ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
			)

	BEGIN
	
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
	 -- Delete code commented and update code added
		--DELETE FROM TBLDOCIMAGES
		--WHERE IMAGEID=@NODEID

		  UPDATE TBLDOCIMAGES SET IsDeleted=1  
          WHERE IMAGEID=@NODEID  
		    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 

			if @@error<>0
					begin
						rollback transaction deletenode
						return 0
					end

		---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		 -- Delete code commented and update code added
		--DELETE FROM TBLIMAGETAG
		--WHERE IMAGEID=@NODEID

		  UPDATE  TBLIMAGETAG SET IsDeleted=1  
          WHERE IMAGEID=@NODEID  
		    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 

			if @@error<>0
					begin
						rollback transaction deletenode
						return 0
					end

						
				commit transaction deletenode
				return 1

	END



END

