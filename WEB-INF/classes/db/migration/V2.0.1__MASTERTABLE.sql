/****** Object:  Table [admin].[BinCollectionStatusType]    Script Date: 10/19/2020 4:05:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[BinCollectionStatusType](
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusType] [varchar](100) NULL,
	[StatusTypeCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[BinDemandType]    Script Date: 10/19/2020 4:05:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[BinDemandType](
	[bdt_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[bdt_type] [varchar](100) NULL,
 CONSTRAINT [BinDemandType_pkey] PRIMARY KEY CLUSTERED 
(
	[bdt_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_admin_menu]    Script Date: 10/19/2020 4:05:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_admin_menu](
	[cam_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cam_menu_name] [nvarchar](100) NULL,
 CONSTRAINT [config_admin_menu_pkey] PRIMARY KEY CLUSTERED 
(
	[cam_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_alert_sub_type]    Script Date: 10/19/2020 4:05:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_alert_sub_type](
	[cast_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cast_type] [nvarchar](100) NULL,
 CONSTRAINT [config_alert_sub_type_pkey] PRIMARY KEY CLUSTERED 
(
	[cast_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_alert_type]    Script Date: 10/19/2020 4:05:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_alert_type](
	[cat_id_pk] [int] NULL,
	[cat_type] [varchar](50) NULL,
	[cat_email_status] [int] NULL,
	[cat_sms_status] [int] NULL,
	[cat_nearest_workforce] [int] NULL,
	[cat_nearest_distance] [varchar](30) NULL,
	[cat_typeCode] [varchar](25) NULL,
	[cat_categoryId] [int] NULL,
	[cat_categoryCode] [varchar](25) NULL,
	[cat_tenantCode] [varchar](25) NULL,
	[cat_priorityId] [int] NULL,
	[cat_isDisaster] [bit] NULL,
	[cat_companyId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_bin_category_type]    Script Date: 10/19/2020 4:05:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_bin_category_type](
	[cbct_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cbct_type] [varchar](50) NULL,
	[cbct_type_code] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_bin_type]    Script Date: 10/19/2020 4:05:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_bin_type](
	[cbt_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cbt_type] [varchar](100) NULL,
	[cbt_type_Code] [varchar](50) NULL,
 CONSTRAINT [config_bin_type_pkey] PRIMARY KEY CLUSTERED 
(
	[cbt_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_dashboard_menu]    Script Date: 10/19/2020 4:05:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_dashboard_menu](
	[cdm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cdm_menu_name] [nvarchar](100) NULL,
 CONSTRAINT [config_dashboard_master_pkey] PRIMARY KEY CLUSTERED 
(
	[cdm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_fence_type]    Script Date: 10/19/2020 4:05:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_fence_type](
	[cft_id] [int] IDENTITY(1,1) NOT NULL,
	[cft_type] [varchar](100) NULL,
	[cft_type_code] [varchar](50) NULL,
 CONSTRAINT [config_fence_type_pkey] PRIMARY KEY CLUSTERED 
(
	[cft_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_fleet_category]    Script Date: 10/19/2020 4:05:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_fleet_category](
	[cfc_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cfc_type] [varchar](100) NULL,
	[cfc_ulb_id_fk] [int] NULL,
	[cfc_mileage] [float] NULL,
	[bin_type_id] [int] NULL,
	[cfc_type_code] [varchar](50) NULL,
	[cfc_iottype_id] [int] NULL,
 CONSTRAINT [config_fleet_category_pkey] PRIMARY KEY CLUSTERED 
(
	[cfc_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_garbage_collection_menu]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_garbage_collection_menu](
	[cgcm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cgcm_menu_name] [nvarchar](100) NULL,
 CONSTRAINT [config_garbage_collection_menu_pkey] PRIMARY KEY CLUSTERED 
(
	[cgcm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_Integration_type]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_Integration_type](
	[Inte_id_pk] [int] NULL,
	[Inte_name] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_menu_master]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_menu_master](
	[cmm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cmm_menu_name] [nvarchar](100) NULL,
 CONSTRAINT [config_menu_master_pkey] PRIMARY KEY CLUSTERED 
(
	[cmm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_report_menu]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_report_menu](
	[crm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[crm_menu_name] [nvarchar](100) NULL,
	[crm_ulb_id_fk] [int] NULL,
 CONSTRAINT [config_report_menu_pkey] PRIMARY KEY CLUSTERED 
(
	[crm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_shift_master]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_shift_master](
	[csm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[csm_shift_name] [nvarchar](256) NULL,
	[csm_shift_start_time] [time](7) NULL,
	[csm_shift_end_time] [time](7) NULL,
	[csm_ulb_id_fk] [int] NULL,
 CONSTRAINT [config_shift_master_pkey] PRIMARY KEY CLUSTERED 
(
	[csm_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_staff_category]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_staff_category](
	[csc_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[csc_type] [nvarchar](100) NULL,
 CONSTRAINT [config_staff_category_pkey] PRIMARY KEY CLUSTERED 
(
	[csc_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_staff_type]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_staff_type](
	[cst_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cst_type] [nvarchar](100) NULL,
	[cst_ulb_id_fk] [int] NULL,
 CONSTRAINT [config_staff_type_pkey] PRIMARY KEY CLUSTERED 
(
	[cst_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[config_user_type]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[config_user_type](
	[cut_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cut_type] [nvarchar](250) NULL,
	[cut_status] [int] NULL,
 CONSTRAINT [config_user_type_pkey] PRIMARY KEY CLUSTERED 
(
	[cut_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[device_Type]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[device_Type](
	[dt_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[dt_name] [varchar](100) NULL,
	[dt_type_Id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[dt_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[DeviceAssignedType]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[DeviceAssignedType](
	[DeviceAssignedId] [int] NULL,
	[DeviceAssignedName] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[externalConfigUrl]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[externalConfigUrl](
	[Department_Name] [varchar](255) NULL,
	[Webservice] [varchar](700) NULL,
	[UI] [varchar](700) NULL,
	[Username] [varchar](300) NULL,
	[Password] [varchar](300) NULL,
	[kafka_Url] [varchar](700) NULL,
	[group_Id] [varchar](500) NULL,
	[bin_sensor_topic] [varchar](700) NULL,
	[gateway_topic] [varchar](700) NULL,
	[RFID_topic] [varchar](700) NULL,
	[weight_bridge_topic] [varchar](700) NULL,
	[webSocket] [varchar](700) NULL,
	[ICCC_url] [varchar](700) NULL,
	[API_key] [varchar](700) NULL,
	[tenant_Code_Url] [varchar](500) NULL,
	[wso2_Url] [varchar](500) NULL,
	[applicationHealth_url] [varchar](500) NULL,
	[historyData_url] [varchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [admin].[vehicle_maintenance_type_master]    Script Date: 10/19/2020 4:05:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[vehicle_maintenance_type_master](
	[vmtm_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[vmtm_maintenance_type] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [citizen].[citizen_complaints_type]    Script Date: 10/19/2020 4:05:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [citizen].[citizen_complaints_type](
	[cct_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[cct_type] [nvarchar](256) NULL,
	[typeCode] [varchar](50) NULL,
	[tenantCode] [varchar](50) NULL,
 CONSTRAINT [citizen_complaints_type_pkey] PRIMARY KEY CLUSTERED 
(
	[cct_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [citizen].[priority_type]    Script Date: 10/19/2020 4:05:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [citizen].[priority_type](
	[pt_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[pt_priority] [varchar](256) NULL,
 CONSTRAINT [priority_type_pkey] PRIMARY KEY CLUSTERED 
(
	[pt_id_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HoursDay]    Script Date: 10/19/2020 4:05:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoursDay](
	[h] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [garbage].[poi_type_details]    Script Date: 10/19/2020 4:05:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [garbage].[poi_type_details](
	[ptd_id_pk] [int] IDENTITY(1,1) NOT NULL,
	[ptd_poi_type] [varchar](256) NULL,
	[ptd_poi_access] [bit] NULL,
	[ptd_fence_access] [bit] NULL,
	[ptd_client_poi_status] [int] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [admin].[BinCollectionStatusType] ON 
GO
INSERT [admin].[BinCollectionStatusType] ([StatusId], [StatusType], [StatusTypeCode]) VALUES (1, N'Only RFID (NR)', 0)
GO
INSERT [admin].[BinCollectionStatusType] ([StatusId], [StatusType], [StatusTypeCode]) VALUES (2, N'RFID With Status (M)', 1)
GO
INSERT [admin].[BinCollectionStatusType] ([StatusId], [StatusType], [StatusTypeCode]) VALUES (3, N'RFID With  Status (NM)', 2)
GO
INSERT [admin].[BinCollectionStatusType] ([StatusId], [StatusType], [StatusTypeCode]) VALUES (4, N'Only QR Code (NR)', 0)
GO
INSERT [admin].[BinCollectionStatusType] ([StatusId], [StatusType], [StatusTypeCode]) VALUES (5, N'QR Code With Status (M)', 1)
GO
INSERT [admin].[BinCollectionStatusType] ([StatusId], [StatusType], [StatusTypeCode]) VALUES (6, N'QR Code With Status (NM)', 2)
GO
INSERT [admin].[BinCollectionStatusType] ([StatusId], [StatusType], [StatusTypeCode]) VALUES (7, N'Only Status (M)', 1)
GO
SET IDENTITY_INSERT [admin].[BinCollectionStatusType] OFF
GO
SET IDENTITY_INSERT [admin].[BinDemandType] ON 
GO
INSERT [admin].[BinDemandType] ([bdt_id_pk], [bdt_type]) VALUES (1, N'High')
GO
INSERT [admin].[BinDemandType] ([bdt_id_pk], [bdt_type]) VALUES (2, N'Medium')
GO
INSERT [admin].[BinDemandType] ([bdt_id_pk], [bdt_type]) VALUES (3, N'Low')
GO
SET IDENTITY_INSERT [admin].[BinDemandType] OFF
GO
SET IDENTITY_INSERT [admin].[config_admin_menu] ON 
GO
INSERT [admin].[config_admin_menu] ([cam_id_pk], [cam_menu_name]) VALUES (1, N'Roster')
GO
INSERT [admin].[config_admin_menu] ([cam_id_pk], [cam_menu_name]) VALUES (2, N'User Profile')
GO
INSERT [admin].[config_admin_menu] ([cam_id_pk], [cam_menu_name]) VALUES (3, N'Alert Configure')
GO
INSERT [admin].[config_admin_menu] ([cam_id_pk], [cam_menu_name]) VALUES (4, N'Billing')
GO
SET IDENTITY_INSERT [admin].[config_admin_menu] OFF
GO
SET IDENTITY_INSERT [admin].[config_alert_sub_type] ON 
GO
INSERT [admin].[config_alert_sub_type] ([cast_id_pk], [cast_type]) VALUES (1, N'Incoming')
GO
INSERT [admin].[config_alert_sub_type] ([cast_id_pk], [cast_type]) VALUES (2, N'Outgoing')
GO
INSERT [admin].[config_alert_sub_type] ([cast_id_pk], [cast_type]) VALUES (3, N'Both')
GO
SET IDENTITY_INSERT [admin].[config_alert_sub_type] OFF
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (1, N'Speed Alert', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (2, N'Disconnected Alert', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (3, N'Bin Fill Alert', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (4, N'Bin Skipped Alert', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (5, N'Route Deviation Alert', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (6, N'Halt Alert', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (7, N'Geo-Fence Alert', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (8, N'Start Point Violation', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (9, N'End Point Violation', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (12, N'Connected Alert Alert', 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[config_alert_type] ([cat_id_pk], [cat_type], [cat_email_status], [cat_sms_status], [cat_nearest_workforce], [cat_nearest_distance], [cat_typeCode], [cat_categoryId], [cat_categoryCode], [cat_tenantCode], [cat_priorityId], [cat_isDisaster], [cat_companyId]) VALUES (13, N'Tampering Alert', 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [admin].[config_bin_category_type] ON 
GO
INSERT [admin].[config_bin_category_type] ([cbct_id_pk], [cbct_type], [cbct_type_code]) VALUES (1, N'Dry Waste', N'DW')
GO
INSERT [admin].[config_bin_category_type] ([cbct_id_pk], [cbct_type], [cbct_type_code]) VALUES (2, N'Wet Waste', N'WW')
GO
INSERT [admin].[config_bin_category_type] ([cbct_id_pk], [cbct_type], [cbct_type_code]) VALUES (3, N'OTHERS', N'OT')
GO
SET IDENTITY_INSERT [admin].[config_bin_category_type] OFF
GO
SET IDENTITY_INSERT [admin].[config_bin_type] ON 
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (1, N'UNDER GROUND BINS', N'UGB')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2, N'DUMPSTER/ FRONT LIFT BINS', N'DFLB')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (3, N'COMPACTOR BINS', N'CBIN')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (1009, N'Bin11', N'AB1091')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (1010, N'Bin12', N'AB1092')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (1011, N'Bin13', N'AB1093')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (1012, N'Bin14', N'AB1094')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (1015, N'DemoBin1', N'DMB1')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (1016, N'DemoBin3', N'DMB3')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2008, N'ESB BinTest1Updated', N'ESB testing1')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2009, N'TEST Binesb 123', N'TET esb12')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2010, N'TEST Binesb 1234', N'TET esb124')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2011, N'UpdatedTEST Binesb 1234', N'TET esb1241')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2012, N'UpdatedTEST Binesb 1232', N'TET esb1242')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2013, N'ESB BinTest1Updated123', N'ESB test12')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2015, N'UpdateTEST Binesb 1235', N'TET esb125')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2016, N'Update TEST Bin12', N'Esb TestTET')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2017, N'TEST Bin', N'TET')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2020, N'demotype1121', N'demotypecode11231')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2021, N'TEST Bin24Update', N'TET24')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (2022, N'TEST Bin24A', N'TET24A')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (3021, N'q1', N'qwe')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (3023, N'SWM Bin Type', N'SWMBIN13072019130117')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (3025, N'UNDER GROUND', N'UG')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (3026, N'DUMPSTER', N'DU')
GO
INSERT [admin].[config_bin_type] ([cbt_id_pk], [cbt_type], [cbt_type_Code]) VALUES (4026, N'COMPACTOR', N'CO')
GO
SET IDENTITY_INSERT [admin].[config_bin_type] OFF
GO
SET IDENTITY_INSERT [admin].[config_fence_type] ON 
GO
INSERT [admin].[config_fence_type] ([cft_id], [cft_type], [cft_type_code]) VALUES (1, N'Dumping-Yard', N'DUY')
GO
INSERT [admin].[config_fence_type] ([cft_id], [cft_type], [cft_type_code]) VALUES (2, N'Transfer-Station', N'TRS')
GO
SET IDENTITY_INSERT [admin].[config_fence_type] OFF
GO
SET IDENTITY_INSERT [admin].[config_fleet_category] ON 
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3099, N'LOADER', 21210, 0, NULL, N'LDR', 1)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3100, N'COMPACTOR', 21210, 2.75, NULL, N'CPTR', 2)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3101, N'ETHANOL BU', 21210, 0, NULL, N'ETNB', 19061)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3102, N'STANDARD B', 21210, 0, NULL, N'STDB', 28082)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3118, N'MINI TRUCK', 21210, 0, NULL, N'MINI', 10)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3124, N'PUSH CART / TRICYCLE', 21210, 0, NULL, N'PSHCRT', 9)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3211, N'HOYSALA', 21210, 0, NULL, N'HYL', 30082)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3212, N'TRACTORS', 21210, 3, NULL, N'TRAC', 30090)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3213, N'TATA ACE', 24371, 12, NULL, N'TAEC', 27)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3214, N'AMBULANCE', 24371, 3, NULL, N'ABNC', 15)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3215, N'CATTLE VAN', 24371, 6, NULL, N'CV', 16)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3216, N'NEW TATA ACE', 24371, 0, NULL, N'NTAACE', 23)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3217, N'DUMPER TRUCK', 24371, 5, NULL, N'DT', 17)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3218, N'HOOK LOADER', 24371, 4, NULL, N'HL', 18)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3219, N'HYVA', 24371, 4, NULL, N'HVA', 12)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3220, N'JCB R S', 24371, 0, NULL, N'JCBRS', 20)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3221, N'TOWER LOADER', 24371, 3.5, NULL, N'TLR', 28)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3222, N'NALA MAN', 24371, 3, NULL, N'NMN', 22)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3223, N'CESSPOOL', 24371, 0, NULL, N'CSOOL', 13)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3224, N'POKELAND', 24371, 14, NULL, N'PLD', 24)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3225, N'ROAD SWIPPER', 24371, 10, NULL, N'RSR', 25)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3226, N'ROBOT R S', 24371, 5, NULL, N'RRS', 26)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3227, N'TRACTOR', 24371, 3, NULL, N'TCOR', 9)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3228, N'MINI TIPPER', 24371, 12, NULL, N'MTR', 21)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3229, N'JCB', 24371, 7, NULL, N'JCB', 19)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3230, N'DUMPER PLACER', 24371, 0, NULL, N'DP', 10)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3231, N'FORCE SAV', 24371, 0, NULL, N'FRS', 29)
GO
INSERT [admin].[config_fleet_category] ([cfc_id_pk], [cfc_type], [cfc_ulb_id_fk], [cfc_mileage], [bin_type_id], [cfc_type_code], [cfc_iottype_id]) VALUES (3232, N'SAV VAHAN', 24371, 0, NULL, N'SAV', 30)
GO
SET IDENTITY_INSERT [admin].[config_fleet_category] OFF
GO
SET IDENTITY_INSERT [admin].[config_garbage_collection_menu] ON 
GO
INSERT [admin].[config_garbage_collection_menu] ([cgcm_id_pk], [cgcm_menu_name]) VALUES (1, N'Scheduling')
GO
INSERT [admin].[config_garbage_collection_menu] ([cgcm_id_pk], [cgcm_menu_name]) VALUES (2, N'Reporting')
GO
SET IDENTITY_INSERT [admin].[config_garbage_collection_menu] OFF
GO
INSERT [admin].[config_Integration_type] ([Inte_id_pk], [Inte_name]) VALUES (1, N'ICCC')
GO
INSERT [admin].[config_Integration_type] ([Inte_id_pk], [Inte_name]) VALUES (2, N'Chatbot')
GO
INSERT [admin].[config_Integration_type] ([Inte_id_pk], [Inte_name]) VALUES (3, N'OpenDataPortal')
GO
INSERT [admin].[config_Integration_type] ([Inte_id_pk], [Inte_name]) VALUES (4, N'WorkForceUser')
GO
INSERT [admin].[config_Integration_type] ([Inte_id_pk], [Inte_name]) VALUES (5, N'IotOps')
GO
SET IDENTITY_INSERT [admin].[config_menu_master] ON 
GO
INSERT [admin].[config_menu_master] ([cmm_id_pk], [cmm_menu_name]) VALUES (1, N'Dashboard')
GO
INSERT [admin].[config_menu_master] ([cmm_id_pk], [cmm_menu_name]) VALUES (2, N'MAP')
GO
INSERT [admin].[config_menu_master] ([cmm_id_pk], [cmm_menu_name]) VALUES (3, N'Garbage Collection')
GO
INSERT [admin].[config_menu_master] ([cmm_id_pk], [cmm_menu_name]) VALUES (4, N'Citizen Greviance')
GO
INSERT [admin].[config_menu_master] ([cmm_id_pk], [cmm_menu_name]) VALUES (5, N'Report')
GO
INSERT [admin].[config_menu_master] ([cmm_id_pk], [cmm_menu_name]) VALUES (7, N'Admin')
GO
INSERT [admin].[config_menu_master] ([cmm_id_pk], [cmm_menu_name]) VALUES (8, N'Alert Management')
GO
INSERT [admin].[config_menu_master] ([cmm_id_pk], [cmm_menu_name]) VALUES (10, N'Staff Attendence')
GO
SET IDENTITY_INSERT [admin].[config_menu_master] OFF
GO
SET IDENTITY_INSERT [admin].[config_shift_master] ON 
GO
INSERT [admin].[config_shift_master] ([csm_id_pk], [csm_shift_name], [csm_shift_start_time], [csm_shift_end_time], [csm_ulb_id_fk]) VALUES (1, N'General Shift', CAST(N'06:00:00' AS Time), CAST(N'21:00:00' AS Time), 0)
GO
INSERT [admin].[config_shift_master] ([csm_id_pk], [csm_shift_name], [csm_shift_start_time], [csm_shift_end_time], [csm_ulb_id_fk]) VALUES (2, N'Night Shift', CAST(N'21:00:00' AS Time), CAST(N'05:00:00' AS Time), 0)
GO
SET IDENTITY_INSERT [admin].[config_shift_master] OFF
GO
SET IDENTITY_INSERT [admin].[config_staff_category] ON 
GO
INSERT [admin].[config_staff_category] ([csc_id_pk], [csc_type]) VALUES (1, N'Permanent')
GO
INSERT [admin].[config_staff_category] ([csc_id_pk], [csc_type]) VALUES (2, N'Outsourcing Day')
GO
INSERT [admin].[config_staff_category] ([csc_id_pk], [csc_type]) VALUES (3, N'Outsourcing Night')
GO
SET IDENTITY_INSERT [admin].[config_staff_category] OFF
GO
SET IDENTITY_INSERT [admin].[config_staff_type] ON 
GO
INSERT [admin].[config_staff_type] ([cst_id_pk], [cst_type], [cst_ulb_id_fk]) VALUES (1, N'Driver', 1)
GO
INSERT [admin].[config_staff_type] ([cst_id_pk], [cst_type], [cst_ulb_id_fk]) VALUES (2, N'Cleaner', 1)
GO
INSERT [admin].[config_staff_type] ([cst_id_pk], [cst_type], [cst_ulb_id_fk]) VALUES (4, N'Sanitation Staff', 1)
GO
INSERT [admin].[config_staff_type] ([cst_id_pk], [cst_type], [cst_ulb_id_fk]) VALUES (5, N'Supervisor', 1)
GO
SET IDENTITY_INSERT [admin].[config_staff_type] OFF
GO
SET IDENTITY_INSERT [admin].[config_user_type] ON 
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (1, N'Super Admin', 1)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (2, N'Admin', 1)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (3, N'Operator', 1)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (4, N'Ward', 2)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (5, N'Zone', 2)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (6, N'Division', 2)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (7, N'HelpDesk', 2)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (8, N'Officer', 3)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (9, N'Supervisor', 3)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (10, N'Driver', 3)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (11, N'Cleaner', 3)
GO
INSERT [admin].[config_user_type] ([cut_id_pk], [cut_type], [cut_status]) VALUES (12, N'Sanitation Staff', 3)
GO
SET IDENTITY_INSERT [admin].[config_user_type] OFF
GO
SET IDENTITY_INSERT [admin].[device_Type] ON 
GO
INSERT [admin].[device_Type] ([dt_id_pk], [dt_name], [dt_type_Id]) VALUES (1, N'Vehicle Gateway', 1)
GO
INSERT [admin].[device_Type] ([dt_id_pk], [dt_name], [dt_type_Id]) VALUES (2, N'Bin Sensor', 2)
GO
SET IDENTITY_INSERT [admin].[device_Type] OFF
GO
INSERT [admin].[DeviceAssignedType] ([DeviceAssignedId], [DeviceAssignedName]) VALUES (1, N'Fleet')
GO
INSERT [admin].[externalConfigUrl] ([Department_Name], [Webservice], [UI], [Username], [Password], [kafka_Url], [group_Id], [bin_sensor_topic], [gateway_topic], [RFID_topic], [weight_bridge_topic], [webSocket], [ICCC_url], [API_key], [tenant_Code_Url], [wso2_Url], [applicationHealth_url], [historyData_url]) VALUES (N'workForceURL', N'http://10.120.4.75:8283/t/amc.com/workforce/1.0.0/', N'http://10.120.4.75:9093/workforceManagement/', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[externalConfigUrl] ([Department_Name], [Webservice], [UI], [Username], [Password], [kafka_Url], [group_Id], [bin_sensor_topic], [gateway_topic], [RFID_topic], [weight_bridge_topic], [webSocket], [ICCC_url], [API_key], [tenant_Code_Url], [wso2_Url], [applicationHealth_url], [historyData_url]) VALUES (N'iotopsURL', N'2', N'--', NULL, NULL, N'10.120.4.75:9092', N'nificonsumer_stream05', N'bin sensor', N'gateway topic', N'trinity_demo_rfid', N'weighbridge_topic', NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[externalConfigUrl] ([Department_Name], [Webservice], [UI], [Username], [Password], [kafka_Url], [group_Id], [bin_sensor_topic], [gateway_topic], [RFID_topic], [weight_bridge_topic], [webSocket], [ICCC_url], [API_key], [tenant_Code_Url], [wso2_Url], [applicationHealth_url], [historyData_url]) VALUES (N'apiManUrl', N'http://192.168.1.136:8002/TrinityRestApi/rest/wso2services/getAccessToken', N'--', N'swm@amc.com', N'123456', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'http://40.81.72.252:8282/t/demo.com/IcccIntegration/1.0/', N'V2cwM181bDFyTmpQclpONnV6WU1FVEhjZ0hjYTpoRU9CRUZ3bWlqTzRJZFA4a0pBcGV0WmVjenNh', N'http://10.120.4.75:8283/t/amc.com/iotOperations/1.0.0/', N'http://10.120.4.75:8283/t/amc.com/trinityPlatform/1.0.0/', N'http://192.168.1.136:8283/t/platform.com/applicationHealth/1.0.0/', N'http://10.120.4.75:8283/t/amc.com/historyData/1.0.0/')
GO
INSERT [admin].[externalConfigUrl] ([Department_Name], [Webservice], [UI], [Username], [Password], [kafka_Url], [group_Id], [bin_sensor_topic], [gateway_topic], [RFID_topic], [weight_bridge_topic], [webSocket], [ICCC_url], [API_key], [tenant_Code_Url], [wso2_Url], [applicationHealth_url], [historyData_url]) VALUES (N'SWMapplication', N'4', N'--', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'http://10.120.4.76:9080/trinitySWM/', NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[externalConfigUrl] ([Department_Name], [Webservice], [UI], [Username], [Password], [kafka_Url], [group_Id], [bin_sensor_topic], [gateway_topic], [RFID_topic], [weight_bridge_topic], [webSocket], [ICCC_url], [API_key], [tenant_Code_Url], [wso2_Url], [applicationHealth_url], [historyData_url]) VALUES (N'config_Reports', N'https://swm.prayagrajsmartcity.org/knowage/servlet/AdapterHTTP?PAGE=LoginPage&NEW_SESSION=TRUE&Username=biadmin&Password=123456', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[externalConfigUrl] ([Department_Name], [Webservice], [UI], [Username], [Password], [kafka_Url], [group_Id], [bin_sensor_topic], [gateway_topic], [RFID_topic], [weight_bridge_topic], [webSocket], [ICCC_url], [API_key], [tenant_Code_Url], [wso2_Url], [applicationHealth_url], [historyData_url]) VALUES (N'sso_Users', N'SSO_URL1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[externalConfigUrl] ([Department_Name], [Webservice], [UI], [Username], [Password], [kafka_Url], [group_Id], [bin_sensor_topic], [gateway_topic], [RFID_topic], [weight_bridge_topic], [webSocket], [ICCC_url], [API_key], [tenant_Code_Url], [wso2_Url], [applicationHealth_url], [historyData_url]) VALUES (N'GisConfig', N'http://10.120.4.75:8283/t/amc.com/trinityGIS/1.0.0/', N'http://10.120.4.75:8283/t/amc.com/GIS/1.0.0/', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [admin].[externalConfigUrl] ([Department_Name], [Webservice], [UI], [Username], [Password], [kafka_Url], [group_Id], [bin_sensor_topic], [gateway_topic], [RFID_topic], [weight_bridge_topic], [webSocket], [ICCC_url], [API_key], [tenant_Code_Url], [wso2_Url], [applicationHealth_url], [historyData_url]) VALUES (N'hbaseUrl', N'511', N'--', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [admin].[vehicle_maintenance_type_master] ON 
GO
INSERT [admin].[vehicle_maintenance_type_master] ([vmtm_id_pk], [vmtm_maintenance_type]) VALUES (1, N'Accident')
GO
INSERT [admin].[vehicle_maintenance_type_master] ([vmtm_id_pk], [vmtm_maintenance_type]) VALUES (2, N'Damaged Wheels')
GO
INSERT [admin].[vehicle_maintenance_type_master] ([vmtm_id_pk], [vmtm_maintenance_type]) VALUES (3, N'Dead on key')
GO
INSERT [admin].[vehicle_maintenance_type_master] ([vmtm_id_pk], [vmtm_maintenance_type]) VALUES (4, N'Engine turning over, not firing')
GO
INSERT [admin].[vehicle_maintenance_type_master] ([vmtm_id_pk], [vmtm_maintenance_type]) VALUES (5, N'Overheating')
GO
INSERT [admin].[vehicle_maintenance_type_master] ([vmtm_id_pk], [vmtm_maintenance_type]) VALUES (6, N'Vehicle Breakdown')
GO
INSERT [admin].[vehicle_maintenance_type_master] ([vmtm_id_pk], [vmtm_maintenance_type]) VALUES (7, N'Vehicle Service')
GO
INSERT [admin].[vehicle_maintenance_type_master] ([vmtm_id_pk], [vmtm_maintenance_type]) VALUES (8, N'Painting')
GO
INSERT [admin].[vehicle_maintenance_type_master] ([vmtm_id_pk], [vmtm_maintenance_type]) VALUES (9, N'Other')
GO
SET IDENTITY_INSERT [admin].[vehicle_maintenance_type_master] OFF
GO
SET IDENTITY_INSERT [citizen].[citizen_complaints_type] ON 
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (1, N'Absenteeism of door to door  garbage collector', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (2, N'Absenteeism of Sweepers', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (3, N'Biomedical Waste', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (5, N'Burning of Garbage', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (6, N'Cleaning of Roads', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (8, N'Cleaning of vacant Sites', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (9, N'Cockroach, rat and flies problem because of solid waste', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (13, N'Garbage is thrown all around and no maintenance', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (16, N'Hotel or factory dumping solid waste in the colony', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (18, N'Need training on segrigation of solid waste', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (19, N'No garbage collection in my street', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (20, N'No cleaning of dustbins', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (22, N'Other', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (23, N'Removal of construction debris and other debis', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (24, N'Removal of Garbage', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (25, N'Sanitary land fill sites', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (26, N'Garbage bin is full', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (28, N'Request for Garbage collections', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (29, N'Missed Garbage Collection at home / Industrial Area', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (30, N'Garbage Pile on the roads', NULL, NULL)
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (52, N'Parking property voilation', N'54', N'Bangaluru')
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (53, N'Burning of garbage at Kodungaiyur Dumping Ground', N'18', N'Bangaluru')
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (54, N'Burning of garbage at Kodungaiyur Dumping Ground', N'18', N'Bangaluru')
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (58, N'Burning of garbage at perungudi Dumping Ground', N'19', N'Bangaluru')
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (59, N'Burning of garbage at Kodungaiyur Dumping Ground', N'18', N'Bangaluru')
GO
INSERT [citizen].[citizen_complaints_type] ([cct_id_pk], [cct_type], [typeCode], [tenantCode]) VALUES (60, N'Burning of garbage at Kodungaiyur Dumping Ground', N'1', N'Bangaluru')
GO
SET IDENTITY_INSERT [citizen].[citizen_complaints_type] OFF
GO
SET IDENTITY_INSERT [citizen].[priority_type] ON 
GO
INSERT [citizen].[priority_type] ([pt_id_pk], [pt_priority]) VALUES (1, N'Low')
GO
INSERT [citizen].[priority_type] ([pt_id_pk], [pt_priority]) VALUES (2, N'Medium')
GO
INSERT [citizen].[priority_type] ([pt_id_pk], [pt_priority]) VALUES (3, N'High')
GO
SET IDENTITY_INSERT [citizen].[priority_type] OFF
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (0)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (1)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (2)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (3)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (4)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (5)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (6)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (7)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (8)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (9)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (10)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (11)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (12)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (13)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (14)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (15)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (16)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (17)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (18)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (19)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (20)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (21)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (22)
GO
INSERT [dbo].[HoursDay] ([h]) VALUES (23)
GO
SET IDENTITY_INSERT [garbage].[poi_type_details] ON 
GO
INSERT [garbage].[poi_type_details] ([ptd_id_pk], [ptd_poi_type], [ptd_poi_access], [ptd_fence_access], [ptd_client_poi_status]) VALUES (1, N'Bin Location', 1, 1, 0)
GO
INSERT [garbage].[poi_type_details] ([ptd_id_pk], [ptd_poi_type], [ptd_poi_access], [ptd_fence_access], [ptd_client_poi_status]) VALUES (2, N'Start Location', 1, 1, 1)
GO
INSERT [garbage].[poi_type_details] ([ptd_id_pk], [ptd_poi_type], [ptd_poi_access], [ptd_fence_access], [ptd_client_poi_status]) VALUES (3, N'Dumping Yard', 1, 1, 3)
GO
INSERT [garbage].[poi_type_details] ([ptd_id_pk], [ptd_poi_type], [ptd_poi_access], [ptd_fence_access], [ptd_client_poi_status]) VALUES (4, N'Road Area', 1, 1, 0)
GO
INSERT [garbage].[poi_type_details] ([ptd_id_pk], [ptd_poi_type], [ptd_poi_access], [ptd_fence_access], [ptd_client_poi_status]) VALUES (5, N'End Location', 1, 1, 1)
GO
INSERT [garbage].[poi_type_details] ([ptd_id_pk], [ptd_poi_type], [ptd_poi_access], [ptd_fence_access], [ptd_client_poi_status]) VALUES (6, N'Garage', 1, 1, 1)
GO
INSERT [garbage].[poi_type_details] ([ptd_id_pk], [ptd_poi_type], [ptd_poi_access], [ptd_fence_access], [ptd_client_poi_status]) VALUES (8, N'Municipal Office', 1, 1, 1)
GO
INSERT [garbage].[poi_type_details] ([ptd_id_pk], [ptd_poi_type], [ptd_poi_access], [ptd_fence_access], [ptd_client_poi_status]) VALUES (7, N'Transfer-Station', 1, 1, 3)
GO
SET IDENTITY_INSERT [garbage].[poi_type_details] OFF
GO
ALTER TABLE [admin].[config_alert_sub_type] ADD  DEFAULT ((0)) FOR [cast_type]
GO
ALTER TABLE [admin].[config_alert_type] ADD  DEFAULT ((0)) FOR [cat_email_status]
GO
ALTER TABLE [admin].[config_alert_type] ADD  DEFAULT ((0)) FOR [cat_sms_status]
GO
ALTER TABLE [admin].[config_alert_type] ADD  DEFAULT ((0)) FOR [cat_nearest_workforce]
GO
ALTER TABLE [admin].[config_bin_type] ADD  DEFAULT ((0)) FOR [cbt_type]
GO
ALTER TABLE [admin].[config_fence_type] ADD  DEFAULT ((0)) FOR [cft_type]
GO
ALTER TABLE [admin].[config_fleet_category] ADD  DEFAULT ((0)) FOR [cfc_type]
GO
ALTER TABLE [admin].[config_fleet_category] ADD  DEFAULT ((0)) FOR [cfc_ulb_id_fk]
GO
ALTER TABLE [admin].[config_fleet_category] ADD  DEFAULT ((0)) FOR [cfc_mileage]
GO
ALTER TABLE [admin].[config_report_menu] ADD  DEFAULT ((0)) FOR [crm_ulb_id_fk]
GO
ALTER TABLE [admin].[config_shift_master] ADD  DEFAULT ((0)) FOR [csm_ulb_id_fk]
GO
ALTER TABLE [admin].[config_staff_type] ADD  DEFAULT ((0)) FOR [cst_ulb_id_fk]
GO
ALTER TABLE [admin].[device_Type] ADD  DEFAULT ((0)) FOR [dt_type_Id]
GO
