/*        
-- ==========================================================================================        
-- Created By  : Sanket Mehta      
-- Create date : April 11, 2012      
-- Description : This SP is used to get the list of Excursion Addresses based on Culture      
      
-- Sample:        
DECLARE @ActivityID INT,      
  @CultureCode VARCHAR(5)    
      
SELECT @ActivityID = 183,      
  @CultureCode = 'es-AR'    
      
EXEC ExcursionInventory.GetActivityLocations @ActivityID, @CultureCode    
      
-- ==========================================================================================        
*/  
ALTER PROCEDURE ExcursionInventory.GetActivityLocations  (  
 @ActivityID INT  
 ,@CultureCode VARCHAR(5) = 'en-US'  
 )  
AS  
SELECT AL.ActivityLocationID  
 ,AL.ActivityID  
 ,C.CityID  
 ,COALESCE(MLCt.CityName, C.CityName) AS CityName  
 ,S.StateID  
 ,COALESCE(MLS.StateName, S.StateName) AS StateName  
 ,Co.Code AS CountryCode  
 ,COALESCE(MLC.countryname, Co.EnglishName) AS CountryName  
 ,AL.IsActive  
 ,COALESCE(MLC.countryname, Co.EnglishName) + ' -> ' + COALESCE(MLS.StateName, S.StateName) + ' -> ' + COALESCE(MLCt.CityName, C.CityName) AS Location  
 ,Co.Code + '_' + CONVERT(VARCHAR, S.StateID) + '_' + CONVERT(VARCHAR, C.CityID) AS LocationID  
 ,ActivityLocation = COALESCE(MLCt.CityName, C.CityName) + ' To ' + (  
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