CREATE PROCEDURE [dbo].[FHA_WorkArea_IsCaseSettled](
@case_id varchar(50)
)
as
begin
declare 
@SettlementCount int,
@TreatmentCount int,
@IsSettled int

SET @TreatmentCount=(Select count(*) from tblTreatment where Case_Id = @Case_Id)
SET @SettlementCount = (Select count(Treatment_Id) from tbl_treatment_settled left outer join Tblsettlements on Tblsettlements.Settlement_Id = tbl_treatment_settled.settlementid and Case_Id = @Case_Id)
IF(@TreatmentCount=0 or @SettlementCount=0)
	BEGIN			
		SET @IsSettled = 0
		select @IsSettled as IsSettled,'Not Settled' as settledwith	,0	as Settled_by
    END
ELSE IF @TreatmentCount = @SettlementCount
	BEGIN
		SET @IsSettled = 1
		select @IsSettled as IsSettled,settledwith,Settled_by from tblsettlements where case_id=@case_id	
    END
ELSE if(@SettlementCount<@TreatmentCount)
	BEGIN			
		SET @IsSettled = 2
		select @IsSettled as IsSettled,'Partially Settled' as settledwith,0	as Settled_by	
    END

end

