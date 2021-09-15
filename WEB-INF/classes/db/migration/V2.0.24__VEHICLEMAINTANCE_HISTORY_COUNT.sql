CREATE TABLE [reports].[vehicle_maintenance_history_count] (
    vmhc_id_pk int IDENTITY(1,1) NOT NULL,
    vmhc_date datetime,
    vmhc_vehicle_id int,
    vmhc_status int,
	vmhc_ulbId int,
	vmhc_userId int
);