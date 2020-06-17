/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[SP_Get_Settlement_Total_Details]
(
@DomainId VARCHAR(20),
@InsuranceCmpId INT,
@dt1 DATETIME,
@dt2 DATETIME,
@UserId VARCHAR(20),
@SettlementType VARCHAR(100)
)
AS
BEGIN
			SELECT ISNULL(COUNT(DISTINCT CASE_ID),0) AS CNT_TOT,
			ISNULL(SUM(CLAIM_AMOUNT-PAID_AMOUNT),0) as BALANCE,
			ISNULL(SUM(Fee_Schedule-PAID_AMOUNT),0) AS Balance_Fee_Schedule,
			ISNULL(SUM(SETTLEMENT_TOTAL),0) AS Tot_Settlement_Total
			from [dbo].[SJR-SETTLEMENTS] 
			where (@InsuranceCmpId = '' OR InsuranceCompany_id = @InsuranceCmpId)
			and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1
			and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2
			and (@UserId = '' OR isnull(User_id,'') = @UserId)
			and (@SettlementType = '' OR isnull(Settlement_Type,'') = @SettlementType)
			and Settlement_Total <> 0 
			and isnull(DomainId,'') = @DomainId
			and case_id in (select case_id from tblcase with(nolock) where case_id=[SJR-SETTLEMENTS].Case_id and ISNULL(IsDeleted,0) = 0 and DomainId=@DomainId)
END