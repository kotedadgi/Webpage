 CREATE TABLE [reporting].[trip_closed_master] (
    tclm_id_pk int IDENTITY(1,1) NOT NULL,
    tclm_trip_id int,
    tclm_vehicle_id int,
	tclm_route_id int,
	tclm_driver_id int,
	tclm_shift_id int,
	tclm_closed_time datetime
   
);

    CREATE TABLE [reporting].[trip_closed_details] (
    tcld_id_pk int IDENTITY(1,1) NOT NULL,
    tcld_trip_id int,
    tcld_bin_id int,
	tcld_bin_name varchar(50),
	tcld_sequence_no int,
	tclm_bin_to_be_collected int
);