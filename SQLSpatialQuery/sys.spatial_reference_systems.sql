--Most of the spatial refence systems defined in this sys table are in metres except for a few weird ones in Clarke's foot, US Survey foot, Indian foot and German metre.
-- Look at the unit_of_measure column!
select * from sys.spatial_reference_systems where spatial_reference_id in (4203, 4326)

