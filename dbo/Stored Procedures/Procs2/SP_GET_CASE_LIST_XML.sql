CREATE PROCEDURE [dbo].[SP_GET_CASE_LIST_XML] -- '<ROOT><FIELD sz_case_id="" case_type_id="" case_status_id="" patient_name="" insurance_id="" date_of_accident="" birth_date="" claim_number="" ssn_number="" company_id=""/></ROOT>'
(    
 @XML XML    
)    
AS    
BEGIN    
 DECLARE @XML_DOC INT    
 DECLARE @SZ_CASE_ID NVARCHAR(20)    
 DECLARE @SZ_CASE_TYPE_ID NVARCHAR(20)    
 DECLARE @SZ_CASE_STATUS_ID NVARCHAR(20)    
 DECLARE @SZ_PATIENT_NAME NVARCHAR(200)    
 DECLARE @SZ_INSURANCE_COMPANY_ID NVARCHAR(20)    
 DECLARE @DT_DATE_OF_ACCIDENT DATETIME     
 DECLARE @DT_BIRTH_DATE DATETIME    
 DECLARE @SZ_CLAIM_NUMBER NVARCHAR(20)    
 DECLARE @SZ_SSN_NUMBER NVARCHAR(20)    
 DECLARE @SZ_COMPANY_ID NVARCHAR(20)    
    
 --insert into tbllog values(convert(nvarchar(4000),@XML))    
    
 EXEC SP_XML_PREPAREDOCUMENT @XML_DOC OUTPUT, @XML    
    
 SELECT    
   @SZ_CASE_TYPE_ID = XML_DOCUMENT.case_type_id,    
   @SZ_CASE_STATUS_ID = XML_DOCUMENT.case_status_id,    
   @SZ_PATIENT_NAME = XML_DOCUMENT.patient_name,    
   @SZ_INSURANCE_COMPANY_ID = XML_DOCUMENT.insurance_id,    
   @DT_DATE_OF_ACCIDENT = XML_DOCUMENT.date_of_accident,    
   @DT_BIRTH_DATE = XML_DOCUMENT.birth_date,    
   @SZ_CLAIM_NUMBER = XML_DOCUMENT.claim_number,    
   @SZ_SSN_NUMBER = XML_DOCUMENT.ssn_number,    
   @SZ_COMPANY_ID  = XML_DOCUMENT.company_id,    
   @SZ_CASE_ID = XML_DOCUMENT.sz_case_id                
  FROM OPENXML(@XML_DOC, '/ROOT/FIELD', 1)    
  WITH     
  (     
   sz_case_id NVARCHAR(20),  
   case_type_id NVARCHAR(20),    
   case_status_id NVARCHAR(20),    
   patient_name  NVARCHAR(200),    
   insurance_id NVARCHAR(20),    
   date_of_accident NVARCHAR(20),    
   birth_date NVARCHAR(20),    
   claim_number NVARCHAR(20),    
   ssn_number NVARCHAR(20),    
   company_id  NVARCHAR(20)     
  )XML_DOCUMENT    
    
     
    
 -- Execute Query    
    
 DECLARE @SZ_QUERY AS NVARCHAR(4000)    
 SET @SZ_QUERY = 'SELECT     
       Case_Id [Case ID],    
	   case_id [Case #], 
       InjuredParty_FirstName + '' '' + InjuredParty_LastName [Patient Name] ,    
       Status [Case Status],      
       Initial_Status [Case Type],     
       convert(nvarchar(20),date_opened,106) [Opened Date],    
       ''DMS'' [Document Manager]    
           
      FROM    
       tblcase    
     WHERE    
       ( case_id is not null and case_id <> '''')'      
    
     IF @SZ_CASE_STATUS_ID IS NOT NULL AND @SZ_CASE_STATUS_ID <> ''    
     BEGIN    
      SET @SZ_QUERY = @SZ_QUERY + ' AND Status = ''' + @SZ_CASE_STATUS_ID + ''''    
     END   

	IF @SZ_PATIENT_NAME IS NOT NULL AND @SZ_PATIENT_NAME <>''    
     BEGIN    
      SET @SZ_QUERY = @SZ_QUERY + ' AND (InjuredParty_FirstName + '' '' + InjuredParty_LastName) like ''%' + @SZ_PATIENT_NAME + '%'''    
     END  
         
    
       IF @SZ_CASE_ID IS NOT NULL AND @SZ_CASE_ID <>''      
     BEGIN      
      SET @SZ_QUERY = @SZ_QUERY + ' AND case_id  like ''%'+ @SZ_CASE_ID +'%'''             
     END
    exec(@SZ_QUERY)
END

