/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[SP_Get_Settlement_Details]
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
			select * from [dbo].[SJR-SETTLEMENTS] 
			where (@InsuranceCmpId = '' OR InsuranceCompany_id = @InsuranceCmpId)
			and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1
			and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2
			and (@UserId = '' OR isnull(User_id,'') = @UserId)
			and (@SettlementType = '' OR isnull(Settlement_Type,'') = @SettlementType)
			and Settlement_Total <> 0 
			and isnull(DomainId,'') = @DomainId 
			and case_id in (select case_id from tblcase with(nolock) where case_id=[SJR-SETTLEMENTS].Case_id and ISNULL(IsDeleted,0) = 0 and DomainId=@DomainId)
			order by settlement_date asc,provider_name asc
END