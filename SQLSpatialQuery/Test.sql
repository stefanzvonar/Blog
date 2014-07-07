DECLARE         @dmlLat decimal(10, 7),
        @dmlLng decimal(10, 7),
        @intRadius int
        
SET         @dmlLat = 51.4963501
SET         @dmlLng = -0.1966401
SET         @intRadius = 5
 
 
DECLARE @SearchPoint AS geography
SET @SearchPoint = geography::Point(@dmlLat, @dmlLng, 4326)
select * from tblLocation
SELECT @SearchPoint
SELECT LocationID, LocationDescription, Address1, Address2, Town, County, Postcode, WGS84Latitude, WGS84Longitude, Point, Point.STDistance(@SearchPoint) as Distance
FROM tblLocation
--WHERE Point.STDistance(@SearchPoint) <= @intRadius
-- Return XML for formatting results
--FOR XML RAW('marker'),ROOT('markers')



SELECT t.town, ref.point1.STDistance(t.geom)/0.3048 As dist_ft
FROM towns_geodetic As t 
INNER JOIN (
SELECT TOP 1 geom.STPointN(1) As point1
FROM towns_geodetic WHERE town = 'BOSTON') As ref
ON ref.point1.STDistance(t.geom) < 1609.344
ORDER BY ref.point1.STDistance(t.geom) ;