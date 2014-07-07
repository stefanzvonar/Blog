CREATE TRIGGER [dbo].[Tr_tblLocation_U] 
ON [dbo].[tblLocation]
AFTER UPDATE, INSERT 
AS
BEGIN
	IF UPDATE(WGS84Latitude) OR UPDATE(WGS84Longitude)
	BEGIN
		UPDATE tblLocation
		SET Point = Geography::Point(i.WGS84Latitude, i.WGS84Longitude, 4326) -- Transform WGS84 coordinates to a geographic object.
		FROM INSERTED i
			INNER JOIN tblLocation l
				ON i.LocationID = l.LocationID
	END
END 
