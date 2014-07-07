DELETE FROM tblShape
GO


INSERT INTO tblShape(ID, [Description], Shape)
VALUES (1, 'Shape A', geometry::STGeomFromText('POLYGON ((0 0, 150 0, 150 150, 0 150, 0 0))', 0));
-- Shape that is overlapping Shape A
INSERT INTO tblShape(ID, [Description], Shape)
VALUES (2, 'Shape B', geometry::STGeomFromText('POLYGON ((100 100, 250 100, 250 250, 100 250, 100 100))', 0));
-- Shape that is just touching Shape B
INSERT INTO tblShape(ID, [Description], Shape)
VALUES (3, 'Shape C', geometry::STGeomFromText('POLYGON ((0 250, 150 250, 150 400, 0 400, 0 250))', 0));
-- Shape that is not touching anything
INSERT INTO tblShape(ID, [Description], Shape)
VALUES (4, 'Shape D', geometry::STGeomFromText('POLYGON ((300 300, 450 300, 450 450, 300 450, 300 300))', 0));


SELECT * 
FROM tblShape
GO


SELECT *
FROM tblShape a 
	INNER JOIN tblShape b
		ON a.ID <> b.ID
		--AND a.Shape.STIntersects(b.Shape) = 1
		AND a.Shape.STIntersects(b.Shape.STBuffer(-0.01)) = 1
GO