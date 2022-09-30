-- Stored Procedure                                    
-- Stored Procedure                                    
                                        
-- =========================================================================                                        
-- Author:  Sanket Mehta          
-- Create date: 4th April 2014          
-- Description: Revamp the Activity List Service as it was getting timeout.          
-- Reference : ExcursionBooking.spActivityList          
/*                                        
Sample                                        
DECLARE @ActivityDate DATETIME,                
    @PrimaryLocationName NVARCHAR(200),                
    @ActivityTypeID INT,                
    @BusinessTypeID INT,                
    @CurrencyCode NVARCHAR(3),                
    @VendorCode VARCHAR(25),                
    @Provider VARCHAR(50),                
    @MarkupPercentage DECIMAL(19, 4),                
    @ConversionFactor DECIMAL(19, 10),                
    @MarkupAmount DECIMAL(19, 4),                
    @IsAmountRoundOff BIT,                
    @GroupCode NVARCHAR(50),                
    @CheckOutDate DATETIME,                
    @ActivityUnitXML XML,                
    @ActivityCodes XML,                
    @CultureCode VARCHAR(10),                
    @Status VARCHAR(15),                
    @XMLOutput XML                                        
                                        
SELECT  @ActivityDate = '10/19/2014',                
        @PrimaryLocationName = NULL,                
        @ActivityTypeID = NULL,                
        @BusinessTypeID = NULL,                
        @CurrencyCode = 'USD',                
        @VendorCode = 'enterprise',                
        @Provider = 'ACTLActivity',                
        @MarkupPercentage = 0,                
        @ConversionFactor = 1,                
        @MarkupAmount = 0,                
        @IsAmountRoundOff = 1,                
        @GroupCode = N'CRSLocal',                
        @ActivityCodes = --'<ActivityCodes><Code>183</Code></ActivityCodes>',                                    
        '<ActivityCodes><Code/></ActivityCodes>',                
        @CheckOutDate = '11/25/2015',           
      --NULL,                                        
        @CultureCode = 'en-Us',                
        @ActivityUnitXML = '<ActivityUnits xmlns="http://www.avanicimcon.com/XSD">                                                
  <ActivityUnit>                                                
   <UnitCategory>Per Adult</UnitCategory>                                                
   <Quantity>2</Quantity>                                                
  </ActivityUnit>                                                             
 </ActivityUnits>',                
        @Status = 'All'                                       
                                        
EXEC [ExcursionBooking].[spActivityList_New] @ActivityDate = @ActivityDate,                                        
    @PrimaryLocationName = @PrimaryLocationName,                                        
    @ActivityTypeID = @ActivityTypeID,                                        
    @BusinessTypeID=@BusinessTypeID,                                        
    @CurrencyCode = @CurrencyCode,                                        
    @VendorCode = @VendorCode,@Provider=@Provider,                                        
    @MarkupPercentage = @MarkupPercentage,                                        
    @GroupCode = @GroupCode,@CheckOutDate=@CheckOutDate,@ActivityUnitXML =@ActivityUnitXML,                                        
    @ActivityCodes= @ActivityCodes,                                        
    @CultureCode = @CultureCode,                                        
    @Status = @Status,                                        
    @XMLOutput = @XMLOutput OUTPUT                                        
*/                                        
-- =========================================================================                                        
ALTER PROCEDURE [ExcursionBooking].[spActivityList_New]          
    (          
      @ActivityDate DATETIME,          
      @PrimaryLocationName NVARCHAR(200) = NULL,          
      @ActivityTypeID INT = NULL,          
      @BusinessTypeID INT = NULL,          
      @CurrencyCode NVARCHAR(3),          
      @VendorCode VARCHAR(25),          
      @Provider VARCHAR(50),          @MarkupPercentage DECIMAL(19, 4) = 0,          
      @ConversionFactor DECIMAL(19, 10) = 1,          
      @MarkupAmount DECIMAL(19, 4) = 0,          
      @IsAmountRoundOff BIT = 0,          
      @GroupCode NVARCHAR(50),          
      @CheckOutDate DATETIME = NULL,          
      @ActivityUnitXML XML = '<ActivityUnits><ActivityUnit/></ActivityUnits>',          
      @ActivityCodes XML = '<ActivityCodes><Code/></ActivityCodes>',          
      @CultureCode VARCHAR(10),          
      @Status VARCHAR(15) = 'Available',          
      @XMLOutput XML OUTPUT                                        
    )          
AS           
    BEGIN          
        BEGIN TRY          
            SET @CheckOutDate = COALESCE(@CheckOutDate, @ActivityDate)          
            DECLARE @AvailableActivityDetails TABLE          
                (          
                  Status VARCHAR(15),          
                  ActivityID INT,          
                  ActivityName NVARCHAR(200),          
                  ActivityDescription NVARCHAR(MAX),          
                  SiteURL VARCHAR(250),          
                  ActivitySeasonScheduleID INT,          
                  Rate DECIMAL(19, 2),          
                  ActivityDurationCriteriaID INT,          
                  ActivityDuration INT,          
                  ExcursionID INT,          
                  ExcursionName NVARCHAR(200),          
                  VendorCode VARCHAR(250)          
                )          
              
            INSERT  INTO @AvailableActivityDetails          
                    (          
                      Status,          
                      ActivityID,          
                      ActivityName,          
                      ActivityDescription,          
                      SiteURL,          
                      ActivitySeasonScheduleID,          
                      Rate,          
                      ActivityDurationCriteriaID,          
                      ActivityDuration,          
                      ExcursionID,          
                      ExcursionName,          
                      VendorCode          
               )          
                    SELECT  Status,          
                            ActivityID,          
                            ActivityName,          
                            ActivityDescription,          
                            SiteURL,          
                            ActivitySeasonScheduleID,          
                            Rate,          
                            ActivityDurationCriteriaID,          
                            ActivityDuration,          
                            ExcursionID,          
                            ExcursionName,          
                            VendorCode          
                    FROM    ACTLActivity.GetAvailableActivityDetails(@ActivityDate, @CheckOutDate, @PrimaryLocationName, @GroupCode, @ActivityUnitXML, @ActivityCodes, NULL, NULL, @Status, 1, 0)          
        --1 is for getting the best rate schedule.          
        --0 whether the check is form Check Avai or not.          
          
            DECLARE @IsAddTax BIT                                
            SET @IsAddTax = 0             
          
            IF EXISTS ( SELECT  1          
                        FROM    @AvailableActivityDetails )           
                BEGIN          
                    DECLARE @ActivityUnitParentID INT                          
                    SELECT  @ActivityUnitParentID = nCodeId          
                    FROM    Lookup.CodeLookup          
                    WHERE   cCodeShortDesc = 'ActivityRateUnit'             
          
                    DECLARE @AdultCount INT,          
                        @ChildCount INT,          
                        @InfantCount INT ;                       
                    WITH XMLNAMESPACES ( 'http://www.avanicimcon.com/XSD' AS          
                        ACTL )                              
                    SELECT  @AdultCount = COALESCE(ActivityUnits.AU.value('(ACTL:ActivityUnit[ACTL:UnitCategory="Per Adult" or ACTL:UnitCategory="per adult"]/ACTL:Quantity)[1]', 'INT'),          
                                                   0),          
                            @ChildCount = COALESCE(ActivityUnits.AU.value('(ACTL:ActivityUnit[ACTL:UnitCategory="Per Child" or ACTL:UnitCategory="per child"]/ACTL:Quantity)[1]', 'INT'),          
                             0),          
                            @InfantCount = COALESCE(ActivityUnits.AU.value('(ACTL:ActivityUnit[ACTL:UnitCategory="Per Infant" or ACTL:UnitCategory="per infant"]/ACTL:Quantity)[1]', 'INT'),          
                                                    0)          
                    FROM    @ActivityUnitXML.nodes('//ACTL:ActivityUnits') ActivityUnits ( AU )              
          
          
                    SELECT  @XMLOutput = ( SELECT   ( SELECT    @CurrencyCode AS ISOCurrency          
                                                    FOR          
                                                      XML PATH('POS'),          
                                                          TYPE          
                                                    ),          
                                                    ( SELECT    ''          
                                                    FOR          
                                                      XML PATH('Success'),          
                                                          TYPE          
                                                    ),          
                                                    ( SELECT    @ActivityDate AS CheckIn,          
                                                                @CheckOutDate AS CheckOut,          
                                                                ( SELECT    Status,          
                                                                            ActivityID AS Code,    
                   (SELECT ExcursionInventory.GetDepartureLocationsCode(ActivityID)) AS DepartureDetails,              
                                                                            COALESCE(MACT.cActivityName, AAD.ActivityName) AS Name,          
                                                                            AAD.SiteUrl + '/ExcursionExtranet/Upload/Excursion_' + CAST(AAD.ExcursionID AS VARCHAR(100)) + '/' + I.cImagePath AS Url,          
                                                                            CRSServices.GetHtmlDecodeData(COALESCE(MACT.cActivityOverView, AAD.ActivityDescription)) AS Description,          
                                                                            COALESCE(MLBT.MLBusinessTypeShortDescription, BT.BusinessTypeShortDescription, '') AS BusinessTypeName,          
                                                                            ( SELECT    ( SELECT    COALESCE(MBC.cMLBusinessCategoryShortDescription, BL.cBusinessCategoryShortDescription) AS [Name]          
                                                                                          FROM      ( SELECT    nBusinessCategoryID          
                                                                                                      FROM      ExcursionInventory.ActivityExcursionType          
                                                                                                      WHERE     nActivityID = AAD.ActivityID          
                                                                                                           AND isdeleted = 0          
                                                                                                    ) AET          
                                                                                                    INNER JOIN Lookup.BusinessCategory BL ON AET.nBusinessCategoryID = BL.nBusinessCategoryID          
                                                                                                       AND BL.IsDeleted = 0    
                                    AND CASE WHEN @ActivityTypeID IS Not NULL THEN BL.nBusinessCategoryParentID     
                                      else BL.nBusinessCategoryID     
                                      END =     
                                    CASE WHEN   @ActivityTypeID IS Not NULL THEN @ActivityTypeID    
                                    Else ISNULL(BL.nBusinessCategoryParentID ,BL.nBusinessCategoryID )    
                                    END--nBusinessCategoryParentID =  ISNULL(@ActivityTypeID,nBusinessCategoryParentID)    --ADDED on 20170929 KP    
                                                                                                    LEFT JOIN Lookup.MLBusinessCategory MBC ON BL.nBusinessCategoryId = MBC.nBusinessCategoryID          
                                                                                           AND MBC.CultureCode = @CultureCode          
                                                                                        FOR          
                                                                                          XML PATH('Category'),          
                                                                         TYPE          
                                                                                        )          
                                                                            FOR          
                                                                              XML PATH(''),          
                                    TYPE          
                                                                            ) AS Categories,          
                                                                            @Provider AS Provider,          
                                                                            A.cLocation AS 'Address',          
                                                                            ( SELECT    [ACTLActivity].[fnGetActivityLongLatInfo](AAD.ActivityID)          
                                                                            ),          
                                                                            COALESCE(MLCity.CityName, ACT.CityName) AS 'City',          
                                                                            COALESCE(MLState.StateName, S.StateName) AS 'State',          
                                                                            COALESCE(MLCountry.countryname, Co.EnglishName) AS 'Country',          
                                                                            AAD.Rate AS BestAmount,          
                                                                            CAST(AAD.ActivityDuration AS VARCHAR(10)) + ' ' + COALESCE(MLC.cCodeShortDesc, L.cCodeShortDesc, '') AS Duration,          
                                                                            COALESCE(MLE.cFirstName, E.cFirstName) + ' ' + COALESCE(MLE.cLastName, E.cLastName, '') AS OperatorName,          
                                                                            E.cEmail AS OperatorEmail,          
                                                                            AAD.VendorCode AS Vendor,      
                                                                            --Comment:1      
                   (SELECT TOP 1 PromotionId,PromotionName       
                    FROM  ACTLActivity.GetSchedulePromotion ((SELECT [ExcursionInventory].[GetSchedulesID](@ActivityDate, @CheckOutDate,AAD.ActivityID) ),@ActivityDate,@CheckOutDate      
                               ,0,0)      
                          
                     FOR          
                                                                                          XML PATH(''),          
                                         TYPE         
                                                                             ),      
                                                                  
                             --Comment:1           
                                                                            ( SELECT    ( SELECT    COALESCE(MLC.cCodeShortDesc, CL.cCodeShortDesc) AS [Level]          
                                                                                          FROM      ( SELECT    nActivityLevelID          
                                                                                                      FROM      ExcursionInventory.ActivityLevelType          
                                                                                                      WHERE     nActivityID = AAD.ActivityID          
                                                        ) AL          
                                 INNER JOIN Lookup.CodeLookup CL ON AL.nActivityLevelID = CL.nCodeId          
                                                                                                    LEFT JOIN LookupML.MLCodeLookup MLC ON CL.nCodeID = MLC.nCodeLookupId          
                                                                                                                                           AND MLC.CultureCode = @CultureCode          
                                                                                        FOR          
                                                                                          XML PATH(''),          
                                                                                              TYPE          
                                                                                        )          
                                                                            FOR          
                                                                              XML PATH(''),          
                                                                                  TYPE          
                                                                            ) AS Levels        
                             ,          
                                                                            ( SELECT    ACTLActivity.GetOptionDetails(@ActivityDate, @CheckOutDate, AAD.ActivityID, AAD.ActivitySeasonScheduleID, @AdultCount, @ChildCount, @InfantCount, @ActivityUnitXML, 
																			@CurrencyCode, @CultureCode, @MarkupPercentage, @ConversionFactor, @MarkupAmount, @IsAmountRoundOff, AAD.Status, @IsAddTax,NULL,NULL))--Comment:1   --Comment:2       
                                                                  FROM      ( SELECT  DISTINCT          
                                                                                        *          
                                                                              FROM      @AvailableActivityDetails          
                                                                            ) AAD          
                                                                            INNER JOIN ExcursionInventory.Activities A ON AAD.ActivityID = A.nActivityID          
                                                                            INNER JOIN ExcursionInventory.Excursion E ON AAD.ExcursionID = E.nExcursionID          
                                                                            INNER JOIN ExcursionInventory.ActivityImages AI ON AAD.ActivityID = AI.nActivityID          
                                                                                                                               AND bIsDefault = 1          
                                                                            INNER JOIN Inventory.Images I ON AI.nImageID = I.nImageID          
                                                                            --Comment:U Start    
                   INNER JOIN  ExcursionInventory.ActivityExcursionType AET ON A.nActivityID = AET.nActivityID    
                   INNER  JOIN Lookup.BusinessCategory BL ON AET.nBusinessCategoryID = BL.nBusinessCategoryID          
                                                                                                                                             AND BL.IsDeleted = 0    
                                    AND --CASE WHEN @ActivityTypeID IS NUll THEN BL.nBusinessCategoryParentID  END  IS NULL AND    
                                        
                                    -- ISNULL(BL.nBusinessCategoryParentID,BL.nBusinessCategoryId) =  COALESCE(@ActivityTypeID,BL.nBusinessCategoryParentID,BL.nBusinessCategoryId)    --ADDED on 20170929 KP    
                                    CASE WHEN @ActivityTypeID IS Not NULL THEN BL.nBusinessCategoryParentID     
                                      else BL.nBusinessCategoryID     
                                      END =     
                                    CASE WHEN   @ActivityTypeID IS Not NULL THEN @ActivityTypeID    
                                    Else ISNULL(BL.nBusinessCategoryParentID ,BL.nBusinessCategoryID )    
                                    END    
                                       --ISNULL(@ActivityTypeID,BL.nBusinessCategoryParentID)       
                                          
                                       --ADDED on 20170929 KP    
                                                                            --Comment:U End                
                       
                   LEFT JOIN ExcursionML.MLActivities MACT ON AAD.ActivityID = MACT.nActivityID          
                                                                                                                       AND MACT.CultureCode = @CultureCode          
                                                                            LEFT JOIN ExcursionML.MLExcursion MLE ON MLE.nExcursionID = E.nExcursionID          
                                                                                                                     AND MLE.CultureCode = @CultureCode          
                                                                            LEFT JOIN ExcursionInventory.BusinessType EBT ON A.BusinessTypeID = EBT.ProviderBusinessTypeID          
                                                                                                                             AND EBT.IsDeleted = 0          
                                                                            LEFT JOIN Lookup.BusinessType BT ON EBT.BusinessTypeID = BT.BusinessTypeID          
                                                               AND BT.BusinessID = 3          
                                                                                                                AND BT.IsDeleted = 0          
                                                                            LEFT JOIN Lookup.MLBusinessType MLBT ON BT.BusinessTypeID = MLBT.BusinessTypeID          
                                                                                                                    AND MLBT.CultureCode = @CultureCode          
                                                                            LEFT JOIN Internationalization.Cities ACT ON A.nLocationsId = ACT.CityID          
                                                                            LEFT JOIN InternationalizationML.MLCity MLCity ON ACT.CityID = MLCity.nCityID        
                                                                                                                              AND MLCity.CultureCode = @CultureCode          
                                                                            LEFT JOIN Internationalization.State S ON ACT.StateID = S.StateID          
                                                                            LEFT JOIN InternationalizationML.MLState MLState ON S.StateID = MLState.nStateID          
            AND MLState.CultureCode = @CultureCode          
                                                                            LEFT JOIN Internationalization.Country Co ON S.CountryCode = Co.Code          
                   LEFT JOIN InternationalizationML.MLCountry MLCountry ON Co.Code = MLCountry.Code          
                                                                                                                                    AND MLCountry.CultureCode = @CultureCode          
                                                                            LEFT JOIN Lookup.CodeLookup L ON AAD.ActivityDurationCriteriaID = L.nCodeId          
                                                                            LEFT JOIN LookupML.MLCodeLookup MLC ON L.nCodeID = MLC.nCodeLookupId          
                                                                                                                   AND MLC.CultureCode = @CultureCode          
                                                                                      
                                                                FOR          
                                                                  XML PATH('Activity'),          
                                                                      ROOT('ActivityAvails'),          
                                                                      TYPE          
                                                                )          
                                                    FOR          
                                                      XML PATH('ResponseData'),          
                                                          TYPE          
                                                    )          
                                         FOR          
                                           XML PATH('ActivityAvailRS')          
                                         )          
                END          
            ELSE           
                BEGIN                                        
                    SET @XMLOutput = ( SELECT   ( SELECT    '3' AS 'Type',          
                                                            '0' AS 'Code',          
                                                            'No activity found that match your search criteria' AS 'Message'          
                                                FOR          
                                                  XML PATH('Error'),          
                                                      ROOT('Errors'),          
    TYPE          
                                                )          
                                     FOR          
                                       XML PATH('ActivityAvailRS')          
                                     )                                         
                END           
        END TRY                                        
        BEGIN CATCH                                        
            DECLARE @AdditionalInfo XML                                          
            SELECT  @AdditionalInfo = ( SELECT  @ActivityDate AS ActivityDate,          
                                                @PrimaryLocationName AS PrimaryLocationName,          
                                                @ActivityTypeID AS ActivityTypeID,          
                                                @BusinessTypeID AS BusinessTypeID,          
                                       @CurrencyCode AS CurrencyCode,          
                                                @VendorCode AS VendorCode,          
                                                @Provider AS Provider,          
                                                @MarkupPercentage AS MarkupPercentage,          
                                                @GroupCode AS GroupCode,          
                                                @CheckOutDate AS CheckOutDate,          
                                                @ActivityUnitXML AS ActivityUnitXML,          
                                                @ActivityCodes AS ActivityCodes,          
                                                @CultureCode AS CultureCode,          
                                                @Status AS Status          
                                      FOR          
                                        XML PATH('AdditionalInfo'),          
                                            TYPE          
                                      )                                                   
                                                                        
            EXEC Logging.LogAndRaiseError @ApplicationArea = 'Activity List Service',          
                @AdditionalInfo = @AdditionalInfo, @RaiseError = 'false' ;                                                                  
            WITH XMLNAMESPACES ( DEFAULT 'http://www.avanicimcon.com/XSD' ) --Comment 1                                                                    
            SELECT  @XMLOutput = ( SELECT   CRSServices.ServiceErrorTemplate(3, 202, 'No activity found that match your search criteria', NULL)          
                                 FOR          
                                   XML PATH(''),          
                                       ROOT('ActivityAvailRS'),          
                                       TYPE          
                                 )            
        END CATCH                                        
        SELECT  @XMLOutput                                     
    END        
            
/*        
Comment:1                
Changed By   : Sunny Pathai        
Changed Date : 6th Aug 2014                  
Description  : Implementing the changes for Promotion functionality in Excursion Buisness [passes the PromotionID parameter as Null in ACTLActivity.GetOptionDetails].             
==============================================================        
Comment:2                
Changed By   : Sunny Pathai        
Changed Date : 29th October 2014                  
Description  : Implementing the changes for AddOns functionality in Excursion and Packages [Added the Null value in ActlActivity.GetOptionDetails for AddOnXML Parameter]             
==============================================================    
 */ 