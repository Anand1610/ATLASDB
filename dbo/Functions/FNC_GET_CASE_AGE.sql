CREATE FUNCTION [dbo].[FNC_GET_CASE_AGE](@strCaseId VARCHAR(100))
RETURNS INT AS
BEGIN
	declare @dt_settlement DATETIME
	declare @dt_paid_full DATETIME
	declare @dt_withdrawn DATETIME
	declare @dt_opened DATETIME
	declare @i_case_age INT

	set @dt_settlement = (select top 1 settlement_date from tblsettlements where case_id = @strCaseId)
	set @dt_paid_full = (select top 1 NOTES_DATE from TBLNOTES where case_id = @strCaseId AND notes_desc like '%to paid-full%' ORDER BY NOTES_DATE DESC)
	set @dt_withdrawn = (select top 1 NOTES_DATE from TBLNOTES where case_id = @strCaseId AND notes_desc like '%to WITHDRAWN%' ORDER BY NOTES_DATE DESC)
	set @dt_opened = (select date_opened from tblcase where case_id = @strCaseId)
	
	if(@dt_settlement IS NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,getdate())
	END
	else IF(@dt_settlement IS NOT NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,@dt_settlement)
	END
	ELSE IF(@dt_paid_full IS NOT NULL AND @dt_settlement IS NULL AND @dt_withdrawn IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,@dt_paid_full)
	END
	ELSE IF(@dt_withdrawn IS NOT NULL AND @dt_paid_full IS NULL AND @dt_settlement IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,@dt_withdrawn)
	END
	ELSE
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,getdate())	
	END

	RETURN @i_case_age
END
