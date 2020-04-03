CREATE procedure [dbo].[SaveUpdateProcedureCode]
@ServiceTypeID	int=null,
@Code nvarchar(32)=null,
@Auto_Proc_id int =null,
@Description nvarchar(512)=null,
@Amount money=null,
@Specialty varchar(512)=null,
@ins_fee_schedule money=null,
@DomainId	varchar(1024)=null,
@RegionIVfeeScheduleAmount	money=null,
@Comment	varchar(1024)=null,
@CreatedBY	varchar(512)=null,
@UpdatedBy	varchar(512)=null,
@Flag varchar(8)
as
begin

	if(@Flag='add')
	begin
		if not exists(select Auto_Proc_id from  MST_PROCEDURE_CODES where Code=@Code  and [Description]=@Description and ServiceTypeID= @ServiceTypeID and isnull(IsDeleted,0)=0)
		begin
			insert into  MST_PROCEDURE_CODES
			(
			Code,
			Description,
			Amount,
			Specialty,
			ins_fee_schedule,
			ServiceTypeID,
			DomainId,
			RegionIVfeeScheduleAmount,
			Comment,
			CreatedBY,
			CreatedDate,
			IsDeleted
			) values
			(
			@Code,
			@Description,
			@Amount,
			@Specialty,
			@ins_fee_schedule,
			@ServiceTypeID,
			@DomainId,
			@RegionIVfeeScheduleAmount,
			@Comment,
			@CreatedBY,
			getdate(),
			0
			)
			select 'code added successfully.'
		end
		else
			begin
			select 'Same code is alredy exists.'
		end
	end
	if(@Flag='update')
	begin
		update	MST_PROCEDURE_CODES
				set	Code=@Code,
				Description=@Description,
				Amount=@Amount,
				Specialty=@Specialty,
				ins_fee_schedule=@ins_fee_schedule,
				ServiceTypeID=@ServiceTypeID,				
				RegionIVfeeScheduleAmount=@RegionIVfeeScheduleAmount,
				Comment=@Comment,
				UpdatedBy=@UpdatedBy,
				UpdateDate=getdate()
				where
				Auto_Proc_id=@Auto_Proc_id and
				DomainId=@DomainId

			select 'code updated successfully.'
	enD

	if(@Flag='list')
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
		where	DomainId=@DomainId and IsDeleted=0
	end

		if(@Flag='Delete')
	begin
		update 
			MST_PROCEDURE_CODES	
			set  IsDeleted=1
		where
				Auto_Proc_id=@Auto_Proc_id and
				DomainId=@DomainId	
	
	end
end