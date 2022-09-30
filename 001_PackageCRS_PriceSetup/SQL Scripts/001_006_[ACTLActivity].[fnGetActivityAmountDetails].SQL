                          
-- User Defined Function                            
/*                                        
Created By : Jignesh Chauhan                                        
Date  : 29/05/2010                                        
Purpose  : To Retrieve Rate Details of Activity                                         
Sample :                                         
DECLARE @CheckInDate DATETIME,                  
    @ScheduleID INT,                  
    @ActivityID INT,                  
    @ActivityUnitXML XML,                  
    @CurrencyCode NVARCHAR(3),                  
    @MarkupPercentage DECIMAL(19,4),                  
    @ConversionFactor DECIMAL(19,10),                  
    @MarkupAmount DECIMAL(19,4),                  
    @IsAmountRoundOff BIT,                  
    @CultureCode VARCHAR(10),                  
    @IsAddTax BIT,      
    @PromotionID INT = NULL,  
    @AddOnsXML XML = NULL                                     
                                           
SET @CheckInDate = '08/25/2014'                                        
SET @ScheduleID = 480                            
SET @ActivityID = 211                                   
SET @CultureCode = 'en-Us'                                  
SET @ActivityUnitXML = '<ActivityUnits xmlns="http://www.avanicimcon.com/XSD">                                              
  <ActivityUnit>                  
   <UnitCategory>Per Adult</UnitCategory>                  
   <Quantity>2</Quantity>                  
  </ActivityUnit>                  
  <ActivityUnit>                  
   <UnitCategory>Per Child</UnitCategory>                  
   <Age>10</Age>                  
  </ActivityUnit>                  
  <ActivityUnit>                  
   <UnitCategory>Per Infant</UnitCategory>                  
   <Quantity>1</Quantity>                  
  </ActivityUnit>                                                          
 </ActivityUnits>'                                     
SET @CurrencyCode = 'INR'                                        
SET @MarkupPercentage = 0                                          
SET @ConversionFactor = 1                                    
SET @MarkupAmount = 0                                    
SET @IsAmountRoundOff = 1                       
SET @IsAddTax = 0       
SET @PromotionID = 7                                 
SET  @AddOnsXML  = --NULL    
     
    '<AddOns>  
  <AddOn>  
    <Code>122</Code>  
    <NAME>TEst 55</NAME>  
    <Description>TEst 55</Description>  
    <CategoryCode>6</CategoryCode>  
    <CategoryName>Test1</CategoryName>  
    <StartTime></StartTime>  
    <EndTime></EndTime>  
    <Charges>  
      <Charge>  
  <ResQuantity>6</ResQuantity>  
        <Amount>111.0000</Amount>  
        <UNIT>Per Day</UNIT>  
        <ChargeCode>347</ChargeCode>  
        <UnitCode>172</UnitCode>  
        <Quantity>-1</Quantity>  
        <AvailableQuantity>-1</AvailableQuantity>  
        <AvailablePromotionQuantity>0</AvailablePromotionQuantity>  
      </Charge>  
    </Charges>  
  </AddOn>  
  <AddOn>  
    <Code>124</Code>  
    <NAME>TEst AddOns</NAME>  
    <Description>TEst AddOn</Description>  
    <CategoryCode>6</CategoryCode>  
    <CategoryName>Test1</CategoryName>  
    <StartTime></StartTime>  
    <EndTime></EndTime>  
    <ComplimentaryAmenity>1</ComplimentaryAmenity>  
    <Charges>  
      <Charge>  
  <ResQuantity>3</ResQuantity>  
        <Amount>221.0000</Amount>  
        <UNIT>Per Person</UNIT>  
        <ChargeCode>373</ChargeCode>  
        <UnitCode>171</UnitCode>  
        <Quantity>10</Quantity>  
        <AvailableQuantity>-1</AvailableQuantity>  
        <IsPromotionAppliedOnAmenities>1</IsPromotionAppliedOnAmenities>  
        <PromotionAmount>200.0000</PromotionAmount>  
        <PromotionQuantity>7</PromotionQuantity>  
        <PromotionAmountChargeCode>374</PromotionAmountChargeCode>  
        <AvailablePromotionQuantity>0</AvailablePromotionQuantity>  
        <PromotionRateCode>18</PromotionRateCode>  
        <IsComplimentaryAmenity>1</IsComplimentaryAmenity>  
      </Charge>  
    </Charges>  
  </AddOn>  
</AddOns>'  
     
                                  
SELECT [ACTLActivity].[fnGetActivityAmountDetails](@CheckInDate,@ScheduleID,@ActivityID,@ActivityUnitXML,@CurrencyCode,@MarkupPercentage,@ConversionFactor,@MarkupAmount,@IsAmountRoundOff,@CultureCode, @IsAddTax,@PromotionID,@AddOnsXML)                    
  
             
    
         
                                        
 */                                        
ALTER FUNCTION [ACTLActivity].[fnGetActivityAmountDetails]            
    (            
      @CheckInDate DATETIME,            
      @ScheduleID INT,            
      @ActivityID INT,            
      @ActivityUnitXML XML,            
      @CurrencyCode NVARCHAR(3),            
      @MarkupPercentage DECIMAL(19, 4) = 0,            
      @ConversionFactor DECIMAL(19, 10) = 1,            
      @MarkupAmount DECIMAL(19, 4) = 0,            
      @IsAmountRoundOff BIT = 0,            
      @CultureCode VARCHAR(10) = 'en-US', --Comment:11                                         
      @IsAddTax BIT = 0, --Comment:16       
      @PromotionID INT = NULL,-- Comment:24                    
      @AddOnsXML XML = NULL  
    )            
RETURNS XML            
AS BEGIN                                        
        DECLARE @XMLOutputRS XML                                        
    DECLARE @BaseRate DECIMAL(19, 4)                                          
    DECLARE @TotalRate DECIMAL(19, 4)                                         
    DECLARE @TotalRateWOTax DECIMAL(19, 4) --Comment:16                      
    DECLARE @TotalTax DECIMAL(19, 4)                                          
    DECLARE @PrepayAmount DECIMAL(19, 4)                                       
    DECLARE @PayonArrival DECIMAL(19, 4)                                         
    DECLARE @CreditCardAmount DECIMAL(19, 4)                                          
    DECLARE @Markup DECIMAL(19, 4)                                      
    DECLARE @BusinessID INT --Comment:21                                  
                                        
   SELECT @BusinessID = nExcursionID FROM ExcursionInventory.Activities WHERE nActivityID = @ActivityID  --Comment:21          
              
    DECLARE @UnitTable TABLE            
        (            
          UnitCategory VARCHAR(50),            
          Quantity INT            
        )                                        
    DECLARE @RateTable TABLE            
        (            
          Unit VARCHAR(50),            
          UnitDescription VARCHAR(500),            
          Amount DECIMAL(19, 4),            
          MinQty INT,            
          MaxQty INT            
        )                                        
    DECLARE @RateDetails TABLE            
        (            
          Amount DECIMAL(19, 4),            
          CurrencyCode NVARCHAR(3),            
          Description NVARCHAR(200),            
          Purpose INT            
        )                                       
                                            
    /*DECLARE @TaxDetailTable TABLE  --Comment:21          
       (            
          nTaxPolicyDetailId INT,            
          nActivityID INT,            
          cTaxName NVARCHAR(50),            
          nTaxItemValue DECIMAL(19, 4)            
        )*/                                     
                                            
-- Set Rate in Temp Table                                        
    INSERT  INTO @RateTable            
            (            
              Unit,            
     UnitDescription,            
              Amount,            
              MinQty,            
              MaxQty                                         
            )            
            ( SELECT    cUnitDescription AS ChargeUnit,            
                        cUnitDescription AS Description,            
                        CASE WHEN ASS.IsHotDeal = 1            
                             THEN ( SELECT rate            
                                    FROM    ExcursionInventory.ActivityHotDealRates            
                                    WHERE   ActivitySeasonID = ASR.nActivitySeasonID            
                                            AND UnitDescription = ASR.cUnitDescription            
                                  )            
                             WHEN ASS.IsHotDeal = 0 THEN ASR.nrate            
                        END AS Amount,            
                        MinQuantity AS [Min],            
                        MaxQuantity AS [Max]            
              FROM      ExcursionInventory.ActivitySeasonRates ASR            
                        INNER JOIN ExcursionInventory.ActivitySeasons ASS ON ASR.nActivitySeasonID = ASS.nActivitySeasonID                            
                        --Comment:12                            
                        INNER JOIN ExcursionInventory.Activities A ON ASS.nActivityID = A.nActivityID            
                        INNER JOIN ( SELECT *            
                                     FROM   ExcursionInventory.Excursion            
                                     WHERE  IsActive = 1            
                                   ) E ON A.nExcursionID = E.nExcursionID                            
                        --Comment:12                            
              WHERE     ASR.nActivitySeasonScheduleID = @ScheduleID            
                        AND ASS.bIsDeleted = 0 --Comment:14                          
                                    
            )      
                  
            --SELECt * FROM @RateTable                                        
 -- Comment 2                                                 
    IF ( ( SELECT   COUNT(*)            
           FROM     @RateTable            
         ) > 0 )             
        BEGIN                                    
   -- Insert Unit Data from Request into Unit Table                                        
    ;                    
            WITH XMLNAMESPACES ( 'http://www.avanicimcon.com/XSD' AS ACTL )                                        
            INSERT  INTO @UnitTable            
                    (            
                      UnitCategory,            
                      Quantity            
                    )            
                    (  
      --SELECT UnitCategory,      --Comment:by Rajesh Muliya  
      --  Quantity   
      --FROM ACTLActivity.fnGetAdultChildFromChildAge(@ScheduleID,@ActivityUnitXML,@CheckInDate)  
  
      SELECT  U.AU.value('ACTL:UnitCategory[1]', 'VARCHAR(50)') AS Unit,            
          U.AU.value('ACTL:Quantity[1]', 'INT') AS Quantity            
       FROM    @ActivityUnitXML.nodes('//ACTL:ActivityUnit') U ( AU )      
       WHERE U.AU.value('ACTL:Quantity[1]', 'INT') > 0  
                    )  
            IF EXISTS ( SELECT  1            
                        FROM    @UnitTable            
                        WHERE   UnitCategory IS NOT NULL )             
                BEGIN                  
                    SELECT  @BaseRate = ACTLActivity.fnRoundOffNumber(SUM(UT.Quantity * RT.Amount))            
                    FROM    @RateTable RT            
                            INNER JOIN @UnitTable UT ON RT.Unit = UT.UnitCategory       
                                  
  
                END                  
   ELSE             
                BEGIN                  
                    SELECT TOP 1            
                            @BaseRate = Amount            
                    FROM    @RateTable                  
                END         
                      
                --SELECt @BaseRate      
                            
                --Comment:24        
                      
                  
                 IF EXISTS (SELECT 1 FROM ExcursionInventory.Activities A       --Comment:29 Start   
        INNER JOIN Lookup.CodeLookup CL ON A.nRateTypeID = CL.nCodeId   
       WHERE CL.cCodeShortDesc = 'Per Equipment'  AND A.nActivityID=@ActivityID)            
                BEGIN                  
                      
                    SELECT TOP 1            
                            @BaseRate = Amount            
                    FROM    @RateTable                  
                END                     --Comment:29 End  
                  
                DECLARE @CommissionAmount DECIMAL(19,2),     --Comment:23  Start        
        @BaseCoseRate DECIMAL(19,2),        
        @CommissionType VARCHAR(20),        
        @CommissionValue DECIMAL(19, 2)        
              
     SELECT @CommissionType = COALESCE(EAS.CommissionType,'Percentage'),        
      @CommissionValue = COALESCE(EAS.CommissionAmount,0)        
     FROM ExcursionInventory.ActivitySeasons EAS         
     INNER JOIN ExcursionInventory.ActivitySeasonSchedules ASS ON EAS.nActivitySeasonID = ASS.nActivitySeasonID        
     WHERE EAS.nActivityID = @ActivityID        
     AND ASS.nActivitySeasonScheduleID = @ScheduleID            
                
     SELECT @BaseCoseRate = CRSServices.CalculateCommissionableAmount(COALESCE(@BaseRate,0),@CommissionValue,@CommissionType)        
                
     SELECT @CommissionAmount = @BaseRate - @BaseCoseRate  -- Comment:23  END       
                      
                      
                DECLARE @Difference INT ,      
        @CutOffDays INT,      
        @PromotionRate DECIMAL(19,2),      
        @PromotionCostRate DECIMAL(19,2),      
        @Discount DECIMAL(19,2),      
        @DiscountCostRate DECIMAL(19,2)                   
    SELECT  @Difference = COALESCE(TZ.GMTDifference,          
       DATEDIFF(mi, GETUTCDATE(), GETDATE()))        
    FROM       
     (SELECt *       
      FROM ExcursionInventory.ActivitySeasonSchedules      
      WHERE nActivitySeasonScheduleID =@ScheduleID) ASS      
      INNER JOIN ExcursionInventory.ActivitySeasons ACS ON ACS.nActivitySeasonID = ASS.nActivitySeasonID       
      INNER JOIN ExcursionInventory.Activities A ON A.nActivityID = ACS.nActivityID      
      INNER JOIN ExcursionInventory.Excursion E ON E.nExcursionID = A.nExcursionID      
      INNER JOIN Entity.BusinessProfile BP ON E.nBusinessProfileID = BP.nBusinessProfileID          
      LEFT JOIN Internationalization.TimeZone TZ ON BP.TimeZoneID = TZ.TimeZoneID       
            
     
                 SET @CutOffDays = DATEDIFF(d, DATEADD(mi, @Difference, GETUTCDATE()),          
                                   @CheckInDate)                                                      
     IF @CutOffDays < 0           
     BEGIN                                                    
      SET @CutOffDays = 0                                                    
     END          
                      
                DECLARE @PromotionRateDetails TABLE      
      (      
       ActivitySeasonScheduleID INT,      
       PromotionID INT,      
       PromotionCode NVARCHAR(200),      
       PromotionName NVARCHAR(MAX),      
       PromotionType NVARCHAR(100),      
       PromotionRate DECIMAL(19,4),      
       PromotionCostRate DECIMAL(19,4)      
      )      
            
     INSERT INTO @PromotionRateDetails      
     (      
      ActivitySeasonScheduleID,      
      PromotionID ,      
      PromotionCode,      
      PromotionName ,      
      PromotionType ,      
      PromotionRate ,      
      PromotionCostRate       
     )      
     SELECT       
      GSP.ActivitySeasonScheduleID,      
      GSP.PromotionID ,      
      GSP.PromotionCode,      
      GSP.PromotionName ,      
      GSP.PromotionType ,      
      GSP.PromotionRate ,      
      GSP.PromotionCostRate       
     FROM ACTLActivity.GetSchedulePromotion(CAST (@ScheduleID as NVARCHAR(MAX)), @CheckInDate ,NULL,@BaseRate,@BaseCoseRate) GSP  --Comment:25     
     WHERE GSP.PromotionId = COALESCE(@PromotionID,0)                    
                      
                --SELECt @CheckInDate      
                --SELECT * FROM @PromotionRateDetails      
         SELECt @PromotionRate = PromotionRate ,@PromotionCostRate = PromotionCostRate FROM @PromotionRateDetails       
                      
                SET @Discount = @BaseRate - @PromotionRate      
                SET @DiscountCostRate = @BaseCoseRate - @PromotionCostRate      
                    
                --Comment:24      
                      
                          
                     
   --Comment:18                  
/*Calculating Tax*/                                    
   -- Comment 5                                    
            /*IF EXISTS ( SELECT  *            --Comment:21          
                        FROM    ExcursionInventory.vwActivityTaxPolicies            
                        WHERE   ActivityId = @ActivityID            
                            AND @CheckInDate >= dFromDate            
                                AND @CheckInDate <= dToDate )             
                BEGIN                                    
                    INSERT  INTO @TaxDetailTable            
                            (            
                              nTaxPolicyDetailId,            
                              nActivityID,            
                              cTaxName,            
                              nTaxItemValue                                    
                            )            
                            SELECT  nExcursionTaxPolicyDetailID,            
                                    @ActivityID,            
                                    cTaxItemName,            
                                    nTaxItemValue            
                            FROM    ExcursionInventory.ExcursionTaxPolicy ETP            
                                    INNER JOIN ExcursionInventory.ExcursionTaxPolicyDetails ETPD ON ETP.nExcursionTaxPolicyID = ETPD.nExcursionTaxPolicyID            
                                    LEFT JOIN ExcursionInventory.vwActivityTaxPolicies ATP ON ETP.nExcursionID = ATP.nExcursionID            
                                                                                              AND ATP.ActivityID = @ActivityID            
                                                                                              AND @CheckInDate >= ATP.dFromDate            
                                                                                              AND @CheckInDate <= ATP.dToDate            
                            WHERE   ETP.nExcursionID = ( SELECT nExcursionID            
                                              FROM   ExcursionInventory.Activities            
                                                         WHERE  nActivityID = @ActivityID            
                                                       )            
                                    AND @CheckInDate >= ETP.dFromDate            
                                    AND @CheckInDate <= ETP.dToDate            
                                    AND ETP.nExcursionTaxPolicyID = COALESCE(ATP.nExcursionTaxPolicyID, ETP.nExcursionTaxPolicyID)                                      
                                    
                END                                    
            ELSE             
                BEGIN                                    
                    INSERT  INTO @TaxDetailTable            
    (            
                              nTaxPolicyDetailId,            
                              nActivityID,            
                              cTaxName,            
                              nTaxItemValue                                    
                            )            
                            SELECT  nExcursionTaxPolicyDetailID,            
                                    @ActivityID,            
                                    cTaxItemName,            
                                    nTaxItemValue            
                            FROM    ExcursionInventory.ExcursionTaxPolicy ETP            
                          INNER JOIN ExcursionInventory.ExcursionTaxPolicyDetails ETPD ON ETP.nExcursionTaxPolicyID = ETPD.nExcursionTaxPolicyID            
                            WHERE   ETP.nExcursionID = ( SELECT nExcursionID            
                                                         FROM   ExcursionInventory.Activities            
                                                         WHERE  nActivityID = @ActivityID            
                                                       )            
                                    AND @CheckInDate >= ETP.dFromDate            
                                    AND @CheckInDate <= ETP.dToDate            
                                    AND ETP.nExcursionTaxPolicyID NOT IN (            
                                    SELECT  nExcursionTaxPolicyID            
                                    FROM    ExcursionInventory.vwActivityTaxPolicies )                                    
                     
                                     
                END */                                  
   -- Comment 5                                                   
            DECLARE @NetTaxPercentage DECIMAL(19, 4)                                     
            SET @NetTaxPercentage = 0                                    
            SELECT @NetTaxPercentage = TotalTaxPercentage,   --Comment:21          
     @TotalTax = TotalTaxAmount               
            FROM    CRSServices.CalculateTax('Excursion',@BusinessID,@CheckInDate,@BaseRate,@ActivityID)                                       
                                       
            --SET @TotalTax = ACTLActivity.fnRoundOffNumber(ISNULL(SUM(( ( @NetTaxPercentage * @BaseRate ) / 100 )), 0))      --Comment:21                                                                                    
            SELECT  @TotalRate = ACTLActivity.fnRoundOffNumber(  
                @BaseRate - ISNULL(@Discount,0) + ISNULL(@TotalTax, 0)  
                --+(SELECT ACTLActivity.fnCalculateAddOnsRate(COALESCE(@AddOnsXML,'<AddOns></AddOns>')))  
                ),  --Comment:24    --Comment:26   --Comment:27  
                    @TotalRateWOTax = ACTLActivity.fnRoundOffNumber(  
                 @BaseRate - ISNULL(@Discount,0)  
                 --+(SELECT ACTLActivity.fnCalculateAddOnsRate(COALESCE(@AddOnsXML,'<AddOns></AddOns>')))  
                 )      --Comment:16 --Comment:24    --Comment:26    --Comment:27                    
                                                      
/*Calculating Payment Policy*/                             
            DECLARE @PaymentCriteria NVARCHAR(100)                                          
            DECLARE @PaymentChargeUnit NVARCHAR(100)                                          
            DECLARE @PaymentChargeAmount DECIMAL(19, 4) --Comment:15                        
   -- Comment 5       
         
   --Comment:24        
   DECLARE @PromotionPolicyCount INT      
     SELECT @PromotionPolicyCount = COUNT(*) from ExcursionInventory.ViewExcursionPaymentPolicyDetails EPP       
       INNER JOIN (SELECT * FROM ACTLCRS.PromotionPolicy       
          WHERE PromotionID = @PromotionID      
          AND PolicyType='Payment')PP ON EPP.nExcursionPaymentPolicyId = PP.PolicyID       
                     
           IF @PromotionId IS NOT NULL            
    AND @PromotionId <> ''                
    AND @PromotionId <> 0      
    AND @PromotionPolicyCount > 0                 
    BEGIN      
     SELECT  @PaymentCriteria = ISNULL(EPP.cCodeShortDesc, ''),            
          @PaymentChargeUnit = ISNULL(EPP.cChargeUnitDescription,            
                 ''),            
          @PaymentChargeAmount = ISNULL(EPP.nAmount, '0')            
        FROM    ExcursionInventory.ViewExcursionPaymentPolicyDetails EPP       
         INNER JOIN (SELECT * FROM ACTLCRS.PromotionPolicy       
            WHERE PromotionID = @PromotionID      
             AND PolicyType='Payment')PP ON EPP.nExcursionPaymentPolicyId = PP.PolicyID           
        WHERE   EPP.nExcursionID = ( SELECT nExcursionID            
                FROM   ExcursionInventory.Activities            
                WHERE  nActivityID = @ActivityID            
                 )           
                    
          AND EPP.nExcursionPaymentPolicyId NOT IN (            
          SELECT  nExcursionPaymentPolicyId            
          FROM    ExcursionInventory.vwActivityPaymentPolicies )         
    END       
   ELSE      
    BEGIN                                             
     IF EXISTS ( SELECT  *            
        FROM    ExcursionInventory.vwActivityPaymentPolicies            
        WHERE   ActivityId = @ActivityID            
          AND @CheckInDate >= dFromDate            
          AND @CheckInDate <= dToDate )             
      BEGIN                                    
                                      
       SELECT  @PaymentCriteria = ISNULL(EPP.cCodeShortDesc, ''),            
         @PaymentChargeUnit = ISNULL(EPP.cChargeUnitDescription,            
                ''),            
         @PaymentChargeAmount = ISNULL(EPP.nAmount, '0')            
       FROM    ExcursionInventory.ViewExcursionPaymentPolicyDetails EPP            
         LEFT JOIN ExcursionInventory.vwActivityPaymentPolicies APP ON EPP.nExcursionID = APP.nExcursionID            
                          AND APP.ActivityID = @ActivityID            
                          AND @CheckInDate >= APP.dFromDate            
                          AND @CheckInDate <= APP.dToDate            
       WHERE   EPP.nExcursionID = ( SELECT nExcursionID            
               FROM   ExcursionInventory.Activities            
               WHERE  nActivityID = @ActivityID            
                )            
         AND @CheckInDate >= EPP.dFromDate            
         AND @CheckInDate <= EPP.dToDate            
         AND EPP.nExcursionPaymentPolicyID = COALESCE(App.nExcursionPaymentPolicyID, EPP.nExcursionPaymentPolicyID)                                        
                                                                                           
      END                                    
     ELSE             
      BEGIN                                    
                                        
       SELECT  @PaymentCriteria = ISNULL(EPP.cCodeShortDesc, ''),            
         @PaymentChargeUnit = ISNULL(EPP.cChargeUnitDescription,            
                ''),            
         @PaymentChargeAmount = ISNULL(EPP.nAmount, '0')            
       FROM    ExcursionInventory.ViewExcursionPaymentPolicyDetails EPP            
       WHERE   EPP.nExcursionID = ( SELECT nExcursionID            
               FROM   ExcursionInventory.Activities            
               WHERE  nActivityID = @ActivityID            
                )            
         AND @CheckInDate >= EPP.dFromDate            
         AND @CheckInDate <= EPP.dToDate            
         AND EPP.nExcursionPaymentPolicyId NOT IN (            
         SELECT  nExcursionPaymentPolicyId            
         FROM    ExcursionInventory.vwActivityPaymentPolicies )                                    
      END        
    END      
  --Comment:24                                        
   -- Comment 5                                    
                                        
          IF @PaymentCriteria <> ''            
                AND @PaymentCriteria IS NOT NULL                            
                --AND LOWER(@PaymentCriteria) = 'instant'  Comment:10                            
                BEGIN                                          
                    IF LOWER(@PaymentCriteria) = 'instant' --Comment:10                            
                        BEGIN                             
                            IF LOWER(@PaymentChargeUnit) = 'percentage'             
                                BEGIN                                          
                                    --Comment:16        
          --SET @PrepayAmount = ACTLActivity.fnRoundOffNumber(( @TotalRate * @PaymentChargeAmount ) / 100)                                          
          --Comment:22          
                                    --IF @IsAddTax = 0             
                                    --    BEGIN                      
                                    --        SET @PrepayAmount = ACTLActivity.fnRoundOffNumber(( @TotalRateWOTax * @PaymentChargeAmount ) / 100)                      
                                    --    END                      
                                    --ELSE             
                                        BEGIN                      
                                            SET @PrepayAmount = ACTLActivity.fnRoundOffNumber(( @TotalRate * @PaymentChargeAmount ) / 100)                      
                                        END                      
                                    --Commnet:16                      
                                END                                          
                            ELSE             
                                IF LOWER(@PaymentChargeUnit) = 'amount'             
                                    BEGIN                                          
                                        --Commnet:16            
                                        --Comment:22                    
                                        --IF @IsAddTax = 0             
                                        --    BEGIN                      
                                        --        IF @TotalRateWOTax >= @PaymentChargeAmount             
                                        --            BEGIN                                          
                                        --                SET @PrepayAmount = ACTLActivity.fnRoundOffNumber(@PaymentChargeAmount)                          
                                        --            END                                          
                                        --        ELSE             
                                        --            BEGIN                                          
                                        --                SET @PrepayAmount = @TotalRateWOTax                                          
                                        --            END                                          
                                        --    END                      
                                        --ELSE                      
   --Commnet:16                       
                                            BEGIN                      
                                                IF @TotalRate >= @PaymentChargeAmount             
                                                    BEGIN                                          
                                                        SET @PrepayAmount = ACTLActivity.fnRoundOffNumber(@PaymentChargeAmount)                                    
                                                    END                                          
                                                ELSE             
                                                 BEGIN                                          
                                                        SET @PrepayAmount = @TotalRate                                          
                                                    END                        
                                            END                                         
                                    END                                          
                                ELSE             
                                    IF LOWER(@PaymentChargeUnit) = 'fullamount'             
                                        BEGIN                                          
                                            --Commnet:16                      
                                            --SET @PrepayAmount = @TotalRate                      
                                            --Comment:22          
                                            --IF @IsAddTax = 0             
                                            --    BEGIN                      
                                            --        SET @PrepayAmount = @TotalRateWOTax                    
                                            --    END                      
                                            --ELSE             
                                                BEGIN                      
                                                    SET @PrepayAmount = @TotalRate                      
                                                END                      
                                        --Comment:16                      
                                        END                                 
                        END                             
                    ELSE             
                        BEGIN                            
                            SET @PrepayAmount = 0                            
                        END                             
                                                                     
                END                                          
            ELSE /* Payment Policy is not available OR payment criteria is not 'instant'. So, payable amount is total amount. */             
                BEGIN                                          
                -- Comment : 4                                    
                /* Payment Policy is not available OR payment criteria is not 'instant'. So, payable amount is zero. */                                     
                    --SET @PrepayAmount = 0                                          
                    --Commnet:16                      
                    --SET @PrepayAmount = @TotalRate  --Comment:10                       
                    --Comment:22          
                    --IF @IsAddTax = 0             
                    --    BEGIN                      
                    --        SET @PrepayAmount = @TotalRateWOTax                      
                    --    END                      
                    --ELSE             
                        BEGIN                      
                            SET @PrepayAmount = @TotalRate                      
                        END                      
                    --Comment:16                                       
    -- Comment : 4                                    
                END                                          
                                            
/*Calculating Credit Card Policy*/              
/*                                       
            DECLARE @CreditCardChargeUnit NVARCHAR(100)                                    
            DECLARE @CreditCardChargeAmount DECIMAL(19, 4)                                           
   -- Comment 5                                    
            IF EXISTS ( SELECT  *            
                        FROM    ExcursionInventory.vwActivityCreditCardPolicies            
                        WHERE   ActivityId = @ActivityID            
                                AND @CheckInDate >= dFromDate            
                         AND @CheckInDate <= dToDate )             
                BEGIN                                    
                                    
                    SELECT  @CreditCardChargeUnit = ISNULL(ECC.cChargeUnitDescription,            
                                                           ''),            
                            @CreditCardChargeAmount = ISNULL(ECC.nAmount, '0')            
                    FROM    ExcursionInventory.ViewExcursionCreditCardPolicy ECC            
                            LEFT JOIN ExcursionInventory.vwActivityCreditCardPolicies ACC ON ECC.nExcursionID = ACC.nExcursionID            
                                                                           AND ACC.ActivityID = @ActivityID            
                                                                                             AND @CheckInDate >= ACC.dFromDate            
                                                                                             AND @CheckInDate <= ACC.dToDate            
                    WHERE   ECC.nExcursionID = ( SELECT nExcursionID            
                                         FROM   ExcursionInventory.Activities            
                               WHERE  nActivityID = @ActivityID            
                                               )            
                            AND @CheckInDate >= ECC.dFromDate            
                            AND @CheckInDate <= ECC.dToDate            
                            AND ECC.nExcursionCreditCardPolicyId = COALESCE(ACC.nExcursionCreditCardPolicyId, ECC.nExcursionCreditCardPolicyId)                                              
                END                                    
            ELSE             
                BEGIN                                    
                    SELECT  @CreditCardChargeUnit = ISNULL(ECC.cChargeUnitDescription,            
                                                           ''),            
                            @CreditCardChargeAmount = ISNULL(ECC.nAmount, '0')            
                    FROM    ExcursionInventory.ViewExcursionCreditCardPolicy ECC            
                    WHERE   ECC.nExcursionID = ( SELECT nExcursionID            
                                                 FROM   ExcursionInventory.Activities            
                                                 WHERE  nActivityID = @ActivityID            
                                               )            
                            AND @CheckInDate >= ECC.dFromDate            
                            AND @CheckInDate <= ECC.dToDate            
                            AND ECC.nExcursionCreditCardPolicyId NOT IN (            
                            SELECT  nExcursionCreditCardPolicyId            
                            FROM    ExcursionInventory.vwActivityCreditCardPolicies )                                    
                                                    
                END                                    
   -- Comment 5                                    
            SET @CreditCardAmount = 0           
                                    
            IF LOWER(@CreditCardChargeUnit) = 'amount'             
                BEGIN                                    
                    SET @CreditCardAmount = ACTLActivity.fnRoundOffNumber(@CreditCardChargeAmount)                                    
                END                                    
            ELSE             
                IF LOWER(@CreditCardChargeUnit) = 'percentage'             
                    BEGIN                                    
                        SET @CreditCardAmount = ACTLActivity.fnRoundOffNumber(( @PrepayAmount * @CreditCardChargeAmount ) / 100)                                    
                    END                                    
   -- Comment : 3                                    
            SET @PrepayAmount = @PrepayAmount + @CreditCardAmount                                    
-- Comment : 3                                
            SET @TotalRate = @TotalRate + @CreditCardAmount                       
            SET @TotalRateWOTax = @TotalRateWOTax + @CreditCardAmount --Commnet:16                      
               */                                                                          
                                            
-- Set PayonArrival Amount                                        
            --Comment:16                      
            --SET @PayonArrival = ISNULL(( @TotalRate - @PrepayAmount ), 0)                      
            --Comment:22          
 --IF @IsAddTax = 0             
            --    BEGIN                      
            --        SET @PayonArrival = ISNULL(( ISNULL(@TotalRateWOTax, 0)            
            --                                     - ISNULL(@PrepayAmount, 0) ),            
            --                                   0)                      
            --    END                      
            --ELSE             
                BEGIN                      
                    SET @PayonArrival = ISNULL(( ISNULL(@TotalRate, 0)            
                                                 - ISNULL(@PrepayAmount, 0) ),            
                                               0)                      
                END                                        
            --Comment:16                                              
--Comment:13                              
-- Comment 9                                    
-- Set Marukup Percentage.                                          
            SELECT  @Markup = CASE WHEN @MarkupPercentage > 0            
                                        OR @MarkupAmount > 0            
                                   THEN [ACTLActivity].[fnCalculateMarkup](@TotalRate, @ConversionFactor, @MarkupPercentage, @MarkupAmount, @IsAmountRoundOff)            
                                   ELSE 0            
                              END                                   
                              
   -- Calculating Unit wsie markup                              
            /*                            
            SELECT  @Markup = SUM([ACTLActivity].[fnCalculateMarkup](Amount, @ConversionFactor, @MarkupPercentage, @MarkupAmount, @IsAmountRoundOff)                            
                                  * UT.Quantity)                            
            FROM    @RateTable RT                            
                    INNER JOIN @UnitTable UT ON RT.Unit = UT.UnitCategory                            
            WHERE   UT.Quantity > 0                               
            */                            
-- Comment 9                            
--Comment:13                            
                                        
 /*                                     
 Purpose  Description                                          
 -------  -----------                                          
  1  Base Rate                                          
  2  Markup                                          
  3  Discount  (ex. Promotion)                                          
  4  Paid Amount (ex. Already paid during booking and use in modification)                                          
  5  Surcharge (ex. Credit Card Surcharge)                                          
  6  Fee                                          
  7  Tax                                          
  8  Prepay Amount (ex. Amount due to payment policy)                                           
  9  Pay on arrival                                          
  10  Total                                          
  11      Cancellation Amount                                          
                                            
 */                                        
   --Comment:24 Commission Changes taken above for the Pronotion Related Changes( need Base Cost rate)      
 /*      
  DECLARE @CommissionAmount DECIMAL(19,2),     --Comment:23  Start        
       @BaseCoseRate DECIMAL(19,2),        
       @CommissionType VARCHAR(20),        
       @CommissionValue DECIMAL(19, 2)        
              
    SELECT @CommissionType = COALESCE(EAS.CommissionType,'Percentage'),        
     @CommissionValue = COALESCE(EAS.CommissionAmount,0)        
    FROM ExcursionInventory.ActivitySeasons EAS         
    INNER JOIN ExcursionInventory.ActivitySeasonSchedules ASS ON EAS.nActivitySeasonID = ASS.nActivitySeasonID        
    WHERE EAS.nActivityID = @ActivityID        
    AND ASS.nActivitySeasonScheduleID = @ScheduleID            
            
    SELECT @BaseCoseRate = CRSServices.CalculateCommissionableAmount(COALESCE(@BaseRate,0),@CommissionValue,@CommissionType)        
            
    SELECT @CommissionAmount = @BaseRate - @BaseCoseRate  -- Comment:23  END       
*/      
--Comment:24      
      
                                         
   -- Insert Rate Details into To Rate Details Table                                                    
            INSERT  INTO @RateDetails            
                    (            
                      Amount,            
                      CurrencyCode,            
                      Description,            
                      Purpose                                        
                    )            
                    (                                         
         -- Comment 1                                      
                      SELECT    ISNULL(@BaseRate, 0) * @ConversionFactor,            
                                @CurrencyCode,            
        'Base Rate',            
                                1            
                      UNION          
                      SELECT    ISNULL(@Markup, 0),            
                                @CurrencyCode,            
                                'Markup',            
                                2         
                                UNION       
                      --Comment:24                     
                      SELECT    ISNULL(@Discount, 0) * @ConversionFactor,            
                                @CurrencyCode,            
                                'Discount',            
                                3      
                      --Comment:24                                             
     /*                                    
                      UNION            
                      SELECT    ISNULL(@CreditCardAmount, 0)            
                                * @ConversionFactor,            
                                @CurrencyCode,            
                                'Credit Card Surcharge',            
                                5                              */            
                      UNION            
                      SELECT    /*( ( nTaxItemValue * @BaseRate ) / 100 )*/            
                                ISNULL(@TotalTax, 0) * @ConversionFactor AS Amount,            
                                @CurrencyCode,                  
                                --cTaxName AS Description,                  
                                'Tax' AS Description,            
                                7            
                      UNION            
                      SELECT    ISNULL(@PrepayAmount, 0) * @ConversionFactor,            
                                @CurrencyCode,            
                                'Prepay Amount',            
                                8            
                      UNION            
                      SELECT    ISNULL(@PayonArrival, 0) * @ConversionFactor,            
                                @CurrencyCode,            
                                'Pay on arrival',            
                                9            
                      UNION            
                      SELECT    ISNULL(@TotalRate, 0) * @ConversionFactor,            
                      @CurrencyCode,            
                                'Total Rate',            
                                10            
        UNION            
                      SELECT    ISNULL(@CommissionAmount, 0) * @ConversionFactor,    --Comment:23        
                                @CurrencyCode,            
                                'Commission Amount',            
                                20               
                            
                    )                                        
   -- Comment 1                                      
             
   --Comment:6                                 
   --Comment:11             
            DECLARE @ActivityRateUnitID INT                            
            SELECT  @ActivityRateUnitID = nCodeID            
            FROM    Lookup.CodeLookup            
            WHERE   cCodeShortDesc = 'ActivityRateUnit'                            
   --Comment:11               
                            
            SET @XMLOutputRS = ( SELECT ( SELECT    CASE WHEN ASS.IsHotDeal = 1                                   
               -- Comment 7,8                                  
                                                              THEN ( SELECT ( SELECT    [ACTLActivity].[fnGetScheduleNetRate](@CheckInDate, @ActivityID, rate, @ConversionFactor, @MarkupPercentage, @MarkupAmount, 
															  @IsAmountRoundOff, 1, @IsAddTax) --Comment:16                      
                                                                                          
                                                                            ) -- @IsWithMarkup = 1                                  
                                                                     FROM   ExcursionInventory.ActivityHotDealRates            
                                                                     WHERE  ActivitySeasonID = ASR.nActivitySeasonID            
                   AND UnitDescription = ASR.cUnitDescription            
                                                                   )            
                                                         WHEN ASS.IsHotDeal = 0            
                                                         THEN ( SELECT  [ACTLActivity].[fnGetScheduleNetRate](@CheckInDate, @ActivityID, ASR.nrate, @ConversionFactor, @MarkupPercentage, @MarkupAmount, @IsAmountRoundOff, 1, @IsAddTax) --Comment:16         
  
  
    
      
        
          
            
                                                                            
                                                              ) -- @IsWithMarkup = 1                                  
                                                         -- Comment 7,8                                  
              END AS Amount,            
                                                    @CurrencyCode AS CurrencyCode, --Comment:17                    
                                                    COALESCE(MLC.cCodeShortDesc,            
                                                             ASR.cUnitDescription) AS Description, --Comment:11                            
                                                    COALESCE(MLC.cCodeShortDesc,            
                                                             ASR.cUnitDescription) AS ChargeUnit--, --Comment:11 ,      
                                                   -- PRD.PromotionID,      
                                                   -- PRD.PromotionName                                    
                                          FROM      ExcursionInventory.ActivitySeasonRates ASR            
                                                    INNER JOIN ExcursionInventory.ActivitySeasons ASS ON ASR.nActivitySeasonID = ASS.nActivitySeasonID      
                                                    INNER JOIN @PromotionRateDetails PRD ON ASR.nActivitySeasonScheduleID = PRD.ActivitySeasonScheduleID                  
                                                    --Comment:11                            
                                                    LEFT JOIN Lookup.CodeLookup C ON ASR.cUnitDescription = C.cCodeShortDesc            
                                                                                     AND C.nParentCodeID = @ActivityRateUnitID            
               LEFT JOIN LookupML.MLCodeLookup MLC ON C.nCodeID = MLC.nCodeLookupID            
                                                                                           AND MLC.CultureCode = @CultureCode                            
                                                    --Comment:11                            
                                          WHERE     ASR.nActivitySeasonScheduleID = @ScheduleID            
                                                    AND ASS.bIsDeleted = 0 --Comment:14                          
                                  FOR            
                                          XML PATH('Charge'),            
                       TYPE            
                                        ),            
                                        ( SELECT    *            
                                          FROM      @RateDetails            
                                          ORDER BY  Purpose            
                                        FOR            
                                          XML PATH('Charge'),            
                                              TYPE            
                                        )            
                               FOR            
                                 XML PATH(''),            
                                     ROOT('Charges'),            
                                     TYPE            
                               )                                        
           --Comment:6                                    
        END                                    
    ELSE             
        BEGIN                                    
            SET @XMLOutputRS = ( SELECT ( SELECT    '3' AS 'Type',            
                                                    '0' AS 'Code',            
                                                    'No schedules available.' AS 'Message'            
                                        FOR            
                                          XML PATH('Error'),            
                                              ROOT('Errors'),            
                                              TYPE            
                                        )            
                               FOR            
                                 XML PATH('Charges')            
                               )                                         
        END        
                                            
    RETURN @XMLOutputRS                                        
   END                                       
                                         
/*                                      
Comment 1 : Provide Is null check for all type of rate if rate is null than set to 0                                      
Changed By : Jignesh Chauhan                                      
Changed Date : 01/06/2010                                      
-------------------------------------                                    
Comment 2 : To check schedule rates are available or not                            
Changed By : Naiensh Tailor                                    
Changed Date : 22/06/2010                           
-------------------------------------                                    
Comment 3 : To add credit Card amount in to prepayamount.                                    
Changed By : Naiensh Tailor                                    
Changed Date : 26/06/2010                            
-------------------------------------                                    
Comment 4 : Payable amount should be zero if no payment policy applicable or payment option is not equal to 'INSTANT'.                                    
Changed By : Naiensh Tailor                                    
Changed Date : 30/06/2010                                    
-------------------------------------                                  
Comment 5 : Issue ID - 20021288                                  
Changed By : Naiensh Tailor                                  
Changed Date : 01/07/2010                                  
-------------------------------------------------------------                                    
Comment:6                                    
Changed By : Jignesh Chauhan              
Changed Date : 07/02/2010                                    
Description : As Per discussion with nainesh bhai                                    
Add Per person / Per equipment rate in charges section                                    
-------------------------------------                                  
Comment 7 : As per the email from Bhoomika Added markup values into unit rates.                                  
Changed By : Naiensh Tailor                                  
Changed Date : 27/07/2010                                  
-------------------------------------                                  
Comment 8 : Added Tax, CreditCard surcharge & markup value into base unit rate. (Issue ID : 20021452)                            
Changed By : Naiensh Tailor                                  
Changed Date : 31/07/2010                                 
-------------------------------------                                  
Comment 9 : Calculation unit wise markup to resolve issue Id : 20024235                              
Changed By : Naiensh Tailor                                  
Changed Date : 17/02/2012                                
=========================================================================                            
Comment:10                            
Changed By : Jignesh Chauhan                            
Changed Date : 06 Apr,2012                            
Description : Resolve issue in case of no payment policy is define for activity than set prepay amount as total amount(100%) payment. Making this changes based on hotel. And also discuss same with Ashok sir                             
=========================================================================                            
Comment:11                            
Changed By   : Sanket Mehta                            
Changed Date : 20th April 2012                            
Description  : ML related changes (To show Charge Unit in ML)                            
=========================================================================                            
Comment:12                            
Changed By   : Sanket Mehta                            
Changed Date : 18th June 2012                            
Description  : Business Active / Inactive functionality.                            
    Only Activity OF Active Excursion would be displayed.                            
=========================================================================                            
Comment:13                            
Changed By   : Sanket Mehta                            
Changed Date : 14th September 2012                            
Description  : Markup TO be calculated ON Total Rate                            
Reference    : Discussion WITH Samir (Previously Parent Masrkup was NOT available)                            
=========================================================================                            
Comment:14                          
Changed By   : Sanket Mehta                              
Changed Date : 1st October 2012                              
Purpose      : Kept CHECK OF Deleted Flag so that IN RS gets ONLY the active AND nondelete activity                          
=========================================================================                            
Comment:15                        
Changed By   : Sanket Mehta                              
Changed Date : 11th October 2012                              
Purpose      : PaymentChargeAmount changed datatype FROM DECIMAL TO DECIMAL(19, 4).                         
     DECIMAL point was NOT accepted                        
=========================================================================                            
Comment:16                      
Changed By   : Sanket Mehta                              
Changed Date : 13th February 2013                      
Purpose      : AS discussed WITH Samir AND Riddhi TO give PrePay AND Pay ON Arrival without Tax.                  
    Need TO implement IN Activity List, OPTION details and CHECK Avail SERVICE.                      
=========================================================================                            
Comment:17                    
Changed By   : Sanket Mehta                              
Changed Date : 18th February 2013                      
Purpose      : AS discussed WITH Riddhi, TO give Charges IN CRS Currency. So Currency Param IS kept NULLABLE AND                     
    IF Currency Param IS NULL THEN GROUP Code Currency IS passed AND displayed IN Response.                    
--=========================================================================                         
Comment:18                  
Changed By   : Sanket Mehta                              
Changed Date : 6th September 2013                      
Purpose      : Per Equipment Activity NOT getting IN List.                  
--=========================================================================                         
Comment:19                  
Changedby : Ujjaval Patel             
Date      : 27th Nov 2013                  
Purpose   : Change the DataType of Rate ot DECIMAL(19, 4) throughout DB Objects of Hotel.                  
--=========================================================================                         
Comment:20            
Changedby : Sanket Mehta            
Date      : 04th April 2014            
Purpose   : 1) Comment code FOR Credit Card Policy.             
   2) RETURN the Charge bifurcation based ON Purpose IN ascending Order             
--=========================================================================           
Comment:21              
Changed By   : Ujjaval Patel                      
Changed Date : 30th May 2014                
Description  : Implement Cummulative tax in Excursion business           
========================================================================                   
Comment:22              
Changed By   : Sagar Shete                      
Changed Date : 5th Jun 2014                
Description  : 1) Implementing the change for rates calculation. It should be with calculation the tax.          
      2) Prepay and pay on arrival should be calculated based on TotalRate and not on Base rate.           
========================================================================                   
Comment:23              
Changed By   : Ujjaval Patel                      
Changed Date : 3rd Jun 2014                
Description  : to implement the commission in excursion business           
========================================================================       
Comment:24              
Changed By   : Sunny Pathai      
Changed Date : 6th Aug 2014                
Description  : Implementing the changes for Promotion functionality in Excursion Buisness.           
========================================================================      
Comment:25              
Changed By   : Sunny Pathai      
Changed Date : 18 October 2014                
Description  : Pass the Schedule ID in GetScheduelPromotion as Nvarchar not as INT.            
========================================================================             
Comment:26              
Changed By   : Sunny Pathai      
Changed Date : 07 November 2014         
Description  : Implemented the Changes For AddOns functionality in Excursion and Packages.            
========================================================================    
Comment:27              
Changed By   : Sunny Pathai      
Changed Date : 31 March 2015                
Description  : Commented the Calculation of Addons Rate which will be selected by User.  
    This Calculation will be done by Booking Engine.            
========================================================================   
Comment:28              
Changed By   : Ujjaval Patel  
Changed Date : 06th Aug 2015                
Description  : Child policy related changes to calculate count of child from age node   
==============================================================   
Comment:29              
Changed By   : Ujjaval Patel  
Changed Date : 29th March 2017                
Description  : Get rate for per equipment activity   
==============================================================       
               
*/   
  