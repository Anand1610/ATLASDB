CREATE PROCEDURE [dbo].[CPTCode_Retrive]  
(  
 @s_a_Treatment_id  INT,  
 @s_a_Case_id   NVARCHAR(20),  
 @s_a_DomainID  NVARCHAR(50)  
)  
AS          
BEGIN   
if(@s_a_DomainID='af') 
begin
	SELECT   distinct
			CPT_ATUO_ID,
			Treatment_Id,  
			t.Case_Id,  
			BILL_NUMBER,  
			b.Code,  
			b.Description,  
			convert(varchar,DOS,101)[DOS],  
			b.Specialty,  
			Convert(Decimal(38,2),BillAmount) AS BillAmount,  
			Convert(Decimal(38,2),b.Amount) AS Amount,  
			Convert(Decimal(38,2), ISNULL(b.ins_fee_schedule,p.ins_fee_schedule)) AS ins_fee_schedule,
			CollectedAmount,
			b.MOD,
			b.UNITS,
			b.ICD10_1,
			b.ICD10_2,
			b.ICD10_3,
			convert(varchar,t.refund_date,101)[refund_date],
			p.RegionIVfeeScheduleAmount [RegionIV] ,
			p.Comment [Comment]
	  FROM  
			tblTreatment  t (NOLOCK) 
			join BILLS_WITH_PROCEDURE_CODES b (NOLOCK) on 
				((ISNULL(b.BillNumber,'') = ISNULL(t.BILL_NUMBER,'') 
				 AND ISNULL(t.BILL_NUMBER,'') <> '')
				 OR Treatment_id = ISNULL(fk_Treatment_Id,0))
				 AND b.DomainID = @s_a_DomainID
			left join MST_PROCEDURE_CODES p on p.Code=b.Code
					  and p.Description=b.Description
					  and p.Specialty=b.Specialty and p.DomainId=b.DomainID
	  WHERE
			 t.DomainID = @s_a_DomainID  
			 AND Treatment_Id = @s_a_Treatment_id   
			 AND t.Case_Id = @s_a_Case_id  
	  ORDER BY   
			DOS ,b.Code    
end
else
begin
	  SELECT   
			CPT_ATUO_ID,
			Treatment_Id,  
			t.Case_Id,  
			BILL_NUMBER,  
			Code,  
			Description,  
			convert(varchar,DOS,101)[DOS],  
			Specialty,  
			Convert(Decimal(38,2),BillAmount) AS BillAmount,  
			Convert(Decimal(38,2),Amount) AS Amount,  
			Convert(Decimal(38,2), ISNULL(ins_fee_schedule,Amount)) AS ins_fee_schedule,
			CollectedAmount,
			b.MOD,
			b.UNITS,
			b.ICD10_1,
			b.ICD10_2,
			b.ICD10_3,
			convert(varchar,t.refund_date,101)[refund_date],
			'' [RegionIV] ,
			'' [Comment]   
	  FROM  
			tblTreatment  t (NOLOCK) 
			inner join BILLS_WITH_PROCEDURE_CODES b (NOLOCK) on 
			 ((ISNULL(b.BillNumber,'') = ISNULL(t.BILL_NUMBER,'') AND ISNULL(t.BILL_NUMBER,'') <> '')
			 OR Treatment_id = ISNULL(fk_Treatment_Id,0))
			 AND b.DomainID = @s_a_DomainID
	  WHERE
			 t.DomainID = @s_a_DomainID  
			 AND Treatment_Id = @s_a_Treatment_id   
			 AND t.Case_Id = @s_a_Case_id  
	  ORDER BY   
			DOS ,b.Code    
end
END  
  
  
