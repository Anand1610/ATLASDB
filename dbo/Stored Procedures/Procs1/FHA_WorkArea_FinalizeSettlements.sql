CREATE PROCEDURE [dbo].[FHA_WorkArea_FinalizeSettlements]
(
@Settlement_Amount 	money,
@Settlement_Int		money,
@Settlement_Af		money,
@Settlement_Ff		money,
@Settlement_Total 	money,
@Settlement_Date	datetime,
@Case_Id 		nvarchar(100),
@User_Id		nvarchar(50),
@SettledWith		nvarchar(400),
@Settlement_Notes	nvarchar(2000),
@Adjuster_Attorney varchar(2),
@Adjuster_Id 		INT,
@Treatment_Id		VARCHAR(MAX),
@Settled_Type       int,
@Settled_By       int
)

AS
  Declare @settlementid as int
  declare @Settled_With_Name varchar(400), @Settled_With_Phone varchar(100), @Settled_With_Fax varchar(100)  
begin
  BEGIN  
   IF @Adjuster_Attorney = 'AD'  
     BEGIN  
        set @Settled_With_Name=(select Adjuster_FirstName + ' ' + Adjuster_LastName from tblAdjusters where Adjuster_Id= + cast(@Adjuster_Id as int))   
        set @Settled_With_Phone =(select Adjuster_Phone from tblAdjusters where Adjuster_Id= + cast(@Adjuster_Id as int))   
        set @Settled_With_Fax =(select Adjuster_Fax from tblAdjusters where Adjuster_Id= + cast(@Adjuster_Id as int))   
     END  
   ELSE  
     IF @Adjuster_Attorney = 'AT'  
       BEGIN  
            
          set @Settled_With_Name=(select Attorney_FirstName +' '+ Attorney_LastName from tblAttorney where Attorney_AutoId= + @Adjuster_Id)   
          set @Settled_With_Phone =(select Attorney_Phone from tblAttorney where Attorney_AutoId= + @Adjuster_Id)   
          set @Settled_With_Fax =(select Attorney_Fax from tblAttorney where Attorney_AutoId= + @Adjuster_Id)   
       END  
 END 
		        INSERT INTO tblSettlements

					(
						Settlement_Amount,
						Settlement_Int,
						Settlement_Af,
						Settlement_Ff,
						Settlement_Total,
						Settlement_Date,
						Case_Id,
						User_Id,
						Settlement_Notes,
						SettledWith,
						Treatment_Id,
						Settled_With_Name,  
						Settled_With_Phone,  
						Settled_With_Fax,
						Settled_Type,
						Settled_by 
					)
					VALUES
					(						
						@Settlement_Amount,
						@Settlement_Int,
						@Settlement_Af,
						@Settlement_Ff,
						@Settlement_Total,
						Convert(nvarchar(15), @Settlement_Date, 101),
						@Case_Id,
						@User_Id,
						@Settlement_Notes,
						@SettledWith,
						0,
						@Settled_With_Name,  
						@Settled_With_Phone,  
						@Settled_With_Fax,
						@Settled_Type,
						@Settled_By
					)					
					
					SET @settlementid=(SELECT MAX(Settlement_Id) FROM tblSettlements)
				
					INSERT INTO tbl_treatment_settled
					(
					   Treatmentid,
					   SettlementId
					)					
					   select s,@settlementid from dbo.SplitString (@Treatment_Id,',') 
					
					IF @Adjuster_Id <> 0 
						BEGIN
							Update tblCase SET Adjuster_Id = + @Adjuster_Id WHERE Case_Id = + @Case_Id
						END
			END

