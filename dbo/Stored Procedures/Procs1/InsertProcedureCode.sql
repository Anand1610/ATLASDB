  
-- =============================================  
-- Changed By: Atul Jadhav 
-- Changed date: 4/9/2020
-- Description: Added CptCodeC Change  
-- =============================================  

CREATE PROCEDURE [dbo].[InsertProcedureCode]
@Treatment_Details VARCHAR(MAX),
@Bill_Number varchar(50) null,
@Treatment_Id int ,
@Case_Id varchar(50),
@DomainID varchar(50)
AS
BEGIN 
print @Bill_Number
print @Case_Id
	--	declare @Bill_Number varchar(50),@Case_Id varchar(50),@Treatment_Id int 
	---DECLARE @TreatmentJson VARCHAR(MAX)= '[{"TreatmentCodeID":"PR000000000000104834","TreatmentCode":"82570","TreatmentDescription":"Creatinine-Creatinine; Urine Ph;Urine Specific Gravity","Specialty":"TOXICOLOGY","DOS":"2020-03-11T00:00:00","Amount":84.60,"Units":1.00,"InsuranceFeeSchedule":84.60},{"TreatmentCodeID":"PR000000000000104863","TreatmentCode":"81002","TreatmentDescription":"Urinalysis dip stick\/ablet reagent Non Auto","Specialty":"TOXICOLOGY","DOS":"2020-03-11T00:00:00","Amount":42.00,"Units":1.00,"InsuranceFeeSchedule":42.00},{"TreatmentCodeID":"PR000000000000104835","TreatmentCode":"80307","TreatmentDescription":"Drug test-Amphetamine; Barbiturates;Benzodiazepines;Cocaine;Methadone;Opiates;Oxycodone;Phencyclidine;THC (Cannabinoids)","Specialty":"TOXICOLOGY","DOS":"2020-03-11T00:00:00","Amount":758.20,"Units":1.00,"InsuranceFeeSchedule":758.20}]'
	BEGIN TRY
		BEGIN TRANSACTION

							create table #temp(
							TreatmentCodeID VARCHAR(255),
							TreatmentCode VARCHAR(50),
							TreatmentDescription VARCHAR(1000),
							Specialty VARCHAR(255),
							DOS datetime,
							Amount money,
							Units decimal,
							InsuranceFeeSchedule money
							)
							insert into #temp(
							TreatmentCodeID,
							TreatmentCode,
							TreatmentDescription,
							Specialty,
							DOS,
							Amount,
							Units,
							InsuranceFeeSchedule
							)
							SELECT	TreatmentCodeID,
							ltrim(rtrim(TreatmentCode)) [TreatmentCode],
							TreatmentDescription,
							Specialty,
							DOS,
							Amount,
							Units,
							InsuranceFeeSchedule 
							FROM	OPENJSON(@Treatment_Details)
							WITH
							(
							TreatmentCodeID VARCHAR(255),
							TreatmentCode VARCHAR(50),
							TreatmentDescription VARCHAR(1000),
							Specialty VARCHAR(255),
							DOS datetime,
							Amount money,
							Units decimal,
							InsuranceFeeSchedule money
			)
							update #temp set Specialty='Toxicology' where Specialty='Toxicology-'
							update #temp set Specialty='AC'  where  Specialty='ACUPUNCTURE' 
							update #temp set Specialty='FCT'  where  Specialty='FUNCTIONAL CAPACITY TEST' 
							update #temp set Specialty='MMT'  where  Specialty='MANUAL MUSCLE TESTING' 
							update #temp set Specialty='MMT'  where  Specialty='MUSCLE TESTING' 
							update #temp set Specialty='Outcome Test'  where  Specialty='OutcomeTest' 
							update #temp set Specialty='Pain Management'  where  Specialty='Pain-Management' 
							update #temp set Specialty='PT'  where  Specialty='PHYSICAL THERAPY'

							declare @Specialty varchar(255)
							declare @ServiceType_ID int
							set @Specialty=(select top 1 Specialty from #temp)
	
							if not exists(select ServiceType_ID from  tblserviceType where ServiceType=@Specialty and DomainId=@DomainID)
							begin
							insert into tblserviceType(ServiceType,ServiceDesc,DomainId,created_by_user,created_date)
							values(@Specialty,@Specialty,'@DomainID','System',getdate())

							end
							set @ServiceType_ID=(select ServiceType_ID from  tblserviceType where ServiceType=@Specialty and DomainId=@DomainID)

							--select #temp.TreatmentCode,
							--#temp.TreatmentDescription,
							--#temp.Amount,
							--#temp.Specialty,
							--#temp.InsuranceFeeSchedule,
							--t2.Auto_Proc_id into #temp2
							--from #temp
							--left join MST_PROCEDURE_CODES t2 on #temp.TreatmentCode=t2.Code and
							--				#temp.TreatmentDescription=t2.Description and
							--				#temp.Amount=t2.Amount and 
							--				#temp.Specialty=t2.Specialty
							--				and  t2.DomainId=@DomainID
							--				where t2.Auto_Proc_id is null

							--insert into MST_PROCEDURE_CODES(Code,Description,Amount,Specialty,ins_fee_schedule,ServiceTypeID,DomainId,CreatedBY,CreatedDate) 
							--select  #temp2.TreatmentCode,
							--#temp2.TreatmentDescription,
							--#temp2.Amount,
							--#temp2.Specialty,
							--#temp2.InsuranceFeeSchedule,
							--@ServiceType_ID,
							--@DomainID,
							--'system',
							--getdate()
							--from #temp2

							select #temp.*,
							t2.Auto_Proc_id into #temp3
							from #temp
							left join DistinctCPTCodes t2 on #temp.TreatmentCode=t2.Code and											
											#temp.Amount=t2.Amount and 
											#temp.Specialty=t2.Specialty
											and  t2.DomainId=@DomainID
						
						if not exists ( select CPT_ATUO_ID from BILLS_WITH_PROCEDURE_CODES where BillNumber=@Bill_Number and Case_ID=@Case_Id)
						begin
							insert into BILLS_WITH_PROCEDURE_CODES 
							(BillNumber,Code,Description,Amount,DOS,Specialty,ins_fee_schedule,Case_ID,fk_Treatment_Id,UNITS,DomainID,created_by_user,created_date,GBBCodeID,Auto_Proc_id)
							select distinct	@Bill_Number,
							t.TreatmentCode,
							t.TreatmentDescription,
							t.Amount,
							t.DOS,
							t.Specialty,
							t.InsuranceFeeSchedule,
							@Case_Id,
							@Treatment_Id,
							t.Units,
							@DomainID,
							'System',
							getdate(),
							t.TreatmentCodeID,
							t.Auto_Proc_id

							from	#temp3 t	
							
							if(@DomainID='AF')
							begin
								declare @RegionIvAmount money
								select @RegionIvAmount=sum(isnull(t2.RegionIVfeeScheduleAmount,0)) from BILLS_WITH_PROCEDURE_CODES t1
								join DistinctCPTCodes t2 on t1.Auto_Proc_id=t2.Auto_Proc_id
								where t1.fk_Treatment_Id=@Treatment_Id and t1.DomainID=@DomainID

								update tblTreatment 
								set Fee_Schedule=@RegionIvAmount 
								where tblTreatment.Treatment_Id=@Treatment_Id

								update t1
								set  t1.FeeSchedule=t2.RegionIVfeeScheduleAmount
								from BILLS_WITH_PROCEDURE_CODES t1
								join DistinctCPTCodes t2 on t1.Auto_Proc_id=t2.Auto_Proc_id
								and t1.BillNumber=@Bill_Number
							end
					end

							

			COMMIT TRAN
   END TRY


BEGIN CATCH

print 'Error'

ROLLBACK TRAN --R

END CATCH
		

			
											
END