CREATE PROCEDURE [dbo].[SP_DELETE_NODE]

@NODEID NVARCHAR(20)=NULL

AS 
BEGIN

begin transaction deletenode

IF NOT EXISTS(SELECT IMAGEID FROM TBLIMAGETAG
WHERE TAGID IN(SELECT NODEID FROM TBLTAGS
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
		DELETE FROM TBLDOCIMAGES
		WHERE IMAGEID IN (SELECT IMAGEID FROM TBLIMAGETAG
		WHERE TAGID IN(SELECT NODEID FROM TBLTAGS
		WHERE NODEID=@NODEID))


		DELETE FROM TBLIMAGETAG
		WHERE TAGID IN(SELECT NODEID FROM TBLTAGS
		WHERE NODEID=@NODEID)

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

