/****** Object:  Table [admin].[config_alert_master]    Script Date: 10/19/2020 1:17:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_alert_master](
	[cam_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cam_vehicle_id_fk] [int] NULL,
	[cam_date_time] [datetime] NULL,
	[cam_created_user] [int] NULL,
	[cam_alert_type_fk] [int] NULL,
	[cam_alert_sub_type] [int] NULL,
	[cam_fence_type_fk] [int] NULL,
	[cam_fence_id] [int] NULL,
	[cam_alert_frequency] [int] NULL,
	[cam_ulb_id_fk] [int] NULL,
	[cam_alert_mode] [int] NULL,
	[cam_email_id] [nvarchar](50) NULL,
	[cam_phone_no] [nvarchar](50) NULL,
	[cam_start_time] [nvarchar](50) NULL,
	[cam_end_time] [nvarchar](50) NULL,
	[cam_speedlimit] [int] NULL,
 CONSTRAINT [config_alert_master_pkey] PRIMARY KEY CLUSTERED 
(
	[cam_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [admin].[config_alert_master] ADD  DEFAULT ((0)) FOR [cam_vehicle_id_fk]
GO
ALTER TABLE [admin].[config_alert_master] ADD  DEFAULT ((0)) FOR [cam_created_user]
GO
ALTER TABLE [admin].[config_alert_master] ADD  DEFAULT ((0)) FOR [cam_alert_sub_type]
GO
ALTER TABLE [admin].[config_alert_master] ADD  DEFAULT ((0)) FOR [cam_fence_type_fk]
GO
ALTER TABLE [admin].[config_alert_master] ADD  DEFAULT ((0)) FOR [cam_fence_id]
GO
ALTER TABLE [admin].[config_alert_master] ADD  DEFAULT ((0)) FOR [cam_alert_frequency]
GO
ALTER TABLE [admin].[config_alert_master] ADD  DEFAULT ((0)) FOR [cam_ulb_id_fk]
GO
ALTER TABLE [admin].[config_alert_master] ADD  DEFAULT ((0)) FOR [cam_alert_mode]
GO
ALTER TABLE [admin].[config_alert_master] ADD  DEFAULT ((0)) FOR [cam_speedlimit]
GO
/****** Object:  Table [admin].[config_alerts_recived_log]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_alerts_recived_log](
	[arl_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[arl_alert_type_fk] [int] NULL,
	[arl_received_date_time] [datetime] NULL,
	[arl_latitude] [float] NULL,
	[arl_longitude] [float] NULL,
	[arl_location] [varchar](255) NULL,
	[arl_alert_type] [varchar](255) NULL,
	[arl_ulb_id_fk] [int] NULL,
	[arl_vehicle_id_fk] [int] NULL,
	[arl_vehicle_no] [varchar](255) NULL,
	[arl_Tenant_Code] [varchar](255) NULL,
	[arl_uuid] [varchar](255) NULL,
	[arl_alert_priority] [varchar](255) NULL,
	[arl_vehicle_trigger] [varchar](50) NULL,
	[arl_route_id] [varchar](50) NULL,
	[arl_trip_id] [varchar](50) NULL,
	[arl_skipped_bin] [varchar](100) NULL,
	[arl_geofence_type] [varchar](100) NULL,
	[arl_geo_event] [varchar](100) NULL,
	[arl_assign_status] [int] NOT NULL,
	[arl_binloc_id] [int] NULL,
	[arl_geo_details] [varchar](500) NULL,
	[arl_notify_status] [int] NULL,
	[arl_geom_type] [int] NULL,
 CONSTRAINT [arl_master_pkey] PRIMARY KEY CLUSTERED 
(
	[arl_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_bin_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_bin_master](
	[cbm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cbm_bin_loc_id] [int] NULL,
	[cbm_ulb_id_fk] [int] NULL,
	[cbm_zone_id] [int] NULL,
	[cbm_ward_id] [int] NULL,
	[cbm_created_by] [int] NULL,
	[cbm_created_date] [datetime] NULL,
	[cbm_modified_by] [int] NULL,
	[cbm_modified_date] [datetime] NULL,
	[cbm_bin_name] [nvarchar](100) NULL,
	[cbm_bin_capacity] [int] NULL,
	[cbm_rfid_status] [int] NULL,
	[cbm_bin_sensor_status] [int] NULL,
	[cbm_device_type] [int] NULL,
	[cbm_binRroad_status] [int] NULL,
	[cbm_person_name] [varchar](100) NULL,
	[cbm_house_no] [varchar](20) NULL,
	[cbm_binStatus] [int] NULL,
	[cbm_ulbCode] [nvarchar](50) NULL,
	[cbm_binType] [int] NULL,
	[cbm_bin_category_type] [int] NOT NULL,
	[cbm_is_sensor] [int] NULL,
	[BinLayoutID] [varchar](250) NULL,
 CONSTRAINT [config_bin_master_pkey] PRIMARY KEY CLUSTERED 
(
	[cbm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_bin_sensor_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_bin_sensor_master](
	[cbsm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cbsm_bin_id] [int] NULL,
	[cbsm_ulb_id_fk] [int] NULL,
	[cbsm_zone_id] [int] NULL,
	[cbsm_ward_id] [int] NULL,
	[cbsm_created_by] [int] NULL,
	[cbsm_created_date] [datetime] NULL,
	[cbsm_modified_by] [int] NULL,
	[cbsm_modified_date] [datetime] NULL,
	[cbsm_sensor_sim_no] [nvarchar](250) NULL,
	[cbsm_bin_volume] [nvarchar](100) NULL,
	[cbsm_bin_full_status] [int] NULL,
	[cbsm_bin_sensor_capasity] [int] NULL,
	[cbsm_check_count] [int] NULL,
	[cbsm_bin_loc_id] [int] NULL,
	[cbsm_bin_latitude] [float] NULL,
	[cbsm_bin_longitude] [float] NULL,
	[cbsm_mac_address] [varchar](50) NULL,
	[cbsm_sim_no] [varchar](50) NULL,
	[cbsm_bin_name] [varchar](50) NULL,
	[cbsm_sensor_updated_date] [datetime] NULL,
	[cbsm_location] [varchar](max) NULL,
	[cbsm_device_no] [varchar](40) NULL,
	[cbsm_collection_status] [int] NULL,
	[cbsm_alert_time] [datetime] NULL,
	[cbsm_sla_time] [datetime] NULL,
	[cbsm_collected_time] [datetime] NULL,
	[cbsm_sla_hours] [int] NULL,
	[cbsm_sla_type_id] [int] NULL,
	[cbsm_sla_type] [varchar](30) NULL,
	[cbsm_can_be_emptied_threshold] [int] NULL,
	[cbsm_emptied_threshold] [int] NULL,
	[cbsm_almost_full_threshold] [int] NULL,
	[cbsm_full_threshold] [int] NULL,
	[cbsm_transmissionmode_type_id] [int] NULL,
	[cbsm_measurement_rate] [int] NULL,
	[cbsm_measurement_by_send] [int] NULL,
	[cbsm_device_id] [varchar](50) NULL,
	[not_collect_status] [int] NULL,
	[cbsm_configuration_details] [nvarchar](max) NULL,
	[cbsm_binStatus] [int] NULL,
	[cbsm_ulbCode] [nvarchar](50) NULL,
	[sensorBinLayoutID] [varchar](250) NULL,
	[cbsm_alert_status] [int] NULL,
 CONSTRAINT [config_bin_sensor_master_pkey] PRIMARY KEY CLUSTERED 
(
	[cbsm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_fleet_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_fleet_master](
	[cfm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cfm_vehicle_no] [nvarchar](100) NULL,
	[cfm_model_no] [nvarchar](100) NULL,
	[cfm_purchase_date] [date] NULL,
	[cfm_year_of_making] [int] NULL,
	[cfm_engine_no] [nvarchar](100) NULL,
	[cfm_chassis_no] [nvarchar](100) NULL,
	[cfm_vehicle_type_id_fk] [int] NULL,
	[cfm_fuel_capacity] [int] NULL,
	[cfm_ulb_id_fk] [int] NULL,
	[cfm_register_date] [date] NULL,
	[cfm_vehicle_available_status] [int] NULL,
	[cfm_fc_date] [date] NULL,
	[cfm_contract_end_date] [date] NULL,
	[cfm_puc_date] [date] NULL,
	[cfm_created_by] [int] NULL,
	[cfm_modified_by] [int] NULL,
	[cfm_created_date] [datetime] NULL,
	[cfm_modified_date] [datetime] NULL,
	[cfm_sim_no] [nvarchar](50) NULL,
	[cfm_contractor_name] [varchar](40) NULL,
	[cfm_mobile_no] [nvarchar](15) NULL,
	[cfm_shift_type] [nvarchar](25) NULL,
	[gcm_reg_id] [nvarchar](max) NULL,
	[cfm_maintenance_status] [int] NULL,
	[cfm_mileage] [float] NULL,
	[cfm_zone_id] [int] NULL,
	[cfm_fleet_capacity] [int] NULL,
	[cfm_start_location] [int] NULL,
	[cfm_rfid_number] [varchar](30) NULL,
	[cfm_driver_id] [int] NULL,
	[cfm_rfid_number_2] [varchar](30) NULL,
	[cfm_ward_id] [int] NULL,
	[cfm_ulb_code] [varchar](20) NULL,
	[macAddress] [nvarchar](50) NULL,
	[cfm_iotops_id] [int] NOT NULL,
	[IotOpsID] [varchar](50) NULL,
 CONSTRAINT [config_fleet_master_pkey] PRIMARY KEY CLUSTERED 
(
	[cfm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_mobile_user_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_mobile_user_master](
	[cmum_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cmum_user_name] [nvarchar](50) NULL,
	[cmum_login_name] [nvarchar](50) NULL,
	[cmum_login_password] [nvarchar](50) NULL,
	[cmum_mobile] [nvarchar](15) NULL,
	[cmum_address] [nvarchar](max) NULL,
	[cmum_email] [nvarchar](max) NULL,
	[cmum_ulb_id_fk] [int] NULL,
	[cmum_user_type] [int] NULL,
	[cmum_status] [int] NULL,
	[cmum_created_by] [int] NULL,
	[cmum_modified_by] [int] NULL,
	[cmum_created_date] [datetime] NULL,
	[cmum_modified_date] [datetime] NULL,
	[cmum_zone_status] [bit] NULL,
	[cmum_ward_status] [bit] NULL,
	[cmum_ward_id] [int] NULL,
	[cmum_zone_id] [int] NULL,
	[cmum_driver_id] [int] NULL,
	[cmum_employee_id] [varchar](50) NULL,
	[cmum_license_key] [int] NULL,
	[cmum_vehicle_id] [varchar](max) NULL,
	[cmum_uuid] [nvarchar](64) NULL,
	[cmum_otp] [int] NULL,
	[cmum_otpexp] [varchar](50) NULL,
	[cmum_package_status] [int] NULL,
	[cmum_workforce_id_fk] [int] NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[utc_date_time] [datetime] NULL,
	[placename] [varchar](250) NULL,
	[received_datetime] [datetime] NULL,
	[mainworkforceid] [int] NULL,
	[isMultiuser] [bit] NULL,
 CONSTRAINT [config_mobile_user_master_pkey] PRIMARY KEY CLUSTERED 
(
	[cmum_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_online_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_online_master](
	[com_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[com_fleet_id] [int] NULL,
	[com_sim_id] [int] NULL,
	[com_status] [int] NULL,
	[com_assigned_by] [int] NULL,
	[com_unassigned_by] [int] NULL,
	[com_assigned_date] [datetime] NULL,
	[com_unassigned_date] [datetime] NULL,
	[com_fleet_name] [varchar](max) NULL,
	[com_sim_no] [varchar](50) NULL,
	[com_ulb_id_fk] [int] NOT NULL,
 CONSTRAINT [config_online_master_pkey] PRIMARY KEY CLUSTERED 
(
	[com_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_rfid_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_rfid_master](
	[crm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[crm_rfid_no] [nvarchar](50) NULL,
	[crm_rfid_type] [int] NOT NULL,
	[crm_bin_id] [int] NULL,
	[crm_ulb_id_fk] [int] NULL,
	[crm_zone_id] [int] NULL,
	[crm_ward_id] [int] NULL,
	[crm_created_by] [int] NULL,
	[crm_created_date] [datetime] NULL,
	[crm_modified_by] [int] NULL,
	[crm_modified_date] [datetime] NULL,
	[crm_bin_name] [nvarchar](100) NULL,
	[crm_sensor_sim_no] [nvarchar](250) NULL,
	[crm_bin_volume] [nvarchar](100) NULL,
	[crm_bin_full_status] [int] NULL,
	[crm_check_count] [int] NULL,
	[crm_bin_loc_id_fk] [int] NULL,
	[crf_capacity] [int] NULL,
	[crm_rfid_no2] [nvarchar](50) NULL,
	[crm_bin_lat] [float] NULL,
	[crm_bin_long] [float] NULL,
	[crm_bin_collection_status] [int] NULL,
	[crm_bin_collection_time] [datetime] NULL,
	[RfidBinLayoutID] [varchar](250) NULL,
	[TripId] [int] NULL,
 CONSTRAINT [config_rfid_master_pkey] PRIMARY KEY CLUSTERED 
(
	[crm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_rfid_reader]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_rfid_reader](
	[crd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[crd_imei_no] [varchar](20) NULL,
	[crd_ts_dg] [int] NULL,
	[crd_ulb_id] [int] NULL,
	[crd_ulb_code] [varchar](20) NULL,
	[crd_assign_status] [int] NULL,
	[crd_device_name] [varchar](30) NULL,
	[crd_fence_type] [int] NULL,
 CONSTRAINT [config_rfid_reader_pkey] PRIMARY KEY CLUSTERED 
(
	[crd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_sim_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_sim_master](
	[csm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[csm_sim_no] [varchar](30) NULL,
	[csm_status] [int] NULL,
	[csm_ulb_id_fk] [int] NULL,
	[csm_created_date] [datetime] NULL,
	[csm_modified_date] [datetime] NULL,
	[macAddress] [nvarchar](50) NULL,
	[deviceName] [nvarchar](50) NULL,
	[csm_device_type] [varchar](50) NULL,
	[csm_device_no] [varchar](40) NULL,
	[csm_ulb_code] [varchar](20) NULL,
	[FK_ZoneId] [int] NULL,
	[FK_WardId] [int] NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[address] [varchar](2000) NULL,
	[csm_iotops_id] [int] NULL,
	[isGPS] [bit] NULL,
 CONSTRAINT [config_sim_master_pkey] PRIMARY KEY CLUSTERED 
(
	[csm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_staff_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_staff_master](
	[cssm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cssm_staff_name] [nvarchar](256) NULL,
	[cssm_emp_id] [nvarchar](50) NULL,
	[cssm_licence_no] [nvarchar](50) NULL,
	[cssm_phone_no] [nvarchar](15) NULL,
	[cssm_shift_type_id_fk] [int] NULL,
	[cssm_created_date] [datetime] NULL,
	[cssm_modified_date] [datetime] NULL,
	[cssm_address] [nvarchar](256) NULL,
	[cssm_state] [int] NULL,
	[cssm_city] [int] NULL,
	[cssm_imagePath] [nvarchar](1) NULL,
	[cssm_driver_status] [int] NULL,
	[cssm_staff_type] [int] NULL,
	[cssm_created_by] [int] NULL,
	[cssm_modified_by] [int] NULL,
	[cssm_ulb_id_fk] [int] NULL,
	[cssm_aadhar_no] [nvarchar](20) NULL,
	[cssm_email_id] [varchar](30) NULL,
	[cssm_mobile_user_status] [int] NULL,
	[cssm_zone_id_fk] [int] NULL,
	[cssm_ward_id_fk] [int] NULL,
	[csm_shift_type_id_fk] [varchar](150) NULL,
	[cssm_package_id_fk] [int] NULL,
	[cssm_staff_category_id_fk] [int] NULL,
	[is_assigned_trip] [bit] NULL,
 CONSTRAINT [config_staff_master_pkey] PRIMARY KEY CLUSTERED 
(
	[cssm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_supervisor_notify]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_supervisor_notify](
	[asn_supervisor_id] [int] IDENTITY(1,1) NOT NULL,
	[asn_supervisor_email] [varchar](255) NULL,
	[asn_supervisor_number] [varchar](200) NULL,
	[asn_nearest_workforce] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[asn_supervisor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_user_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_user_master](
	[cum_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cum_user_name] [nvarchar](50) NULL,
	[cum_login_name] [nvarchar](50) NULL,
	[cum_login_password] [nvarchar](50) NULL,
	[cum_mobile] [nvarchar](15) NULL,
	[cum_address] [nvarchar](max) NULL,
	[cum_email] [nvarchar](max) NULL,
	[cum_ulb_id_fk] [int] NULL,
	[cum_report_menu] [nvarchar](max) NULL,
	[cum_garbage_collection_menu] [nvarchar](max) NULL,
	[cum_admin_menu] [nvarchar](max) NULL,
	[cum_user_menu] [nvarchar](max) NULL,
	[cum_assign_fleet] [nvarchar](max) NULL,
	[cum_user_type] [int] NULL,
	[cum_division_id] [nvarchar](max) NULL,
	[cum_dumping_ground_id] [nvarchar](max) NULL,
	[cum_status] [int] NULL,
	[cum_created_by] [int] NULL,
	[cum_modified_by] [int] NULL,
	[cum_created_date] [datetime] NULL,
	[cum_modified_date] [datetime] NULL,
	[cum_dasboard_menu] [nvarchar](max) NULL,
	[cum_otp_no] [int] NULL,
	[cum_ward_id] [nvarchar](max) NULL,
	[cum_zone_id] [nvarchar](max) NULL,
	[cum_ward_status] [bit] NULL,
	[cum_zone_status] [bit] NULL,
	[cum_user_app_type] [varchar](10) NULL,
	[cum_ulb_status] [int] NULL,
	[cum_password_modified_date] [datetime] NULL,
	[cum_esbm_user_status] [int] NULL,
	[cum_user_theme] [varchar](max) NULL,
	[cum_intg] [nvarchar](max) NULL,
	[cum_tenant_code] [nvarchar](max) NULL,
	[is_logged_in] [bit] NULL,
	[tenantStatus] [bit] NULL,
	[expiryDate] [datetime] NULL,
	[cum_bintypes_todisplay] [nvarchar](max) NULL,
 CONSTRAINT [config_user_master_pkey] PRIMARY KEY CLUSTERED 
(
	[cum_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_ward_master]    Script Date: 10/19/2020 1:14:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_ward_master](
	[cwm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cwm_ward_name] [nvarchar](256) NULL,
	[cwm_zone_id_fk] [int] NULL,
	[cwm_ulb_id_fk] [int] NULL,
	[cwm_geometry] [geometry] NULL,
	[cwm_ward_number] [int] NULL,
	[cwm_iot_id] [int] NULL,
	[wardUId] [varchar](50) NULL,
	[TotalPopulation] [numeric](18, 0) NULL,
	[MenPopulation] [numeric](18, 0) NULL,
	[WomenPopulation] [numeric](18, 0) NULL,
	[ChildrenPopulation] [numeric](18, 0) NULL,
 CONSTRAINT [PK_config_ward_master] PRIMARY KEY CLUSTERED 
(
	[cwm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_widget_notificaton_master]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_widget_notificaton_master](
	[cnm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cnm_column_no] [int] NULL,
	[cnm_row_no] [int] NULL,
	[cnm_sizeY] [int] NULL,
	[cnm_sizeX] [int] NULL,
	[cnm_widget_name] [varchar](100) NULL,
	[cnm_alert_type] [int] NULL,
	[cnm_ulb_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[cnm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_zone_master]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_zone_master](
	[czm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[czm_zone_name] [nvarchar](256) NULL,
	[czm_ulb_id_fk] [int] NULL,
	[czm_geometry] [geometry] NULL,
	[czm_iot_id] [int] NULL,
	[zoneUId] [varchar](50) NULL,
 CONSTRAINT [config_zone_master_pkey] PRIMARY KEY CLUSTERED 
(
	[czm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[DeviceManagementDetails]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[DeviceManagementDetails](
	[pk_DeviceID] [int] IDENTITY(1,1) NOT NULL,
	[DeviceName] [varchar](100) NULL,
	[DeviceMacaddress] [varchar](100) NULL,
	[DeviceTypeID] [int] NULL,
	[DeviceTypeName] [varchar](100) NULL,
	[DeviceCreatedDate] [datetime] NULL,
	[DeviceUpdatedDate] [datetime] NULL,
	[DeviceTanentCode] [varchar](50) NULL,
	[DeviceULbID] [int] NULL,
	[DeviceZoneID] [int] NULL,
	[DeviceWardID] [int] NULL,
	[DeviceLatitude] [float] NULL,
	[DeviceLongtitude] [float] NULL,
	[DeviceAddress] [varchar](250) NULL,
	[DeviceIotOpsID] [varchar](50) NULL,
	[DeviceAssignedStatus] [int] NULL,
	[isBin] [bit] NULL,
	[cameraURL] [varchar](255) NULL,
	[Device_assigned_type] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[pk_DeviceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[region_master]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[region_master](
	[regionId] [int] IDENTITY(1,1) NOT NULL,
	[regionName] [nvarchar](256) NULL,
	[regionULBId] [int] NULL,
	[regionGeometry] [geometry] NULL,
	[regionIoTId] [int] NULL,
	[regionUId] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[regionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[state_master]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[state_master](
	[sm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[sm_name] [nvarchar](256) NULL,
 CONSTRAINT [state_master_pkey] PRIMARY KEY CLUSTERED 
(
	[sm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[unassigned_fleet_details]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[unassigned_fleet_details](
	[cfm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cfm_vehicle_no] [nvarchar](100) NULL,
	[cfm_model_no] [nvarchar](100) NULL,
	[cfm_purchase_date] [date] NULL,
	[cfm_year_of_making] [int] NULL,
	[cfm_engine_no] [nvarchar](100) NULL,
	[cfm_chassis_no] [nvarchar](100) NULL,
	[cfm_vehicle_type_id_fk] [int] NULL,
	[cfm_fuel_capacity] [int] NULL,
	[cfm_ulb_id_fk] [int] NULL,
	[cfm_register_date] [date] NULL,
	[cfm_vehicle_available_status] [int] NULL,
	[cfm_fc_date] [date] NULL,
	[cfm_contract_end_date] [date] NULL,
	[cfm_puc_date] [date] NULL,
	[cfm_created_by] [int] NULL,
	[cfm_modified_by] [int] NULL,
	[cfm_created_date] [datetime] NULL,
	[cfm_modified_date] [datetime] NULL,
	[cfm_sim_no] [nvarchar](50) NULL,
	[cfm_contractor_name] [varchar](40) NULL,
	[cfm_mobile_no] [nvarchar](15) NULL,
	[cfm_shift_type] [nvarchar](25) NULL,
	[gcm_reg_id] [nvarchar](max) NULL,
	[cfm_maintenance_status] [int] NULL,
	[cfm_mileage] [float] NULL,
	[cfm_zone_id] [int] NULL,
	[cfm_fleet_capacity] [int] NULL,
	[cfm_start_location] [int] NULL,
	[cfm_rfid_number] [varchar](30) NULL,
	[cfm_driver_id] [int] NULL,
	[cfm_rfid_number_2] [varchar](30) NULL,
	[cfm_ward_id] [int] NULL,
	[cfm_ulb_code] [varchar](20) NULL,
	[macAddress] [nvarchar](50) NULL,
	[cfm_iotops_id] [int] NOT NULL,
	[IotOpsID] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[urban_local_body_master]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[urban_local_body_master](
	[ulbm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[ulbm_name] [nvarchar](256) NULL,
	[ulbm_created_date] [datetime] NULL,
	[ulbm_address] [varchar](max) NULL,
	[ulbm_phone_no] [nvarchar](15) NULL,
	[ulbm_city] [nvarchar](256) NULL,
	[ulbm_emil_id] [nvarchar](200) NULL,
	[ulbm_state] [nvarchar](256) NULL,
	[ulbm_country] [nvarchar](256) NULL,
	[ulbm_city_id_fk] [int] NULL,
	[ulbm_state_id_fk] [int] NULL,
	[ulbm_available_status] [int] NULL,
	[ulbm_modified_date] [datetime] NULL,
	[ulbm_created_by] [int] NULL,
	[ulbm_modified_by] [int] NULL,
	[ulbm_fleet_menu] [bit] NULL,
	[ulbm_pos_menu] [bit] NULL,
	[ulbm_citizan_menu] [bit] NULL,
	[ulbm_image] [nvarchar](max) NULL,
	[ulbm_long] [float] NULL,
	[ulbm_lat] [float] NULL,
	[ulb_mobile_key_count] [int] NULL,
	[ulb_vehicle_key_count] [int] NULL,
	[ulbm_user_category] [varchar](max) NULL,
	[ulbm_fbpageId] [nvarchar](max) NULL,
	[ulbm_twitterpageId] [nvarchar](max) NULL,
	[ulbm_supervisor_key_count] [int] NULL,
	[ulb_vehicle_charges] [float] NULL,
	[ulb_driverapp_charges] [float] NULL,
	[ulb_supervisoryapp_charges] [float] NULL,
	[ulbm_notify_person_name] [varchar](256) NULL,
	[ulbm_notify_email_id] [varchar](256) NULL,
	[ulbm_notify_contact_no] [varchar](50) NULL,
	[ulbm_fbappId] [varchar](50) NULL,
	[ulbm_fbappToken] [varchar](256) NULL,
	[ulbm_fbappSec] [varchar](100) NULL,
	[ulbm_twitterCkey] [varchar](50) NULL,
	[ulbm_twitterCSkey] [varchar](100) NULL,
	[ulbm_twitterAtoken] [varchar](100) NULL,
	[ulbm_twitterAtokenSec] [varchar](100) NULL,
	[ulbm_rfid_key_count] [int] NULL,
	[ulbm_bin_key_count] [int] NULL,
	[ulbm_rfid_menu] [bit] NULL,
	[ulbm_bin_menu] [bit] NULL,
	[ulbm_attendance_key_count] [int] NULL,
	[ulbm_attendanceapp_charges] [float] NULL,
	[ulbm_attendance_menu] [bit] NULL,
	[ulbm_intg] [varchar](max) NULL,
	[ulbm_tenant_code] [varchar](50) NULL,
	[ulbm_ulbLogo] [varchar](max) NULL,
	[is_logged_in] [bit] NULL,
	[GroupName] [varchar](255) NULL,
	[GroupId] [varchar](255) NULL,
	[ZoneLayerId] [varchar](1000) NULL,
	[WardLayerId] [varchar](1000) NULL,
	[BinLocId] [varchar](1000) NULL,
	[DumpGroundId] [varchar](1000) NULL,
	[BoundaryGeom] [geometry] NULL,
	[RegionLayerId] [varchar](1000) NULL,
 CONSTRAINT [urban_local_body_master_pkey] PRIMARY KEY CLUSTERED 
(
	[ulbm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [tanantCode] UNIQUE NONCLUSTERED 
(
	[ulbm_tenant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[user_log]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[user_log](
	[ul_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[ul_user_type] [nvarchar](256) NULL,
	[ul_user_id_fk] [int] NULL,
	[ul_vehicle_id_fk] [int] NULL,
	[ul_ip_address] [nvarchar](256) NULL,
	[ul_login_time] [datetime] NULL,
	[ul_logout_time] [datetime] NULL,
	[ul_ulb_id_fk] [nvarchar](256) NULL,
	[login_status] [int] NULL,
	[gcm_reg_id] [nvarchar](max) NULL,
 CONSTRAINT [user_log_pkey] PRIMARY KEY CLUSTERED 
(
	[ul_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [analytics].[bin_sensor_predictive_alert]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [analytics].[bin_sensor_predictive_alert](
	[bspa_DateTime] [datetime] NULL,
	[bspa_Hour] [varchar](max) NULL,
	[bspa_Predicted_Volume] [varchar](max) NULL,
	[bspa_Predicted_Pick_Up_Alert] [varchar](max) NULL,
	[bspa_Bin_ID] [varchar](max) NULL,
	[bspa_bin_id_pk] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [analytics].[bin_sensor_predictive_alert_new]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [analytics].[bin_sensor_predictive_alert_new](
	[bspa_DateTime] [datetime] NULL,
	[bspa_Bin_ID] [bigint] NULL,
	[bspa_Predicted_Volume] [real] NULL,
	[bspa_bin_name] [varchar](max) NULL,
	[bspa_ward_id] [float] NULL,
	[bspa_bin_location_id] [float] NULL,
	[bspa_lat] [float] NULL,
	[bspa_lon] [float] NULL,
	[bspa_hour] [varchar](max) NULL,
	[bspa_Predicted_Pick_Up_Alert] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [analytics].[bin_sensor_simulated_history]    Script Date: 10/19/2020 1:14:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [analytics].[bin_sensor_simulated_history](
	[date_time] [datetime] NULL,
	[bin_id] [bigint] NULL,
	[volume] [float] NULL,
	[day] [varchar](max) NULL,
	[hour] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [analytics].[schedulePublish_Details]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [analytics].[schedulePublish_Details](
	[spdt_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[spdt_master_id_fk] [int] NULL,
	[spdt_bin_id_fk] [int] NULL,
	[spdt_bin_name] [varchar](max) NOT NULL,
	[spdt_collection_status] [int] NULL,
 CONSTRAINT [schedulePublish_Details_pkey] PRIMARY KEY CLUSTERED 
(
	[spdt_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [analytics].[schedulePublish_master]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [analytics].[schedulePublish_master](
	[spm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[spm_shedule_time] [datetime] NULL,
	[spm_vehId] [int] NULL,
	[spm_veh_type_id] [int] NULL,
	[spm_staff_id] [varchar](max) NULL,
	[spm_ward_id] [int] NULL,
 CONSTRAINT [schedulePublish_master_key] PRIMARY KEY CLUSTERED 
(
	[spm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [citizen].[citizen_complaints]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [citizen].[citizen_complaints](
	[cc_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cc_informer_name] [nvarchar](256) NULL,
	[cc_email_id] [nvarchar](50) NULL,
	[cc_location] [nvarchar](256) NULL,
	[cc_phone_no] [nvarchar](15) NULL,
	[cc_ward] [int] NULL,
	[cc_zone] [int] NULL,
	[cc_complaint_type] [int] NULL,
	[cc_discription] [nvarchar](max) NULL,
	[cc_image_url] [nvarchar](max) NULL,
	[cc_complain_mode] [int] NULL,
	[cc_citizen_geom] [geometry] NULL,
	[cc_priority] [int] NULL,
	[cc_compliant_status] [int] NULL,
	[cc_assign_status] [int] NULL,
	[cc_complaint_time] [datetime] NULL,
	[cc_ulb_id_fk] [int] NULL,
	[cc_complaint_key] [nvarchar](max) NULL,
	[cc_rating_value] [int] NULL,
	[cc_feedback_data] [nvarchar](max) NULL,
	[cc_citizen_user_profile_id] [nvarchar](30) NULL,
	[cc_resolved_time] [datetime] NULL,
	[cc_image] [varchar](max) NULL,
	[cc_insertstatus] [int] NOT NULL,
	[binLocationFK] [int] NULL,
	[source] [varchar](20) NULL,
	[sourceName] [varchar](255) NULL,
	[cc_trip_id] [int] NULL,
 CONSTRAINT [citizen_complaints_pkey] PRIMARY KEY CLUSTERED 
(
	[cc_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [citizen].[citizen_complaints_action_status]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [citizen].[citizen_complaints_action_status](
	[ccas_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[ccas_cc_id_fk] [int] NULL,
	[ccas_action_time] [datetime] NULL,
	[ccas_assigned_user] [int] NULL,
	[ccas_assigned_time] [datetime] NULL,
	[ccas_action_status] [int] NULL,
	[ccas_user_type] [int] NULL,
	[ccas_complaint_ward_id_fk] [int] NULL,
	[ccas_complaint_zone_id_fk] [int] NULL,
	[ccas_ulb_id_fk] [int] NULL,
	[ccas_officer_action_taken_status] [nvarchar](max) NULL,
	[ccas_imgurl] [nvarchar](max) NULL,
	[ccas_remarks] [nvarchar](max) NULL,
 CONSTRAINT [citizen_complaints_action_status_pkey] PRIMARY KEY CLUSTERED 
(
	[ccas_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dashboard].[bin_collection_report]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dashboard].[bin_collection_report](
	[bcr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[bcr_bin_collected] [int] NULL,
	[bcr_bin_not_collected] [int] NULL,
	[bcr_date] [date] NULL,
	[bcr_zone_id] [int] NULL,
	[bcr_ward_id] [int] NULL,
	[dsr_ulb_id_fk] [int] NULL,
	[bcr_total_bins] [int] NULL,
	[bcr_vehicle_id_fk] [int] NULL,
	[bcr_bin_attended_not_collected] [int] NULL,
	[bcr_bin_type_id] [int] NULL,
 CONSTRAINT [bin_collection_report_pkey] PRIMARY KEY CLUSTERED 
(
	[bcr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dashboard].[dashboard_garbage_bin_details]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dashboard].[dashboard_garbage_bin_details](
	[dgbd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[dgbd_ulb_id_fk] [int] NULL,
	[dgbd_bins_collected] [int] NULL,
	[dgbd_bins_pending] [int] NULL,
	[dgbd_date_time] [datetime] NULL,
 CONSTRAINT [dashboard_garbage_bin_details_pkey] PRIMARY KEY CLUSTERED 
(
	[dgbd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dashboard].[dashboard_staff_attendance]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dashboard].[dashboard_staff_attendance](
	[dsa_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[dsa_ulb_id_fk] [int] NULL,
	[dsa_total_staff_count] [int] NULL,
	[dsa_staff_present_count] [int] NULL,
	[dsa_staff_absent_count] [int] NULL,
	[dsa_staff_type] [int] NULL,
	[dsa_datetime] [datetime] NOT NULL,
 CONSTRAINT [dashboard_staff_attendance_pkey] PRIMARY KEY CLUSTERED 
(
	[dsa_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[alert_log]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alert_log](
	[al_id_pk] [bigint] NOT NULL,
	[al_alert_type_fk] [int] NULL,
	[al_alert_sub_type_fk] [int] NULL,
	[al_vehicle_id_fk] [int] NULL,
	[al_alert_msg] [nvarchar](max) NULL,
	[al_received_date_time] [datetime] NULL,
	[al_latitude] [float] NULL,
	[al_longitude] [float] NULL,
	[al_location] [nvarchar](max) NULL,
	[al_email_status] [int] NULL,
	[al_sms_status] [int] NULL,
	[al_month] [int] NOT NULL,
	[al_vehicle_no] [nvarchar](100) NULL,
	[al_alert_type] [varchar](100) NULL,
	[al_sub_alert_type] [varchar](100) NULL,
	[al_ulb_id_fk] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bin_rfid_details]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bin_rfid_details](
	[brd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[brd_sim_number] [nvarchar](20) NULL,
	[brd_date] [datetime] NULL,
	[brd_longitude] [float] NULL,
	[brd_latitide] [float] NULL,
	[brd_logsheet_id] [int] NULL,
	[brd_rfid_status] [nvarchar](25) NULL,
	[brd_bin_address] [nvarchar](300) NULL,
	[brd_rfid_number] [nvarchar](50) NULL,
	[brd_packet_type] [nvarchar](10) NULL,
 CONSTRAINT [PK_bin_rfid_details] PRIMARY KEY CLUSTERED 
(
	[brd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bin_sensor_alert_log]    Script Date: 10/19/2020 1:14:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bin_sensor_alert_log](
	[bsal_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[bsal_sim_number] [nvarchar](20) NULL,
	[bsal_bin_name] [nvarchar](256) NULL,
	[bsal_bin_location] [nvarchar](256) NULL,
	[bsal_longitude] [float] NULL,
	[bsal_latitude] [float] NULL,
	[bsal_date_time] [datetime] NULL,
	[bsal_assign_status] [int] NULL,
	[bsal_ulb_id_pk] [int] NULL,
	[bsal_bin_id] [int] NULL,
	[bsal_volume] [int] NULL,
	[bsal_bin_loc_id] [int] NULL,
	[bsal_bin_skippedfull_status] [int] NULL,
	[bsal_fg_update_status] [int] NULL,
	[bsal_trip_id] [int] NULL,
	[bsal_basic_id] [bigint] NULL,
	[dtm_mac_address] [nvarchar](20) NULL,
	[bsal_mailing_status] [int] NULL,
	[skippedStatus] [int] NULL,
	[bsal_source_name] [varchar](256) NOT NULL,
 CONSTRAINT [PK_bin_sensor_alert_log] PRIMARY KEY CLUSTERED 
(
	[bsal_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bin_sensor_log]    Script Date: 10/19/2020 1:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bin_sensor_log](
	[bsl_id_pk] [bigint] NULL,
	[bsl_utc_date_time] [datetime] NULL,
	[bsl_bin_id] [bigint] NULL,
	[bsl_bin_name] [varchar](max) NULL,
	[bsl_simcard_no] [varchar](max) NULL,
	[bsl_ward_id] [bigint] NULL,
	[bsl_bin_location_id] [bigint] NULL,
	[bsl_latitude] [float] NULL,
	[bsl_longitude] [float] NULL,
	[bsl_volume_fill_percentage] [float] NULL,
	[bsl_garbage_volume] [float] NULL,
	[bsl_received_date_time] [varchar](max) NULL,
	[bsl_placename] [varchar](max) NULL,
	[bsl_packet_type] [varchar](max) NULL,
	[sla_alert_status] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bin_sensor_predictive_alert]    Script Date: 10/19/2020 1:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bin_sensor_predictive_alert](
	[bspa_DateTime] [datetime] NULL,
	[bspa_Hour] [varchar](max) NULL,
	[bspa_Predicted_Volume] [float] NULL,
	[bspa_Predicted_Pick_Up_Alert] [bigint] NULL,
	[bspa_Bin_ID] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bin_sla_alert_log]    Script Date: 10/19/2020 1:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bin_sla_alert_log](
	[bsal_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[bsal_bin_name] [nvarchar](256) NULL,
	[bsal_bin_location] [nvarchar](256) NULL,
	[bsal_date_time] [datetime] NULL,
	[bsal_ulb_id_pk] [int] NULL,
	[bsal_bin_id] [int] NULL,
	[bsal_volume] [int] NULL,
	[bsal_bin_loc_id] [int] NULL,
	[bsal_alert_status] [int] NULL,
 CONSTRAINT [PK_bin_sla_alert_log] PRIMARY KEY CLUSTERED 
(
	[bsal_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dtd_bin_rfid_details]    Script Date: 10/19/2020 1:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dtd_bin_rfid_details](
	[dbrd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[dbrd_date] [datetime] NULL,
	[dbrd_longitude] [float] NULL,
	[dbrd_latitide] [float] NULL,
	[dbrd_rfid_status] [nvarchar](25) NULL,
	[dbrd_bin_address] [nvarchar](300) NULL,
	[dbrd_rfid_number] [nvarchar](50) NULL,
 CONSTRAINT [PK_dtd_bin_rfid_details] PRIMARY KEY CLUSTERED 
(
	[dbrd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehicle_in_out_status]    Script Date: 10/19/2020 1:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_in_out_status](
	[vios_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[vios_vehicle_no] [nvarchar](100) NULL,
	[vios_vehicle_in_time] [datetime] NULL,
	[vios_vehicle_out_time] [datetime] NULL,
	[vios_fence_type] [int] NULL,
	[vios_fence_name] [nvarchar](max) NULL,
	[vios_fence_id] [int] NULL,
	[vios_duration] [nvarchar](50) NULL,
	[vios_vehicle_id_fk] [int] NULL,
	[vios_is_in] [bit] NULL,
 CONSTRAINT [vehicle_in_out_status_pkey] PRIMARY KEY CLUSTERED 
(
	[vios_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vehicle_rfid_details]    Script Date: 10/19/2020 1:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_rfid_details](
	[vrd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[vrd_sim_number] [nvarchar](12) NULL,
	[vrd_rfid_number] [nvarchar](30) NULL,
	[vrd_date] [datetime] NULL,
	[vrd_longitude] [float] NULL,
	[vrd_latitude] [float] NULL,
	[vrd_packet_type] [int] NULL,
	[vrd_logsheet_id] [int] NULL,
	[vrd_rfid_status] [nvarchar](30) NULL,
	[vrd_vehicle_address] [nvarchar](80) NULL,
 CONSTRAINT [PK_vehicle_rfid_details] PRIMARY KEY CLUSTERED 
(
	[vrd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[view_online_master]    Script Date: 10/19/2020 1:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[view_online_master](
	[vom_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[vom_vehicle_id] [int] NULL,
	[vom_sim_no] [nvarchar](30) NULL,
	[vom_latitude] [float] NULL,
	[vom_longitude] [float] NULL,
	[vom_utc_date_time] [datetime] NULL,
	[vom_received_date_time] [datetime] NULL,
	[vom_placename] [nvarchar](250) NULL,
	[vom_speed] [float] NULL,
	[vom_distance] [numeric](18, 5) NULL,
	[vom_packet_type] [nvarchar](10) NULL,
	[vom_signal_strength] [int] NULL,
	[vom_ignition] [int] NULL,
	[vom_status] [int] NULL,
	[vom_gpsstatus] [nvarchar](50) NULL,
	[vom_batterystatus] [nvarchar](50) NULL,
	[vom_ulb_id] [int] NULL,
	[vom_vehicle_type] [nvarchar](50) NULL,
	[vom_vehicle_No] [varchar](50) NULL,
	[vom_route_distance] [numeric](18, 5) NULL,
	[vom_halt_status] [int] NULL,
	[vom_maintenance_type] [nvarchar](256) NULL,
	[vom_vehicle_is_in] [int] NULL,
	[vom_odometer_value] [float] NULL,
	[vom_route_id] [int] NULL,
	[vom_trip_id] [int] NULL,
	[vom_route_deviation_status] [int] NULL,
	[vom_driver_id] [int] NULL,
	[vom_speedalert_time] [datetime] NULL,
	[vom_idle_time] [datetime] NULL,
	[vom_ignition_on_time] [datetime] NULL,
	[vom_disconnected_status] [int] NOT NULL,
	[vom_degree] [int] NULL,
	[vom_vehicle_is_in_zone] [int] NULL,
	[vom_total_distance] [float] NULL,
	[vom_prev_lat] [float] NULL,
	[vom_prev_long] [float] NULL,
	[vom_halt_alert_status] [int] NOT NULL,
	[vom_halt_time] [datetime] NULL,
	[vom_vehicle_type_id] [int] NULL,
	[isGPS] [bit] NULL,
	[vom_rfid_status] [int] NULL,
	[vom_rfts_status] [int] NULL,
	[batteryLevel] [int] NULL,
 CONSTRAINT [view_online_master_pkey] PRIMARY KEY CLUSTERED 
(
	[vom_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [garbage].[gis_client_fence]    Script Date: 10/19/2020 1:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [garbage].[gis_client_fence](
	[gcf_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[gcf_poi_name] [varchar](256) NULL,
	[gcf_address] [varchar](max) NULL,
	[gcf_poi_type_id_fk] [varchar](256) NULL,
	[gcf_the_geom] [geometry] NULL,
	[gcf_ulb_id_fk] [int] NULL,
	[gcf_poi_fence] [int] NULL,
	[gcf_fence_the_geom] [geometry] NULL,
	[gcf_radius] [float] NULL,
	[gcf_ward_id] [int] NULL,
	[gcf_zone_id] [int] NULL,
	[gcf_created_date] [datetime] NULL,
	[gcf_modified_date] [datetime] NULL,
	[gcf_created_by] [int] NULL,
	[gcf_modified_by] [int] NULL,
 CONSTRAINT [gis_client_fence_pkey] PRIMARY KEY CLUSTERED 
(
	[gcf_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [garbage].[gis_dumping_grounds]    Script Date: 10/19/2020 1:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [garbage].[gis_dumping_grounds](
	[gdg_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[gdg_name] [varchar](256) NULL,
	[gdg_the_geom] [geometry] NULL,
	[gdg_ulb_id_fk] [int] NULL,
	[poi_type_details] [int] NULL,
	[gdg_ward_id] [int] NULL,
	[gdg_zone_id] [int] NULL,
	[gdg_created_date] [datetime] NULL,
	[gdg_modified_date] [datetime] NULL,
	[gdg_created_by] [int] NULL,
	[gdg_modified_by] [int] NULL,
	[fence_type] [int] NULL,
	[FenceUid] [varchar](100) NULL,
	[GisId] [varchar](100) NULL,
	[CamId_FK] [int] NULL,
	[isBinLoc] [bit] NULL,
 CONSTRAINT [gis_dumping_grounds_pkey] PRIMARY KEY CLUSTERED 
(
	[gdg_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [garbage].[gis_garbage_collection_points]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [garbage].[gis_garbage_collection_points](
	[ggcf_points_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[ggcf_points_name] [varchar](256) NULL,
	[ggcf_points_address] [varchar](256) NULL,
	[ggcf_points_count] [int] NULL,
	[the_geom] [geometry] NULL,
	[ggcf_ulb_id_fk] [int] NULL,
	[poi_type_details] [int] NULL,
	[the_fence_geom] [geometry] NULL,
	[the_radious] [float] NULL,
	[ggcf_ward_id] [int] NULL,
	[ggcf_zone_id] [int] NULL,
	[ggcf_created_date] [datetime] NULL,
	[ggcf_modified_date] [datetime] NULL,
	[ggcf_created_by] [int] NULL,
	[ggcf_modified_by] [int] NULL,
	[ggcf_bin_capacity] [int] NULL,
	[Bin_type_id] [int] NULL,
	[ggcf_bin_loc_status] [int] NULL,
	[ggcf_bin_collection_status] [int] NULL,
	[ggcf_last_collected_date] [datetime] NULL,
	[ggcf_vehicle_id] [int] NULL,
	[ggcf_collected_bins] [int] NULL,
	[ggcf_minfrequency] [int] NOT NULL,
	[ggcf_layout_id] [varchar](50) NULL,
	[BinUId] [varchar](50) NULL,
	[bin_gis_id] [varchar](100) NULL,
	[bin_Demand_TypeId] [int] NULL,
	[CamId_FK] [int] NULL,
	[CollectionStatusTypeFK] [int] NULL,
	[isBinLoc] [bit] NULL,
 CONSTRAINT [gis_garbage_collection_points_pkey] PRIMARY KEY CLUSTERED 
(
	[ggcf_points_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [garbage].[gis_road_area]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [garbage].[gis_road_area](
	[gra_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[gra_name] [varchar](256) NULL,
	[gra_address] [varchar](256) NULL,
	[gra_ulb_id_fk] [int] NULL,
	[gra_created_date] [datetime] NULL,
	[gra_ward_id] [int] NULL,
	[gra_zone_id] [int] NULL,
	[gra_fence] [geometry] NULL,
	[gra_modified_date] [datetime] NULL,
	[gra_created_by] [int] NULL,
	[gra_modified_by] [int] NULL,
	[gra_route] [geometry] NULL,
	[gra_points_count] [int] NULL,
	[isStreetSweeping] [bit] NULL,
 CONSTRAINT [gis_road_area_pkey] PRIMARY KEY CLUSTERED 
(
	[gra_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [garbage].[route_details]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [garbage].[route_details](
	[rd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[rd_route_id_fk] [int] NULL,
	[rd_order_no] [int] NULL,
	[rd_check_points] [varchar](256) NULL,
	[rd_check_point_id_fk] [int] NULL,
	[rd_the_geom] [geometry] NULL,
 CONSTRAINT [route_details_pkey] PRIMARY KEY CLUSTERED 
(
	[rd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [garbage].[route_master]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [garbage].[route_master](
	[rm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[rm_route_name] [varchar](256) NULL,
	[rm_ulb_id_fk] [int] NULL,
	[rm_geom] [geometry] NULL,
	[rm_created_by] [int] NULL,
	[rm_modified_by] [int] NULL,
	[rm_modified_date] [datetime] NULL,
	[rm_created_date] [datetime] NULL,
	[rm_ward_id] [int] NULL,
	[rm_zone_id] [int] NULL,
	[rm_fence_geom] [geometry] NULL,
	[rm_type] [int] NULL,
	[bin_Demand_TypeId] [varchar](256) NULL,
	[demandFreq_Status] [int] NULL,
	[CollectionStatusTypeFK] [varchar](256) NULL,
	[Bin_type_id] [varchar](50) NULL,
 CONSTRAINT [route_master_pkey] PRIMARY KEY CLUSTERED 
(
	[rm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reporting].[rfid_read_in_each_binLocation]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reporting].[rfid_read_in_each_binLocation](
	[rreb_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[rreb_bin_loc_id_fk] [int] NULL,
	[rreb_bin_id_fk] [int] NULL,
	[rreb_bin_name] [nvarchar](max) NULL,
	[rreb_trip_ongoing_details_id_fk] [int] NULL,
	[rreb_rfid_tag] [nvarchar](50) NULL,
	[rreb_householder_name] [nvarchar](100) NULL,
	[rreb_dtd_bin_name] [nvarchar](256) NULL,
	[rreb_lat] [float] NULL,
	[rreb_long] [float] NULL,
	[rreb_date_time] [datetime] NULL,
 CONSTRAINT [rreb_id_pk] PRIMARY KEY CLUSTERED 
(
	[rreb_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reporting].[trip_completed_captured_data]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reporting].[trip_completed_captured_data](
	[tccd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[tccd_trip_id_fk] [int] NULL,
	[tccd_bin_id_fk] [int] NULL,
	[tccd_bin_images_url] [nvarchar](max) NULL,
	[tccd_bin_remarks] [nvarchar](max) NULL,
	[tccd_bin_coordinates] [nvarchar](max) NULL,
	[tcd_collected_datetime] [datetime] NULL,
 CONSTRAINT [trip_completed_captured_data_pkey] PRIMARY KEY CLUSTERED 
(
	[tccd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reporting].[trip_completed_details]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reporting].[trip_completed_details](
	[tcd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[tcd_master_id_fk] [int] NULL,
	[tcd_bin_id_fk] [int] NULL,
	[tcd_bin_name] [varchar](max) NOT NULL,
	[tcd_collection_status] [int] NULL,
	[tcd_bin_entry_time] [datetime] NULL,
	[tcd_bin_exit_time] [datetime] NULL,
	[tcd_sequence_no] [int] NULL,
	[tcd_bins_to_be_collected] [int] NULL,
	[tcd_bins_collected] [int] NULL,
	[image_url] [varchar](255) NULL,
 CONSTRAINT [trip_completed_details_pkey] PRIMARY KEY CLUSTERED 
(
	[tcd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reporting].[trip_completed_master]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reporting].[trip_completed_master](
	[tcm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[tcm_vehicle_id_fk] [int] NULL,
	[tcm_trip_id_fk] [int] NULL,
	[tcm_route_id_fk] [int] NULL,
	[tcm_trip_date_time] [datetime] NULL,
	[tcm_start_date_time] [datetime] NULL,
	[tcm_end_date_time] [datetime] NULL,
	[tcm_trip_status] [int] NULL,
	[tcm_driver_id_fk] [int] NULL,
	[tcm_cleaner_id_fk] [int] NULL,
	[tcm_shift_id_fk] [int] NULL,
	[tcm_weight_disposed] [float] NULL,
	[tcm_dumping_ground] [varchar](max) NULL,
	[tcm_dump_entry_time] [datetime] NULL,
	[tcm_dump_exit_time] [datetime] NULL,
	[tcm_zone_name] [varchar](250) NULL,
	[tcm_ward_name] [varchar](250) NULL,
	[tcm_start_location] [varchar](max) NULL,
	[tcm_end_location] [varchar](max) NULL,
	[tcm_zone_id] [int] NULL,
	[tcm_ward_id] [int] NULL,
	[tcm_ulb_id_fk] [int] NULL,
	[tcm_route_type] [int] NULL,
	[tcm_received_weight] [float] NULL,
	[tcm_trip_distance] [float] NULL,
	[Maitenance] [bit] NULL,
	[singleBinArea_FK] [int] NULL,
 CONSTRAINT [trip_completed_master_pkey] PRIMARY KEY CLUSTERED 
(
	[tcm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reporting].[trip_completed_rfid_details]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reporting].[trip_completed_rfid_details](
	[tcrd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[tcrd_bin_loc_id_fk] [int] NULL,
	[tcrd_bin_id_fk] [int] NULL,
	[tcrd_bin_name] [nvarchar](max) NULL,
	[tcrd_trip_ongoing_details_id_fk] [int] NULL,
	[tcrd_rfid_tag] [nvarchar](50) NULL,
	[tcrd_householder_name] [nvarchar](100) NULL,
	[tcrd_dtd_bin_name] [nvarchar](256) NULL,
	[tcrd_lat] [float] NULL,
	[tcrd_long] [float] NULL,
	[tcrd_date_time] [datetime] NULL,
 CONSTRAINT [tcrd_id_pk] PRIMARY KEY CLUSTERED 
(
	[tcrd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reporting].[trip_ongoing_captured_data]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reporting].[trip_ongoing_captured_data](
	[tocd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[tocd_trip_id_fk] [int] NULL,
	[tocd_bin_id_fk] [int] NULL,
	[tocd_bin_images_url] [nvarchar](max) NULL,
	[tocd_bin_remarks] [nvarchar](max) NULL,
	[tocd_bin_coordinates] [nvarchar](max) NULL,
	[tod_collected_datetime] [datetime] NULL,
	[tocd_video_url] [nvarchar](max) NULL,
	[tocd_audio_url] [nvarchar](max) NULL,
 CONSTRAINT [trip_ongoing_captured_data_pkey] PRIMARY KEY CLUSTERED 
(
	[tocd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reporting].[trip_ongoing_details]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reporting].[trip_ongoing_details](
	[tod_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[tod_master_id_fk] [int] NULL,
	[tod_bin_id_fk] [int] NULL,
	[tod_bin_name] [varchar](max) NOT NULL,
	[tod_collection_status] [int] NULL,
	[tod_bin_entry_time] [datetime] NULL,
	[tod_bin_exit_time] [datetime] NULL,
	[tod_sequence_no] [int] NULL,
	[tod_bins_to_be_collected] [int] NULL,
	[tod_bins_collected] [int] NULL,
	[image_url] [varchar](255) NULL,
 CONSTRAINT [trip_ongoing_details_pkey] PRIMARY KEY CLUSTERED 
(
	[tod_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reporting].[trip_ongoing_master]    Script Date: 10/19/2020 1:14:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reporting].[trip_ongoing_master](
	[tom_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[tom_vehicle_id_fk] [int] NULL,
	[tom_trip_id_fk] [int] NULL,
	[tom_route_id_fk] [int] NULL,
	[tom_trip_schedule_date_time] [datetime] NULL,
	[tom_start_date_time] [datetime] NULL,
	[tom_end_date_time] [datetime] NULL,
	[tom_start_location] [nvarchar](max) NULL,
	[tom_end_location] [nvarchar](max) NULL,
	[tom_trip_status] [int] NULL,
	[tom_driver_id_fk] [int] NULL,
	[tom_cleaner_id_fk] [int] NULL,
	[tom_shift_id_fk] [int] NULL,
	[tom_weight_disposed] [float] NULL,
	[tom_notify_status] [int] NULL,
	[tom_final_location] [int] NULL,
	[tom_start_loc_type] [int] NULL,
	[tom_end_loc_type] [int] NULL,
	[tom_route_type] [int] NULL,
	[tom_received_weight] [float] NULL,
	[tom_dump_time] [datetime] NULL,
	[tom_trip_distance] [float] NULL,
	[tom_rm_geom] [geometry] NULL,
	[tom_is_from_citizen] [int] NULL,
	[Maitenance] [bit] NULL,
	[singleBinArea_FK] [int] NULL,
 CONSTRAINT [trip_ongoing_master_pkey] PRIMARY KEY CLUSTERED 
(
	[tom_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reporting].[trip_weight_details]    Script Date: 10/19/2020 1:14:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reporting].[trip_weight_details](
	[twd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[twd_trip_id] [int] NULL,
	[twd_vehicle_id_fk] [int] NULL,
	[twd_dgwdid_fk] [int] NULL,
	[twd_ward_id_fk] [int] NULL,
	[twd_weight] [int] NULL,
	[twd_updated_date] [datetime] NULL,
	[twd_gross_weight] [float] NULL,
 CONSTRAINT [trip_weight_details_pkey] PRIMARY KEY CLUSTERED 
(
	[twd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [reports].[bin_collection_detailed_report]    Script Date: 10/19/2020 1:14:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[bin_collection_detailed_report](
	[bcdr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[bcdr_bin_collected_status] [int] NULL,
	[bcdr_bin_id] [int] NULL,
	[bcdr_bin_location_id] [int] NULL,
	[bcdr_date] [date] NULL,
	[bcdr_zone_id] [int] NULL,
	[bcdr_ward_id] [int] NULL,
	[bcdr_ulb_id_fk] [int] NULL,
	[bcdr_vehicle_id_fk] [int] NULL,
	[bcdr_collected_time] [datetime] NULL,
	[bcdr_bin_type_id] [int] NULL,
 CONSTRAINT [bin_collection_detailed_report_pkey] PRIMARY KEY CLUSTERED 
(
	[bcdr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [reports].[bin_status_report]    Script Date: 10/19/2020 1:14:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[bin_status_report](
	[bsr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[bsr_vehicle_no] [nvarchar](256) NULL,
	[bsr_vehicle_id_fk] [int] NULL,
	[bsr_route_id_fk] [int] NULL,
	[bsr_route_name] [nvarchar](256) NULL,
	[bsr_bin_location] [nvarchar](256) NULL,
	[bsr_date] [date] NULL,
	[bsr_collect_status] [int] NULL,
	[bsr_zone_id] [int] NULL,
	[bsr_ward_id] [int] NULL,
	[bsr_ward_name] [varchar](256) NULL,
	[bsr_zone_name] [varchar](256) NULL,
	[bsr_ulb_id_fk] [int] NULL,
	[bsr_entry_time] [datetime] NULL,
	[bsr_exit_time] [datetime] NULL,
	[bsr_bin_id] [int] NULL,
 CONSTRAINT [bin_status_report_pkey] PRIMARY KEY CLUSTERED 
(
	[bsr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [reports].[bin_summary_report]    Script Date: 10/19/2020 1:14:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[bin_summary_report](
	[bsr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[bsr_vehicle_no] [nvarchar](256) NULL,
	[bsr_vehicle_id_fk] [int] NULL,
	[bsr_route_id_fk] [int] NULL,
	[bsr_route_name] [nvarchar](256) NULL,
	[bsr_bin_collected] [int] NULL,
	[bsr_bin_not_collected] [int] NULL,
	[bsr_date] [date] NULL,
	[bsr_zone_id] [int] NULL,
	[bsr_ward_id] [int] NULL,
	[bsr_ward_name] [varchar](256) NULL,
	[bsr_zone_name] [varchar](256) NULL,
	[bsr_ulb_id_fk] [int] NULL,
	[bsr_weight] [int] NULL,
 CONSTRAINT [bin_summary_report_pkey] PRIMARY KEY CLUSTERED 
(
	[bsr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [reports].[dtd_bin_collection_detailed_report]    Script Date: 10/19/2020 1:14:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[dtd_bin_collection_detailed_report](
	[dbcdr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[dbcdr_bin_collected_status] [int] NULL,
	[dbcdr_bin_id] [int] NULL,
	[dbcdr_road_id] [int] NULL,
	[dbcdr_zone_id] [int] NULL,
	[dbcdr_ward_id] [int] NULL,
	[dbcdr_ulb_id_fk] [int] NULL,
	[dbcdr_vehicle_id_fk] [int] NULL,
	[dbcdr_collected_time] [datetime] NULL,
	[dbcdr_house_holder_name] [nvarchar](256) NULL,
	[dbcdr_date] [date] NULL,
	[dbcdr_trip_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[dbcdr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [reports].[dump_weight_details]    Script Date: 10/19/2020 1:14:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[dump_weight_details](
	[dwd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[dwd_vehicle_id_fk] [int] NULL,
	[dwd_dgwdid_fk] [int] NULL,
	[dwd_rfid_no] [nvarchar](30) NULL,
	[dwd_weight] [int] NULL,
	[dwd_updated_date] [datetime] NULL,
	[dwd_received_time] [datetime] NULL,
	[dwd_trip_id_fk] [int] NOT NULL,
	[dwd_disposed_weight] [float] NULL,
	[gross_weight_stable] [int] NULL,
	[net_weight_stable] [int] NULL,
 CONSTRAINT [dump_weight_details_pkey] PRIMARY KEY CLUSTERED 
(
	[dwd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [reports].[halt_report]    Script Date: 10/19/2020 1:14:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[halt_report](
	[hr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[hr_vehicle_no] [nvarchar](256) NULL,
	[hr_vehicle_id_fk] [int] NULL,
	[hr_startdate_time] [datetime] NULL,
	[hr_enddate_time] [datetime] NULL,
	[hr_location] [nvarchar](max) NULL,
	[hr_duration] [time](7) NULL,
	[hr_latitude] [float] NULL,
	[hr_longitude] [float] NULL,
	[hr_ulb_id] [int] NULL,
	[hr_is_in] [bit] NULL,
	[hr_is_bin] [int] NULL,
	[hr_status] [int] NULL,
 CONSTRAINT [halt_report_pkey] PRIMARY KEY CLUSTERED 
(
	[hr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reports].[report_configuration]    Script Date: 10/19/2020 1:14:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[report_configuration](
	[rc_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[rc_vehicle_id] [nvarchar](max) NULL,
	[rc_report_id] [int] NULL,
	[rc_email_status] [int] NULL,
	[rc_email_time] [time](7) NULL,
	[rc_email_id] [varchar](256) NULL,
	[rc_ulb_id_fk] [int] NULL,
	[rc_sub_report_id] [int] NULL,
	[rc_person_name] [varchar](256) NULL,
	[rc_created_date] [datetime] NULL,
	[rc_created_by] [int] NULL,
	[rc_modified_date] [datetime] NULL,
	[rc_modified_by] [int] NULL,
 CONSTRAINT [report_configuration_pkey] PRIMARY KEY CLUSTERED 
(
	[rc_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reports].[report_distance]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[report_distance](
	[rd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[rd_vehicle_id] [int] NULL,
	[rd_date_time] [datetime] NULL,
	[rd_distance] [float] NULL,
	[rd_vehicle_no] [nvarchar](50) NULL,
	[rd_ulb_id_fk] [int] NULL,
 CONSTRAINT [report_distance_pkey] PRIMARY KEY CLUSTERED 
(
	[rd_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [reports].[report_weight]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[report_weight](
	[rw_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[rw_ulb_id_fk] [int] NULL,
	[rw_vehicle_id_fk] [int] NULL,
	[rw_trip_id_fk] [int] NULL,
	[rw_date_time] [datetime] NULL,
	[rw_shift_type_id] [int] NULL,
	[rw_shift_type] [nvarchar](50) NULL,
	[rw_weight] [float] NULL,
	[rw_route_id] [int] NULL,
	[rw_ward_id] [int] NULL,
	[rw_zone_id] [int] NULL,
	[rw_zone_name] [varchar](256) NULL,
	[rw_ward_name] [varchar](256) NULL,
	[rw_route_name] [varchar](256) NULL,
	[rw_vehicle_no] [varchar](256) NULL,
 CONSTRAINT [report_weight_pkey] PRIMARY KEY CLUSTERED 
(
	[rw_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [reports].[route_deviation_report]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[route_deviation_report](
	[rdr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[rdr_vehicle_no] [nvarchar](256) NULL,
	[rdr_vehicle_id_fk] [int] NULL,
	[rdr_route_id_fk] [int] NULL,
	[rdr_route_name] [nvarchar](256) NULL,
	[rdr_bin_location] [nvarchar](256) NULL,
	[rdr_date] [date] NULL,
	[rdr_shift_id] [int] NULL,
	[rdr_zone_id] [int] NULL,
	[rdr_ward_id] [int] NULL,
	[rdr_ward_name] [varchar](256) NULL,
	[rdr_zone_name] [varchar](256) NULL,
	[rdr_ulb_id_fk] [int] NULL,
	[rdr_trip_id] [int] NULL,
 CONSTRAINT [route_deviation_report_pkey] PRIMARY KEY CLUSTERED 
(
	[rdr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [reports].[route_report]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[route_report](
	[rr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[rr_vehicle_no] [nvarchar](256) NULL,
	[rr_vehicle_id_fk] [int] NULL,
	[rr_date_time] [datetime] NULL,
	[rr_location] [nvarchar](max) NULL,
 CONSTRAINT [route_report_pkey] PRIMARY KEY CLUSTERED 
(
	[rr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reports].[staff_attendance_report]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[staff_attendance_report](
	[sar_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[sar_staff_id_fk] [nvarchar](50) NULL,
	[sar_staff_name] [varchar](max) NULL,
	[sar_login_time] [datetime] NULL,
	[sar_logout_time] [datetime] NULL,
	[sar_ulb_id_fk] [int] NULL,
	[sar_staff_type_id] [int] NULL,
	[sar_staff_type] [varchar](50) NULL,
	[sar_staff_status] [nvarchar](50) NULL,
	[sar_date] [date] NULL,
	[sar_emp_id] [nvarchar](50) NULL,
	[sar_shift_id] [int] NULL,
	[sar_shift_end_time_status] [int] NULL,
	[sar_shift_start_time_status] [int] NULL,
	[sar_staff_category_id_fk] [int] NULL,
	[sar_supervisor_id_fk] [int] NULL,
	[sar_ward_id_fk] [int] NULL,
 CONSTRAINT [staff_attendance_report_pkey] PRIMARY KEY CLUSTERED 
(
	[sar_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reports].[staff_report_images]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[staff_report_images](
	[sri_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[sri_employee_id] [nvarchar](50) NULL,
	[sri_image_url] [nvarchar](max) NULL,
	[sri_comment] [nvarchar](max) NULL,
	[sri_updated_time] [datetime] NULL,
 CONSTRAINT [staff_report_images_pkey] PRIMARY KEY CLUSTERED 
(
	[sri_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reports].[vehicle_maintenance_history_report]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[vehicle_maintenance_history_report](
	[vmhr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[vmhr_vehicle_id_fk] [int] NULL,
	[vmhr_maintenance_type] [int] NULL,
	[vmhr_location] [nvarchar](max) NULL,
	[vmhr_remarks] [nvarchar](max) NULL,
	[vmhr_datetime] [datetime] NULL,
	[vmhr_ulb_id_fk] [int] NULL,
	[vmhr_repaired_date] [varchar](255) NULL,
	[vmhr_repair_reason] [nvarchar](max) NULL,
 CONSTRAINT [vehicle_maintenance_history_report_pkey] PRIMARY KEY CLUSTERED 
(
	[vmhr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [reports].[vehicle_maintenance_report]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [reports].[vehicle_maintenance_report](
	[vmr_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[vmr_vehicle_id_fk] [int] NULL,
	[vmr_maintenance_type] [int] NULL,
	[vmr_location] [nvarchar](max) NULL,
	[vmr_remarks] [nvarchar](max) NULL,
	[vmr_datetime] [datetime] NULL,
	[vmr_status] [int] NULL,
	[vmr_modified_date] [datetime] NULL,
	[vmr_ulb_id_fk] [int] NULL,
	[vmr_repair_reason] [nvarchar](max) NULL,
 CONSTRAINT [vehicle_maintenance_report_pkey] PRIMARY KEY CLUSTERED 
(
	[vmr_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [scheduling].[dispatch_trip_master]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scheduling].[dispatch_trip_master](
	[dtm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[dtm_vheicle_id_fk] [int] NULL,
	[dtm_date_time] [datetime] NULL,
	[dtm_status] [int] NULL,
	[dtm_schedule_type] [int] NULL,
	[dtm_bin_location_id] [int] NULL,
	[dtm_bin_id] [int] NULL,
	[dtm_dumping_ground] [int] NULL,
	[dtm_trip_id] [int] NULL,
	[dtm_basic_id] [bigint] NULL,
	[dtm_trip_status] [int] NULL,
	[dtm_collection_time] [datetime] NULL,
	[dtm_mac_address] [nvarchar](20) NULL,
	[dtm_workforce_notify_status] [int] NULL,
	[is_new_trip] [bit] NULL,
	[isCitizen] [int] NULL,
 CONSTRAINT [dispatch_trip_master_pkey] PRIMARY KEY CLUSTERED 
(
	[dtm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scheduling].[schedule_repeat_status]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scheduling].[schedule_repeat_status](
	[srs_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[srs_status] [varchar](256) NULL,
	[srs_module_status] [int] NULL,
 CONSTRAINT [schedule_repeat_status_pkey] PRIMARY KEY CLUSTERED 
(
	[srs_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scheduling].[schedule_trip_details]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scheduling].[schedule_trip_details](
	[std_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[std_stm_id_fk] [int] NULL,
	[std_bin_id_fk] [int] NULL,
	[std_sequence_no] [int] NULL,
	[std_bins_to_be_collected] [int] NULL,
 CONSTRAINT [schedule_trip_details_pkey] PRIMARY KEY CLUSTERED 
(
	[std_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [scheduling].[schedule_trip_master]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scheduling].[schedule_trip_master](
	[stm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[stm_vehicle_category_id_fk] [int] NULL,
	[stm_vheicle_id_fk] [int] NULL,
	[stm_shift_id_fk] [int] NULL,
	[stm_driver_id_fk] [int] NULL,
	[stm_cleaner_id_fk] [int] NULL,
	[stm_date_time] [datetime] NULL,
	[stm_status] [int] NULL,
	[stm_schedule_type] [int] NULL,
	[stm_start_location] [int] NULL,
	[stm_end_location] [int] NULL,
	[stm_route_id_fk] [int] NULL,
	[stm_staff] [nvarchar](max) NULL,
	[stm_final_location] [int] NULL,
	[stm_start_loc_type] [int] NULL,
	[stm_end_loc_type] [int] NULL,
	[stm_geom] [geometry] NULL,
	[stm_rqst_id] [int] NULL,
	[stm_type_id] [int] NULL,
	[stm_end_time] [datetime] NULL,
	[stm_alert_notify] [int] NULL,
 CONSTRAINT [schedule_trip_master_pkey] PRIMARY KEY CLUSTERED 
(
	[stm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [scheduling].[schedule_trip_repeatedly]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [scheduling].[schedule_trip_repeatedly](
	[str_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[str_stm_id_fk] [int] NULL,
	[str_repeat_status] [int] NULL,
	[str_shift_id_fk] [int] NULL,
	[str_schedule_date] [nvarchar](max) NULL,
	[str_update_date] [date] NULL,
	[str_schedule_end_date] [nvarchar](max) NULL,
 CONSTRAINT [schedule_trip_repeatedly_pkey] PRIMARY KEY CLUSTERED 
(
	[str_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [staff_attendance].[online_staff_master]    Script Date: 10/19/2020 1:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staff_attendance].[online_staff_master](
	[osm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[osm_staff_name] [nvarchar](256) NULL,
	[osm_emp_id] [nvarchar](50) NULL,
	[osm_staff_type] [nvarchar](50) NULL,
	[osm_phone_no] [nvarchar](20) NULL,
	[osm_login_time] [datetime] NULL,
	[osm_logout_time] [datetime] NULL,
	[osm_location] [nvarchar](256) NULL,
	[osm_status] [int] NULL,
	[osm_zonename] [nvarchar](100) NULL,
	[osm_wardname] [nvarchar](100) NULL,
	[cssm_ulb_id_fk] [int] NULL,
	[osm_latitude] [float] NULL,
	[osm_longitude] [float] NULL,
	[osm_staff_id] [int] NULL,
	[osm_shift_type_id_fk] [varchar](150) NULL,
	[osm_package_id_fk] [int] NULL,
	[osm_staff_category_id_fk] [int] NULL,
 CONSTRAINT [online_staff_master_pkey] PRIMARY KEY CLUSTERED 
(
	[osm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [admin].[config_alerts_recived_log] ADD  DEFAULT ((0)) FOR [arl_assign_status]
GO
ALTER TABLE [admin].[config_alerts_recived_log] ADD  DEFAULT ((0)) FOR [arl_notify_status]
GO
ALTER TABLE [admin].[config_bin_master] ADD  DEFAULT ((0)) FOR [cbm_ulb_id_fk]
GO
ALTER TABLE [admin].[config_bin_master] ADD  DEFAULT ((0)) FOR [cbm_zone_id]
GO
ALTER TABLE [admin].[config_bin_master] ADD  DEFAULT ((0)) FOR [cbm_ward_id]
GO
ALTER TABLE [admin].[config_bin_master] ADD  DEFAULT ((0)) FOR [cbm_created_by]
GO
ALTER TABLE [admin].[config_bin_master] ADD  DEFAULT ((0)) FOR [cbm_modified_by]
GO
ALTER TABLE [admin].[config_bin_master] ADD  DEFAULT ((0)) FOR [cbm_bin_capacity]
GO
ALTER TABLE [admin].[config_bin_master] ADD  DEFAULT ((0)) FOR [cbm_device_type]
GO
ALTER TABLE [admin].[config_bin_master] ADD  CONSTRAINT [DF_config_bin_master_cbm_binRroad_status]  DEFAULT ((0)) FOR [cbm_binRroad_status]
GO
ALTER TABLE [admin].[config_bin_master] ADD  DEFAULT ((0)) FOR [cbm_bin_category_type]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_ulb_id_fk]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_zone_id]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_ward_id]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_created_by]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_modified_by]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_bin_full_status]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_check_count]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_bin_loc_id]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT (NULL) FOR [cbsm_location]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_collection_status]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_sla_hours]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [cbsm_sla_type_id]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT (NULL) FOR [cbsm_sla_type]
GO
ALTER TABLE [admin].[config_bin_sensor_master] ADD  DEFAULT ((0)) FOR [not_collect_status]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_year_of_making]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_vehicle_type_id_fk]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_fuel_capacity]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_ulb_id_fk]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_vehicle_available_status]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_created_by]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_modified_by]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_maintenance_status]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_mileage]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_zone_id]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_fleet_capacity]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_driver_id]
GO
ALTER TABLE [admin].[config_fleet_master] ADD  DEFAULT ((0)) FOR [cfm_iotops_id]
GO
ALTER TABLE [admin].[config_mobile_user_master] ADD  DEFAULT ((0)) FOR [cmum_zone_status]
GO
ALTER TABLE [admin].[config_mobile_user_master] ADD  DEFAULT ((0)) FOR [cmum_ward_status]
GO
ALTER TABLE [admin].[config_mobile_user_master] ADD  DEFAULT ((0)) FOR [cmum_driver_id]
GO
ALTER TABLE [admin].[config_mobile_user_master] ADD  DEFAULT ((0)) FOR [cmum_license_key]
GO
ALTER TABLE [admin].[config_online_master] ADD  DEFAULT ((0)) FOR [com_fleet_id]
GO
ALTER TABLE [admin].[config_online_master] ADD  DEFAULT ((0)) FOR [com_sim_id]
GO
ALTER TABLE [admin].[config_online_master] ADD  DEFAULT ((0)) FOR [com_status]
GO
ALTER TABLE [admin].[config_online_master] ADD  DEFAULT ((0)) FOR [com_assigned_by]
GO
ALTER TABLE [admin].[config_online_master] ADD  DEFAULT ((0)) FOR [com_unassigned_by]
GO
ALTER TABLE [admin].[config_online_master] ADD  DEFAULT ((0)) FOR [com_ulb_id_fk]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_ulb_id_fk]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_zone_id]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_ward_id]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_created_by]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_modified_by]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_bin_full_status]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_check_count]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crf_capacity]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_bin_lat]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_bin_long]
GO
ALTER TABLE [admin].[config_rfid_master] ADD  DEFAULT ((0)) FOR [crm_bin_collection_status]
GO
ALTER TABLE [admin].[config_rfid_reader] ADD  DEFAULT ((0)) FOR [crd_ts_dg]
GO
ALTER TABLE [admin].[config_rfid_reader] ADD  CONSTRAINT [DF_config_rfid_reader_crd_assign_status]  DEFAULT ((0)) FOR [crd_assign_status]
GO
ALTER TABLE [admin].[config_sim_master] ADD  DEFAULT ((0)) FOR [csm_status]
GO
ALTER TABLE [admin].[config_sim_master] ADD  DEFAULT ((0)) FOR [csm_ulb_id_fk]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [cssm_shift_type_id_fk]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [cssm_state]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [cssm_city]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [cssm_driver_status]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [cssm_staff_type]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [cssm_created_by]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [cssm_modified_by]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [cssm_ulb_id_fk]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [cssm_mobile_user_status]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT (NULL) FOR [csm_shift_type_id_fk]
GO
ALTER TABLE [admin].[config_staff_master] ADD  DEFAULT ((0)) FOR [is_assigned_trip]
GO
ALTER TABLE [admin].[config_user_master] ADD  DEFAULT ((0)) FOR [cum_garbage_collection_menu]
GO
ALTER TABLE [admin].[config_user_master] ADD  CONSTRAINT [DF_config_user_master_cum_otp_no]  DEFAULT ((0)) FOR [cum_otp_no]
GO
ALTER TABLE [admin].[config_user_master] ADD  DEFAULT ((0)) FOR [cum_ward_status]
GO
ALTER TABLE [admin].[config_user_master] ADD  DEFAULT ((0)) FOR [cum_zone_status]
GO
ALTER TABLE [admin].[config_user_master] ADD  DEFAULT ((0)) FOR [cum_ulb_status]
GO
ALTER TABLE [admin].[config_user_master] ADD  DEFAULT ((0)) FOR [cum_esbm_user_status]
GO
ALTER TABLE [admin].[config_user_master] ADD  DEFAULT ((0)) FOR [is_logged_in]
GO
ALTER TABLE [admin].[config_user_master] ADD  DEFAULT ((0)) FOR [tenantStatus]
GO
ALTER TABLE [admin].[config_ward_master] ADD  DEFAULT ((0)) FOR [cwm_zone_id_fk]
GO
ALTER TABLE [admin].[config_ward_master] ADD  DEFAULT ((0)) FOR [cwm_ulb_id_fk]
GO
ALTER TABLE [admin].[config_zone_master] ADD  DEFAULT ((0)) FOR [czm_ulb_id_fk]
GO
ALTER TABLE [admin].[DeviceManagementDetails] ADD  DEFAULT ((0)) FOR [DeviceAssignedStatus]
GO
ALTER TABLE [admin].[DeviceManagementDetails] ADD  DEFAULT ((0)) FOR [isBin]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_year_of_making]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_vehicle_type_id_fk]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_fuel_capacity]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_ulb_id_fk]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_vehicle_available_status]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_created_by]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_modified_by]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_maintenance_status]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_mileage]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_zone_id]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_fleet_capacity]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_driver_id]
GO
ALTER TABLE [admin].[unassigned_fleet_details] ADD  DEFAULT ((0)) FOR [cfm_iotops_id]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulbm_city_id_fk]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulbm_state_id_fk]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulbm_available_status]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulbm_created_by]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulbm_modified_by]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulb_mobile_key_count]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulb_vehicle_key_count]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT (NULL) FOR [ulbm_fbpageId]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT (NULL) FOR [ulbm_twitterpageId]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulbm_supervisor_key_count]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulb_vehicle_charges]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulb_driverapp_charges]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [ulb_supervisoryapp_charges]
GO
ALTER TABLE [admin].[urban_local_body_master] ADD  DEFAULT ((0)) FOR [is_logged_in]
GO
ALTER TABLE [admin].[user_log] ADD  DEFAULT ((0)) FOR [login_status]
GO
ALTER TABLE [citizen].[citizen_complaints] ADD  DEFAULT ((0)) FOR [cc_ward]
GO
ALTER TABLE [citizen].[citizen_complaints] ADD  DEFAULT ((0)) FOR [cc_zone]
GO
ALTER TABLE [citizen].[citizen_complaints] ADD  DEFAULT ((0)) FOR [cc_complaint_type]
GO
ALTER TABLE [citizen].[citizen_complaints] ADD  DEFAULT ((0)) FOR [cc_complain_mode]
GO
ALTER TABLE [citizen].[citizen_complaints] ADD  DEFAULT ((0)) FOR [cc_priority]
GO
ALTER TABLE [citizen].[citizen_complaints] ADD  DEFAULT ((0)) FOR [cc_compliant_status]
GO
ALTER TABLE [citizen].[citizen_complaints] ADD  DEFAULT ((0)) FOR [cc_assign_status]
GO
ALTER TABLE [citizen].[citizen_complaints] ADD  DEFAULT ((0)) FOR [cc_ulb_id_fk]
GO
ALTER TABLE [citizen].[citizen_complaints] ADD  DEFAULT ((0)) FOR [cc_insertstatus]
GO
ALTER TABLE [citizen].[citizen_complaints_action_status] ADD  DEFAULT ((0)) FOR [ccas_cc_id_fk]
GO
ALTER TABLE [citizen].[citizen_complaints_action_status] ADD  DEFAULT ((0)) FOR [ccas_assigned_user]
GO
ALTER TABLE [citizen].[citizen_complaints_action_status] ADD  DEFAULT ((0)) FOR [ccas_action_status]
GO
ALTER TABLE [citizen].[citizen_complaints_action_status] ADD  DEFAULT ((0)) FOR [ccas_user_type]
GO
ALTER TABLE [dashboard].[bin_collection_report] ADD  DEFAULT ((0)) FOR [bcr_bin_collected]
GO
ALTER TABLE [dashboard].[bin_collection_report] ADD  DEFAULT ((0)) FOR [bcr_bin_not_collected]
GO
ALTER TABLE [dashboard].[bin_collection_report] ADD  DEFAULT ((0)) FOR [bcr_zone_id]
GO
ALTER TABLE [dashboard].[bin_collection_report] ADD  DEFAULT ((0)) FOR [bcr_ward_id]
GO
ALTER TABLE [dashboard].[bin_collection_report] ADD  DEFAULT ((0)) FOR [dsr_ulb_id_fk]
GO
ALTER TABLE [dashboard].[bin_collection_report] ADD  DEFAULT ((0)) FOR [bcr_total_bins]
GO
ALTER TABLE [dashboard].[bin_collection_report] ADD  DEFAULT ((0)) FOR [bcr_bin_attended_not_collected]
GO
ALTER TABLE [dashboard].[bin_collection_report] ADD  DEFAULT ((0)) FOR [bcr_bin_type_id]
GO
ALTER TABLE [dashboard].[dashboard_garbage_bin_details] ADD  DEFAULT ((0)) FOR [dgbd_ulb_id_fk]
GO
ALTER TABLE [dashboard].[dashboard_garbage_bin_details] ADD  DEFAULT ((0)) FOR [dgbd_bins_collected]
GO
ALTER TABLE [dashboard].[dashboard_garbage_bin_details] ADD  DEFAULT ((0)) FOR [dgbd_bins_pending]
GO
ALTER TABLE [dashboard].[dashboard_staff_attendance] ADD  DEFAULT ((0)) FOR [dsa_ulb_id_fk]
GO
ALTER TABLE [dashboard].[dashboard_staff_attendance] ADD  DEFAULT ((0)) FOR [dsa_total_staff_count]
GO
ALTER TABLE [dashboard].[dashboard_staff_attendance] ADD  DEFAULT ((0)) FOR [dsa_staff_present_count]
GO
ALTER TABLE [dashboard].[dashboard_staff_attendance] ADD  DEFAULT ((0)) FOR [dsa_staff_absent_count]
GO
ALTER TABLE [dashboard].[dashboard_staff_attendance] ADD  DEFAULT ((0)) FOR [dsa_staff_type]
GO
ALTER TABLE [dbo].[alert_log] ADD  DEFAULT ((0)) FOR [al_ulb_id_fk]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ((0)) FOR [bsal_ulb_id_pk]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ((0)) FOR [bsal_bin_id]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ((0)) FOR [bsal_volume]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ((0)) FOR [bsal_bin_loc_id]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ((0)) FOR [bsal_fg_update_status]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ((0)) FOR [bsal_trip_id]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ((0)) FOR [bsal_basic_id]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ((0)) FOR [bsal_mailing_status]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ((0)) FOR [skippedStatus]
GO
ALTER TABLE [dbo].[bin_sensor_alert_log] ADD  DEFAULT ('BIN') FOR [bsal_source_name]
GO
ALTER TABLE [dbo].[bin_sla_alert_log] ADD  DEFAULT ((0)) FOR [bsal_ulb_id_pk]
GO
ALTER TABLE [dbo].[bin_sla_alert_log] ADD  DEFAULT ((0)) FOR [bsal_bin_id]
GO
ALTER TABLE [dbo].[bin_sla_alert_log] ADD  DEFAULT ((0)) FOR [bsal_volume]
GO
ALTER TABLE [dbo].[bin_sla_alert_log] ADD  DEFAULT ((0)) FOR [bsal_bin_loc_id]
GO
ALTER TABLE [dbo].[bin_sla_alert_log] ADD  CONSTRAINT [DF_bin_sla_alert_log_bsal_alert_status]  DEFAULT ((0)) FOR [bsal_alert_status]
GO
ALTER TABLE [dbo].[vehicle_in_out_status] ADD  DEFAULT ((0)) FOR [vios_fence_type]
GO
ALTER TABLE [dbo].[vehicle_in_out_status] ADD  DEFAULT ((0)) FOR [vios_fence_id]
GO
ALTER TABLE [dbo].[vehicle_in_out_status] ADD  DEFAULT ((0)) FOR [vios_vehicle_id_fk]
GO
ALTER TABLE [dbo].[vehicle_in_out_status] ADD  DEFAULT ((0)) FOR [vios_is_in]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_vehicle_id]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_speed]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_distance]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_signal_strength]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_ignition]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_status]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_ulb_id]
GO
ALTER TABLE [dbo].[view_online_master] ADD  CONSTRAINT [DF_view_online_master_vom_route_distance]  DEFAULT ((0)) FOR [vom_route_distance]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_halt_status]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_vehicle_is_in]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_odometer_value]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_route_id]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_trip_id]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_route_deviation_status]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_driver_id]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_disconnected_status]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_vehicle_is_in_zone]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_total_distance]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT ((0)) FOR [vom_halt_alert_status]
GO
ALTER TABLE [dbo].[view_online_master] ADD  DEFAULT (NULL) FOR [vom_halt_time]
GO
ALTER TABLE [garbage].[gis_client_fence] ADD  DEFAULT ((0)) FOR [gcf_radius]
GO
ALTER TABLE [garbage].[gis_client_fence] ADD  DEFAULT ((0)) FOR [gcf_ward_id]
GO
ALTER TABLE [garbage].[gis_client_fence] ADD  DEFAULT ((0)) FOR [gcf_zone_id]
GO
ALTER TABLE [garbage].[gis_client_fence] ADD  DEFAULT ((0)) FOR [gcf_created_by]
GO
ALTER TABLE [garbage].[gis_client_fence] ADD  DEFAULT ((0)) FOR [gcf_modified_by]
GO
ALTER TABLE [garbage].[gis_dumping_grounds] ADD  DEFAULT ((0)) FOR [gdg_ward_id]
GO
ALTER TABLE [garbage].[gis_dumping_grounds] ADD  DEFAULT ((0)) FOR [gdg_zone_id]
GO
ALTER TABLE [garbage].[gis_dumping_grounds] ADD  DEFAULT ((0)) FOR [gdg_created_by]
GO
ALTER TABLE [garbage].[gis_dumping_grounds] ADD  DEFAULT ((0)) FOR [gdg_modified_by]
GO
ALTER TABLE [garbage].[gis_dumping_grounds] ADD  CONSTRAINT [DF_isBinLocDG]  DEFAULT ((0)) FOR [isBinLoc]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((0)) FOR [ggcf_points_count]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  CONSTRAINT [DF_gis_garbage_collection_points_the_radious]  DEFAULT ((0)) FOR [the_radious]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((0)) FOR [ggcf_ward_id]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((0)) FOR [ggcf_zone_id]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((0)) FOR [ggcf_created_by]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((0)) FOR [ggcf_modified_by]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((0)) FOR [ggcf_bin_capacity]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((0)) FOR [ggcf_bin_loc_status]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  CONSTRAINT [DF_gis_garbage_collection_points_ggcf_bin_collection_status]  DEFAULT ((0)) FOR [ggcf_bin_collection_status]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((0)) FOR [ggcf_collected_bins]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((0)) FOR [ggcf_minfrequency]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  DEFAULT ((3)) FOR [bin_Demand_TypeId]
GO
ALTER TABLE [garbage].[gis_garbage_collection_points] ADD  CONSTRAINT [DF_isBinLoc]  DEFAULT ((1)) FOR [isBinLoc]
GO
ALTER TABLE [garbage].[gis_road_area] ADD  DEFAULT ((0)) FOR [gra_points_count]
GO
ALTER TABLE [garbage].[gis_road_area] ADD  DEFAULT ((0)) FOR [isStreetSweeping]
GO
ALTER TABLE [garbage].[route_master] ADD  DEFAULT ((0)) FOR [rm_created_by]
GO
ALTER TABLE [garbage].[route_master] ADD  DEFAULT ((0)) FOR [rm_modified_by]
GO
ALTER TABLE [garbage].[route_master] ADD  DEFAULT ((0)) FOR [rm_ward_id]
GO
ALTER TABLE [garbage].[route_master] ADD  DEFAULT ((0)) FOR [rm_zone_id]
GO
ALTER TABLE [garbage].[route_master] ADD  DEFAULT ((0)) FOR [rm_type]
GO
ALTER TABLE [reporting].[rfid_read_in_each_binLocation] ADD  DEFAULT ((0)) FOR [rreb_bin_loc_id_fk]
GO
ALTER TABLE [reporting].[rfid_read_in_each_binLocation] ADD  DEFAULT ((0)) FOR [rreb_bin_id_fk]
GO
ALTER TABLE [reporting].[rfid_read_in_each_binLocation] ADD  CONSTRAINT [DF_rfid_read_in_each_binLocation_rreb_trip_ongoing_details_id_fk]  DEFAULT ((0)) FOR [rreb_trip_ongoing_details_id_fk]
GO
ALTER TABLE [reporting].[rfid_read_in_each_binLocation] ADD  DEFAULT ((0)) FOR [rreb_lat]
GO
ALTER TABLE [reporting].[rfid_read_in_each_binLocation] ADD  DEFAULT ((0)) FOR [rreb_long]
GO
ALTER TABLE [reporting].[trip_completed_captured_data] ADD  DEFAULT ((0)) FOR [tccd_trip_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_captured_data] ADD  DEFAULT ((0)) FOR [tccd_bin_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_details] ADD  DEFAULT ((0)) FOR [tcd_master_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_details] ADD  DEFAULT ((0)) FOR [tcd_bin_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_details] ADD  DEFAULT ((0)) FOR [tcd_collection_status]
GO
ALTER TABLE [reporting].[trip_completed_details] ADD  DEFAULT ((0)) FOR [tcd_sequence_no]
GO
ALTER TABLE [reporting].[trip_completed_details] ADD  DEFAULT ((0)) FOR [tcd_bins_to_be_collected]
GO
ALTER TABLE [reporting].[trip_completed_details] ADD  DEFAULT ((0)) FOR [tcd_bins_collected]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_vehicle_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_trip_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_route_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_trip_status]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_driver_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_cleaner_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_shift_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_weight_disposed]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_route_type]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  CONSTRAINT [DF_trip_completed_master_tcm_received_weight]  DEFAULT ((0)) FOR [tcm_received_weight]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  DEFAULT ((0)) FOR [tcm_trip_distance]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  CONSTRAINT [DF__trip_comp__tcm_w__5BE2A6F_defaultvalue]  DEFAULT ((0)) FOR [Maitenance]
GO
ALTER TABLE [reporting].[trip_completed_master] ADD  CONSTRAINT [DF__trip_comp__tcm_w__5BE2A6F3_bin_area_default]  DEFAULT ((0)) FOR [singleBinArea_FK]
GO
ALTER TABLE [reporting].[trip_completed_rfid_details] ADD  DEFAULT ((0)) FOR [tcrd_bin_loc_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_rfid_details] ADD  DEFAULT ((0)) FOR [tcrd_bin_id_fk]
GO
ALTER TABLE [reporting].[trip_completed_rfid_details] ADD  DEFAULT ((0)) FOR [tcrd_trip_ongoing_details_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_captured_data] ADD  DEFAULT ((0)) FOR [tocd_trip_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_captured_data] ADD  DEFAULT ((0)) FOR [tocd_bin_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_details] ADD  DEFAULT ((0)) FOR [tod_master_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_details] ADD  DEFAULT ((0)) FOR [tod_bin_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_details] ADD  DEFAULT ((0)) FOR [tod_collection_status]
GO
ALTER TABLE [reporting].[trip_ongoing_details] ADD  DEFAULT ((0)) FOR [tod_sequence_no]
GO
ALTER TABLE [reporting].[trip_ongoing_details] ADD  DEFAULT ((0)) FOR [tod_bins_to_be_collected]
GO
ALTER TABLE [reporting].[trip_ongoing_details] ADD  DEFAULT ((0)) FOR [tod_bins_collected]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_vehicle_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_trip_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_route_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_trip_status]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_driver_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_cleaner_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_shift_id_fk]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_weight_disposed]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_notify_status]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_final_location]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_start_loc_type]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_end_loc_type]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_route_type]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  CONSTRAINT [DF_trip_ongoing_master_tom_received_weight]  DEFAULT ((0)) FOR [tom_received_weight]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_trip_distance]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  DEFAULT ((0)) FOR [tom_is_from_citizen]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  CONSTRAINT [DF__trip_ongo__tom_defaultvalue]  DEFAULT ((0)) FOR [Maitenance]
GO
ALTER TABLE [reporting].[trip_ongoing_master] ADD  CONSTRAINT [[DF__trip_ongo__tom_w__72C60C4A1_bin_area_default]  DEFAULT ((0)) FOR [singleBinArea_FK]
GO
ALTER TABLE [reporting].[trip_weight_details] ADD  DEFAULT ((0)) FOR [twd_trip_id]
GO
ALTER TABLE [reporting].[trip_weight_details] ADD  DEFAULT ((0)) FOR [twd_vehicle_id_fk]
GO
ALTER TABLE [reporting].[trip_weight_details] ADD  DEFAULT ((0)) FOR [twd_dgwdid_fk]
GO
ALTER TABLE [reporting].[trip_weight_details] ADD  DEFAULT ((0)) FOR [twd_ward_id_fk]
GO
ALTER TABLE [reporting].[trip_weight_details] ADD  DEFAULT ((0)) FOR [twd_weight]
GO
ALTER TABLE [reports].[bin_collection_detailed_report] ADD  DEFAULT ((0)) FOR [bcdr_bin_collected_status]
GO
ALTER TABLE [reports].[bin_collection_detailed_report] ADD  DEFAULT ((0)) FOR [bcdr_bin_id]
GO
ALTER TABLE [reports].[bin_collection_detailed_report] ADD  DEFAULT ((0)) FOR [bcdr_bin_location_id]
GO
ALTER TABLE [reports].[bin_collection_detailed_report] ADD  DEFAULT ((0)) FOR [bcdr_zone_id]
GO
ALTER TABLE [reports].[bin_collection_detailed_report] ADD  DEFAULT ((0)) FOR [bcdr_ward_id]
GO
ALTER TABLE [reports].[bin_collection_detailed_report] ADD  DEFAULT ((0)) FOR [bcdr_ulb_id_fk]
GO
ALTER TABLE [reports].[bin_collection_detailed_report] ADD  DEFAULT ((0)) FOR [bcdr_bin_type_id]
GO
ALTER TABLE [reports].[bin_status_report] ADD  DEFAULT ((0)) FOR [bsr_vehicle_id_fk]
GO
ALTER TABLE [reports].[bin_status_report] ADD  DEFAULT ((0)) FOR [bsr_route_id_fk]
GO
ALTER TABLE [reports].[bin_status_report] ADD  DEFAULT ((0)) FOR [bsr_collect_status]
GO
ALTER TABLE [reports].[bin_status_report] ADD  DEFAULT ((0)) FOR [bsr_zone_id]
GO
ALTER TABLE [reports].[bin_status_report] ADD  DEFAULT ((0)) FOR [bsr_ward_id]
GO
ALTER TABLE [reports].[bin_status_report] ADD  DEFAULT ((0)) FOR [bsr_bin_id]
GO
ALTER TABLE [reports].[bin_summary_report] ADD  DEFAULT ((0)) FOR [bsr_vehicle_id_fk]
GO
ALTER TABLE [reports].[bin_summary_report] ADD  DEFAULT ((0)) FOR [bsr_route_id_fk]
GO
ALTER TABLE [reports].[bin_summary_report] ADD  DEFAULT ((0)) FOR [bsr_bin_collected]
GO
ALTER TABLE [reports].[bin_summary_report] ADD  DEFAULT ((0)) FOR [bsr_bin_not_collected]
GO
ALTER TABLE [reports].[bin_summary_report] ADD  DEFAULT ((0)) FOR [bsr_zone_id]
GO
ALTER TABLE [reports].[bin_summary_report] ADD  DEFAULT ((0)) FOR [bsr_ward_id]
GO
ALTER TABLE [reports].[bin_summary_report] ADD  DEFAULT ((0)) FOR [bsr_ulb_id_fk]
GO
ALTER TABLE [reports].[bin_summary_report] ADD  DEFAULT ((0)) FOR [bsr_weight]
GO
ALTER TABLE [reports].[dump_weight_details] ADD  DEFAULT ((0)) FOR [dwd_vehicle_id_fk]
GO
ALTER TABLE [reports].[dump_weight_details] ADD  DEFAULT ((0)) FOR [dwd_dgwdid_fk]
GO
ALTER TABLE [reports].[dump_weight_details] ADD  DEFAULT ((0)) FOR [dwd_weight]
GO
ALTER TABLE [reports].[dump_weight_details] ADD  DEFAULT ((0)) FOR [gross_weight_stable]
GO
ALTER TABLE [reports].[dump_weight_details] ADD  DEFAULT ((0)) FOR [net_weight_stable]
GO
ALTER TABLE [reports].[halt_report] ADD  DEFAULT ((0)) FOR [hr_ulb_id]
GO
ALTER TABLE [reports].[halt_report] ADD  DEFAULT ((0)) FOR [hr_is_in]
GO
ALTER TABLE [reports].[halt_report] ADD  DEFAULT ((0)) FOR [hr_is_bin]
GO
ALTER TABLE [reports].[halt_report] ADD  DEFAULT ((0)) FOR [hr_status]
GO
ALTER TABLE [reports].[report_configuration] ADD  DEFAULT ((0)) FOR [rc_report_id]
GO
ALTER TABLE [reports].[report_configuration] ADD  DEFAULT ((0)) FOR [rc_email_status]
GO
ALTER TABLE [reports].[report_configuration] ADD  DEFAULT ((0)) FOR [rc_ulb_id_fk]
GO
ALTER TABLE [reports].[report_configuration] ADD  DEFAULT ((0)) FOR [rc_sub_report_id]
GO
ALTER TABLE [reports].[report_configuration] ADD  DEFAULT ((0)) FOR [rc_created_by]
GO
ALTER TABLE [reports].[report_configuration] ADD  DEFAULT ((0)) FOR [rc_modified_by]
GO
ALTER TABLE [reports].[report_distance] ADD  DEFAULT ((0)) FOR [rd_vehicle_id]
GO
ALTER TABLE [reports].[report_distance] ADD  DEFAULT ((0)) FOR [rd_distance]
GO
ALTER TABLE [reports].[report_distance] ADD  DEFAULT ((0)) FOR [rd_ulb_id_fk]
GO
ALTER TABLE [reports].[report_weight] ADD  DEFAULT ((0)) FOR [rw_ulb_id_fk]
GO
ALTER TABLE [reports].[report_weight] ADD  DEFAULT ((0)) FOR [rw_vehicle_id_fk]
GO
ALTER TABLE [reports].[report_weight] ADD  DEFAULT ((0)) FOR [rw_trip_id_fk]
GO
ALTER TABLE [reports].[report_weight] ADD  DEFAULT ((0)) FOR [rw_shift_type_id]
GO
ALTER TABLE [reports].[report_weight] ADD  DEFAULT ((0)) FOR [rw_weight]
GO
ALTER TABLE [reports].[report_weight] ADD  DEFAULT ((0)) FOR [rw_route_id]
GO
ALTER TABLE [reports].[report_weight] ADD  DEFAULT ((0)) FOR [rw_ward_id]
GO
ALTER TABLE [reports].[report_weight] ADD  DEFAULT ((0)) FOR [rw_zone_id]
GO
ALTER TABLE [reports].[route_deviation_report] ADD  DEFAULT ((0)) FOR [rdr_vehicle_id_fk]
GO
ALTER TABLE [reports].[route_deviation_report] ADD  DEFAULT ((0)) FOR [rdr_route_id_fk]
GO
ALTER TABLE [reports].[route_deviation_report] ADD  DEFAULT ((0)) FOR [rdr_shift_id]
GO
ALTER TABLE [reports].[route_deviation_report] ADD  DEFAULT ((0)) FOR [rdr_zone_id]
GO
ALTER TABLE [reports].[route_deviation_report] ADD  DEFAULT ((0)) FOR [rdr_ward_id]
GO
ALTER TABLE [reports].[route_deviation_report] ADD  DEFAULT ((0)) FOR [rdr_trip_id]
GO
ALTER TABLE [reports].[staff_attendance_report] ADD  CONSTRAINT [DF__staff_att__sar_s__36B12243]  DEFAULT ((0)) FOR [sar_staff_id_fk]
GO
ALTER TABLE [reports].[staff_attendance_report] ADD  CONSTRAINT [DF__staff_att__sar_u__37A5467C]  DEFAULT ((0)) FOR [sar_ulb_id_fk]
GO
ALTER TABLE [reports].[staff_attendance_report] ADD  CONSTRAINT [DF__staff_att__sar_s__38996AB5]  DEFAULT ((0)) FOR [sar_staff_type_id]
GO
ALTER TABLE [reports].[staff_attendance_report] ADD  DEFAULT ((0)) FOR [sar_shift_id]
GO
ALTER TABLE [reports].[staff_attendance_report] ADD  DEFAULT ((0)) FOR [sar_shift_end_time_status]
GO
ALTER TABLE [reports].[staff_attendance_report] ADD  DEFAULT ((0)) FOR [sar_shift_start_time_status]
GO
ALTER TABLE [reports].[staff_attendance_report] ADD  DEFAULT ((0)) FOR [sar_supervisor_id_fk]
GO
ALTER TABLE [reports].[staff_report_images] ADD  DEFAULT ((0)) FOR [sri_employee_id]
GO
ALTER TABLE [reports].[vehicle_maintenance_history_report] ADD  DEFAULT ((0)) FOR [vmhr_vehicle_id_fk]
GO
ALTER TABLE [reports].[vehicle_maintenance_history_report] ADD  DEFAULT ((0)) FOR [vmhr_maintenance_type]
GO
ALTER TABLE [reports].[vehicle_maintenance_history_report] ADD  CONSTRAINT [DF_vehicle_maintenance_history_report_vmr_ulb_id_fk]  DEFAULT ((0)) FOR [vmhr_ulb_id_fk]
GO
ALTER TABLE [reports].[vehicle_maintenance_report] ADD  DEFAULT ((0)) FOR [vmr_vehicle_id_fk]
GO
ALTER TABLE [reports].[vehicle_maintenance_report] ADD  DEFAULT ((0)) FOR [vmr_maintenance_type]
GO
ALTER TABLE [reports].[vehicle_maintenance_report] ADD  DEFAULT ((0)) FOR [vmr_status]
GO
ALTER TABLE [reports].[vehicle_maintenance_report] ADD  DEFAULT ((0)) FOR [vmr_ulb_id_fk]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_vheicle_id_fk]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_status]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_schedule_type]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_bin_location_id]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_bin_id]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_dumping_ground]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_trip_id]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_basic_id]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_trip_status]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [dtm_workforce_notify_status]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [is_new_trip]
GO
ALTER TABLE [scheduling].[dispatch_trip_master] ADD  DEFAULT ((0)) FOR [isCitizen]
GO
ALTER TABLE [scheduling].[schedule_repeat_status] ADD  DEFAULT ((0)) FOR [srs_module_status]
GO
ALTER TABLE [scheduling].[schedule_trip_details] ADD  DEFAULT ((0)) FOR [std_stm_id_fk]
GO
ALTER TABLE [scheduling].[schedule_trip_details] ADD  DEFAULT ((0)) FOR [std_bin_id_fk]
GO
ALTER TABLE [scheduling].[schedule_trip_details] ADD  DEFAULT ((0)) FOR [std_sequence_no]
GO
ALTER TABLE [scheduling].[schedule_trip_details] ADD  DEFAULT ((0)) FOR [std_bins_to_be_collected]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_vehicle_category_id_fk]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_vheicle_id_fk]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_shift_id_fk]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_driver_id_fk]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_cleaner_id_fk]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_status]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_schedule_type]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_start_location]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_end_location]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_route_id_fk]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_final_location]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_start_loc_type]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_end_loc_type]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_rqst_id]
GO
ALTER TABLE [scheduling].[schedule_trip_master] ADD  DEFAULT ((0)) FOR [stm_alert_notify]
GO
ALTER TABLE [scheduling].[schedule_trip_repeatedly] ADD  DEFAULT ((0)) FOR [str_stm_id_fk]
GO
ALTER TABLE [scheduling].[schedule_trip_repeatedly] ADD  DEFAULT ((0)) FOR [str_repeat_status]
GO
ALTER TABLE [scheduling].[schedule_trip_repeatedly] ADD  DEFAULT ((0)) FOR [str_shift_id_fk]
GO
ALTER TABLE [staff_attendance].[online_staff_master] ADD  DEFAULT ((0)) FOR [osm_status]
GO
ALTER TABLE [staff_attendance].[online_staff_master] ADD  DEFAULT ((0)) FOR [cssm_ulb_id_fk]
GO
ALTER TABLE [staff_attendance].[online_staff_master] ADD  DEFAULT ((0)) FOR [osm_latitude]
GO
ALTER TABLE [staff_attendance].[online_staff_master] ADD  DEFAULT ((0)) FOR [osm_longitude]
GO
ALTER TABLE [staff_attendance].[online_staff_master] ADD  DEFAULT (NULL) FOR [osm_shift_type_id_fk]
GO
ALTER TABLE [dbo].[alert_log]  WITH CHECK ADD  CONSTRAINT [Ck_al_month1] CHECK  (([al_month]=(1)))
GO
ALTER TABLE [dbo].[alert_log] CHECK CONSTRAINT [Ck_al_month1]
GO
