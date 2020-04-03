CREATE procedure [dbo].[getBillProcedure]-- getBillProcedure '2020-03-24 00:00:00.000','af'
@lastTransferdDate datetime ,
@DomainID varchar(40)
as
begin
	select 	t1.BillNumber,
			t1.FltBillAmount,
			t1.TreatmentDetails,
			t1.AtlasCaseID,t2.Treatment_Id,
			t1.TransferAmount
	from	XN_TEMP_GBB_ALL t1
			join tblTreatment t2   on t1.DomainId=t2.DomainId 
			and t1.BillNumber=t2.BILL_NUMBER
			and t1.AtlasCaseID=t2.Case_Id
	where	t1.DomainId=@DomainID
			and isnull(TreatmentDetails,'')<>'' 
			 and convert(date,t1.Transferd_Date)>=convert(date,@lastTransferdDate)
			 and  t1.BillNumber not in(select distinct tt.BillNumber  from BILLS_WITH_PROCEDURE_CODES tt where tt.DomainID=@DomainID)
	    --  and convert(date,t1.Transferd_Date)>=convert(date,@lastTransferdDate)
		
end

