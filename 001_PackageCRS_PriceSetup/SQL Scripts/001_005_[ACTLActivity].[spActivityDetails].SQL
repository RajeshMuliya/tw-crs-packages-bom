--'ACTLActivity.spActivityDetails'  
--'ACTLActivity.spActivityDetails'    
-- Stored Procedure                          
-- =========================================================================                              
-- Author:  Jignesh Chauhan                              
-- Create date: 24/05/2010                              
-- Description: This procedure is used to get activity details.                              
/*                              
  
Sample                              
  
DECLARE @ActivityDate DATETIME,                              
    @CurrencyCode NVARCHAR(3),                              
    @ActivityID INT,                              
    @VendorCode VARCHAR(25),                      
    @CultureCode VARCHAR(10),                     
    @CheckOutDate DATETIME,                       
    @ActivityUnitXML XML,                         
    @XMLOutput XML                              
SELECT  @ActivityDate = '2014-09-25',           
        @CurrencyCode = 'USD',                  
        @ActivityID = 229,                      
        @VendorCode = 'enterprise',             
        @CultureCode ='es-US',                  
        @CheckOutDate  = '2014-09-27',          
        @ActivityUnitXML =                      
  '<ActivityUnits xmlns="http://www.avanicimcon.com/XSD">                                    
  <ActivityUnit>                                    
   <UnitCategory>Per Adult</UnitCategory>           
   <Quantity>2</Quantity>                           
  </ActivityUnit>                                   
  <ActivityUnit>                                    
   <UnitCategory>Per Child</UnitCategory>           
   <Quantity>0</Quantity>                           
  </ActivityUnit>                                   
  <ActivityUnit>                                    
   <UnitCategory>Per Infant</UnitCategory>          
   <Quantity>0</Quantity>                           
  </ActivityUnit>                                   
 </ActivityUnits>'                         
  
EXEC [ACTLActivity].[spActivityDetails] @ActivityDate = @ActivityDate, @CheckOutDate=@CheckOutDate, @ActivityUnitXML=@ActivityUnitXML,                            
    @CurrencyCode = @CurrencyCode,                               
    @ActivityID = @ActivityID, @VendorCode = @VendorCode, @CultureCode =@CultureCode ,                            
    @XMLOutput = @XMLOutput OUTPUT                              
  
*/  
-- =========================================================================                              
ALTER PROCEDURE [ACTLActivity].[spActivityDetails] (  
 @ActivityDate DATETIME  
 ,@CurrencyCode NVARCHAR(3)  
 ,@ActivityID INT  
 ,@VendorCode VARCHAR(25)  
 ,@CultureCode VARCHAR(10)  
 ,@CheckOutDate DATETIME = NULL  
 ,@ActivityUnitXML XML = '<ActivityUnits><ActivityUnit/></ActivityUnits>'  
 ,@XMLOutput XML OUTPUT  
 )  
AS  
BEGIN  
 BEGIN TRY  
  -- Comment 1                            
  DECLARE @OriginalCurrencyCode VARCHAR(3)  
  DECLARE @SiteURL VARCHAR(150)  
  DECLARE @Vendor VARCHAR(25)  
  
  -- Set CheckOutDate equels ActivityDate if CheckOutDate is null       
  SET @CheckOutDate = ISNULL(@CheckOutDate, @ActivityDate)  
  
  -- <START> Getting Base Provider Info                            
  EXEC [ACTLActivity].[spGetBaseProviderInfo] @VendorCode = NULL  
   ,@ActivityCode = @ActivityID  
   ,@BookingRefNo = NULL  
   ,@CurrencyCode = @OriginalCurrencyCode OUTPUT  
   ,@SiteUrl = @SiteURL OUTPUT  
   ,@Vendor = @Vendor OUTPUT -- Comment 4                            
  
  -- <END> Getting Base Provider Info                            
  -- Comment 1                            
  -- code                              
  SET @XMLOutput = (  
    SELECT (  
      SELECT @CurrencyCode AS ISOCurrency  
      FOR XML PATH('POS')  
       ,TYPE  
      )  
     ,(  
      SELECT ''  
      FOR XML PATH('Success')  
       ,TYPE  
      )  
     ,(  
      SELECT @ActivityDate AS CheckIn  
       ,(  
        SELECT 'Available' AS STATUS  
         ,A.nActivityID AS Code  
         ,(SELECT ExcursionInventory.GetDepartureLocationsCode(A.nActivityID)) AS DepartureDetails  
         ,COALESCE(MACT.cActivityName, A.cActivityName) AS Name  
         ,(  
          SELECT COALESCE(MLEI.cImageTitle, VAVD.ImageTitle) AS Title  
           ,VAVD.ImageID AS ID  
           ,CASE   
            WHEN VAVD.MediaType = 'photo'  
             THEN @SiteURL + '/ExcursionExtranet/Upload/Excursion_' + CAST(VAVD.ExcursionID AS VARCHAR(100)) + '/' + VAVD.ImagePath  
            WHEN (  
              VAVD.MediaType = 'video'  
              AND VAVD.isExternalSource = 1  
              )  
             THEN VAVD.cVideoPath --Comment:16          
            ELSE @SiteURL + '/ExcursionExtranet/Upload/Excursion_' + CAST(VAVD.ExcursionID AS VARCHAR(100)) + '/' + VAVD.cVideoPath  
            END AS Url  
           ,CASE   
            WHEN VAVD.MediaType = 'photo'  
             THEN NULL  
            WHEN (  
              VAVD.MediaType = 'video'  
              AND isExternalSource = 1  
              )  
             THEN VAVD.cVideoPath --Comment:16          
            ELSE @SiteURL + '/ExcursionExtranet/Upload/Excursion_' + CAST(VAVD.ExcursionID AS VARCHAR(100)) + '/' + VAVD.ImagePath  
            END AS ThumbnailUrl  
           ,COALESCE(MLEI.cImageDescription, VAVD.ImageDescription) AS Description  
           ,VAVD.MediaType AS Type  
           ,CASE   
            WHEN CASE   
              WHEN VAVD.MediaType = 'photo'  
               THEN IsDefault  
              ELSE VAVD.VideoDefault  
              END = 1  
             THEN 'true' --Comment:17         
            ELSE 'false'  
            END AS IsDefault  
          FROM ExcursionInventory.ViewActivityVideoDetails VAVD  
          LEFT OUTER JOIN ExcursionML.MLExcursionImages MLEI ON MLEI.nImageId = VAVD.ImageID  
           AND MLEI.CultureCode = @CultureCode  
          WHERE VAVD.ActivityID = A.nActivityID  
          FOR XML PATH('ImageInfo')  
           ,ROOT('Images')  
           ,TYPE  
          )  
         ,@SiteURL + '/ExcursionExtranet/Upload_PDF/Excursion_' + CAST(E.nExcursionID AS VARCHAR(100)) + '/' + A.cPdfURL AS PdfURL  
         ,--Comment:18      
         CRSServices.GetHtmlDecodeData(COALESCE('<![CDATA[' + MACT.cActivityOverView + ']]>', '<![CDATA[' + A.cActivityOverView + ']]>', '')) AS Description  
         ,--Comment:15    
         --CRSServices.GetHtmlDecodeData(COALESCE(MACT.cActivityOverView,A.cActivityOverView)) AS Description,   --Comment:15               
         EN.cFirstName + ' ' + ISNULL(EN.cLastName, '') AS Provider  
         ,A.cLocation AS [Address]  
         ,-- Comment:7                            
         (  
          SELECT [ACTLActivity].[fnGetActivityLongLatInfo](A.nActivityID)  
          )  
         ,-- Comment:7                            
         COALESCE(MlCity.CityName, C.CityName) AS 'City'  
         ,COALESCE(MlState.StateName, S.StateName) AS 'State'  
         ,COALESCE(MLCountry.countryname, Co.EnglishName) AS 'Country'  
         ,ISNULL(ASS.IndicativeRate, 0) AS BestAmount  
         ,ISNULL(CONVERT(VARCHAR, ASS.nDuration) + ' ' + COALESCE(MLC.cCodeShortDesc, L.cCodeShortDesc), 'NA') AS Duration  
         ,(  
          SELECT (  
            SELECT COALESCE(MLC.cCodeShortDesc, CL.cCodeShortDesc) AS [Level]  
            FROM (  
             SELECT nActivityLevelID  
             FROM ExcursionInventory.ActivityLevelType  
             WHERE nActivityID = A.nActivityID  
             ) AL  
            INNER JOIN Lookup.CodeLookup CL ON AL.nActivityLevelID = CL.nCodeId  
            LEFT JOIN LookupML.MLCodeLookup MLC ON CL.nCodeID = MLC.nCodeLookupId  
             AND MLC.CultureCode = @CultureCode  
            FOR XML PATH('')  
             ,TYPE  
            )  
          FOR XML PATH('')  
           ,TYPE  
          ) AS Levels  
         ,--Comment:22  
         CRSServices.GetHtmlDecodeData(COALESCE('<![CDATA[' + MACT.cTerms + ']]>', '<![CDATA[' + A.cTerms + ']]>', '')) AS RulesAndRegulations  
         ,  
         --CRSServices.GetHtmlDecodeData(COALESCE(MACT.cTerms, A.cTerms, '')) AS RulesAndRegulations,                  
         CRSServices.GetHtmlDecodeData(COALESCE('<![CDATA[' + MACT.cInclusions + ']]>', '<![CDATA[' + A.cInclusions + ']]>', '')) AS Inclusions  
         ,-- comment:20                
         CRSServices.GetHtmlDecodeData(COALESCE('<![CDATA[' + MACT.cExclusions + ']]>', '<![CDATA[' + A.cExclusions + ']]>', '')) AS Exclusions  
         ,CRSServices.GetHtmlDecodeData(COALESCE('<![CDATA[' + MACT.CDayWiseItineraryDetail + ']]>', '<![CDATA[' + A.CDayWiseItineraryDetail + ']]>', '')) AS ItenaryDetails  
         ,--Comment:19 --Comment:20  
         --CRSServices.GetHtmlDecodeData(COALESCE(MACT.CDayWiseItineraryDetail,A.CDayWiseItineraryDetail)) as ItenaryDetails,--Comment:19 --Comment:20  
         --Comment 13                      
         COALESCE(MACT.cMeetingPlace, ISNULL(A.cMeetingPlace, '')) AS DeparturePoint  
         ,  
         -- Comment 2                            
         --ISNULL(COALESCE(MLBT.MLBusinessTypeShortDescription, BT.BusinessTypeShortDescription), '') AS BusinessSubType,                        
         -- Comment 2                                                                                            
         (  
          SELECT ET.nBusinessCategoryId AS [Code]  
           ,COALESCE(MBC.cMLBusinessCategoryShortDescription, ET.cBusinessCategoryShortDescription) AS [Name] --  Comment:8                            
          FROM Lookup.BusinessCategory ET  
          INNER JOIN ExcursionInventory.ActivityExcursionType AT ON ET.nBusinessCategoryId = AT.nBusinessCategoryId  
          LEFT OUTER JOIN Lookup.MLBusinessCategory MBC ON MBC.nBusinessCategoryID = ET.nBusinessCategoryId  
           AND MBC.CultureCode = @CultureCode  
          WHERE AT.nActivityID = A.nActivityID  
          FOR XML PATH('Category')  
           ,ROOT('Categories')  
           ,TYPE  
          )  
         ,COALESCE(MLE.cExcursionName, E.cExcursionName) AS OperatorName  
         ,@VendorCode AS Vendor  
         ,-- Comment 3                            
         (  
          SELECT [ACTLActivity].[fnGetActivityPolicy](@ActivityDate, @ActivityID, @CultureCode)  
          )  
        FROM ExcursionInventory.Activities A  
        INNER JOIN ExcursionInventory.Excursion E ON A.nExcursionID = E.nExcursionID  
         AND E.IsActive = 1 --Comment 11                            
        --                                                                          AND E.nProviderID IN ( SELECT  nProviderID                            
        --                                                                                                                                 FROM    Entity.fnGetProviderDownLine(@Vendor) PD ) -- Comment 4                            
        INNER JOIN Entity.Providers P ON E.nProviderID = P.nProviderID  
        INNER JOIN Entity.Entities EN ON P.nEntityID = EN.nEntityID  
        INNER JOIN ExcursionInventory.ActivityImages AI ON A.nActivityID = AI.nActivityID  
         AND AI.bIsDefault = 1  
        INNER JOIN Inventory.Images I ON AI.nImageID = I.nImageID  
        INNER JOIN Internationalization.Cities C ON A.nLocationsId = C.CityID  
        LEFT JOIN InternationalizationML.MLCity MLCity ON C.CityID = MLCity.nCityID  
         AND MLCity.CultureCode = @CultureCode  
        INNER JOIN Internationalization.STATE S ON C.StateID = S.StateID  
        LEFT JOIN InternationalizationML.MLState MLState ON S.StateID = MLState.nStateID  
         AND MLState.CultureCode = @CultureCode  
        INNER JOIN Internationalization.Country Co ON S.CountryCode = Co.Code  
        LEFT JOIN InternationalizationML.MLCountry MLCountry ON Co.Code = MLCountry.Code  
         AND MLCountry.CultureCode = @CultureCode  
        -- Comment 6                            
        LEFT JOIN (  
         SELECT *  
         FROM ExcursionInventory.ActivitySeasons  
         WHERE nActivityID = @ActivityID  
          AND bIsDeleted = 0 --Comment 12                        
         ) ASS ON A.nActivityID = ASS.nActivityID  
         AND @ActivityDate BETWEEN ASS.dActivityFromDate  
          AND ASS.dActivityToDate  
        LEFT JOIN Lookup.CodeLookup L ON ASS.nDurationCriteriaID = L.nCodeId  
        --Comment 14                
        LEFT JOIN LookupML.MLCodeLookup MLC ON L.nCodeID = MLC.nCodeLookupId  
         AND MLC.CultureCode = @CultureCode  
        -- Comment 6                            
        -- Comment 2                                                                                            
        --Comment:10                          
        --LEFT JOIN Lookup.ViewBusinessType VBT ON VBT.BusinessTypeID = A.BusinessTypeID                          
        LEFT JOIN ExcursionInventory.BusinessType EBT ON A.BusinessTypeID = EBT.ProviderBusinessTypeID  
         AND EBT.IsDeleted = 0  
        LEFT JOIN Lookup.BusinessType BT ON EBT.BusinessTypeID = BT.BusinessTypeID  
         AND BT.BusinessID = 3  
         AND BT.IsDeleted = 0  
        LEFT JOIN Lookup.MLBusinessType MLBT ON BT.BusinessTypeID = MLBT.BusinessTypeID  
         AND MLBT.CultureCode = @CultureCode  
        --Comment:10                          
        -- Comment 2                                    
        LEFT OUTER JOIN ExcursionML.MLActivities MACT ON MACT.nActivityID = A.nActivityID  
         AND MACT.CultureCode = @CultureCode  
        LEFT OUTER JOIN ExcursionML.MLExcursion MLE ON MLE.nExcursionID = E.nExcursionID  
         AND MLE.CultureCode = @CultureCode  
        WHERE A.nActivityID = @ActivityID  
        FOR XML PATH('Activity')  
         ,ROOT('ActivityAvails')  
         ,TYPE  
        )  
      FOR XML PATH('ResponseData')  
       ,TYPE  
      )  
    FOR XML PATH('ActivityAvailRS')  
    )  
  
  -- end code                              
  DECLARE @ActivityCount INT  
  
  SET @ActivityCount = @XMLOutput.value('count(//Activity)', 'INT')  
  
  IF @ActivityCount = 0  
  BEGIN  
   SET @XMLOutput = (  
     SELECT (  
       SELECT '3' AS 'Type'  
        ,'0' AS 'Code'  
        ,'No activity details found' AS 'Message'  
       FOR XML PATH('Error')  
        ,ROOT('Errors')  
        ,TYPE  
       )  
     FOR XML PATH('ActivityAvailRS')  
     )  
  END  
 END TRY  
  
 BEGIN CATCH  
  PRINT ('Error')  
  
  SET @XMLOutput = (  
    SELECT (  
      SELECT '3' AS 'Type'  
       ,'0' AS 'Code'  
       ,'No activity details found' AS 'Message'  
      FOR XML PATH('Error')  
       ,ROOT('Errors')  
       ,TYPE  
      )  
    FOR XML PATH('ActivityAvailRS')  
    )  
 END CATCH  
  
 SELECT @XMLOutput  
END  
 /*                              
  
Comment 1 : Added code to get base provider information.                            
  
Changed By : Nainesh Tailor                              
  
Changed Date : 08/07/2010                              
  
--------------------------------------------------------                            
  
Comment 2 : Added BusinessTypeName field/element for Business Type implementation in Excursion CRS.                            
  
COMMENTED AS PER THE DISCUSSION WITH SONAL MADAM. THIS WILL BE ACTIVITED ONCE BE TEAM IMPLEMENTS THIS CHANGES.                            
  
Changed By : Nainesh Tailor                              
  
Changed Date : 11/08/2010                              
  
--------------------------------------------------------                            
  
Comment 3 : To add the value of "Vendor" element.                            
  
As per discussion with Sonal ma'am and Dhimant, they required the VendorCode in the response,                            
  
so changed it to send the vendorcode back.                            
  
Changed By : Nainesh Tailor                              
  
Changed Date : 13/08/2010                              
  
--------------------------------------------------------                            
  
Comment 4 : To return "Vendor" from base provider info sp and to pass that for finding provider downline.                            
  
To return base provider based on Activity ID.                            
  
Changed By : Noopur Desai                              
  
Changed Date : 25/09/2010                             
  
--------------------------------------------------------                            
  
Comment 5 : ML implementation for Activity Details service.                            
  
Changed By : Nainesh Tailor                              
  
Changed Date : 26/11/2010                             
  
-------------------------                            
  
Comment:6                            
  
Changed By : Nainesh Tailor                            
  
Changed Date : 05/01/2011                            
  
Description : Changed to get details of Unavailable Activities.                            
  
-------------------------                            
  
Comment:7                            
  
Changed By : Nainesh Tailor                            
  
Changed Date : 06/04/2011                            
  
Description : Added Address, Longitude and Latitude information for activity.                            
  
-------------------------                               
  
Comment:8                            
  
Changed By : Nainesh Tailor                            
  
Changed Date : 11/04/2011                            
  
Description : Changed field for Activity Type name BusinessCategoryDescription to BusinessCategoryShortDescription because desc. field length is 4000.                            
  
-------------------------                               
  
Comment:9                            
  
Changed By : Nainesh Tailor                            
  
Changed Date : 11/11/2011                            
  
Description : Changed for Search SP optimization related changes.                            
  
-------------------------                            
  
Comment:10                          
  
Changed By   : Sanket Mehta                          
  
Changed Date : 18th April 2012                          
  
Description  : 1) Multilingual related changes.                          
  
2) Business Type will never come due Business TYPE revamp changes                           
  
(In Activities table BusinessTypeID OF ExcursionInventory.BusinessType Is inserted so need TO change the join )                          
  
-------------------------                              
  
Comment 11                          
  
Changed By   : Sanket Mehta                          
  
Changed Date : 18th June 2012                          
  
Purpose      : Business Active / Inactive functionality.                          
  
Only Activity OF Active Excursion would be displayed.                          
  
---------------------------                             
  
Comment 12                        
  
Changed By   : Sanket Mehta                          
  
Changed Date : 27th June 2012                          
  
Purpose      : IF Season Deleted AND added new THEN 2 Activity Nodes are created                        
  
Reference  : WaterplayUSA posted issue Live iTrak ID : 5390                         
  
---------------------------         
  
Comment 13                      
  
Changed By   : Sanket Mehta                          
  
Changed Date : 15th July 2013                      
  
Purpose      : 7127 - p tage displaying IN Inclusions AND exclusions.                      
  
---------------------------                              
  
Comment 14                
  
Changed By   : Sanket Mehta                          
  
Changed Date : 30th January 2014                
  
Purpose      : Duration was calling function fnGetAvailableActivity which was not required.                
  
---------------------------             
  
Comment:15                
  
Changed By   : Ujjaval Patel                
  
Changed Date : 10th feb 2014                
  
Description  : to get value of description in decoded in crs response                
  
--=========================================================================                               
  
Comment:16      
  
Changed By   : Milan Patel                             
  
Changed Date : 8th April 2014                              
  
Description  : Added One more field to Check External Video URL.           
  
-- ===========================================================================           
  
Comment:17            
  
Changed By   : Ujjaval Patel                  
  
Changed Date : 26 April 2014                
  
Purpose      : to get default value of video file           
  
--=========================================================================                               
  
Comment:18      
  
Changed By   : Milan Patel                             
  
Changed Date : 5th September 2014                              
  
Description  : Added One more field for PdfURL in ActivityDetails.           
  
-- ===========================================================================           
  
Comment:19      
  
Changed By   : Sagar Shete   
  
Changed Date : 30th September  
  
Description  : Add the ItenaryDetails in Detail page.  
  
-- ===========================================================================  
  
Comment:20      
  
Changed By   : Ujjaval Patel   
  
Changed Date : 11 nov 2014  
  
Description  : change in c data node with proper format suggested by samir bhai  
  
-- ===========================================================================            
  
-- ===========================================================================           
Comment:21      
Changed By   : Ujjaval Patel  
Changed Date : 19th July 2016  
Description  : Add the ItenaryDetails in Detail page with ML values.  
-- ===========================================================================      
Comment:22  
Changed By   : Ujjaval Patel  
Changed Date : 11th May 2020  
Description  : Add Actiity level in details service as per mail by kavita mam with Sub : "MVP : Activity Details : Level" Date :08-May-2020   
-- ===========================================================================      
  
*/  