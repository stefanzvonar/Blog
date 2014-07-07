
--EXEC proc_Location_List_By_Geometry -27.4709331, 153.023502399, 15
CREATE PROCEDURE [dbo].[proc_Location_List_By_Geography]
    (
        @dmlLat decimal(10, 7),
        @dmlLng decimal(10, 7),
        @intRadiusKm int
    )
    As

SET NOCOUNT ON


-- Assuming a WGS84 projection, but change 4326 to the appropriate spatial reference ID for your stored coordinates
DECLARE @SearchPoint as geography
SET @SearchPoint = geography::Point(@dmlLat, @dmlLng, 4326) 

-- The STDistance instance method returns a measurment based on the [unit_of_measure] in [sys].[spatial_reference_systems] table for the appropriate spatial reference.  
-- In most cases, this is in metres.
SELECT LocationID, LocationDescription, Address1, Address2, Town, County, Postcode, Latitude, Longitude, SRID, (Point.STDistance(@SearchPoint)/1000) AS DistanceKm
FROM tblLocation
WHERE Point.STDistance(@SearchPoint) <= (@intRadiusKm * 1000)


SET NOCOUNT OFF
GO

