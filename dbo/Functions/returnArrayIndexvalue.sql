CREATE FUNCTION [dbo].[returnArrayIndexvalue]( @commsepString varchar(8000),
@indexvalue int
 )
RETURNS  varchar(8000)  AS  
BEGIN 

declare @return varchar(8000) 
set @return=''

declare @separator varchar(5)
set @separator=','

declare @tempindex int

set @tempindex = 1

if @commsepString is not null and @commsepString<>'' 
begin
--First Insert Case id's 
DECLARE @INDEX INT
DECLARE @SLICE varchar(1000)
DECLARE @ROWID INT

SELECT @INDEX = 1
    IF @commsepString IS  not NULL  
   begin
    WHILE @INDEX !=0
        BEGIN	
        	SELECT @INDEX = CHARINDEX(@separator,@commsepString)

        	IF @INDEX !=0
        		SELECT @SLICE = LEFT(@commsepString,@INDEX -1)
        	ELSE
        		SELECT @SLICE = @commsepString
       	SELECT @commsepString = RIGHT(@commsepString,LEN(@commsepString) - @INDEX)
	set @commsepString= right(@commsepString,len(@commsepString)-len(@separator)+1)
	Set @slice = replace(@slice, @separator,'')

	if @indexvalue=@tempindex
	begin
		set @return = @slice
		break
	end
	else
	begin
		set @tempindex = @tempindex+1	
	end	
	
	
        	IF LEN(@commsepString) = 0 BREAK
    END
 end

end


return @return




END
