CREATE    FUNCTION [dbo].[handleMoneyNULL](@input as Money)
RETURNS  Money  AS  
BEGIN 
declare @out as money

IF (@input = NULL) 
	set @out = 0
else
	set @out = @input

return @out
END
