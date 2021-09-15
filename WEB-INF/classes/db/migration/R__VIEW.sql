/****** Object:  View [dbo].[all_geofence_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[all_geofence_view]
WITH SCHEMABINDING
AS
SELECT gcf_zone_id as zonid,gcf_ward_id as wardid, gcf_id_pk AS id,gcf_poi_name AS name,gcf_poi_type_id_fk AS poi_type,gcf_ulb_id_fk AS ubl_id,gcf_fence_the_geom AS geom ,[gcf_radius],gcf_the_geom
FROM garbage.gis_client_fence 
UNION ALL
SELECT gdg_zone_id as zonid,gdg_ward_id as wardid,gdg_id_pk AS id,gdg_name AS name,3 AS poi_type,gdg_ulb_id_fk AS ulb_id,gdg_the_geom AS geom ,0,null
FROM garbage.gis_dumping_grounds
UNION ALL
SELECT  gra_zone_id as zonid,gra_ward_id as wardid, gra_id_pk AS id, gra_name AS name,4 AS poi_type,gra_ulb_id_fk AS ulb_id, gra_fence AS geom,0,null FROM garbage.gis_road_area

/*SELECT ggcf_points_id_pk AS id,ggcf_points_name AS name,poi_type_details AS poi_type,ggcf_ulb_id_fk AS ulb_id,
(select geometry::STGeomFromText('POINT('+CAST((geometry::STGeomFromText(CONVERT(nvarchar(50),the_geom), 4326).STX) 
AS VARCHAR(20))+' '+CAST((geometry::STGeomFromText(CONVERT(nvarchar(50),the_geom),4326).STY) AS VARCHAR(20))+')', 0).STBuffer(0.0002) )

--from (select geometry::
--STGeomFromText(CONVERT(nvarchar(50),the_geom), 4326).STX as lat,geometry::STGeomFromText(CONVERT(nvarchar(50),the_geom),
 --4326).STY as lon from BSNL_SWM_APP.garbage.gis_garbage_collection_points ) as temp_t1)
  AS 
geom FROM garbage.gis_garbage_collection_points
*/

GO
/****** Object:  View [dbo].[fg_trip_status_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [dbo].[fg_trip_status_view]

AS


  select tcm_trip_id_fk Trip_ID,CASE when tcm_weight_disposed is null then 0 else tcm_weight_disposed end Waste_Disposed ,tcm_route_id_fk as 'Route_ID',cfc_type as 'Vehicle_Type',
case when sum(tcm_trip_distance) is null then 0 else round(sum(tcm_trip_distance),2) end Distance,
(select sum(case when tcd_collection_status=1 or tcd_collection_status=3 then tcd_bins_collected else 0 end) from [reporting].[trip_completed_details] where tcd_master_id_fk=tcm_id_pk ) No_Of_Bins_Covered,case when [cssm_staff_name] is null then '' else [cssm_staff_name] end as driver_name,case when [cssm_emp_id] is null then '' else [cssm_emp_id] end as emp_id,tcm_vehicle_id_fk as vehicle_id,'COMPLETED' AS trip_status,cfm_ulb_id_fk,convert(nvarchar(20),tcm_trip_date_time,120) as scheduled_time,case when tcm_start_date_time is null then '' else convert(nvarchar(20),tcm_start_date_time,120) end as trip_start_time,case when tcm_end_date_time is null then '' else convert(nvarchar(20),tcm_end_date_time,120) end as trip_end_time,csm_shift_name as shift_name,case when [tcm_start_location] is null then '' else [tcm_start_location] end as start_location,case when [tcm_end_location] is null then '' else [tcm_end_location] end as end_location,case when [tcm_dumping_ground] is null then '' else [tcm_dumping_ground] end as dg_ts,case when [tcm_dump_entry_time] is null then '' else  convert(nvarchar(20),[tcm_dump_entry_time],120) end as dg_ts_time from  [reporting].[trip_completed_master] left join admin.config_fleet_master on cfm_id_pk=tcm_vehicle_id_fk
join admin.config_fleet_category fc on [cfm_vehicle_type_id_fk]=cfc_id_pk  left join[admin].[config_staff_master] on [cssm_id_pk]= tcm_driver_id_fk left join admin.config_shift_master on tcm_shift_id_fk=csm_id_pk  
where cast(tcm_trip_date_time as date ) =cast(getdate() as date) 
GROUP BY [tcm_trip_id_fk],tcm_route_id_fk,cfc_type,cssm_staff_name,cssm_emp_id,tcm_weight_disposed,tcm_id_pk,tcm_vehicle_id_fk,cfm_ulb_id_fk,tcm_trip_date_time,tcm_start_date_time,tcm_end_date_time,csm_shift_name,tcm_start_location,tcm_end_location,tcm_dumping_ground,tcm_dump_entry_time
union all
(  select tom_trip_id_fk Trip_ID,CASE when tom_weight_disposed is null then 0 else tom_weight_disposed end Waste_Disposed ,tom_route_id_fk as 'Route ID',cfc_type as 'Vehicle Type',case when tom_trip_distance is null then 0 else tom_trip_distance end Distance,
(select sum(case when tod_collection_status=1 or tod_collection_status=3 then tod_bins_collected else 0 end) from [reporting].[trip_ongoing_details] where tod_master_id_fk=tom_id_pk ) No_Of_Bins_Covered,case when [cssm_staff_name] is null then '' else [cssm_staff_name] end as driver_name,case when [cssm_emp_id] is null then '' else [cssm_emp_id] end as emp_id,tom_vehicle_id_fk as vehicle_id,case when tom_trip_status=0 then 'PENDING' ELSE 'ONGOING' END AS trip_status,cfm_ulb_id_fk,convert(nvarchar(20),tom_trip_schedule_date_time,120),case when tom_start_date_time is null then '' else convert(nvarchar(20),tom_start_date_time,120) end as start_time,case when tom_end_date_time is null  then '' else convert(nvarchar(20),tom_end_date_time,120) end as end_time,csm_shift_name,gv1.name,gv2.name,case when gv3.name is null then '' else gv3.name end ,case when [tom_dump_time] is null then '' else convert(nvarchar(20),[tom_dump_time],120) end from  [reporting].[trip_ongoing_master] left join admin.config_fleet_master cfm on cfm_id_pk=tom_vehicle_id_fk
join admin.config_fleet_category fc on [cfm_vehicle_type_id_fk]=cfc_id_pk --left join [dbo].[HistoryTableView] ON [hm_vehicle_id]=tom_vehicle_id_fk and [hm_utc_date_time] between tom_start_date_time and getdate() 
left join[admin].[config_staff_master] on [cssm_id_pk]= tom_driver_id_fk left join admin.config_shift_master on tom_shift_id_fk=csm_id_pk left join [dbo].[all_geofence_view] gv1 on gv1.[poi_type]= [tom_start_loc_type] and [tom_start_location]=gv1.[id] left join [dbo].[all_geofence_view] gv2 on gv2.[poi_type]= [tom_end_loc_type] and [tom_final_location]=gv2.[id] left join [dbo].[all_geofence_view] gv3 on gv3.[poi_type]= 3 and tom_end_location=gv3.[id] 
where cast(tom_trip_schedule_date_time as date ) =cast(getdate() as date) 
GROUP BY [tom_trip_id_fk],tom_route_id_fk,cfc_type,cssm_staff_name,cssm_emp_id,tom_weight_disposed,tom_id_pk,tom_vehicle_id_fk,tom_trip_status,cfm_ulb_id_fk,tom_trip_schedule_date_time,tom_start_date_time,tom_end_date_time,tom_trip_distance,csm_shift_name,gv1.name,gv2.name,gv3.name,tom_dump_time)

GO
/****** Object:  View [dbo].[current_shift_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[current_shift_view]
WITH SCHEMABINDING
AS

select case when  (DATEPART(HOUR,CAST(getdate() AS time))) <=5 then 2 when (DATEPART(HOUR,CAST(getdate() AS time))) >=21 then 2 else 1 end
 as csm_id_pk

GO
/****** Object:  View [dbo].[current_vehicle_status_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[current_vehicle_status_view]

AS

select vom_trip_id,isGPS, cfm_ulb_code as tenantCode,cfm_sim_no,macAddress,case when vom_maintenance_type is null then '-' else vom_maintenance_type end as maintenance_type,
CASE WHEN vom_signal_strength < 10 then 'verybad' when vom_signal_strength >= 10 and vom_signal_strength < 20 then 'bad'
when  vom_signal_strength >= 20 and vom_signal_strength < 30 then 'good' when  vom_signal_strength >= 30 then 'excelent' end as signal_status,CASE WHEN vom_gpsstatus = 1 
then 'GPS' when vom_gpsstatus=0 then 'NO-GPS' end as vom_gpsstatus,CASE WHEN vom_batterystatus = 11 then 'BATTERYCONNECTED' when vom_batterystatus = 0 then 'BATTERYDISCONNECTED' end as vom_batterystatus,case when vom_status=1 then 'TRACKING' when vom_status=2 then 'NON TRACKING' when  vom_status=3 then 'NO GPS'
when  vom_status=4 then 'LOW COVERAGE' when  vom_status=5 then 'DISCONNECTED' when [vom_status] = 6  then 'UNDER MAINTENANCE'   END AS status,
vom_degree,vom_vehicle_No as vehNo,vom_signal_strength as signal_st,
case when vom_ignition=0  then 0 when vom_ignition=1 and vom_rfts_status=1 and vom_rfid_status=1 then 1 when vom_ignition=1 and vom_rfts_status=1 and vom_rfid_status=0 then 0 when vom_ignition=1 and vom_rfts_status=1 and vom_rfid_status=2 then 2 when vom_ignition=1 and vom_rfts_status=0 or vom_rfid_status=2 then 0  else 0 end as vom_rfid_status,
--case  when vom_ignition=0 then '0' when vom_ignition=1  and vom_rfts_status=1 then '1' when vom_ignition=1 and (vom_rfts_status=0 or vom_rfts_status=2) then '2' end as ignition_rfts,
case  when vom_ignition=0 then '0' when vom_ignition=1  and vom_rfts_status=1 then '1' when vom_ignition=1 and (vom_rfts_status=0 or vom_rfts_status=2 or vom_rfts_status is null) then '2' end as ignition_rfts ,
vom_gpsstatus as gps_st,vom_batterystatus as btry_st,vom_vehicle_id as vehId,vom_sim_no,
case when vom_placename is null then 'NA' else vom_placename end as plcNam,
vom_latitude as lat,vom_longitude as lon,convert(varchar(50), [vom_utc_date_time] ,121) as UTC_date, cfm_contractor_name, vom_distance

					  ----convert(varchar(10),cast ([vom_utc_date_time] as date),21)
					   ,vom_received_date_time,vom_speed as speed,vom_status,vom_ulb_id,
					   case when rm_route_name is null then '' else rm_route_name end Route,
					   CASE WHEN [vom_trip_id]>0 THEN 'IN TRIP' ELSE 'NOT IN TRIP' END AS trip_status,
					    case when vom_status=1 AND [vom_trip_id]>0  then 'GREEN' when vom_status=1 AND ([vom_trip_id]<=0 OR [vom_trip_id] IS NULL )  then 'PURPLE'  WHEN vom_status=2 THEN 'MEROON' WHEN vom_status=5 THEN 'RED' WHEN vom_status=3 THEN 'AMBER' else 'BLUE' end color,
						case when [cssm_staff_name] is null then '' else [cssm_staff_name] end as driver_name,
						(select [csm_shift_name] from current_shift_view csv join [admin].[config_shift_master] csm on  csm.[csm_id_pk]=csv.csm_id_pk)as shift_type,
						case when vom_idle_time is null then '--- --- ---' else CONVERT(varchar(10),vom_idle_time,105)+' '+CONVERT(varchar(8),vom_idle_time,14) end AS idletime,
					   cfm_vehicle_type_id_fk,vom_ignition,cfc_type as vehicleType,
					   cfm_zone_id,cfm_ward_id,czm_zone_name,cwm_ward_name,CASE WHEN vom_speed > 3 and vom_ignition=1 and vom_status=1  then 'Running' when  vom_speed < 3 and vom_ignition=1 and vom_status=1  then 'Idle' 
					  when vom_speed < 3 and vom_ignition=0 and vom_status=1  then 'Stand'  end as vehicle_status,CASE WHEN vom_speed > 3 and vom_speed<50 and vom_status=1 then 'Normal' when  vom_speed > 50 and vom_speed<60 and vom_status=1 then 'Alarming'  when  vom_speed = 0 and vom_status=1 then 'Zero'
					  when  vom_speed > 60 and vom_status=1  then 'Max'  end as speed_status,cfc_type_code as vehicleTypeCode,cast((batteryLevel*1./4200)*100 as int) as perBatteryLevel  from view_online_master 
left join [admin].[config_fleet_master] on cfm_id_pk=vom_vehicle_id
left join [admin].[config_fleet_category] on [cfm_vehicle_type_id_fk]=[cfc_id_pk]
left join [admin].[config_zone_master] on czm_id_pk=cfm_zone_id
left join [admin].[config_ward_master] on cwm_id_pk=cfm_ward_id
left join [garbage].[route_master] on rm_id_pk=[vom_route_id] 
left join [admin].[config_staff_master]	on [cssm_id_pk]=[vom_driver_id] and [cssm_staff_type]=1

GO
/****** Object:  View [dbo].[trip_report_vehicle_wise]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[trip_report_vehicle_wise]

AS
select *,totalbins-(collectedbins+attendedtagnotreadbins)notcollected from (select [cfm_zone_id],cfm_ward_id, cfm_ulb_id_fk, tcm_trip_date_time as trip_time,tcm_vehicle_id_fk,cfm_vehicle_no,tcm_trip_id_fk as tom_trip_id_fk,tcm_weight_disposed,case when tcm_start_date_time is null then '---' else convert(varchar(10),tcm_start_date_time,105)+' '+convert(varchar(8),tcm_start_date_time,108) end as tcm_start_date_time,
convert(varchar(10),tcm_trip_date_time,105)+' '+convert(varchar(8),tcm_trip_date_time,108) tcm_trip_date_time
,[rm_route_name],case when [tcm_end_date_time] is null then '---' else convert(varchar(10),[tcm_end_date_time],105)+' '+convert(varchar(8),[tcm_end_date_time],108) end as [tcm_end_date_time],'Completed'[tcm_trip_status],[cssm_staff_name],[csm_shift_name],[tcm_dumping_ground],[tcm_dump_entry_time],[tcm_start_location],[tcm_end_location],[tcm_received_weight],[tcm_trip_distance],(select sum([tcd_bins_to_be_collected]) from reporting.trip_completed_details where tcd_master_id_fk=tcm_id_pk )totalbins,(select case when sum([tcd_bins_collected]) is null then 0 else sum([tcd_bins_collected]) end from reporting.trip_completed_details where tcd_master_id_fk=tcm_id_pk and  [tcd_collection_status]=1)collectedbins,(select case when sum([tcd_bins_to_be_collected]) is null then 0 else sum([tcd_bins_to_be_collected]) end  from reporting.trip_completed_details where tcd_master_id_fk=tcm_id_pk and  [tcd_collection_status]=1  )attendedtagnotreadbins from reporting.trip_completed_master 
left join [admin].[config_fleet_master] on cfm_id_pk=tcm_vehicle_id_fk
left join [garbage].[route_master] on [rm_id_pk]=[tcm_route_id_fk]
left join [admin].[config_staff_master] on cssm_id_pk= [tcm_driver_id_fk]
left join [admin].[config_shift_master] on csm_id_pk=[tcm_shift_id_fk] where [cfm_ward_id] is not null and [cfm_zone_id] is not null
------------------------
union all (
select  [gdg_zone_id],[gdg_ward_id],cfm_ulb_id_fk, tom_trip_schedule_date_time as trip_time,tom_vehicle_id_fk,cfm_vehicle_no,tom_trip_id_fk as tom_trip_id_fk,tom_weight_disposed,case when tom_start_date_time is null then '---' else convert(varchar(10),tom_start_date_time,105)+' '+convert(varchar(8),tom_start_date_time,108) end as tcm_start_date_time,
convert(varchar(10),tom_trip_schedule_date_time,105)+' '+convert(varchar(8),tom_trip_schedule_date_time,108) tcm_trip_date_time
,[rm_route_name],case when [tom_end_date_time] is null then '---' else convert(varchar(10),[tom_end_date_time],105)+' '+convert(varchar(8),[tom_end_date_time],108) end as [tcm_end_date_time],case when [tom_trip_status]=null or [tom_trip_status]=0 then 'Pending' when [tom_trip_status]=1 then 'Ongoing' else 'Completed' end as [tcm_trip_status],[cssm_staff_name],[csm_shift_name],[gdg_name],[tom_dump_time],agv1.name,agv2.[name],[tom_received_weight],[tom_trip_distance],(select sum([tod_bins_to_be_collected]) from reporting.trip_ongoing_details where tod_master_id_fk=tom_id_pk )totalbins,(select case when sum([tod_bins_collected]) is null then 0 else sum([tod_bins_collected]) end from reporting.trip_ongoing_details where tod_master_id_fk=tom_id_pk and  [tod_collection_status]=1)collectedbins,(select case when sum([tod_bins_to_be_collected]) is null then 0 else sum([tod_bins_to_be_collected]) end  from reporting.trip_ongoing_details where tod_master_id_fk=tom_id_pk and  [tod_collection_status]=1  )attendedtagnotreadbins from reporting.trip_ongoing_master 
left join [admin].[config_fleet_master] on cfm_id_pk=tom_vehicle_id_fk
left join [garbage].[route_master] on [rm_id_pk]=[tom_route_id_fk]
left join [admin].[config_staff_master] on cssm_id_pk= [tom_driver_id_fk]
left join [admin].[config_shift_master] on csm_id_pk=[tom_shift_id_fk] left join [garbage].[gis_dumping_grounds] on [gdg_id_pk]=[tom_end_location] left join [dbo].[all_geofence_view]  agv1  on agv1.[id]=[tom_start_location] and [tom_start_loc_type]=agv1.[poi_type]
left join [dbo].[all_geofence_view]  agv2  on agv2.[id]=tom_final_location and [tom_end_loc_type]=agv2.[poi_type] where [gdg_zone_id] is not null and [gdg_ward_id] is not null
)

)as t1
/*select * ,(select weight1 from [dbo].[fnAppendString_weight_For_report](tripid)) as weight from (

 select [bcdr_date] ,[bcdr_ward_id],[bcdr_zone_id],[cwm_ward_name],[czm_zone_name],total_bins,collected_bins,AttendedNotCollectedBin  as 'Bins Attended/Tag Not Read',total_bins-(collected_bins+AttendedNotCollectedBin) as not_collected_bins,vehicleno,tripid
							   from( select [bcdr_date],[bcdr_ward_id],[bcdr_zone_id],count([bcdr_bin_id]) total_bins, sum(case when [bcdr_bin_collected_status]=1 then 1  else 0 end)collected_bins, sum(case when [bcdr_bin_collected_status]=3 then 1 else 0 end)AttendedNotCollectedBin,(select vehicleno from [dbo].[fnAppendString_vehicle_For_report] ([bcdr_ward_id],convert(nvarchar(10),[bcdr_date])+' '+'00:00:00' , convert(nvarchar(10),[bcdr_date])+' '+'23:59:59')) as vehicleno,(select tripid from [dbo].[fnAppendString_trip_For_report] ([bcdr_ward_id],convert(nvarchar(10),[bcdr_date])+' '+'00:00:00' , convert(nvarchar(10),[bcdr_date])+' '+'23:59:59')) as tripid
							 from [trinitySWM_VMC].[reports].[bin_collection_detailed_report]     where [bcdr_ulb_id_fk] ='16179' group by bcdr_zone_id,[bcdr_ward_id],[bcdr_date]) as t1 left join [trinitySWM_VMC].admin.config_ward_master on [cwm_id_pk]=[bcdr_ward_id] left join   [trinitySWM_VMC].admin.config_zone_master on czm_id_pk=[bcdr_zone_id]  

union all(select cast(getdate() as date) ,[cbsm_ward_id],[cbsm_zone_id],[cwm_ward_name],[czm_zone_name],total_bins,collected_bins,AttendedNotCollectedBin  as 'Bins Attended/Tag Not Read',total_bins-(collected_bins+AttendedNotCollectedBin) as not_collected_bins,vehicleno,tripid
							   from( select [cbsm_ward_id],[cbsm_zone_id],[cwm_ward_name],[czm_zone_name],count([cbsm_bin_id]) total_bins, sum(case when [cbsm_collection_status]=1 then 1  else 0 end)collected_bins, sum(case when [cbsm_collection_status]=3 then 1 else 0 end)AttendedNotCollectedBin,(select vehicleno from [dbo].[fnAppendString_vehicle_For_report] ([cbsm_ward_id],convert(nvarchar(10),cast(getdate() as date))+' '+'00:00:00' , convert(nvarchar(10),cast(getdate() as date))+' '+'23:59:59')) as vehicleno,(select tripid from [dbo].[fnAppendString_trip_For_report] ([cbsm_ward_id],convert(nvarchar(10),cast(getdate() as date))+' '+'00:00:00' , convert(nvarchar(10),cast(getdate() as date))+' '+'23:59:59')) as tripid
							 from [trinitySWM_VMC].[dbo].[compactor_bin_collection_status_view]  where [cbsm_ulb_id_fk] ='16179' group by [cbsm_ward_id],[cbsm_zone_id],[cwm_ward_name],[czm_zone_name]) as t1)) as tt1
							 */

GO
/****** Object:  View [dbo].[get_citizen_complaint_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[get_citizen_complaint_view]
AS
	select ISNULL(crt_remarks, '--' ) as crt_remarks ,ggcf_points_name, cc_complaint_time,cc_complain_mode,cc_complaint_type,[cc_id_pk],[cc_informer_name],[cc_email_id],[cc_location],[cc_phone_no],[cc_ward],[cc_zone],cct_id_pk as typeCode,[cct_type],[cc_citizen_geom].STX as compLon,[cc_citizen_geom].STY as compLat,[cc_image_url],[cc_priority],[cc_compliant_status],[cc_assign_status],[cc_ulb_id_fk],[cc_complaint_key],convert(nvarchar(10),cc_complaint_time,105)+' '+convert(nvarchar(8),cc_complaint_time,108) as datee,
	convert(nvarchar(10),[cc_resolved_time],105)+' '+convert(nvarchar(8),[cc_resolved_time],108) as resolvedDate,ccas_imgurl,cc_image
	,ulbm_tenant_code,sourceName,czm_zone_name as zoneName,cwm_ward_name as wardName from citizen.citizen_complaints cc
	left join garbage.gis_garbage_collection_points on [ggcf_points_id_pk] = [binLocationFK]
	left join [citizen].[citizen_complaints_action_status] on [ccas_cc_id_fk] = [cc_id_pk]
	INNER JOIN citizen.citizen_complaints_type pt on cc.[cc_complaint_type] = pt.[cct_id_pk]
	left join admin.urban_local_body_master on cc_ulb_id_fk=ulbm_id_pk
	left join admin.config_zone_master on czm_id_pk=[cc_zone]
	left join admin.config_ward_master on cwm_id_pk=[cc_ward]
	left join [citizen].[citizen_remarks_types] on [crt_id]=ccRemarkType

GO
/****** Object:  View [dbo].[complaint_status_for_dash_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[complaint_status_for_dash_view]

AS

select case when TotalComp is null then 0 else TotalComp end as TotalComp ,case when Ongoingcc_compliant_status is null then 0 else Ongoingcc_compliant_status 
  end as Ongoingcc_compliant_status,case when Pendingcc_compliant_status is null then 0 else 
  Pendingcc_compliant_status end as Pendingcc_compliant_status,case when Compcc_compliant_status is null 
  then 0 else Compcc_compliant_status end as Compcc_compliant_status,[cc_ulb_id_fk],date from 
   (select count(*) as TotalComp , sum( case when cc_compliant_status=1 then 1 else 0 end )Ongoingcc_compliant_status,sum( 
  case when cc_compliant_status=0 then 1 else 0 end )Pendingcc_compliant_status,sum( case when 
  cc_compliant_status=2 then 1 else 0 end)Compcc_compliant_status,[cc_ulb_id_fk],cast(cc_complaint_time as date) as date from [dbo].[get_citizen_complaint_view] 
  group by [cc_ulb_id_fk], cast(cc_complaint_time as date)
   )  as temp_newTbl

GO
/****** Object:  View [dbo].[dtd_bin_collection_status_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[dtd_bin_collection_status_view]

AS
select [dbcdr_bin_collected_status],[dbcdr_bin_id],[dbcdr_road_id],[dbcdr_date] 
,[dbcdr_zone_id],[dbcdr_ward_id],[dbcdr_ulb_id_fk],[dbcdr_vehicle_id_fk],dbcdr_trip_id,
[dbcdr_collected_time],[dbcdr_house_holder_name],cfm_vehicle_no,czm_zone_name,[czm_id_pk],cwm_ward_name,[cwm_id_pk]
 from  [reports].[dtd_bin_collection_detailed_report] 
left join admin.config_fleet_master on cfm_id_pk=[dbcdr_vehicle_id_fk]
 left join admin.config_zone_master on czm_id_pk=[dbcdr_zone_id]
  left join admin.config_ward_master on cwm_id_pk=[dbcdr_ward_id]
 
 UNION ALL(
 select [crm_bin_collection_status] as [dbcdr_bin_collected_status] ,[crm_bin_id] as [dbcdr_bin_id],[crm_bin_loc_id_fk] as [dbcdr_road_id], cast(GETDATE() as date) as [dbcdr_date],
 [crm_zone_id] as[dbcdr_zone_id],[crm_ward_id] as [dbcdr_ward_id] ,[crm_ulb_id_fk] as [dbcdr_ulb_id_fk],NULL as [dbcdr_vehicle_id_fk],NULL as dbcdr_trip_id,
 [crm_bin_collection_time] as [dbcdr_collected_time],[cbm_person_name] as [dbcdr_house_holder_name], NULL as cfm_vehicle_no,czm_zone_name,[czm_id_pk],cwm_ward_name,[cwm_id_pk]
 from [admin].[config_rfid_master] left join [admin].[config_bin_master] on [crm_bin_id]=[cbm_id_pk] left join [admin].[config_zone_master] on [czm_id_pk]=[crm_zone_id] left join [admin].[config_ward_master] on [cwm_id_pk]=[crm_ward_id]
  where [cbm_binRroad_status]=1
 
 )
GO
/****** Object:  View [dbo].[DoorToDoorForDashGrid]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[DoorToDoorForDashGrid]
AS 	
   with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0)))where 
   dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()union all select dateadd(dd, 1, dt) 
   from dateRange where dateadd(dd, 1, dt) < GETDATE()-1)select  convert(varchar(10),dt,120) as dt ,czm_zone_name,cwm_ward_name,
   dbcdr_zone_id,dbcdr_ward_id,count([dbcdr_bin_id]) as total,sum(case when[dbcdr_bin_collected_status]=1 then 1 else 0 end) as collected,
   sum(case when [dbcdr_bin_collected_status]=0 then 1 else 0 end) as notcollected,dbcdr_ulb_id_fk  from dateRange 
   left join [dbo].[dtd_bin_collection_status_view] on dt=[dbcdr_date] group by dt,czm_zone_name,cwm_ward_name,dbcdr_ulb_id_fk,
   dbcdr_zone_id,dbcdr_ward_id

GO
/****** Object:  View [dbo].[ongoing_trip_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[ongoing_trip_view]

AS
	select [stm_end_time] as endTime,gdg_id_pk,gdg_the_geom.STAsText() as gdg_the_geom,stm_end_time, csm_id_pk,[cwm_ward_name],[czm_zone_name],[cfm_zone_id],[cfm_ward_id],tom_vehicle_id_fk,tom_trip_schedule_date_time as tom_time, cfm_ulb_id_fk,(select case when staffName is null then 'NA' else staffName end as staffName from [dbo].[fnAppendString] (tom_trip_id_fk)) as sanitationStaffNm,case when gcf1.gcf_poi_name is null then 'NA' else gcf1.gcf_poi_name end as start_location,case when name is null then 'NA' else name end as end_location,tom_trip_id_fk,tom_trip_status,case when tom_trip_schedule_date_time is null then 'NA' else CONVERT(varchar(10),tom_trip_schedule_date_time,105)+' '+CONVERT(varchar(10),tom_trip_schedule_date_time,108) end as tom_trip_schedule_date_time,case when tom_trip_schedule_date_time is null then 'NA' else CONVERT(varchar(10),tom_trip_schedule_date_time,108) end as tom_trip_schedule_time,tom_route_id_fk,tom_id_pk,case when tom_start_date_time is null then 'NA' else CONVERT(varchar(10),tom_start_date_time,105)+' '+CONVERT(varchar(8),tom_start_date_time,108) end as tom_start_date_time,case when tom_end_date_time is null then 'NA' else CONVERT(varchar(10),tom_end_date_time,105)+' '+CONVERT(varchar(8),tom_end_date_time,108) end as tom_end_date_time,tom_weight_disposed,case when staff.cssm_staff_name is null then 'NA' else staff.cssm_staff_name end as cssm_staff_name,fleet.cfm_vehicle_no,case when routedata.rm_route_name is null then 'NA' else routedata.rm_route_name end as rm_route_name,shift.csm_shift_name,case when dumping.gdg_name is null then 'NA' else dumping.gdg_name end as gdg_name ,case when tom_route_id_fk > 0 then [rm_geom].STAsText() else stm_geom.STAsText() end as  latlon,cfm_id_pk,online.[vom_latitude]as onlineLat,online.[vom_longitude]  as onlineLon,online.[vom_status] as onlineStatus,online.[vom_placename] as placename,
	fleet1.cfc_id_pk as vehTypeCategory,fleet1.cfc_type as vehTypeCategory1,(select count(tod_id_pk) from reporting.trip_ongoing_details where tod_master_id_fk=tom_id_pk) as collection_points,vom_vehicle_type+convert(varchar(10),vom_status)image_name,case when tom_trip_distance is null then '0' else  tom_trip_distance end as Distance,tom_route_type as rm_type,case when tom_dump_time is null then 'NA' else CONVERT(varchar(10),tom_dump_time,105)+' '+CONVERT(varchar(8),tom_dump_time,108) end as dump_time,case when tom_received_weight is null then 0 else tom_received_weight end as received_wt 
	,tom_start_date_time as StartDateTime,tom_end_date_time as EndDateTime from reporting.trip_ongoing_master  
left join  [garbage].[gis_client_fence] gcf1 on tom_start_location=gcf1.gcf_id_pk left join  [garbage].[gis_client_fence] gcf2 on tom_end_location=gcf2.gcf_id_pk left join admin.config_fleet_master as fleet on tom_vehicle_id_fk=fleet.cfm_id_pk left join admin.config_fleet_category as fleet1 on cfm_vehicle_type_id_fk=fleet1.cfc_id_pk left join garbage.route_master as routedata on routedata.rm_id_pk=tom_route_id_fk left join admin.config_shift_master as shift on shift.csm_id_pk=tom_shift_id_fk left join [dbo].[all_geofence_view] as geo on geo.id=tom_end_location and poi_type=3
left join  admin.config_staff_master as staff on staff.cssm_id_pk =tom_driver_id_fk left join garbage.gis_dumping_grounds as dumping on dumping.gdg_id_pk=tom_end_location  left join   dbo.view_online_master as online on online.vom_vehicle_id=tom_vehicle_id_fk left join  [scheduling].[schedule_trip_master] on stm_id_pk=tom_trip_id_fk left join [admin].[config_ward_master] on [cwm_id_pk]=[cfm_ward_id] left join [admin].[config_zone_master] on [czm_id_pk]=[cfm_zone_id] where tom_trip_status in (0,1)


GO
/****** Object:  View [dbo].[compactor_bin_collection_status_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[compactor_bin_collection_status_view]

AS

select cfm_vehicle_no,cbsm_bin_id ,cbsm_bin_loc_id,cbsm_collected_time,cbsm_collection_status,
case when cbsm_collection_status is null or cbsm_collection_status =0 then 'Not Collected'
 when cbsm_collection_status =1 then 'Collected' when cbsm_collection_status =3 then 
 'Attended,Tag Not Read' end as  current_collection_status,cbsm_ward_id,cbsm_zone_id,cbsm_ulb_id_fk,
 cwm_ward_name,czm_zone_name,Bin_type_id,[cbt_type],[cbsm_bin_volume],[cbsm_bin_sensor_capasity],
 ggcf_points_name,[cbm_bin_name],[cbm_bin_capacity],[crm_rfid_no],[crm_rfid_no2],[cbsm_alert_time],
 [cbsm_sla_time],CONVERT(varchar(5),  DATEADD(minute, [cbsm_sla_hours], 0),114) as sla_min
  from admin.config_bin_sensor_master 
  left join admin.config_bin_master on cbm_id_pk=cbsm_bin_id 
  left join [admin].[config_rfid_master] on [crm_bin_id]=cbm_id_pk 
  left join garbage.gis_garbage_collection_points on ggcf_points_id_pk=cbsm_bin_loc_id 
  left join [admin].[config_bin_type] on [cbt_id_pk]=Bin_type_id 
  left join  admin.config_ward_master on cwm_id_pk=cbsm_ward_id 
  left join admin.config_zone_master on czm_id_pk=cbsm_zone_id --where Bin_type_id=3
   left join [admin].[config_fleet_master] on [cfm_id_pk]=ggcf_vehicle_id--where Bin_type_id=3

GO
/****** Object:  View [dbo].[trip_report_zone_wise]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[trip_report_zone_wise]

AS
select * ,(select weight1 from [dbo].[fnAppendString_weight_For_report](tripid)) as weight from (

 select [bcdr_date] ,[bcdr_ward_id],[bcdr_zone_id],[cwm_ward_name],[czm_zone_name],total_bins,collected_bins,AttendedNotCollectedBin  as bcr_bin_attended_not_collected,total_bins-(collected_bins+AttendedNotCollectedBin) as not_collected_bins,vehicleno,tripid
from( select [bcdr_date],[bcdr_ward_id],[bcdr_zone_id],count([bcdr_bin_id]) total_bins, sum(case when [bcdr_bin_collected_status]=1 then 1  else 0 end)collected_bins, sum(case when [bcdr_bin_collected_status]=3 then 1 else 0 end)AttendedNotCollectedBin,(select vehicleno from [dbo].[fnAppendString_vehicle_For_report] ([bcdr_ward_id],convert(nvarchar(10),[bcdr_date])+' '+'00:00:00' , convert(nvarchar(10),[bcdr_date])+' '+'23:59:59')) as vehicleno,(select tripid from [dbo].[fnAppendString_trip_For_report] ([bcdr_ward_id],convert(nvarchar(10),[bcdr_date])+' '+'00:00:00' , convert(nvarchar(10),[bcdr_date])+' '+'23:59:59')) as tripid from  [reports].[bin_collection_detailed_report]     --where [bcdr_ulb_id_fk] ='21210' 
group by bcdr_zone_id,[bcdr_ward_id],[bcdr_date]) as t1 left join  admin.config_ward_master on [cwm_id_pk]=[bcdr_ward_id] left join    admin.config_zone_master on czm_id_pk=[bcdr_zone_id]  

union all(select cast(getdate() as date) ,[cbsm_ward_id],[cbsm_zone_id],[cwm_ward_name],[czm_zone_name],total_bins,collected_bins,AttendedNotCollectedBin  as 'Bins Attended/Tag Not Read',total_bins-(collected_bins+AttendedNotCollectedBin) as not_collected_bins,vehicleno,tripid from( select [cbsm_ward_id],[cbsm_zone_id],[cwm_ward_name],[czm_zone_name],count([cbsm_bin_id]) total_bins, sum(case when [cbsm_collection_status]=1 then 1  else 0 end)collected_bins, sum(case when [cbsm_collection_status]=3 then 1 else 0 end)AttendedNotCollectedBin,(select vehicleno from [dbo].[fnAppendString_vehicle_For_report] ([cbsm_ward_id],convert(nvarchar(10),cast(getdate() as date))+' '+'00:00:00' , convert(nvarchar(10),cast(getdate() as date))+' '+'23:59:59')) as vehicleno,(select tripid from [dbo].[fnAppendString_trip_For_report] ([cbsm_ward_id],convert(nvarchar(10),cast(getdate() as date))+' '+'00:00:00' , convert(nvarchar(10),cast(getdate() as date))+' '+'23:59:59')) as tripid from  [dbo].[compactor_bin_collection_status_view]  
--where [cbsm_ulb_id_fk] ='21210' 
group by [cbsm_ward_id],[cbsm_zone_id],[cwm_ward_name],[czm_zone_name]) as t1)) as tt1

GO
/****** Object:  View [analytics].[route_details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [analytics].[route_details]

AS


  select rm_id_pk as route_id,rm_route_name as route_name,rd_check_points as bin_loc,rd_check_point_id_fk as bin_loc_id,ulbm_tenant_code as tentant_code
  from garbage.route_master
  left join [garbage].[route_details] route on  route.rd_route_id_fk=rm_id_pk
  left join [admin].[urban_local_body_master] ulb on ulb.ulbm_id_pk=rm_ulb_id_fk

GO
/****** Object:  View [analytics].[ulb_details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [analytics].[ulb_details]

AS

select ulbm_id_pk,ulbm_name,ulbm_tenant_code
from [admin].[urban_local_body_master]

GO
/****** Object:  View [analytics].[v_trip_binLoc_binId_details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [analytics].[v_trip_binLoc_binId_details]

AS

select tcm_trip_id_fk as tripId,tcm_trip_date_time as datetime,tcm_vehicle_id_fk as vehId,cfm_vehicle_no as vehNo,tcd_bin_id_fk as binLocId,
tcd_bin_name as binLocName,cbsm_bin_id as binId,cbsm_bin_name as binIdName,cbsm_bin_latitude as lat,cbsm_bin_longitude as long
from [reporting].[trip_completed_master]
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join [reporting].[trip_completed_details] on tcd_master_id_fk=tcm_id_pk
left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tcd_bin_id_fk

GO
/****** Object:  View [analytics].[v_trip_Details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [analytics].[v_trip_Details]

AS

select tcm_trip_id_fk as tripId,tcm_trip_date_time as datetime,ISNULL(cfm_id_pk,10054)
as vehId,ISNULL(cfm_vehicle_no,'KA-04-J-0011') as vehNo,
ISNULL(cfc_type,'Compactor') as vehType
,ISNULL(csm_shift_name, 'General Shift') as shiftName,
ISNULL(csm_id_pk, 1)  as shiftId,
case when cfm_start_location=0 or cfm_start_location is null then 11074 else cfm_start_location end as startLocId,ISNULL(gcf_poi_name,'prabhat12345') as StartLocName,
ISNULL(gcf_the_geom.STX,'73.8156962954891') as long,ISNULL(gcf_the_geom.STY,'15.4920265981556') as lat,case when cfm_driver_id=0 or cfm_driver_id is null then 1012 else cfm_driver_id end as driverId,ISNULL(cssm_staff_name,'sdfsdf') as drivername,ulbm_tenant_code as tenantCode
from [reporting].[trip_completed_master]
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk 
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join [admin].[config_shift_master] on [csm_id_pk]=cfm_shift_type
left join [garbage].[gis_client_fence] on cfm_start_location= gcf_id_pk
left join [admin].[urban_local_body_master] on ulbm_id_pk=tcm_ulb_id_fk
left join admin.config_staff_master on cssm_id_pk=cfm_driver_id

GO
/****** Object:  View [analytics].[v_trip_Staff_Details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [analytics].[v_trip_Staff_Details]

AS

select tcm_trip_id_fk as tripId,tcm_trip_date_time as datetime,tcm_vehicle_id_fk as vehId,cfm_vehicle_no as vehNo,stm_staff as StaffIds, (select staffName from [dbo].[fnAppendString](tcm_trip_id_fk)) as staffName
from [reporting].[trip_completed_master]
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join [scheduling].[schedule_trip_master] on stm_id_pk=tcm_trip_id_fk

GO
/****** Object:  View [dbo].[all_doorTodoorView]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[all_doorTodoorView]
WITH SCHEMABINDING
AS
select cbm_id_pk,cbm_bin_name,crm_bin_lat,crm_bin_long,cbm_zone_id,cwm_ward_name,cbm_ward_id,czm_zone_name,cbm_person_name,crm_bin_loc_id_fk,
					cbm_house_no,crm_bin_collection_status,gra_name,crm_ulb_id_fk,Convert(varchar(50),crm_bin_collection_time,121) as crm_bin_collection_time
					 from admin.config_bin_master bin 
					left join admin.config_rfid_master  crm on bin.cbm_id_pk=crm.crm_bin_id 
					left join admin.config_ward_master cwm on bin.cbm_ward_id= cwm.cwm_id_pk
					 left join admin.config_zone_master czm on bin.cbm_zone_id= czm.czm_id_pk
					 left join [garbage].[gis_road_area] gra on gra.gra_id_pk= crm.crm_bin_loc_id_fk 
					 where  cbm_binRroad_status=1

GO
/****** Object:  View [dbo].[all_predictedDtaWithLoc]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[all_predictedDtaWithLoc]
WITH SCHEMABINDING
AS
select distinct bspa_Bin_ID,cbm.cbm_id_pk,gcp.Bin_type_id,gcp.ggcf_points_id_pk,ggcf_points_name,
gcp.ggcf_points_address as bin_address,
cbm_bin_capacity as bin_capacity,cbm_zone_id,cbm_ward_id 
from [analytics].[bin_sensor_predictive_alert_new]  
join [admin].[config_bin_master] cbm on cbm.cbm_id_pk=bspa_Bin_ID
join [garbage].[gis_garbage_collection_points] gcp on gcp.ggcf_points_id_pk=[bspa_bin_location_id]
where cast(bspa_DateTime as date) between  CONVERT(VARCHAR(10),  DATEADD(day,0, GETDATE()), 120) and  
CONVERT(VARCHAR(10), DATEADD(day,7, GETDATE()), 120)

GO
/****** Object:  View [dbo].[bin_collection_status_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[bin_collection_status_view]

AS

select cbsm_bin_id,cbsm_bin_loc_id,cbsm_alert_time,cbsm_bin_sensor_capasity,cbsm_collected_time,cbsm_collection_status,cbsm_ward_id,cbsm_zone_id,cbsm_ulb_id_fk,cwm_ward_name,czm_zone_name from admin.config_bin_sensor_master left join garbage.gis_garbage_collection_points on ggcf_points_id_pk=cbsm_bin_loc_id left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id left join admin.config_zone_master on czm_id_pk=cbsm_zone_id where Bin_type_id=1

GO
/****** Object:  View [dbo].[Bin_Details_Status_View]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[Bin_Details_Status_View]

AS

SELECT cbm_ulb_id_fk as ulbId, cbm_bin_name as binId,isnull(the_geom.STX, '') as latitude,isnull(the_geom.STY, '') as longitude,isnull(ggcf_points_name, '') as binName,isnull([ggcf_points_address], '') as location,
case when cbsm_bin_sensor_capasity is null then 0 else cbsm_bin_sensor_capasity end as 'volumeFill',cbm_bin_capacity as binCapacity,'' wasteWeight,
case when cbsm_sensor_updated_date is null then  CONVERT(varchar(10),getdate(),105)+' '+CONVERT(varchar(8),getdate(),14) else  CONVERT(varchar(10),cbsm_sensor_updated_date,105)+' '+CONVERT(varchar(8),cbsm_sensor_updated_date,14) end  as reportedDate,
case when czm_zone_name is null then '' else czm_zone_name end  zone,case when cwm_ward_name is null then '' else cwm_ward_name end  ward,
'' vendorName,isnull([cbt_type], '') as 'binType',isnull([cbsm_bin_volume], '')  as binVolume,isnull([crm_rfid_no], '') as rfidNo FROM [admin].[config_bin_master] left join [admin].[config_rfid_master] on cbm_id_pk=[crm_bin_id] 
left join [admin].[config_bin_sensor_master] on cbm_id_pk=cbsm_bin_id left 
join [garbage].[gis_garbage_collection_points] 
on ggcf_points_id_pk=cbm_bin_loc_id left join [admin].[config_bin_type] on [cbt_id_pk] =[Bin_type_id]  left join [admin].[config_ward_master] on cwm_id_pk=cbm_ward_id
left join [admin].[config_zone_master] on czm_id_pk=cbm_zone_id

GO
/****** Object:  View [dbo].[binCollectionReport]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[binCollectionReport]

AS
select [bcr_id_pk],[bcr_bin_collected] as collected,[bcr_bin_not_collected] as notCollected,[bcr_date] as date,[bcr_zone_id],[bcr_ward_id],[dsr_ulb_id_fk],[bcr_total_bins] as total,[bcr_bin_attended_not_collected] as attended,[bcr_bin_type_id],ulbm_tenant_code   FROM [dashboard].[bin_collection_report]
 left join admin.urban_local_body_master on ulbm_id_pk=[dsr_ulb_id_fk]

GO
/****** Object:  View [dbo].[compactor_bin_for_dash_veiw]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[compactor_bin_for_dash_veiw]
AS 	
with dateRange as( select dt = dateadd(dd, 1, CONVERT(date,  dateadd(day,datediff(day,7,GETDATE()),0)))  
							  where   dateadd(dd, 1, CONVERT(date,  dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()   union all 
							 select dateadd(dd, 1, dt) from dateRange where dateadd(dd, 1, dt) < GETDATE())  
							 select t_date,total_bins,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,czm_zone_name,[cwm_id_pk], 
							 case when collected_bins is null then 0 else collected_bins end as collected_bins, 
							 total_bins-((case when collected_bins is null then 0 else collected_bins end)+(case when attended_not_collected_bins is null then 0 else attended_not_collected_bins end)) as not_collected_bins ,
							 case when attended_not_collected_bins is null then 0 else attended_not_collected_bins end as attended_not_collected_bins from 
							 ( select FORMAT( dt,'dd-MM-yyyy') as t_date,sum([ggcf_points_count]) as total_bins,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name, 
							 czm_zone_name,[cwm_id_pk],(select case when dt=cast(getdate() as date) then sum(case when 
							 [ggcf_bin_collection_status]=1 then [ggcf_collected_bins] else 0 end) else (select sum([bcr_bin_collected]) 
							 from [dashboard].[bin_collection_report] where [bcr_date]=dt and [bcr_ward_id]=[cwm_id_pk] and bcr_bin_type_id=3) end ) 
							 collected_bins, 
							( select case when dt=cast(getdate() as date) then sum(case when 
							 [ggcf_bin_collection_status]=3 then [ggcf_points_count] else 0 end) else (select sum([bcr_bin_attended_not_collected])  
							 from [dashboard].[bin_collection_report] where [bcr_date]=dt and [bcr_ward_id]=[cwm_id_pk] and bcr_bin_type_id=3 ) end ) attended_not_collected_bins
							 from dateRange,[garbage].[gis_garbage_collection_points] 
							  left join  admin.config_ward_master on [cwm_id_pk]=[ggcf_ward_id] left join 
							   admin.config_zone_master on cwm_zone_id_fk=czm_id_pk 
							   left join [admin].[config_bin_type] on Bin_type_id=[cbt_id_pk] 
							 where [cbt_type] LIKE 'COMP%'
							   -- where Bin_type_id= 3 
							 group by dt,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,czm_zone_name,[cwm_id_pk]) as t1

GO
/****** Object:  View [dbo].[compfilterforDash]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[compfilterforDash] as
with dateRange as( select dt = dateadd(dd, 1, CONVERT(date,  dateadd(day,datediff(day,7,GETDATE()),0)))  
							   where   dateadd(dd, 1, CONVERT(date,  dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()   union all 
							  select dateadd(dd, 1, dt) from dateRange where dateadd(dd, 1, dt) < GETDATE())  
							  select t_date,total_bins,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,czm_zone_name,[cwm_id_pk], 
							  case when collected_bins is null then 0 else collected_bins end as collected_bins, 
							  total_bins-((case when collected_bins is null then 0 else collected_bins end)+(case when attended_not_collected_bins is null then 0 else attended_not_collected_bins end)) as not_collected_bins ,
							  case when attended_not_collected_bins is null then 0 else attended_not_collected_bins end as attended_not_collected_bins from 
							  ( select FORMAT( dt,'dd-MM-yyyy') as t_date,sum([ggcf_points_count]) as total_bins,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name, 
							  czm_zone_name,[cwm_id_pk],(select case when dt=cast(getdate() as date) then sum(case when 
							  [ggcf_bin_collection_status]=1 then [ggcf_collected_bins] else 0 end) else (select sum([bcr_bin_collected]) 
							  from [dashboard].[bin_collection_report] where [bcr_date]=dt and [bcr_ward_id]=[cwm_id_pk] and bcr_bin_type_id=3) end ) 
							  collected_bins, 
							 ( select case when dt=cast(getdate() as date) then sum(case when 
							  [ggcf_bin_collection_status]=3 then [ggcf_points_count] else 0 end) else (select sum([bcr_bin_attended_not_collected])  
							  from [dashboard].[bin_collection_report] where [bcr_date]=dt and [bcr_ward_id]=[cwm_id_pk] and bcr_bin_type_id=3 ) end ) attended_not_collected_bins
							  from dateRange,[garbage].[gis_garbage_collection_points] 
							   left join  admin.config_ward_master on [cwm_id_pk]=[ggcf_ward_id] left join 
							    admin.config_zone_master on cwm_zone_id_fk=czm_id_pk  where Bin_type_id= 3 
							  group by dt,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,czm_zone_name,[cwm_id_pk]) as t1

GO
/****** Object:  View [dbo].[complaint_data_dashboad]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[complaint_data_dashboad]
AS 	
with dateRange as( select dt = dateadd(dd, 0,convert(varchar, getdate() - 30 , 25))  where dateadd(dd, 0,convert(varchar, getdate() - 30 , 25)) < =convert(varchar,getdate(), 25)  union all   select dateadd(dd, 1, dt)  from dateRange   where dateadd(dd, 1, dt) < =convert(varchar,getdate(), 25) )   select  CONVERT(varchar(10),dt,105) as dt,[czm_zone_name],[cwm_ward_name],cc_ward,cc_zone,cc_ulb_id_fk,sum(case when cast(cc_complaint_time as date)=cast(dt as date) then 1 else 0 end) AS TotalComp,  sum( case when cast(cc_complaint_time as date)=cast(dt as date) and (cc_compliant_status=1 Or cc_compliant_status=0) then 1 else 0 end ) notcc_compliant_status,     sum( case when cast(cc_complaint_time as date)=cast(dt as date) and cc_compliant_status=2 then 1 else 0 end)Compcc_compliant_status,[cc_id_pk],[sourceName]   from dateRange, [citizen].[citizen_complaints]   left join  [admin].[config_zone_master] on cc_zone=czm_id_pk left join  [admin].[config_ward_master] on cc_ward=cwm_id_pk   
 group by dt,cc_ward,cc_zone,cc_ulb_id_fk,czm_zone_name,cwm_ward_name,cc_complaint_type,[cc_id_pk]
 ,[sourceName]

GO
/****** Object:  View [dbo].[Completed_bin_status]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[Completed_bin_status]

AS


  select sum(tcd_collection_status) as tot_bin,cast([tcm_trip_date_time] as date)as date_time,[ggcf_ward_id] from  [reporting].[trip_completed_details] left join [reporting].[trip_completed_master] on  [tcm_id_pk]=[tcd_master_id_fk] left join [garbage].[gis_garbage_collection_points] on [ggcf_points_id_pk]=[tcd_bin_id_fk]  where tcd_collection_status=1 group by tcd_collection_status,cast([tcm_trip_date_time] as date),[ggcf_ward_id]

GO
/****** Object:  View [dbo].[completed_trip_Bin CollectionData]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[completed_trip_Bin CollectionData]

AS

select tcd_master_id_fk as trip_id,cfm_vehicle_no as vehicleNo,tcm_trip_date_time as trip_date,
ggcf_points_name as bin_location,ulbm_tenant_code,cbm_binRroad_status,
crm_bin_lat as lat,crm_bin_long as lon,
case when (select staffName from [dbo].[fnAppendString](tcm_trip_id_fk)) is null then '--' else
(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk)) end as staffname
,case when staff.cssm_staff_name is null then '---' else staff.cssm_staff_name end as driverr_staff_name,
[cbm_bin_loc_id],
[cbm_bin_name] as bin_name,[cbm_id_pk] as bin_id,case when [tcrd_date_time] is null then 0 else 1 end as collection_status,
case when [cbm_person_name] is null then '---' else [cbm_person_name] end as [cbm_person_name],
case when [cbm_house_no] is null or [cbm_house_no] = '' then '---' else [cbm_house_no] end as [cbm_house_no],
case when tcrd_lat is null then 0 else tcrd_lat end as tcrd_lat1,case when [tcrd_long] is null then 0 else [tcrd_long] end as [tcrd_long1],[tcd_bin_name]

  from [admin].[config_bin_master] 
 inner join [reporting].[trip_completed_details] on [tcd_bin_id_fk]=[cbm_bin_loc_id] 
 left join [reporting].[trip_completed_rfid_details] on [tcrd_trip_ongoing_details_id_fk]=[tcd_id_pk] and [tcrd_bin_id_fk]=[cbm_id_pk]
 left join admin.config_rfid_master on crm_bin_id=cbm_id_pk
 left join  [reporting].trip_completed_master on [tcm_id_pk]=[tcd_master_id_fk]
 left join admin.config_fleet_master on tcm_vehicle_id_fk  = cfm_id_pk
 left join admin.config_staff_master as staff on staff.cssm_id_pk = tcm_driver_id_fk 
 left join garbage.gis_garbage_collection_points on ggcf_points_id_pk = cbm_bin_loc_id
 left join admin.urban_local_body_master on ulbm_id_pk=tcm_ulb_id_fk

GO
/****** Object:  View [dbo].[completed_trip_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[completed_trip_details_view]

AS

select cbm_binRroad_status,crm_bin_lat as tcrd_lat,crm_bin_long as  tcrd_long,crm_bin_lat as lat,crm_bin_long as lon,[cbm_bin_loc_id],[cbm_bin_name],[cbm_id_pk],case when [tcrd_date_time] is null then '---' else CONVERT(varchar(20),[tcrd_date_time],120) end as [tcrd_date_time],case when [tcrd_date_time] is null then 0 else 1 end as collection_status,tcd_master_id_fk,case when [cbm_person_name] is null then '---' else [cbm_person_name] end as [cbm_person_name],case when [cbm_house_no] is null or [cbm_house_no] = '' then '---' else [cbm_house_no] end as [cbm_house_no],case when tcrd_lat is null then 0 else tcrd_lat end as tcrd_lat1,case when [tcrd_long] is null then 0 else [tcrd_long] end as [tcrd_long1],[tcd_bin_name]
 from [admin].[config_bin_master] 
 inner join [reporting].[trip_completed_details] on [tcd_bin_id_fk]=[cbm_bin_loc_id] 
 left join [reporting].[trip_completed_rfid_details] on [tcrd_trip_ongoing_details_id_fk]=[tcd_id_pk] and [tcrd_bin_id_fk]=[cbm_id_pk]
 left join admin.config_rfid_master on crm_bin_id=cbm_id_pk

GO
/****** Object:  View [dbo].[completed_trip_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[completed_trip_view]

AS

 select  singleBinArea_FK, Maitenance, stm_end_time, fleet1.cfc_id_pk as vehTypeId,fleet1.cfc_type as vehTypeCategory,[cwm_ward_name],[czm_zone_name],[cfm_zone_id],[cfm_ward_id],tcm_trip_date_time as trip_time, cfm_ulb_id_fk,tcm_trip_status,case when tcm_trip_id_fk is null then '---' else tcm_trip_id_fk end as tcm_trip_id_fk,case when tcm_route_id_fk is null then '---' else tcm_route_id_fk end as tcm_route_id_fk,tcm_id_pk,
case when tcm_start_date_time is null then '---' else CONVERT(varchar(10),tcm_start_date_time,105)+' '+CONVERT(varchar(8),tcm_start_date_time,108) end as tcm_start_date_time,
case when tcm_trip_date_time is null then '---' else CONVERT(varchar(10),tcm_trip_date_time,105)+' '+CONVERT(varchar(10),tcm_trip_date_time,108) end as tcm_trip_date_time,
tcm_weight_disposed,case when tcm_start_location is null then '--'else tcm_start_location end as start_location ,case when tcm_end_location is null then'--' else tcm_end_location end as end_location,
case when tcm_received_weight is null then '--' else tcm_received_weight end as tcm_received_weight,case when tcm_dump_entry_time is null then '---' else CONVERT(varchar(10),tcm_dump_entry_time,105)+' '+CONVERT(varchar(8),tcm_dump_entry_time,108) end as tcm_dump_entry_time, 
case when tcm_end_date_time is null then '---' else CONVERT(varchar(10),tcm_end_date_time,105)+' '+CONVERT(varchar(8),tcm_end_date_time,108) end as tcm_end_date_time,
CONVERT(varchar(3),DATEDIFF(minute,tcm_start_date_time, tcm_end_date_time)/60) + ':' + RIGHT('0' + CONVERT(varchar(2),DATEDIFF(minute,tcm_start_date_time,tcm_end_date_time)%60),2) as TurnaroundTime,
tcm_shift_id_fk,tcm_dumping_ground,tcm_driver_id_fk,case when staff.cssm_staff_name is null then '---' else staff.cssm_staff_name end as cssm_staff_name,fleet.cfm_vehicle_no,fleet.cfm_id_pk,case when routedata.rm_route_name is null then '---' else routedata.rm_route_name end as rm_route_name,shift.csm_shift_name,[rm_geom].STAsText() as latlon,(select count(tcd_id_pk) from reporting.trip_completed_details where tcd_master_id_fk=tcm_id_pk) as collection_points,vom_vehicle_type+convert(varchar(10),vom_status)image_name,case when [tcm_trip_distance] is null then '0' else  [tcm_trip_distance] end as Distance,tcm_route_type,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk)) as staffname
 ,tcm_start_date_time as StartDateTime,tcm_end_date_time as EndDateTime, online.[vom_latitude]as onlineLat,online.[vom_longitude]  as onlineLon
 from reporting.trip_completed_master left join admin.config_fleet_master as fleet on tcm_vehicle_id_fk=fleet.cfm_id_pk 
left join admin.config_fleet_category as fleet1 on fleet.cfm_vehicle_type_id_fk=fleet1.cfc_id_pk left join garbage.route_master as routedata on routedata.rm_id_pk=tcm_route_id_fk left join admin.config_shift_master as shift on shift.csm_id_pk=tcm_shift_id_fk 
left join admin.config_staff_master as staff on staff.cssm_id_pk = tcm_driver_id_fk	left join   dbo.view_online_master as online on online.vom_vehicle_id=tcm_vehicle_id_fk
								left join [admin].[config_ward_master] on [cwm_id_pk]=[cfm_ward_id] left join [admin].[config_zone_master] on [czm_id_pk]=[cfm_zone_id] 
								left join [scheduling].[schedule_trip_master] on [stm_id_pk]=tcm_id_pk

GO
/****** Object:  View [dbo].[config_mobile_user_master_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[config_mobile_user_master_view]

AS

select cmum_id_pk,cmum_user_name,cmum_login_name,cmum_mobile,cmum_address,cmum_email,cmum_user_type,cmum_license_key,cmum_driver_id,cmum_employee_id,cmum_ulb_id_fk,cmum_vehicle_id,cut_type,czm_zone_name,cwm_ward_name,cssm_staff_name,case when cfm_vehicle_no is null then '0' else cfm_vehicle_no end as cfm_vehicle_no from admin.config_mobile_user_master left join [admin].[config_staff_master] on cssm_id_pk=cmum_driver_id left join  [admin].[config_user_type] on cmum_user_type= cut_id_pk left join admin.config_zone_master on [cmum_zone_id]=czm_id_pk left join admin.config_ward_master on [cmum_ward_id]=cwm_id_pk left join admin.config_fleet_master on [cmum_vehicle_id]=cfm_id_pk

GO
/****** Object:  View [dbo].[dashboard_count_for_all_types]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[dashboard_count_for_all_types] as

select bcdr_date as t_date,count(*) as total_bins, sum(case when bcdr_bin_collected_status=0 then 1 else 0 end) not_collected_bins, ISNULL(sum(case when bcdr_bin_collected_status=0 then 1 else 0 end)*100.0/NULLIF(count(*),0),0) not_collected_bins_percetg ,
sum(case when bcdr_bin_collected_status=1 then 1 else 0 end) collected_bins,ISNULL(sum(case when bcdr_bin_collected_status=1 then 1 else 0 end)*100.00/NULLIF(count(*),0),0) collected_bins_percentg,bcdr_ulb_id_fk,[cbm_binType],[cbm_zone_id],[cbm_ward_id],[czm_zone_name],[cwm_ward_name] from [reports].[bin_collection_detailed_report] left join [admin].[config_bin_master] on bcdr_bin_id=cbm_id_pk left join [admin].[config_zone_master] on [cbm_zone_id]=[czm_id_pk] left join [admin].[config_ward_master] on [cbm_ward_id]=[cwm_id_pk]
where  bcdr_date between  dateadd(dd, 0,convert(varchar, getdate() - 8 , 25)) and dateadd(dd, 0,convert(varchar, getdate() - 0 , 25)) group by bcdr_date,[cbm_zone_id],[cbm_ward_id],[czm_zone_name],[cwm_ward_name],[cbm_binType],bcdr_ulb_id_fk

GO
/****** Object:  View [dbo].[door2door_total_status]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[door2door_total_status]

AS

/*select tom_vehicle_id_fk,cfm_vehicle_no,tom_trip_id_fk,sum(tod_bins_to_be_collected),sum(tod_bins_collected),tom_trip_schedule_date_time from reporting.trip_ongoing_master left join [admin].[config_fleet_master] on cfm_id_pk=tom_vehicle_id_fk left join reporting.trip_ongoing_details on tom_id_pk=tod_master_id_fk group by tom_trip_id_fk,tom_vehicle_id_fk,cfm_vehicle_no,tom_trip_schedule_date_time*/



/*select cfm_id_pk,cfm_vehicle_no,tod_bins_to_be_collected,cast(crm_bin_collection_time as date )as dttime,sum(case when crm_bin_collection_status =1 then 1 else 0 end)as totalcollected   from  reporting.trip_ongoing_details left join  reporting.trip_ongoing_master on tom_id_pk=tod_master_id_fk left join [garbage].[gis_garbage_collection_points] on [ggcf_points_id_pk]= tod_bin_id_fk left join  [garbage].[route_master] on [rm_id_pk] =[tod_route_id]left join   [garbage].[route_details] on [rd_check_point_id_fk] =[tod_bin_id_fk] and [rd_route_id_fk]=[tod_route_id]
	left join   reporting.trip_ongoing_captured_data on tom_trip_id_fk=tocd_trip_id_fk and tod_bin_id_fk=tocd_bin_id_fk  left join [admin].[config_fleet_master] on cfm_id_pk=tom_vehicle_id_fk left join  admin.config_bin_master on cbm_zone_id=cfm_zone_id 
	left join [admin].[config_rfid_master] on crm_bin_id=cbm_id_pk group by cfm_vehicle_no,tod_bins_to_be_collected,cfm_id_pk,cast(crm_bin_collection_time as date )*/

	select [dbcdr_bin_collected_status],[dbcdr_bin_id],[dbcdr_road_id],[dbcdr_zone_id],[dbcdr_ward_id],[dbcdr_ulb_id_fk],[dbcdr_vehicle_id_fk],[dbcdr_collected_time],[dbcdr_house_holder_name],[dbcdr_date],[cwm_ward_name],[czm_zone_name] from (select [dbcdr_bin_collected_status],[dbcdr_bin_id],[dbcdr_road_id],[dbcdr_zone_id],[dbcdr_ward_id],[dbcdr_ulb_id_fk],[dbcdr_vehicle_id_fk],[dbcdr_collected_time],[dbcdr_house_holder_name],[dbcdr_date] FROM [reports].[dtd_bin_collection_detailed_report]

	union all(SELECT [crm_bin_collection_status],[crm_bin_id],[crm_bin_loc_id_fk],[crm_zone_id],[crm_ward_id],[crm_ulb_id_fk],0,[crm_bin_collection_time],[cbm_person_name],cast(getdate() as date) from [admin].[config_rfid_master] LEFT JOIN [admin].[config_bin_master] on [cbm_id_pk]=[crm_bin_id] where [crm_bin_collection_status]=1)
	)as t1  left join [admin].[config_ward_master] on [cwm_id_pk]=[dbcdr_ward_id] left join [admin].[config_zone_master] on [czm_id_pk]=[dbcdr_zone_id]

GO
/****** Object:  View [dbo].[fence_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[fence_details_view]
AS
	SELECT case when crd_imei_no is null then '--' else  crd_imei_no end as crd_imei_no,crd_id_pk,case when ward.cwm_ward_name is null then '----' else ward.cwm_ward_name end as cwm_ward_name,case when zone.czm_zone_name is null then '----' else zone.czm_zone_name end as czm_zone_name,gdg_id_pk, gdg_name, fence_type, gdg_the_geom.STAsText() as latlon,case when gdg_created_date is null then '----' else convert(varchar(10),cast (gdg_created_date as date),105)+' '+convert(varchar(8),gdg_created_date,108 ) end as date,gdg_ward_id,[gdg_zone_id],gdg_ulb_id_fk, CamId_FK, cameraURL, gdg_the_geom FROM garbage.gis_dumping_grounds left Join admin.config_ward_master as ward on gdg_ward_id=ward.cwm_id_pk left join [admin].[config_rfid_reader] on crd_ts_dg=[gdg_id_pk] left Join admin.config_zone_master as zone on gdg_zone_id=zone.czm_id_pk left join [admin].[DeviceManagementDetails] on pk_DeviceID=CamId_FK

GO
/****** Object:  View [dbo].[Fleets_forPredict]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[Fleets_forPredict]
WITH SCHEMABINDING
AS
select cfm_id_pk,cfm_vehicle_no,cfm_vehicle_type_id_fk,cfc_type,cfm_zone_id,vom_latitude,vom_longitude,cfm_fleet_capacity,
 bin_type_id from   [admin].[config_fleet_master]
						join   [dbo].[view_online_master] on vom_vehicle_id=cfm_id_pk join   
						[admin].[config_fleet_category] on cfc_id_pk=cfm_vehicle_type_id_fk
						 where cfm_vehicle_available_status ='1' AND cfm_maintenance_status='0' 
						 AND vom_status in(1,3)

GO
/****** Object:  View [dbo].[garbage_bin_alerts_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[garbage_bin_alerts_view]
AS
select the_geom.STX as lon,bsal_ulb_id_pk,the_geom.STY as lat,bsal_id_pk,cbm_binType,cbsm_bin_id,[cbsm_zone_id],[cbsm_ward_id],[cbsm_bin_latitude],[cbsm_bin_longitude],bsal_bin_name,dtm_mac_address,bsal_bin_skippedfull_status,bsal_bin_loc_id as ggcf_points_id_pk,bsal_bin_location as ggcf_points_name,3 as priority,
 case when cbm_binType=1 then (select binName from [dbo].[fnGetBins] (ggcf_points_id_pk,0,2)) else (select binName from [dbo].[fnGetBins] (ggcf_points_id_pk,0,3)) end as binId,case when convert(varchar(20),bsal_date_time,120) is null then '--' else convert(varchar(20),bsal_date_time,120) end as bsal_date_time,bsal_source_name from 
[dbo].[bin_sensor_alert_log] left join [admin].[config_bin_master] on bsal_bin_id=[cbm_id_pk] left join [admin].[config_bin_sensor_master] on bsal_bin_id=cbsm_bin_id
 left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = bsal_bin_loc_id where [bsal_assign_status]=0 and bsal_bin_skippedfull_status in (1,2)

GO
/****** Object:  View [dbo].[garbage_weight_details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[garbage_weight_details] as

--select ROW_NUMBER() OVER(order BY gdg_name ASC) AS SLNo,case when gdg_name is null then '---' else gdg_name end as dumpName,
--case when sum([tcm_weight_disposed]) is null then 0 else sum([tcm_weight_disposed]) end as  dumpWeight,
--CASE WHEN SUM(tcm_received_weight) IS NULL THEN 0 ELSE SUM(tcm_received_weight) END as recWeight ,count(distinct tcm_vehicle_id_fk) as 
--vehiclecount,count(tcm_trip_id_fk) as tripcount,gdg_ulb_id_fk,gdg_zone_id,gdg_ward_id from [garbage].[gis_dumping_grounds] asd left join 
--[reporting].[trip_completed_master] on [tcm_dumping_ground]= gdg_name and cast([tcm_trip_date_time] as date)=cast(getdate() as date)left join 
--[admin].[config_rfid_reader] on crd_ts_dg=gdg_id_pk group by gdg_name,gdg_ulb_id_fk,gdg_zone_id,gdg_ward_id

select ROW_NUMBER() OVER(order BY gdg_name,cast(dwd_updated_date as date) ASC) AS SLNo,case when gdg_name is null then '---' else gdg_name end as dumpName,
sum(case when dwd_disposed_weight is null and [net_weight_stable]=0 then 0 else dwd_disposed_weight end) as  dumpWeight,
SUM(CASE WHEN  dwd_weight IS NULL and gross_weight_stable=0 THEN 0 ELSE dwd_weight END)   as recWeight ,
0 as vehiclecount,
0 as tripcount,gdg_ulb_id_fk,gdg_zone_id,gdg_ward_id,czm_zone_name as zone, cwm_ward_name as ward, cast(dwd_updated_date as date) as date
from [garbage].[gis_dumping_grounds] asd 
left join [reports].[dump_weight_details] on dwd_dgwdid_fk=gdg_id_pk --and 
--cast(dwd_updated_date as date)=cast(getdate() as date)
left join [admin].[config_rfid_reader] on crd_ts_dg=gdg_id_pk 
left join admin.config_zone_master on gdg_zone_id=czm_id_pk
left join admin.config_ward_master on gdg_ward_id=cwm_id_pk
group by gdg_name,cast(dwd_updated_date as date),gdg_ulb_id_fk,gdg_zone_id,gdg_ward_id,czm_zone_name,cwm_ward_name

GO
/****** Object:  View [dbo].[get_Bin_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[get_Bin_details_view]
AS
	SELECT CollectionStatusTypeFK,CamId_FK, cameraURL, bin_Demand_TypeId,case when bdt_type is null then '----' else bdt_type end as bdt_type, ggcf_ulb_id_fk,ggcp.the_geom.STAsText() as [the_geom],[the_fence_geom].STAsText() as the_fence_geom,case when ward.cwm_ward_name is  null then '----' else ward.cwm_ward_name end  as cwm_ward_name,case when zone.czm_zone_name is null then '----' else zone.czm_zone_name end  as czm_zone_name ,ggcf_points_id_pk,ggcf_points_name,ggcf_points_count,ggcf_points_address,ggcf_zone_id,case when ggcf_created_date is  null then '----' else convert(varchar(10),cast (ggcf_created_date as date),105)+' '+convert(varchar(8),ggcf_created_date,108 ) end as date,geometry::STGeomFromText(CONVERT(nvarchar(50),ggcp.the_geom), 4326).STX as lat,geometry::STGeomFromText(CONVERT(nvarchar(50),ggcp.the_geom), 4326).STY as lon,the_radious,
	   ggcf_ward_id,cbt_type,cbt_id_pk,ggcf_bin_collection_status,ggcf_minfrequency,case when cbt_id_pk=1 then (select binName from [dbo].[fnGetBins] (ggcf_points_id_pk,0,2)) else (select binName from [dbo].[fnGetBins] (ggcf_points_id_pk,0,3)) end as binId, case when ggcf_last_collected_date is null then '-- -- --' else convert(varchar(10),ggcf_last_collected_date,105)+' '+convert(varchar(8),ggcf_last_collected_date,14) end ggcf_last_collected_date 
 FROM garbage.gis_garbage_collection_points ggcp 
left join [admin].[config_bin_type] as type on Bin_type_id = type.cbt_id_pk 
left join [admin].[BinDemandType] on bdt_id_pk=bin_Demand_TypeId
left Join admin.config_ward_master as ward on ggcf_ward_id=ward.cwm_id_pk left Join admin.config_zone_master as zone on ggcf_zone_id=zone.czm_id_pk
left join [admin].[DeviceManagementDetails] on pk_DeviceID=CamId_FK

GO
/****** Object:  View [dbo].[get_route_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[get_route_details_view]
AS
	select  [Bin_type_id], [CollectionStatusTypeFK], bin_Demand_TypeId,demandFreq_Status,rm_ulb_id_fk,rm_created_date,rm_type,rm_route_name,rm_id_pk,rd_the_geom.STAsText() as rm_route_point ,ulb.ulbm_name,rm_geom.STAsText() as rm_geom,rm_ward_id,CASE WHEN ward.cwm_ward_name is null then '----' else ward.cwm_ward_name end as cwm_ward_name,rm_fence_geom.STAsText()
	as rm_fence,rm_zone_id,zone.czm_zone_name,case when rm_created_date is null then '--' else convert(varchar(10),rm_created_date,105)+' '+convert(varchar(8),rm_created_date,108) end as date,rm_created_by,(select case when count(*)>0 then 1 else 0 end from scheduling.schedule_trip_master 
	where stm_route_id_fk=rm_id_pk and stm_status in (1,0)) as  trip_status from [garbage].[route_master] 
	left join [admin].[urban_local_body_master] ulb on rm_ulb_id_fk=ulb.ulbm_id_pk left join
	[garbage].[route_details] route on rm_created_by = route.rd_route_id_fk 
	left Join admin.config_ward_master as ward on rm_ward_id = ward.cwm_id_pk 
	left Join admin.config_zone_master as zone on rm_zone_id = zone.czm_id_pk

GO
/****** Object:  View [dbo].[getAttandanceChartDataMyforDash_Staff_veiw]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[getAttandanceChartDataMyforDash_Staff_veiw] as
with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0)))   
							 where dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()  union all  
						 select dateadd(dd, 1, dt)from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
						   select distinct dt,sar_ulb_id_fk,sum(case when  sar_staff_type_id IN (1,2,3,4) then 1 else 0 end )  as dsa_total_staff_count, 
						  sum(case when sar_staff_status=1 then 1 else 0 end ) as dsa_staff_present_count, 
						   sum(case when sar_staff_status=0 then 1 else  0 end) as dsa_staff_absent_count 
						    from dateRange left join  [reports].[staff_attendance_report] on   CONVERT(date, sar_date) = dt 
						  group by dt,sar_date,sar_ulb_id_fk

GO
/****** Object:  View [dbo].[getAttandanceChartDataMyforDash_veiw]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[getAttandanceChartDataMyforDash_veiw]
AS 
with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0)))   
					 where dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()  union all  
				 select dateadd(dd, 1, dt)from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
				   select distinct dt,sum(case when  sar_staff_type_id IN (1,2,3,4) then 1 else 0 end )  as dsa_total_staff_count, 
				  sum(case when sar_staff_status=1 then 1 else 0 end ) as dsa_staff_present_count, 
				  sum(case when sar_staff_status=0 then 1 else  0 end) as dsa_staff_absent_count,sar_ulb_id_fk 
				    from dateRange left join  [reports].[staff_attendance_report] on   CONVERT(date, sar_date) = dt 
			 
				  group by dt,sar_date,sar_ulb_id_fk

GO
/****** Object:  View [dbo].[getCepAlerts]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[getCepAlerts]

AS


 select *,cc_citizen_geom.STY as Lat,cc_citizen_geom.STX as Lon FROM [citizen].[citizen_complaints] left join [citizen].[citizen_complaints_type] on cc_complaint_type=[cct_id_pk] where [sourceName] in('CEP','Citizen App')

GO
/****** Object:  View [dbo].[getscheduleDetailsFromDB]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[getscheduleDetailsFromDB]

AS

select stm_id_pk,cfm_ulb_id_fk,case when stm_date_time is null then '--' else convert(varchar(10),stm_date_time,105)+' '+convert(varchar(8),stm_date_time,108) end as date,fleet.cfm_vehicle_no,dumping.gdg_name,case when gis1.gcf_poi_name is null then '--' else gis1.gcf_poi_name end as startlocat,case when gis2.gcf_poi_name is null then '--' else gis2.gcf_poi_name end as endlocat,rt.rm_route_name,shift.csm_shift_name,cfc_type,case when cssm_staff_name is null then '--' else cssm_staff_name end as cssm_staff_name, ( SELECT case when staffName is null then '--' else staffName end as staffName from fnAppendString(stm_id_pk) )as staff_name,stm_status from scheduling.schedule_trip_master   left join [garbage].[gis_client_fence] gis1 on stm_start_location=gis1.gcf_id_pk  left join [garbage].[gis_client_fence] gis2 on stm_end_location=gis2.gcf_id_pk LEFT join admin.config_fleet_master as fleet on stm_vheicle_id_fk=fleet.cfm_id_pk LEFT JOIN admin.config_fleet_category ON cfc_id_pk=cfm_vehicle_type_id_fk left join admin.config_staff_master ON cssm_id_pk=stm_driver_id_fk LEFT join garbage.gis_dumping_grounds as dumping on dumping.gdg_id_pk=stm_end_location LEFT join garbage.route_master as rt on rt.rm_id_pk=stm_route_id_fk LEFT join admin.config_shift_master as shift on shift.csm_id_pk=stm_shift_id_fk where stm_status in (0,1)

GO
/****** Object:  View [dbo].[getTripDataForNewCReports]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[getTripDataForNewCReports]

AS

select  TripId, gcf.gcf_address as tripStartLoc,gcf1.gcf_address as tripEndLoc,vehID,
case when stmStatus=0 then 'Pending' when stmStatus=1 then 'OnGoing' when stmStatus=2 then 'Completed' end as stmStatus,
scheduleDatetime,
TodbinName,todBinEntrytm,todBinExittm,rtId,tripStartLocId,tripEndLocId,shiftname,cmst1.cfm_vehicle_no,cmst1.cfm_id_pk,
  shm1.csm_shift_name,rmst1.rm_route_name,stm_date_time from (
  select tom_trip_id_fk as TripId,stm.stm_vheicle_id_fk as vehID ,stm.stm_status as stmStatus,
  
 case when  stm.stm_date_time is null then '--- '  else  CONVERT(VARCHAR(10), stm.stm_date_time,105)+' '+ CONVERT(VARCHAR(8), stm.stm_date_time,108)
   end as scheduleDatetime,
 -- stm.stm_date_time as scheduleDatetime,

  tod.tod_bin_name as TodbinName,

  case when  tod.tod_bin_entry_time is null then '--- '  else  CONVERT(VARCHAR(10), tod.tod_bin_entry_time,105)+' '+ CONVERT(VARCHAR(8), tod.tod_bin_entry_time,108)
   end  as todBinEntrytm,
  --tod.tod_bin_entry_time

   case when  tod.tod_bin_exit_time is null then '--- '  else  CONVERT(VARCHAR(10), tod.tod_bin_exit_time,105)+' '+ CONVERT(VARCHAR(8), tod.tod_bin_exit_time,108)
   end  as todBinExittm,
 -- tod.tod_bin_exit_time as todBinExittm ,
  
  tom.tom_route_id_fk as rtId
  ,tom.tom_start_location as tripStartLocId,tom.tom_end_location as     tripEndLocId,
  stm.stm_shift_id_fk as shiftname,stm.stm_date_time
  from [scheduling].[schedule_trip_master] stm
  left join [reporting].[trip_ongoing_master] tom on stm.stm_vheicle_id_fk=tom.tom_vehicle_id_fk
  left join [reporting].[trip_ongoing_details] tod on tom.tom_id_pk=tod.tod_master_id_fk
  union all
  select tcm_trip_id_fk as TripId,stm1.stm_vheicle_id_fk as vehID,stm1.stm_status as stmStatus,
  
  case when  stm1.stm_date_time is null then '--- '  else  CONVERT(VARCHAR(10), stm1.stm_date_time,105)+' '+ CONVERT(VARCHAR(8), stm1.stm_date_time,108)
   end as scheduleDatetime,
 -- stm1.stm_date_time as scheduleDatetime,
  tcd.tcd_bin_name as TodbinName,
  
  case when  tcd.tcd_bin_entry_time is null then '--- '  else  CONVERT(VARCHAR(10), tcd.tcd_bin_entry_time,105)+' '+ CONVERT(VARCHAR(8), tcd.tcd_bin_entry_time,108)
   end  as todBinEntrytm,
 -- tcd.tcd_bin_entry_time as todBinEntrytm,

   case when  tcd.tcd_bin_exit_time is null then '--- '  else  CONVERT(VARCHAR(10), tcd.tcd_bin_exit_time,105)+' '+ CONVERT(VARCHAR(8), tcd.tcd_bin_exit_time,108)
   end  as todBinExittm,
  --tcd.tcd_bin_exit_time as todBinExittm,
  
  tcm.tcm_route_id_fk as rtId,'' as tripStartLoc,'' as tripEndLoc,
  stm1.stm_shift_id_fk as shiftname,stm1.stm_date_time
   from [scheduling].[schedule_trip_master] stm1
  left join [reporting].[trip_completed_master] tcm on stm1.stm_vheicle_id_fk=tcm.tcm_vehicle_id_fk
  left join [reporting].[trip_completed_details] tcd on tcm.tcm_id_pk=tcd.tcd_master_id_fk
  ) as temp 
  left join [admin].[config_fleet_master] cmst1 on cmst1.cfm_id_pk=vehID
  left join [admin].[config_shift_master] shm1 on shiftname=shm1.csm_id_pk
  left join [garbage].[route_master] rmst1 on rmst1.rm_id_pk=rtId
  left join [garbage].[gis_client_fence] gcf on gcf.gcf_id_pk=tripStartLocId
  left join [garbage].[gis_client_fence] gcf1 on gcf1.gcf_id_pk=tripEndLocId

  group by TripId, gcf.gcf_address ,gcf1.gcf_address ,vehID,
 stmStatus,
scheduleDatetime,
TodbinName,todBinEntrytm,todBinExittm,rtId,tripStartLocId,tripEndLocId,shiftname,cmst1.cfm_vehicle_no,cmst1.cfm_id_pk,
  shm1.csm_shift_name,rmst1.rm_route_name,stm_date_time

GO
/****** Object:  View [dbo].[getVehiclesDataForNewCReports]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[getVehiclesDataForNewCReports]

AS




select * from (select  row_number() over (partition by cfm_id_pk order by tom_trip_status desc,tom_trip_id_fk) as selectrow,sum(ttod.tod_bins_collected) as collected,
sum(tod_bins_to_be_collected ) as notcoll,  
cfm_id_pk,cfm_ward_id,
 cfm_vehicle_no,cfc_type,cfm_vehicle_available_status,vom_placename,vom_speed,vom_status,
 [rd_distance] as vom_route_distance,cfm_maintenance_status,cfm_fleet_capacity,vom_batterystatus,
  vom_gpsstatus,vom_latitude,vom_longitude,cfm_mileage,case when  vom_utc_date_time is null then '--- '  else  CONVERT(VARCHAR(10), vom_utc_date_time,105)+' '+ CONVERT(VARCHAR(8), vom_utc_date_time,108)
   end as vom_utc_date_time,cssm_staff_name,tom_trip_status,
  tom_trip_id_fk,case when rm_route_name is null then '' else rm_route_name  end as rm_route_name ,case when tod_bins_to_be_collected is null then 0 else tod_bins_to_be_collected end as tod_bins_to_be_collected,case when tod_bins_collected is null then 0 else tod_bins_collected end as tod_bins_collected,csm_shift_name,
  tod_bin_name,
  tom_trip_schedule_date_time,tom_start_date_time,tom_end_date_time,
  aa.gcf_poi_name as tom_start_location,
 ab.gcf_poi_name as tom_end_location,
 cfm_zone_id as zone


   from [admin].[config_fleet_master] cfm 
 left join [admin].[config_fleet_category] cfc on cfm.cfm_vehicle_type_id_fk=cfc.cfc_id_pk
 left join [dbo].[view_online_master] vom on vom.vom_vehicle_id=cfm.cfm_id_pk
 left join [reporting].[trip_ongoing_master] tomstr on cfm.cfm_id_pk =tomstr.tom_vehicle_id_fk  
left join  [scheduling].[schedule_trip_master] sch on sch.stm_vheicle_id_fk=cfm.cfm_id_pk AND tomstr.tom_trip_status IS NOT NULL AND tomstr.tom_trip_status IN (0,1) and cast(tom_trip_schedule_date_time as date) =cast(getdate() as date)
 left join [admin].[config_staff_master] csmstr on sch.stm_driver_id_fk=csmstr.cssm_id_pk and cssm_staff_type=4
left join  [admin].[config_shift_master] cssm on tomstr.tom_shift_id_fk=cssm.csm_id_pk 
left join [garbage].[route_master] rm on tomstr.tom_route_id_fk=rm.rm_id_pk
left join [reports].[report_distance] on [rd_vehicle_id]=cfm_id_pk and cast([rd_date_time] as date)=cast(getdate() as date)
left join [reporting].[trip_ongoing_details] ttod on tomstr.tom_id_pk=ttod.tod_master_id_fk
left join [garbage].[gis_client_fence] aa on tom_start_location=aa.gcf_id_pk
left join [garbage].[gis_client_fence] ab on tom_end_location=ab.gcf_id_pk 
where cfm_ward_id is not null and cfm_zone_id is not null



  group by cfm_id_pk,tom_trip_status,
cfm_vehicle_no,cfc_type,cfm_vehicle_available_status,vom_placename,vom_speed,vom_status,
  vom_route_distance,cfm_maintenance_status,cfm_fleet_capacity,vom_batterystatus,
  vom_gpsstatus,vom_latitude,vom_longitude,cfm_mileage,vom_utc_date_time,cssm_staff_name,tom_trip_status,
  tom_trip_id_fk,rm_route_name,tod_bins_to_be_collected,tod_bins_collected,csm_shift_name,
  tod_bin_name,tom_start_location,tom_end_location,cfm_zone_id,
  tom_trip_schedule_date_time,tom_start_date_time,tom_end_date_time,[rd_distance],aa.gcf_poi_name,ab.gcf_poi_name,cfm_ward_id,cfm_zone_id
 )as t1 where selectrow=1

GO
/****** Object:  View [dbo].[halt_report_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[halt_report_view]

AS

select hr_vehicle_id_fk,case when hr_latitude is null then 0 else hr_latitude end as hr_latitude,
CONVERT(datetime,hr_startdate_time) as hr_startdate_time,
CONVERT(datetime,hr_enddate_time) as hr_enddate_time,
			case when hr_longitude is null then 0 else hr_longitude end as hr_longitude,hr_vehicle_no,
			CASE WHEN hr_location IS NULL  THEN '--- ---- ----' ELSE hr_location END AS hr_location,hr_ulb_id,
		--convert(VARCHAR(10), dateadd(mi,hr_duration,'00:00:00'), 108) as hr_time,
		--CONVERT(VARCHAR(8),dateadd(mi,hr_duration,'00:00:00'),14) as hr_time2,
		CONVERT(time,CONVERT(VARCHAR(8),dateadd(mi,hr_duration,'00:00:00'),14)) as hr_time3
		--hr_duration
			
			  from (
Select hr_vehicle_no,hr_vehicle_id_fk,
--hr_startdate_time,hr_enddate_time,
CONVERT(datetime,hr_startdate_time) as hr_startdate_time,
CONVERT(datetime,hr_enddate_time) as hr_enddate_time,
hr_location, hr_latitude,hr_longitude,case when hr_enddate_time is null then datediff
			  (mi, hr_startdate_time ,FORMAT( GETDATE(), 'yyyy-MM-dd HH:mm:ss')) 
			else datediff(mi, hr_startdate_time , hr_enddate_time)  end AS hr_duration,hr_ulb_id from reports.halt_report
			) as d
			--where CONVERT(datetime,hr_startdate_time) between '2017-06-10 10:12:45' and '2017-10-10 10:12:45'
			--AND  hr_duration>60  order by hr_startdate_time desc

			--select CONVERT (date, GETDATE()+'' )  --18-11-2016 11:10:45
			--FORMAT( GETDATE(), 'dd/MM/yyyy')
			--SELECT SYSDATETIME()  
    --,CURRENT_TIMESTAMP  
    --,FORMAT( GETDATE(), 'dd-MM-yyyy HH:mm:ss');  


	--select * from reports.halt_report

GO
/****** Object:  View [dbo].[ICOP_Bin_Collection_status]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[ICOP_Bin_Collection_status]

AS

 select cbm_bin_name as binId,case when ggcf_points_name is null then '' else ggcf_points_name end as binLocation,case when cbsm_bin_latitude is  null then 0 else cbsm_bin_latitude end  as latitude,case when cbsm_bin_longitude is null then 0 else cbsm_bin_longitude end as longitude,case when cbsm_collection_status=0 then 'notCollected' else 'collected' end as binStatus from  admin.config_bin_sensor_master
 left join admin.config_bin_master on cbsm_bin_id=cbm_id_pk
 left join garbage.gis_garbage_collection_points on ggcf_points_id_pk=cbsm_bin_loc_id
 where cbm_binRroad_status =0 and ggcf_points_name is not null and cbm_bin_name is not null

GO
/****** Object:  View [dbo].[ongoing_trip_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[ongoing_trip_details_view]

AS

select cbm_binRroad_status,crm_bin_lat as rreb_lat,crm_bin_long as rreb_long, crm_bin_lat as lat,crm_bin_long as lon,[cbm_bin_loc_id],[cbm_bin_name],[cbm_id_pk],case when [rreb_date_time] is null then '---' else CONVERT(varchar(20),[rreb_date_time],120) end as [rreb_date_time],case when [rreb_date_time] is null then 0 else 1 end as collection_status,tod_master_id_fk,case when [cbm_person_name] is null then '---' else [cbm_person_name] end as [cbm_person_name],case when [cbm_house_no] is null or [cbm_house_no] = '' then '---' else [cbm_house_no] end as [cbm_house_no],case when [rreb_lat] is null then 0 else [rreb_lat] end as [rreb_lat1],case when [rreb_long] is null then 0 else [rreb_long] end as [rreb_long2],tod_bin_name
 from [admin].[config_bin_master] 
 inner join [reporting].[trip_ongoing_details] on [tod_bin_id_fk]=[cbm_bin_loc_id]  
 left join [reporting].[rfid_read_in_each_binLocation] on [rreb_trip_ongoing_details_id_fk]=[tod_id_pk] and [rreb_bin_id_fk]=[cbm_id_pk]
 left join admin.config_rfid_master on crm_bin_id=cbm_id_pk

 
 --select crm_bin_lat,crm_bin_long,* from admin.config_rfid_master
/*
 select tod_master_id_fk,case when (select  binName from [dbo].[fnGetBins] (tod_bin_id_fk,1))  is null  then '--' else  (select binName from [dbo].[fnGetBins] (tod_bin_id_fk,1)) end as binSubName,tod_bin_name,case when tod_bin_entry_time is null then '--' else CONVERT(varchar(10),tod_bin_entry_time,105)+' '+convert(nvarchar(8),tod_bin_entry_time,108) end as tod_bin_entry_time,CASE WHEN tod_weight IS NULL THEN '0' ELSE convert(varchar,[tod_weight]) END AS [tod_weight],
								case when tom_weight_disposed is null then 0 else round(tom_weight_disposed,2)end as tom_weight_disposed,case when tom_received_weight is null then 0 else round(tom_received_weight,2)end as tom_received_weight,case when tom_dump_time is null then '--' else convert(varchar(10),tom_dump_time,105)+' '+convert(nvarchar(8),tom_dump_time,108) end as dumpDate,
								case when tod_bin_exit_time is null then '--' else CONVERT(varchar(20),tod_bin_exit_time,120) end as tod_bin_exit_time,tocd_bin_images_url,0 as status,the_geom.STX as lat,the_geom.STY as lon,
								[tod_collection_status],[rm_type],geometry::STGeomFromText([rd_the_geom].STAsText(),4326).STStartPoint().STX AS Start_Lat,geometry::STGeomFromText([rd_the_geom].STAsText(),4326).STStartPoint().STY AS Start_Lon,
								CASE WHEN ggcf_points_count IS NULL THEN '--' ELSE CONVERT(varchar(2),ggcf_points_count) END AS ggcf_points_count,tod_bins_to_be_collected,tod_bins_collected,Bin_type_id,ggcf_bin_collection_status  
								
								,case when (select binName from [dbo].[fnGetBins] (ggcf_points_id_pk,2)) is null then '0' else
								 (select binName from [dbo].[fnGetBins] (ggcf_points_id_pk,2)) end as binId 
								,case when ggcf_last_collected_date is null then '-- -- --' else convert(varchar(10),ggcf_last_collected_date,105)+' '+convert(varchar(8),ggcf_last_collected_date,14) end ggcf_last_collected_date 

								
								 from  reporting.trip_ongoing_details 
								left join  reporting.trip_ongoing_master on tom_id_pk=tod_master_id_fk 
								left join [garbage].[gis_garbage_collection_points] on [ggcf_points_id_pk]= tod_bin_id_fk 
								 left join  [garbage].[route_master] on [rm_id_pk] =[tod_route_id]
								
		                       
								 left join   [garbage].[route_details] on [rd_check_point_id_fk] =[tod_bin_id_fk] and [rd_route_id_fk]=[tod_route_id]
								 left join   reporting.trip_ongoing_captured_data on tom_trip_id_fk=tocd_trip_id_fk and tod_bin_id_fk=tocd_bin_id_fk 
*/

GO
/****** Object:  View [dbo].[optimize_Scheduling_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[optimize_Scheduling_view]

AS

  select ggcf_ulb_id_fk,ggcf_points_id_pk,ggcf_bin_loc_status,ggcf_points_name,ggcf_points_address,ggcf.[the_geom].STX AS Latitude,ggcf.[the_geom].STY AS Longitude,ggcf_ward_id,ggcf_zone_id,czm_zone_name,the_radious,Bin_type_id,cbt_type,cbm_bin_capacity,ggcf_points_count,case when (select binName from [dbo].[fnGetBins] (ggcf_points_id_pk,0,0)) is null then '--' else (select binName from [dbo].[fnGetBins] (ggcf_points_id_pk,0,0)) end as binId FROM   [garbage].[gis_garbage_collection_points] ggcf left join   [admin].[config_zone_master] on czm_id_pk=ggcf_zone_id left join   [admin].[config_bin_type] on cbt_id_pk = Bin_type_id inner join(select [cbm_bin_loc_id],sum([cbm_bin_capacity]) as cbm_bin_capacity from   [admin].[config_bin_master] GROUP BY [cbm_bin_loc_id]) f on f.cbm_bin_loc_id=ggcf_points_id_pk

GO
/****** Object:  View [dbo].[poi_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[poi_details_view]
AS

SELECT [gcf_the_geom].STAsText() as[gcf_the_geom],gcf_id_pk,gcf_poi_name,gcf_address,
geometry::STGeomFromText(CONVERT(nvarchar(max),gcf_the_geom), 4326).STX as lat,geometry::STGeomFromText(CONVERT(nvarchar(max),gcf_the_geom), 4326).STY as lon,poitype.ptd_poi_type,gcf_radius,case when ward.cwm_ward_name is null then '----' else ward.cwm_ward_name end as cwm_ward_name,case when zone.czm_zone_name is null then '----' else zone.czm_zone_name end as czm_zone_name,
	case when gcf_created_date is null then '----' else convert(varchar(10),cast (gcf_created_date as date),105)+' '+convert(varchar(8),gcf_created_date,108 ) end as date ,gcf_zone_id,gcf_ward_id,gcf_poi_type_id_fk,gcf_ulb_id_fk FROM garbage.gis_client_fence 
	left Join garbage.poi_type_details as poitype on gcf_poi_type_id_fk=poitype.ptd_id_pk 
	left Join admin.config_ward_master as ward on gcf_ward_id=ward.cwm_id_pk 
	left Join admin.config_zone_master as zone on gcf_zone_id=zone.czm_id_pk

GO
/****** Object:  View [dbo].[road_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[road_details_view]
AS
	SELECT convert(varchar(10),GETDATE(),105)+' '+convert(varchar(8),GETDATE(),14)  datera,case when ward.cwm_ward_name is null then '----' else ward.cwm_ward_name end as cwm_ward_name,case when zone.czm_zone_name is null then '----' else zone.czm_zone_name end as czm_zone_name,gra_name,gra_zone_id,gra_id_pk,gra_fence.STAsText() as gra_fence ,gra_route.STAsText() as gra_route,gra_address,
	case when gra_created_date is null then '----' else convert(varchar(10),cast (gra_created_date as date),105)+' '+convert(varchar(8),gra_created_date,108 ) end as date,gra_created_by,gra_ward_id,gra_points_count,gra_ulb_id_fk,(select case when count(*)>0 then 1 else 0 end from [garbage].[route_details]
	where [rd_check_point_id_fk]=gra_id_pk ) as status FROM [garbage].[gis_road_area] 
	left Join admin.config_ward_master as ward on gra_ward_id=ward.cwm_id_pk 
	left Join admin.config_zone_master as zone on gra_zone_id=zone.czm_id_pk

GO
/****** Object:  View [dbo].[route_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[route_details_view]
WITH SCHEMABINDING
AS
	Select rd_order_no,rd_check_points,rd_check_point_id_fk, case when [rm_type]=0 then (CASE WHEN [ggcf_points_count] IS NULL THEN 0 ELSE   [ggcf_points_count] END) ELSE (CASE WHEN gra_points_count IS NULL THEN 0 ELSE gra_points_count END ) end as ggcf_points_count,rm_type,rd_the_geom.STX as lat, 
															rd_the_geom.STY as lon,rm_geom.STAsText() as rmGeom,rd_the_geom.STAsText() as rdTheGeom,rd_route_id_fk from garbage.route_details left join [garbage].[route_master] on [rm_id_pk]=[rd_route_id_fk] left join [garbage].[gis_garbage_collection_points]  on [ggcf_points_id_pk]=rd_check_point_id_fk and [rm_type]=0 left join [garbage].[gis_road_area] on rd_check_point_id_fk=gra_id_pk and [rm_type]=1

GO
/****** Object:  View [dbo].[schedule_trip_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[schedule_trip_details_view]

AS
select cfm_ulb_id_fk, stm_id_pk,case when stm_date_time is null then '--' else convert(varchar(10),stm_date_time,105)+' '+convert(varchar(8),stm_date_time,108) end as date,fleet.cfm_vehicle_no,dumping.gdg_name,case when gis1.gcf_poi_name is null then '--' else gis1.gcf_poi_name end as startlocat,case when gis2.gcf_poi_name is null then '--' else gis2.gcf_poi_name end as endlocat,rt.rm_route_name,shift.csm_shift_name,cfc_type,case when cssm_staff_name is null then '--' else cssm_staff_name end as cssm_staff_name,
									 ( SELECT case when staffName is null then '--' else staffName end as staffName from fnAppendString(stm_id_pk) )as staff_name,stm_status from scheduling.schedule_trip_master 
									  left join [garbage].[gis_client_fence] gis1 on stm_start_location=gis1.gcf_id_pk 
									 left join [garbage].[gis_client_fence] gis2 on stm_end_location=gis2.gcf_id_pk 
										LEFT join admin.config_fleet_master as fleet on stm_vheicle_id_fk=fleet.cfm_id_pk  LEFT JOIN admin.config_fleet_category ON cfc_id_pk=cfm_vehicle_type_id_fk 
										left join admin.config_staff_master ON cssm_id_pk=stm_driver_id_fk LEFT join garbage.gis_dumping_grounds as dumping on dumping.gdg_id_pk=stm_end_location LEFT join garbage.route_master as rt on rt.rm_id_pk=stm_route_id_fk 
										LEFT join admin.config_shift_master as shift on shift.csm_id_pk=stm_shift_id_fk where stm_status in (0,1)

GO
/****** Object:  View [dbo].[StaffAttendance_total_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[StaffAttendance_total_view]
WITH SCHEMABINDING
AS

select count(sar_staff_id_fk) as total,sum(case when cast(sar_staff_status as int)=1 then 1 else 0 end) Present,sum(case when cast(sar_staff_status as int)=0 then 1 else  0  end) Absent,cssm_zone_id_fk,cssm_ward_id_fk,cssm_package_id_fk,sar_staff_type_id, sar_date as date,sar_ulb_id_fk
--FORMAT(sar_date, ' ddd MMM dd  HH:mm:ss "GMT" yyyy')  as date
 FROM [reports].[staff_attendance_report]  join  [admin].[config_staff_master] on cssm_id_pk=sar_staff_id_fk  and  sar_date between DATEADD(month, -100, GETDATE()) and GETDATE()
		 group by sar_date,cssm_zone_id_fk,cssm_ward_id_fk,cssm_package_id_fk,sar_staff_type_id ,sar_ulb_id_fk

GO
/****** Object:  View [dbo].[StaffAttendance_view_report]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[StaffAttendance_view_report]

AS 
select --cfm_vehicle_no,cfc_type,
cssm_staff_type,[cssm_zone_id_fk],[cssm_ward_id_fk],cssm_id_pk,ulbm_tenant_code,case when csc_type is null then '--'else csc_type end as staff_role, case when csm_shift_name is null then '--'else csm_shift_name end as shiftName,
[cwm_id_pk],[czm_id_pk],sar_staff_type as stafftype,sar_emp_id as employeeID,sar_staff_name as staffname,sar_ulb_id_fk,[cssm_aadhar_no],[cssm_licence_no],[cssm_phone_no],[cssm_address],[cssm_email_id],
case when sar_login_time is null and sar_logout_time is null then '--/--' when sar_login_time is not null  and 
					sar_logout_time is not null then convert(varchar(8),cast (sar_login_time as time))+'/'+convert(varchar(8),
					cast (sar_logout_time as time))when  sar_login_time is not null and sar_logout_time is null then 
					convert(varchar(8),cast (sar_login_time as time)) else  convert(varchar(8),cast (sar_logout_time as time)) end	 report_Time,[czm_zone_name],[cwm_ward_name]
,CASE WHEN sar_date IS NULL THEN '-- -- --' ELSE CONVERT(varchar(10),sar_date,105) end as sar_date,case when  sar_staff_status = 1 then 'Present ' else 'Absent' end as staff_status,sar_date as sar_date_1,sar_staff_status,cmum_user_name,sar_login_time,sar_logout_time  from  reports.staff_attendance_report 
left join  [admin].[config_staff_master] as staff on staff.cssm_id_pk=sar_staff_id_fk  
left join  [admin].config_zone_master on [czm_id_pk]=[cssm_zone_id_fk]
left join  [admin].config_ward_master on [cwm_id_pk]=[cssm_ward_id_fk]
left join  [admin].[config_mobile_user_master] on cmum_id_pk = sar_supervisor_id_fk 
--left join  [admin].[config_mobile_user_master] as mobile on mobile.cmum_employee_id=sar_staff_id_fk and cmum_user_type=9
--left join  [admin].[user_log] as log on log.ul_user_id_fk=mobile.cmum_id_pk 
--left join  [admin].[config_fleet_master] as fleet on fleet.cfm_id_pk=log.ul_vehicle_id_fk [sar_shift_id] 	
--left join  [admin].[config_fleet_category] cfc on fleet.cfm_vehicle_type_id_fk=cfc.cfc_id_pk
left join  [admin].[config_shift_master] as shiftt on shiftt.csm_id_pk=[csm_shift_type_id_fk]
left join  [admin].[config_staff_category] on csc_id_pk=cssm_staff_category_id_fk
left join admin.urban_local_body_master on sar_ulb_id_fk = ulbm_id_pk where [cssm_zone_id_fk] is not null and [cssm_ward_id_fk] is not null

GO
/****** Object:  View [dbo].[StaffCount]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE  OR ALTER VIEW [dbo].[StaffCount] as 
  with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0)))   
						 	 where dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()  union all  
						  select dateadd(dd, 1, dt)from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
						    select distinct dt,sar_ulb_id_fk,sum(case when  sar_staff_type_id IN (1,2,3,4) then 1 else 0 end )  as dsa_total_staff_count, 
						   sum(case when sar_staff_status=1 then 1 else 0 end ) as dsa_staff_present_count, 
						    sum(case when sar_staff_status=0 then 1 else  0 end) as dsa_staff_absent_count 
						     from dateRange left join  [reports].[staff_attendance_report] on   CONVERT(date, sar_date) = dt 
						   group by dt,sar_date,sar_ulb_id_fk

GO
/****** Object:  View [dbo].[staffDataGrid]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[staffDataGrid]

AS
select * from [reports].[staff_attendance_report] left join admin.config_staff_master on sar_staff_id_fk=cssm_id_pk left join [admin].[config_ward_master] on cssm_ward_id_fk=cwm_id_pk left join [admin].[config_zone_master] on cssm_zone_id_fk=czm_id_pk where cast(sar_date as date)>= cast(GETDATE() as date)

GO
/****** Object:  View [dbo].[total_trip_report]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[total_trip_report]

AS
select [tom_trip_id_fk] as tripId,[tom_trip_schedule_date_time] as Schedule_DateTime ,case when [tom_trip_status]=0 then 'Pending' else 'Ongoing' end as tripStatus,case when [tom_start_date_time]=null then '---' else [tom_start_date_time] end as tripStartTime, case when [tom_end_date_time]=null then '---' else [tom_end_date_time] end as tripEndTime from [reporting].[trip_ongoing_master] 

union all(select [tcm_trip_id_fk] as tripId,[tcm_trip_date_time] as Schedule_DateTime,case when [tcm_trip_status]=2 then 'Completed' end as tripStatus,case when [tcm_start_date_time]=null then '---' else [tcm_start_date_time] end as tripStartTime,
 case when [tcm_end_date_time]=null then '---' else [tcm_end_date_time] end as tripEndTime  from [reporting].[trip_completed_master] )

GO
/****** Object:  View [dbo].[underground_bin_for_dash_veiw]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[underground_bin_for_dash_veiw]
AS
  /*with dateRange as( select dt = dateadd(dd, 1, CONVERT(date,  dateadd(day,datediff(day,7,GETDATE()),0)))    where  
								  dateadd(dd, 1, CONVERT(date,  dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()   
								  union all  select dateadd(dd, 1, dt) from dateRange where dateadd(dd, 1, dt) < GETDATE())select t_date,total_bins,case when collected_bins is null then 0 else collected_bins end as collected_bins,  total_bins-(case when collected_bins is null then 0 else collected_bins end)
	                                   as not_collected_bins,cbsm_ulb_id_fk 
                                       from  ( select FORMAT( dt,'dd-MM-yyyy') as t_date,count([cbsm_bin_id]) as total_bins,
                                       (select case when dt=cast(getdate() as date) then sum(case when  [cbsm_collection_status]=1 then 1 else 0 end) else (select sum([bcr_bin_collected])  from [dashboard].[bin_collection_report] where [bcr_date]=dt
                                        and bcr_bin_type_id=1) end )  collected_bins,cbsm_ulb_id_fk from dateRange,[dbo].[bin_collection_status_view]  where cbsm_ulb_id_fk=21210
										
										group by cbsm_ulb_id_fk,dt) as t1*/

with dateRange as( select dt = dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0)))
where dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE() union all
select dateadd(dd, 1, dt) from dateRange where dateadd(dd, 1, dt) < GETDATE())
select t_date,total_bins,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,czm_zone_name,[cwm_id_pk],
case when collected_bins is null then 0 else collected_bins end as collected_bins, ISNULL(collected_bins*100.00/NULLIF(total_bins, 0), 0) as collected_bins_percentage, total_bins-((case when collected_bins is null then 0 else collected_bins end)+(case when attended_not_collected_bins is null then 0 else attended_not_collected_bins end)) as not_collected_bins, ISNULL((total_bins - ISNULL(collected_bins, 0)+ISNULL(attended_not_collected_bins, 0))*100.00/NULLIF(total_bins,0),0) as not_collected_bins_percentag, case when attended_not_collected_bins is null then 0 else attended_not_collected_bins end as attended_not_collected_bins
from
( select FORMAT( dt,'dd-MM-yyyy') as t_date,sum([ggcf_points_count]) as total_bins,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,
czm_zone_name,[cwm_id_pk],(select case when dt=cast(getdate() as date) then sum(case when
[ggcf_bin_collection_status]=1 then [ggcf_collected_bins] else 0 end) else (
select sum([bcr_bin_collected])
from [dashboard].[bin_collection_report]
where [bcr_date]=dt and [bcr_ward_id]=[cwm_id_pk] and bcr_bin_type_id=1) end )
collected_bins,
(
select case when dt=cast(getdate() as date) then sum(
case when
[ggcf_bin_collection_status]=3 then [ggcf_points_count] else 0 end) else (select sum([bcr_bin_attended_not_collected])
from [dashboard].[bin_collection_report]
where [bcr_date]=dt and [bcr_ward_id]=[cwm_id_pk] and bcr_bin_type_id=1
) end ) attended_not_collected_bins
from dateRange,[garbage].[gis_garbage_collection_points]
left join admin.config_ward_master on [cwm_id_pk]=[ggcf_ward_id] left join
admin.config_zone_master on cwm_zone_id_fk=czm_id_pk
left join [admin].[config_bin_type] on Bin_type_id=[cbt_id_pk]
where [cbt_type] LIKE 'UNDER%'
-- where Bin_type_id= 1
group by dt,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,czm_zone_name,[cwm_id_pk]) as t1

GO
/****** Object:  View [dbo].[urban_local_body_master_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[urban_local_body_master_view]

AS

SELECT ulbm_ulbLogo,expiryDate,ulb.is_logged_in,ulb.ulbm_tenant_code,ulb.ulbm_created_date,ulb.ulbm_address,ulb.ulbm_intg,ulb.ulbm_id_pk,ulb.ulbm_name,cum_login_name,ulb.ulbm_phone_no,ulb.ulbm_emil_id,ulb.ulbm_state,ulb.ulbm_state_id_fk,ulb.ulbm_image,ulb.ulbm_user_category,ulb.ulbm_pos_menu,ulb.ulbm_citizan_menu,ulb.ulbm_fbpageId,ulb.GroupId,ulb.ZoneLayerId,ulb.WardLayerId,ulb.BinLocId,ulb.DumpGroundId,ulb.ulbm_twitterpageId,ulb.ulb_mobile_key_count,ulb.ulbm_supervisor_key_count,ulb.ulb_driverapp_charges,ulb.ulb_supervisoryapp_charges,ulb.ulbm_rfid_menu,ulb.ulbm_bin_menu,ulb.ulbm_attendance_key_count,ulb.ulbm_attendanceapp_charges,ulb.ulbm_attendance_menu FROM admin.urban_local_body_master ulb left join admin.config_user_master on cum_tenant_code=ulb.ulbm_tenant_code

GO
/****** Object:  View [dbo].[v_analytic_binId_details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[v_analytic_binId_details]
	AS

 select cbsm_ulb_id_fk as ULBId,cbm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_loc_id as binLocID,ggcf_points_name as binLocName,
cbsm_bin_latitude as lat,cbsm_bin_longitude as lon,cbsm_bin_id as id,cbsm_bin_name as binIDName,
case when cbsm_sensor_updated_date is null then '' else convert(varchar(20),cbsm_sensor_updated_date,120) end as updatedDate,
case when max(bsl_volume_fill_percentage) is null then 0 else max(bsl_volume_fill_percentage) end as 
binFullPer
 from  admin.config_bin_sensor_master 
left join admin.config_bin_master on cbsm_bin_id = [cbm_id_pk]
left join dbo.bin_sensor_log  on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
left join admin.config_ward_master on cbm_ward_id=[cwm_id_pk]
left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id
where convert(varchar(10),bsl_utc_date_time,120)=convert(varchar(10),getdate(),120)
group by cbm_ward_id, cbsm_bin_id,cbsm_ulb_id_fk,cbsm_ward_id,cwm_ward_name,cbsm_bin_loc_id,ggcf_points_name,cbsm_bin_latitude,cbsm_bin_longitude,cbsm_bin_id,cbsm_sensor_updated_date,cbsm_bin_name,
convert(varchar(10),bsl_utc_date_time,120),bsl_simcard_no

GO
/****** Object:  View [dbo].[v_get_employee_data]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[v_get_employee_data] AS
SELECT * FROM employee

GO
/****** Object:  View [dbo].[vehicle_assigned_for_dash_veiw]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[vehicle_assigned_for_dash_veiw]
AS with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, 
				       		  dateadd(day,datediff(day,7,GETDATE()),0))) where dateadd(dd, 1, CONVERT(date, 
				       		  dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE() union all select dateadd(dd, 1, dt)
				       		  from dateRange where dateadd(dd, 1, dt) < GETDATE()) select assingedVehicle,stm_date_time,
				       		  Total,Total-assingedVehicle as unassignedVehicle ,cfm_ulb_id_fk from (select dt, 
				       		  count(distinct(case when CONVERT(date, stm_date_time) = dt then stm_vheicle_id_fk end)) 
				       		  as assingedVehicle,FORMAT( dt,'dd-MM-yyyy') as stm_date_time, (select count(*) 
				       		  from  admin.config_fleet_master where cfm_ulb_id_fk=cfm.cfm_ulb_id_fk 
				       		  and cfm_vehicle_available_status = 1) as Total ,cfm_ulb_id_fk from dateRange, 
				       		   scheduling.schedule_trip_master left join  [admin].[config_fleet_master]
				       		  cfm on stm_vheicle_id_fk = cfm_id_pk where cfm_ulb_id_fk is not null group by dt,cfm_ulb_id_fk) 
				       		  as temp_table union all(select assingedVehicle,stm_date_time,Total,Total-assingedVehicle 
				       		  as unassignedVehicle,cfm_ulb_id_fk from ( select dt, count(distinct(stm_vheicle_id_fk)) 
				       		  as assingedVehicle,FORMAT( dt,'dd-MM-yyyy') as stm_date_time, (select count(*) 
				       		  from  admin.config_fleet_master where cfm_vehicle_available_status = 1) 
				       		  as Total,0 as cfm_ulb_id_fk from dateRange left join   scheduling.schedule_trip_master
				       		  on CONVERT(date, stm_date_time) = dt group by dt,CONVERT(date, stm_date_time) ) as temp_table)

GO
/****** Object:  View [dbo].[vehicle_assigned_for_vehicle_veiw]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[vehicle_assigned_for_vehicle_veiw]
AS 	with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, 
	dateadd(day,datediff(day,7,GETDATE()),0))) where dateadd(dd, 1, CONVERT(date, 
	dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE() union all select dateadd(dd, 1, dt)
	from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
select assingedVehicle,stm_date_time,Total,Total-assingedVehicle as unassignedVehicle ,cfm_ulb_id_fk,ulbm_tenant_code from (select dt, 
count(distinct(case when CONVERT(date, stm_date_time) = dt then stm_vheicle_id_fk end)) 
 as assingedVehicle,FORMAT( dt,'dd-MM-yyyy') as stm_date_time, (select count(*) 
 from  admin.config_fleet_master where cfm_ulb_id_fk=cfm.cfm_ulb_id_fk 
 and cfm_vehicle_available_status = 1) as Total ,cfm_ulb_id_fk,ulbm_tenant_code from dateRange, scheduling.schedule_trip_master  left join  [admin].[config_fleet_master] cfm on stm_vheicle_id_fk = cfm_id_pk left join admin.urban_local_body_master on cfm_ulb_id_fk=ulbm_id_pk
where cfm_ulb_id_fk is not null group by dt,cfm_ulb_id_fk,ulbm_tenant_code) 
as temp_table union all(select assingedVehicle,stm_date_time,Total,Total-assingedVehicle 
 as unassignedVehicle,cfm_ulb_id_fk,ulbm_tenant_code from ( select dt, count(distinct(stm_vheicle_id_fk)) 
 as assingedVehicle,FORMAT( dt,'dd-MM-yyyy') as stm_date_time, (select count(*) 
 from  admin.config_fleet_master where cfm_vehicle_available_status = 1) 
 as Total,0 as cfm_ulb_id_fk,'' as ulbm_tenant_code  from dateRange left join   scheduling.schedule_trip_master
 on CONVERT(date, stm_date_time) = dt group by dt,CONVERT(date, stm_date_time) ) as temp_table )

GO
/****** Object:  View [dbo].[vehicle_details_view]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[vehicle_details_view]
WITH SCHEMABINDING
AS
	select cmum_workforce_id_fk,cfm_vehicle_available_status,cfm_id_pk,cfm_vehicle_no,cfc.cfc_type,cfm_ulb_id_fk,cfm_vehicle_type_id_fk,cfm_sim_no,case when [cssm_staff_name] is null then '' else [cssm_staff_name] end as driverName, cfm_ward_id
	, [cfm_zone_id],[vom_status]
	from admin.config_fleet_master 
	inner join admin.config_fleet_category cfc on cfm_vehicle_type_id_fk=cfc.cfc_id_pk 
	left join [dbo].[view_online_master] on [vom_vehicle_id]=cfm_id_pk 
	left join admin.config_mobile_user_master on cfm_id_pk=cmum_vehicle_id
	left join [admin].[config_staff_master] on [cfm_driver_id] =  [cssm_id_pk] and [cssm_staff_type]=1

GO
/****** Object:  View [dbo].[vehicle_distance_for_dash_veiw]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[vehicle_distance_for_dash_veiw] as 
with dateRange as (select dt = dateadd(dd, 1, CONVERT(date,  
					   		  dateadd(day,datediff(day,7,GETDATE()),0))) where dateadd(dd, 1, CONVERT(date,  
					   		  dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE() union all select dateadd(dd, 1, dt)  
					   		  from dateRange where dateadd(dd, 1, dt) < GETDATE()) select round(SUM (case when rd_distance is not null  
					   		  and CONVERT(date, rd_date_time)=dt then rd_distance else 0 end),0) total_distance, round((SUM  
					   		  (case when rd_distance is not null and CONVERT(date, rd_date_time)=dt then  
					   		  rd_distance else 0 end))/count(*),0) Avg_distance, FORMAT( dt,'dd-MM-yyyy') as rd_date_time,rd_ulb_id_fk   
					   		  from dateRange,  [reports].[report_distance] where rd_ulb_id_fk <> 0  
					   		  group by rd_ulb_id_fk,  dt union all (select case when sum(rd_distance) is null then 0 else  
					   		  round(sum(rd_distance),0) end as total_distance, case when sum(rd_distance) is null  
					   		  then 0 else round(sum(rd_distance) / count(*),0) end as Avg_distance, FORMAT( dt,'dd-MM-yyyy')  
					   		  as rd_date_time,0 as rd_ulb_id_fk from dateRange left join  [reports].[report_distance]  
					   		  on CONVERT(date, rd_date_time)=dt group by  dt,CONVERT(date, rd_date_time) )

GO
/****** Object:  View [dbo].[Vehicle_Maintainance_details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[Vehicle_Maintainance_details]

AS 



SELECT cfm_vehicle_no as vehicleName,cfc_type as vehicleType,ulbm_tenant_code,vmr_datetime as maintaincedate,vmtm_maintenance_type as maintainceType
  FROM [reports].[vehicle_maintenance_report]
  left join [admin].[config_fleet_master] on vmr_vehicle_id_fk= cfm_id_pk
  left join [admin].[vehicle_maintenance_type_master] on vmr_maintenance_type=vmtm_id_pk
  left join admin.config_fleet_category on cfc_id_pk = cfm_vehicle_type_id_fk
  left join admin.urban_local_body_master on ulbm_id_pk= cfm_ulb_id_fk

GO
/****** Object:  View [dbo].[vehicle_trip_for_grid]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[vehicle_trip_for_grid]
AS 	with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, 
	dateadd(day,datediff(day,7,GETDATE()),0))) where dateadd(dd, 1, CONVERT(date, 
	dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE() union all select dateadd(dd, 1, dt)
	from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
select cwm_id_pk,czm_id_pk,czm_zone_name,cwm_ward_name,assingedVehicle,stm_date_time,Total,Total-assingedVehicle as unassignedVehicle ,cfm_ulb_id_fk,ulbm_tenant_code from (select dt, 
count(distinct(case when CONVERT(date, stm_date_time) = dt then stm_vheicle_id_fk end)) 
 as assingedVehicle,FORMAT( dt,'dd-MM-yyyy') as stm_date_time, (select count(*) 
 from  admin.config_fleet_master where cfm_ulb_id_fk=cfm.cfm_ulb_id_fk 
 and cfm_vehicle_available_status = 1) as Total ,cwm_id_pk,czm_id_pk ,czm_zone_name,cwm_ward_name,cfm_ulb_id_fk,ulbm_tenant_code from dateRange, scheduling.schedule_trip_master  left join  [admin].[config_fleet_master] cfm on stm_vheicle_id_fk = cfm_id_pk left join admin.urban_local_body_master on cfm_ulb_id_fk=ulbm_id_pk left join  [admin].[config_ward_master] on [cfm_ward_id]=cwm_id_pk left join  [admin].[config_zone_master] on [cfm_zone_id]=czm_id_pk
where cfm_ulb_id_fk is not null group by czm_zone_name,cwm_ward_name,dt,cfm_ulb_id_fk,ulbm_tenant_code,cwm_id_pk,czm_id_pk) 
as temp_table union all(select cwm_id_pk,czm_id_pk,czm_zone_name,cwm_ward_name,assingedVehicle,stm_date_time,Total,Total-assingedVehicle 
 as unassignedVehicle,cfm_ulb_id_fk,ulbm_tenant_code from ( select dt, count(distinct(stm_vheicle_id_fk)) 
 as assingedVehicle,FORMAT( dt,'dd-MM-yyyy') as stm_date_time, (select count(*) 
 from  admin.config_fleet_master where cfm_vehicle_available_status = 1) 
 as Total,0 as cfm_ulb_id_fk,'' as ulbm_tenant_code,'' as czm_zone_name,'' as cwm_ward_name,0 as cwm_id_pk,0 as czm_id_pk from dateRange left join   scheduling.schedule_trip_master
 on CONVERT(date, stm_date_time) = dt group by dt,CONVERT(date, stm_date_time) ) as temp_table )

GO
/****** Object:  View [dbo].[VI_Analytics_vehicle_details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[VI_Analytics_vehicle_details]

AS
 with dateRange as( select dt = dateadd(dd, 1,CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0)))  where dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE() union all  
								 select dateadd(dd, 1, dt)  from dateRange   where dateadd(dd, 1, dt) < =GETDATE())  
								select  dt,cfm_vehicle_no as vehicleno,cfm_id_pk as vehicleid,cfc_type as vehicletype ,
								startlocation.gcf_poi_name as startlocation ,startlocation.gcf_the_geom.STX as startlat,
								startlocation.gcf_the_geom.STY as startlon,endlocation.gcf_poi_name as endlocation ,
								endlocation.gcf_the_geom.STX as endlat,endlocation.gcf_the_geom.STY as endlon,
								cbm_bin_name as Binid,cbsm_bin_longitude as binlatitude,cbsm_bin_longitude as binlongtitude,
								cbt_type as bintype,tcm_ulb_id_fk from dateRange, [reporting].[trip_completed_master] 
								left join  [admin].[config_zone_master] on tcm_zone_id=czm_id_pk 
								 left join  [admin].[config_ward_master] on tcm_ward_id=cwm_id_pk 
								  left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
								  left join [admin].[config_fleet_category]  on cfm_vehicle_type_id_fk=cfc_id_pk 
								  left join [garbage].[gis_client_fence] startlocation   on tcm_start_location=startlocation.gcf_poi_name
								   left join [garbage].[gis_client_fence] endlocation  on tcm_end_location=endlocation.gcf_poi_name
								   left join [reporting].[trip_completed_details] on tcm_id_pk=tcd_master_id_fk
								   left join  [admin].[config_bin_master] on cbm_bin_loc_id=tcd_bin_id_fk
								   left join [admin].[config_bin_sensor_master] on cbm_id_pk=cbsm_bin_id
								   left join [admin].[config_bin_type] on cbm_binType=cbt_id_pk
								   left join [garbage].[route_master] on tcm_route_id_fk=rm_id_pk
								  left join  [garbage].[route_details] on rd_route_id_fk=rm_id_pk

  group by dt,cfm_vehicle_no,cfm_id_pk,cfc_type,startlocation.gcf_poi_name,endlocation.gcf_poi_name,
  startlocation.gcf_the_geom.STX,endlocation.gcf_the_geom.STX,startlocation.gcf_the_geom.STY ,
  endlocation.gcf_the_geom.STY ,cbm_bin_name,cbsm_bin_longitude,cbsm_bin_longitude,cbt_type,tcm_ulb_id_fk

GO
/****** Object:  View [dbo].[VI_ICOP_TotalBin_WeightCount]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[VI_ICOP_TotalBin_WeightCount]

AS

SELECT Bins.totalBins,case when doorbins.door2doorcollected is null then 0 else doorbins.door2doorcollected end as door2doorCollectedCount,Weight.totalWeight FROM ( select count (cbm_id_pk) as totalbins from  [admin].[config_bin_master]) as bins, (SELECT sum(case when [crm_bin_collection_status]=1 then 1 else 0 end) as door2doorcollected  from [admin].[config_rfid_master] LEFT JOIN [admin].[config_bin_master] on [cbm_id_pk]=[crm_bin_id] where  cbm_binRroad_status=1 and cast (crm_bin_collection_time as date)=cast (GETDATE() as date)) as doorbins,(select sum (tcm_weight_disposed) as TotalWeight from [reporting].[trip_completed_master] where   tcm_trip_date_time >= DATEADD(hh, -24, GETDATE())) as Weight

GO
/****** Object:  View [dbo].[VI_ICOP_TotalBinsSkipped]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[VI_ICOP_TotalBinsSkipped]

AS



SELECT x.binskippedcount, y.doorskippedcount FROM (
select count(bsal_bin_id) as binskippedcount from  [dbo].[bin_sensor_alert_log] 
where bsal_bin_skippedfull_status=1 ) as x, (select count(bsal_bin_id) as doorskippedcount from  [dbo].[bin_sensor_alert_log] where bsal_bin_skippedfull_status=5 ) as y

GO
/****** Object:  View [dbo].[VI_Weight_Report_View]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [dbo].[VI_Weight_Report_View]

AS

  select [dwd_dgwdid_fk],cfm_id_pk,[dwd_updated_date],[gdg_id_pk],case when gdg_name is NULL then '---' else gdg_name  end as gdgname,
  case when [dwd_weight] is NULL then '---' else [dwd_weight] end as twd_weight,
  case when [dwd_updated_date] is null then '---' else CONVERT(VARCHAR(10), [dwd_updated_date],105)+' '+ CONVERT(VARCHAR(8), [dwd_updated_date],108) end as twd_updated_date,
  case when [dwd_trip_id_fk] is null then 0 else [dwd_trip_id_fk] end as [dwd_trip_id_fk],
  case when  cfm_vehicle_no  is NULL then '---' else  cfm_vehicle_no  end as cfm_vehicle_no ,czm_zone_name ,cwm_ward_name ,czm_id_pk,cwm_id_pk,garbage_wt 
  from ( 
  select  [dwd_dgwdid_fk],[dwd_rfid_no],[dwd_weight],[dwd_updated_date],[dwd_trip_id_fk],DATEDIFF(MINUTE,prev_time, [dwd_updated_date]) as diff_time,
  case when prev_time is null then 0 when prev_veh=cfm_vehicle_no and DATEDIFF(MINUTE, prev_time,[dwd_updated_date])<5 THEN 1 else 0 end as status,
  [gdg_id_pk],gdg_name,cfm_vehicle_no,czm_zone_name ,cwm_ward_name,garbage_wt,cfm_id_pk ,czm_id_pk,cwm_id_pk
  from (SELECT  
       [dwd_dgwdid_fk]
      ,[dwd_rfid_no]
      ,[dwd_weight],([dwd_weight]-cfm_fleet_capacity) as garbage_wt,cfm_id_pk
      ,[dwd_updated_date],[gdg_id_pk],gdg_name,czm_id_pk,cwm_id_pk,case when cwm_ward_name is null then '---' else cwm_ward_name end as cwm_ward_name,case when czm_zone_name is null then '---' else czm_zone_name end as czm_zone_name
      ,cfm_vehicle_no,lag([dwd_updated_date] ) over(order by cfm_vehicle_no,[dwd_updated_date]) as prev_time,
	  lag(cfm_vehicle_no ) over(order by cfm_vehicle_no,[dwd_updated_date]) as prev_veh,
	  [dwd_trip_id_fk]
  FROM [reports].[dump_weight_details]
   left join [garbage].[gis_dumping_grounds] on [gdg_id_pk]=dwd_dgwdid_fk
  	left join [admin].[config_zone_master] on czm_id_pk=gdg_zone_id	left join [admin].[config_ward_master] on cwm_id_pk=gdg_ward_id  left join admin.config_fleet_master on cfm_id_pk=[dwd_vehicle_id_fk]  where cfm_vehicle_no is not null  and dwd_weight>=cfm_fleet_capacity
    ) as t1 ) as t2 where status=0

GO
/****** Object:  View [esc].[v_escalation_bin_details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [esc].[v_escalation_bin_details]
	AS

 select top 1 cbsm_mac_address,dtm_vheicle_id_fk as vehicleId,convert(varchar(10),dtm_date_time,120) as 
dispatchTime,dtm_bin_location_id as bin_locationId,
dtm_bin_id as BinIdKey,dtm_dumping_ground as dumping_groundId,dtm_trip_id as tripId,cmum_driver_id as driver_id ,
cmum_user_name as workforceUserName,cmum_mobile as workforceMobNum,
cmum_email as workforceEmail ,
cssm_staff_name as staffName,cssm_emp_id as staffEmpId,
cssm_phone_no as staffNo,cssm_address as StaffAddress,cssm_email_id as staffEmailId ,
vom_vehicle_No,vom_vehicle_type,vom_utc_date_time,vom_latitude,vom_longitude,
case when vom_status=1 then 'Tracking' when vom_status=2 then 'Non-Tracking' 
when vom_status=3 then 'No-GPS' when vom_status=5 then 'Disconnected' when 
vom_status=6 then 'Under-Maintenance' end vehicleStatus
from dbo.view_online_master as vom
join [admin].[config_mobile_user_master] as cmum on cmum.cmum_vehicle_id = vom.vom_vehicle_id
join admin.config_staff_master as csm on csm.cssm_id_pk=cmum.cmum_driver_id
join [scheduling].[dispatch_trip_master] as dtm on dtm.dtm_vheicle_id_fk = vom.vom_vehicle_id
join [admin].[config_bin_sensor_master] as cbms on [cbsm_bin_id]=dtm.[dtm_bin_id]

GO
/****** Object:  View [esc].[v_escalation_vehicle_details]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [esc].[v_escalation_vehicle_details]
	AS

select vom_vehicle_No,vom_vehicle_type,vom_utc_date_time,vom_latitude,vom_longitude,case when vom_status=1 then 'Tracking' when vom_status=2 then 'Non-Tracking' when vom_status=3 then 'No-GPS' when vom_status=5 then 'Disconnected' when vom_status=6 then 'Under-Maintenance' end vehicleStatus from dbo.view_online_master

GO
/****** Object:  View [v_reports].[VI_BinSensorLogData]    Script Date: 12-04-2021 18:29:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER VIEW [v_reports].[VI_BinSensorLogData]

AS

select  cbm_id_pk as binId,cbm_bin_name as binIdName,ggcf_points_id_pk as binLocationId,ggcf_points_name as binLocation,cwm_id_pk as wardId,cwm_ward_name as wardName,cbm_ulb_id_fk,Bin_type_id,convert(varchar(50),bsl_utc_date_time,120)  as receivedDateTime,bsl_garbage_volume as sensorLength,(([cbsm_bin_volume]-bsl_garbage_volume)*100)/[cbsm_bin_volume] as volumeInPercent,case when cbct_type is null then 'Both' else cbct_type end as segregation_type from [dbo].[bin_sensor_log]
left join [admin].[config_bin_sensor_master] on [cbsm_sensor_sim_no] COLLATE SQL_Latin1_General_CP1_CS_AS =bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CS_AS
 left join [admin].[config_zone_master] on [cbsm_zone_id]=czm_id_pk
left join [admin].[config_ward_master] on [cbsm_ward_id]=cwm_id_pk 
left join [admin].[config_bin_master] on cbm_id_pk=cbsm_bin_id 
left join [admin].[config_bin_category_type] on cbct_id_pk=cbm_bin_category_type
left join [garbage].[gis_garbage_collection_points] on [cbsm_bin_loc_id]=[ggcf_points_id_pk] where cbm_binType=1 and Bin_type_id=1

GO
