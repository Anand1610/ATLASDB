--DROP PROCEDURE UpdateProcedureCode

CREATE PROCEDURE [dbo].[UpdateProcedureCode]
@code dbo.procedurecode READONLY ,
@DomainID varchar(50)
     
AS  
BEGIN 

	select * into #temp from @code
	update #temp set Specialty='Toxicology' where Specialty='Toxicology-'
	update #temp set Specialty='AC'  where  Specialty='ACUPUNCTURE' 
	update #temp set Specialty='FCT'  where  Specialty='FUNCTIONAL CAPACITY TEST' 
	update #temp set Specialty='MMT'  where  Specialty='MANUAL MUSCLE TESTING' 
	update #temp set Specialty='MMT'  where  Specialty='MUSCLE TESTING' 
	update #temp set Specialty='Outcome Test'  where  Specialty='OutcomeTest' 
	update #temp set Specialty='Pain Management'  where  Specialty='Pain-Management' 
	update #temp set Specialty='PT'  where  Specialty='PHYSICAL THERAPY'


	DELETE t1
	FROM #temp t1
	 JOIN BILLS_WITH_PROCEDURE_CODES t2
	ON  t1.BillNumber=t2.BillNumber and t2.Case_ID=t1.CaseID
	and t2.DomainID=@DomainID

	


	select distinct				Code,
								 Description,
								 Amount,
								 Specialty,
								 ins_fee_schedule,								
								 DomainId							
								  
								 into #tempInsertCode from BILLS_WITH_PROCEDURE_CODES where DomainID=@DomainID

	delete	t1
	from	#tempInsertCode t1
			join MST_PROCEDURE_CODES t2 on t1.Code=t2.Code  
			and t1.Description=t2.Description 
			and t1.Specialty=t2.Specialty
			and t1.DomainID=t2.DomainId
			and t1.Amount=t2.Amount
			insert into 
			MST_PROCEDURE_CODES	(Code,
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
								 GBBCodeID)
								 select
								 distinct
								 Code,
								 Description,
								 Amount,
								 Specialty,
								 ins_fee_schedule,
								 (SELECT ServiceType_ID FROM tblServiceType WHERE ServiceType=Specialty AND DomainId=@DomainID),
								 @DomainID,
								 (select top 1 isnull(RegionIVfeeScheduleAmount,0) from  MST_PROCEDURE_CODES where DomainID=DomainID and Specialty=#tempInsertCode.Specialty and Code=#tempInsertCode.Code ),
								 '', 
								 'admin',
								 getdate(),
								 ''
								 from #tempInsertCode 

								 	insert into BILLS_WITH_PROCEDURE_CODES
									(BillNumber,Code,Description,Amount,DOS,Specialty,BillAmount,ins_fee_schedule,Case_ID,fk_Treatment_Id,UNITS,DomainID,created_by_user,created_date,GBBCodeID,Auto_Proc_id)
									select BillNumber,Code,Description,Amount,DOS,Specialty,BillAmount,InsFeeSchedule,CaseID,TreatmentId,Unit,@DomainID,'admin',getdate(),CodeID,  
									(select top 1 Auto_Proc_id from  MST_PROCEDURE_CODES where Code=t.Code 
									and Description=t.Description and Amount=t.Amount and Specialty=t.Specialty and DomainId=@DomainID)
	from #temp t
								 
								update t1
								set t1.fk_Treatment_Id=t2.Treatment_Id
								from BILLS_WITH_PROCEDURE_CODES t1
								join tblTreatment t2 on t1.BillNumber=t2.BILL_NUMBER and t1.DomainID='af'
								join #temp t3 on t3.BillNumber=t2.BILL_NUMBER and t2.Case_Id=t3.CaseID

								update ProcedureCodeConfiguration set LastTranfertDate=(select max(Transferd_Date) from XN_TEMP_GBB_ALL where DomainId=@DomainID)

								 select * from MST_PROCEDURE_CODES where DomainId=@DomainID  and (RegionIVfeeScheduleAmount is null or RegionIVfeeScheduleAmount='')

								 select t1.fk_Treatment_Id,
								sum(t2.RegionIVfeeScheduleAmount)[RegionIVAmount] into #temp3
								from BILLS_WITH_PROCEDURE_CODES t1
								join MST_PROCEDURE_CODES t2 on  t1.Auto_Proc_id = t2.Auto_Proc_id
								join #temp t3 on t3.BillNumber=t1.BillNumber 
								group by t1.fk_Treatment_Id

								update t1
								set t1.Fee_Schedule=t2.RegionIVAmount
								from tblTreatment t1
								join #temp3 t2 on t2.fk_Treatment_Id=t1.Treatment_Id

								 drop table  #tempInsertCode
								 drop table #temp
								 drop table #temp3

END