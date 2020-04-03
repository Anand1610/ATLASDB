CREATE procedure [dbo].[getCptCodes]--getCptCodes @DomainId='af',@code='',@ServiceType='505'
@DomainId varchar(50),
@code varchar(50),
@ServiceType int 
as
begin
	
		select	Auto_Proc_id,
				Code,
				Description,
				Amount,
				Specialty,
				ins_fee_schedule,
				ServiceTypeID,	
				DomainId,
				RegionIVfeeScheduleAmount,
				Comment
		from	MST_PROCEDURE_CODES
		where	DomainId=@DomainId and isnull(IsDeleted,0)=0
		and	   ( @code='' or Code=@code) 
		and(@ServiceType=0 or ServiceTypeID=@ServiceType)
end