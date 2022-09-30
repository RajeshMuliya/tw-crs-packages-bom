CREATE FUNCTION ExcursionInventory.GetDepartureLocationsCode (@ActivityID INT)      
RETURNS XML      
AS      
BEGIN      
 DECLARE @RetXML XML = NULL;      
      
 WITH CTE      
 AS (      
   SELECT nLocationsId AS CityID,1 AS IsPackageCity FROM ExcursionInventory.Activities WHERE nActivityID = @ActivityID      
   UNION      
   SELECT CityID,0 AS IsPackageCity FROM ExcursionInventory.ActivityLocations WHERE ActivityID = @ActivityID      
  )      
 SELECT @RetXML = (   
     SELECT       
     EnglishName as Country,StateName,      
     CityName,IsPackageCity,Co.Code + '_' + CONVERT(VARCHAR, S.StateID) + '_' + CONVERT(VARCHAR, C.CityID) AS LocationCode      
     FROM CTE AL      
     INNER JOIN Internationalization.Cities C ON C.CityID = AL.CityID      
     INNER JOIN Internationalization.STATE S ON S.StateID = C.StateID      
     INNER JOIN Internationalization.Country Co ON Co.Code = S.CountryCode      
     WHERE C.IsActive = 1      
     FOR XML PATH('DepartureDetail'),TYPE      
    )      
      
 RETURN @RetXML      
END 