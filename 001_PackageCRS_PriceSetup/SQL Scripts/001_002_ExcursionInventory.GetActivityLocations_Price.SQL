CREATE PROCEDURE ExcursionInventory.GetActivityLocations_Price  (        
 @ActivityID INT        
 ,@CultureCode VARCHAR(5) = 'en-US'        
 )        
AS        
      
;WITH CTE AS       
(      
 SELECT 'ADULT' AS PaxType      
 UNION      
 SELECT 'CHILD' AS PaxType      
 UNION      
 SELECT 'INFANT' AS PaxType      
),CTE2 AS (      
SELECT  Co.Code + '_' + CONVERT(VARCHAR, S.StateID) + '_' + CONVERT(VARCHAR, C.CityID) AS LocationID  ,ActivityLocation = COALESCE(MLCt.CityName, C.CityName) + ' To ' +       
(        
  SELECT C.CityName AS ActivityLocation        
  FROM ExcursionInventory.Activities A        
  INNER JOIN Internationalization.Cities C ON A.nLocationsId = C.CityID        
  WHERE A.nActivityID = @ActivityID        
  )        
FROM (        
 SELECT *        
 FROM ExcursionInventory.ActivityLocations        
 WHERE ActivityID = @ActivityID        
  AND IsActive = 1        
 ) AL        
INNER JOIN Internationalization.Cities C ON C.CityID = AL.CityID        
INNER JOIN Internationalization.STATE S ON S.StateID = C.StateID        
INNER JOIN Internationalization.Country Co ON Co.Code = S.CountryCode        
LEFT JOIN InternationalizationML.MLCountry MLC ON Co.Code = MLC.Code        
 AND MLC.CultureCode = @CultureCode        
LEFT JOIN InternationalizationML.MLState MLS ON S.StateID = MLS.nStateID        
 AND MLS.CultureCode = @CultureCode        
LEFT JOIN InternationalizationML.MLCity MLCt ON C.CityID = MLCt.nCityID        
 AND MLCt.CultureCode = @CultureCode        
)      
SELECT LocationID + '_' + PaxType AS LocationID,ActivityLocation + ' (' + PaxType + ' )' AS  ActivityLocation FROM CTE2 CROSS JOIN CTE