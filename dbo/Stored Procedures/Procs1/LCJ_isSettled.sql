CREATE PROCEDURE [dbo].[LCJ_isSettled](
@case_id varchar(50)
)
as
begin
declare 
@SettlementCount int,
@IsSettled int

SET @SettlementCount = (Select count(*) from tblSettlements where Case_Id = @Case_Id)

IF @SettlementCount > 0 

	BEGIN

		SET @IsSettled = 1
		select @IsSettled as IsSettled,settledwith from tblsettlements where case_id=@case_id
		

	END


ELSE


	BEGIN
			
		SET @IsSettled = 0
		select @IsSettled as IsSettled,'Not Settled' as settledwith
		

	END


end

