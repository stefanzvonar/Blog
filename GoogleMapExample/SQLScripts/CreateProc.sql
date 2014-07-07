CREATE PROCEDURE [dbo].[proc_Location_List]
    (
        @dmlLat decimal(10, 7),
        @dmlLng decimal(10, 7),
        @intRadius int
    )
    As

SET NOCOUNT ON

DECLARE @intMilesModifier int
SET @intMilesModifier = 3959  -- If using kilometers, use 6371 instead of 3959

-- Select locations that are near the parameters based on distance formula on a sphere
SELECT LocationID, LocationDescription, Address1, Address2, Town, County, Postcode, Latitude, Longitude,
      (@intMilesModifier*acos(cos(radians(@dmlLat))*cos(radians(Latitude))*cos(radians(Longitude)-
       radians(@dmlLng))+sin(radians(@dmlLat))*sin(radians(Latitude)))) AS distance
FROM dbo.tblLocation
WHERE (@intMilesModifier*acos(cos(radians(@dmlLat))*cos(radians(Latitude))*cos(radians(Longitude)-
       radians(@dmlLng))+sin(radians(@dmlLat))*sin(radians(Latitude)))) < @intRadius

-- Return XML for formatting results
FOR XML RAW('marker'),ROOT('markers')

SET NOCOUNT OFF
GO

