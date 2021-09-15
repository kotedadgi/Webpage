/****** Object:  StoredProcedure [dbo].[AlertSyncIot]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[AlertSyncIot]
  @action int, 
  @alarmTypeId int,
  @alarmTypeName varchar(40),
  @alarmTypeCode varchar(40),
  @priorityId int,
  @categoryId int,
  @companyId int,
  @categoryCode varchar(100),
  @companyCode varchar(50)
     
AS
BEGIN
Declare @status Bit

SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY
if @action=1
begin
insert into [admin].[config_alert_type] ([cat_id_pk],[cat_type],[cat_typeCode],[cat_categoryId],[cat_categoryCode],[cat_tenantCode],[cat_priorityId],[cat_companyId]) values
(@alarmTypeId,@alarmTypeName,@alarmTypeCode,@categoryId,@categoryCode,@companyCode,@priorityId,@companyId)
Set @status=1
SELECT @status AS status,'Alarm Insertion successful' AS message
end
if @action=2
begin
update [admin].[config_alert_type] set [cat_type]=@alarmTypeName,[cat_categoryId]=@categoryId,[cat_categoryCode]=@categoryCode,[cat_priorityId]=@priorityId where [cat_id_pk]=@alarmTypeId
Set @status=1
SELECT @status AS status,'Alarm Updation successful' AS message
end
if @action=3
begin
delete [admin].[config_alert_type] where [cat_id_pk]=@alarmTypeId
Set @status=1
SELECT @status AS status,'Alarm Deletion successful' AS message
end

COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	 set @status=0
	 SELECT @status AS status,ERROR_MESSAGE() AS message
	  END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[analytics_ActualVsPredictedVolChartByWard]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_ActualVsPredictedVolChartByWard] 
      
	 
	@stattime date,
	@endtime date,
	@binId varchar(50)
	     
AS
BEGIN
SET NOCOUNT ON;
select avg(bsl_garbage_volume) as avgVolume,cbsm_bin_id,cbsm_bin_name,
datepart(HOUR,bsl_utc_date_time) as hourdata 
         				from dbo.bin_sensor_log 
         				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
						left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id
         				where CONVERT(VARCHAR(10),bsl_utc_date_time,120) between @stattime and @endtime 
						and cbsm_bin_id in (select * from [dbo].[fnSplitString] (@binId, ','))
         				group by datepart(HOUR,bsl_utc_date_time),cbsm_bin_id,cbsm_bin_name
         				order by datepart(HOUR,bsl_utc_date_time)
END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_ActualVsPredictedVolChartsecondByWard]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_ActualVsPredictedVolChartsecondByWard] 
      
	  
	@stattime date,
	@endtime date,
	@binId varchar(50)
	
AS
BEGIN
SET NOCOUNT ON;

select cbsm_bin_name as cbsm_bin_name,hourdata,sum(predictvol) as predictvol,sum(actualvol) as actualvol from (select 0 as predictvol ,avg(bsl_garbage_volume) as actualvol,cbsm_bin_id,cbsm_bin_name,
datepart(HOUR,bsl_utc_date_time) as hourdata 
         				from dbo.bin_sensor_log 
         				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
						left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id
         				where CONVERT(VARCHAR(10),bsl_utc_date_time,120) between @stattime and @endtime 
						and cbsm_bin_id in (select * from [dbo].[fnSplitString] (@binId, ','))
         				group by datepart(HOUR,bsl_utc_date_time),cbsm_bin_id,cbsm_bin_name
						union
						select avg(CONVERT(INT,bspa_Predicted_Volume))  as predictvol,0 as actualvol, cbsm_bin_id,cbsm_bin_name,datepart(HOUR,bspa_DateTime) as hourdata 
    					
						from [analytics].[bin_sensor_predictive_alert_new]
						 left join admin.config_bin_sensor_master on cbsm_bin_id=bspa_Bin_ID
						
    					where 
						--bspa_Predicted_Pick_Up_Alert=1 
						--and
						 CONVERT(VARCHAR(10),bspa_DateTime,120) between @stattime and   @endtime
						 and cbsm_bin_id in (select * from [dbo].[fnSplitString] (@binId, ','))
						 
					
    					group by datepart(HOUR,bspa_DateTime),cbsm_bin_id,cbsm_bin_name
    					
						 
         				)  as t1
						group by hourdata,cbsm_bin_id,cbsm_bin_name
						order by hourdata




END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_collectedVolTripForChartByWard]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_collectedVolTripForChartByWard] 
      
	@ulb int, 
	@stattime date,
	@endtime date,
	@wardId varchar(50)
	     
AS
BEGIN
SET NOCOUNT ON;
select sum(totweight) as totalweight,wardName,wardID,hourdata  from ( select avg(tom_weight_disposed) as totweight,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,datepart(HOUR,tom_trip_schedule_date_time) as hourdata 
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120) between @stattime and @endtime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,datepart(HOUR,tom_trip_schedule_date_time) 
    			union select avg(tcm_weight_disposed) as totweight,cwm_ward_name as wardName,cwm_id_pk as wardID,
				cwm_ulb_id_fk as ulb,datepart(HOUR,tcm_trip_date_time) as hourdata
    			from [reporting].[trip_completed_master] 
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where CONVERT(VARCHAR(10),tcm_trip_date_time,120) between  @stattime and @endtime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,datepart(HOUR,tcm_trip_date_time))as t1 
    			where ulb=@ulb and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,hourdata
END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_Existing_schedule]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_Existing_schedule] 
      
	  	@ulbid int,  
	@wardId int,
	@vehId int,  
	@actualParam varchar(5),
	@datetime datetime,
	@staffId int,
	@shiftId int
	     
AS
BEGIN
SET NOCOUNT ON;
IF (@actualParam ='true')
BEGIN

if(@staffId = 0 AND @shiftId = 0 and @vehId=0 and @wardId=0)--All filters true
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_type_id_fk as veh_type_id,cfm_vehicle_no as vehicle_name,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,CONVERT(VARCHAR(19),tcm_start_date_time,120) as starttime,CONVERT(VARCHAR(19),tcm_end_date_time,120) as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where 
--tcm_vehicle_id_fk=@vehId and 
CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120)
--select * from garbage.route_master  19086

--select * from reporting.trip_completed_details where tcd_master_id_fk=4139
--select * from reporting.trip_completed_master
--select * from scheduling.schedule_trip_master
--select * from admin.config_staff_master where cssm_id_pk=7025
END;
else if(@staffId = 0 AND @shiftId = 0 and @wardId=0 and @vehId<>0)--staff & shift true vehicle will pass
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_type_id_fk as veh_type_id,cfm_vehicle_no as vehicle_name,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where 
tcm_vehicle_id_fk=@vehId and 
CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120)
--select * from garbage.route_master  19086
--select * from reporting.trip_completed_details where tcd_master_id_fk=4139
--select * from reporting.trip_completed_master
--select * from scheduling.schedule_trip_master
--select * from admin.config_staff_master where cssm_id_pk=7025
END;
else if(@staffId > 0 AND @shiftId = 0 and @vehId=0 and @wardId=0)/*//filter staffId */
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where 
--tcm_vehicle_id_fk=@vehId and
 CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and @staffId in(select * from [dbo].[fnSplitString] (stm_staff, ','))
END;
else if(@staffId > 0 AND @shiftId = 0 and @vehId<>0 and @wardId=0)/*//filter staffId & vehicle*/
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where tcm_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and @staffId in(select * from [dbo].[fnSplitString] (stm_staff, ','))
END;

else if(@staffId > 0 AND @shiftId > 0 and  @vehId=0 and @wardId=0)/*//filter staffId & shiftid*/
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where 
--tcm_vehicle_id_fk=@vehId and 
CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and @staffId in(select * from [dbo].[fnSplitString] (stm_staff, ','))
and csm_id_pk=@shiftId
END;
else if(@staffId > 0 AND @shiftId > 0 and @vehId<>0)/*//filter staffId & shiftid*/
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where tcm_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and @staffId in(select * from [dbo].[fnSplitString] (stm_staff, ','))
and csm_id_pk=@shiftId
END;
else if(@staffId = 0 AND @shiftId > 0 and  @vehId=0 and @wardId=0)/*//filter shiftid*/
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where 
--tcm_vehicle_id_fk=@vehId and 
CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) 
and csm_id_pk=@shiftId
END;
else if(@staffId = 0 AND @shiftId > 0 and  @vehId<>0 and @wardId=0)/*//filter shiftid*/
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where tcm_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) 
and csm_id_pk=@shiftId
END;
else if(@staffId = 0 AND @shiftId = 0 and  @vehId=0 and @wardId<>0)/*//filter wardid*/
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where cfm_ward_id=@wardId
and CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) 

END;
else if(@staffId = 0 AND @shiftId = 0 and  @vehId<>0 and @wardId<>0)/*//filter wardid & vehid*/
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where cfm_ward_id=@wardId and tcm_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) 

END;
else if(@staffId = 0 AND @shiftId <> 0 and  @vehId<>0 and @wardId<>0)/*//filter wardid & vehid & staff*/
BEGIN
select tcm_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tcm_trip_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tcm_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tcm_start_date_time as starttime,tcm_end_date_time as endtime from reporting.trip_completed_master
left join garbage.route_master on rm_id_pk=tcm_route_id_fk
left join admin.config_fleet_master on tcm_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tcm_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where cfm_ward_id=@wardId and tcm_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tcm_trip_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) 
and csm_id_pk=@shiftId
END;


END;



else IF (@actualParam ='false')
BEGIN

if(@staffId = 0 AND @shiftId = 0 and @vehId=0 and @wardId=0)--All filters true
BEGIN

select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_type_id_fk as veh_type_id,cfm_vehicle_no as vehicle_name,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where 
--tom_vehicle_id_fk=@vehId and 
CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1
--select * from garbage.route_master  19086
--select * from reporting.trip_completed_details where tcd_master_id_fk=4139
--select *,tom_trip_schedule_date_time,tom_route_id,tom_trip_id_fk from reporting.trip_ongoing_master
--select * from scheduling.schedule_trip_master
--select * from admin.config_staff_master where cssm_id_pk=7025
END;
else if(@staffId = 0 AND @shiftId = 0 and @vehId<>0 and @wardId=0)--vehicle will pass
BEGIN

select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_type_id_fk as veh_type_id,cfm_vehicle_no as vehicle_name,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where tom_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1
--select * from garbage.route_master  19086
--select * from reporting.trip_completed_details where tcd_master_id_fk=4139
--select *,tom_trip_schedule_date_time,tom_route_id,tom_trip_id_fk from reporting.trip_ongoing_master
--select * from scheduling.schedule_trip_master
--select * from admin.config_staff_master where cssm_id_pk=7025
END;
else if(@staffId > 0 AND @shiftId = 0 and @vehId=0 and @wardId=0)/*//filter staffId*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tom_trip_schedule_date_time as starttime,tom_trip_schedule_date_time as endtime 
from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where 
--tom_vehicle_id_fk=@vehId and 
CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1 and @staffId in(select * from [dbo].[fnSplitString] (stm_staff, ','))
END;

else if(@staffId > 0 AND @shiftId = 0 and @vehId<>0 and @wardId=0)/*//filter staffId & vehid*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route,tom_trip_schedule_date_time as starttime,tom_trip_schedule_date_time as endtime 
from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where tom_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1 and @staffId in(select * from [dbo].[fnSplitString] (stm_staff, ','))
END;

else if(@staffId > 0 AND @shiftId > 0 and @vehId=0 and @wardId=0)/*//filter staffId & shiftid*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where 
--tom_vehicle_id_fk=@vehId and 
CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1 and @staffId in(select * from [dbo].[fnSplitString] (stm_staff, ','))
and csm_id_pk=@shiftId
END;
else if(@staffId > 0 AND @shiftId > 0 and @vehId<>0 and @wardId=0)/*//filter staffId & shiftid*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where tom_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1 and @staffId in(select * from [dbo].[fnSplitString] (stm_staff, ','))
and csm_id_pk=@shiftId
END;
else if(@staffId = 0 AND @shiftId > 0 and @vehId=0 and @wardId=0)/*//filter shiftid*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where 
--tom_vehicle_id_fk=@vehId and 
CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1
and csm_id_pk=@shiftId
END;
else if(@staffId = 0 AND @shiftId > 0 and @vehId<>0 and @wardId=0)/*//filter shiftid*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where tom_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1
and csm_id_pk=@shiftId
END;

else if(@staffId = 0 AND @shiftId = 0 and @vehId=0 and @wardId<>0)/*//filter wardId*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where cfm_ward_id=@wardId
and CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1

END;
else if(@staffId = 0 AND @shiftId = 0 and @vehId<>0 and @wardId<>0)/*//filter wardId & vehid*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where cfm_ward_id=@wardId and tom_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1

END;
else if(@staffId = 0 AND @shiftId <> 0 and @vehId<>0 and @wardId<>0)/*//filter wardId & vehid ShiftId*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where cfm_ward_id=@wardId and tom_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1
and csm_id_pk=@shiftId

END;
else if(@staffId = 0 AND @shiftId <> 0 and @vehId<>0 and @wardId<>0)/*//filter wardId & vehid ShiftId staffId*/
BEGIN
select tom_vehicle_id_fk as vehicle_id,stm_id_pk,gcf_address as vehicle_location,cfm_vehicle_no as vehicle_name,cfm_vehicle_type_id_fk as veh_type_id,cfc_type as vechile_type,[gcf_the_geom].STY as lat,
[gcf_the_geom].STX as lon,csm_id_pk as shift_id,csm_shift_name as shift_name,CONVERT(VARCHAR(19),tom_trip_schedule_date_time,120) as date_time,
stm_staff as staff_id,(select staffName from [dbo].[fnAppendString](tom_trip_id_fk) as staffname) as staff_name,
rm_geom.STAsText ( ) as schedule_route from reporting.trip_ongoing_master
left join garbage.route_master on rm_id_pk=tom_route_id_fk
left join admin.config_fleet_master on tom_vehicle_id_fk=cfm_id_pk
left join admin.config_fleet_category on cfm_vehicle_type_id_fk=cfc_id_pk
left join dbo.view_online_master on vom_vehicle_id=cfm_id_pk
left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
left join scheduling.schedule_trip_master on stm_id_pk=tom_trip_id_fk
left join [garbage].[gis_client_fence] on stm_start_location=gcf_id_pk
where cfm_ward_id=@wardId and tom_vehicle_id_fk=@vehId
and CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120)=CONVERT(VARCHAR(10),@datetime,120) and vom_status=1
and csm_id_pk=@shiftId
and @staffId in(select * from [dbo].[fnSplitString] (stm_staff, ','))

END;
END;

END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_GetBinIddetails]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_GetBinIddetails] 
      
	  	@ulbid int,  
	@chartTime int,  
	@geom varchar(max), 
	@datetime  varchar(max)
AS
BEGIN
SET NOCOUNT ON;
if(@geom != null OR  @geom <> '' OR @geom <> null OR  @geom <> '' ) /**WITH GEOM**/
BEGIN
IF(@chartTime>0)/**WITH GEOM & CHART TIME**/
BEGIN
select wardID,wardName,binFullPer,binLocID,binLocName,lat,lon,Id,binIDName,updatedDate,
       		 		case when binFullPer<50 then 'Low' when binFullPer>50 and binFullPer<90 then 'Medium' 
       		 		when binFullPer>90 then 'high' end as binFillStatus 
       		 		from [dbo].[v_analytic_binId_details] 
       		 		where ULBId=@ulbid
       		 		and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( lon ,lat  , 4326))=1) 
       		 		and wardId <> 0 
					and  datepart(HOUR,updatedDate) = @chartTime
END;
ELSE /**WITH GEOM & NOT CHART TIME**/
BEGIN
select wardID,wardName,binFullPer,binLocID,binLocName,lat,lon,Id,binIDName,updatedDate,
       		 		case when binFullPer<50 then 'Low' when binFullPer>50 and binFullPer<90 then 'Medium' 
       		 		when binFullPer>90 then 'high' end as binFillStatus 
       		 		from [dbo].[v_analytic_binId_details] 
       		 		where ULBId=@ulbid
       		 		and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( lon ,lat  , 4326))=1) 
       		 		and wardId <> 0 
				
END;
	
END;
ELSE
BEGIN
IF(@chartTime>0)/**WITHOUT GEOM & CHART TIME**/
BEGIN
select wardID,wardName,binFullPer,binLocID,binLocName,lat,lon,Id,binIDName,updatedDate,
       		 		case when binFullPer<50 then 'Low' when binFullPer>50 and binFullPer<90 then 'Medium' 
       		 		when binFullPer>90 then 'high' end as binFillStatus 
       		 		from [dbo].[v_analytic_binId_details] 
       		 		where ULBId=@ulbid
       		 		and wardId <> 0 
					and  datepart(HOUR,updatedDate) = @chartTime
END;
ELSE /**WITHOUT GEOM & NOT CHART TIME**/
BEGIN
select wardID,wardName,binFullPer,binLocID,binLocName,lat,lon,Id,binIDName,updatedDate,
       		 		case when binFullPer<50 then 'Low' when binFullPer>50 and binFullPer<90 then 'Medium' 
       		 		when binFullPer>90 then 'high' end as binFillStatus 
       		 		from [dbo].[v_analytic_binId_details] 
       		 		where ULBId=@ulbid
       		 		and wardId <> 0 
				
END;
END;
END

GO
/****** Object:  StoredProcedure [dbo].[analytics_HistoryTripCount]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_HistoryTripCount] 
      
	  	@ulbid int,  
	@chartTime int,
	@binId int,  
	@wardId varchar(max),
	@fromdate date,
	@todate date,
	@geom varchar(max)          
AS
BEGIN
SET NOCOUNT ON;
if(@geom != null OR  @geom <> '' OR @geom <> null OR  @geom <> '' ) /**WITH GEOM**/
BEGIN
IF(@chartTime<0 AND @binId =-1 )/**WITH out CHART TIME && binid all**/
BEGIN

select sum(tripcount) as tripCount,wardName,wardID ,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_ongoing_master] 
				left join [reporting].[trip_ongoing_details] on tod_master_id_fk=tom_id_pk
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tod_bin_id_fk
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where tom_trip_schedule_date_time between @fromdate and @todate
				and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
				and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    			union select count(tcm_id_pk) as tripcount,cwm_ward_name as wardName,cwm_id_pk as wardID,cwm_ulb_id_fk as ulb,
				cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_completed_master] 
				left join [reporting].trip_completed_details on tcd_master_id_fk=tcm_id_pk 
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tcd_bin_id_fk
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where tcm_trip_date_time between  @fromdate and @todate
				and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
				and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,cfm_id_pk,cfm_vehicle_no)as t1 
    			where ulb=@ulbid  group by wardName,wardID,veh_No,veh_Id
END; 

IF(@chartTime>0 AND @binId =-1 ) /**WITH chart & NOT binId**/
BEGIN

select sum(tripcount) as tripCount,wardName,wardID ,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_ongoing_master]
				left join [reporting].[trip_ongoing_details] on tod_master_id_fk=tom_id_pk
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tod_bin_id_fk 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tom_trip_schedule_date_time) between @fromdate and @todate
				and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
				and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
				and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    			union select count(tcm_id_pk) as tripcount,cwm_ward_name as wardName,cwm_id_pk as wardID,cwm_ulb_id_fk as ulb,
				cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_completed_master] 
				left join [reporting].trip_completed_details on tcd_master_id_fk=tcm_id_pk 
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tcd_bin_id_fk
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tcm_trip_date_time)  between  @fromdate and @todate
				and  datepart(HOUR,tcm_trip_date_time) = @chartTime
				and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
				and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,cfm_id_pk,cfm_vehicle_no)as t1 
    			where ulb=@ulbid group by wardName,wardID,veh_No,veh_Id

END;
IF(@chartTime<0 AND @binId <>-1 )/**WITH no chart &  binId**/
BEGIN


select sum(tripcount) as tripCount,wardName,wardID ,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
				left join [reporting].[trip_ongoing_details] on tod_master_id_fk=tom_id_pk
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tod_bin_id_fk
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tom_trip_schedule_date_time) between @fromdate and @todate
				and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
				and cbsm_bin_id=@binId
				and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
				and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    			union select count(tcm_id_pk) as tripcount,cwm_ward_name as wardName,cwm_id_pk as wardID,cwm_ulb_id_fk as ulb,
				cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_completed_master]
				left join [reporting].trip_completed_details on tcd_master_id_fk=tcm_id_pk 
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tcd_bin_id_fk
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tcm_trip_date_time)  between  @fromdate and @todate
				and  datepart(HOUR,tcm_trip_date_time) = @chartTime
				and cbsm_bin_id=@binId
				and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
				and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,cfm_id_pk,cfm_vehicle_no)as t1 
    			where ulb=@ulbid  group by wardName,wardID,veh_No,veh_Id



END;
IF(@chartTime>0 AND @binId <>-1 )/**WITH  chart &  binId**/
BEGIN

select sum(tripcount) as tripCount,wardName,wardID ,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
				left join [reporting].[trip_ongoing_details] on tod_master_id_fk=tom_id_pk
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tod_bin_id_fk
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tom_trip_schedule_date_time) between @fromdate and @todate
				and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
				and cbsm_bin_id=@binId
				and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
				and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
			    and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    			union select count(tcm_id_pk) as tripcount,cwm_ward_name as wardName,cwm_id_pk as wardID,cwm_ulb_id_fk as ulb,
				cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_completed_master]
				left join [reporting].trip_completed_details on tcd_master_id_fk=tcm_id_pk 
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tcd_bin_id_fk
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tcm_trip_date_time)  between  @fromdate and @todate
				and  datepart(HOUR,tcm_trip_date_time) = @chartTime
				and cbsm_bin_id=@binId
				and  datepart(HOUR,tcm_trip_date_time) = @chartTime
				and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
				and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,cfm_id_pk,cfm_vehicle_no)as t1 
    			where ulb=@ulbid 
				group by wardName,wardID,veh_No,veh_Id
END;
END;


ELSE
BEGIN
IF(@chartTime<0 AND @binId =-1 )/**WITH out CHART TIME && binid all**/
BEGIN

select sum(tripcount) as tripCount,wardName,wardID ,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where tom_trip_schedule_date_time between @fromdate and @todate
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    			union select count(tcm_id_pk) as tripcount,cwm_ward_name as wardName,cwm_id_pk as wardID,cwm_ulb_id_fk as ulb,
				cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_completed_master] 
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where tcm_trip_date_time between  @fromdate and @todate
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,cfm_id_pk,cfm_vehicle_no)as t1 
    			where ulb=@ulbid and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,veh_No,veh_Id
END; 

IF(@chartTime>0 AND @binId =-1 ) /**WITH chart & NOT binId**/
BEGIN

select sum(tripcount) as tripCount,wardName,wardID ,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tom_trip_schedule_date_time) between @fromdate and @todate
				and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    			union select count(tcm_id_pk) as tripcount,cwm_ward_name as wardName,cwm_id_pk as wardID,cwm_ulb_id_fk as ulb,
				cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_completed_master] 
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tcm_trip_date_time)  between  @fromdate and @todate
				and  datepart(HOUR,tcm_trip_date_time) = @chartTime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,cfm_id_pk,cfm_vehicle_no)as t1 
    			where ulb=@ulbid and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,veh_No,veh_Id

END;
IF(@chartTime<0 AND @binId <>-1 )/**WITH no chart &  binId**/
BEGIN


select sum(tripcount) as tripCount,wardName,wardID ,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
				left join [reporting].[trip_ongoing_details] on tod_master_id_fk=tom_id_pk
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tod_bin_id_fk
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tom_trip_schedule_date_time) between @fromdate and @todate
				and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
				and cbsm_bin_id=@binId
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    			union select count(tcm_id_pk) as tripcount,cwm_ward_name as wardName,cwm_id_pk as wardID,cwm_ulb_id_fk as ulb,
				cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_completed_master]
				left join [reporting].trip_completed_details on tcd_master_id_fk=tcm_id_pk 
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tcd_bin_id_fk
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tcm_trip_date_time)  between  @fromdate and @todate
				and  datepart(HOUR,tcm_trip_date_time) = @chartTime
				and cbsm_bin_id=@binId
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,cfm_id_pk,cfm_vehicle_no)as t1 
    			where ulb=@ulbid and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,veh_No,veh_Id



END;
IF(@chartTime>0 AND @binId <>-1 )/**WITH  chart &  binId**/
BEGIN

select sum(tripcount) as tripCount,wardName,wardID ,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
				left join [reporting].[trip_ongoing_details] on tod_master_id_fk=tom_id_pk
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tod_bin_id_fk
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tom_trip_schedule_date_time) between @fromdate and @todate
				and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
				and cbsm_bin_id=@binId
				and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    			union select count(tcm_id_pk) as tripcount,cwm_ward_name as wardName,cwm_id_pk as wardID,cwm_ulb_id_fk as ulb,
				cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    			from [reporting].[trip_completed_master]
				left join [reporting].trip_completed_details on tcd_master_id_fk=tcm_id_pk 
				left join admin.config_bin_sensor_master on cbsm_bin_loc_id=tcd_bin_id_fk
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where convert(date,tcm_trip_date_time)  between  @fromdate and @todate
				and  datepart(HOUR,tcm_trip_date_time) = @chartTime
				and cbsm_bin_id=@binId
				and  datepart(HOUR,tcm_trip_date_time) = @chartTime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,cfm_id_pk,cfm_vehicle_no)as t1 
    			where ulb=@ulbid and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
				group by wardName,wardID,veh_No,veh_Id
END;
END;


END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_hourlyData]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_hourlyData] 
      
	  	@dataInput int,  
	@ulb int,
	@binId int,  
	@geom varchar(max),
	@vehId int,
	@fromdate datetime,
	@todate datetime,
	@wardId varchar(max)
	
AS
BEGIN
SET NOCOUNT ON;

if (@dataInput = 1)
BEGIN
IF(@vehId=-1 AND @binId =-1 AND @geom='All')/**Default all**/
BEGIN

select avg(bsl_volume_fill_percentage) as avgVolume,
CONVERT(VARCHAR(10),bsl_utc_date_time,120) as date,datepart(HOUR,bsl_utc_date_time) as hourdata 
         				from dbo.bin_sensor_log 
         				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
         				left join admin.config_bin_master on cbsm_bin_id = [cbm_id_pk]
						where bsl_utc_date_time between @fromdate and @todate
						and cbm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
         				group by datepart(day,bsl_utc_date_time),CONVERT(VARCHAR(10),bsl_utc_date_time,120),datepart(HOUR,bsl_utc_date_time) 
         				order by datepart(day,bsl_utc_date_time),datepart(HOUR,bsl_utc_date_time)
END; 
IF(@vehId<>-1 AND @binId =-1 AND @geom='All')/**VehicleId**/
BEGIN

select avg(bsl_volume_fill_percentage) as avgVolume,datepart(HOUR,bsl_utc_date_time) as hourdata
					from dbo.bin_sensor_log 
					left join  [reporting].trip_ongoing_master on CONVERT(VARCHAR(10),bsl_utc_date_time,120)  = CONVERT(VARCHAR(10),tom_start_date_time,120)
					left join [reporting].trip_ongoing_details on tod_master_id_fk=tom_id_pk
					left join admin.config_bin_sensor_master cbsm on cbsm_bin_loc_id= tod_bin_id_fk 
					left join admin.config_bin_sensor_master cbm on cbm.cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
					where tom_trip_schedule_date_time between @fromdate and  @todate
					 and bsl_utc_date_time between  @fromdate and @todate
					and  tom_vehicle_id_fk=@vehId
					and cbsm.cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
					group by datepart(HOUR,bsl_utc_date_time)

END; 
IF(@vehId<>-1 AND @binId <>-1 AND @geom='All')/**VehicleId & binId**/
BEGIN

select avg(bsl_volume_fill_percentage) as avgVolume,datepart(HOUR,bsl_utc_date_time) as hourdata
					from dbo.bin_sensor_log 
					left join  [reporting].trip_ongoing_master on CONVERT(VARCHAR(10),bsl_utc_date_time,120)  = CONVERT(VARCHAR(10),tom_start_date_time,120)
					left join [reporting].trip_ongoing_details on tod_master_id_fk=tom_id_pk
					left join admin.config_bin_sensor_master cbsm on cbsm_bin_loc_id= tod_bin_id_fk 
					left join admin.config_bin_sensor_master cbm on cbm.cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
					where tom_trip_schedule_date_time between @fromdate and  @todate
					 and bsl_utc_date_time between  @fromdate and @todate
					and  tom_vehicle_id_fk=@vehId
					and cbsm.cbsm_bin_id=@binId
					and cbsm.cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
					group by datepart(HOUR,bsl_utc_date_time)



END;
IF(@vehId<>-1 AND @binId =-1 AND @geom<>'All')/**VehicleId & geom**/
BEGIN

select avg(bsl_volume_fill_percentage) as avgVolume,datepart(HOUR,bsl_utc_date_time) as hourdata
					from dbo.bin_sensor_log 
					left join  [reporting].trip_ongoing_master on CONVERT(VARCHAR(10),bsl_utc_date_time,120)  = CONVERT(VARCHAR(10),tom_start_date_time,120)
					left join [reporting].trip_ongoing_details on tod_master_id_fk=tom_id_pk
					left join admin.config_bin_sensor_master cbsm on cbsm_bin_loc_id= tod_bin_id_fk 
					left join admin.config_bin_sensor_master cbm on cbm.cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
					where tom_trip_schedule_date_time between @fromdate and  @todate
					 and bsl_utc_date_time between  @fromdate and @todate
					and  tom_vehicle_id_fk=@vehId
					and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm.cbsm_bin_longitude ,cbsm.cbsm_bin_latitude  , 4326))=1) 
						and cbsm.cbsm_bin_longitude is not null and cbsm.cbsm_bin_latitude is not null
					and cbsm.cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
					group by datepart(HOUR,bsl_utc_date_time)



END;
IF(@vehId=-1 AND @binId <>-1 AND @geom='All')/**bINiD**/
BEGIN

select avg(bsl_volume_fill_percentage) as avgVolume,datepart(HOUR,bsl_utc_date_time) as hourdata 
        				from dbo.bin_sensor_log 
        				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
        				where bsl_utc_date_time between @fromdate and @todate
        				and cbsm_bin_id=@binId
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
        				group by datepart(HOUR,bsl_utc_date_time) 
        				order by datepart(HOUR,bsl_utc_date_time)
END;
IF(@vehId=-1 AND @binId <>-1 AND @geom<>'All')/**bINiD & geom**/
BEGIN

select avg(bsl_volume_fill_percentage) as avgVolume,datepart(HOUR,bsl_utc_date_time) as hourdata 
        				from dbo.bin_sensor_log 
        				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
        				where bsl_utc_date_time between @fromdate and @todate
        				 and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude , 4326))=1) 
                 	    and cbsm_bin_id=@binId
						and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
        				group by datepart(HOUR,bsl_utc_date_time)
        				order by datepart(HOUR,bsl_utc_date_time)
END;
IF(@vehId=-1 AND @binId =-1 AND @geom<>'All')/** geom**/
BEGIN

select avg(bsl_volume_fill_percentage) as avgVolume,datepart(HOUR,bsl_utc_date_time) as hourdata 
        				from dbo.bin_sensor_log 
        				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
        				where bsl_utc_date_time between @fromdate and @todate
        				 and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude  , 4326))=1) 
						 and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
						 and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
        				group by datepart(HOUR,bsl_utc_date_time)
        				order by datepart(HOUR,bsl_utc_date_time)
END;
	RETURN;
END;
if (@dataInput = 2)
BEGIN
IF(@vehId=-1 AND @binId =-1 AND @geom='All')/**Default all**/
BEGIN

select cbsm_bin_id as Id,cbsm_bin_name as bin_name,avg(bsl_volume_fill_percentage) as avgVolume,cbsm_bin_latitude as lat,cbsm_bin_longitude as lon,
datepart(HOUR,bsl_utc_date_time) as hourdata 
         				from dbo.bin_sensor_log 
         				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
         				left join admin.config_bin_master on cbsm_bin_id = [cbm_id_pk]
						where CONVERT(VARCHAR(10),bsl_utc_date_time,120) between CONVERT(VARCHAR(10),@fromdate,120) and CONVERT(VARCHAR(10),@todate,120) 
						and cbm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
         				group by cbsm_bin_name,datepart(HOUR,bsl_utc_date_time),cbsm_bin_latitude,cbsm_bin_longitude,cbsm_bin_id 
         				order by datepart(HOUR,bsl_utc_date_time)
END; 
IF(@vehId<>-1 AND @binId =-1 AND @geom='All')/**VehicleId**/
BEGIN

select cbsm_bin_id,cbsm_bin_name as bin_name,avg(bsl_volume_fill_percentage) as avgVolume,cbsm_bin_latitude,cbsm_bin_longitude,
datepart(HOUR,bsl_utc_date_time) as hourdata 
      				from dbo.bin_sensor_log 
      				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
      				left join  [reporting].trip_ongoing_master on bsl_utc_date_time between tom_start_date_time and  tom_end_date_time 
      				where tom_vehicle_id_fk=@vehId and CONVERT(VARCHAR(10),bsl_utc_date_time,120) between CONVERT(VARCHAR(10),@fromdate,120) and CONVERT(VARCHAR(10),@todate,120) 
					and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
      				group by cbsm_bin_name,datepart(HOUR,bsl_utc_date_time),cbsm_bin_latitude,cbsm_bin_longitude,cbsm_bin_id
END; 
IF(@vehId<>-1 AND @binId <>-1 AND @geom='All')/**VehicleId & binId**/
BEGIN

select cbsm_bin_id,cbsm_bin_name as bin_name,avg(bsl_volume_fill_percentage) as avgVolume,cbsm_bin_latitude,cbsm_bin_longitude,
datepart(HOUR,bsl_utc_date_time) as hourdata 
        				from dbo.bin_sensor_log 
        				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
        				left join  [reporting].trip_ongoing_master on bsl_utc_date_time between tom_start_date_time and  tom_end_date_time 
        				where tom_vehicle_id_fk=@vehId and CONVERT(VARCHAR(10),bsl_utc_date_time,120) between CONVERT(VARCHAR(10),@fromdate,120) and CONVERT(VARCHAR(10),@todate,120) 
        				and cbsm_bin_id=@binId
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
        				group by cbsm_bin_name,datepart(HOUR,bsl_utc_date_time),cbsm_bin_latitude,cbsm_bin_longitude,cbsm_bin_id
        				 order by datepart(HOUR,bsl_utc_date_time)
END;
IF(@vehId<>-1 AND @binId =-1 AND @geom<>'All')/**VehicleId & geom**/
BEGIN

select cbsm_bin_id,cbsm_bin_name as bin_name,avg(bsl_volume_fill_percentage) as avgVolume,cbsm_bin_latitude,cbsm_bin_longitude,datepart(HOUR,bsl_utc_date_time) as hourdata 
        				from dbo.bin_sensor_log 
        				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
        				left join  [reporting].trip_ongoing_master on bsl_utc_date_time between tom_start_date_time and  tom_end_date_time 
        				where tom_vehicle_id_fk=@vehId and CONVERT(VARCHAR(10),bsl_utc_date_time,120) between CONVERT(VARCHAR(10),@fromdate,120) and CONVERT(VARCHAR(10),@todate,120) 
						and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
        				and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude  , 4326))=1) 
        				group by cbsm_bin_name,datepart(HOUR,bsl_utc_date_time),cbsm_bin_latitude,cbsm_bin_longitude,cbsm_bin_id
        				 order by datepart(HOUR,bsl_utc_date_time)
END;
IF(@vehId=-1 AND @binId <>-1 AND @geom='All')/**bINiD**/
BEGIN

select cbsm_bin_id as Id,cbsm_bin_name as bin_name,avg(bsl_volume_fill_percentage) as avgVolume,cbsm_bin_latitude as lat,cbsm_bin_longitude as lon,CONVERT(VARCHAR(10),bsl_utc_date_time,120) as date,datepart(HOUR,bsl_utc_date_time) as hourdata 
        				from dbo.bin_sensor_log 
        				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
        				where CONVERT(VARCHAR(10),bsl_utc_date_time,120) between CONVERT(VARCHAR(10),@fromdate,120) and CONVERT(VARCHAR(10),@todate,120) 
        				and cbsm_bin_id=@binId
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
        				group by cbsm_bin_name,CONVERT(VARCHAR(10),bsl_utc_date_time,120),datepart(HOUR,bsl_utc_date_time),cbsm_bin_latitude,cbsm_bin_longitude,cbsm_bin_id 
        				order by datepart(HOUR,bsl_utc_date_time)
END;
IF(@vehId=-1 AND @binId <>-1 AND @geom<>'All')/**bINiD & geom**/
BEGIN

select cbsm_bin_id as Id,cbsm_bin_name as bin_name,avg(bsl_volume_fill_percentage) as avgVolume,cbsm_bin_latitude as lat,cbsm_bin_longitude as lon,CONVERT(VARCHAR(10),bsl_utc_date_time,120) as date,datepart(HOUR,bsl_utc_date_time) as hourdata 
        				from dbo.bin_sensor_log 
        				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
        				where CONVERT(VARCHAR(10),bsl_utc_date_time,120) between CONVERT(VARCHAR(10),@fromdate,120) and CONVERT(VARCHAR(10),@todate,120) 
        				 and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude , 4326))=1) 
						 and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null 
                 	    and cbsm_bin_id=@binId
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
        				group by cbsm_bin_name,CONVERT(VARCHAR(10),bsl_utc_date_time,120),datepart(HOUR,bsl_utc_date_time),cbsm_bin_latitude,cbsm_bin_longitude,cbsm_bin_id 
        				order by datepart(HOUR,bsl_utc_date_time)
END;
IF(@vehId=-1 AND @binId =-1 AND @geom<>'All')/** geom**/
BEGIN

select cbsm_bin_id as Id,cbsm_bin_name as bin_name,avg(bsl_volume_fill_percentage) as avgVolume,cbsm_bin_latitude as lat,cbsm_bin_longitude as lon,CONVERT(VARCHAR(10),bsl_utc_date_time,120) as date,datepart(HOUR,bsl_utc_date_time) as hourdata 
        				from dbo.bin_sensor_log 
        				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
        				where CONVERT(VARCHAR(10),bsl_utc_date_time,120) between CONVERT(VARCHAR(10),@fromdate,120) and CONVERT(VARCHAR(10),@todate,120)  
        				 and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude  , 4326))=1) 
						 and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null 
						 and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
        				group by cbsm_bin_name,CONVERT(VARCHAR(10),bsl_utc_date_time,120),datepart(HOUR,bsl_utc_date_time),cbsm_bin_latitude,cbsm_bin_longitude,cbsm_bin_id 
        				order by datepart(HOUR,bsl_utc_date_time)
END;
END;

END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_hourlyData_predicted]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_hourlyData_predicted] 
      
	  
	@ulb int,
	@binId int,  
	@geom varchar(max),
	@day varchar(20),
	@fromdate datetime,
	@todate datetime,
    @wardId varchar(max)
	
AS
BEGIN
SET NOCOUNT ON;


IF( @binId =-1 AND @geom='All'  AND @day='All') /**Default all**/
BEGIN
select datepart(HOUR,bspa_DateTime) as hourdata,CONVERT(VARCHAR(10),bspa_DateTime,120) as date, 
    					avg(CONVERT(INT,bspa_Predicted_Volume)) as avgVolume from [analytics].[bin_sensor_predictive_alert_new] 
						left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID   
    					left join admin.config_bin_master on cbsm_bin_id = [cbm_id_pk] 
						where 
						--bspa_Predicted_Pick_Up_Alert=1 and
						 CONVERT(VARCHAR(10),bspa_DateTime,120)=convert(date,@fromdate) 
						-- and datepart(HOUR,bspa_DateTime)  = datepart(HOUR,@fromdate)
						 and cbm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
    					group by CONVERT(VARCHAR(10),bspa_DateTime,120),datepart(HOUR,bspa_DateTime) 
    					order by datepart(HOUR,bspa_DateTime)
END;
IF( @binId <>-1 AND @geom='All'  AND @day='All') /**binId**/
BEGIN
select cbsm_bin_id as Id,cbsm_bin_name as bin_name,datepart(HOUR,bspa_DateTime) as hourdata,avg(CONVERT(INT, 
    					bspa_Predicted_Volume)) as avgVolume from [analytics].[bin_sensor_predictive_alert_new] 
    					left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID   
    					where 
						--bspa_Predicted_Pick_Up_Alert=1 and 
						CONVERT(VARCHAR(10),bspa_DateTime,120)=convert(date,@fromdate)  
						-- and datepart(HOUR,bspa_DateTime)  = datepart(HOUR,@fromdate)
    					and cbsm_bin_id=@binId 
    					and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null 
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
    					group by datepart(HOUR,bspa_DateTime),cbsm_bin_id,cbsm_bin_name
END;
IF( @binId <>-1 AND @geom<>'All'  AND @day='All') /**binId & geom**/
BEGIN
select cbsm_bin_id as Id,cbsm_bin_name as bin_name,datepart(HOUR,bspa_DateTime) as hourdata,CONVERT(VARCHAR(10),bspa_DateTime,120),avg(CONVERT(INT, 
    					bspa_Predicted_Volume)) as avgVolume from [analytics].[bin_sensor_predictive_alert_new] 
    					left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID   
    					where 
						--bspa_Predicted_Pick_Up_Alert=1 and
						 CONVERT(VARCHAR(10),bspa_DateTime,120)=convert(date,@fromdate) 
						 -- and datepart(HOUR,bspa_DateTime)  = datepart(HOUR,@fromdate)
    					and cbsm_bin_id=@binId
    							and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null 
								and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
    					and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude  , 4326))=1) 
    					group by CONVERT(VARCHAR(10),bspa_DateTime,120),datepart(HOUR,bspa_DateTime),cbsm_bin_id,cbsm_bin_name
END;
IF( @binId <>-1 AND @geom='All'  AND @day<>'All') /**binId & day**/
BEGIN
select cbsm_bin_id as Id,cbsm_bin_name as bin_name,datepart(HOUR,bspa_DateTime) as hourdata,avg(CONVERT(INT, 
    					bspa_Predicted_Volume)) as avgVolume from [analytics].[bin_sensor_predictive_alert_new] 
    					left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID  
    					where 
						--bspa_Predicted_Pick_Up_Alert=1 and
						 CONVERT(VARCHAR(10),bspa_DateTime,120)=convert(date,@day)  
						 -- and datepart(HOUR,bspa_DateTime)  = datepart(HOUR,@fromdate)
    					and cbsm_bin_id=@binId
    							and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null 
								and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
    					group by datepart(HOUR,bspa_DateTime),cbsm_bin_id,cbsm_bin_name
END;
IF( @binId =-1 AND @geom<>'All'  AND @day='All') /**geom**/
BEGIN
select cbsm_bin_id as Id,cbsm_bin_name as bin_name,datepart(HOUR,bspa_DateTime) as hourdata,avg(CONVERT(INT, 
    					bspa_Predicted_Volume)) as avgVolume from [analytics].[bin_sensor_predictive_alert_new] 
    					left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID   
    					where 
						--bspa_Predicted_Pick_Up_Alert=1 and 
						CONVERT(VARCHAR(10),bspa_DateTime,120)=convert(date,@fromdate) 
						 --and datepart(HOUR,bspa_DateTime)  = datepart(HOUR,@fromdate)
    					and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude   , 4326))=1) 
	                    		and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null 
								and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
    					group by datepart(HOUR,bspa_DateTime),cbsm_bin_id,cbsm_bin_name
END;
IF( @binId =-1 AND @geom<>'All'  AND @day<>'All') /**geom && day**/
BEGIN
select cbsm_bin_id as Id,cbsm_bin_name as bin_name,datepart(HOUR,bspa_DateTime) as hourdata,avg(CONVERT(INT, 
    					bspa_Predicted_Volume)) as avgVolume from [analytics].[bin_sensor_predictive_alert_new] 
    					left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID   
    					where 
						--bspa_Predicted_Pick_Up_Alert=1 and 
						CONVERT(VARCHAR(10),bspa_DateTime,120)=convert(date,@day)  
						-- and datepart(HOUR,bspa_DateTime)  = datepart(HOUR,@fromdate)
    					and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude  , 4326))=1) 
	                    		and cbsm_bin_longitude is not null and cbsm_bin_latitude is not null 
								and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
    					group by datepart(HOUR,bspa_DateTime),cbsm_bin_id,cbsm_bin_name
END;
IF( @binId =-1 AND @geom='All'  AND @day<>'All') /**day**/
BEGIN
select datepart(HOUR,bspa_DateTime) as hourdata,CONVERT(VARCHAR(10),bspa_DateTime,120) as date, 
    					avg(CONVERT(INT,bspa_Predicted_Volume)) as avgVolume from [analytics].[bin_sensor_predictive_alert_new] 
						left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID   
    					where 
						--bspa_Predicted_Pick_Up_Alert=1 and 
						CONVERT(VARCHAR(10),bspa_DateTime,120)=convert(date,@day)  
						 --and datepart(HOUR,bspa_DateTime)  = datepart(HOUR,@fromdate)
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ',')) 
    					group by CONVERT(VARCHAR(10),bspa_DateTime,120),datepart(HOUR,bspa_DateTime) 
    					order by datepart(HOUR,bspa_DateTime)
END;
END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_realtimeTripCount]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_realtimeTripCount] 
      
	  	@ulbid int,  
	@chartTime int,
	@binId int,  
	@wardId varchar(max),
	@fromdate datetime,
	@todate datetime,
	@geom varchar(max)     
AS
BEGIN
SET NOCOUNT ON;
if(@geom != null OR  @geom <> '' OR @geom <> null OR  @geom <> '' ) /**WITH GEOM**/
BEGIN
IF(@chartTime<0 AND @binId =-1 )/**WITH out CHART TIME && binid all**/
BEGIN

	select count(tripcount) as tripCount,wardName,wardID,veh_No,veh_Id from ( select (select tom_id_pk ) as tripcount,cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    	    			from [reporting].[trip_ongoing_master] trip
						 right join [reporting].[trip_ongoing_details] td on td.tod_master_id_fk=trip.tom_id_pk 
						 right join admin.config_bin_sensor_master cbm on cbm.cbsm_bin_loc_id=td.tod_bin_id_fk
    	    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    	    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    	    			where convert(date,tom_trip_schedule_date_time) between convert(date,@fromdate)  and convert(date,@todate) 
						and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
						and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    	    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no,tom_id_pk
    	    			)as t1 
    	    			where ulb=@ulbid  group by wardName,wardID,veh_No,veh_Id
END;

IF(@chartTime>0 AND @binId =-1 ) /**WITH chart & NOT binId**/
BEGIN
select count(tripcount) as tripCount,wardName,wardID,veh_No,veh_Id from ( select (select tom_id_pk ) as tripcount,cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    	    			from [reporting].[trip_ongoing_master] trip
						 right join [reporting].[trip_ongoing_details] td on td.tod_master_id_fk=trip.tom_id_pk 
						 right join admin.config_bin_sensor_master cbm on cbm.cbsm_bin_loc_id=td.tod_bin_id_fk
    	    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    	    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    	    			where convert(date,tom_trip_schedule_date_time) between convert(date,@fromdate)  and convert(date,@todate) 
						and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
						and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
						and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    	    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no,tom_id_pk
    	    			)as t1 
    	    			where ulb=@ulbid  group by wardName,wardID,veh_No,veh_Id

END;
IF(@chartTime<0 AND @binId <>-1 )/**WITH no chart &  binId**/
BEGIN

	select count(tripcount) as tripCount,wardName,wardID,veh_No,veh_Id from ( select (select tom_id_pk ) as tripcount,cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    	    			from [reporting].[trip_ongoing_master] trip
						 right join [reporting].[trip_ongoing_details] td on td.tod_master_id_fk=trip.tom_id_pk 
						 right join admin.config_bin_sensor_master cbm on cbm.cbsm_bin_loc_id=td.tod_bin_id_fk
    	    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    	    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    	    			where convert(date,tom_trip_schedule_date_time) between convert(date,@fromdate)  and convert(date,@todate) 
						and cbsm_bin_id=@binId  
						and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
						and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    	    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no,tom_id_pk
    	    			)as t1 
    	    			where ulb=@ulbid  group by wardName,wardID,veh_No,veh_Id
END;
IF(@chartTime>0 AND @binId <>-1 )/**WITH  chart &  binId**/
BEGIN

select count(tripcount) as tripCount,wardName,wardID,veh_No,veh_Id from ( select (select tom_id_pk ) as tripcount,cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    	    			from [reporting].[trip_ongoing_master] trip
						 right join [reporting].[trip_ongoing_details] td on td.tod_master_id_fk=trip.tom_id_pk 
						 right join admin.config_bin_sensor_master cbm on cbm.cbsm_bin_loc_id=td.tod_bin_id_fk
    	    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    	    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    	    			where convert(date,tom_trip_schedule_date_time) between convert(date,@fromdate)  and convert(date,@todate) 
						and cbsm_bin_id=@binId  
						and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
						and (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
						and  cbsm_bin_longitude is not null and cbsm_bin_latitude is not null
    	    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no,tom_id_pk
    	    			)as t1 
    	    			where ulb=@ulbid  group by wardName,wardID,veh_No,veh_Id
END;

END;

ELSE
BEGIN
IF(@chartTime<0 AND @binId =-1 )/**WITH out CHART TIME && binid all**/
BEGIN

select sum(tripcount) as tripCount,wardName,wardID,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    	    			from [reporting].[trip_ongoing_master] 
    	    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    	    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    	    			where convert(date,tom_trip_schedule_date_time) between convert(date,@fromdate)  and convert(date,@todate) 
    	    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    	    			)as t1 
    	    			where ulb=@ulbid and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,veh_No,veh_Id
END;

IF(@chartTime>0 AND @binId =-1 ) /**WITH chart & NOT binId**/
BEGIN

select sum(tripcount) as tripCount,wardName,wardID,veh_No,veh_Id from ( select count([tom_id_pk]) as tripcount,cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    	    			from [reporting].[trip_ongoing_master] 
    	    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    	    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    	    			where convert(date,tom_trip_schedule_date_time) between convert(date,@fromdate)  and convert(date,@todate) 
						and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
    	    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no 
    	    			)as t1 
    	    			where ulb=@ulbid and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,veh_No,veh_Id
END;
IF(@chartTime<0 AND @binId <>-1 )/**WITH no chart &  binId**/
BEGIN

	select count(tripcount) as tripCount,wardName,wardID,veh_No,veh_Id from ( select (select tom_id_pk ) as tripcount,cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    	    			from [reporting].[trip_ongoing_master] trip
						 right join [reporting].[trip_ongoing_details] td on td.tod_master_id_fk=trip.tom_id_pk 
						 right join admin.config_bin_sensor_master cbm on cbm.cbsm_bin_loc_id=td.tod_bin_id_fk
    	    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    	    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    	    			where convert(date,tom_trip_schedule_date_time) between convert(date,@fromdate)  and convert(date,@todate) 
						and cbsm_bin_id=@binId  
						
    	    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no,tom_id_pk
    	    			)as t1 
    	    			where ulb=@ulbid and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,veh_No,veh_Id

END;
IF(@chartTime>0 AND @binId <>-1 )/**WITH  chart &  binId**/
BEGIN

	select count(tripcount) as tripCount,wardName,wardID,veh_No,veh_Id from ( select (select tom_id_pk ) as tripcount,cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,cfm_id_pk as veh_Id,cfm_vehicle_no as veh_No 
    	    			from [reporting].[trip_ongoing_master] trip
						 right join [reporting].[trip_ongoing_details] td on td.tod_master_id_fk=trip.tom_id_pk 
						 right join admin.config_bin_sensor_master cbm on cbm.cbsm_bin_loc_id=td.tod_bin_id_fk
    	    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    	    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    	    			where convert(date,tom_trip_schedule_date_time) between convert(date,@fromdate)  and convert(date,@todate) 
						and cbsm_bin_id=@binId  
						and  datepart(HOUR,tom_trip_schedule_date_time) = @chartTime
						
    	    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk ,cfm_id_pk,cfm_vehicle_no,tom_id_pk
    	    			)as t1 
    	    			where ulb=@ulbid and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,veh_No,veh_Id
END;
END;


END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_shiftWiseBinFillVolumeforChart]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_shiftWiseBinFillVolumeforChart] 
      
	@ulb int,
	@stattime date,
	@endtime date,
	@wardId varchar(max)
	
	     
AS
BEGIN
SET NOCOUNT ON;

select shiftname,sum(totweight) as totweight,wardName,wardID  from ( select csm_shift_name as shiftname,avg(tom_weight_disposed) as totweight,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb 
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk
				left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
    			where CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120) between @stattime and @endtime
    			group by csm_shift_name,cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,datepart(HOUR,tom_trip_schedule_date_time) 
    			union select csm_shift_name as shiftname,avg(tcm_weight_disposed) as totweight,cwm_ward_name as wardName,cwm_id_pk as wardID,
				cwm_ulb_id_fk as ulb
    			from [reporting].[trip_completed_master] 
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
				left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
    			where CONVERT(VARCHAR(10),tcm_trip_date_time,120) between  @stattime and @endtime
    			group by csm_shift_name,cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk)as t1 
    			where ulb=@ulb and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,shiftname



END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_TripCountForChartByWard]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_TripCountForChartByWard] 
      
	@ulb int, 
	@stattime date,
	@endtime date,
	@wardId varchar(50)
	     
AS
BEGIN
SET NOCOUNT ON;
select sum(tripcount) as tripCount,wardName,wardID,hourdata  from ( select count([tom_id_pk]) as tripcount,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,datepart(HOUR,tom_trip_schedule_date_time) as hourdata 
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120) between @stattime and @endtime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,datepart(HOUR,tom_trip_schedule_date_time) 
    			union select count(tcm_id_pk) as tripcount,cwm_ward_name as wardName,cwm_id_pk as wardID,
				cwm_ulb_id_fk as ulb,datepart(HOUR,tcm_trip_date_time) as hourdata
    			from [reporting].[trip_completed_master] 
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
    			where CONVERT(VARCHAR(10),tcm_trip_date_time,120) between  @stattime and @endtime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,datepart(HOUR,tcm_trip_date_time))as t1 
    			where ulb=@ulb and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,hourdata
END;

GO
/****** Object:  StoredProcedure [dbo].[Analytics_Vehicle_details]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE  [dbo].[Analytics_Vehicle_details] 


AS

BEGIN
SET NOCOUNT ON;

Declare @tripid int,@count int ,@I  int,@locationid int,@locationcount int,@L int

DECLARE @temp_trip_completed_master table(rowid INT ,masterid int ,tcm_trip_id_fk int ,tcm_vehicle_id_fk int ,cfm_vehicle_no varchar(50),cfc_type varchar(100),startlocation varchar(100),startlocationlat float ,startlocationlon float,endlocation varchar(100),endlocationlat float ,endlocationlon float)
DECLARE @temp_trip_completed_master_bin_details table([cbm_bin_loc_id] int,[cbm_bin_name] varchar(50),[cbm_id_pk] int,tcd_master_id_fk int,[cbm_person_name] varchar(50),[cbm_house_no] varchar(50));

DECLARE @temp_trip_completed_details table(rowid1 INT ,masterid1 int ,tcm_trip_id_fk1 int ,tcm_vehicle_id_fk1 int ,cfm_vehicle_no1 varchar(50),cfc_type1 varchar(100),startlocation1 varchar(100),startlocationlat1 float ,startlocationlon1 float,endlocation1 varchar(100),endlocationlat1 float ,endlocationlon1 float,bindetails varchar(max));


DECLARE @temp_trip_location_details table(rowid3 INT ,locationid int);



insert into @temp_trip_completed_master 
select   row_number() over( order by tcm_id_pk) as rowid ,tcm_id_pk,tcm_trip_id_fk , tcm_vehicle_id_fk,cfm_vehicle_no,cfc_type,startlocation.gcf_poi_name as startlocation ,
  startlocation.gcf_the_geom.STX ,startlocation.gcf_the_geom.STY ,
  endlocation.gcf_poi_name as endlocation ,endlocation.gcf_the_geom.STX as endlat,endlocation.gcf_the_geom.STY as endlon
 from [reporting].[trip_completed_master] 
  left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
  left join [admin].[config_fleet_category]  on cfm_vehicle_type_id_fk=cfc_id_pk 
   left join [garbage].[gis_client_fence] startlocation   on tcm_start_location=startlocation.gcf_poi_name
    left join [garbage].[gis_client_fence] endlocation  on tcm_end_location=endlocation.gcf_poi_name






	SET @count = (SELECT COUNT(tcm_id_pk) from [reporting].[trip_completed_master]);  

		SET @I = 1
		SET @L=1
			WHILE (@I <= @count)
			BEGIN
			SELECT @tripid= masterid from @temp_trip_completed_master  WHERE rowid=@I

			select @locationcount=count([tcd_bin_id_fk]) from [reporting].[trip_completed_master]  left join [reporting].[trip_completed_details] on tcd_master_id_fk=tcm_id_pk  where tcd_master_id_fk=@tripid 
	insert into @temp_trip_location_details
	 SELECT row_number() over( order by [tcd_bin_id_fk]) ,[tcd_bin_id_fk] from  [reporting].[trip_completed_details]  where tcd_master_id_fk=@tripid 

			WHILE (@L <= @locationcount)
			BEGIN
			SELECT @locationid=locationid from @temp_trip_location_details where  rowid3=@L

		          insert into @temp_trip_completed_details
			select rowid ,masterid  ,tcm_trip_id_fk  ,tcm_vehicle_id_fk  ,cfm_vehicle_no ,cfc_type ,startlocation,startlocationlat ,startlocationlon,endlocation,endlocationlat  ,endlocationlon,(select * from [dbo].[fnGetBins_for_trip](@locationid,1)) as bindetails from @temp_trip_completed_master WHERE rowid=@I
               

			END;
			SET @L=@L+1;
			END;
			

			

 
 SET @I=@I+1;

 select * from @temp_trip_completed_details


END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_VolTripDataForChartByWard]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_VolTripDataForChartByWard] 
      
	 
	@stattime date,
	@endtime date,
	@wardId varchar(50)
	     
AS
BEGIN
SET NOCOUNT ON;
select cwm_id_pk,cwm_ward_name,avg(bsl_garbage_volume) as avgVolume,
datepart(HOUR,bsl_utc_date_time) as hourdata 
         				from dbo.bin_sensor_log 
         				left join admin.config_bin_sensor_master on cbsm_sensor_sim_no=bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
						left join admin.config_bin_master on cbsm_bin_id = cbm_id_pk
						left join admin.config_ward_master on cwm_id_pk=cbm_ward_id
         				where CONVERT(VARCHAR(10),bsl_utc_date_time,120) between @stattime and @endtime 
						and cbm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ','))
         				group by datepart(HOUR,bsl_utc_date_time),cwm_id_pk,cwm_ward_name 
         				order by datepart(HOUR,bsl_utc_date_time)
END;

GO
/****** Object:  StoredProcedure [dbo].[analytics_WardAlertCount]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_WardAlertCount] 
      
	  	@ulbid int, 
	@fromdate datetime, 
	@todate datetime,   
	@chartTime int,
	@geom varchar(max),
	@wardId varchar(max)     
AS
BEGIN
SET NOCOUNT ON;
if(@geom != null OR  @geom <> '' OR @geom <> null OR  @geom <> '' ) /**WITH GEOM**/
BEGIN
IF(@chartTime>0)/**WITH GEOM & CHART TIME**/
BEGIN


select
  cbsm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_name as bin_name,cbsm_bin_id as Id,count(bsl_id_pk) as alertcount,
                            cbsm_bin_longitude as lon,cbsm_bin_latitude as lat 
  --count(bsl.bsl_id_pk) as alertne,
  -- case when sum(bsl_volume_fill_percentage)>90 then count(bsl.bsl_id_pk) else 0 end as alert
   from admin.config_bin_sensor_master cbsm 
   LEFT JOIN bin_sensor_log bsl on cbsm.cbsm_sensor_sim_no = bsl.bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
   left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id 
   where  cbsm_ulb_id_fk=@ulbid
   and bsl_utc_date_time between @fromdate  and @todate and cbsm_ulb_id_fk=@ulbid and bsl_volume_fill_percentage>90 
   	and cwm_id_pk in (select * from [dbo].[fnSplitString] (@wardId, ','))
	and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude   , 4326))=1) 
	and datepart(HOUR,bsl_utc_date_time) = @chartTime
   GROUP BY cbsm.cbsm_bin_id,
   cbsm.cbsm_bin_latitude,
   cbsm.cbsm_bin_longitude,
   cbsm.cbsm_bin_name
   ,cbsm_ward_id
   ,cwm_ward_name
union
    select cbsm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_name as bin_name,cbsm_bin_id as Id,0 as alertcount,
                            cbsm_bin_longitude as lon,cbsm_bin_latitude as lat 
   
   from admin.config_bin_sensor_master cbsm 
   left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id 
    where  cbsm_ulb_id_fk=@ulbid
	and cbsm.cbsm_bin_id not in (select bsl_bin_id from   bin_sensor_log bsl where bsl_utc_date_time between @fromdate  and @todate
	and  bsl_volume_fill_percentage>90 and datepart(HOUR,bsl_utc_date_time) = @chartTime)
		and cwm_id_pk in (select * from [dbo].[fnSplitString] (@wardId, ','))
		and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude   , 4326))=1) 
	 GROUP BY cbsm.cbsm_bin_id,
   cbsm.cbsm_bin_latitude,
   cbsm.cbsm_bin_longitude,
   cbsm.cbsm_bin_name
   ,cbsm_ward_id
   ,cwm_ward_name


END;
ELSE /**WITH GEOM & NOT CHART TIME**/
BEGIN


select
  cbsm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_name as bin_name,cbsm_bin_id as Id,count(bsl_id_pk) as alertcount,
                            cbsm_bin_longitude as lon,cbsm_bin_latitude as lat 
  --count(bsl.bsl_id_pk) as alertne,
  -- case when sum(bsl_volume_fill_percentage)>90 then count(bsl.bsl_id_pk) else 0 end as alert
   from admin.config_bin_sensor_master cbsm 
   LEFT JOIN bin_sensor_log bsl on cbsm.cbsm_sensor_sim_no = bsl.bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
   left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id 
   where  cbsm_ulb_id_fk=@ulbid
   and bsl_utc_date_time between @fromdate  and @todate and cbsm_ulb_id_fk=@ulbid and bsl_volume_fill_percentage>90 
   	and cwm_id_pk in (select * from [dbo].[fnSplitString] (@wardId, ','))
	and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude   , 4326))=1) 
   GROUP BY cbsm.cbsm_bin_id,
   cbsm.cbsm_bin_latitude,
   cbsm.cbsm_bin_longitude,
   cbsm.cbsm_bin_name
   ,cbsm_ward_id
   ,cwm_ward_name
union
    select cbsm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_name as bin_name,cbsm_bin_id as Id,0 as alertcount,
                            cbsm_bin_longitude as lon,cbsm_bin_latitude as lat 
   
   from admin.config_bin_sensor_master cbsm 
   left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id 
    where  cbsm_ulb_id_fk=@ulbid
	and cbsm.cbsm_bin_id not in (select bsl_bin_id from   bin_sensor_log bsl where bsl_utc_date_time between @fromdate  and @todate
	and  bsl_volume_fill_percentage>90 )
		and cwm_id_pk in (select * from [dbo].[fnSplitString] (@wardId, ','))
		and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude   , 4326))=1) 
	 GROUP BY cbsm.cbsm_bin_id,
   cbsm.cbsm_bin_latitude,
   cbsm.cbsm_bin_longitude,
   cbsm.cbsm_bin_name
   ,cbsm_ward_id
   ,cwm_ward_name



				
END;
	
END;
ELSE
BEGIN
IF(@chartTime>0)/**WITHOUT GEOM & CHART TIME**/
BEGIN


select
  cbsm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_name as bin_name,cbsm_bin_id as Id,count(bsl_id_pk) as alertcount,
                            cbsm_bin_longitude as lon,cbsm_bin_latitude as lat 
  --count(bsl.bsl_id_pk) as alertne,
  -- case when sum(bsl_volume_fill_percentage)>90 then count(bsl.bsl_id_pk) else 0 end as alert
   from admin.config_bin_sensor_master cbsm 
   LEFT JOIN bin_sensor_log bsl on cbsm.cbsm_sensor_sim_no = bsl.bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
   left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id 
   where  cbsm_ulb_id_fk=@ulbid
   and bsl_utc_date_time between @fromdate  and @todate and cbsm_ulb_id_fk=@ulbid and bsl_volume_fill_percentage>90 
   	and cwm_id_pk in (select * from [dbo].[fnSplitString] (@wardId, ','))
	and datepart(HOUR,bsl_utc_date_time) = @chartTime
   GROUP BY cbsm.cbsm_bin_id,
   cbsm.cbsm_bin_latitude,
   cbsm.cbsm_bin_longitude,
   cbsm.cbsm_bin_name
   ,cbsm_ward_id
   ,cwm_ward_name
union
    select cbsm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_name as bin_name,cbsm_bin_id as Id,0 as alertcount,
                            cbsm_bin_longitude as lon,cbsm_bin_latitude as lat 
   
   from admin.config_bin_sensor_master cbsm 
   left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id 
    where  cbsm_ulb_id_fk=@ulbid
	and cbsm.cbsm_bin_id not in (select bsl_bin_id from   bin_sensor_log bsl where bsl_utc_date_time between @fromdate  and @todate
	and  bsl_volume_fill_percentage>90 
    and datepart(HOUR,bsl_utc_date_time) = @chartTime	)
		and cwm_id_pk in (select * from [dbo].[fnSplitString] (@wardId, ','))
	 GROUP BY cbsm.cbsm_bin_id,
   cbsm.cbsm_bin_latitude,
   cbsm.cbsm_bin_longitude,
   cbsm.cbsm_bin_name
   ,cbsm_ward_id
   ,cwm_ward_name



END;
ELSE /**WITHOUT GEOM & NOT CHART TIME**/
BEGIN

select
  cbm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_name as bin_name,cbsm_bin_id as Id,count(bsl_id_pk) as alertcount,
                            cbsm_bin_longitude as lon,cbsm_bin_latitude as lat 
  --count(bsl.bsl_id_pk) as alertne,
  -- case when sum(bsl_volume_fill_percentage)>90 then count(bsl.bsl_id_pk) else 0 end as alert
   from admin.config_bin_sensor_master cbsm 
   LEFT JOIN bin_sensor_log bsl on cbsm.cbsm_sensor_sim_no = bsl.bsl_simcard_no COLLATE SQL_Latin1_General_CP1_CI_AS 
   left join admin.config_bin_master on cbsm_bin_id = [cbm_id_pk]
   left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id 
   where  cbsm_ulb_id_fk=@ulbid
   and bsl_utc_date_time between @fromdate  and @todate and cbsm_ulb_id_fk=@ulbid and bsl_volume_fill_percentage>90 
   	and cwm_id_pk in (select * from [dbo].[fnSplitString] (@wardId, ','))
   GROUP BY cbm_ward_id, cbsm.cbsm_bin_id,
   cbsm.cbsm_bin_latitude,
   cbsm.cbsm_bin_longitude,
   cbsm.cbsm_bin_name
   ,cbsm_ward_id
   ,cwm_ward_name
union
    select cbm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_name as bin_name,cbsm_bin_id as Id,0 as alertcount,
                            cbsm_bin_longitude as lon,cbsm_bin_latitude as lat 
   
   from admin.config_bin_sensor_master cbsm 
    left join admin.config_bin_master on cbsm_bin_id = [cbm_id_pk]
   left join admin.config_ward_master on cwm_id_pk=cbsm_ward_id 
    where  cbsm_ulb_id_fk=@ulbid
	and cbsm.cbsm_bin_id not in (select bsl_bin_id from   bin_sensor_log bsl where bsl_utc_date_time between @fromdate  and @todate
	and  bsl_volume_fill_percentage>90 )
		and cwm_id_pk in (select * from [dbo].[fnSplitString] (@wardId, ','))
	 GROUP BY cbm_ward_id, cbsm.cbsm_bin_id,
   cbsm.cbsm_bin_latitude,
   cbsm.cbsm_bin_longitude,
   cbsm.cbsm_bin_name
   ,cbsm_ward_id
   ,cwm_ward_name

									
END;
END;
END

GO
/****** Object:  StoredProcedure [dbo].[analytics_WardAlertCount_Predict]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_WardAlertCount_Predict] 
      
	@ulbid int, 
	@fromdate datetime, 
	@todate datetime,   
	@chartTime int,
	@geom varchar(max)     
AS
BEGIN
SET NOCOUNT ON;
if(@geom != null OR  @geom <> '' OR @geom <> null OR  @geom <> '' ) /**WITH GEOM**/
BEGIN
IF(@chartTime>0)/**WITH GEOM & CHART TIME**/
BEGIN
select cbsm_bin_name as bin_name,cbsm_bin_id as Id,cbsm_ward_id as wardID,cwm_ward_name as wardName,
        				count(bspa_DateTime) as alertcount,cbsm_bin_longitude as lon,cbsm_bin_latitude as lat  
						from [analytics].[bin_sensor_predictive_alert_new] 
        				left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID  
        				left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
        				left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
        				where bspa_DateTime between @fromdate and  DATEADD (hour , 1 , @fromdate ) 
        			   and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude  , 4326))=1) 
					   and bspa_Predicted_Volume > 90
        				and cbsm_ulb_id_fk=@ulbid 
						and bspa_Hour=@chartTime
					   group by cbsm_bin_name,cbsm_bin_id,cbsm_ward_id,cwm_ward_name,cbsm_bin_longitude,cbsm_bin_latitude
					   
					   				   union 

					   select  cbsm_bin_name as bin_name,cbsm_bin_id as Id,cbsm_ward_id as wardID,cwm_ward_name as wardName,
        				0 as alertcount,cbsm_bin_longitude as lon,cbsm_bin_latitude as lat  
					   from [admin].[config_bin_sensor_master] 
					   --left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID  
					   left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
					   where cbsm_bin_id not in (select bspa_Bin_ID from [analytics].[bin_sensor_predictive_alert_new]  where  bspa_DateTime between @fromdate and  
					   DATEADD (hour , 1 , @fromdate )  and bspa_Predicted_Volume > 90 and bspa_Hour=@chartTime)
					   and cbsm_ulb_id_fk=@ulbid 
					    and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude  , 4326))=1) 
					    group by cbsm_bin_name,cbsm_bin_id,cbsm_ward_id,cwm_ward_name,cbsm_bin_longitude,cbsm_bin_latitude	
					   
					   
					   
					   	
END;
ELSE /**WITH GEOM & NOT CHART TIME**/
BEGIN
select cbsm_bin_name as bin_name,cbsm_bin_id as Id,cbsm_ward_id as wardID,cwm_ward_name as wardName,
        				count(bspa_DateTime) as alertcount,cbsm_bin_longitude as lon,cbsm_bin_latitude as lat  
						from [analytics].[bin_sensor_predictive_alert_new] 
        				left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID
        				left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
        				left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
        				where bspa_DateTime between @fromdate and  DATEADD (hour , 1 , @fromdate ) 
						and bspa_Predicted_Volume > 90
        			   and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude  , 4326))=1) 
        				and cbsm_ulb_id_fk=@ulbid 
						
					   group by cbsm_bin_name,cbsm_bin_id,cbsm_ward_id,cwm_ward_name,cbsm_bin_longitude,cbsm_bin_latitude
					   
					     union 

					   select  cbsm_bin_name as bin_name,cbsm_bin_id as Id,cbsm_ward_id as wardID,cwm_ward_name as wardName,
        				0 as alertcount,cbsm_bin_longitude as lon,cbsm_bin_latitude as lat  
					   from [admin].[config_bin_sensor_master] 
					   --left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID  
					   left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
					   where cbsm_bin_id not in (select bspa_Bin_ID from [analytics].[bin_sensor_predictive_alert_new]  where  bspa_DateTime between @fromdate and  
					   DATEADD (hour , 1 , @fromdate )  and bspa_Predicted_Volume > 90 )
					   and cbsm_ulb_id_fk=@ulbid 
					    and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude  , 4326))=1) 
					    group by cbsm_bin_name,cbsm_bin_id,cbsm_ward_id,cwm_ward_name,cbsm_bin_longitude,cbsm_bin_latitude	
					   	
				
END;
	
END;
ELSE
BEGIN
IF(@chartTime>0)/**WITHOUT GEOM & CHART TIME**/
BEGIN
select cbsm_bin_name as bin_name,cbsm_bin_id as Id,cbsm_ward_id as wardID,cwm_ward_name as wardName,
        				count(bspa_DateTime) as alertcount,cbsm_bin_longitude as lon,cbsm_bin_latitude as lat  
						from [analytics].[bin_sensor_predictive_alert_new] 
        				left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID
        				left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
        				left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
        				where bspa_DateTime between @fromdate and  DATEADD (hour , 1 , @fromdate ) 
						and bspa_Predicted_Volume > 90
        			    and bspa_Hour=@chartTime
        				and cbsm_ulb_id_fk=@ulbid 
						
					   group by cbsm_bin_name,cbsm_bin_id,cbsm_ward_id,cwm_ward_name,cbsm_bin_longitude,cbsm_bin_latitude	


					     union 

					   select  cbsm_bin_name as bin_name,cbsm_bin_id as Id,cbsm_ward_id as wardID,cwm_ward_name as wardName,
        				0 as alertcount,cbsm_bin_longitude as lon,cbsm_bin_latitude as lat  
					   from [admin].[config_bin_sensor_master] 
					   --left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID  
					   left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
					   where cbsm_bin_id not in (select bspa_Bin_ID from [analytics].[bin_sensor_predictive_alert_new]  where  bspa_DateTime between @fromdate and  
					   DATEADD (hour , 1 , @fromdate )  and bspa_Predicted_Volume > 90 and bspa_Hour=@chartTime)
					   and cbsm_ulb_id_fk=@ulbid 
					    group by cbsm_bin_name,cbsm_bin_id,cbsm_ward_id,cwm_ward_name,cbsm_bin_longitude,cbsm_bin_latitude	


END;
ELSE /**WITHOUT GEOM & NOT CHART TIME**/
BEGIN
select cbsm_bin_name as bin_name,cbsm_bin_id as Id,cbm_ward_id as wardID,cwm_ward_name as wardName,
        				count(bspa_DateTime) as alertcount,cbsm_bin_longitude as lon,cbsm_bin_latitude as lat  
						from [analytics].[bin_sensor_predictive_alert_new] 
        				left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID 
        				left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
        				left join admin.config_bin_master on cbsm_bin_id = [cbm_id_pk]
						left join admin.config_ward_master on cbm_ward_id=[cwm_id_pk] 
        				where bspa_DateTime between @fromdate and  DATEADD (hour , 1 , @fromdate ) 
						and bspa_Predicted_Volume > 90
        			    
        				and cbsm_ulb_id_fk=@ulbid 
						
					   group by cbm_ward_id, cbsm_bin_name,cbsm_bin_id,cbsm_ward_id,cwm_ward_name,cbsm_bin_longitude,cbsm_bin_latitude
					   
					   union 

					   select  cbsm_bin_name as bin_name,cbsm_bin_id as Id,cbm_ward_id as wardID,cwm_ward_name as wardName,
        				0 as alertcount,cbsm_bin_longitude as lon,cbsm_bin_latitude as lat  
					   from [admin].[config_bin_sensor_master] 
					   --left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID  
					   left join admin.config_bin_master on cbsm_bin_id = [cbm_id_pk]
					   left join admin.config_ward_master on cbm_ward_id=[cwm_id_pk] 
					   where cbsm_bin_id not in (select bspa_Bin_ID from [analytics].[bin_sensor_predictive_alert_new]  where  bspa_DateTime between @fromdate and  
					   DATEADD (hour , 1 , @fromdate )  and bspa_Predicted_Volume > 90 )
					   and cbsm_ulb_id_fk=@ulbid 
					    group by cbm_ward_id, cbsm_bin_name,cbsm_bin_id,cbsm_ward_id,cwm_ward_name,cbsm_bin_longitude,cbsm_bin_latitude	
								
END;
END;
END

GO
/****** Object:  StoredProcedure [dbo].[analytics_weekDaysWiseBinFillVolumeforChart]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[analytics_weekDaysWiseBinFillVolumeforChart] 
      
	@ulb int,
	@stattime date,
	@endtime date,
	@wardId varchar(max)
	
	     
AS
BEGIN
SET NOCOUNT ON;

select weekdaytype,sum(totweight) as totweight,wardName,wardID  from ( select avg(tom_weight_disposed) as totweight,
cwm_ward_name as wardName,cwm_id_pk  as wardID,cwm_ulb_id_fk as ulb,
case when DATEName(DW, tom_trip_schedule_date_time) = 'Saturday' or DATEName(DW, tom_trip_schedule_date_time) = 'Sunday'  then 'Weekend' else 'Weekday' end as weekdaytype
    			from [reporting].[trip_ongoing_master] 
    			left join [admin].[config_fleet_master]  on tom_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk
				left join admin.config_shift_master on csm_id_pk=tom_shift_id_fk
    			where CONVERT(VARCHAR(10),tom_trip_schedule_date_time,120) between @stattime and @endtime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,tom_trip_schedule_date_time 
    			union select avg(tcm_weight_disposed) as totweight,cwm_ward_name as wardName,cwm_id_pk as wardID,
				cwm_ulb_id_fk as ulb,
				case when DATEName(DW, tcm_trip_date_time) = 'Saturday' or DATEName(DW, tcm_trip_date_time) = 'Sunday'  then 'Weekend' else 'Weekday' end as weekdaytype
    			from [reporting].[trip_completed_master] 
    			left join [admin].[config_fleet_master]  on tcm_vehicle_id_fk=cfm_id_pk 
    			left join admin.config_ward_master on cfm_ward_id=cwm_id_pk 
				left join admin.config_shift_master on csm_id_pk=tcm_shift_id_fk
    			where CONVERT(VARCHAR(10),tcm_trip_date_time,120) between  @stattime and @endtime
    			group by cwm_ward_name,cwm_id_pk,cwm_ulb_id_fk,tcm_trip_date_time)as t1 
    			where ulb=@ulb and wardID in (select * from [dbo].[fnSplitString] (@wardId, ',')) group by wardName,wardID,weekdaytype



END;
DECLARE @dayName VARCHAR(9);
SET @dayName = DATEName(DW, GETDATE());

IF(@dayName = 'Saturday' OR @dayName = 'Sunday') 
    PRINT 'Weekend';
ELSE
    PRINT 'NOT Weekend'

GO
/****** Object:  StoredProcedure [dbo].[BinCollectionByCEP]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[BinCollectionByCEP]

@tripid int,
@binlocid int,
@alertTime datetime  
AS
BEGIN
SET NOCOUNT ON;
Declare @status Bit;
Declare @vehicleID int;
DECLARE @tomidpk int;
DECLARE @count int,@I int,@count_1 int;
DECLARE @workForceCount int;
DECLARE @todidpk int;
DECLARE @insertIntoReeb table(rowid INT,rfidNo varchar(50),binLocId int,binidPk int,BinIdName varchar(50),todIdPk int,todMasterId int);
DECLARE @strRfid varchar(75),@StrbinId int,@strBinLocID int,@strBinName varchar(75),@strTodIdPk int,@strTodMasterId int,@collectionCount int;


BEGIN TRAN
BEGIN TRY
		select @tomidpk=tom_id_pk from [reporting].[trip_ongoing_master] where tom_trip_id_fk=@tripid;

		

		update [reporting].[trip_ongoing_details] set tod_collection_status='1',tod_bins_collected=tod_bins_to_be_collected,tod_bin_entry_time=dateadd(minute, -330,@alertTime) where  tod_bin_id_fk=@binlocid and tod_master_id_fk=@tomidpk

		SELECT @count=COUNT(*) FROM reporting.trip_ongoing_captured_data where tocd_trip_id_fk=@tripid and tocd_bin_id_fk=@binlocid

		IF @count=0
			BEGIN
			  insert into reporting.trip_ongoing_captured_data(tocd_trip_id_fk,tocd_bin_id_fk,tod_collected_datetime)  
			  values (@tripid,@binlocid,dateadd(minute, -330,@alertTime))
			END
		ELSE
			 BEGIN
				update reporting.trip_ongoing_captured_data set tod_collected_datetime=dateadd(minute, -330,@alertTime) where tocd_trip_id_fk=@tripid
			 END
		 select @todidpk=tod_id_pk from [reporting].[trip_ongoing_details] where tod_master_id_fk=@tomidpk and tod_bin_id_fk=@binlocid

		--------RFID procedure-------------

		 UPDATE [garbage].[gis_garbage_collection_points] SET [ggcf_bin_collection_status]=1,[ggcf_last_collected_date]=@alertTime WHERE [ggcf_points_id_pk]=@binlocid

		 UPDATE [admin].[config_bin_sensor_master] SET cbsm_bin_sensor_capasity=0,cbsm_bin_full_status=0,cbsm_check_count=0,cbsm_collection_status=1,[cbsm_collected_time]=@alertTime WHERE [cbsm_bin_loc_id]= @binlocid

		 INSERT INTO @insertIntoReeb select row_number() over( order by cbm_id_pk),[crm_rfid_no],cbm_bin_loc_id,[cbm_id_pk],[cbm_bin_name],tod_id_pk,tod_master_id_fk from [admin].[config_bin_master]  left join [admin].[config_rfid_master] on [crm_bin_id] = [cbm_id_pk] inner join [reporting].[trip_ongoing_details] on [tod_bin_id_fk]=[cbm_bin_loc_id] where cbm_bin_loc_id=@binlocid
			 and [tod_master_id_fk]= @tomidpk
			

			SET @count_1 = (SELECT COUNT(*) FROM @insertIntoReeb);
			SET @I = 1;
		
			WHILE (@I <= @count_1)
			
			BEGIN
		
				SELECT @strRfid=rfidNo,@strBinLocID=binLocId,@StrbinId=binidPk,@strBinName=BinIdName,@strTodIdPk=todIdPk,@strTodMasterId=todMasterId  FROM @insertIntoReeb WHERE rowid=@I
		
		select @collectionCount=count(*) from reporting.rfid_read_in_each_binLocation where rreb_trip_ongoing_details_id_fk=@strTodIdPk and rreb_bin_loc_id_fk=@binlocid

		if @collectionCount=0
		  begin
				INSERT INTO  reporting.rfid_read_in_each_binLocation (rreb_rfid_tag,rreb_bin_loc_id_fk,rreb_bin_id_fk,rreb_bin_name,rreb_trip_ongoing_details_id_fk, rreb_date_time)
					VALUES (@strRfid,@strBinLocID,@StrbinId,@strBinName,@strTodIdPk, @alertTime)
          end 
        else 
		  begin
		      update reporting.rfid_read_in_each_binLocation set [rreb_date_time]=@alertTime where rreb_trip_ongoing_details_id_fk=@strTodIdPk and rreb_bin_loc_id_fk=@binlocid
		  end
       

				SET @I = @I+1;
			End


		

		select @vehicleID=[stm_vheicle_id_fk] from  [scheduling].[schedule_trip_master]  where [stm_id_pk]=@tripid

		select @workForceCount=count(*) from [admin].[config_mobile_user_master] left join  [admin].[config_fleet_master] on [cfm_id_pk]=[cmum_vehicle_id] where [cfm_id_pk]=@vehicleID


if @workForceCount>0
begin
set @status=1
 select @status as workForceStatus ,cmum_workforce_id_fk as workforceUserId from  [scheduling].[schedule_trip_master] left join [admin].[config_mobile_user_master] on [stm_vheicle_id_fk] = cmum_vehicle_id where [stm_id_pk]=@tripid
 end

if @workForceCount=0
begin
set @status=0
select @status as workForceStatus , 0 as workforceUserId
end


COMMIT TRAN
END TRY

 BEGIN CATCH
 ROLLBACK TRAN
	
END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[binCollectionForSupervisior]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[binCollectionForSupervisior]

@ulbid int,
@binTypId int,
@zoneId int,
@wardId int,
@statusId int,
@fromDate varchar(50),
@endate varchar(50)


   
AS
BEGIN


SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

if @statusId=1


 select ISNULL(sum(case when bcdr_bin_collected_status=1 then 1 else 0 end), 0) collected_bins,
  ISNULL(sum(case when bcdr_bin_collected_status=0 then 1 else 0 end), 0) not_collected_bins,
  (select count(*) FROM [reports].[bin_collection_detailed_report]  where bcdr_ulb_id_fk=@ulbid 
   and bcdr_date between @fromDate and @endate) total,bcdr_date FROM [reports].[bin_collection_detailed_report] 
   where bcdr_ulb_id_fk=@ulbid and bcdr_date between @fromDate and @fromDate group by bcdr_date

if @statusId=2

select ISNULL(sum(case when bcdr_bin_collected_status=1 then 1 else 0 end), 0) collected_bins,
  ISNULL(sum(case when bcdr_bin_collected_status=0 then 1 else 0 end), 0) not_collected_bins,
  (select count(*) FROM [reports].[bin_collection_detailed_report]  where bcdr_ulb_id_fk=@ulbid and bcdr_zone_id=@zoneId
   and bcdr_date between @fromDate and @endate) total,bcdr_date FROM [reports].[bin_collection_detailed_report] 
   where bcdr_ulb_id_fk=@ulbid and bcdr_zone_id=@zoneId and bcdr_date between @fromDate and @endate group by bcdr_date

if @statusId=3

select ISNULL(sum(case when bcdr_bin_collected_status=1 then 1 else 0 end), 0) collected_bins,
  ISNULL(sum(case when bcdr_bin_collected_status=0 then 1 else 0 end), 0) not_collected_bins,
  (select count(*) FROM [reports].[bin_collection_detailed_report]  where bcdr_ulb_id_fk=@ulbid and bcdr_zone_id=@zoneId and bcdr_ward_id=@wardId
   and bcdr_date between @fromDate and @endate) total,bcdr_date FROM [reports].[bin_collection_detailed_report] 
   where bcdr_ulb_id_fk=@ulbid and bcdr_zone_id=@zoneId and bcdr_ward_id=@wardId and bcdr_date between @fromDate and @endate group by bcdr_date




COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	
	  END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[BinCollectionRfidNotRequired]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[BinCollectionRfidNotRequired]

@tripid int,
@binlocid int,
@alertTime datetime  
AS
BEGIN
SET NOCOUNT ON;
Declare @status Bit;

DECLARE @tomidpk int;
DECLARE @count int,@I int,@count_1 int;

DECLARE @todidpk int;
DECLARE @insertIntoReeb table(rowid INT,rfidNo varchar(50),binLocId int,binidPk int,BinIdName varchar(50),todIdPk int,todMasterId int);
DECLARE @strRfid varchar(75),@StrbinId int,@strBinLocID int,@strBinName varchar(75),@strTodIdPk int,@strTodMasterId int,@collectionCount int;


BEGIN TRAN
BEGIN TRY
		select @tomidpk=tom_id_pk from [reporting].[trip_ongoing_master] where tom_trip_id_fk=@tripid;

	print @tomidpk


		--------RFID procedure-------------

		 UPDATE [garbage].[gis_garbage_collection_points] SET [ggcf_bin_collection_status]=1,[ggcf_last_collected_date]=@alertTime WHERE [ggcf_points_id_pk]=@binlocid

		 UPDATE [admin].[config_bin_sensor_master] SET cbsm_bin_sensor_capasity=0,cbsm_bin_full_status=0,cbsm_check_count=0,cbsm_collection_status=1,[cbsm_collected_time]=@alertTime WHERE [cbsm_bin_loc_id]= @binlocid

		 INSERT INTO @insertIntoReeb select row_number() over( order by cbm_id_pk),[crm_rfid_no],cbm_bin_loc_id,[cbm_id_pk],[cbm_bin_name],tod_id_pk,tod_master_id_fk from [admin].[config_bin_master]  left join [admin].[config_rfid_master] on [crm_bin_id] = [cbm_id_pk] inner join [reporting].[trip_ongoing_details] on [tod_bin_id_fk]=[cbm_bin_loc_id] where cbm_bin_loc_id=@binlocid
			 and [tod_master_id_fk]= @tomidpk

		
			

			SET @count_1 = (SELECT COUNT(*) FROM @insertIntoReeb);
			
			SET @I = 1;
		
			WHILE (@I <= @count_1)
			
			BEGIN
		
				SELECT @strRfid=rfidNo,@strBinLocID=binLocId,@StrbinId=binidPk,@strBinName=BinIdName,@strTodIdPk=todIdPk,@strTodMasterId=todMasterId  FROM @insertIntoReeb WHERE rowid=@I
		
		select @collectionCount=count(*) from reporting.rfid_read_in_each_binLocation where rreb_trip_ongoing_details_id_fk=@strTodIdPk and rreb_bin_loc_id_fk=@binlocid and rreb_bin_id_fk=@StrbinId
	
		if @collectionCount=0
		  begin
				INSERT INTO  reporting.rfid_read_in_each_binLocation (rreb_rfid_tag,rreb_bin_loc_id_fk,rreb_bin_id_fk,rreb_bin_name,rreb_trip_ongoing_details_id_fk, rreb_date_time)
					VALUES (@strRfid,@strBinLocID,@StrbinId,@strBinName,@strTodIdPk, @alertTime)
          end 
        else 
		  begin
		      update reporting.rfid_read_in_each_binLocation set [rreb_date_time]=@alertTime where rreb_trip_ongoing_details_id_fk=@strTodIdPk and rreb_bin_loc_id_fk=@binlocid
		  end
       

				SET @I = @I+1;
			End



set @status=1
select @status as status  




COMMIT TRAN
END TRY

 BEGIN CATCH
 ROLLBACK TRAN
	
END CATCH
END


GO
/****** Object:  StoredProcedure [dbo].[checkWardGeom]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[checkWardGeom] @wkt NVARCHAR(MAX), @ulb int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @g geography;
	
    SET @g = (geography::STGeomFromText(@wkt, 4326)); 
    SELECT [cwm_id_pk] as wardID,[cwm_ward_name] as wardName,cwm_geometry.STAsText() as wardGeom ,(select count(*) from admin.config_bin_master where cbm_ward_id=[cwm_id_pk] and cbm_ulb_id_fk=@ulb) 
        			as binIdCount from [admin].[config_ward_master] cwm where 
	--cwm.cwm_id_pk = @ulb AND
	(geometry::STGeomFromWKB(@g.STAsBinary(),@g.STSrid)).STIntersects  (geometry::STGeomFromText(cwm.cwm_geometry.STAsText(), 4326))=1
END

GO
/****** Object:  StoredProcedure [dbo].[CloseTripStatus]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[CloseTripStatus]
--@TripId int


AS
BEGIN
	SET NOCOUNT ON;
	
--	declare @tomId int,@count_2 int,@K int,@count int,@I int,@tom_id int,@tod_id int;	
--	   	DECLARE @temp_trip_ongoing_master table(rowid INT ,tom_id_pk int,tom_vehicle_id_fk int,tom_trip_id_fk int,tom_route_id_fk int,tom_trip_schedule_date_time datetime,
--	tom_start_date_time datetime,tom_end_date_time datetime,tom_trip_status int,tom_driver_id_fk int,tom_cleaner_id_fk int,tom_shift_id_fk int,tom_end_location int,tom_start_location int,tom_final_location int,tom_notify_status int,tom_start_loc_type int,tom_end_loc_type int)
--		DECLARE @temp_trip_completed_details table(rowid INT ,tod_id_pk int, tod_master_id_fk int,tod_bin_id_fk int,tod_bin_name varchar(max),tod_collection_status int,tod_bin_entry_time datetime,
--	tod_bin_exit_time datetime,tod_sequence_no int,tod_bins_to_be_collected int,tod_bins_collected int,tod_weight int)

--	BEGIN TRAN
--		BEGIN TRY
--		SET @count = (SELECT COUNT(rowid) FROM @temp_trip_ongoing_master);  
--			SET @I = 1
--	print 'in here 1' 
--	--WHILE (@I <= @count)
--	BEGIN
--	SELECT @tom_id=tom_id_pk,@TripId=tom_trip_id_fk  FROM @temp_trip_ongoing_master WHERE rowid=@I

	
--	print 'in here 2'
--	update [scheduling].[schedule_trip_master] set [stm_status]=3 where [stm_id_pk]=@TripId

	
--			INSERT INTO reporting.trip_completed_master (tcm_vehicle_id_fk,tcm_trip_id_fk,tcm_route_id_fk,tcm_trip_date_time,tcm_start_date_time,
--			tcm_end_date_time,tcm_driver_id_fk,tcm_cleaner_id_fk,tcm_shift_id_fk,tcm_weight_disposed,tcm_received_weight,tcm_route_type,tcm_trip_distance,tcm_start_location,[tcm_dumping_ground],tcm_end_location)
--	select [tom_vehicle_id_fk],[tom_trip_id_fk],[tom_route_id_fk],[tom_trip_schedule_date_time],[tom_start_date_time],[tom_end_date_time],[tom_driver_id_fk],[tom_cleaner_id_fk],
--	[tom_shift_id_fk],[tom_weight_disposed],[tom_received_weight],[tom_route_type],[tom_trip_distance],agv1.name as StartLocation,agv2.name as finalLocation,agv3.name as endLocation from  [reporting].[trip_ongoing_master]
--	left join dbo.all_geofence_view agv1 on agv1.poi_type=tom_start_loc_type and tom_start_location=agv1.id left join dbo.all_geofence_view agv2 on agv2.poi_type=tom_end_loc_type and tom_final_location=agv2.id
--	left join dbo.all_geofence_view agv3 on  [tom_end_location]=agv3.id
--	 where [tom_trip_id_fk]=@TripId

--	 delete from  [reporting].[trip_ongoing_master] where  [tom_trip_id_fk]=@TripId





--	 	delete from @temp_trip_completed_details
--	INSERT @temp_trip_completed_details
--				SELECT row_number() over (order by tod_id_pk) ,tod_id_pk,@tod_id,tod_bin_id_fk,tod_bin_name,
--			tod_collection_status,tod_bin_entry_time,tod_bin_exit_time,tod_sequence_no,tod_cnt,cnt_2,weight FROM (SELECT tod_id_pk, tod_master_id_fk,tod_bin_id_fk,tod_bin_name,
--			tod_collection_status,tod_bin_entry_time,tod_bin_exit_time,tod_sequence_no,tod_bins_to_be_collected as tod_cnt,tod_bins_collected as cnt_2,0 as weight FROM reporting.trip_ongoing_details 
--			WHERE tod_master_id_fk=@tom_id)AS TEMP_TABLE

--			SET @count_2 = (SELECT COUNT(rowid) FROM @temp_trip_completed_details);  

--				-- Initialize the iterator
--				--SET @K = 1

--				--WHILE (@K <= @count_2)
--				BEGIN
			
				
				
--					print 'in here 3'
--				INSERT INTO reporting.trip_completed_details
--				SELECT tod_master_id_fk,tod_bin_id_fk,tod_bin_name,tod_collection_status,tod_bin_entry_time,
--				tod_bin_exit_time,tod_sequence_no,tod_bins_to_be_collected,tod_bins_collected FROM
--				@temp_trip_completed_details WHERE rowid = @K;


--end

--delete from [reporting].[trip_ongoing_details] where [tod_master_id_fk] =(select [tom_id_pk] from [reporting].[trip_ongoing_master] where [tom_trip_id_fk]=@TripId)
--end



		


		

--	COMMIT TRAN
--	END TRY
--	BEGIN CATCH
--	ROLLBACK TRAN
        
--	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[doorToDoorForSupevisior]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[doorToDoorForSupevisior]

@ulbid int,
@zoneId int,
@wardId int,
@statusId int,
@fromDate varchar(50),
@endDate varchar(50)


   
AS
BEGIN


SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

if @statusId=1

select sum(CASE WHEN dbcdr_bin_collected_status = 1 THEN 1 else 0 end )as collected,sum(CASE WHEN dbcdr_bin_collected_status = 0 THEN 1 else 0 end )as
 notCollected,(select count([cbm_id_pk]) FROM [admin].[config_bin_master]  where [cbm_ulb_id_fk]=@ulbid and [cbm_binRroad_status]=1) 
 as total,dbcdr_date from [dbo].[dtd_bin_collection_status_view] where dbcdr_ulb_id_fk=@ulbid and dbcdr_date between @fromDate and @endDate group by dbcdr_date





if @statusId=2

select sum(CASE WHEN dbcdr_bin_collected_status = 1 THEN 1 else 0 end )as collected,sum(CASE WHEN dbcdr_bin_collected_status = 0 THEN 1 else 0 end )as notCollected,
(select count([cbm_id_pk]) FROM [admin].[config_bin_master]  where [cbm_ulb_id_fk]=@ulbid and [cbm_zone_id]=@zoneId and [cbm_binRroad_status]=1) 
 as total,dbcdr_date from [dbo].[dtd_bin_collection_status_view] where dbcdr_ulb_id_fk=@ulbid and czm_id_pk=@zoneId and dbcdr_date between @fromDate and @endDate group by dbcdr_date




if @statusId=3

select sum(CASE WHEN dbcdr_bin_collected_status = 1 THEN 1 else 0 end )as collected,sum(CASE WHEN dbcdr_bin_collected_status = 0 THEN 1 else 0 end )as notCollected,
(select count([cbm_id_pk]) FROM [admin].[config_bin_master]  where [cbm_ulb_id_fk]=@ulbid and [cbm_zone_id]=@zoneId and [cbm_ward_id]=@wardId and [cbm_binRroad_status]=1) 
 as total,dbcdr_date from [dbo].[dtd_bin_collection_status_view] where dbcdr_ulb_id_fk=@ulbid and czm_id_pk=@zoneId and cwm_id_pk=@wardId and dbcdr_date between @fromDate
  and @endDate group by dbcdr_date







COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	
	  END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[DumpyardEntryAndExitTimeByCEP]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[DumpyardEntryAndExitTimeByCEP]

@tripid int,
@dumpId int,
@alertTime datetime,
@inOutStatus varchar(100)

   
AS
BEGIN

declare @count int;


SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

if @inOutStatus='IN'
 begin
 

  update [reporting].[trip_completed_master] set [tcm_dump_entry_time]=@alertTime where [tcm_trip_id_fk]=@tripid
 
  select  @count=count(*) from [reporting].[trip_ongoing_master] where [tom_trip_id_fk]=@tripid
 
  if @count =1
   begin
   update [reporting].[trip_ongoing_master] set [tom_dump_time]= @alertTime where [tom_trip_id_fk]=@tripid
   end
  
  end

if @inOutStatus='OUT'
 begin
  update [reporting].[trip_completed_master] set [tcm_dump_exit_time]=@alertTime where [tcm_trip_id_fk]=@tripid
 end
COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	
	
	  END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[getAttandanceChartDataMyforDash]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[getAttandanceChartDataMyforDash] 
      
	@ulbid int  
	     
AS
BEGIN
SET NOCOUNT ON;
	--with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0)))   
	--					 where dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()  union all  
	--				select dateadd(dd, 1, dt)from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
	--				   select distinct dt,sum(case when  sar_staff_type_id IN (1,2,3,4) then 1 else 0 end )  as dsa_total_staff_count, 
	--				  sum(case when sar_staff_status=1 then 1 else 0 end ) as dsa_staff_present_count, 
	--				   sum(case when sar_staff_status=0 then 1 else  0 end) as dsa_staff_absent_count 
	--				    from dateRange left join  [reports].[staff_attendance_report] on   CONVERT(date, sar_date) = dt 
	--				 and sar_ulb_id_fk=@ulbid 
	--				  group by dt,sar_date	
	
	
 with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0)))   
						 	 where dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()  union all  
						  select dateadd(dd, 1, dt)from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
						    select distinct dt,
					
							CASE 
							WHEN dt<>cast(getdate() as date) THEN (select count(*) from [reports].[staff_attendance_report] where sar_ulb_id_fk=@ulbid and sar_date=dt)
							--WHEN dt<>cast(getdate() as date) THEN sum(case when  sar_staff_type_id  IN (1,2,3,4)  then 1 else 0 end )
                           -- ELSE sum(case when  osm_status  IN (0,1) then 1 else 0 end )
						   ELSE (select count(*) from staff_attendance.online_staff_master where cssm_ulb_id_fk=@ulbid)
							END  as dsa_total_staff_count,

							CASE 


							WHEN dt<>cast(getdate() as date) THEN sum(case when sar_staff_status=1 and sar_date=dt then 1 else 0 end ) 
                            --ELSE sum(case when  osm_status=0 then 1 else 0 end )
							ELSE (select sum(case when  osm_status=1 then 1 else 0 end )  from staff_attendance.online_staff_master where cssm_ulb_id_fk=@ulbid )
							END as dsa_staff_present_count,

							CASE 
							WHEN dt<>cast(getdate() as date) THEN sum(case when sar_staff_status=0 then 1 else 0 end ) 
                            --ELSE sum(case when  osm_status=0 then 1 else 0 end )
						    ELSE (select sum(case when  osm_status=0 then 1 else 0 end )  from staff_attendance.online_staff_master where cssm_ulb_id_fk=@ulbid )
							END as dsa_staff_absent_count


						     from dateRange
							  left join  [reports].[staff_attendance_report] on   CONVERT(date, sar_date) = dt and sar_ulb_id_fk=@ulbid
							  --left join staff_attendance.online_staff_master on  osm_staff_id=sar_staff_id_fk and cssm_ulb_id_fk=24258
						      group by dt,sar_date 
	
	
		
END

GO
/****** Object:  StoredProcedure [dbo].[getGarbageChartDataFornewDash]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[getGarbageChartDataFornewDash] 
      
	@ulbid int  
	     
AS
BEGIN
SET NOCOUNT ON;

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
								 from [dashboard].[bin_collection_report] where [bcr_date]=dt and [bcr_ward_id]=[cwm_id_pk]) end ) 
								 collected_bins,( select case when dt=cast(getdate() as date) then sum(case when 
								 [ggcf_bin_collection_status]=3 then [ggcf_points_count] else 0 end) else (select sum([bcr_bin_attended_not_collected])  
								from [dashboard].[bin_collection_report] where [bcr_date]=dt and [bcr_ward_id]=[cwm_id_pk]) end ) attended_not_collected_bins
								 from dateRange,[garbage].[gis_garbage_collection_points] 
								  left join  admin.config_ward_master on [cwm_id_pk]=[ggcf_ward_id] left join 
								   admin.config_zone_master on cwm_zone_id_fk=czm_id_pk  where ggcf_ulb_id_fk=@ulbid 
								 group by dt,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,czm_zone_name,[cwm_id_pk]) as t1	
								 
								 	
END

GO
/****** Object:  StoredProcedure [dbo].[getHistoryDataOfBin]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[getHistoryDataOfBin] 
      
	  	@ulbid int,  
	@startdate date,  
	@enddate date   
  
AS
BEGIN
SET NOCOUNT ON;
	select cbsm_bin_id as Id,cbsm_bin_name as bin_name ,avg(bsl_volume_fill_percentage) as avgVolume,cbsm_bin_latitude as lat,cbsm_bin_longitude as lon,
				 cbsm_bin_loc_id as binLocID,ggcf_points_name as binLocName,cbsm_ward_id as wardID,cwm_ward_name as wardName,
				 case when max(bsl_volume_fill_percentage) <=50 then 'Low' when max(bsl_volume_fill_percentage) >50 and max(bsl_volume_fill_percentage) <=90 then 'Medium' when max(bsl_volume_fill_percentage) >90 then 'High' when max(bsl_volume_fill_percentage) is null then 'Low' end as binFillStatus
				 from 
				[dbo].[bin_sensor_log] 
				left join [admin].[config_bin_sensor_master] on bsl_simcard_no=cbsm_sensor_sim_no COLLATE SQL_Latin1_General_CP1_CI_AS 
				left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
				left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
				where convert(varchar(10),bsl_utc_date_time,120) between @startdate and @enddate and cbsm_ulb_id_fk=@ulbid 
				 
				group by [bsl_simcard_no],cbsm_bin_id,cbsm_bin_name,cbsm_bin_latitude,
				cbsm_bin_longitude,cbsm_bin_loc_id,ggcf_points_name,cbsm_ward_id,cwm_ward_name,cbsm_bin_sensor_capasity
				 --order by convert(varchar(10),bsl_utc_date_time,120)	
END

GO
/****** Object:  StoredProcedure [dbo].[getHistoryDataOfBin_withgeom]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[getHistoryDataOfBin_withgeom] 
      
	  	@ulbid int,  
	@startdate date,  
	@enddate date,   
	@geom varchar(max)  
AS
BEGIN
SET NOCOUNT ON;
 DECLARE @g geography;
SET @g = (geography::STGeomFromText(@geom, 4326)); 
	select cbsm_bin_id as Id,cbsm_bin_name as bin_name,avg(bsl_volume_fill_percentage) as avgVolume,cbsm_bin_latitude as lat,cbsm_bin_longitude as lon,
				 cbsm_bin_loc_id as binLocID,ggcf_points_name as binLocName,cbsm_ward_id as wardID,cwm_ward_name as wardName,
				 case when avg(bsl_volume_fill_percentage) <=50 then 'Low' when avg(bsl_volume_fill_percentage) >50 and avg(bsl_volume_fill_percentage) <=70 then 'Medium' when avg(bsl_volume_fill_percentage) >70 then 'High' when avg(bsl_volume_fill_percentage) is null then 'Low' end as binFillStatus
				 from 
				[dbo].[bin_sensor_log] 
				left join [admin].[config_bin_sensor_master] on bsl_simcard_no=cbsm_sensor_sim_no COLLATE SQL_Latin1_General_CP1_CI_AS 
				left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
				left join admin.config_ward_master cwm on cbsm_ward_id=cwm.[cwm_id_pk] 
				where convert(varchar(10),bsl_utc_date_time,120) between @startdate and @enddate and cbsm_ulb_id_fk=@ulbid 
				--and (geometry::STGeomFromWKB(@g.STAsBinary(),@g.STSrid)).STIntersects  (geometry::STGeomFromText(cwm.cwm_geometry.STAsText(), 4326))=1
				--and  (geometry::STGeomFromText(@geom,4326).STContains(geometry::Point( cbsm_bin_longitude ,cbsm_bin_latitude, 4326))=1)
				and    cbsm_ward_id in (select cwm_id_pk
 from admin.config_ward_master cwm where (geometry::STGeomFromWKB(@g.STAsBinary()
,@g.STSrid)).STIntersects 
 (geometry::STGeomFromText(cwm.cwm_geometry.STAsText(), 4326))=1)
				group by [bsl_simcard_no],cbsm_bin_id,cbsm_bin_name,cbsm_bin_latitude,
				cbsm_bin_longitude,cbsm_bin_loc_id,ggcf_points_name,cbsm_ward_id,cwm_ward_name,cbsm_bin_sensor_capasity
				 --order by convert(varchar(10),bsl_utc_date_time,120)	
END

GO
/****** Object:  StoredProcedure [dbo].[GetPredictedDataOfBin]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[GetPredictedDataOfBin] 
      
	  	@ulbid int,  
	@startdate date,  
	@enddate date     
AS
BEGIN
SET NOCOUNT ON;
	 select bspa_Bin_ID,convert(varchar(10),bspa_DateTime,120) as bin_date
				 ,cbsm_bin_loc_id as binLocID,ggcf_points_name as binLocName
				 ,avg(CONVERT(INT, bspa_Predicted_Volume)) AS Avgvolume,cbsm_ward_id as wardID,cwm_ward_name as wardName,cbsm_bin_latitude as bin_lat,cbsm_bin_longitude as bin_lng,
				 case when avg(CONVERT(INT, bspa_Predicted_Volume)) <=50 then 'Low' when avg(CONVERT(INT, bspa_Predicted_Volume)) >50 and avg(CONVERT(INT, bspa_Predicted_Volume)) <=70 then 'Medium' when avg(CONVERT(INT, bspa_Predicted_Volume)) >70 then 'High' when avg(CONVERT(INT, bspa_Predicted_Volume)) is null then 'Low' end as binFillStatus
				 --,avg(bspa_Predicted_Volume) as avgVolume 
				 from [analytics].[bin_sensor_predictive_alert]
				 left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_name=bspa_Bin_ID COLLATE SQL_Latin1_General_CP1_CI_AS
				 left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
				 left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
				 where convert(varchar(10),bspa_DateTime,120) between @startdate and @enddate and cbsm_ulb_id_fk=@ulbid 
				 group by 
				 bspa_Predicted_Volume,
				 bspa_Bin_ID,convert(varchar(10),bspa_DateTime,120),cbsm_bin_loc_id,ggcf_points_name,bspa_Predicted_Volume,cbsm_ward_id,
				 cwm_ward_name,cbsm_bin_latitude,cbsm_bin_longitude
END

GO
/****** Object:  StoredProcedure [dbo].[getPredictionWeekData]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[getPredictionWeekData] 
      
	  	@ulbid int, 
	@date date,  
	@chartTime int,
	@binId int,   
	@wardId varchar(max)  
AS
BEGIN
SET NOCOUNT ON;
if(@chartTime < 0 AND @binId =-1 )/*******FOR ALL ********/
BEGIN

select * from ((select convert(varchar(10),bspa_DateTime,120) as date,DATENAME(weekday, bspa_DateTime) as day,
						avg(CONVERT(INT, bspa_Predicted_Volume)) as avgVolume,case when avg(CONVERT(INT, bspa_Predicted_Volume)) <=50 
						then 'Low' when avg(CONVERT(INT, bspa_Predicted_Volume)) >50 and avg(CONVERT(INT, bspa_Predicted_Volume)) <=70 
						then 'Medium' when avg(CONVERT(INT, bspa_Predicted_Volume)) >70 then 'High' when avg(CONVERT(INT, bspa_Predicted_Volume)) 
						is null then 'Low' end as binFillStatus  
						from [analytics].[bin_sensor_predictive_alert_new]
						left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID   
						left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
						left join admin.config_bin_master on cbsm_bin_id = [cbm_id_pk]
						left join admin.config_ward_master on cbm_ward_id=[cwm_id_pk] 
						where bspa_DateTime between @date and  DATEADD (day , 7 , @date ) 
						--and cbsm_ulb_id_fk=@ulbid  
						and cbm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ','))
						group by DATENAME(weekday, bspa_DateTime),convert(varchar(10),bspa_DateTime,120))) as t1


END;
else 
BEGIN
if (@chartTime >0 AND @binId =-1 ) /*******CHART TIME PASSED bInALL ********/
select * from ((select convert(varchar(10),bspa_DateTime,120) as date,DATENAME(weekday, bspa_DateTime) as day,
						avg(CONVERT(INT, bspa_Predicted_Volume)) as avgVolume,case when avg(CONVERT(INT, bspa_Predicted_Volume)) <=50 
						then 'Low' when avg(CONVERT(INT, bspa_Predicted_Volume)) >50 and avg(CONVERT(INT, bspa_Predicted_Volume)) <=70 
						then 'Medium' when avg(CONVERT(INT, bspa_Predicted_Volume)) >70 then 'High' when avg(CONVERT(INT, bspa_Predicted_Volume)) 
						is null then 'Low' end as binFillStatus  
						from [analytics].[bin_sensor_predictive_alert_new]
						left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID  
						left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
						left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
						where bspa_DateTime between @date and  DATEADD (day , 7 , @date ) 
						--and cbsm_ulb_id_fk=@ulbid 
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ','))
						and  bspa_Hour= @chartTime
						group by DATENAME(weekday, bspa_DateTime),convert(varchar(10),bspa_DateTime,120))) as t1
END;
if (@chartTime <0 AND @binId !=-1 )/*******CHART TIME NOT PASSED BIN ID PASSED ********/
BEGIN
select * from ((select convert(varchar(10),bspa_DateTime,120) as date,DATENAME(weekday, bspa_DateTime) as day,
						avg(CONVERT(INT, bspa_Predicted_Volume)) as avgVolume,case when avg(CONVERT(INT, bspa_Predicted_Volume)) <=50 
						then 'Low' when avg(CONVERT(INT, bspa_Predicted_Volume)) >50 and avg(CONVERT(INT, bspa_Predicted_Volume)) <=70 
						then 'Medium' when avg(CONVERT(INT, bspa_Predicted_Volume)) >70 then 'High' when avg(CONVERT(INT, bspa_Predicted_Volume)) 
						is null then 'Low' end as binFillStatus  
						from [analytics].[bin_sensor_predictive_alert_new]
						left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID  
						left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
						left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
						where bspa_DateTime between @date and  DATEADD (day , 7 , @date ) 
						--and cbsm_ulb_id_fk=@ulbid  
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ','))
						and cbsm_bin_id= @binId
						group by DATENAME(weekday, bspa_DateTime),convert(varchar(10),bspa_DateTime,120))) as t1
END;
if (@chartTime >0 AND @binId !=-1 ) /*******BOTH PASSED ********/
BEGIN
select * from ((select convert(varchar(10),bspa_DateTime,120) as date,DATENAME(weekday, bspa_DateTime) as day,
						avg(CONVERT(INT, bspa_Predicted_Volume)) as avgVolume,case when avg(CONVERT(INT, bspa_Predicted_Volume)) <=50 
						then 'Low' when avg(CONVERT(INT, bspa_Predicted_Volume)) >50 and avg(CONVERT(INT, bspa_Predicted_Volume)) <=70 
						then 'Medium' when avg(CONVERT(INT, bspa_Predicted_Volume)) >70 then 'High' when avg(CONVERT(INT, bspa_Predicted_Volume)) 
						is null then 'Low' end as binFillStatus  
						from [analytics].[bin_sensor_predictive_alert_new]
						left join [admin].[config_bin_sensor_master] cbsm on cbsm.cbsm_bin_id=bspa_Bin_ID  
						left join [garbage].[gis_garbage_collection_points] on ggcf_points_id_pk = cbsm_bin_loc_id 
						left join admin.config_ward_master on cbsm_ward_id=[cwm_id_pk] 
						where bspa_DateTime between @date and  DATEADD (day , 7 , @date ) 
						--and cbsm_ulb_id_fk=@ulbid  
						and cbsm_ward_id in (select * from [dbo].[fnSplitString] (@wardId, ','))
						and cbsm_bin_id= @binId and  bspa_Hour= @chartTime
						group by DATENAME(weekday, bspa_DateTime),convert(varchar(10),bspa_DateTime,120))) as t1
END;
	
END;

GO
/****** Object:  StoredProcedure [dbo].[getSupervisorDetails]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[getSupervisorDetails] 
      

@userID int


AS
BEGIN
SET NOCOUNT ON;

DECLARE @count int;
DECLARE @status bit;


BEGIN TRAN
BEGIN TRY
 
 set @status=1 

select @count=count(*) from [admin].[config_mobile_user_master] where [cmum_workforce_id_fk]=@userID
  

if   @count>0
begin
set @status=1
select @status as Status, [cmum_ulb_id_fk] as ulbId, [cmum_user_name] as name ,superVisorType as userType,[cmum_workforce_id_fk] as supervisorId,[cmum_ward_id] as wardId,[cmum_zone_id] as zoneId from [admin].[config_mobile_user_master] where [cmum_workforce_id_fk]=@userID



end
 
 else if  @count=0
 begin
 set @status=0;
 select @status as Status , 'No Supervisors of this ID' as 'Message' 
 end
 

COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	 set @status=0
	 SELECT @status AS status,ERROR_MESSAGE() AS message
	  END CATCH


END


GO
/****** Object:  StoredProcedure [dbo].[importBinRfidSensorDDdata]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[importBinRfidSensorDDdata]
		@ULB_Id int,
	@user_Id int,
	@zone_name varchar(250),
	@ward_name varchar(250),
	@Road_name varchar(250),
	@bin_name varchar(250),
	@householder_name varchar(250),
	@house_no varchar(250),
	@QR_code varchar(250),
	@phno varchar(20),
	@bin_lat float,
	@bin_long float
		
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @binIdpk int;
	DECLARE @zoneid int;
	DECLARE @wardid int;
	DECLARE @roadid int;
	DECLARE @binMasterCount int;
	DECLARE @rfidMasterCount int;
	BEGIN TRAN
	------------------------
	BEGIN TRY
	-- select czm_id_pk from [admin].[config_zone_master] where czm_ulb_id_fk=21210  and czm_zone_name='Zone1' COLLATE SQL_Latin1_General_CP1_CS_AS 
	select @zoneid=czm_id_pk from [admin].[config_zone_master] where czm_ulb_id_fk=@ULB_Id  and czm_zone_name=@zone_name COLLATE SQL_Latin1_General_CP1_CS_AS 

	-- select cwm_id_pk from [admin].[config_ward_master] where cwm_ulb_id_fk=21210  and cwm_ward_name='ward1' COLLATE SQL_Latin1_General_CP1_CS_AS 
   select @wardid=cwm_id_pk from [admin].[config_ward_master] where cwm_ulb_id_fk=@ULB_Id  and cwm_ward_name=@ward_name COLLATE SQL_Latin1_General_CP1_CS_AS 

  --  select gra_id_pk from [garbage].[gis_road_area] where gra_ulb_id_fk=21210  and gra_name='test' COLLATE SQL_Latin1_General_CP1_CS_AS 
    select @roadid=gra_id_pk from [garbage].[gis_road_area] where gra_ulb_id_fk=@ULB_Id  and gra_name=@Road_name COLLATE SQL_Latin1_General_CP1_CS_AS 

   -- select count(*) as count from [admin].[config_bin_master] where cbm_ulb_id_fk=21210 and cbm_binRroad_status=1 and cbm_bin_name='Bin1001'
   select @binMasterCount = count(*) from [admin].[config_bin_master] where cbm_ulb_id_fk=@ULB_Id and cbm_binRroad_status=1 and cbm_bin_name=@bin_name

   IF(@binMasterCount=0)
   BEGIN

  -- Insert INTO admin.config_bin_master (cbm_ulb_id_fk,cbm_zone_id,cbm_ward_id,cbm_created_by,cbm_bin_capacity,cbm_bin_name,cbm_created_date,cbm_binRroad_status,cbm_person_name,cbm_house_no,cbm_bin_loc_id)
   -- values(21210,21290,5003,26337,0,'Bin1001',(CURRENT_TIMESTAMP),1,'sanju','House001',9023)

   Insert INTO admin.config_bin_master (cbm_ulb_id_fk,cbm_zone_id,cbm_ward_id,cbm_created_by,cbm_bin_capacity,cbm_bin_name,cbm_created_date,cbm_binRroad_status,cbm_person_name,cbm_house_no,cbm_bin_loc_id,cbm_phno)
    values(@ULB_Id,@zoneid,@wardid,@user_Id,0,@bin_name,(CURRENT_TIMESTAMP),1,@householder_name,@house_no,@roadid,@phno)

	select @rfidMasterCount = count(*) from admin.config_rfid_master where crm_ulb_id_fk=@ULB_Id and crm_rfid_no = @QR_code
    
		IF(@rfidMasterCount=0)
		BEGIN

		select  @binIdpk = cbm_id_pk from [admin].[config_bin_master] where cbm_ulb_id_fk=@ULB_Id  and cbm_bin_name=@bin_name COLLATE SQL_Latin1_General_CP1_CS_AS 
  
        --Insert into [admin].[config_rfid_master] (crm_rfid_no,crm_rfid_no2,crm_rfid_type,crm_bin_id,crm_ulb_id_fk,crm_zone_id,crm_ward_id,crm_created_by,crm_created_date,crm_bin_loc_id_fk,crm_bin_lat,crm_bin_long) 
		--values ('MSCL101',0,0,1245523,21210,21290,5003,26337,CURRENT_TIMESTAMP,9023,12.77876763,80.87663)

		Insert into [admin].[config_rfid_master] (crm_rfid_no,crm_rfid_no2,crm_rfid_type,crm_bin_id,crm_ulb_id_fk,crm_zone_id,crm_ward_id,crm_created_by,crm_created_date,crm_bin_loc_id_fk,crm_bin_lat,crm_bin_long) 
		values (@QR_code,0,0,@binIdpk,@ULB_Id,@zoneid,@wardid,@user_Id,CURRENT_TIMESTAMP,@roadid,@bin_lat,@bin_long)


		END
        SELECT 'success' AS status
   END
   ELSE
   BEGIN
		SELECT 'failure' AS status, ERROR_MESSAGE() AS message 
   END

   COMMIT TRAN
   END TRY

	---------------------------------
	BEGIN CATCH
        ROLLBACK TRAN
        
    END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[ImportStaffData]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[ImportStaffData]
@ULB_Id int,
@user_Id int,
@zone_name varchar(250),
@ward_name varchar(250),
@address varchar(350),
@adhar varchar(250),
@shiftType varchar(250),
@mobileno varchar(250),
@empid varchar(250),
@stafftype varchar(250),
@staffName varchar(250),
@emailId varchar(250),
@staffCatagory varchar(250)


AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @staffMasterCount int;
	DECLARE @staffTypeId int;
	DECLARE @zoneId int;
	DECLARE	@wardId int;	
	DECLARE	@shiftTyperId int;	
	DECLARE	@staffCataId int;	
	DECLARE	@staffPrimaryKey int;
	DECLARE	@adharCount int;

	

	BEGIN TRAN
		BEGIN TRY

		select @adharCount=count(*) from [admin].[config_staff_master] where [cssm_aadhar_no]=@adhar

		IF @adharCount=0
			BEGIN



			select @staffTypeId=[cst_id_pk] from [admin].[config_staff_type] where [cst_type]=@stafftype

			select @zoneId=[czm_id_pk] from [admin].[config_zone_master] where [czm_zone_name]=@zone_name and [czm_ulb_id_fk]=@ULB_Id

			select @wardId=[cwm_id_pk] from [admin].[config_ward_master] where [cwm_ward_name] =@ward_name and [cwm_ulb_id_fk]=@ULB_Id

			select @shiftTyperId=[csm_id_pk] from [admin].[config_shift_master] where [csm_shift_name]=@shiftType

			select @staffCataId=[csc_id_pk] from [admin].[config_staff_category] where [csc_type]=@staffCatagory


				insert into admin.config_staff_master (cssm_staff_name,cssm_staff_type,cssm_emp_id,cssm_address,cssm_phone_no,cssm_aadhar_no,cssm_ulb_id_fk,cssm_created_by,cssm_email_id,cssm_mobile_user_status,cssm_created_date,cssm_zone_id_fk,cssm_ward_id_fk,csm_shift_type_id_fk,cssm_staff_category_id_fk)VALUES (@staffName,@staffTypeId,@empid,@address,@mobileno,@adhar,@ULB_Id,@user_Id,@emailId,0,(CURRENT_TIMESTAMP),@zoneId,@wardId,@shiftTyperId,@staffCataId)

				Set @staffPrimaryKey = (SELECT SCOPE_IDENTITY())

			

				INSERT INTO staff_attendance.online_staff_master (osm_staff_name,osm_emp_id,osm_staff_type,osm_phone_no,osm_status,cssm_ulb_id_fk,osm_staff_id,osm_zonename,osm_wardname,osm_shift_type_id_fk,osm_package_id_fk,osm_staff_category_id_fk) VALUES (@staffName,@empid,@stafftype,@mobileno,0,@ULB_Id,@staffPrimaryKey,@zone_name,@ward_name,@shiftTyperId,0,@staffCataId)

				select 'success' as status 
				END
			

		 ELSE
				BEGIN
				select 'error' as status ,@staffName+' of adhar no '+@adhar+' already exist' 
				END

	COMMIT TRAN
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
        
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[insert_bin_rfid_packet]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_bin_rfid_packet]
	-- Add the parameters for the stored procedure here
	@strSimNo NVARCHAR(50),
	@strRfid NVARCHAR(50),
	@strDate NVARCHAR(15),
	@strTime NVARCHAR(15),
	@longitude FLOAT,
	@latitude FLOAT,	
	
	@strPacketType nvarchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	DECLARE @isSimRegistered INT;
	DECLARE @isRfidRegistered NVARCHAR(50);
	DECLARE @rfidStatusToDb NVARCHAR(20);
	DECLARE @differenceInMins INT;
	DECLARE @lastValidTime DATETIME;
	DECLARE @binAddress NVARCHAR(200);
	DECLARE @binName NVARCHAR(200);
	DECLARE @placename NVARCHAR(200);
	DECLARE @city NVARCHAR(50);
	DECLARE @district NVARCHAR(50);
	DECLARE @state NVARCHAR(30);
	DECLARE @binId INT;
	DECLARE @tripOngoingDetailsPk INT;
	DECLARE @binReadCount INT;
	DECLARE @binsToBeCollected INT;
	DECLARE  @binIdForBinLoc  INT;
	DECLARE @ParametersCombinedDate  datetime;
	DECLARE @isValidDataCount int;
	declare @existcount int,@rbin_id int,@trip_id int,@rfid_1 nvarchar(30),@rfid_2 nvarchar(30)
	 declare @bemtpy int,@bpartial int,@bfull int,@fleet_id int


	 SELECT top 1 @fleet_id=com_fleet_id FROM admin.config_online_master WHERE com_sim_no=@strSimNo
	SET @ParametersCombinedDate = CAST(@strDate + ' ' + @strTime as datetime)
	SET @isSimRegistered = (SELECT COUNT(*) FROM dbo.view_online_master WHERE vom_sim_no = @strSimNo)
	
	SELECT top 1 @isRfidRegistered=crm_rfid_no,@binAddress=ggcf_points_name, @binName=ggcf_points_name,@binId =  ggcf_points_id_pk,@rbin_id=crm_bin_id,@rfid_1=crm_rfid_no,@rfid_2=crm_rfid_no2 FROM  admin.config_rfid_master join  [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[crm_bin_id]  
	left join  garbage.gis_garbage_collection_points GGCP on ggcf_points_id_pk=[cbsm_bin_loc_id] WHERE crm_rfid_no = @strRfid or crm_rfid_no2=@strRfid
	SET @lastValidTime = (SELECT TOP 1 brd_date FROM dbo.bin_rfid_details WHERE brd_rfid_status = 'VALID PACKET' AND brd_rfid_number =@strRfid OR brd_rfid_number =@rfid_1 or brd_rfid_number=@rfid_2 ORDER BY brd_id_pk DESC)
	
	IF(@isSimRegistered>0)
	BEGIN
		IF(@isRfidRegistered is not null)
		BEGIN
			
			SET @differenceInMins = (SELECT DATEDIFF(minute, cast(@lastValidTime as datetime),cast(@ParametersCombinedDate as datetime)))
			
			

			IF(@differenceInMins IS NOT NULL)
			BEGIN
				IF(@differenceInMins >= 30)
				BEGIN
					SET @rfidStatusToDb = 'VALID PACKET'
				END
				ELSE
				BEGIN
					
					SET @rfidStatusToDb = 'BIN ALREADY COLLECTED'
				END
			END
			ELSE
			BEGIN
				
				IF(@lastValidTime IS NULL)
				BEGIN
					SET @rfidStatusToDb = 'VALID PACKET'
				END
				ELSE
				BEGIN
					
					SET @rfidStatusToDb = 'INVALID PACKET'
				END
			END
		END
		ELSE
		BEGIN
			SET @rfidStatusToDb = 'RFID NOT REGISTERED'
		END
	END
	ELSE
	BEGIN
		SET @rfidStatusToDb = 'SIM NOT REGISTERED'
	END

	--IF(@binAddress IS NULL)
	--BEGIN
		
		--select top 1  @binAddress = Location from [dbo].[ReferencePoints]  where (Lat between (@latitude-0.05) and (@latitude+0.05)) and (Lon between (@longitude-0.05) and (@longitude+0.05))  
			--ORDER BY cast(SQRT(power((69.1 * (Lat - @latitude)) , 2 ) + power((53 * (Lon - @longitude)), 2)) * 1.609 as float) ASC
		--select top 1  @placename = placename, @city = city, @district = district,@state = state from  dbo.indiaplaces where (latitude between (@latitude-0.05) and (@latitude+0.05)) and (longitude between (@longitude-0.05) and (@longitude+0.05))  
		--ORDER BY cast(SQRT(power((69.1 * (latitude - @latitude)) , 2 ) + power((53 * (longitude - @longitude)), 2)) * 1.609 as float) ASC
		--IF @placename IS NULL AND @city IS NOT NULL 
		--BEGIN
		--	SET @binAddress = @city
		--END
		--ELSE IF @city != ''  
		--Begin
		--	set @binAddress = @placename +',' + @city
		--END
		--ELSE IF @placename IS NOT NULL AND @city = '' 
		--BEGIN
		--	if @state IS NOT NULL
		--  		set @binAddress = @placename +','+ @state
		--	else  
		--		set @binAddress = @placename
		--END
		--else
		--Begin
		--	set @binAddress = @state
		--End
	--END
    -- Insert statements for procedure here
	SELECT @isValidDataCount = COUNT(brd_id_pk) FROM  dbo.bin_rfid_details WHERE brd_rfid_number = @strRfid AND CAST(brd_date AS date) = CAST(GETDATE() AS date)					AND	brd_rfid_status ='VALID PACKET'
	INSERT INTO  dbo.bin_rfid_details (brd_sim_number,brd_rfid_number,brd_date,brd_longitude,brd_latitide,brd_packet_type,brd_rfid_status,brd_bin_address) 
	VALUES(@strSimNo,@strRfid,cast(@ParametersCombinedDate as datetime),@longitude,@latitude,@strPacketType,@rfidStatusToDb,@binAddress)
	print @rfidStatusToDb
	IF (@rfidStatusToDb = 'VALID PACKET')
	
	BEGIN
		
		SELECT @tripOngoingDetailsPk = TOD.tod_id_pk,@binsToBeCollected = TOD.tod_bins_to_be_collected, @binReadCount = CASE WHEN TOD.tod_bins_collected IS NULL THEN 0 ELSE				TOD.tod_bins_collected END,@trip_id=tom_trip_id_fk FROM  reporting.trip_ongoing_details TOD
		LEFT JOIN  reporting.trip_ongoing_master TOM ON  TOM.tom_id_pk = TOD.tod_master_id_fk 
		WHERE TOD.tod_bin_id_fk = @binId AND TOM.tom_trip_status = 1 and tom_vehicle_id_fk= @fleet_id;
	
		
		SET @binReadCount = @binReadCount+1
		
		SELECT @binIdForBinLoc = crm_bin_id FROM  admin.config_rfid_master WHERE crm_rfid_no = @strRfid
			
			select @existcount=count(*) from  reporting.rfid_read_in_each_binLocation where rreb_trip_ongoing_details_id_fk=@tripOngoingDetailsPk and rreb_bin_id_fk=@binIdForBinLoc
		

		IF @existcount<1 and @tripOngoingDetailsPk IS NOT NULL--((@tripOngoingDetailsPk IS NOT NULL) AND (@binReadCount < @binsToBeCollected) AND @isValidDataCount<1)
		BEGIN
			
			UPDATE  reporting.trip_ongoing_details SET tod_bins_collected = @binReadCount,tod_bin_entry_time=cast(@ParametersCombinedDate as datetime),[tod_collection_status]=1 WHERE tod_id_pk = @tripOngoingDetailsPk AND tod_bin_id_fk = @binId and tod_bins_to_be_collected>=@binReadCount
			UPDATE [garbage].[gis_garbage_collection_points] SET [ggcf_bin_collection_status]=1,[ggcf_collected_bins]=@binReadCount,[ggcf_last_collected_date]=cast(@ParametersCombinedDate as datetime) WHERE [ggcf_points_id_pk]=@binId AND ggcf_points_count>=@binReadCount  --and Bin_type_id<>1
			UPDATE [admin].[config_bin_sensor_master] SET cbsm_bin_sensor_capasity=0,cbsm_bin_full_status=0,cbsm_check_count=0,[cbsm_sensor_updated_date]=cast(@ParametersCombinedDate as datetime),cbsm_collection_status=1,[cbsm_collected_time]=cast(@ParametersCombinedDate as datetime),[cbsm_alert_time]=null, [cbsm_sla_time]=null WHERE [cbsm_bin_id]= @rbin_id
			
			--------------------added by Sanju------------------------------------------
			--Update [reporting].[trip_completed_rfid_details] SET tcrd_lat = @latitude , tcrd_long= @longitude, tcrd_date_time = cast(@ParametersCombinedDate as datetime) where tcrd_bin_id_fk = @rbin_id

			------------------@ added by shilpa-------------------------------------
			--insert into  reporting.trip_ongoing_captured_data (tocd_trip_id_fk,tocd_bin_id_fk,tod_collected_datetime) values (@trip_id,@binId,cast(@ParametersCombinedDate as datetime));
			-----------------------------------------------------------------------------
			 --SELECT @bemtpy= sum(case when cbsm_bin_sensor_capasity<=50 --or @capacity<=50 
		  --then 1 else 0 end) FROM admin.config_bin_sensor_master WHERE cbsm_bin_loc_id=@binId
		  
		  UPDATE [garbage].[gis_garbage_collection_points] SET [ggcf_bin_collection_status]=1,[ggcf_collected_bins]=@binReadCount,[ggcf_last_collected_date]=cast(@ParametersCombinedDate as datetime) WHERE [ggcf_points_id_pk]=@binId --AND ggcf_points_count=@bemtpy  and Bin_type_id=1
		  UPDATE [garbage].[gis_garbage_collection_points] SET [ggcf_collected_bins]=@binReadCount,[ggcf_last_collected_date]=cast(@ParametersCombinedDate as datetime) WHERE [ggcf_points_id_pk]=@binId --AND ggcf_points_count>@bemtpy  and Bin_type_id=1
		 

		  ----------------------------------------------------------------------------------
			--UPDATE bin_sensor_alert_log	SET bsal_assign_status=2 WHERE bsal_bin_id=@rbin_id
			INSERT INTO  reporting.rfid_read_in_each_binLocation (rreb_rfid_tag,rreb_bin_loc_id_fk,rreb_bin_id_fk,rreb_bin_name,rreb_trip_ongoing_details_id_fk, rreb_date_time)
			VALUES (@strRfid,@binId,@binIdForBinLoc,@binName,@tripOngoingDetailsPk, @ParametersCombinedDate)
		END
		ELSE
		BEGIN
			UPDATE [garbage].[gis_garbage_collection_points] SET [ggcf_bin_collection_status]=1,[ggcf_collected_bins]=[ggcf_collected_bins]+1,[ggcf_last_collected_date]=cast(@ParametersCombinedDate as datetime) WHERE [ggcf_points_id_pk]=@binId  AND ggcf_points_count>=[ggcf_collected_bins]+1
			UPDATE [admin].[config_bin_sensor_master] SET cbsm_bin_sensor_capasity=0,cbsm_bin_full_status=0,cbsm_check_count=0,[cbsm_sensor_updated_date]=cast(@ParametersCombinedDate as datetime),cbsm_collection_status=1,[cbsm_collected_time]=cast(@ParametersCombinedDate as datetime) WHERE [cbsm_bin_id]= @rbin_id
			--UPDATE bin_sensor_alert_log	SET bsal_assign_status=2 WHERE bsal_bin_id=@rbin_id
		END
	END
	
	select @trip_id as TripId,crm_bin_id as BinId , cbm_bin_name as binName , [cbm_bin_loc_id] as scheduledTaskId from admin.config_rfid_master left join [admin].[config_bin_master] on crm_bin_id=cbm_id_pk where crm_rfid_no=@strRfid
END;

GO
/****** Object:  StoredProcedure [dbo].[insert_bin_sensor_data_ubase]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE  [dbo].[insert_bin_sensor_data_ubase] 
@ht_simcard_no NVARCHAR(20),
@ht_latitude double precision,
@ht_longitude double precision,
@ht_datetime nvarchar(20),
@ht_garbageVolume double precision

AS

BEGIN
SET NOCOUNT ON;

declare @datetime datetime,@bin_id int,@bin_name nvarchar(256),@bin_volume int,@ulb_id int,@bin_location nvarchar(256),@bin_status int,@check_count int,@capacity int,@binlocation_id int,@sensor_update_date datetime,@cb_sla_time datetime
declare @bemtpy int,@bpartial int,@bfull int,@collection_status int


select @bin_id=cbsm_bin_id,@ulb_id=cbsm_ulb_id_fk,@bin_name=cbm_bin_name,@bin_volume=cbsm_bin_volume,@bin_status=cbsm_bin_full_status,
@check_count=cbsm_check_count,@binlocation_id=cbm_bin_loc_id,@bin_location= ggcf_points_name,@sensor_update_date=cbsm_sensor_updated_date,@collection_status=[ggcf_bin_collection_status],@cb_sla_time=[cbsm_sla_time]  FROM  [admin].[config_bin_sensor_master] 
join  [admin].[config_bin_master] on cbm_id_pk=cbsm_bin_id join  garbage.gis_garbage_collection_points on ggcf_points_id_pk=cbm_bin_loc_id where cbsm_sensor_sim_no=@ht_simcard_no


 SET @capacity=round(((@bin_volume-@ht_garbageVolume)*100)/(@bin_volume),0)
 print @capacity
INSERT INTO [dbo].[bin_sensor_log]
           ([bsl_simcard_no]
           ,[bsl_utc_date_time]
           ,[bsl_received_date_time]
           ,[bsl_volume_fill_percentage]          
           ,[bsl_garbage_volume],[sla_alert_status])
     VALUES
           (@ht_simcard_no
           ,cast(@ht_datetime as datetime)
           ,GETDATE()
           ,@capacity
           ,@ht_garbageVolume,case when @cb_sla_time is null then 0 else 1 end)
	IF @sensor_update_date<convert(datetime,@ht_datetime,120 ) OR @sensor_update_date IS NULL
	BEGIN
		  IF @capacity<0 
			  BEGIN
				set @capacity=0
			  END
		  IF @capacity>100
			  BEGIN
				set @capacity=100
			  END
		  IF @capacity>90 
			BEGIN
			--UPDATE [garbage].[gis_garbage_collection_points] SET [ggcf_bin_collection_status]=2 WHERE [ggcf_points_id_pk]=@binlocation_id AND			ggcf_points_count >= (SELECT COUNT(*)+1 FROM admin.config_bin_sensor_master WHERE cbsm_bin_loc_id=@binlocation_id AND cbsm_bin_sensor_capasity>90 and cbsm_bin_id<>@bin_id)  
			---------------------------------------------
				IF( @bin_status=0 )
				   BEGIN
					   UPDATE  admin.[config_bin_sensor_master] SET cbsm_bin_full_status=1
						WHERE cbsm_sensor_sim_no=@ht_simcard_no
					END
			END
		  ELSE
				BEGIN
					UPDATE  admin.[config_bin_sensor_master] SET cbsm_bin_full_status=0 
					WHERE cbsm_sensor_sim_no=@ht_simcard_no
				END
		 
		   
		    UPDATE  admin.[config_bin_sensor_master] SET cbsm_bin_sensor_capasity=@capacity,
			cbsm_sensor_updated_date=cast(@ht_datetime as datetime) WHERE cbsm_sensor_sim_no=@ht_simcard_no
END;
END;

GO
/****** Object:  StoredProcedure [dbo].[insert_complaint_ext_App]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE  [dbo].[insert_complaint_ext_App] 
@incidentId varchar(50),
@name varchar(200),
@email varchar(200),
@address varchar(1000),
@phoneNo varchar(20),
@companyId varchar(20),
@latitude float,
@longitude float,
@description varchar(2000),
@incidentSubType varchar(200),
@incidentSubTypeId int,
@images varchar(4000),
@sourceName varchar(50)
AS

BEGIN
SET NOCOUNT ON;
DECLARE @ulbId int,@wardId int,@zoneId int,@complaintTypeId int,@complaintTypeCount int,@complaintPK int,@location_id int,@location_name varchar(100),@status Bit, @count int ,@gm GEOMETRY

 set @companyId='dscl'

BEGIN TRAN
BEGIN TRY
    SELECT @ulbId= ulbm_id_pk FROM [admin].[urban_local_body_master] WHERE [ulbm_tenant_code]=@companyId

    SELECT TOP 1 @wardId=cwm_id_pk,@zoneId=cwm_zone_id_fk FROM admin.config_ward_master WHERE cwm_geometry.MakeValid().STIntersects(geometry::Point(@longitude,@latitude,4326).MakeValid())=1 and cwm_ulb_id_fk=@ulbId 
	
	IF @sourceName='CEP'
	BEGIN
		SELECT @complaintTypeCount =count(*) from citizen.citizen_complaints_type where typeCode=@incidentSubTypeId and tenantCode=@companyId
		IF @complaintTypeCount=0
		BEGIN
			INSERT INTO [citizen].[citizen_complaints_type] (cct_type,typeCode,tenantCode) VALUES (@incidentSubType,@incidentSubTypeId,@companyId)
		END
		SELECT @complaintTypeId=cct_id_pk from citizen.citizen_complaints_type where typeCode=@incidentSubTypeId and tenantCode=@companyId
	END
	ELSE
	BEGIN
		SELECT @complaintTypeId=cct_id_pk from citizen.citizen_complaints_type where cct_id_pk=@incidentSubTypeId
	END
    INSERT INTO citizen.citizen_complaints (cc_informer_name,cc_email_id,cc_location,cc_phone_no,cc_ward,cc_zone,cc_complaint_type,cc_discription,cc_image_url,cc_complain_mode,cc_citizen_geom,cc_priority,cc_compliant_status,cc_assign_status,cc_complaint_time,cc_ulb_id_fk,cc_complaint_key,sourceName) VALUES (@name,@email,@address,@phoneNo,@wardId,@zoneId,@complaintTypeId,@description,@images,2,geometry::Point(@longitude, @latitude,4326),1,0,0,getdate(),@ulbId,@incidentId,@sourceName)    
	SET @complaintPK=SCOPE_IDENTITY()

		IF @sourceName='CEP'
		--print 'fdfsfdff'
		BEGIN

		--select @count=count(*) from garbage.gis_garbage_collection_points WHERE ggcf_ulb_id_fk=@ulbId and the_fence_geom.STIntersects(geometry::Point(@longitude,@latitude,4326).STBuffer(5*0.001))=1

		--IF @count>0
		--BEGIN
			SELECT TOP 1 @location_id=[ggcf_points_id_pk],@location_name=ggcf_points_name,@gm=the_fence_geom.MakeValid() from 
			garbage.gis_garbage_collection_points WHERE ggcf_ulb_id_fk=@ulbId and @gm.STIntersects(geometry::Point(@longitude,@latitude,4326).STBuffer(5000*0.001))=1
			--5 means 500 meter of radius
			print 1+@location_id 

			UPDATE citizen.citizen_complaints set binLocationFK=@location_id where cc_id_pk=@complaintPK
			--END
		END
		

	SET	@status =1
	SELECT @status AS status,'Complaint Inserted Successfully' as message,@incidentId AS complaintId,@location_id as binLocation
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
SET	@status =0
SELECT @status AS status,ERROR_LINE() as 'errorLine',ERROR_MESSAGE() as message,'' AS complaintId,@location_id as binLocation
END CATCH
END;


--select cwm_id_pk FROM admin.config_ward_master WHERE cwm_geometry.STIntersects(geometry::Point(72.58858703613281,16.993133316040039,4326))=1
 --SELECT TOP 1 cwm_id_pk,cwm_zone_id_fk FROM admin.config_ward_master WHERE cwm_geometry.STIntersects(geometry::Point(72.58858703613281,16.993133316040039,4326))=1 and cwm_ulb_id_fk=24258 
--SELECT TOP 1 [ggcf_points_id_pk],ggcf_points_name from garbage.gis_garbage_collection_points WHERE ggcf_ulb_id_fk=24258 and the_fence_geom.STIntersects(geometry::Point(77.601049,12.973107,4326).STBuffer(5*0.001))=1

GO
/****** Object:  StoredProcedure [dbo].[insert_complaint_to_alert]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE  [dbo].[insert_complaint_to_alert] 
--@date datetime

AS

BEGIN
SET NOCOUNT ON;
BEGIN TRAN
	
	BEGIN TRY
		DECLARE @cc_type_id int,@complaint_type int,@lat float,@lon float ,@count int,@id int, @citizen_name varchar(256),@location_id int,@location_name varchar(500),@ulb int,@complaintid int


		DECLARE  @temp TABLE( rowid int,complaintid int,informer_name varchar(256),complaint_type int,lon float,lat float)
		INSERT INTO @temp
		select  row_number() over( order by cc_id_pk),cc_id_pk,cc_informer_name,cc_complaint_type, geometry::STGeomFromText(CONVERT(nvarchar(50),cc_citizen_geom), 4326).STX,geometry::STGeomFromText(CONVERT(nvarchar(50),cc_citizen_geom), 4326).STY FROM [citizen].[citizen_complaints]    where cc_complaint_type in (24,13,26)  and cc_insertstatus=0
		select * from @temp

	  	SELECT @count=COUNT(*) FROM @temp
		SET @id=1

		WHILE(@id <= @count)
		BEGIN
	
			SELECT @complaintid=complaintid, @lat=lat,@lon=lon,@cc_type_id=complaint_type,@citizen_name=informer_name FROM @temp where RowId=@id order by RowId
			select TOP 1  @location_id=[ggcf_points_id_pk],@location_name=ggcf_points_name,@ulb=ggcf_ulb_id_fk from garbage.gis_garbage_collection_points 
					 WHERE (SQRT(power((69.1 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STX) -@lon)) , 2 ) +power((53 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STY) - @lat)), 2)) * 1609 between 0 and 1000) 
					--select TOP 1  [ggcf_points_id_pk],ggcf_points_name from garbage.gis_garbage_collection_points 
					-- WHERE (SQRT(power((69.1 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STX) -@lat)) , 2 ) +power((53 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STY) - @lon)), 2)) * 1609 between 0 and 2000) 
				
					IF @location_name is not null
					BEGIN
					
					UPDATE [citizen].[citizen_complaints] SET cc_insertstatus=1 where cc_id_pk=@complaintid  
                   INSERT INTO [dbo].[bin_sensor_alert_log](bsal_bin_loc_id,bsal_bin_location,bsal_source_name,bsal_date_time,[bsal_assign_status],bsal_bin_skippedfull_status,bsal_ulb_id_pk) values(@location_id,@location_name,'CITIZEN',GETDATE(),0,2,@ulb)
                        END;
			SET @id=@id+1
		 END;




	COMMIT TRAN
	--return @status
	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
	   -- return set @status=0
	 END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[insert_DTD_bin_rfid_packet]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_DTD_bin_rfid_packet]

		@strRfid NVARCHAR(50),
	--@strDateTime NVARCHAR(25),	
	@longitude FLOAT,
	@latitude FLOAT,	
	@trip_id int,
	@road_name NVARCHAR(100),
	@personname NVARCHAR(100)
	
AS
BEGIN
	DECLARE @details_id int,@count_1 int,@bins_collected int,@dupcount int ,@binId int
	INSERT INTO  [dbo].[dtd_bin_rfid_details]([dbrd_date],[dbrd_longitude],[dbrd_latitide],[dbrd_rfid_status],[dbrd_bin_address],[dbrd_rfid_number]) 
	VALUES(GETUTCDATE(),@longitude,@latitude,0,@road_name,@strRfid
)
select top 1 @details_id=[tod_id_pk],@bins_collected=[tod_bins_collected] from [reporting].[trip_ongoing_details] left join [reporting].trip_ongoing_master on [tom_id_pk]=[tod_master_id_fk] where [tod_bin_name]=@road_name and [tom_trip_id_fk]=@trip_id
select @dupcount=count(*) from [reporting].[rfid_read_in_each_binLocation]  where rreb_trip_ongoing_details_id_fk=@details_id and rreb_rfid_tag=@strRfid

	INSERT INTO [reporting].[rfid_read_in_each_binLocation] 
	SELECT top 1 [crm_bin_loc_id_fk],[crm_bin_id],@road_name,@details_id,@strRfid,@personname,[cbm_bin_name],@latitude,@longitude ,GETUTCDATE()from [admin].[config_rfid_master] JOIN admin.config_bin_master on [cbm_id_pk]=[crm_bin_id] where [crm_rfid_no]= @strRfid

		--update [admin].[config_rfid_master] set [crm_bin_lat]=@latitude,[crm_bin_long]=@longitude,[crm_bin_collection_status]=1,[crm_bin_collection_time]=GETUTCDATE() where [crm_rfid_no]=@strRfid

		update [admin].[config_rfid_master] set [crm_bin_collection_status]=1,[crm_bin_collection_time]=GETUTCDATE(),TripId=@trip_id where [crm_rfid_no]=@strRfid


	SELECT @count_1=count(*) from [admin].[config_rfid_master]  where [crm_rfid_no]= @strRfid
	if(@count_1>0 and @details_id>0 and @dupcount<1)
	begin
		update [reporting].[trip_ongoing_details] set [tod_bins_collected]=@bins_collected+1,[tod_bin_entry_time]=GETUTCDATE() where [tod_id_pk]=@details_id and [tod_bins_collected]<[tod_bins_to_be_collected]
	end

	SELECT @binId=[crm_bin_id] from [admin].[config_rfid_master]  where [crm_rfid_no]= @strRfid
		update [reporting].[DTDTransactionTable] set [dtt_collection_status]=1 where [dtt_trip_id]=@trip_id and [dtt_bin_id]=@binId

END;



GO
/****** Object:  StoredProcedure [dbo].[insert_into_collection_report_table]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_into_collection_report_table] 
       
AS
BEGIN

		INSERT INTO [dashboard].[bin_collection_report]
		select sum(case when [ggcf_bin_collection_status]=1 then [ggcf_collected_bins] else 0 end)CollectedBin,sum(case when [ggcf_bin_collection_status]=0 then [ggcf_points_count] else 0 end)ntCollectedBin,CAST(GETDATE()-1 AS DATE)AS date_time,[ggcf_zone_id],[ggcf_ward_id],[ggcf_ulb_id_fk],sum([ggcf_points_count]) BinTotal,[ggcf_vehicle_id], sum(case when [ggcf_bin_collection_status]=3 then [ggcf_points_count] else 0 end)attendedNotCollectedBin,Bin_type_id 
		from  [garbage].[gis_garbage_collection_points] where Bin_type_id=3 group by [ggcf_zone_id],[ggcf_ward_id],[ggcf_ulb_id_fk],[ggcf_vehicle_id],Bin_type_id

		
		INSERT INTO [dashboard].[bin_collection_report]
		 select CollectedBin,BinTotal-(CollectedBin+AttendedBin) as ntCollectedBin
 ,date_time,[cbsm_zone_id],[cbsm_ward_id],[cbsm_ulb_id_fk],BinTotal,ggcf_vehicle_id,AttendedBin,bin_type
 from(
select [cbsm_ward_id],[cbsm_zone_id],[cbsm_ulb_id_fk],CAST(GETDATE()-1 AS DATE)AS date_time, count([cbsm_bin_id]) BinTotal,sum(case when [cbsm_collection_status]=1 then 1  else 0 end)CollectedBin,
sum(case when [cbsm_collection_status]=3 then 1 else 0 end)AttendedBin,1 bin_type,ggcf_vehicle_id

from  [dbo].[bin_collection_status_view] left join garbage.gis_garbage_collection_points on ggcf_points_id_pk=[cbsm_bin_loc_id] where [cbsm_ulb_id_fk] =16182 group by [cbsm_ward_id],[cbsm_zone_id],[cbsm_ulb_id_fk],ggcf_vehicle_id) as t1

INSERT INTO [reports].[bin_collection_detailed_report]
select cbsm_collection_status,cbsm_bin_id,cbsm_bin_loc_id,CAST(GETDATE()-1 AS DATE),cbsm_zone_id,cbsm_ward_id,cbsm_ulb_id_fk,ggcf_vehicle_id,cbsm_collected_time,Bin_type_id from admin.config_bin_sensor_master left join garbage.gis_garbage_collection_points on ggcf_points_id_pk=[cbsm_bin_loc_id]

		UPDATE  [garbage].[gis_garbage_collection_points] SET [ggcf_bin_collection_status]=0,[ggcf_vehicle_id]=NULL

		update admin.config_bin_sensor_master set cbsm_collection_status=0 
		update scheduling.schedule_trip_master set stm_status=2 where cast(stm_date_time as date)=cast(getdate()-1 as date)
	update reporting.trip_ongoing_master set tom_trip_status=2 where cast(tom_trip_schedule_date_time as date)=cast(getdate()-1 as date)
				
END

GO
/****** Object:  StoredProcedure [dbo].[insert_into_dtd_collection_report_table]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_into_dtd_collection_report_table] 
       
AS
BEGIN
	INSERT INTO [reports].[dtd_bin_collection_detailed_report](
      [dbcdr_bin_collected_status]
      ,[dbcdr_bin_id]
      ,[dbcdr_road_id]
      ,[dbcdr_zone_id]
      ,[dbcdr_ward_id]
      ,[dbcdr_ulb_id_fk]
      ,[dbcdr_vehicle_id_fk]
      ,[dbcdr_collected_time]
      ,[dbcdr_house_holder_name]
      ,[dbcdr_date],
	  dbcdr_trip_id)SELECT [crm_bin_collection_status],[crm_bin_id],[crm_bin_loc_id_fk],[crm_zone_id],[crm_ward_id],[crm_ulb_id_fk],stm_vheicle_id_fk,[crm_bin_collection_time],[cbm_person_name],cast(getdate()-1 as date),TripId from [admin].[config_rfid_master] 
	  LEFT JOIN [admin].[config_bin_master] on [cbm_id_pk]=[crm_bin_id] left join [scheduling].[schedule_trip_master] on stm_id_pk=TripId  where  cbm_binRroad_status=1
	  update [admin].[config_rfid_master] set [crm_bin_collection_status]=0,crm_bin_collection_time=null,TripId=null
				
END

GO
/****** Object:  StoredProcedure [dbo].[insert_into_weight_table]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_into_weight_table] 
@sim_no nvarchar(20), 
@datetime datetime,
@rfid_no nvarchar(30),
@weight double precision

AS
BEGIN
DECLARE @vehicle_id int,@tom_id int,@check_status int,@ts_dg_id int,@ts_dg_name nvarchar(100),@tcm_id int,@trip_id int,@fleetcapacity  double precision,@garbageweight double precision
set @check_status=0
		SELECT TOP 1 @vehicle_id=cfm_id_pk,@fleetcapacity=cfm_fleet_capacity FROM admin.config_fleet_master where [cfm_rfid_number]=@rfid_no
		select  @ts_dg_id=[crd_ts_dg],@ts_dg_name=[gdg_name] from [admin].[config_rfid_reader] left join [garbage].[gis_dumping_grounds] on [gdg_id_pk]= [crd_ts_dg] where [crd_imei_no]=@sim_no
		IF @weight>@fleetcapacity
	   BEGIN
		SET @garbageweight=@weight-@fleetcapacity
		select TOP 1 @tom_id=tom_id_pk,@trip_id=tom_trip_id_fk from  [reporting].[trip_ongoing_master] where tom_vehicle_id_fk=@vehicle_id and [tom_end_location]=@ts_dg_id order by tom_id_pk desc 
		IF @tom_id>0
			BEGIN
			SET @check_status=1
				update [reporting].[trip_ongoing_master] SET tom_weight_disposed=@weight where tom_id_pk=@tom_id


				INSERT INTO [reporting].[trip_weight_details]([twd_trip_id],[twd_vehicle_id_fk],[twd_dgwdid_fk]
			   ,[twd_weight],[twd_updated_date])
				VALUES( @trip_id,@vehicle_id,@ts_dg_id,@garbageweight,@datetime)



			END
		ELSE
			BEGIN
				select TOP 1 @tcm_id=tcm_id_pk from  [reporting].[trip_completed_master] where tcm_vehicle_id_fk=@vehicle_id and [tcm_dumping_ground]=@ts_dg_name  and   @datetime > [tcm_start_date_time] and (tcm_weight_disposed is null or tcm_weight_disposed=0) order by tcm_id_pk desc 
					IF @tcm_id>0
					BEGIN
						SET @check_status=1
						update [reporting].[trip_completed_master] SET tcm_weight_disposed=@weight where tcm_id_pk=@tcm_id 


						INSERT INTO [reporting].[trip_weight_details]([twd_trip_id],[twd_vehicle_id_fk],[twd_dgwdid_fk]
						,[twd_weight],[twd_updated_date])
						VALUES( @trip_id,@vehicle_id,@ts_dg_id,@garbageweight,@datetime)
					END
			END
END

-----------------------------------------------------------------------------------------------------------------------------------------
				IF @check_status=0
					SET @tom_id=0
					SET @trip_id=0
		select TOP 1 @tom_id=tom_id_pk,@trip_id=tom_trip_id_fk from  [reporting].[trip_ongoing_master] where tom_vehicle_id_fk=@vehicle_id and  cast( tom_trip_schedule_date_time as date) =cast(getdate() as date)  and (tom_weight_disposed is null or tom_weight_disposed=0) and tom_trip_status in (1,2) and tom_start_date_time<@datetime
		IF @tom_id>0
			BEGIN
				update [reporting].[trip_ongoing_master] SET tom_weight_disposed=@garbageweight,[tom_received_weight]=@weight, tom_dump_time=@datetime,[tom_end_location]=@ts_dg_id where tom_id_pk=@tom_id
				INSERT INTO [reporting].[trip_weight_details]([twd_trip_id],[twd_vehicle_id_fk],[twd_dgwdid_fk]
			   ,[twd_weight],[twd_updated_date])
				VALUES( @trip_id,@vehicle_id,@ts_dg_id,@garbageweight,@datetime)
			END
		ELSE
			BEGIN
				SET @tcm_id=0
				SET @trip_id=0
				select TOP 1 @tcm_id=tcm_id_pk,@trip_id=tcm_trip_id_fk from  [reporting].[trip_completed_master] where tcm_vehicle_id_fk=@vehicle_id   and    cast( [tcm_trip_date_time] as date) =cast(getdate() as date) and (tcm_weight_disposed is null or tcm_weight_disposed=0) and tcm_start_date_time<@datetime order by tcm_id_pk  DESC
					IF @tcm_id>0
					BEGIN
				
						update [reporting].[trip_completed_master] SET tcm_weight_disposed=@garbageweight,tcm_received_weight=@weight,tcm_dump_entry_time=@datetime, [tcm_dumping_ground]=@ts_dg_name  where tcm_id_pk=@tcm_id --and [tcm_dumping_ground]=@ts_dg_name 
						INSERT INTO [reporting].[trip_weight_details]([twd_trip_id],[twd_vehicle_id_fk],[twd_dgwdid_fk]
						,[twd_weight],[twd_updated_date])
						VALUES( @trip_id,@vehicle_id,@ts_dg_id,@garbageweight,@datetime)
					END
			END

INSERT INTO [reports].[dump_weight_details](dwd_vehicle_id_fk, dwd_dgwdid_fk, dwd_rfid_no, dwd_weight, dwd_updated_date, dwd_received_time, dwd_trip_id_fk)
		SELECT @vehicle_id,@ts_dg_id,@rfid_no,@weight,@datetime,getdate(),@trip_id


END

GO
/****** Object:  StoredProcedure [dbo].[insert_live_vehicle_data_to_VOM_1]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_live_vehicle_data_to_VOM_1] 
AS
BEGIN
	DECLARE @count int;
	DECLARE @I int;
	DECLARE @tempVehId int;
	DECLARE @tempVehStartLoc int;
	DECLARE @tempScheduledTime datetime;
	DECLARE @currentTime datetime;
	DECLARE @currentshift int;
	DECLARE @temp_vehicle_table table(row_id INT IDENTITY(1,1),vehicle_id_pk int)
	DECLARE @tomCnt int;
	DECLARE @J int;
	DECLARE @tomId int;
	DECLARE @tomVehId int;
	DECLARE @tomStartTime datetime;
	DECLARE @binId int;
	DECLARE @binName varchar(50);
	DECLARE @binInTime datetime;
	DECLARE @binOutTime datetime;
	DECLARE @binOrderNo int;
	DECLARE @binDupCount int;
	DECLARE @binCountForBinLoc int;
	DECLARE @driverID int;
	-- temporary table to get ongoing master data
	DECLARE @tempTripOngoingMaster TABLE(tomRowId INT IDENTITY(1,1),tomIdPk int,tomVehIdFk int,tomStartTime datetime)
--============================================================== declaration ends ==========================================================================
	INSERT INTO @temp_vehicle_table SELECT cfm_id_pk from  [admin].[config_fleet_master] 
		WHERE cfm_id_pk not in ( select DISTINCT tom_vehicle_id_fk from    [reporting].[trip_ongoing_master] where  tom_trip_status  IN (0,1) and cast(tom_trip_schedule_date_time as date)=cast(GETDATE() as date) AND tom_vehicle_id_fk is not null) 
--============================================================== to get @temp_vehicle_table row count ======================================================
	SET @count = (SELECT COUNT(row_id) FROM @temp_vehicle_table);
	SET @I = 1;
--============================================================== calculating shift based on current time ==================================================== 
	--select @currentshift=csm_id_pk FROM  [admin].[config_shift_master] 
	--where cast(GETDATE() as time) between csm_shift_start_time and csm_shift_end_time and csm_id_pk <> 4
	select  @currentshift=csm_id_pk from  dbo.[current_shift_view]
--============================================================== itterating through @temp_vehicle_table ==================================================== 
	WHILE (@I <= @count)
	BEGIN
		-- set all variable null beacuse its value is carried to next itteration als
		SET @binId = NULL
		SET @binName = NULL
		SET @binInTime = NULL
		SET @binOutTime = NULL
		SELECT @tomVehId = vehicle_id_pk from  @temp_vehicle_table where row_id =@I
		SELECT top 1 @binId=vios_fence_id,@binName=vios_fence_name, @binInTime=vios_vehicle_in_time,@binOutTime=vios_vehicle_out_time FROM  [dbo].								[vehicle_in_out_status] WHERE vios_vehicle_id_fk = @tomVehId AND CAST (vios_vehicle_in_time AS date) = CAST(GETDATE() AS date) AND vios_vehicle_out_time IS NOT NULL AND vios_fence_type=1
		IF(@binId IS NOT NULL)
		BEGIN
			SELECT @binCountForBinLoc = ggcf_points_count FROM  garbage.gis_garbage_collection_points WHERE ggcf_points_id_pk = @binId
			SELECT @currentTime = GETDATE()

		END
		SET @I=@I+1
	END
--=-================================================ if trip is ongoing and has atleast 1 collected bin then this code will execute====================================
	INSERT INTO @tempTripOngoingMaster SELECT tom_id_pk,tom_vehicle_id_fk,tom_start_date_time FROM  [reporting].[trip_ongoing_master] WHERE 
	cast(tom_start_date_time as date) = cast(GETDATE() AS date) AND tom_vehicle_id_fk IS NOT NULL
	SET @tomCnt = (SELECT COUNT(tomRowId) FROM @tempTripOngoingMaster);
	SET @J = 1;
	WHILE(@J <= @tomCnt)
	BEGIN
	SET @binId=NULL
	SET @binName=NULL
	SET @binInTime=NULL
	SET @binOutTime=NULL
		SELECT @tomId = tomIdPk,@tomVehId = tomVehIdFk, @tomStartTime=tomStartTime FROM @tempTripOngoingMaster WHERE tomRowId = @J
		-- checking wether vehicle come to bin location if came insert details to trip_ongoing_details
		SELECT top 1 @binId=vios_fence_id,@binName=vios_fence_name,
		 @binInTime=vios_vehicle_in_time,@binOutTime=vios_vehicle_out_time 
		 FROM  [dbo].							
		 	[vehicle_in_out_status] WHERE vios_vehicle_id_fk = @tomVehId 
			and vios_vehicle_in_time > @tomStartTime AND vios_fence_type=1
			 
		and datediff(ss, vios_vehicle_in_time , vios_vehicle_out_time)>120 and
		vios_fence_id not in ( SELECT tod_bin_id_fk from  
		[reporting].[trip_ongoing_details] where tod_master_id_fk = @tomId ) 
		order by  vios_vehicle_in_time 
		if(@binName is not null)
		BEGIN
			SELECT @binCountForBinLoc = ggcf_points_count FROM  garbage.gis_garbage_collection_points WHERE ggcf_points_id_pk = @binId
			SELECT @binOrderNo = case when MAX(tod_sequence_no) is null then 0 else MAX(tod_sequence_no) end  from  [reporting].[trip_ongoing_details] WHERE						tod_master_id_fk = @tomId
	
				IF(@binOrderNo = 0)
				BEGIN
					SET @binOrderNo = 1;
				END
				ELSE
				BEGIN
					SET @binOrderNo = @binOrderNo +1;
				END
				INSERT INTO  [reporting].[trip_ongoing_details]
					(tod_master_id_fk,tod_bin_id_fk,tod_bin_name,tod_collection_status,tod_bin_entry_time,
					tod_bin_exit_time,tod_sequence_no,tod_bins_collected,tod_bins_to_be_collected)
				VALUES(@tomId,@binId,@binName,1,@binInTime,@binOutTime,@binOrderNo,@binCountForBinLoc,@binCountForBinLoc)
		END
		SET @J = @J+1;
	END
	UPDATE reporting.trip_ongoing_master SET tom_trip_status=2 WHERE tom_trip_status=1 and CAST(GETDATE() AS date)<> CAST(tom_trip_schedule_date_time AS DATE)
	-------------------------------------------Handling citizen complaints & bins full ----------------------------------------
	DECLARE @dispatch_trip_master TABLE(dtmRowId INT IDENTITY(1,1),vheicle_id int,bin_location_id int,dumping_ground int,binloc_name nvarchar(256),bin_count int,dispatch_id int,vehicle_type_id int,status_1 int,bin_id int)
	DECLARE @K int,@dis_count int,@dbinloc_id int,@ddump_id int--,@dtom_id int,
	declare @td_count int,@disatch_id int,@vehicle_type int,@trip_id int,@status_char int,@dbin_id nvarchar(max),@isNewTrip int
	set @isNewTrip=0
	INSERT INTO @dispatch_trip_master
	SELECT dtm_vheicle_id_fk,dtm_bin_location_id,dtm_dumping_ground,CASE WHEN ggcf_points_name IS NULL THEN [gra_name] ELSE ggcf_points_name END AS 
	ggcf_points_name,CASE WHEN ggcf_points_name IS NULL THEN 1 ELSE ggcf_points_count END ggcf_points_count,dtm_id_pk,cfm_vehicle_type_id_fk,CASE WHEN ggcf_points_name IS NULL THEN 1 ELSE 0 END AS 
	status_1,dtm_bin_id FROM [scheduling].[dispatch_trip_master] join admin.config_fleet_master on cfm_id_pk=dtm_vheicle_id_fk
	
	LEFT JOIN garbage.gis_garbage_collection_points ON ggcf_points_id_pk=dtm_bin_location_id
	LEFT JOIN [garbage].[gis_road_area] ON [gra_id_pk]=dtm_bin_location_id
	 WHERE dtm_status=0 and dtm_schedule_type=0 group by dtm_bin_location_id,dtm_vheicle_id_fk,dtm_dumping_ground,ggcf_points_name,ggcf_points_count,dtm_id_pk,cfm_vehicle_type_id_fk,[gra_name],dtm_bin_id

	 SELECT @dis_count=COUNT(*) FROM @dispatch_trip_master
	 SET @K = 1
	 WHILE(@K <= @dis_count)
	BEGIN
	set @tomId=0
	set @binOrderNo=0
	set @binCountForBinLoc=0
	set @binName=null
	SET @tomVehId=0
	SELECT top 1 @tomVehId=vheicle_id,@dbinloc_id=bin_location_id,@ddump_id=dumping_ground,@binName= binloc_name,@binCountForBinLoc=bin_count,@disatch_id=dispatch_id,@vehicle_type=vehicle_type_id,@status_char=status_1,@dbin_id=bin_id FROM @dispatch_trip_master where dtmRowId=@K order by dtmRowId
	SELECT top 1 @tomId=tom_id_pk,@trip_id=tom_trip_id_fk FROM reporting.trip_ongoing_master WHERE tom_vehicle_id_fk=@tomVehId AND tom_trip_status IN (0,1) and cast(tom_trip_schedule_date_time as date)=cast(GETDATE() as date)
	
	SELECT @binOrderNo = case when MAX(tod_sequence_no) is null then 0 else MAX(tod_sequence_no) end  from  [reporting].[trip_ongoing_details] WHERE tod_master_id_fk = @tomId
	
	IF @tomId>0
	BEGIN
	select @td_count=case when count(*) is null then 0 else  count(*) end  from [reporting].[trip_ongoing_details] where tod_bin_id_fk=@dbinloc_id and [tod_master_id_fk]=@tomId
	
	if(@td_count<1)
	begin
	
	INSERT INTO  [reporting].[trip_ongoing_details]
					(tod_master_id_fk,tod_bin_id_fk,tod_bin_name,tod_collection_status,
					tod_sequence_no,tod_bins_to_be_collected)
				VALUES(@tomId,@dbinloc_id,@binName,0,@binOrderNo,@binCountForBinLoc)
	end
	ELSE
	BEGIN
	IF @status_char=1
		begin
			select @binCountForBinLoc=@binCountForBinLoc+[tod_bins_to_be_collected]  from [reporting].[trip_ongoing_details] where tod_bin_id_fk=@dbinloc_id and [tod_master_id_fk]=@tomId
			update  [reporting].[trip_ongoing_details] set tod_bins_to_be_collected=@binCountForBinLoc where
		tod_bin_id_fk=@dbinloc_id and [tod_master_id_fk]=@tomId
		end
	END
	END
	ELSE
	BEGIN

	
	insert into scheduling.schedule_trip_master (stm_vehicle_category_id_fk,stm_vheicle_id_fk,stm_shift_id_fk,stm_date_time,stm_end_location) values (  @vehicle_type,@tomVehId,@currentshift,getdate(),@ddump_id)
	set @trip_id=SCOPE_IDENTITY()
	set @isNewTrip=1
	 select @driverID = cmum_driver_id from [admin].[config_mobile_user_master] where cmum_vehicle_id=@tomVehId
	INSERT INTO  [reporting].[trip_ongoing_master] (tom_vehicle_id_fk,tom_trip_id_fk,tom_trip_schedule_date_time,tom_start_date_time,tom_start_location,tom_trip_status,tom_shift_id_fk,tom_start_loc_type,tom_end_location,tom_route_type,tom_driver_id_fk)
			VALUES (@tomVehId,@trip_id,getdate(),getdate(),'',1,@currentshift,0,@ddump_id,@status_char,@driverID)
			-- to select recently inserted primary key value in [trip_ongoing_master]
			SELECT @tomId=SCOPE_IDENTITY()
			insert into scheduling.schedule_trip_details(std_stm_id_fk,std_bin_id_fk,std_sequence_no,std_bins_to_be_collected)values (@trip_id,@dbinloc_id,@binOrderNo,@binCountForBinLoc)
	INSERT INTO  [reporting].[trip_ongoing_details]
					(tod_master_id_fk,tod_bin_id_fk,tod_bin_name,tod_collection_status,
					tod_sequence_no,tod_bins_to_be_collected)
				VALUES(@tomId,@dbinloc_id,@binName,0,@binOrderNo,@binCountForBinLoc)

	END
	
	update [scheduling].[dispatch_trip_master] set  dtm_status=1,dtm_trip_id=@trip_id,is_new_trip=@isNewTrip where dtm_id_pk=@disatch_id
	SET @K=@K+1
	END


	----------------------------------------dynamic start of trip without trip ---------------------------------------------------------
	DECLARE @schedule_trip_master TABLE(stmRowId INT IDENTITY(1,1),vehicle_id int,start_location_id int,vehicle_type int)
	DECLARE @dumping_ground TABLE(dgRowId INT IDENTITY(1,1),dgvehicle_id int)
	DECLARE @stm_count int,@L int,@stm_vehicle int,@stm_start_location int,@vehicle_out_time datetime,@is_in int,@start_date datetime,@shift_id int,@veh_type int,@dg_count INT,@M INT
	INSERT INTO @schedule_trip_master
	SELECT cfm_id_pk,cfm_start_location,[cfm_vehicle_type_id_fk] FROM admin.config_fleet_master WHERE cfm_id_pk not in (SELECT stm_vheicle_id_fk FROM scheduling.schedule_trip_master WHERE CAST(stm_date_time as date)=cast(getdate() as date))

	 SELECT @stm_count=COUNT(*) FROM @schedule_trip_master
	 SET @L = 1
	 WHILE(@L <= @stm_count)
		BEGIN
		set @stm_vehicle=null
		set @stm_start_location=null
		set @veh_type=null
		set @start_date=null
		set @shift_id=null
		set @vehicle_out_time=null
		set @is_in =null
		set @trip_id=null
			SELECT top 1 @stm_vehicle=vehicle_id,@stm_start_location=start_location_id,@veh_type=vehicle_type FROM @schedule_trip_master where stmRowId=@L order by stmRowId
			select @start_date= convert(datetime,replace(convert(nvarchar(10),getdate(),111),'/','-')+' '+convert(nvarchar(10),csm.csm_shift_start_time,108),120),@shift_id=csv.csm_id_pk from [dbo].[current_shift_view] csv join [admin].[config_shift_master] csm on csm.csm_id_pk=csv.csm_id_pk
			IF @start_date IS NOT NULL
			SELECT TOP 1 @vehicle_out_time=vios_vehicle_out_time,@is_in=vios_is_in 
					FROM  dbo.vehicle_in_out_status WHERE vios_vehicle_id_fk=@stm_vehicle
					AND vios_fence_type =2 AND vios_fence_id=@stm_start_location AND 
					vios_vehicle_out_time>DATEADD(MINUTE,-30,@start_date) and DATEDIFF(MINUTE,vios_vehicle_out_time,GETDATE())>=5  ORDER BY vios_vehicle_in_time
					--SELECT DATEADD(MINUTE,-30,CURRENT_TIMESTAMP)
					IF @vehicle_out_time IS NOT NULL 
					BEGIN
						
						insert into scheduling.schedule_trip_master (stm_vehicle_category_id_fk,stm_vheicle_id_fk,stm_shift_id_fk,stm_date_time,[stm_start_location],[stm_final_location],[stm_start_loc_type],[stm_end_loc_type]) values (  @vehicle_type,@stm_vehicle,@shift_id,@vehicle_out_time,@stm_start_location,@stm_start_location,2,2)
	set @trip_id=SCOPE_IDENTITY()
	INSERT INTO  [reporting].[trip_ongoing_master]																														(tom_vehicle_id_fk,tom_trip_id_fk,tom_trip_schedule_date_time,tom_start_date_time,tom_start_location,tom_trip_status,tom_shift_id_fk,tom_start_loc_type,tom_end_loc_type,tom_final_location)
			VALUES (@stm_vehicle,@trip_id,@vehicle_out_time,@vehicle_out_time,@stm_start_location,1,@shift_id,2,2,@stm_start_location)
					END 

			SET @L=@L+1
		END

		declare @dg_vehicle int
		INSERT INTO @dumping_ground
		SELECT tom_vehicle_id_fk FROM reporting.trip_ongoing_master WHERE tom_route_id_fk=0 and cast(tom_trip_schedule_date_time as date)=cast(getdate() as date) and tom_end_location is null and tom_trip_status=1
		SELECT @dg_count=COUNT(*) FROM @dumping_ground
	 SET @M = 1
	 WHILE(@M <= @dg_count)
		BEGIN
		SELECT top 1 @dg_vehicle=dgvehicle_id FROM @dumping_ground where dgRowId=@L order by dgRowId
		SELECT top 1 * FROM vehicle_in_out_status WHERE vios_vehicle_id_fk=@dg_vehicle and vios_fence_type=3 and DATEDIFF(MINUTE,vios_vehicle_in_time,vios_vehicle_out_time)>=5 order by vios_vehicle_in_time desc

		END
END

GO
/****** Object:  StoredProcedure [dbo].[insert_schedule_details]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE  [dbo].[insert_schedule_details] 
@driverid int,
@reqWorkForce bit ,
@vehicle_id int,
@binid int,
@dumpground_id int, 
@route_id int,
@isBinLoc int,
@staff_id varchar(256),
@shift_id int,
@schedule_time varchar(25),
@vehicle_type int,
@start_location int,
@end_location int,
@start_loc_type int,
@end_loc_type int,
@route_type int,
@mainParam bit,
@repeat_type int,
@repeat_schedule_date varchar(256),
@schedule_end_time varchar(25),
@Otrip_id int OUT
AS
SET NOCOUNT ON
BEGIN
--SET @schedule_end_time = '2020-03-31 23:59:59';
DECLARE @trip_id int,@setschedule_time varchar(256),@tom_id int,@route_geom geometry, @Driver_id int
DECLARE @temp_route_details table(master_id int,bin_id int,bin_name varchar(50),tod_sequence_no int,tod_route_id int,tod_bins_to_be_collected int)

if @reqWorkForce=1
begin
select @Driver_id = cmum_driver_id from [admin].[config_mobile_user_master] where cmum_vehicle_id=@vehicle_id
end
if @reqWorkForce=0
begin
set @Driver_id=@driverid
end

INSERT INTO scheduling.schedule_trip_master(stm_driver_id_fk,stm_vheicle_id_fk,stm_end_location,stm_route_id_fk,stm_staff,stm_shift_id_fk,stm_date_time,
stm_end_time,
stm_vehicle_category_id_fk,stm_start_location,stm_final_location,stm_start_loc_type,stm_end_loc_type)
VALUES (@Driver_id,@vehicle_id,@dumpground_id,@route_id,@staff_id,@shift_id,convert(datetime,@schedule_time,120),
convert(datetime,@schedule_end_time,120),
@vehicle_type,@start_location,@end_location,@start_loc_type,@end_loc_type)

	SET @trip_id=SCOPE_IDENTITY()
	
	select @route_geom=[rm_geom] from [garbage].[route_master] where [rm_id_pk]=@route_id
INSERT INTO [reporting].[trip_ongoing_master](singleBinArea_FK, tom_driver_id_fk, tom_vehicle_id_fk,tom_trip_id_fk,tom_route_id_fk,tom_trip_schedule_date_time,tom_shift_id_fk,tom_end_location,tom_start_location,tom_final_location,tom_start_loc_type,tom_end_loc_type,tom_route_type,tom_rm_geom)
VALUES(@binid, @Driver_id, @vehicle_id,@trip_id,@route_id,convert(datetime,@schedule_time,120),@shift_id,@dumpground_id,@start_location,@end_location,@start_loc_type,@end_loc_type,@route_type,@route_geom)
	SET @tom_id=SCOPE_IDENTITY()
IF(@mainParam=1)
BEGIN
	IF @repeat_type=4	
		SET @setschedule_time=@repeat_schedule_date	
	ELSE
		SET @setschedule_time=@schedule_time
	
	INSERT INTO scheduling.schedule_trip_repeatedly (str_stm_id_fk,str_repeat_status,str_shift_id_fk,str_schedule_date,str_schedule_end_date)
	VALUES(@trip_id,@repeat_type,@shift_id,@setschedule_time,@schedule_end_time)
END
	INSERT INTO scheduling.schedule_trip_details(std_stm_id_fk,std_bin_id_fk,std_sequence_no) 
	SELECT @trip_id,[rd_check_point_id_fk],[rd_order_no] FROM garbage.route_details WHERE [rd_route_id_fk]=@route_id
	
	if @route_type=0
	begin
	
			if @route_id !='' or @route_id !=0
			begin
			
				insert into @temp_route_details
					SELECT @tom_id,[rd_check_point_id_fk],[rd_check_points],[rd_order_no],@route_id,[ggcf_points_count] FROM garbage.route_details left join [garbage].[gis_garbage_collection_points] on [ggcf_points_id_pk]=[rd_check_point_id_fk] WHERE [rd_route_id_fk]=@route_id
			end
			else
			begin
			
			print @isBinLoc
			if @isBinLoc=1
			
				begin
				print 'Bin'
					insert into @temp_route_details
							SELECT @tom_id,[ggcf_points_id_pk],[ggcf_points_name],1,@route_id,[ggcf_points_count] FROM [garbage].[gis_garbage_collection_points]  WHERE [ggcf_points_id_pk]=@binid
				end
			else
				begin
				print 'TS'
					insert into @temp_route_details
							SELECT @tom_id,gdg_id_pk as[ggcf_points_id_pk],gdg_name as [ggcf_points_name],1,@route_id,'0' as [ggcf_points_count] FROM garbage.gis_dumping_grounds  WHERE gdg_id_pk=@binid
				end
			end
	end
	else
	   begin
		insert into @temp_route_details
		SELECT @tom_id,[rd_check_point_id_fk],[rd_check_points],[rd_order_no],@route_id,[gra_points_count] FROM garbage.route_details left join [garbage].[gis_road_area] on [gra_id_pk]=[rd_check_point_id_fk] WHERE [rd_route_id_fk]=@route_id
		--select * from @temp_route_details
		update [admin].[config_rfid_master] set [TripId]=@trip_id where [crm_bin_loc_id_fk] in(select rd_check_point_id_fk from [garbage].[route_details] left join [admin].[config_bin_master] on cbm_bin_loc_id=rd_check_point_id_fk  where [rd_route_id_fk]=@route_id and [cbm_binRroad_status]=1)

		insert into [reporting].[DTDTransactionTable] (dtt_bin_id,dtt_trip_id,[dtt_collection_status],dtt_inserted_date)  (select [crm_bin_id],[TripId],0,GETDATE() from [admin].[config_rfid_master]  where [TripId]=@trip_id)

       end
	  
   INSERT INTO reporting.trip_ongoing_details(tod_master_id_fk,tod_bin_id_fk,tod_bin_name,tod_sequence_no,tod_bins_to_be_collected)	
	select master_id ,bin_id ,bin_name ,tod_sequence_no,tod_bins_to_be_collected  from @temp_route_details	
	
	
	
	
					

 set @Otrip_id=@trip_id 
 return @Otrip_id
END



GO
/****** Object:  StoredProcedure [dbo].[insert_two_way_weight_data]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_two_way_weight_data]
@sim_no nvarchar(20), 
@datetime datetime,
@rfid_no nvarchar(30),
@weight double precision
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @vehicle_id int,@tom_id int,@check_status int,@ts_dg_id int,@ts_dg_name nvarchar(100),@tcm_id int,@trip_id int,@fleetcapacity  double precision,@garbageweight double precision
	DECLARE @weightDisposed double precision,@grossWeight double precision,@NetWeight double precision,@currentCount int,@dwdID int,@previousTime datetime,@timeDiffInMinReturn int,@timeDiffInSecStable int,@grossStable int,@netStable int
	BEGIN TRAN
	BEGIN TRY
		set @trip_id=0; 
		SELECT TOP 1 @vehicle_id=cfm_id_pk,@fleetcapacity=cfm_fleet_capacity FROM admin.config_fleet_master where [cfm_rfid_number]=@rfid_no
		select  @ts_dg_id=[crd_ts_dg],@ts_dg_name=[gdg_name] from [admin].[config_rfid_reader] left join [garbage].[gis_dumping_grounds] on [gdg_id_pk]= [crd_ts_dg] where [crd_imei_no]=@sim_no
		IF @vehicle_id is not null
		BEGIN
		select TOP 1 @tom_id=tom_id_pk,@trip_id=tom_trip_id_fk,@weightDisposed=tom_weight_disposed,@grossWeight=tom_received_weight from  [reporting].[trip_ongoing_master] where tom_vehicle_id_fk=@vehicle_id and [tom_end_location]=@ts_dg_id and  
		cast( tom_trip_schedule_date_time as date) =cast(getdate() as date) -- and (tom_weight_disposed is null or tom_weight_disposed=0) 
		and tom_trip_status in (1,2) and tom_start_date_time<@datetime order by tom_id_pk desc 
		IF @tom_id>0
			BEGIN
				IF (@grossWeight is null or @grossWeight=0)
					BEGIN
						update [reporting].[trip_ongoing_master] SET tom_received_weight=@weight,tom_dump_time=@datetime where tom_id_pk=@tom_id
						INSERT INTO [reporting].[trip_weight_details]([twd_trip_id],[twd_vehicle_id_fk],[twd_dgwdid_fk]
						,twd_gross_weight,[twd_updated_date])
						VALUES( @trip_id,@vehicle_id,@ts_dg_id,@weight,@datetime)
					END
				ELSE 
					BEGIN
						set @NetWeight=@grossWeight-@weight
						update [reporting].[trip_ongoing_master] SET tom_weight_disposed=@NetWeight where tom_id_pk=@tom_id
						update [reporting].[trip_weight_details] set [twd_weight]=@NetWeight where [twd_trip_id]=@trip_id and [twd_vehicle_id_fk]=@vehicle_id
					END
			END
		ELSE
			BEGIN
				select TOP 1 @tcm_id=tcm_id_pk,@trip_id=tcm_trip_id_fk,@grossWeight=tcm_received_weight,@weightDisposed=tcm_weight_disposed from  [reporting].[trip_completed_master] where tcm_vehicle_id_fk=@vehicle_id and cast( [tcm_trip_date_time] as date) =cast(getdate() as date) 
				--and (tcm_weight_disposed is null or tcm_weight_disposed=0) 
				and tcm_start_date_time<@datetime order by tcm_id_pk  DESC
					IF @tcm_id>0
						BEGIN
							IF (@grossWeight is null or @grossWeight=0)
								BEGIN
									update [reporting].[trip_completed_master] SET tcm_received_weight=@weight,tcm_dump_entry_time=@datetime where tcm_id_pk=@tcm_id 
									INSERT INTO [reporting].[trip_weight_details]([twd_trip_id],[twd_vehicle_id_fk],[twd_dgwdid_fk]
									,twd_gross_weight,[twd_updated_date])
									VALUES( @trip_id,@vehicle_id,@ts_dg_id,@weight,@datetime)
								END
							ELSE
								BEGIN
									set @NetWeight=@grossWeight-@weight
									update [reporting].[trip_completed_master] SET tcm_weight_disposed=@NetWeight,tcm_dump_exit_time=@datetime where tcm_id_pk=@tcm_id 
									update [reporting].[trip_weight_details] set [twd_weight]=@NetWeight where @trip_id=@trip_id and [twd_vehicle_id_fk]=@vehicle_id
								END
						END
				END
---currentCount is used to check if for the current day is it the first record for the weight data of a vehicle
--I need to find the time where first in-time of a vehicle (To this time I need to add 30 sec and will check the packets received 
--after that and update the current records, time and gross weight value 
	select @currentCount=Count(*) from  [reports].[dump_weight_details] where [dwd_vehicle_id_fk]=@vehicle_id and [dwd_dgwdid_fk]=@ts_dg_id and [dwd_rfid_no]=@rfid_no and cast([dwd_updated_date] as date)=cast(getdate() as date)
	IF @currentCount=0
		BEGIN
			INSERT INTO [reports].[dump_weight_details] ([dwd_vehicle_id_fk],[dwd_dgwdid_fk],[dwd_rfid_no],[dwd_weight],[dwd_updated_date],[dwd_received_time],[dwd_trip_id_fk],[dwd_disposed_weight]) 
			values (@vehicle_id,@ts_dg_id,@rfid_no,@weight,@datetime,getdate(),@trip_id,0)
		END
	ELSE
		BEGIN
			select top 1 @dwdID=dwd_id_pk,@grossWeight=[dwd_weight],@weightDisposed=[dwd_disposed_weight],@previousTime=dwd_updated_date,@grossStable=gross_weight_stable,@netStable=net_weight_stable from  [reports].[dump_weight_details] where [dwd_vehicle_id_fk]=@vehicle_id and [dwd_dgwdid_fk]=@ts_dg_id and [dwd_rfid_no]=@rfid_no and cast([dwd_updated_date] as date)=cast(getdate() as date) order by dwd_id_pk desc
			SET @timeDiffInMinReturn=DATEDIFF(MINUTE, @previousTime, @datetime);
			SET @timeDiffInSecStable=DATEDIFF(SECOND, @previousTime, @datetime);

			IF (@timeDiffInSecStable>=40 and @timeDiffInSecStable<=60)
			BEGIN
				IF ((@weightDisposed is null or @weightDisposed=0) and (@grossWeight is not null or @grossWeight<>0) and @grossStable=0)
					BEGIN
						UPDATE [reports].[dump_weight_details] set [dwd_weight]=@weight,gross_weight_stable=1,[dwd_updated_date]=@datetime where dwd_id_pk=@dwdID
					END
				ELSE IF  @weightDisposed<>0 and @grossStable=1 and @netStable=0
					BEGIN
						set @NetWeight=@grossWeight-@weight
						UPDATE [reports].[dump_weight_details] set [dwd_disposed_weight]=@NetWeight,net_weight_stable=1 where dwd_id_pk=@dwdID
					END
			END
			IF @timeDiffInMinReturn>=5
				BEGIN
					IF (@grossWeight>0 and (@weightDisposed is null or @weightDisposed=0))
						BEGIN
							set @NetWeight=@grossWeight-@weight
							IF (@NetWeight > 0)
							BEGIN
								update [reports].[dump_weight_details]  set [dwd_disposed_weight]=@NetWeight,dwd_updated_date=@datetime,dwd_received_time=getdate() where dwd_id_pk=@dwdID and gross_weight_stable=1
							END
						END
					ELSE
						BEGIN
							INSERT INTO [reports].[dump_weight_details] ([dwd_vehicle_id_fk],[dwd_dgwdid_fk],[dwd_rfid_no],[dwd_weight],[dwd_updated_date],[dwd_received_time],[dwd_trip_id_fk],[dwd_disposed_weight]) 
							values (@vehicle_id,@ts_dg_id,@rfid_no,@weight,@datetime,getdate(),@trip_id,0)
						END
				END
		END
	END
	COMMIT TRAN
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[insert_update_delete_binLocation]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_update_delete_binLocation]
	@binLocation_name varchar(250),
	@ULB_Id int,
	@user_Id int,
	@binLocation_address varchar(2000),
	@bin_radius float,
	@bin_zoneId int,
	@bin_wardId int,
	@bin_Count int,
	@bin_type int,
	@bin_geom varchar(100),
	@bin_fence_geom varchar(max),
	@action_status int,
	@binlocationPK int=0,
	@frequency int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @bins_count int;   
	DECLARE @binId_count int
	BEGIN TRAN
	
	BEGIN TRY
	IF (@action_status=1)
		BEGIN
			select @bins_count=count(*) from [garbage].[gis_garbage_collection_points] where [ggcf_points_name]=@binLocation_name and [ggcf_ulb_id_fk]=@ULB_Id
				IF @bins_count>0
				BEGIN
					SELECT 'failure' AS status
				END
				ELSE
				BEGIN
					insert into [garbage].[gis_garbage_collection_points]([ggcf_points_name],[ggcf_points_address],[the_geom],[poi_type_details],[the_radious],[the_fence_geom],[ggcf_zone_id],[ggcf_ward_id],[ggcf_created_by],[ggcf_created_date],[ggcf_ulb_id_fk],ggcf_points_count,Bin_type_id,ggcf_minfrequency)
					 VALUES (@binLocation_name,@binLocation_address,
					 geometry::STGeomFromText(@bin_geom,4326),1,@bin_radius,geometry::STGeomFromText(@bin_fence_geom, 4326),@bin_zoneId,@bin_wardId,@user_Id,getdate(),@ULB_Id,@bin_Count,@bin_type,@frequency)

					 SELECT max(ggcf_points_id_pk) as binlocationPK, 'success' AS status from [garbage].[gis_garbage_collection_points]  

				END
		END
	--ELSE IF (@action_status=2)
	--	BEGIN
			--UPDATE [garbage].[gis_garbage_collection_points] SET  ggcf_points_name=?,ggcf_points_address=?,the_fence_geom=geometry::STGeomFromText('"
					--+ obj.getString("binPoly") + "', 4326),the_geom=geometry::STGeomFromText('"
				--	+ obj.getString("binGeom") + "', 4326),the_radious=?,ggcf_points_count = ?,Bin_type_id = ?  WHERE [ggcf_points_id_pk]=?
		
		--END
	ELSE IF (@action_status=3)
		BEGIN
			select @bins_count=count(*) from [garbage].[route_details] inner join [garbage].[route_master] on [rd_route_id_fk]=[rm_id_pk] and [rm_type]=0 where [rd_check_point_id_fk]=@binlocationPK
			IF(@bins_count>0)
				BEGIN
					SELECT 'failure' AS status
				END
			ELSE 
				BEGIN
					select @binId_count=count(*) FROM [admin].[config_bin_sensor_master] where [cbsm_bin_loc_id]=@binlocationPK
					IF (@binId_count>0)
						BEGIN
							 select @binId_count as binIdCount,'BinIdCount' AS status 
						END
					ELSE
					BEGIN
						DELETE FROM [garbage].[gis_garbage_collection_points] WHERE  [ggcf_points_id_pk]=@binlocationPK

						select 'success' AS status
					END
				END

		END
		
	COMMIT TRAN
	--return @status
	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
	   -- return set @status=0
	 END CATCH







	
END

GO
/****** Object:  StoredProcedure [dbo].[insert_update_delete_fence]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_update_delete_fence]
	@fence_name varchar(250),
	@ULB_Id int,
	@user_Id int,
	@fence_geom varchar(max),
	@zoneId int,
	@wardId int,
	@action_status int,
	@fencelocationPK int=0,
	@userType bit,
	@imeiId int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @count int;   
	DECLARE @fenceCount int;
	BEGIN TRAN
	
	BEGIN TRY
	IF (@action_status=1)
		BEGIN
			select @count=count(*) from [garbage].[gis_dumping_grounds] where [gdg_name] = @fence_name and [gdg_ulb_id_fk] =@ULB_Id
				IF @count>0
				BEGIN
					SELECT 'failure' AS status
				END
				ELSE
				BEGIN
					insert into [garbage].[gis_dumping_grounds] (gdg_name,gdg_the_geom,gdg_zone_id,gdg_ward_id,gdg_created_date,gdg_created_by,gdg_ulb_id_fk,poi_type_details) VALUES (@fence_name,(geometry::STGeomFromText(@fence_geom, 0)),@zoneId,@wardId,getdate(),@user_Id,@ULB_Id,3)

					 SELECT max(gdg_id_pk) as fencePK, 'success' AS status from [garbage].[gis_dumping_grounds]  

				END
		END
	ELSE IF (@action_status=3)
		BEGIN
			select @count=count(*) from [scheduling].[schedule_trip_master] where [stm_end_location]=@fencelocationPK And [stm_status]=0 And [stm_status]<=1
			If(@count>0)
				BEGIN
					SELECT 'failure' AS status
				END
			ELSE
				BEGIN
					select @fenceCount=count(*) from [garbage].[gis_dumping_grounds] WHERE [gdg_id_pk]=@fencelocationPK
					IF (@fenceCount>0)
					BEGIN
						DELETE FROM [garbage].[gis_dumping_grounds] WHERE [gdg_id_pk]=@fencelocationPK
					IF(@userType=1)
						BEGIN
							IF(@imeiId=0)
								SELECT 'success' AS status
							ELSE 
								BEGIN
									update [admin].[config_rfid_reader] set		   [crd_ts_dg]=null,crd_assign_status=0 where [crd_ts_dg]=@fencelocationPK
									SELECT 'success' AS status
								END
						END
					ELSE 
						BEGIN
							DELETE FROM [admin].[config_rfid_reader] WHERE [crd_ts_dg]=@fencelocationPK
							SELECT 'success' AS status
						END
					END
					ELSE
					BEGIN 
						SELECT 'error' AS status
					END
					
				END

		END
		
	COMMIT TRAN
	--return @status
	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
		SELECT 'failure' AS status
	   -- return set @status=0
	 END CATCH

	
END

GO
/****** Object:  StoredProcedure [dbo].[insert_update_delete_road]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_update_delete_road]
	@road_name varchar(250),
	@ULB_Id int,
	@user_Id int,
	@road_fence nvarchar(max),
	@road_route nvarchar(max),
	@road_address varchar(2000),
	@zoneId int,
	@wardId int,
	@bin_Count int,
	@action_status int,
	@roadPK int=0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @count int;
	DECLARE @PKStreetId int;     
	BEGIN TRAN
	
	BEGIN TRY
	IF (@action_status=1)
		BEGIN
			select @count=count(*) from [garbage].[gis_road_area] where [gra_name] = @road_name and [gra_ulb_id_fk] =@ULB_Id
			
				IF @count>0
				BEGIN
					SELECT 'failure' AS status
				END
				ELSE
				BEGIN
					INSERT INTO [garbage].[gis_road_area] (gra_name,gra_fence,gra_route,gra_address,gra_zone_id,gra_ward_id,gra_created_date,gra_ulb_id_fk,gra_created_by,gra_points_count)
			           VALUES (@road_name, geometry::STGeomFromText(@road_fence,0),
			              geometry::STGeomFromText(@road_route,0),@road_address,@zoneId,@wardId,getdate(),@ULB_Id,@user_Id,@bin_Count)

					 SELECT 'success' AS status

				END
		END
	ELSE IF (@action_status=2)
		BEGIN
		
		select @PKStreetId=gra_id_pk from [garbage].[gis_road_area] where [gra_name] = @road_name and [gra_ulb_id_fk] =@ULB_Id

		select @count=count(*) from [garbage].[gis_road_area] where [gra_name] = @road_name and [gra_ulb_id_fk] =@ULB_Id
			
				IF @count>0 and @PKStreetId!=@roadPK
				BEGIN
					SELECT 'failure' AS status
				END
				ELSE
				BEGIN
					UPDATE [garbage].[gis_road_area] SET [gra_name] = @road_name,[gra_fence] = geometry::STGeomFromText(@road_fence,0),[gra_route] = geometry::STGeomFromText(@road_route,0),[gra_address]= @road_address,[gra_ulb_id_fk] = @ULB_Id,[gra_points_count] = @bin_Count Where gra_id_pk=@roadPK;

					SELECT 'success' AS status
				END
				 
		END
	ELSE IF (@action_status=3)
		BEGIN
			select @count=count(*) from [garbage].[route_details] inner join [garbage].[route_master] on [rd_route_id_fk]=[rm_id_pk] and [rm_type]=1 where [rd_check_point_id_fk]=@roadPK;
			IF(@count>0)
				BEGIN
					SELECT 'failure' AS status
				END
			ELSE
				BEGIN
					DELETE FROM  [garbage].[gis_road_area] WHERE [gra_id_pk]=@roadPK
					SELECT 'success' AS status
				END
		END
		
	COMMIT TRAN
	--return @status
	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
		SELECT 'error' AS status
	   -- return set @status=0
	 END CATCH







	
END

GO
/****** Object:  StoredProcedure [dbo].[insert_update_delete_route]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[insert_update_delete_route]
	@route_name varchar(250),
	@ULB_Id int,
	@user_Id int,
	@route_geom varchar(max),
	@route_fence_geom varchar(max),
	@zoneId int,
	@action_status int,
	@routePK int=0,
	@binRroad varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @count int;   
	DECLARE @fenceCount int;
	BEGIN TRAN
	
	BEGIN TRY
	IF (@action_status=1)
		BEGIN
			IF(@binRroad='bybin')
			BEGIN 
				INSERT INTO [garbage].[route_master] ([rm_route_name] ,[rm_ulb_id_fk],[rm_geom],[rm_created_date],[rm_created_by],[rm_fence_geom],[rm_type],[rm_zone_id]) 
				VALUES  (@route_name,@ULB_Id,geometry::STGeomFromText(@route_geom,0),getdate(),
				@user_Id,geometry::STGeomFromText(@route_fence_geom,0),0,@zoneId)

				SELECT max(rm_id_pk) as routePK, 'success' AS status from [garbage].[route_master] 
			END
			ELse 
				BEGIN
					INSERT INTO [garbage].[route_master] ([rm_route_name] ,[rm_ulb_id_fk],[rm_geom],[rm_created_date],[rm_created_by],[rm_fence_geom],[rm_type],[rm_zone_id]) 
				VALUES  (@route_name,@ULB_Id,geometry::STGeomFromText(@route_geom,0),getdate(),
				@user_Id,geometry::STGeomFromText(@route_fence_geom,0),1,@zoneId)

				SELECT max(rm_id_pk) as routePK, 'success' AS status from [garbage].[route_master] 
				END


		END
	ELSE IF (@action_status=3)
		BEGIN
			DELETE FROM [garbage].[route_details] WHERE [rd_route_id_fk] = @routePK
			DELETE FROM [garbage].[route_master] WHERE [rm_id_pk] = @routePK

			select 'success' AS status
		END
		
	COMMIT TRAN
	--return @status
	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
		SELECT 'failure' AS status
	   -- return set @status=0
	 END CATCH

	
END

GO
/****** Object:  StoredProcedure [dbo].[InsertAlertsToDB]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[InsertAlertsToDB] 
      
@alertTime datetime,
@uuid varchar(250),
@tenantcode varchar(350),
@alertype int,
@alertCatagory varchar(250),
@alertyPriority varchar(250),
@lat varchar(250),
@lon varchar(250),
@location varchar(250),
@vehicleLimit varchar(50),
@routeId varchar(50),
@tripId varchar(50),
@skippedId varchar(100),
@geotype varchar(100),
@event varchar(100),
@binlocid varchar(50),
@poiType varchar(20)

  
AS
BEGIN
SET NOCOUNT ON;

DECLARE @VehicleNo varchar(250);
DECLARE @VehicleId int;
DECLARE @countMac int;
DECLARE @ulbId int;
DECLARE @tripMaster int;
DECLARE @zoneID int;
DECLARE @wardID int;
DECLARE @binLOCATINID int;

DECLARE @alertName varchar(250);

if @alertype=1 or @alertype=2 or @alertype=6
begin
set @tripId='0';
end
 
if @alertype=3 
begin
set @skippedId='';
select  @countMac=count(*) from [admin].[config_bin_sensor_master] where [cbsm_mac_address]=@uuid
select @skippedId= CONVERT(varchar(10), [cbsm_bin_id]) from [admin].[config_bin_sensor_master] where [cbsm_mac_address]=@uuid
if @countMac>0
     begin
select @binLOCATINID= cbsm_bin_loc_id, @VehicleNo=cbsm_bin_name ,@location=[cbsm_location],@ulbId=[cbsm_ulb_id_fk], @zoneID=[cbsm_zone_id],@wardID=[cbsm_ward_id] from [admin].[config_bin_sensor_master] where [cbsm_mac_address]=@uuid
     end
end

if @alertype!=3 
begin
select  @countMac=count(*) from [admin].[config_fleet_master] where [macAddress]=@uuid
if @countMac>0
    begin


	
select @VehicleNo=[cfm_vehicle_no],@VehicleId=[cfm_id_pk],@ulbId=[cfm_ulb_id_fk],@zoneID=[cfm_zone_id],@wardID=[cfm_ward_id] from [admin].[config_fleet_master] where [macAddress]=@uuid

    end 
end
select @alertName=[cat_type] from [admin].[config_alert_type] where [cat_id_pk]=@alertype
if @countMac>0
      begin
	  
insert into [admin].[config_alerts_recived_log] (
       [arl_alert_type_fk]
      ,[arl_received_date_time]
      ,[arl_latitude]
      ,[arl_longitude]
	  ,[arl_alert_type]
	  ,[arl_Tenant_Code]
	  ,[arl_location]
	  ,[arl_vehicle_id_fk]
	  ,[arl_vehicle_no]
	  ,[arl_alert_priority]
	  ,[arl_uuid]
	  ,[arl_vehicle_trigger]
	  ,[arl_route_id]
	  ,[arl_trip_id]
	  ,[arl_skipped_bin]
	  ,[arl_geofence_type]
	  ,[arl_geo_event]
	  ,[arl_ulb_id_fk]
	  ,[arl_binloc_id]
	  ,[arl_geom_type]
      ) values(@alertype,@alertTime,@lat,@lon,@alertName,@tenantcode,@location,@VehicleId,@VehicleNo,@alertyPriority,@uuid,@vehicleLimit,@routeId,@tripId,@skippedId,@geotype,@event,@ulbId,@binlocid,@poiType) 
	  end

	   select @tripMaster=[tom_id_pk] from [reporting].[trip_ongoing_master] where tom_trip_id_fk=@tripId
--Checking geo fence
if @alertype=3 
begin
update [admin].[config_alerts_recived_log] set [arl_binloc_id]=@binLOCATINID  where [arl_uuid]=@uuid
end

	  if @alertype=7
	  BEGIN
		  if @poiType=2 and @geotype='OUT'
			  BEGIN
			  update [reporting].[trip_ongoing_master] set [tom_start_date_time]=CURRENT_TIMESTAMP,[tom_trip_status]=1 where tom_trip_id_fk=@tripId
			  END
		  if @poiType=1 and @geotype='IN'
			  BEGIN
			  update [reporting].[trip_ongoing_details] set tod_bin_entry_time=CURRENT_TIMESTAMP where [tod_master_id_fk]=@tripMaster and tod_bin_id_fk=@binlocid
			  END
		  if @poiType=1 and @geotype='OUT'
			  BEGIN
			  update [reporting].[trip_ongoing_details] set tod_bin_exit_time=CURRENT_TIMESTAMP where [tod_master_id_fk]=@tripMaster and tod_bin_id_fk=@binlocid
			  END
          if @poiType=5 and @geotype='IN'
		      BEGIN
			  update [reporting].[trip_ongoing_master] set [tom_end_date_time]=CURRENT_TIMESTAMP,[tom_trip_status]=2 where tom_trip_id_fk=@tripId
			  END
          if @poiType=3 and @geotype='IN'
		      BEGIN
			  update [reporting].[trip_ongoing_master] set [tom_dump_time]=CURRENT_TIMESTAMP where tom_trip_id_fk=@tripId
			  END

	  END
--Checking bin fill
     if @alertype=3
	 BEGIN
	 update [admin].[config_bin_sensor_master] set [cbsm_binStatus]=1,cbsm_bin_full_status=1,cbsm_alert_time=CURRENT_TIMESTAMP where cbsm_mac_address=@uuid
	 END     


	 --select [ulbm_id_pk] from [admin].[urban_local_body_master] where [ulbm_tenant_code]=@tenantcode

	 --select [cum_id_pk] from [admin].[config_user_master] where [cum_ulb_id_fk]=@ulbId

	-- select TOP 1 [cum_id_pk] from [admin].[config_user_master] where cum_user_type=3 and  cum_zone_id like @zoneID and cum_ward_id like @wardID and [cum_ulb_id_fk]=@ulbId



END


--select * from [admin].[config_user_master] where [cum_id_pk]=29522

--((select * from dbo.fnSplitString((select [cum_zone_id] from [admin].[config_user_master] where cum_id_pk=29523 ),',')))

GO
/****** Object:  StoredProcedure [dbo].[IoT_BinManagement_insert_update_delete]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   PROCEDURE [dbo].[IoT_BinManagement_insert_update_delete]
@sensorBin int ,
@binname varchar(50),
@bincapacity int,
@binVolume int,
@macaddress varchar(150),
@bintype int,
@bintypecode varchar(50),
@bincatrgorytypeid int,
@tenantcode varchar(50),
@zoneid varchar(50),
@wardid varchar(50),
@latitude float,
@longitude float,
@address varchar(300),
@RFIDno1 varchar(250),
@RFIDno2 varchar(250),
--@boundary text,
@areaId varchar(50),
@binidiotops varchar(50),-- for bin id --------------------------//
--@layouttypename varchar(50),
@bintypename varchar(50),
@bincategorytypecode varchar(50),
@bincategorytypename varchar(50),
@devicename varchar(50),
@olddevicemacaddress varchar(50),
@zonename varchar(50),
@wardname varchar(50),
@movableBin bit,
@action_status int
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @count int,@zonecount int ,@maccount int,@bintypecount int,@bintypeidpk int,@binPK int,@typecount int, @devicepk int,@simpk int,@fleetonmac varchar(100),@updatetypecount varchar(100),@updatetypeid int,@updatetypename varchar(100),@bincount int
 DECLARE @ulbPK int,@garbagepk int,@bincategorytypecount int ,@bincategoryPk int, @ggcflayoutid int,@maccountupdate int,@maccountdata int ,@wardcount int,@wardIDpk int,@wardzoneIDpk int,@deletebinpk int,@deletemacaddress varchar(250),@deletemaccount int
 BEGIN TRAN
 BEGIN TRY
 IF (@action_status=1)
  BEGIN
   select @ulbPK= ulbm_id_pk from [admin].[urban_local_body_master]where [ulbm_tenant_code]=@tenantCode
   select @zonecount=count(*) from [admin].[config_zone_master] where zoneUId=@zoneid and czm_ulb_id_fk=@ulbPK
   IF @zonecount=0
    BEGIN
     insert into [admin].[config_zone_master] (czm_zone_name,zoneUId,czm_ulb_id_fk) values(@zonename,@zoneid,@ulbPK)
				--SELECT 'success' AS status,'Zone added successfully' as message
    END
   select @wardzoneIDpk=czm_id_pk from [admin].[config_zone_master]  where zoneUId=@zoneid and czm_ulb_id_fk=@ulbPK	
   select @wardcount=COUNT(*) from  [admin].[config_ward_master] where wardUId=@wardid and cwm_ulb_id_fk=@ulbPK
   IF @wardcount=0
    BEGIN
     INSERT into [admin].[config_ward_master] (cwm_ward_name,wardUId,cwm_ulb_id_fk,cwm_zone_id_fk) values(@wardname,@wardid,@ulbPK,@wardzoneIDpk)
		---SELECT 'success' AS status,'ward added successfully' as message
    END
   select @wardIDpk=cwm_id_pk  from  [admin].[config_ward_master] where wardUId=@wardid and cwm_ulb_id_fk=@ulbPK
	IF @sensorBin=1--Exc if sensor bin
	BEGIN
	   select @maccountdata=count(*) from [admin].[DeviceManagementDetails] where DeviceMacaddress=@macaddress and DeviceTanentCode=@tenantcode and DeviceULbID=@ulbPK
	   IF @maccountdata=0
		BEGIN
		 INSERT into [admin].[DeviceManagementDetails] (DeviceName,DeviceMacaddress,DeviceAddress,DeviceCreatedDate,DeviceTanentCode,DeviceULbID,DeviceLatitude,DeviceLongtitude,DeviceAssignedStatus)values(@devicename,@macaddress,@address,CURRENT_TIMESTAMP,@tenantcode,@ulbPK,@latitude,@longitude,1)
		END
	   update [admin].[DeviceManagementDetails] SET DeviceAssignedStatus=1 where  DeviceMacaddress=@macaddress and DeviceTanentCode=@tenantcode and DeviceULbID=@ulbPK
	   select @devicepk=pk_DeviceID,@devicename=DeviceName from [admin].[DeviceManagementDetails] where DeviceMacaddress=@macaddress and DeviceTanentCode=@tenantcode and DeviceULbID=@ulbPK
	  -- IF @sensorBin=1
		--BEGIN
		 --update [admin].[DeviceManagementDetails] SET DeviceTypeID=7,DeviceTypeName='Bin Sensor' where DeviceMacaddress=@macaddress and DeviceTanentCode=@tenantcode and DeviceULbID=@ulbPK
		 --update [admin].[DeviceManagementDetails] SET DeviceTypeName='Bin Sensor' 
		--END
	   select @maccount=Count(*) from admin.config_bin_sensor_master where [cbsm_mac_address] = @macaddress and [cbsm_ulb_id_fk]=@ulbPK
	-- for checking if mac address is exist or not-- 
	END
   IF @maccount>0 and @sensorBin=1
    BEGIN
	 SELECT 'false' AS status,'MacAddress Already Exists' as message
	END
   Else 
    BEGIN
     --for bin type insert if bin type not exist--
     select @bintypecount=count(*) from [admin].[config_bin_type] where cbt_type_Code=@bintypecode
	 IF @bintypecount <= 0
	  BEGIN
       Insert into  [admin].[config_bin_type] (cbt_type,cbt_type_Code)values(@bintypename,@bintypecode)
	  END
     select  @bintypeidpk=cbt_id_pk from [admin].[config_bin_type] where cbt_type_Code=@bintypecode
     --for inserting bin category if bin category not exist--
	 select @bincategorytypecount=count(*) from [admin].[config_bin_category_type] where cbct_type_code=@bincategorytypecode
     IF @bincategorytypecount =0
      BEGIN
       insert into [admin].[config_bin_category_type] (cbct_type,cbct_type_code) values(@bincategorytypename,@bincategorytypecode)
      END
     select @bincategoryPk=cbct_id_pk from  [admin].[config_bin_category_type] where cbct_type_code=@bincategorytypecode
     --end of bin category--
     --check wheather layout id is exist for location --
     select @ggcflayoutid=count(*) from  [garbage].[gis_garbage_collection_points] where [bin_gis_id]=@areaId and ggcf_ulb_id_fk=@ulbPK--ggcf_layout_id=@layouttypeid
--IF @ggcflayoutid<=0
--BEGIN

--insert into  [garbage].[gis_garbage_collection_points]  (ggcf_points_name,Bin_type_id,the_fence_geom,ggcf_ulb_id_fk,ggcf_ward_id,ggcf_zone_id,ggcf_layout_id)values(@layouttypename,@bintypeidpk,geometry::STGeomFromText(@boundary, 4326),@ulbPK,@wardIDpk,@wardzoneIDpk,@layouttypeid)
--SELECT 'success' AS status,' Bin location  Added Successfully' as message
--END

	select  @garbagepk=ggcf_points_id_pk from [garbage].[gis_garbage_collection_points]  where [bin_gis_id]=@areaId and ggcf_ulb_id_fk=@ulbPK--ggcf_layout_id=@layouttypeid

	Insert INTO admin.config_bin_master (cbm_bin_loc_id,cbm_ward_id,cbm_zone_id,cbm_ulb_id_fk,cbm_created_by,cbm_bin_capacity,cbm_ulbCode,cbm_binType,cbm_bin_name,cbm_created_date,cbm_is_sensor,BinLayoutID,cbm_bin_category_type,isMovable)  values(@garbagepk,@wardIDpk,@wardzoneIDpk,@ulbPK,@ulbPK,@bincapacity,@tenantCode,@bintypeidpk,@binname,CURRENT_TIMESTAMP,@sensorBin,@binidiotops,@bincategoryPk,@movableBin)
	--select @binPK=scope_identity()
	select @binPK=cbm_id_pk from admin.config_bin_master where BinLayoutID=@binidiotops

	select @bincount=count(*) from admin.config_bin_master where cbm_bin_loc_id=@garbagepk
	update [garbage].[gis_garbage_collection_points] SET ggcf_points_count=@bincount where [ggcf_points_id_pk]=@garbagepk and ggcf_ulb_id_fk=@ulbPK
	INSERT INTO admin.config_rfid_master(crm_bin_loc_id_fk,crm_zone_id,crm_ward_id,crm_rfid_no,crm_rfid_no2,crm_rfid_type,crm_bin_id,crm_ulb_id_fk,crm_created_by,crm_created_date,crm_bin_lat,crm_bin_long,RfidBinLayoutID)values(@garbagepk,@wardzoneIDpk,@wardIDpk,@RFIDno1,@RFIDno2,0,@binPK,@ulbPK,@ulbPK,CURRENT_TIMESTAMP,@latitude,@longitude,@binidiotops)
	INSERT INTO admin.config_bin_sensor_master(cbsm_bin_loc_id,cbsm_bin_id,cbsm_ulb_id_fk,cbsm_sensor_sim_no,cbsm_bin_volume,cbsm_bin_latitude,cbsm_bin_longitude,cbsm_device_id,cbsm_created_by,cbsm_created_date,cbsm_mac_address,cbsm_ulbCode,cbsm_bin_name,sensorBinLayoutID)values(@garbagepk,@binPK,@ulbPK,@macaddress,@binVolume,@latitude,@longitude,@devicepk,@ulbPK,CURRENT_TIMESTAMP,@macaddress,@tenantCode,@binname,@binidiotops)
	SELECT 'true' AS status,' Bin Details Added Successfully' as message
   END
  END
  ELSE if (@action_status=2)
   BEGIN
    select @ulbPK= ulbm_id_pk from [admin].[urban_local_body_master] where [ulbm_tenant_code]=@tenantCode
	select @maccountdata=count(*) from [admin].[DeviceManagementDetails] where DeviceMacaddress=@olddevicemacaddress and DeviceTanentCode=@tenantcode and DeviceULbID=@ulbPK
	IF @olddevicemacaddress=@macaddress
	 BEGIN 
	  update [admin].[DeviceManagementDetails] SET DeviceAssignedStatus=1 where  DeviceMacaddress=@olddevicemacaddress and DeviceTanentCode=@tenantcode and DeviceULbID=@ulbPK
	 END
	ELSE
	 BEGIN
	  IF @maccountdata>0
       BEGIN
        update [admin].[DeviceManagementDetails] SET DeviceAssignedStatus=0 where  DeviceMacaddress=@olddevicemacaddress and DeviceTanentCode=@tenantcode and DeviceULbID=@ulbPK
        INSERT into [admin].[DeviceManagementDetails] (DeviceName,DeviceMacaddress,DeviceAddress,DeviceCreatedDate,DeviceTanentCode,DeviceULbID,DeviceLatitude,DeviceLongtitude,DeviceAssignedStatus)values(@devicename,@macaddress,@address,CURRENT_TIMESTAMP,@tenantcode,@ulbPK,@latitude,@longitude,1)
       END
      END

	select @maccountupdate=Count(*) from admin.config_bin_sensor_master where [cbsm_mac_address] = @olddevicemacaddress 
	
	if @maccountupdate>0
    BEGIN
	
	 --------------------------------for bin type insert if bin type not exist----------------------------------------------------------------
  select @bintypecount=count(*) from [admin].[config_bin_type] where cbt_type_Code=@bintypecode
  
	 IF @bintypecount = 0
	  BEGIN
    Insert into  [admin].[config_bin_type] (cbt_type,cbt_type_Code)values(@bintypename,@bintypecode)
END

select  @bintypeidpk=cbt_id_pk from [admin].[config_bin_type] where cbt_type_Code=@bintypecode

-----------------------------for inserting bin category if bin category not exist----------------------------------------------------
 select @bincategorytypecount=count(*) from [admin].[config_bin_category_type] where cbct_type_code=@bincategorytypecode
 
 IF @bincategorytypecount =0
 BEGIN
  
 insert into [admin].[config_bin_category_type] (cbct_type,cbct_type_code) values(@bincategorytypename,@bincategorytypecode)
 END

 select @bincategoryPk=cbct_id_pk from  [admin].[config_bin_category_type] where cbct_type_code=@bincategorytypecode


 select @zonecount=count(*) from [admin].[config_zone_master] where zoneUId=@zoneid and czm_ulb_id_fk=@ulbPK

 	IF @zonecount=0
		BEGIN
		insert into [admin].[config_zone_master] (czm_zone_name,zoneUId,czm_ulb_id_fk) values(@zonename,@zoneid,@ulbPK)
		--SELECT 'success' AS status,'Zone added successfully' as message
		END

		select @wardzoneIDpk=czm_id_pk from [admin].[config_zone_master]  where zoneUId=@zoneid and czm_ulb_id_fk=@ulbPK
			
		select @wardcount=COUNT(*) from  [admin].[config_ward_master] where wardUId=@wardid and cwm_ulb_id_fk=@ulbPK
		IF @wardcount=0
		BEGIN
		INSERT into [admin].[config_ward_master] (cwm_ward_name,wardUId,cwm_ulb_id_fk,cwm_zone_id_fk) values(@wardname,@wardid,@ulbPK,@wardzoneIDpk)
		---SELECT 'success' AS status,'ward added successfully' as message
		END
	select @wardIDpk=cwm_id_pk  from  [admin].[config_ward_master] where wardUId=@WardID and cwm_ulb_id_fk=@ulbPK
	

 ----------------------------for location exist or not ---------------------------------------
select @ggcflayoutid=count(*) from  [garbage].[gis_garbage_collection_points] where [bin_gis_id]=@areaId and ggcf_ulb_id_fk=@ulbPK--ggcf_layout_id=@layouttypeid

--IF @ggcflayoutid<=0
--BEGIN

--insert into  [garbage].[gis_garbage_collection_points]  (ggcf_points_name,the_fence_geom,ggcf_ulb_id_fk,ggcf_ward_id,ggcf_zone_id,ggcf_layout_id)values(@layouttypename,geometry::STGeomFromText(@boundary, 4326),@ulbPK,@wardIDpk,@wardzoneIDpk,@layouttypeid)
--SELECT 'success' AS status,' Bin location  Added Successfully' as message
--END

select @garbagepk=ggcf_points_id_pk from  [garbage].[gis_garbage_collection_points] where [bin_gis_id]=@areaId  and ggcf_ulb_id_fk=@ulbPK--ggcf_layout_id=@layouttypeid
update  admin.config_bin_master SET cbm_bin_loc_id=@garbagepk,cbm_ward_id=@wardIDpk,cbm_zone_id=@wardzoneIDpk,cbm_bin_capacity=@bincapacity,cbm_binType=@bintypeidpk,cbm_bin_name=@binname,cbm_is_sensor=@sensorBin,cbm_bin_category_type=@bincategoryPk,isMovable=@movableBin where BinLayoutID=@binidiotops and cbm_ulbCode=@tenantCode and cbm_ulb_id_fk=@ulbPK
select @binPK=cbm_id_pk from  admin.config_bin_master where  BinLayoutID=@binidiotops 
update admin.config_rfid_master SET crm_bin_loc_id_fk=@garbagepk,crm_zone_id=@wardzoneIDpk,crm_ward_id=@wardIDpk,crm_rfid_no=@RFIDno1,crm_rfid_no2=@RFIDno2,crm_rfid_type=0,crm_bin_id=@binPK,crm_bin_lat=@latitude,crm_bin_long=@longitude where RfidBinLayoutID=@binidiotops and crm_ulb_id_fk=@ulbPK
update admin.config_bin_sensor_master SET cbsm_bin_loc_id=@garbagepk,cbsm_bin_id=@binPK,cbsm_sensor_sim_no=@macaddress,cbsm_bin_volume=@binVolume,cbsm_bin_latitude=@latitude,cbsm_bin_longitude=@longitude,cbsm_device_id=@devicepk,cbsm_mac_address=@macaddress,cbsm_bin_name=@binname where cbsm_ulb_id_fk=@ulbPK and cbsm_ulbCode=@tenantcode and sensorBinLayoutID=@binidiotops
SELECT 'true' AS status,' Bin Details Updated Successfully' as message
	END
	END
	ELSE IF (@action_status=3)
	BEGIN
	 select @ulbPK= ulbm_id_pk from [admin].[urban_local_body_master] where [ulbm_tenant_code]=@tenantCode
	--Delete from  [garbage].[gis_garbage_collection_points] where ggcf_layout_id=@layouttypeid
select @deletebinpk=cbm_id_pk,@garbagepk=cbm_bin_loc_id from admin.config_bin_master  where BinLayoutID=@binidiotops
 select @deletemacaddress=cbsm_mac_address from admin.config_bin_sensor_master where cbsm_bin_id=@deletebinpk

 select @deletemaccount=count(*) from  [admin].[DeviceManagementDetails] where DeviceMacaddress=@deletemacaddress
 IF @deletemaccount=0
 BEGIN
 SELECT 'false' AS status,' Mac Address doesnot exists' as message
 END
 ELSE
 BEGIN

 update [admin].[DeviceManagementDetails] SET DeviceAssignedStatus=0 where  DeviceMacaddress=@deletemacaddress and DeviceTanentCode=@tenantcode and DeviceULbID=@ulbPK
 Delete from admin.config_bin_master where BinLayoutID=@binidiotops and cbm_ulbCode=@tenantCode and cbm_ulb_id_fk=@ulbPK
	Delete from admin.config_rfid_master where RfidBinLayoutID=@binidiotops and crm_ulb_id_fk=@ulbPK
	Delete from admin.config_bin_sensor_master where cbsm_ulb_id_fk=@ulbPK and cbsm_ulbCode=@tenantcode and sensorBinLayoutID=@binidiotops
	 select @bincount=count(*) from admin.config_bin_master where cbm_bin_loc_id=@garbagepk
update [garbage].[gis_garbage_collection_points] SET ggcf_points_count=@bincount where [ggcf_points_id_pk]=@garbagepk and ggcf_ulb_id_fk=@ulbPK
	SELECT 'true' AS status,' Bin Details Deleted Successfully' as message

 END

	
	END
		
	COMMIT TRAN

	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
		SELECT 'false' AS status,ERROR_MESSAGE() AS message
	   
	 END CATCH

	
END

GO
/****** Object:  StoredProcedure [dbo].[IoT_DeviceManagement_insert_update_delete]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[IoT_DeviceManagement_insert_update_delete]
@iotopsDeviceid varchar(50),
@Devicename varchar(100),
@Devicemacaddress varchar(100),
@DeviceTypeID int,
@DeviceTypeName varchar(100),
@DeviceCreatedDatetime Datetime,
@DeviceUpdatedDatetime Datetime,
@DeviceTenantCode varchar(50),
@DeviceZoneID varchar(50),
@DeviceWardID varchar(50),
@DeviceLatitude float,
@DeviceLongitude float,
@DeviceAddress varchar(250),
@DeviceZoneName varchar(50),
@DeviceWardName varchar(50),
@DeviceWardNumber int,
@action_status int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @zonecount int,@zoneIDpk int ,@wardcount int,@wardIDpk int,@iotopsIDcount int,@deletedeviceid int,@deletedeviceIDPK int,@Deviceassignedstatus int
	DECLARE @ulbPK int,@macaddress varchar(50),@RFIDReader int
	BEGIN TRAN
	
	BEGIN TRY
	select @ulbPK= ulbm_id_pk from [admin].[urban_local_body_master] where [ulbm_tenant_code]=@DeviceTenantCode
	
		

	IF (@action_status=1)
		BEGIN
	
		select @zonecount=Count(*) from [admin].[config_zone_master] where zoneUId=@DeviceZoneID and czm_ulb_id_fk=@ulbPK
		IF @zonecount=0
		BEGIN
		
		INSERT INTO  [admin].[config_zone_master](czm_zone_name,czm_ulb_id_fk,zoneUId)values(@DeviceZoneName,@ulbPK,@DeviceZoneID)
		END
		
		SELECT @zoneIDpk=czm_id_pk from  [admin].[config_zone_master] where zoneUId=@DeviceZoneID and czm_ulb_id_fk=@ulbPK
		
		select @wardcount=COUNT(*) from  [admin].[config_ward_master] where wardUId=@DeviceWardID and cwm_ulb_id_fk=@ulbPK
		IF @wardcount=0
		BEGIN
		
		INSERT INTO [admin].[config_ward_master] (cwm_ward_name,cwm_zone_id_fk,cwm_ulb_id_fk,cwm_ward_number,wardUId)values(@DeviceWardName,@zoneIDpk,@ulbPK,@DeviceWardNumber,@DeviceWardID)
		END
		
		select @wardIDpk=cwm_id_pk from  [admin].[config_ward_master] where wardUId=@DeviceWardID and cwm_ulb_id_fk=@ulbPK

		select @macaddress=count(*) from [admin].[DeviceManagementDetails] where [DeviceMacaddress]=@Devicemacaddress and [DeviceULbID]=@ulbPK

		IF @macaddress>0
		BEGIN
		SELECT 'false' AS status,'Macaddress Already Exists Please Try With Another' as message
		END
		ELse 
		BEGIN
		INSERT INTO [admin].[DeviceManagementDetails]([DeviceIotOpsID],[DeviceName],[DeviceMacaddress],[DeviceTypeID],[DeviceTypeName],[DeviceCreatedDate],[DeviceUpdatedDate],[DeviceTanentCode],[DeviceULbID],[DeviceZoneID],[DeviceWardID],[DeviceLatitude],[DeviceLongtitude],[DeviceAddress])
		values(@iotopsDeviceid,@Devicename,@Devicemacaddress,@DeviceTypeID,@DeviceTypeName,@DeviceCreatedDatetime,@DeviceUpdatedDatetime,@DeviceTenantCode,@ulbPK,@zoneIDpk,@wardIDpk,@DeviceLatitude,@DeviceLongitude,@DeviceAddress)
		IF @DeviceTypeID=35--weighbridge
		BEGIN
			insert into [admin].[config_rfid_reader] ([crd_imei_no],[crd_ulb_id],[crd_ulb_code],[crd_assign_status],[crd_device_name]) values (@Devicemacaddress,@ulbPK,@DeviceTenantCode,0,@Devicename)
		END
		IF @DeviceTypeID=36--MDT device
		BEGIN
			INSERT INTO [admin].[config_sim_master] (csm_sim_no,csm_created_date,csm_status,csm_ulb_id_fk,macAddress,csm_device_type,csm_device_no,deviceName,csm_ulb_code,FK_ZoneId,FK_WardId,latitude,longitude,csm_iotops_id,isGPS)
			values (@Devicemacaddress,@DeviceCreatedDatetime,0,@ulbPK,@Devicemacaddress,@DeviceTypeName,@DeviceTypeID,@Devicename,@DeviceTenantCode,@zoneIDpk,@wardIDpk,@DeviceLatitude,@DeviceLongitude,@iotopsDeviceid,0)
		END
		SELECT 'true' AS status,'DEVICE Added Successfully!' as message
		END
		
		END
	ELSE IF (@action_status=2)
		BEGIN
			select @iotopsIDcount=Count(*)from [admin].[DeviceManagementDetails] where [DeviceIotOpsID]=@iotopsDeviceid and [DeviceMacaddress]=@Devicemacaddress
			select @zonecount=Count(*) from [admin].[config_zone_master] where zoneUId=@DeviceZoneID and czm_ulb_id_fk=@ulbPK
		IF @zonecount=0
		BEGIN
	
		INSERT INTO  [admin].[config_zone_master](czm_zone_name,czm_ulb_id_fk,zoneUId)values(@DeviceZoneName,@ulbPK,@DeviceZoneID)
		END
		ELSE 
		BEGIN
		update [admin].[config_zone_master] SET czm_zone_name=@DeviceZoneName where zoneUId=@DeviceZoneID and czm_ulb_id_fk=@ulbPK
		END
		select @wardcount=COUNT(*) from  [admin].[config_ward_master] where wardUId=@DeviceWardID and cwm_ulb_id_fk=@ulbPK
		IF @wardcount=0
		BEGIN
		
		INSERT INTO [admin].[config_ward_master] (cwm_ward_name,cwm_zone_id_fk,cwm_ulb_id_fk,cwm_ward_number,wardUId)values(@DeviceWardName,@zoneIDpk,@ulbPK,@DeviceWardNumber,@DeviceWardID)
		END
		ELSE
		BEGIN 
		update [admin].[config_ward_master] SET cwm_ward_name=@DeviceWardName where wardUId=@DeviceWardID and cwm_ulb_id_fk=@ulbPK
		END
			IF @iotopsIDcount=0
			BEGIN
				SELECT 'false' AS status,'DEVICE DOSE Not EXISTs' as message
			
			END
			ELSE
			BEGIN
			UPDATE [admin].[DeviceManagementDetails] SET [DeviceName]=@Devicename,[DeviceTypeID]=@DeviceTypeID,[DeviceTypeName]=@DeviceTypeName,[DeviceUpdatedDate]=@DeviceUpdatedDatetime,[DeviceAddress]=@DeviceAddress,[DeviceLatitude]=@DeviceLatitude,[DeviceLongtitude]=@DeviceLongitude  where [DeviceIotOpsID]=@iotopsDeviceid and [DeviceMacaddress]=@Devicemacaddress
			IF @DeviceTypeID=35
			BEGIN
				UPDATE [admin].[config_rfid_reader] set [crd_ulb_id]=@ulbPK,[crd_ulb_code]=@DeviceTenantCode,[crd_device_name]=@Devicename where [crd_imei_no]=@Devicemacaddress
			END
			IF @DeviceTypeID=36
			BEGIN
				UPDATE [admin].[config_sim_master] set deviceName=@Devicename,csm_device_no=@DeviceTypeID,csm_device_type=@DeviceTypeName,csm_modified_date=@DeviceUpdatedDatetime,address=@DeviceAddress,latitude=@DeviceLatitude,longitude=@DeviceLongitude  where csm_iotops_id=@iotopsDeviceid and csm_sim_no=@Devicemacaddress and macAddress=@Devicemacaddress and isGPS=0
			END
			SELECT 'true' AS status,'DEVICE Updated Successfully' as message
			END
				 
		END
		ELSE IF (@action_status=3)
		BEGIN
			select @deletedeviceid=Count(*)from [admin].[DeviceManagementDetails] where [DeviceMacaddress]=@Devicemacaddress
			select @deletedeviceIDPK=[pk_DeviceID],@Deviceassignedstatus=DeviceAssignedStatus from [admin].[DeviceManagementDetails]where  [DeviceMacaddress]=@Devicemacaddress

			IF @deletedeviceid>0 and @Deviceassignedstatus=0
			BEGIN
			Delete  from [admin].[DeviceManagementDetails] where [pk_DeviceID]=@deletedeviceIDPK
			--Weigh Bridge delete from config_rfid_reader
			select @RFIDReader = count(*) from [admin].[config_rfid_reader] where [crd_imei_no]=@Devicemacaddress
			IF @RFIDReader>0
			BEGIN
				DELETE FROM [admin].[config_rfid_reader] where [crd_imei_no]=@Devicemacaddress
			END
			
			SELECT 'true' AS status,' Device Deleted successfully' as message
			END
			ELSE
			BEGIN
			SELECT 'false' AS status,'Please UnAssign The Device To Delete' as message
			
			END
			

		END


	COMMIT TRAN

	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
		SELECT 'false' AS status,ERROR_MESSAGE() AS message
	   
	 END CATCH

	
END

GO
/****** Object:  StoredProcedure [dbo].[IoT_fleetManagement_insert_update_delete]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[IoT_fleetManagement_insert_update_delete]
@iotopsfleetid varchar(50),
@fleetname varchar(100),
@chassisNo varchar(100),
@engineNo varchar(100),
@milage int,
@iotopsvehicletypeid int,
@iotvehicletypecode varchar(100),
@iotvehicletype varchar(100) ,
@tenantCode varchar(50),
@macaddress varchar(50),
@gatewayid int,
@model varchar(100),
@rfidno varchar(50),
@rfidno2 varchar(50),
@fleetavaliablestatus int,
@wardID varchar(100),
@fleetcapacity int,
@fuelcapacity int,
@deviceno int,
@devicetype varchar(50),
@devicetypecode varchar(50),
@latitude float,
@longitude float,
@isGPS Bit,
@action_status int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @count int,@typecount int,@fleetpk int,@simpk int,@fleetonmac varchar(100),@updatetypecount varchar(100),@updatetypeid int,@updatetypename varchar(100),@simcount int
	DECLARE @ulbPK int, @deletevehid int,@deletevehsimno varchar(100)  ,@deletecount int,@maccount int,@typepk int,@wardcount int,@wardIDpk int,@wardzineIDpk int,@countmac int,@maclon float,@maclat float
	BEGIN TRAN
	
	BEGIN TRY
	select @ulbPK= ulbm_id_pk from [admin].[urban_local_body_master] where [ulbm_tenant_code]=@tenantCode
	


	IF (@action_status=1)
		BEGIN
				select @typecount=Count(*) from [admin].[config_fleet_category] where cfc_type_code=@iotvehicletypecode
				IF @typecount=0
				BEGIN
					
					INSERT INTO [admin].[config_fleet_category](cfc_type,cfc_type_code,cfc_ulb_id_fk,cfc_mileage,cfc_iottype_id)values(@iotvehicletype,@iotvehicletypecode,@ulbPK,0,@iotopsvehicletypeid)
					--select 'Vehicle Type ADD Successfully' as message
				END
		
		select @wardcount=COUNT(*) from  [admin].[config_ward_master] where wardUId=@WardID and cwm_ulb_id_fk=@ulbPK
		IF @wardcount<>0
		
		BEGIN
		select @wardIDpk=cwm_id_pk ,@wardzineIDpk=cwm_zone_id_fk from  [admin].[config_ward_master] where wardUId=@WardID and cwm_ulb_id_fk=@ulbPK
		--INSERT INTO [admin].[config_ward_master] (cwm_ward_name,cwm_ulb_id_fk,cwm_iot_id)values(@WardName,@ulbPK,@WardID)
		END
		
		select @simcount=Count(*) from  [admin].[config_sim_master] where csm_sim_no=@macaddress and csm_ulb_id_fk=@ulbPK
		IF @simcount=0
		BEGIN
		INSERT INTO [admin].[config_sim_master] (csm_sim_no,csm_created_date,csm_status,csm_ulb_id_fk,macAddress,csm_device_type,csm_device_no,csm_ulb_code,FK_ZoneId,FK_WardId,latitude,longitude,csm_iotops_id,isGPS)values(@macaddress,CURRENT_TIMESTAMP,0,@ulbPK,@macaddress,@devicetype,@deviceno,@tenantCode,@wardzineIDpk,@wardIDpk,@latitude,@longitude,@gatewayid,@isGPS)
		END
		select @maclat=latitude,@maclon=longitude from [admin].[config_sim_master] where  csm_sim_no=@macaddress

			select @count=COUNT(*)  from admin.config_fleet_master where cfm_vehicle_no=@fleetname and cfm_ulb_id_fk=@ulbPK
			select @countmac=COUNT(*)  from admin.config_fleet_master where  macAddress=@macaddress and cfm_ulb_id_fk=@ulbPK
			IF @count>0
				BEGIN
					
					SELECT 'false' AS status,'Vehicle Already Exist' as message
				END
				ELSE IF @countmac>0
				BEGIN
				SELECT 'false' AS status,'MAcAddress Already Exist' as message
				END
				ELSE
				BEGIN
         select @typepk=cfc_id_pk from [admin].[config_fleet_category] where cfc_type_code=@iotvehicletypecode
			         INSERT INTO admin.config_fleet_master(IotOpsID,cfm_vehicle_no,cfm_chassis_no,cfm_engine_no,cfm_mileage,cfm_ulb_code,macAddress,cfm_model_no,cfm_vehicle_type_id_fk,cfm_sim_no,cfm_ulb_id_fk,cfm_rfid_number,cfm_rfid_number_2,cfm_vehicle_available_status,cfm_ward_id,cfm_zone_id,cfm_fleet_capacity,cfm_fuel_capacity)
					 values(@iotopsfleetid,@fleetname,@chassisNo,@engineNo,@milage,@tenantCode,@macaddress,@model,@typepk,@macaddress,@ulbPK,@rfidno,@rfidno2,1,@wardIDpk,@wardzineIDpk,@fleetcapacity,@fuelcapacity)
					 select @fleetpk=cfm_id_pk from admin.config_fleet_master where IotOpsID=@iotopsfleetid
					 select @simpk=csm_id_pk from  [admin].config_sim_master where csm_iotops_id=@gatewayid
					update  [admin].[config_sim_master] SET csm_status=1 where macAddress=@macaddress and csm_ulb_id_fk=@ulbPK
					 INSERT INTO admin.config_online_master(com_fleet_id,com_sim_id,com_fleet_name,com_sim_no,com_assigned_by,com_assigned_date,com_ulb_id_fk)values(@fleetpk,@simpk,@fleetname,@macaddress,@ulbPK,CURRENT_TIMESTAMP,@ulbPK)
					INSERT INTO reports.vehicle_maintenance_report(vmr_vehicle_id_fk,vmr_ulb_id_fk)  values(@fleetpk,@ulbPK)
					INSERT INTO dbo.view_online_master(vom_vehicle_id,vom_sim_no,vom_status,vom_ulb_id,vom_vehicle_No,vom_received_date_time,vom_batterystatus,vom_gpsstatus,vom_vehicle_type,vom_latitude,vom_longitude,isGPS)values(@fleetpk,@macaddress,2,@ulbPK,@fleetname,CURRENT_TIMESTAMP,0,0,@iotvehicletype,@maclat,@maclon,@isGPS)
					
						update [admin].[DeviceManagementDetails] set DeviceAssignedStatus=1 where DeviceMacaddress=@macaddress
					
					SELECT 'true' AS status,'Fleet Details ADDED Successfully' as message
				END
				
		END
	

	ELSE IF (@action_status=2)
		BEGIN
			select @count=count(*) from admin.config_fleet_master where cfm_sim_no=@macaddress and cfm_ulb_id_fk=@ulbPK


			select @wardcount=COUNT(*) from  [admin].[config_ward_master] where wardUId=@WardID and cwm_ulb_id_fk=@ulbPK
		IF @wardcount<>0
		
		BEGIN
		select @wardIDpk=cwm_id_pk ,@wardzineIDpk=cwm_zone_id_fk from  [admin].[config_ward_master] where wardUId=@WardID and cwm_ulb_id_fk=@ulbPK
		--INSERT INTO [admin].[config_ward_master] (cwm_ward_name,cwm_ulb_id_fk,cwm_iot_id)values(@WardName,@ulbPK,@WardID)
		END
			IF @count<=0
				BEGIN
					SELECT 'false' AS status,'Macadress Doesnot Exist' as message
				END 
			ELSE
				BEGIN
			    select @fleetonmac=cfm_vehicle_no from  admin.config_fleet_master where cfm_sim_no=@macaddress and cfm_ulb_id_fk=@ulbPK
				select @updatetypecount=count(*) from [admin].[config_fleet_category] where [cfc_type_code]=@iotvehicletypecode
				IF @updatetypecount>0
				BEGIN
				select @updatetypeid=[cfc_id_pk],@updatetypename=[cfc_type]  from [admin].[config_fleet_category] where [cfc_type_code]=@iotvehicletypecode
				update admin.config_fleet_master set cfm_chassis_no=@chassisNo,cfm_engine_no=@engineNo,cfm_model_no=@model,cfm_vehicle_type_id_fk=@updatetypeid,cfm_vehicle_no=@fleetname,cfm_rfid_number=@rfidno,cfm_rfid_number_2=@rfidno2,cfm_ward_id=@wardIDpk,cfm_zone_id=@wardzineIDpk,cfm_fleet_capacity=@fleetcapacity,cfm_fuel_capacity=@fuelcapacity where cfm_sim_no=@macaddress and cfm_ulb_id_fk=@ulbPK
				update dbo.view_online_master set vom_vehicle_No=@fleetname,vom_vehicle_type=@updatetypename where vom_sim_no=@macaddress and vom_ulb_id=@ulbPK
				SELECT 'true' AS status,'FLEET DETAILS UPDATED SUCCESSFULLY' as message
				END;
				ELSE
				BEGIN
			     INSERT INTO [admin].[config_fleet_category](cfc_type,cfc_type_code,cfc_ulb_id_fk,cfc_mileage,cfc_iottype_id)values(@iotvehicletype,@iotvehicletypecode,0,0,@iotopsvehicletypeid)
				END;
					

					
				END
			
				 
		END
	ELSE IF (@action_status=3)
		BEGIN
			
		select @deletevehid=cfm_id_pk,@deletevehsimno=cfm_sim_no from admin.config_fleet_master where IotOpsID=@iotopsfleetid

			select @deletecount=count(*) from [reporting].[trip_ongoing_master] where [tom_vehicle_id_fk]=@deletevehid and tom_trip_status in (0,1)
			select @maccount=count(*) from admin.config_fleet_master where cfm_sim_no=@deletevehsimno and cfm_id_pk=@deletevehid



			  

			IF @maccount>0
			BEGIN
			IF @deletecount>0
				BEGIN 
					SELECT 'false' AS status,'Vehicle is assigned for the trip' as message
				END
				ELSE
				BEGIN
					DELETE FROM admin.config_online_master WHERE com_fleet_id=@deletevehid
					DELETE FROM dbo.view_online_master WHERE vom_vehicle_id=@deletevehid
					DELETE FROM reports.vehicle_maintenance_report WHERE vmr_vehicle_id_fk=@deletevehid
					Delete from admin.config_fleet_master where cfm_id_pk=@deletevehid
					update  [admin].[config_sim_master] SET csm_status=0 where csm_sim_no=@deletevehsimno
					
					update [admin].[DeviceManagementDetails] set DeviceAssignedStatus=0 where DeviceMacaddress=@deletevehsimno
					
					SELECT 'true' AS status,'Vehicle Details Deleted Successfully' as message
				END
				END;
				ELSE
				BEGIN
				SELECT 'false' AS status,'Vehicle number and Mac Address Not Available' as message
				END;
		END
		
	COMMIT TRAN

	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
		SELECT 'false' AS status,ERROR_MESSAGE() AS message
	   
	 END CATCH

	
END
GO
/****** Object:  StoredProcedure [dbo].[IoT_fleetManagement_unassign_fleet]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[IoT_fleetManagement_unassign_fleet]

@FLEETID VARCHAR(500),
@COMPANYID int,
@COMPANYCODE VARCHAR(100)
	
AS
	SET NOCOUNT ON;
	BEGIN TRAN
	BEGIN TRY

	DECLARE @VEHICLED int;
	DECLARE @VEHICLENO VARCHAR(50);
	DECLARE @SIMNO VARCHAR(50);
	DECLARE @COUNT int;

		-- GET VEH NO, VEH ID AND SIM DETAILS FOR THE GIVEN FLEET ID AND CHECKING FOR THAT FLEET IN TRIP FOR TODAY.
		SELECT @VEHICLED= cfm_id_pk, @VEHICLENO = cfm_vehicle_no, @SIMNO = cfm_sim_no 
		FROM admin.config_fleet_master WHERE IotOpsID = @FLEETID;

		-- tom_trip_status 0 - pending ; tom_trip_status 1 - ongoing;
		SELECT @COUNT = COUNT(*) FROM reporting.trip_ongoing_master 
		WHERE tom_vehicle_id_fk = @VEHICLED AND tom_trip_status IN (0,1) AND 
		CONVERT(DATE,tom_trip_schedule_date_time) = CONVERT(DATE,GETDATE());

		IF(@COUNT = 0)
			BEGIN
			print ' inside IF'
			SET IDENTITY_INSERT admin.unassigned_fleet_details ON;
			
			INSERT INTO admin.unassigned_fleet_details(cfm_id_pk,cfm_vehicle_no,cfm_model_no,
			cfm_purchase_date,cfm_year_of_making,cfm_engine_no,cfm_chassis_no,cfm_vehicle_type_id_fk,
			cfm_fuel_capacity,cfm_ulb_id_fk,cfm_register_date,cfm_vehicle_available_status,cfm_fc_date,
			cfm_contract_end_date,cfm_puc_date,cfm_created_by,cfm_modified_by,cfm_created_date,
			cfm_modified_date,cfm_sim_no,cfm_contractor_name,cfm_mobile_no,cfm_shift_type,gcm_reg_id,
			cfm_maintenance_status,cfm_mileage,cfm_zone_id,cfm_fleet_capacity,cfm_start_location,
			cfm_rfid_number,cfm_driver_id,cfm_rfid_number_2,cfm_ward_id,cfm_ulb_code,macAddress,
			cfm_iotops_id,IotOpsID)	SELECT * FROM admin.config_fleet_master WHERE cfm_id_pk = @VEHICLED;

			SET IDENTITY_INSERT admin.unassigned_fleet_details OFF;

			UPDATE admin.config_sim_master SET csm_status = 0 WHERE csm_sim_no = @SIMNO;

			UPDATE admin.DeviceManagementDetails SET DeviceAssignedStatus = 0 WHERE DeviceMacaddress = @SIMNO;

			DELETE FROM dbo.view_online_master WHERE vom_vehicle_id = @VEHICLED;

			DELETE FROM admin.config_online_master WHERE com_fleet_id = @VEHICLED;

			DELETE FROM reports.vehicle_maintenance_report WHERE vmr_vehicle_id_fk = @VEHICLED;

			DELETE FROM admin.config_fleet_master WHERE cfm_id_pk = @VEHICLED;

			SELECT 'true' AS status, 'Action completes' AS message
		END
		ELSE
			BEGIN
				SELECT 'false' AS status, 'Vehicle Already In Trip' AS message
			END
	COMMIT TRAN
	 
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
			SELECT 'false' AS status, ERROR_MESSAGE() AS message
	END CATCH

GO
/****** Object:  StoredProcedure [dbo].[IoT_gateway_insert_update_delete]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[IoT_gateway_insert_update_delete]
	@macaddress varchar(50),
	@deviceType varchar(50),
	@deviceName varchar(100),
	@deviceTypeId int,
	@createdDate datetime,
	@tenantCode varchar(50),
	@zoneId varchar(50),
	@wardId varchar(50),
	@latitude float,
	@longitude float,
	@address varchar(2000),
	@IoTOpsId int,
	@action_status int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @count int,@simstatus int
	DECLARE @zonePK int,@wardPK int,@ulbPK int;   
	BEGIN TRAN
	
	BEGIN TRY
	select @ulbPK= ulbm_id_pk from [admin].[urban_local_body_master] where [ulbm_tenant_code]=@tenantCode
	select @zonePK = czm_id_pk from [admin].[config_zone_master] where zoneUId=@zoneId
	select @wardPK = cwm_id_pk from admin.config_ward_master where wardUId=@wardId
	
	IF (@action_status=1)
		BEGIN
			select @count=count(*) from admin.config_sim_master where csm_sim_no = @macaddress and csm_ulb_id_fk=@ulbPK
			
				IF @count>0
				BEGIN
					SELECT 'false' AS status,'Macadress Already Exist' as message
					
				END
				ELSE
				BEGIN
					INSERT INTO admin.config_sim_master (csm_sim_no,[csm_status],[csm_ulb_id_fk],[csm_created_date],[macAddress],[deviceName],[csm_device_type],[csm_device_no],[csm_ulb_code],[FK_ZoneId],[FK_WardId],[latitude],[longitude],[address],[csm_iotops_id]) values (@macaddress,0,@ulbPK,@createdDate,@macaddress,@deviceType,@deviceName,@deviceTypeId,@tenantCode,@zonePK,@wardPK,@latitude,@longitude,@address,@IoTOpsId)

					 SELECT 'true' AS status,'Gateway Added successfully' as message
					 
				END
		END
	ELSE IF (@action_status=2)
		BEGIN
			select @count=count(*) from admin.config_sim_master where csm_sim_no = @macaddress and csm_ulb_id_fk=@ulbPK
			
			IF @count<=0
				BEGIN
					SELECT 'false' AS status,'Macadress Doesnot Exist' as message
				END
				ELSE
				BEGIN
					UPDATE admin.config_sim_master SET [csm_ulb_id_fk] = @ulbPK,[csm_modified_date] = @createdDate,[deviceName]= @deviceType,csm_device_type=@deviceName,[csm_device_no] = @deviceTypeId,[csm_ulb_code] = @tenantCode, [FK_ZoneId]=@zonePK,[FK_WardId]=@wardPK,[latitude]=@latitude,[longitude]=@longitude,[address]=@address Where csm_sim_no=@macaddress;

					SELECT 'true' AS status,'Gateway Updated successfully' as message
				END
			
				 
		END
	ELSE IF (@action_status=3)
		BEGIN
			
			select @count=count(*) from admin.config_sim_master where csm_sim_no = @macaddress and csm_ulb_id_fk=@ulbPK
			select @simstatus=csm_status from admin.config_sim_master where csm_sim_no = @macaddress and csm_ulb_id_fk=@ulbPK

			IF @simstatus=1
			BEGIN
			SELECT 'false' AS status,'Macadress is Assigned PLease Unassign before delete' as message
			END
			ELSE IF @count<=0
				BEGIN
					SELECT 'false' AS status,'Macadress Doesnot Exist' as message
				END
				ELSE
				BEGIN
					DELETE FROM admin.config_sim_master WHERE csm_sim_no=@macaddress and csm_ulb_id_fk=@ulbPK;

					SELECT 'true' AS status,'Gateway Deleted successfully' as message
				END
		END
		
	COMMIT TRAN
	--return @status
	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
		SELECT 'false' AS status,ERROR_MESSAGE() AS message
	   -- return set @status=0
	 END CATCH

	
END

GO
/****** Object:  StoredProcedure [dbo].[live_tracking_status]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[live_tracking_status]
    
AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @temp_onlinetab table(rowID INT IDENTITY(1,1),ot_vehicle_id int,ot_sim_card_no nvarchar(100),ot_vehicle_no nvarchar(50), ot_utc_date_time datetime, ot_status int,ot_placename nvarchar(500));
	DECLARE @RowCount INT;
	DECLARE @macaddress nvarchar(100);

	INSERT INTO @temp_onlinetab(ot_vehicle_id,ot_sim_card_no,ot_vehicle_no,ot_utc_date_time,ot_status,ot_placename)
	SELECT  vom_vehicle_id,vom_sim_no,vom_vehicle_No, vom_utc_date_time,vom_status,vom_placename
	from view_online_master where DATEDIFF(MINUTE, vom_received_date_time, getdate()) >60 and vom_status not in(2,3,5,6);

	SET @RowCount = (SELECT COUNT(rowID) FROM @temp_onlinetab);

	PRINT @RowCount;

	DECLARE @I INT
	SET @I = 1
	WHILE (@I <= @RowCount)
		BEGIN
		
		select @macaddress=ot_sim_card_no from @temp_onlinetab where rowID=@I;
		print @macaddress;
				UPDATE view_online_master SET vom_status=2 where vom_sim_no = @macaddress;

			SET @I = @I  + 1;
		END 

    


END;

GO
/****** Object:  StoredProcedure [dbo].[staffAttendenceForSupevisior]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[staffAttendenceForSupevisior]

@ulbid int,
@zoneId int,
@wardId int,
@statusId int,
@fromDate varchar(50),
@endDate varchar(50)


   
AS
BEGIN


SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

if @statusId=1

select sum(case when  sar_staff_type_id IN (1,2,3,4,5) then 1 else 0 end )  as total_staff_count, 
sum(case when sar_staff_status=1 then 1 else 0 end ) as staff_present_count, 
sum(case when sar_staff_status=0 then 1 else  0 end) as staff_absent_count,sar_date as date 
from [reports].[staff_attendance_report] where sar_ulb_id_fk=@ulbid and  sar_date between @fromDate and @endDate  group by sar_date


if @statusId=2

select sum(case when  sar_staff_type_id IN (1,2,3,4,5) then 1 else 0 end )  as total_staff_count, 
sum(case when sar_staff_status=1 then 1 else 0 end ) as staff_present_count, 
sum(case when sar_staff_status=0 then 1 else  0 end) as staff_absent_count,sar_date as date 
from [reports].[staff_attendance_report]  left join [admin].[config_staff_master] on [cssm_id_pk]=sar_staff_id_fk 
where sar_ulb_id_fk=@ulbid and [cssm_zone_id_fk]=@zoneId and sar_date between @fromDate and @endDate  group by sar_date




if @statusId=3

select sum(case when  sar_staff_type_id IN (1,2,3,4,5) then 1 else 0 end )  as total_staff_count, 
sum(case when sar_staff_status=1 then 1 else 0 end ) as staff_present_count, 
sum(case when sar_staff_status=0 then 1 else  0 end) as staff_absent_count,sar_date as date 
from [reports].[staff_attendance_report]  left join [admin].[config_staff_master] on [cssm_id_pk]=sar_staff_id_fk 
where sar_ulb_id_fk=@ulbid and [cssm_zone_id_fk]=@zoneId and [cssm_ward_id_fk]=@wardId and sar_date between @fromDate and @endDate group by sar_date







COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	
	  END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[syncFleet]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[syncFleet]
(
 @fleettypeId nvarchar(20),--FleetId
 @fleettypeName  nvarchar(10),--FleetTypeName
 @fleettypeCode nvarchar(100),--FleetTypeCode
 @tenantCode nvarchar(15),--CompanyCode
 @wardId nvarchar(15),--AreaId
 @FleetName nvarchar(50),--FleetName
 @ChassisNo nvarchar(50),--ChassisNo
 @EngineNo nvarchar(50),--EngineNo
 @Mileage nvarchar(50),--Mileage
 @Modal nvarchar(50),--Modal
 @fleetcapacity nvarchar(50),--SeatingCapacity
 @FleetCodeId nvarchar(50),--FleetCodeId
 @FuelCapacity int--FuelCapacity
) 
As
 Begin
 SET NOCOUNT ON;
 DECLARE @ulbPK int,@typecount int,@wardIDpk int,@wardzineIDpk int,@wardcount int,@fleetmastercount int,@typepk int,@fleetpk int
 BEGIN TRAN
 BEGIN TRY
  select @ulbPK= ulbm_id_pk from [admin].[urban_local_body_master] where [ulbm_tenant_code]=@tenantCode

  select @typecount=Count(*) from [admin].[config_fleet_category] where cfc_type_code=@fleettypeCode
      
	  IF @typecount=0
				BEGIN
					
					INSERT INTO [admin].[config_fleet_category](cfc_type,cfc_type_code,cfc_ulb_id_fk,cfc_mileage,cfc_iottype_id)values(@fleettypeName,@fleettypeCode,@ulbPK,0,@fleettypeId)
					
				END
    
		select @wardcount=COUNT(*) from  [admin].[config_ward_master] where wardUId=@WardID and cwm_ulb_id_fk=@ulbPK
		IF @wardcount<>0
		
		BEGIN
		select @wardIDpk=cwm_id_pk ,@wardzineIDpk=cwm_zone_id_fk from  [admin].[config_ward_master] where wardUId=@WardID and cwm_ulb_id_fk=@ulbPK
		END

		select @fleetmastercount=count(*) from admin.config_fleet_master where [IotOpsID]= @FleetCodeId
		select @typepk=cfc_id_pk from [admin].[config_fleet_category] where cfc_type_code=@fleettypeCode


		if @fleetmastercount=0
		begin
		 INSERT INTO admin.config_fleet_master(IotOpsID,cfm_vehicle_no,cfm_chassis_no,cfm_engine_no,cfm_mileage,cfm_ulb_code,cfm_model_no,cfm_vehicle_type_id_fk,cfm_ulb_id_fk,cfm_ward_id,cfm_zone_id,cfm_fleet_capacity,cfm_fuel_capacity,cfm_vehicle_available_status)values(@FleetCodeId,@FleetName,@ChassisNo,@EngineNo,@Mileage,@tenantCode,@Modal,@typepk,@ulbPK,@wardIDpk,@wardzineIDpk,@fleetcapacity,@FuelCapacity,1)

		  
        end
		
		 else
		 begin
		 update admin.config_fleet_master set cfm_chassis_no=@ChassisNo,cfm_engine_no=@EngineNo,cfm_model_no=@Modal,cfm_vehicle_type_id_fk=@typepk,cfm_vehicle_no=@FleetName,cfm_ward_id=@wardIDpk,cfm_zone_id=@wardzineIDpk,cfm_fleet_capacity=@fleetcapacity,cfm_fuel_capacity=@FuelCapacity,cfm_vehicle_available_status=1 where IotOpsID=@FleetCodeId

		
		 end

		 SELECT 'true' AS status,'Success' AS message

 COMMIT TRAN

	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
		SELECT 'false' AS status,ERROR_MESSAGE() AS message
	   
	 END CATCH
 End

GO
/****** Object:  StoredProcedure [dbo].[syncFleetDevices]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[syncFleetDevices]
(
@FleetId nvarchar(20),
@Types nvarchar(20),
@TypeId int,
@LayoutLatitude nvarchar(20),
@LayoutLongitude nvarchar(20),
@FleetCodeId nvarchar(20),
@GatewayUUID nvarchar(20),
@DeviceUUID nvarchar(20),
@DeviceDeviceTypeId nvarchar(20),
@GatewayDeviceTypeId nvarchar(20),
@tenant nvarchar(20),
@rfidtag  nvarchar(50) 



) 
As
 Begin
 SET NOCOUNT ON;
 DECLARE @fleetmasterId int,@fleetmastercount int,@ulbPK int,@simId int,@fleetname varchar(25),@macid varchar(25),@onlineMasterCount int,@veiwOnlineCount int,@vehicleTypeId int,@vehicleTypeName varchar(50)
 BEGIN TRAN
 BEGIN TRY
  PRINT @rfidtag
   PRINT @TypeId

  select @ulbPK= ulbm_id_pk from [admin].[urban_local_body_master] where [ulbm_tenant_code]=@tenant


  select @fleetmastercount=count(*) from admin.config_fleet_master where [IotOpsID]=@FleetCodeId

   select @fleetmasterId=[cfm_id_pk],@fleetname=[cfm_vehicle_no],@vehicleTypeId=[cfm_vehicle_type_id_fk] from admin.config_fleet_master where [IotOpsID]=@FleetCodeId

   select @vehicleTypeName=[cfc_type] from [admin].[config_fleet_category] where [cfc_id_pk]=@vehicleTypeId
  if @fleetmastercount>0
   begin
	if @TypeId=1
	begin
	
	update admin.config_fleet_master set cfm_sim_no=@GatewayUUID,[macAddress]=@GatewayUUID  where [cfm_id_pk]=@fleetmasterId
	update [admin].[config_sim_master] set csm_status=1 where csm_sim_no=@GatewayUUID
	select @simId=[csm_id_pk] from [admin].[config_sim_master] where [csm_sim_no]=@GatewayUUID
	select @onlineMasterCount=count(*) from admin.config_online_master where com_fleet_id=@fleetmasterId
	if @onlineMasterCount=0
	begin
	INSERT INTO admin.config_online_master(com_fleet_id,com_sim_id,com_fleet_name,com_sim_no,com_assigned_by,com_assigned_date,com_ulb_id_fk)values(@fleetmasterId,@simId,@fleetname,@GatewayUUID,@ulbPK,CURRENT_TIMESTAMP,@ulbPK)
	INSERT INTO reports.vehicle_maintenance_report(vmr_vehicle_id_fk,vmr_ulb_id_fk)  values(@fleetmasterId,@ulbPK)

	end

	else
	    begin
		update admin.config_online_master set com_sim_id=@simId,com_fleet_name=@fleetname,com_sim_no=@GatewayUUID,com_assigned_by=@ulbPK,com_assigned_date=CURRENT_TIMESTAMP,com_ulb_id_fk=@ulbPK where com_fleet_id=@fleetmasterId
		end
	
	

	select @veiwOnlineCount=count(*) from dbo.view_online_master where vom_vehicle_id=@fleetmasterId
	if @veiwOnlineCount=0
	 begin
	   INSERT INTO dbo.view_online_master(vom_vehicle_id,vom_sim_no,vom_status,vom_ulb_id,vom_vehicle_No,vom_received_date_time,vom_batterystatus,vom_gpsstatus,vom_vehicle_type,vom_latitude,vom_longitude)values(@fleetmasterId,@GatewayUUID,2,@ulbPK,@fleetname,CURRENT_TIMESTAMP,0,0,@vehicleTypeName,@LayoutLatitude,@LayoutLongitude)
     end 
	 else
	  begin 
	  update dbo.view_online_master set vom_vehicle_No=@fleetname,vom_vehicle_type=@vehicleTypeName where vom_sim_no=@GatewayUUID and vom_ulb_id=@ulbPK
	  end
end

	else if @TypeId=2
   begin 
   print 'in type 2==='
	--update admin.config_fleet_master set cfm_sim_no=@DeviceUUID,[macAddress]=@DeviceUUID  where [cfm_id_pk]=@fleetmasterId

	update [admin].[DeviceManagementDetails] set [Device_assigned_type]=1 where [DeviceMacaddress]=@DeviceUUID
	
   end

   else if @TypeId=3
   begin
  PRINT 'sratenjyg'
   update admin.config_fleet_master set [cfm_rfid_number]=@rfidtag  where [cfm_id_pk]=@fleetmasterId
   end
  end 
   SELECT 'true' AS status,'Success' AS message
   
 COMMIT TRAN

	 END TRY
	 BEGIN CATCH
	 ROLLBACK TRAN
		SELECT 'false' AS status,ERROR_MESSAGE() AS message
	   
	 END CATCH
 End

GO
/****** Object:  StoredProcedure [dbo].[trip_auto_schedule]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[trip_auto_schedule]
AS

BEGIN
SET NOCOUNT ON;
	DECLARE @shift_id int, @count int, @I int,@trip_id int,@repeat_status int,@schedule_date varchar(max),@tom_id int,@repeat_id int,@updated_date date,@stm_id int
	DECLARE @temp_schedule_trip_repeat table(rowid INT IDENTITY(1,1),str_id_pk int,str_stm_id_fk int,str_repeat_status int,str_shift_id_fk int,str_schedule_date varchar(max),str_update_date date)
BEGIN TRAN
BEGIN TRY
	 SELECT TOP 1 @shift_id=csm_id_pk FROM dbo.current_shift_view
	 
	 INSERT INTO @temp_schedule_trip_repeat 
	 SELECT str_id_pk,str_stm_id_fk,str_repeat_status,str_shift_id_fk,str_schedule_date,str_update_date FROM 
	 scheduling.schedule_trip_repeatedly WHERE --str_shift_id_fk=@shift_id AND 
	 (str_update_date <>CAST ( GETDATE() AS DATE) OR str_update_date IS NULL )
		SET @count=(SELECT COUNT(*) FROM @temp_schedule_trip_repeat)
		SET @I = 1
		WHILE(@I<=@count)
		BEGIN
		
			SELECT @repeat_id=str_id_pk ,@trip_id=str_stm_id_fk,@repeat_status=str_repeat_status,@schedule_date=str_schedule_date,@updated_date=str_update_date FROM @temp_schedule_trip_repeat WHERE rowid=@I
				IF @repeat_status=1
				
				BEGIN
					IF CAST ( GETDATE() AS DATE)> CAST ( @schedule_date AS DATE)
					
					BEGIN
						INSERT INTO scheduling.schedule_trip_master SELECT stm_vehicle_category_id_fk,stm_vheicle_id_fk,stm_shift_id_fk,stm_driver_id_fk,stm_cleaner_id_fk,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_date_time as time))),0,stm_schedule_type,stm_start_location,
						stm_end_location,stm_route_id_fk,stm_staff,stm_final_location,stm_start_loc_type,stm_end_loc_type,stm_geom,stm_rqst_id,stm_type_id,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_end_time as time))),[stm_alert_notify],[notifyICCC] FROM scheduling.schedule_trip_master WHERE stm_id_pk=@trip_id
						SELECT @stm_id=SCOPE_IDENTITY()
						INSERT INTO scheduling.schedule_trip_details SELECT @stm_id,std_bin_id_fk,std_sequence_no,std_bins_to_be_collected FROM scheduling.schedule_trip_details WHERE std_stm_id_fk=@trip_id ORDER BY std_sequence_no

						INSERT INTO reporting.trip_ongoing_master ([tom_vehicle_id_fk],[tom_trip_id_fk],[tom_route_id_fk],[tom_trip_schedule_date_time],tom_start_location,[tom_end_location],[tom_shift_id_fk],tom_final_location,tom_start_loc_type,tom_end_loc_type,tom_route_type,tom_rm_geom,tom_driver_id_fk)
						SELECT stm_vheicle_id_fk,@stm_id,stm_route_id_fk,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_date_time as time))),stm_start_location,stm_end_location,stm_shift_id_fk,stm_final_location,stm_start_loc_type,stm_end_loc_type,0,rm_geom,stm_driver_id_fk FROM 
						scheduling.schedule_trip_master left join [garbage].[route_master] on stm_route_id_fk=[rm_id_pk] WHERE stm_id_pk=@trip_id
						SELECT @tom_id=SCOPE_IDENTITY() 
						INSERT INTO reporting.trip_ongoing_details ([tod_master_id_fk],[tod_bin_id_fk],[tod_bin_name],[tod_sequence_no],tod_bins_to_be_collected) 
						SELECT @tom_id,std_bin_id_fk,ggcf_points_name,std_sequence_no,ggcf_points_count FROM scheduling.schedule_trip_details 
						LEFT JOIN garbage.gis_garbage_collection_points ON ggcf_points_id_pk=std_bin_id_fk LEFT JOIN scheduling.schedule_trip_master ON stm_id_pk=std_stm_id_fk WHERE std_stm_id_fk=@trip_id ORDER BY std_sequence_no


						UPDATE scheduling.schedule_trip_repeatedly SET str_update_date=CAST ( GETDATE() AS DATE) WHERE str_id_pk=@repeat_id
					END
				END
				ELSE IF @repeat_status=2
				BEGIN
					IF CAST ( GETDATE() AS DATE)> CAST ( @schedule_date AS DATE)
					BEGIN
						IF (@updated_date IS NULL AND DATEADD(DAY,2, CAST(@schedule_date AS DATE)) = CAST ( GETDATE() AS DATE))
						OR (@updated_date IS NOT NULL AND DATEADD(DAY,2, CAST(@updated_date AS DATE)) = CAST ( GETDATE() AS DATE))
						BEGIN
							INSERT INTO scheduling.schedule_trip_master SELECT stm_vehicle_category_id_fk,stm_vheicle_id_fk,stm_shift_id_fk,stm_driver_id_fk,stm_cleaner_id_fk,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_date_time as time))),0,stm_schedule_type,stm_start_location,
							stm_end_location,stm_route_id_fk,stm_staff,stm_final_location,stm_start_loc_type,stm_end_loc_type,stm_geom,stm_rqst_id,stm_type_id,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_end_time as time))),[stm_alert_notify],[notifyICCC] FROM scheduling.schedule_trip_master WHERE stm_id_pk=@trip_id
							SELECT @stm_id=SCOPE_IDENTITY()
							INSERT INTO scheduling.schedule_trip_details SELECT @stm_id,std_bin_id_fk,std_sequence_no,std_bins_to_be_collected FROM scheduling.schedule_trip_details WHERE std_stm_id_fk=@trip_id ORDER BY std_sequence_no

							INSERT INTO reporting.trip_ongoing_master ([tom_vehicle_id_fk],[tom_trip_id_fk],[tom_route_id_fk],[tom_trip_schedule_date_time],tom_start_location,[tom_end_location],[tom_shift_id_fk],tom_final_location,tom_start_loc_type,tom_end_loc_type,tom_route_type,tom_rm_geom,tom_driver_id_fk)
							SELECT stm_vheicle_id_fk,@stm_id,stm_route_id_fk,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_date_time as time))),stm_start_location,stm_end_location,stm_shift_id_fk,stm_final_location,stm_start_loc_type,stm_end_loc_type,0, rm_geom,stm_driver_id_fk FROM 
					         scheduling.schedule_trip_master left join [garbage].[route_master] on stm_route_id_fk=[rm_id_pk] WHERE stm_id_pk=@trip_id
							SELECT @tom_id=SCOPE_IDENTITY() 
							INSERT INTO reporting.trip_ongoing_details ([tod_master_id_fk],[tod_bin_id_fk],[tod_bin_name],[tod_sequence_no],tod_bins_to_be_collected) 
							SELECT @tom_id,std_bin_id_fk,ggcf_points_name,std_sequence_no,ggcf_points_count FROM scheduling.schedule_trip_details 
							LEFT JOIN garbage.gis_garbage_collection_points ON ggcf_points_id_pk=std_bin_id_fk LEFT JOIN scheduling.schedule_trip_master ON stm_id_pk=std_stm_id_fk WHERE std_stm_id_fk=@trip_id ORDER BY std_sequence_no

							UPDATE scheduling.schedule_trip_repeatedly SET str_update_date=CAST ( GETDATE() AS DATE) WHERE str_id_pk=@repeat_id
				
						END
					END
				END
				ELSE IF @repeat_status=3
				BEGIN
			
					IF CAST ( GETDATE() AS DATE)> CAST ( @schedule_date AS DATE)
						BEGIN
							IF (@updated_date IS NULL AND DATEADD(DAY,7, CAST(@schedule_date AS DATE)) = CAST ( GETDATE() AS DATE))
								OR (@updated_date IS NOT NULL AND DATEADD(DAY,7, CAST(@updated_date AS DATE)) = CAST ( GETDATE() AS DATE))
								BEGIN
									INSERT INTO scheduling.schedule_trip_master SELECT stm_vehicle_category_id_fk,stm_vheicle_id_fk,stm_shift_id_fk,stm_driver_id_fk,stm_cleaner_id_fk,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_date_time as time))),0,stm_schedule_type,stm_start_location,
									stm_end_location,stm_route_id_fk,stm_staff,stm_final_location,stm_start_loc_type,stm_end_loc_type,stm_geom,stm_rqst_id,stm_type_id,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_end_time as time))),[stm_alert_notify],[notifyICCC] FROM scheduling.schedule_trip_master WHERE stm_id_pk=@trip_id
									SELECT @stm_id=SCOPE_IDENTITY()
									INSERT INTO scheduling.schedule_trip_details SELECT @stm_id,std_bin_id_fk,std_sequence_no,std_bins_to_be_collected FROM scheduling.schedule_trip_details WHERE std_stm_id_fk=@trip_id ORDER BY std_sequence_no

									INSERT INTO reporting.trip_ongoing_master ([tom_vehicle_id_fk],[tom_trip_id_fk],[tom_route_id_fk],[tom_trip_schedule_date_time],tom_start_location,[tom_end_location],[tom_shift_id_fk],tom_final_location,tom_start_loc_type,tom_end_loc_type,tom_route_type,tom_rm_geom,tom_driver_id_fk)
									SELECT stm_vheicle_id_fk,@stm_id,stm_route_id_fk,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_date_time as time))),stm_start_location,stm_end_location,stm_shift_id_fk,stm_final_location,stm_start_loc_type,stm_end_loc_type,0, rm_geom,stm_driver_id_fk FROM 
					scheduling.schedule_trip_master left join [garbage].[route_master] on stm_route_id_fk=[rm_id_pk] WHERE stm_id_pk=@trip_id
									SELECT @tom_id=SCOPE_IDENTITY() 
									INSERT INTO reporting.trip_ongoing_details ([tod_master_id_fk],[tod_bin_id_fk],[tod_bin_name],[tod_sequence_no],tod_bins_to_be_collected) 
									SELECT @tom_id,std_bin_id_fk,ggcf_points_name,std_sequence_no,ggcf_points_count FROM scheduling.schedule_trip_details 
									LEFT JOIN garbage.gis_garbage_collection_points ON ggcf_points_id_pk=std_bin_id_fk LEFT JOIN scheduling.schedule_trip_master ON stm_id_pk=std_stm_id_fk WHERE std_stm_id_fk=@trip_id ORDER BY std_sequence_no

									UPDATE scheduling.schedule_trip_repeatedly SET str_update_date=CAST ( GETDATE() AS DATE) WHERE str_id_pk=@repeat_id
				
								END
							END

				END
				ELSE IF @repeat_status=4
				BEGIN
					IF CHARINDEX(CONVERT(varchar,GETDATE(),23),@schedule_date)>0
					BEGIN
						INSERT INTO scheduling.schedule_trip_master SELECT stm_vehicle_category_id_fk,stm_vheicle_id_fk,stm_shift_id_fk,stm_driver_id_fk,stm_cleaner_id_fk,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_date_time as time))),0,stm_schedule_type,stm_start_location,
						stm_end_location,stm_route_id_fk,stm_staff,stm_final_location,stm_start_loc_type,stm_end_loc_type,stm_geom,stm_rqst_id,stm_type_id,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_end_time as time))),[stm_alert_notify],[notifyICCC] FROM scheduling.schedule_trip_master WHERE stm_id_pk=@trip_id
						SELECT @stm_id=SCOPE_IDENTITY()
						INSERT INTO scheduling.schedule_trip_details SELECT @stm_id,std_bin_id_fk,std_sequence_no,std_bins_to_be_collected FROM scheduling.schedule_trip_details WHERE std_stm_id_fk=@trip_id ORDER BY std_sequence_no

						INSERT INTO reporting.trip_ongoing_master ([tom_vehicle_id_fk],[tom_trip_id_fk],[tom_route_id_fk],[tom_trip_schedule_date_time],tom_start_location,[tom_end_location],[tom_shift_id_fk],tom_final_location,tom_start_loc_type,tom_end_loc_type,tom_route_type,tom_rm_geom,tom_driver_id_fk)
						SELECT stm_vheicle_id_fk,@stm_id,stm_route_id_fk,convert (datetime,convert (nvarchar(10),cast(GETDATE()as date))+' '+convert (nvarchar(8),cast(stm_date_time as time))),stm_start_location,stm_end_location,stm_shift_id_fk,stm_final_location,stm_start_loc_type,stm_end_loc_type,0,rm_geom,stm_driver_id_fk FROM 
					scheduling.schedule_trip_master left join [garbage].[route_master] on stm_route_id_fk=[rm_id_pk] WHERE stm_id_pk=@trip_id
						SELECT @tom_id=SCOPE_IDENTITY() 
						INSERT INTO reporting.trip_ongoing_details ([tod_master_id_fk],[tod_bin_id_fk],[tod_bin_name],[tod_sequence_no],tod_bins_to_be_collected) 
						SELECT @tom_id,std_bin_id_fk,ggcf_points_name,std_sequence_no,ggcf_points_count FROM scheduling.schedule_trip_details 
						LEFT JOIN garbage.gis_garbage_collection_points ON ggcf_points_id_pk=std_bin_id_fk LEFT JOIN scheduling.schedule_trip_master ON stm_id_pk=std_stm_id_fk WHERE std_stm_id_fk=@trip_id ORDER BY std_sequence_no

						UPDATE scheduling.schedule_trip_repeatedly SET str_update_date=CAST ( GETDATE() AS DATE) WHERE str_id_pk=@repeat_id
				
					END

				END
			

			SET @I=@I+1
		END
		SELECT 'true' AS status
		COMMIT TRAN
		END TRY
		BEGIN CATCH
		  ROLLBACK TRAN
		  SELECT 'false' AS status
		END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[update_distance_in_dash]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[update_distance_in_dash]
	
AS
BEGIN
	SET NOCOUNT ON;

	
	


	 with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, 
					   		 dateadd(day,datediff(day,7,GETDATE()),0))) where dateadd(dd, 1, CONVERT(date, 
					   		 dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE() 
							 union all select dateadd(dd, 1, dt) 
					   		 from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
							 select 10 total_distance, 10 Avg_distance, FORMAT( dt,'dd-MM-yyyy') as rd_date_time,rd_ulb_id_fk  
					   		 from dateRange,  [reports].[report_distance] where rd_ulb_id_fk <> 0 
					   		 group by rd_ulb_id_fk,  dt 
							 union all (
							 select  45 as total_distance, 45 as Avg_distance, FORMAT( dt,'dd-MM-yyyy') 
					   		 as rd_date_time,0 as rd_ulb_id_fk from dateRange left join  [reports].[report_distance] 
					   		 on CONVERT(date, rd_date_time)=dt group by  dt,CONVERT(date, rd_date_time) 
							 
							 )  
					   		 order by rd_ulb_id_fk, rd_date_time

END

GO
/****** Object:  StoredProcedure [dbo].[update_incident_status_by_workforce]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE  [dbo].[update_incident_status_by_workforce] 
	
	@incidentId NVARCHAR(25), 
	@workforceUserId INT,
	@info VARCHAR(1000),
	@status INT,
	@phoneNumber VARCHAR(20),
	@latitude FLOAT,
	@longitude FLOAT

AS  
BEGIN
	
	SET NOCOUNT ON;

	
	select CAST(1 as bit) AS status

END

GO
/****** Object:  StoredProcedure [dbo].[update_mdt_online_master]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE  [dbo].[update_mdt_online_master] 

@ht_simcard_no NVARCHAR(20),

@ht_latitude double precision, 

@ht_longitude double precision,

@medium character varying(4),

@ht_speed double precision, 

@utc_datetime datetime,

@signalstrength int,

@ht_ignition int,

@ht_degree int,

@ht_power int,

@address varchar(2000),

@workforceSimNo varchar(50)

AS

BEGIN

	DECLARE @vehicle_status BIT,@battery_status BIT,@vehicleno nvarchar(20),@vehicleid int,@ulb_id int,@onlinecount int;
	set @onlinecount=0;

	DECLARE @temp_online_master table(row_id INT IDENTITY(1,1),vehicleid int,vehicleNo nvarchar(20),ulbId int,vomIdPk int)

	DECLARE @count int,@I int,@worforceSimCount int;

	INSERT INTO @temp_online_master
	select vom_vehicle_id,vom_vehicle_No,vom_ulb_id,vom_id_pk from view_online_master  where vom_sim_no= @ht_simcard_no;

	SET @count = (SELECT COUNT(row_id) FROM @temp_online_master);
	SET @I = 1;
	WHILE (@I <= @count)
	BEGIN
		select @vehicleid = vehicleid,@vehicleno = vehicleNo, @ulb_id=ulbId,@onlinecount = vomIdPk from @temp_online_master  where row_id= @I;
		IF @onlinecount>0
			BEGIN

			UPDATE view_online_master  SET vom_latitude = @ht_latitude,vom_longitude =@ht_longitude,vom_speed =@ht_speed,vom_utc_date_time = @utc_datetime,vom_received_date_time =GETDATE(),vom_placename = @address,vom_packet_type = @medium,vom_ignition =@ht_ignition,vom_status=1,vom_signal_strength= @signalstrength,vom_gpsstatus = 1,vom_batterystatus =@battery_status,vom_maintenance_type=NULL,vom_vehicle_no =  @vehicleno,[vom_degree] =@ht_degree WHERE (vom_sim_no = @ht_simcard_no) and vom_ulb_id=@ulb_id;
		END
		SET @I=@I+1
	END

	SELECT @worforceSimCount= count(*) from [admin].[config_mobile_user_master] where cmum_mobile=@workforceSimNo
	IF @worforceSimCount>0
	BEGIN
		update [admin].[config_mobile_user_master] set [latitude]=@ht_latitude,[longitude]=@ht_longitude,[utc_date_time]=@utc_datetime,[placename]=@address,received_datetime=GETDATE() where [cmum_mobile]=@workforceSimNo
	END

END

GO
/****** Object:  StoredProcedure [dbo].[update_online_master]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE  [dbo].[update_online_master] 

@ht_simcard_no NVARCHAR(20),

@ht_latitude double precision, 

@ht_longitude double precision,

@ht_odometer double precision,

@medium character varying(4),

@ht_speed double precision, 

@utc_datetime datetime,

@signalstrength int,

@ht_ignition int,

@ht_degree int,

@ht_power int,

@address varchar(2000),

@valid_packet character(2),

@internalBatteryLevel int


AS

BEGIN

	DECLARE @vehicle_status BIT,@battery_status BIT,@vehicleno nvarchar(20),@vehicleid int,@ulb_id int,@onlinecount int;
	set @onlinecount=0;

	DECLARE @temp_online_master table(row_id INT IDENTITY(1,1),vehicleid int,vehicleNo nvarchar(20),ulbId int,vomIdPk int)

	DECLARE @count int,@I int;

	INSERT INTO @temp_online_master
	select vom_vehicle_id,vom_vehicle_No,vom_ulb_id,vom_id_pk from view_online_master  where vom_sim_no= @ht_simcard_no and vom_status<>6;

	SET @count = (SELECT COUNT(row_id) FROM @temp_online_master);
	SET @I = 1;
	WHILE (@I <= @count)
	BEGIN
		select @vehicleid = vehicleid,@vehicleno = vehicleNo, @ulb_id=ulbId,@onlinecount = vomIdPk from @temp_online_master  where row_id= @I;
		IF @onlinecount>0
			BEGIN
				IF(@valid_packet='A')
				BEGIN
					IF(@ht_power=0)
						BEGIN
							SET @vehicle_status=1
							SET @battery_status=11
						END
					ELSE
					   BEGIN
							SET @battery_status=0
							SET @vehicle_status=5
						END

			UPDATE view_online_master  SET vom_latitude = @ht_latitude,vom_longitude =@ht_longitude,vom_speed =@ht_speed,vom_utc_date_time = @utc_datetime,vom_received_date_time =GETDATE(),vom_placename = @address,vom_packet_type = @medium,vom_ignition =@ht_ignition,vom_status=@vehicle_status,vom_signal_strength= @signalstrength,vom_gpsstatus = 1,vom_batterystatus =@battery_status,vom_maintenance_type=NULL,vom_vehicle_no =  @vehicleno,[vom_odometer_value]= @ht_odometer,[vom_degree] =@ht_degree,batteryLevel=@internalBatteryLevel WHERE (vom_sim_no = @ht_simcard_no) and vom_ulb_id=@ulb_id;
			END
			ELSE
				BEGIN
					IF(@ht_power=0)
						BEGIN
							SET @battery_status=11
						END
					ELSE
						BEGIN
							SET @battery_status=0
						END
				IF   (@medium='NM') 
					Begin
						UPDATE view_online_master SET vom_received_date_time =getdate(),vom_status=3,vom_gpsstatus = 0,batteryLevel=@internalBatteryLevel WHERE (vom_sim_no = @ht_simcard_no) and vom_ulb_id=@ulb_id;--vom_utc_date_time =@utc_datetime,
					END
				END
			End 
		SET @I=@I+1
	END
	--To Insert in GPS database for distance data...
	select vom_vehicle_id,vom_ulb_id from view_online_master  where vom_sim_no=@ht_simcard_no; 
END

GO
/****** Object:  StoredProcedure [dbo].[update_staffAttendance_report]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[update_staffAttendance_report]
	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @currentdate date
	SET @currentdate=CONVERT (date, GETDATE()) 
	UPDATE [staff_attendance].[online_staff_master] SET osm_login_time=NULL,osm_logout_time=NULL,osm_location=NULL,osm_status=0 WHERE CAST(osm_login_time AS date)<>@currentdate

	INSERT INTO [reports].[staff_attendance_report]([sar_staff_id_fk],[sar_staff_name],[sar_ulb_id_fk],[sar_staff_type_id],[sar_staff_type]
,sar_staff_status,[sar_date],[sar_emp_id],sar_ward_id_fk)
	   SELECT cssm_id_pk,cssm_staff_name,cssm_ulb_id_fk,cssm_staff_type,cst_type,0,@currentdate,cssm_emp_id,cssm_ward_id_fk FROM admin.config_staff_master left join admin.config_staff_type on cssm_staff_type=cst_id_pk WHERE NOT EXISTS(SELECT sar_staff_id_fk FROM reports.[staff_attendance_report] WHERE sar_staff_id_fk=cssm_id_pk AND cast(sar_date as date)=@currentdate)
	   UPDATE reports.[staff_attendance_report] SET sar_login_time=osm_login_time, sar_logout_time=osm_logout_time, sar_staff_status=osm_status 
	   from reports.[staff_attendance_report],[staff_attendance].[online_staff_master] where sar_staff_id_fk=osm_staff_id and sar_date=@currentdate

END

GO
/****** Object:  StoredProcedure [dbo].[update_trip_logsheet_details]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[update_trip_logsheet_details]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN

	--DECLARE @VEHID INT;
	--DECLARE @TRIPID INT;
	--DECLARE @ROUTEID INT;
	--DECLARE @TRIPSCH_DATETIME DATETIME;
	--DECLARE @TRIPSTART_DATE DATETIME;
	--DECLARE @TRIPEND_DATE DATETIME;
	--DECLARE @TRIPSTATUS INT;
	--DECLARE @DRIVERID INT;
	--DECLARE @CLEANERID INT;
	--DECLARE @SHIFTID INT;
	--DECLARE @WEIGHTDISPO INT;
	--DECLARE @DUMPINGGROUND VARCHAR(50);
	--DECLARE @ROUTETYPE INT;
	--DECLARE @RECEIVEDWEIGHT FLOAT;
	--DECLARE @TRIPDISTANCE FLOAT;

	---- Fetching data from reporting.trip_ongoing_master table for closed trip (i.e trip id = 3)
	--SELECT @VEHID = tom_vehicle_id_fk, @TRIPID = tom_trip_id_fk, @ROUTEID = tom_route_id_fk, 
	--@TRIPSCH_DATETIME = tom_trip_schedule_date_time, @TRIPSTART_DATE = tom_start_date_time,
 --   @TRIPEND_DATE = tom_end_date_time, @TRIPSTATUS = tom_trip_status, @DRIVERID = tom_driver_id_fk,
 --   @CLEANERID = tom_cleaner_id_fk, @SHIFTID = tom_shift_id_fk, @WEIGHTDISPO = tom_weight_disposed,
	--@ROUTETYPE = tom_route_type, @RECEIVEDWEIGHT = tom_received_weight, @TRIPDISTANCE = tom_trip_distance
 --   FROM reporting.trip_ongoing_master WHERE tom_trip_status = 3;

	---- Inserting closed trip details into reporting.trip_completed_master.
	--INSERT INTO reporting.trip_completed_master (tcm_vehicle_id_fk, tcm_trip_id_fk, tcm_route_id_fk,
	--tcm_trip_date_time, tcm_start_date_time, tcm_end_date_time, tcm_trip_status, tcm_driver_id_fk, tcm_cleaner_id_fk,
	--tcm_shift_id_fk, tcm_weight_disposed, tcm_route_type, tcm_received_weight, tcm_trip_distance) VALUES
	--(@VEHID,@TRIPID,@ROUTEID,@TRIPSCH_DATETIME,@TRIPSTART_DATE,@TRIPEND_DATE,@TRIPSTATUS,@DRIVERID,@CLEANERID,
	--@SHIFTID,@WEIGHTDISPO,@ROUTETYPE,@RECEIVEDWEIGHT,@TRIPDISTANCE);

   	DECLARE @temp_trip_ongoing_master table(rowid INT ,tom_id_pk int,tom_vehicle_id_fk int,tom_trip_id_fk int,tom_route_id_fk int,tom_trip_schedule_date_time datetime, Maitenance Bit,singleBinArea_FK int,
	tom_start_date_time datetime,tom_end_date_time datetime,tom_trip_status int,tom_driver_id_fk int,tom_cleaner_id_fk int,tom_shift_id_fk int,tom_end_location int,tom_start_location int,tom_final_location int,tom_notify_status int,tom_start_loc_type int,tom_end_loc_type int)
	DECLARE @temp_trip_ongoing_details table(rowid INT ,tod_id_pk int,tod_master_id_fk int,tod_bin_id_fk int,tod_bin_name varchar(max),tod_bin_entry_time datetime,
	tod_bin_exit_time datetime,tod_sequence_no datetime,tod_bins_collected int)
	DECLARE @temp_trip_completed_details table(rowid INT ,tod_id_pk int, tod_master_id_fk int,tod_bin_id_fk int,tod_bin_name varchar(max),image_url varchar(max),Audio_url varchar(max),Video_url varchar(max),Remark varchar(max),AtrRemark varchar(max),tod_collection_status int,tod_bin_entry_time datetime,
	tod_bin_exit_time datetime,tod_sequence_no int,tod_bins_to_be_collected int,tod_bins_collected int,tod_weight int)


	
	
	DECLARE @count int,@I int,@tom_id int,@count_1 int,@J int,@tod_id int,@trip_status int,@trip_id int,@dump_grnd_id int,@K int,@count_2 int,@trr_id int,@details_id int,@fence_id int
	DECLARE @vehicle_in_time datetime,@vehicle_out_time datetime,@dump_entry_time datetime,@dump_exit_time datetime,@end_date_time datetime
	DECLARE @is_in bit;
	DECLARE @dump_grnd varchar(256),@alertMsg nvarchar(256);
	DECLARE @trip_weight float,@max_id bigint;

	-------------------************----------------------
	--update [dbo].[view_online_master]  set vom_received_date_time=dateadd(mi,330,getdate()) where vom_id_pk=17585
	------------------*************-------------------
	

	INSERT INTO @temp_trip_ongoing_master select row_number() over( order by tom_id_pk),tom_id_pk ,tom_vehicle_id_fk ,tom_trip_id_fk ,tom_route_id_fk ,tom_trip_schedule_date_time, Maitenance, singleBinArea_FK,
	tom_start_date_time ,tom_end_date_time ,tom_trip_status ,tom_driver_id_fk ,tom_cleaner_id_fk ,tom_shift_id_fk,tom_end_location,tom_start_location,tom_final_location,tom_notify_status,tom_start_loc_type,tom_end_loc_type from (SELECT row_number() over(partition by tom_vehicle_id_fk order by tom_trip_schedule_date_time) as p1,tom_id_pk ,tom_vehicle_id_fk ,tom_trip_id_fk ,tom_route_id_fk ,tom_trip_schedule_date_time , Maitenance, singleBinArea_FK,
	tom_start_date_time ,tom_end_date_time ,tom_trip_status ,tom_driver_id_fk ,tom_cleaner_id_fk ,tom_shift_id_fk,tom_end_location,tom_start_location,tom_final_location,tom_notify_status,tom_start_loc_type,tom_end_loc_type FROM  reporting.trip_ongoing_master )as t1 --where p1=1 
	ORDER BY tom_id_pk
	SET @count = (SELECT COUNT(rowid) FROM @temp_trip_ongoing_master);  
	
	-- Initialize the iterator
    --select * from @temp_trip_ongoing_master
	SET @I = 1
	
	WHILE (@I <= @count)
	BEGIN
	SELECT @tom_id=tom_id_pk,@trip_id=tom_trip_id_fk  FROM @temp_trip_ongoing_master WHERE rowid=@I

	SELECT @trip_status=tom_trip_status FROM reporting.trip_ongoing_master WHERE tom_id_pk=@tom_id
	
		SET @vehicle_in_time=NULL;
		SET @vehicle_out_time=NULL;
		SET @is_in=0;
		
		IF @trip_status=1   --CHECKING FOR ONGOING TRIPS
		BEGIN
			
		-------------------------------------------------------------------------------------------------------------------------
		IF (SELECT tom_notify_status FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) >= 0 
			BEGIN
					SELECT TOP 1 @vehicle_in_time=vios_vehicle_in_time,@is_in=vios_is_in 
					FROM  dbo.vehicle_in_out_status WHERE vios_vehicle_id_fk=(SELECT tom_vehicle_id_fk FROM 
					@temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)
					AND vios_fence_type =(SELECT tom_end_loc_type FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) AND vios_fence_id=(SELECT tom_final_location FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) AND 
					vios_vehicle_in_time>(SELECT DATEADD(MINUTE,60,tom_start_date_time) FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)  ORDER BY vios_vehicle_in_time
					IF @vehicle_in_time IS NOT NULL 
					BEGIN
						UPDATE reporting.trip_ongoing_master SET tom_trip_status=2,tom_end_date_time=@vehicle_in_time WHERE 
						tom_id_pk=@tom_id
						UPDATE scheduling.schedule_trip_master SET stm_status=2 WHERE stm_id_pk=@trip_id
					END
			END
		-------------------------------------------------------------------------------------------------------------------------
		delete from @temp_trip_ongoing_details
			INSERT INTO @temp_trip_ongoing_details SELECT row_number() over(order by tod_id_pk),tod_id_pk,tod_master_id_fk,tod_bin_id_fk,tod_bin_name,tod_bin_entry_time,tod_bin_exit_time,tod_sequence_no,tod_bins_collected FROM 
			 reporting.trip_ongoing_details WHERE tod_master_id_fk=@tom_id AND (tod_bin_entry_time IS NULL OR tod_bin_exit_time IS NULL)
			 SET @count_1 = (SELECT COUNT(rowid) FROM @temp_trip_ongoing_details);  
	
				-- Initialize the iterator
				SET @J = 1
	
				WHILE (@J <= @count_1)
				BEGIN
				SELECT @tod_id=tod_id_pk FROM @temp_trip_ongoing_details WHERE rowid=@J
				SET @vehicle_in_time=NULL;
				SET @vehicle_out_time=NULL;
				SET @is_in=0;
					SELECT TOP 1 @vehicle_in_time=vios_vehicle_in_time,@vehicle_out_time=vios_vehicle_out_time,@is_in=vios_is_in 
					FROM  dbo.vehicle_in_out_status WHERE vios_vehicle_id_fk=(SELECT tom_vehicle_id_fk FROM 
					@temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)
					AND vios_fence_type=1 AND vios_fence_id=(SELECT tod_bin_id_fk FROM @temp_trip_ongoing_details WHERE tod_id_pk=@tod_id) AND 
					vios_vehicle_in_time>(SELECT tom_start_date_time FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) and (datediff(minute,vios_vehicle_in_time,vios_vehicle_out_time)> 300 or datediff(minute,vios_vehicle_in_time,getdate())> 300) ORDER BY vios_vehicle_in_time
					IF @vehicle_in_time IS NOT NULL 
					BEGIN
						UPDATE reporting.trip_ongoing_details SET tod_bin_entry_time=@vehicle_in_time,tod_bin_exit_time=@vehicle_out_time,tod_collection_status=(case when [tod_bins_collected]>0 then 1 else 3 end) 
						WHERE tod_id_pk=@tod_id
						update [garbage].[gis_garbage_collection_points] set [ggcf_bin_collection_status] =(SELECT case when tod_bins_collected>0 or ggcf_bin_collection_status=1 then 1 else 3 end FROM @temp_trip_ongoing_details WHERE tod_id_pk=@tod_id)--,[ggcf_last_collected_date]=@vehicle_in_time 
						where [ggcf_points_id_pk] =(SELECT tod_bin_id_fk FROM @temp_trip_ongoing_details WHERE tod_id_pk=@tod_id)  and [Bin_type_id]<>1
						update [admin].[config_bin_sensor_master] set [cbsm_collection_status]=3 where cbsm_bin_loc_id=(SELECT tod_bin_id_fk FROM @temp_trip_ongoing_details WHERE tod_id_pk=@tod_id) and [cbsm_collection_status]<>1 
					END

				SET @J=@J+1;
				END
				
		END
		ELSE IF @trip_status=2 --CHECKING FOR COMPLETED TRIPS
		BEGIN
		
		/*select * from reporting.trip_completed_master where tcm_trip_id_fk=14468
		select * from reporting.trip_completed_details where tcd_master_id_fk=85519
		select * from reporting.trip_completed_captured_data
		select * from [reporting].[trip_completed_rfid_details]*/
		--DELETE from reporting.trip_completed_master
		--DELETE  from reporting.trip_completed_details
		--DELETE from reporting.trip_completed_captured_data
		SET @dump_grnd_id=(SELECT tom_end_location FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)
		SELECT @dump_grnd=gdg_name FROM garbage.gis_dumping_grounds WHERE gdg_id_pk=@dump_grnd_id
		SELECT @dump_entry_time=vios_vehicle_in_time,@dump_exit_time=vios_vehicle_out_time FROM  dbo.vehicle_in_out_status
		WHERE vios_vehicle_id_fk=(SELECT tom_vehicle_id_fk FROM	@temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) AND vios_fence_id=@dump_grnd_id AND vios_fence_type=3
		AND vios_vehicle_in_time>(SELECT tom_start_date_time FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) AND vios_vehicle_in_time<(SELECT tom_end_date_time FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)
		SET @trip_weight = 0;
			
			SELECT top 1 @trip_weight=twd_weight FROM reporting.trip_weight_details WHERE twd_trip_id=@trip_id;

			INSERT INTO reporting.trip_completed_master (tcm_vehicle_id_fk,tcm_trip_id_fk,tcm_route_id_fk,tcm_trip_date_time,Maitenance , singleBinArea_FK, tcm_start_date_time,
			tcm_end_date_time,tcm_trip_status,tcm_driver_id_fk,tcm_cleaner_id_fk,tcm_shift_id_fk,tcm_weight_disposed,tcm_dumping_ground,tcm_dump_entry_time,tcm_dump_exit_time,[tcm_start_location],[tcm_end_location],[tcm_route_type],tcm_received_weight,[tcm_trip_distance])
			SELECT  tom_vehicle_id_fk,tom_trip_id_fk,tom_route_id_fk,tom_trip_schedule_date_time,Maitenance, singleBinArea_FK,
			tom_start_date_time,case when tom_end_date_time is null and tom_start_date_time is not null then getdate() else tom_end_date_time end as tom_end_date_time,tom_trip_status,tom_driver_id_fk,tom_cleaner_id_fk,tom_shift_id_fk,
			@trip_weight as 'trip_weight',@dump_grnd as 'dump_grnd',case when [tom_dump_time] is null then @dump_entry_time else [tom_dump_time] end as 'dump_entry_time',@dump_exit_time as 'dump_exit_time',agv1.[name],agv2.name,[tom_route_type],[tom_received_weight],tom_trip_distance
			 FROM reporting.trip_ongoing_master left join [dbo].[all_geofence_view] agv1 on agv1.[poi_type]=[tom_start_loc_type] and tom_start_location=agv1.id left join [dbo].[all_geofence_view] agv2 on agv2.[poi_type]=[tom_end_loc_type] and [tom_final_location]=agv2.id WHERE tom_id_pk=@tom_id
			
			SELECT @tod_id = SCOPE_IDENTITY();			

		/*	INSERT INTO reporting.trip_completed_details SELECT @tod_id,tod_bin_id_fk,tod_bin_name,
			tod_collection_status,tod_bin_entry_time,tod_bin_exit_time,tod_sequence_no,tod_cnt,cnt_2,weight FROM (SELECT tod_id_pk, tod_master_id_fk,tod_bin_id_fk,tod_bin_name,
			tod_collection_status,tod_bin_entry_time,tod_bin_exit_time,tod_sequence_no,[tod_bins_to_be_collected] as tod_cnt,[tod_bins_collected] as cnt_2,0 as weight FROM reporting.trip_ongoing_details 
			WHERE tod_master_id_fk=@tom_id)AS TEMP_TABLE*/

			------------------------------------------------------------------------------------------		 
			INSERT INTO [dbo].[bin_sensor_alert_log]([bsal_sim_number] ,[bsal_bin_name] ,[bsal_bin_location] ,[bsal_longitude]
            ,[bsal_latitude] ,[bsal_date_time],[bsal_assign_status] ,[bsal_ulb_id_pk],[bsal_bin_id],[bsal_volume],[bsal_bin_loc_id],[bsal_bin_skippedfull_status],[bsal_trip_id])
			
			SELECT '',[cbm_bin_name],[tod_bin_name],0,0,dateadd(minute,330,getdate()),0,[cfm_ulb_id_fk],[cbm_id_pk],0,[tod_bin_id_fk],1,@trip_id FROM reporting.trip_ongoing_details 
			LEFT JOIN reporting.trip_ongoing_master ON tom_id_pk=tod_master_id_fk LEFT JOIN admin.config_fleet_master ON cfm_id_pk=tom_vehicle_id_fk 
			--LEFT JOIN [admin].[config_rfid_master] ON [crm_bin_loc_id_fk]=tod_bin_id_fk 
			LEFT JOIN [admin].[config_bin_master] ON 
			--[cbm_id_pk]=[crm_bin_id] 
			cbm_bin_loc_id=tod_bin_id_fk and cbm_binRroad_status = 0
			left join [reporting].[rfid_read_in_each_binLocation] on [rreb_trip_ongoing_details_id_fk]=[tod_id_pk] and [rreb_bin_id_fk]=[cbm_id_pk]  left join [garbage].[gis_garbage_collection_points] on [ggcf_points_id_pk]=tod_bin_id_fk 
			WHERE tod_master_id_fk=@tom_id AND [rreb_id_pk] is  null	and [tod_bins_collected]<[tod_bins_to_be_collected]	and [ggcf_bin_collection_status]<>1		

			--INSERT INTO  [dbo].[alert_log_m7] ([al_alert_type_fk],[al_alert_sub_type_fk],[al_vehicle_id_fk],[al_alert_msg],[al_received_date_time],[al_latitude],[al_longitude],[al_location],[al_email_status],[al_sms_status],[al_month],[al_vehicle_no],[al_alert_type],[al_sub_alert_type],[al_ulb_id_fk])
			--SELECT 5,0,tom_vehicle_id_fk,'Vehicle No - '+cfm_vehicle_no+' has not attended Bin Id - '+[cbm_bin_name]+' in Bin Location - '+tod_bin_name+'  on '+ 
			--cast(dateadd(minute,330,getdate()) as varchar(20))+'',dateadd(minute,330,getdate()),0,0,tod_bin_name,0,0,7,cfm_vehicle_no,'Bin Skipped Alert','',cfm_ulb_id_fk FROM reporting.trip_ongoing_details 
			--LEFT JOIN reporting.trip_ongoing_master ON tom_id_pk=tod_master_id_fk LEFT JOIN admin.config_fleet_master ON cfm_id_pk=tom_vehicle_id_fk LEFT JOIN [admin].[config_rfid_master] ON [crm_bin_loc_id_fk]=tod_bin_id_fk 
			--LEFT JOIN [admin].[config_bin_master] ON [cbm_id_pk]=[crm_bin_id] 
			--left join [reporting].[rfid_read_in_each_binLocation] on [rreb_trip_ongoing_details_id_fk]=[tod_id_pk] and [rreb_bin_id_fk]=[cbm_id_pk]  left join [garbage].[gis_garbage_collection_points] on [ggcf_points_id_pk]=tod_bin_id_fk 
			--WHERE tod_master_id_fk=@tom_id AND [rreb_id_pk] is  null	and [tod_bins_collected]<[tod_bins_to_be_collected]	and [ggcf_bin_collection_status]<>1	

	delete from @temp_trip_completed_details
	INSERT INTO @temp_trip_completed_details
				SELECT row_number() over (order by tod_id_pk) ,tod_id_pk,@tod_id,tod_bin_id_fk,tod_bin_name,image_url, Audio_url, Video_url, Remark, AtrRemark,
			tod_collection_status,tod_bin_entry_time,tod_bin_exit_time,tod_sequence_no,tod_cnt,cnt_2,weight FROM (SELECT tod_id_pk, tod_master_id_fk,tod_bin_id_fk,tod_bin_name,image_url,Audio_url, Video_url, Remark, AtrRemark,
			tod_collection_status,tod_bin_entry_time,tod_bin_exit_time,tod_sequence_no,[tod_bins_to_be_collected] as tod_cnt,[tod_bins_collected] as cnt_2,0 as weight FROM reporting.trip_ongoing_details 
			WHERE tod_master_id_fk=@tom_id)AS TEMP_TABLE


			SET @count_2 = (SELECT COUNT(rowid) FROM @temp_trip_completed_details);  

				-- Initialize the iterator
				SET @K = 1

				WHILE (@K <= @count_2)
				BEGIN
			
				select @details_id=tod_id_pk from @temp_trip_completed_details where  rowid=@K
				

				

				
				INSERT INTO reporting.trip_completed_details
				SELECT tod_master_id_fk,tod_bin_id_fk,tod_bin_name,tod_collection_status,tod_bin_entry_time,
	tod_bin_exit_time,tod_sequence_no,tod_bins_to_be_collected,tod_bins_collected,image_url, Audio_url, Video_url, Remark, AtrRemark  FROM
	@temp_trip_completed_details WHERE rowid=@K;
		
		SELECT @trr_id=SCOPE_IDENTITY(); 
		
		--for doorto door skipped status
	  INSERT INTO [dbo].[bin_sensor_alert_log]([bsal_bin_loc_id],[bsal_bin_name],[bsal_longitude]
      ,[bsal_latitude] ,[bsal_date_time],[bsal_trip_id],[bsal_bin_id],[bsal_bin_skippedfull_status])
			 SELECT [rreb_bin_loc_id_fk],[rreb_bin_name],[rreb_lat],[rreb_long],dateadd(minute,330,getdate()),@trr_id,[rreb_bin_id_fk],5 
		FROM [reporting].[rfid_read_in_each_binLocation] WHERE [rreb_trip_ongoing_details_id_fk] not in (@details_id)

     INSERT INTO [reporting].[trip_completed_rfid_details] 
		SELECT [rreb_bin_loc_id_fk],[rreb_bin_id_fk],[rreb_bin_name],@trr_id,[rreb_rfid_tag],[rreb_householder_name],[rreb_dtd_bin_name],[rreb_lat],[rreb_long],[rreb_date_time] 
		FROM [reporting].[rfid_read_in_each_binLocation] WHERE [rreb_trip_ongoing_details_id_fk]=@details_id
	

	    DELETE FROM reporting.[rfid_read_in_each_binLocation] WHERE [rreb_trip_ongoing_details_id_fk] = @details_id
		SET @K = @K+1;
				END
				
			INSERT INTO reporting.trip_completed_captured_data SELECT  tocd_trip_id_fk,tocd_bin_id_fk,tocd_bin_images_url,
			tocd_bin_remarks,tocd_bin_coordinates,tod_collected_datetime FROM reporting.trip_ongoing_captured_data WHERE 
			tocd_trip_id_fk=@trip_id

			----- FOR BIN SUMMARY REPORT----------------
			--SELECT * FROM  reports.bin_summary_report
			INSERT INTO  reports.bin_summary_report 
			SELECT cfm_vehicle_no,tom_vehicle_id_fk,tom_route_id_fk,rm_route_name,(SELECT COUNT(*) FROM reporting.trip_ongoing_details WHERE tod_collection_status=1 AND tod_master_id_fk=@tom_id),
			(SELECT COUNT(*) FROM reporting.trip_ongoing_details WHERE tod_collection_status=0 AND tod_master_id_fk=@tom_id),CAST ( tom_trip_schedule_date_time AS DATE),
			rm_zone_id,rm_ward_id,cwm_ward_name,czm_zone_name,cfm_ulb_id_fk,@trip_weight as 'trip_weight' FROM reporting.trip_ongoing_master
			LEFT JOIN admin.config_fleet_master ON cfm_id_pk=tom_vehicle_id_fk LEFT JOIN garbage.route_master ON rm_id_pk=tom_route_id_fk
			LEFT JOIN admin.config_ward_master ON cwm_id_pk=rm_ward_id LEFT JOIN admin.config_zone_master ON czm_id_pk=rm_zone_id 
			WHERE tom_id_pk=@tom_id
			-----END-----------------------------------
			--------FOR BIN STATUS REPORT--------------------
			--SELECT * FROM  reports.bin_status_report
			INSERT INTO  reports.bin_status_report
			SELECT cfm_vehicle_no,tom_vehicle_id_fk,tom_route_id_fk,rm_route_name,tod_bin_name,CAST ( tom_trip_schedule_date_time AS DATE),tod_collection_status,
			rm_zone_id,rm_ward_id,cwm_ward_name,czm_zone_name,cfm_ulb_id_fk,tod_bin_entry_time,tod_bin_exit_time,tod_bin_id_fk FROM reporting.trip_ongoing_details 
			LEFT JOIN reporting.trip_ongoing_master ON tom_id_pk=tod_master_id_fk LEFT JOIN admin.config_fleet_master ON cfm_id_pk=tom_vehicle_id_fk 
			 LEFT JOIN garbage.route_master ON rm_id_pk=tom_route_id_fk LEFT JOIN admin.config_ward_master ON cwm_id_pk=rm_ward_id LEFT JOIN admin.config_zone_master ON czm_id_pk=rm_zone_id 
			 WHERE tod_master_id_fk=@tom_id
			--------END--------------------------------------
			---------FOR WEIGHT REPORT-----------------------
			--SELECT * FROM  reports.report_weight
			INSERT INTO  reports.report_weight
			SELECT cfm_ulb_id_fk,tom_vehicle_id_fk,tom_id_pk,tom_trip_schedule_date_time,tom_shift_id_fk,csm_shift_name,@trip_weight as 'trip_weight',
			tom_route_id_fk,rm_ward_id,rm_zone_id,czm_zone_name,cwm_ward_name,rm_route_name,cfm_vehicle_no
			FROM reporting.trip_ongoing_master
			LEFT JOIN admin.config_fleet_master ON cfm_id_pk=tom_vehicle_id_fk LEFT JOIN garbage.route_master ON rm_id_pk=tom_route_id_fk
			LEFT JOIN admin.config_ward_master ON cwm_id_pk=rm_ward_id LEFT JOIN admin.config_zone_master ON czm_id_pk=rm_zone_id 
			LEFT JOIN admin.config_shift_master ON csm_id_pk=tom_shift_id_fk
			WHERE tom_id_pk=@tom_id 
			----------END------------------------------------
			----------ROUTE DEVIATION------------------------
			INSERT INTO   reports.route_deviation_report
			SELECT cfm_vehicle_no,tom_vehicle_id_fk,tom_route_id_fk,rm_route_name,tod_bin_name,CAST ( tom_trip_schedule_date_time AS DATE),tom_shift_id_fk,rm_zone_id,rm_ward_id,cwm_ward_name,
			czm_zone_name,cfm_ulb_id_fk,tom_trip_id_fk FROM reporting.trip_ongoing_details 
			LEFT JOIN reporting.trip_ongoing_master ON tom_id_pk=tod_master_id_fk LEFT JOIN admin.config_fleet_master ON cfm_id_pk=tom_vehicle_id_fk 
			 LEFT JOIN garbage.route_master ON rm_id_pk=tom_route_id_fk LEFT JOIN admin.config_ward_master ON cwm_id_pk=rm_ward_id LEFT JOIN admin.config_zone_master ON czm_id_pk=rm_zone_id 
			 WHERE tod_master_id_fk=@tom_id AND tod_collection_status=0 AND 
			tod_bin_entry_time IS NULL AND tod_bin_exit_time IS NULL 			 
			
			--select @max_id=CASE WHEN max(al_id_pk) IS NULL THEN 0 ELSE max(al_id_pk) END from   [dbo].[alert_log_m2] 
			--SET @alertMsg=
			/*INSERT INTO  [dbo].[alert_log_m12] 
			(al_id_pk,[al_alert_type_fk],[al_alert_sub_type_fk],[al_vehicle_id_fk],[al_alert_msg],[al_received_date_time],[al_latitude],[al_longitude],[al_location],[al_email_status],[al_sms_status],[al_month],[al_vehicle_no],[al_alert_type],[al_sub_alert_type],[al_ulb_id_fk])
			SELECT (ROW_NUMBER() OVER ( order by tod_id_pk)+@max_id),5,0,tom_vehicle_id_fk,'Vehicle No - '+cfm_vehicle_no+' has not attended Bin Location - '+tod_bin_name+'  on '+ 
			cast(getdate() as varchar(20))+'',getdate(),0,0,tod_bin_name,0,0,12,cfm_vehicle_no,'Bin Skipped Alert','',cfm_ulb_id_fk FROM reporting.trip_ongoing_details 
			LEFT JOIN reporting.trip_ongoing_master ON tom_id_pk=tod_master_id_fk LEFT JOIN admin.config_fleet_master ON cfm_id_pk=tom_vehicle_id_fk 
			
			 WHERE tod_master_id_fk=@tom_id AND tod_collection_status=0 AND 
			tod_bin_entry_time IS NULL AND tod_bin_exit_time IS NULL */	
			
			
			---------END-------------------------------------
			DELETE FROM reporting.trip_ongoing_master WHERE tom_id_pk=@tom_id
			DELETE FROM reporting.trip_ongoing_details WHERE tod_master_id_fk=@tom_id
			DELETE FROM reporting.trip_ongoing_captured_data WHERE tocd_trip_id_fk=@trip_id
		END
		ELSE IF @trip_status=0 --CHECKING FOR PENDING TRIPS
		BEGIN
				SET @vehicle_in_time=NULL;
				SET @vehicle_out_time=NULL;
				SET @is_in=0;
				update [garbage].[gis_garbage_collection_points] set [ggcf_vehicle_id] =(SELECT tom_vehicle_id_fk FROM 
					@temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) where [ggcf_points_id_pk] IN (SELECT [tod_bin_id_fk] FROM [reporting].[trip_ongoing_details] WHERE [tod_master_id_fk]=@tom_id)

				IF (SELECT tom_notify_status FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) >= 0 AND
				(SELECT CAST(tom_trip_schedule_date_time AS DATE) FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) = CAST(GETDATE() AS DATE)
				BEGIN
					SELECT TOP 1 @vehicle_out_time=vios_vehicle_out_time,@is_in=vios_is_in 
					FROM  dbo.vehicle_in_out_status WHERE vios_vehicle_id_fk=(SELECT tom_vehicle_id_fk FROM 
					@temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)
					AND vios_fence_type =(SELECT tom_start_loc_type FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) AND vios_fence_id=(SELECT tom_start_location FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) AND 
					vios_vehicle_out_time>(SELECT DATEADD(MINUTE,-30,tom_trip_schedule_date_time) FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)  ORDER BY vios_vehicle_in_time
					--SELECT DATEADD(MINUTE,-30,CURRENT_TIMESTAMP)
					IF @vehicle_out_time IS NOT NULL 
					BEGIN
						UPDATE reporting.trip_ongoing_master SET tom_trip_status=1,tom_start_date_time=@vehicle_out_time WHERE 
						tom_id_pk=@tom_id
						UPDATE scheduling.schedule_trip_master SET stm_status=1 WHERE stm_id_pk=@trip_id
					END 
					ELSE
					BEGIN
						select @end_date_time=max(tcm_end_date_time) from reporting.trip_completed_master where cast(tcm_trip_date_time as date)=cast(getdate() as date) and [tcm_vehicle_id_fk]=(SELECT tom_vehicle_id_fk FROM 
					@temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)

					if @end_date_time is null
					begin
						SELECT TOP 1 @vehicle_out_time=vios_vehicle_out_time,@is_in=vios_is_in,@fence_id=vios_fence_id ,@vehicle_in_time=vios_vehicle_in_time
					FROM  dbo.vehicle_in_out_status WHERE vios_vehicle_id_fk=(SELECT tom_vehicle_id_fk FROM 
					@temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)
					AND vios_fence_type =1 AND vios_fence_id IN (SELECT [tod_bin_id_fk] FROM [reporting].[trip_ongoing_details] WHERE [tod_master_id_fk]=@tom_id) AND 
					vios_vehicle_out_time>(SELECT DATEADD(MINUTE,-30,tom_trip_schedule_date_time) FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)  ORDER BY vios_vehicle_in_time

					end
					else
					begin
					SELECT TOP 1 @vehicle_out_time=vios_vehicle_out_time,@is_in=vios_is_in,@fence_id=vios_fence_id ,@vehicle_in_time=vios_vehicle_in_time
					FROM  dbo.vehicle_in_out_status WHERE vios_vehicle_id_fk=(SELECT tom_vehicle_id_fk FROM 
					@temp_trip_ongoing_master WHERE tom_id_pk=@tom_id)
					AND vios_fence_type =1 AND vios_fence_id IN (SELECT [tod_bin_id_fk] FROM [reporting].[trip_ongoing_details] WHERE [tod_master_id_fk]=@tom_id) AND 
					vios_vehicle_out_time>(SELECT DATEADD(MINUTE,-30,tom_trip_schedule_date_time) FROM @temp_trip_ongoing_master WHERE tom_id_pk=@tom_id) and vios_vehicle_out_time>@end_date_time ORDER BY vios_vehicle_in_time
					end
						IF @vehicle_out_time IS NOT NULL 
						BEGIN
							UPDATE reporting.trip_ongoing_master SET tom_trip_status=1,tom_start_date_time=@vehicle_out_time WHERE 
						tom_id_pk=@tom_id
							UPDATE scheduling.schedule_trip_master SET stm_status=1 WHERE stm_id_pk=@trip_id;

							UPDATE reporting.trip_ongoing_details SET tod_bin_entry_time=@vehicle_in_time,tod_bin_exit_time=@vehicle_out_time,tod_collection_status=3 
						WHERE tod_bin_id_fk=@fence_id and tod_master_id_fk=@tom_id
						update [garbage].[gis_garbage_collection_points] set [ggcf_bin_collection_status] =3 --,[ggcf_last_collected_date]=@vehicle_in_time 
						where [ggcf_points_id_pk] =@fence_id and [ggcf_bin_collection_status]<>1 and [Bin_type_id]<>1 

						update [admin].[config_bin_sensor_master] set [cbsm_collection_status]=3 where cbsm_bin_loc_id=@fence_id and [cbsm_collection_status]<>1 
						END 

					END

					
					END
		END
		SET @I=@I+1
	END 
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	--select * from  reporting.trip_ongoing_master where tom_id_pk=3023
	/*SELECT * FROM  reporting.trip_ongoing_details
	SELECT * FROM  reporting.trip_ongoing_captured_data
	update  reporting.trip_ongoing_captured_data set tocd_trip_id_fk=2020
	select * from  dbo.vehicle_in_out_status
    -- Insert statements for procedure here
	14468
	
	update  reporting.trip_ongoing_master set tom_trip_status=2 where tom_id_pk=10502
	1	ijulj
	INSERT INTO  dbo.vehicle_in_out_status (vios_vehicle_no,vios_vehicle_in_time,vios_fence_type,vios_fence_name,
				vios_fence_id,vios_vehicle_id_fk,vios_is_in) VALUES('qwerty',CURRENT_TIMESTAMP,'1','test',2,
				1078,1)*/
				--UPDATE  dbo.vehicle_in_out_status SET vios_vehicle_out_time=CURRENT_TIMESTAMP where vios_id_pk=4
	RETURN;
	
END;

GO
/****** Object:  StoredProcedure [dbo].[update_Weight_dash ]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[update_Weight_dash ]
	
	@ulbid int
AS
BEGIN
	SET NOCOUNT ON;
	
	 select (select count(*) as count  from (select count(*) as weightCount from [reports].[dump_weight_details] where  gross_weight_stable=1 and net_weight_stable=1 group by  cast ([dwd_updated_date] as date)) as z) as count,(select sum([dwd_disposed_weight]) as tillYersterday from [reports].[dump_weight_details] where  cast ([dwd_updated_date] as date) !=CAST(GETDATE() AS DATE) and  gross_weight_stable=1 and net_weight_stable=1) as tillYersterday,BinTotal,CollectedBin,attntCollectedBin,BinTotal-(CollectedBin+attntCollectedBin) as ntCollectedBin,case when Binweight is null then 0 else Binweight end as Binweight,case when avgBinweight is null then 0 else avgBinweight end as avgBinweight ,veh_count
   from(select sum([ggcf_points_count]) BinTotal,sum(case when [ggcf_bin_collection_status]=1 then [ggcf_collected_bins] 
   else 0 end)CollectedBin,sum(case when [ggcf_bin_collection_status]=3 then [ggcf_points_count] else 0 end) attntCollectedBin,
--(select sum(tcm_weight_disposed) from  reporting.trip_completed_master where CAST(tcm_start_date_time AS DATE)=CAST(GETDATE() AS DATE)   ) as Binweight,
(select sum(CASE WHEN  dwd_disposed_weight IS NULL or [net_weight_stable]=0 THEN 0 ELSE dwd_disposed_weight END) from  [reports].[dump_weight_details] where CAST(dwd_updated_date AS DATE)=CAST(GETDATE() AS DATE)   ) as Binweight,
(select round(avg(dwd_disposed_weight),3) from [reports].[dump_weight_details] where gross_weight_stable=1 and net_weight_stable=1 and cast([dwd_updated_date] as date)=CAST(GETDATE() AS DATE)  ) as avgBinweight,
--(select count(distinct tcm_vehicle_id_fk ) from  reporting.trip_completed_master where CAST(tcm_start_date_time AS DATE)=CAST(GETDATE() AS DATE)  and tcm_weight_disposed>0) as veh_count
(select count(distinct dwd_vehicle_id_fk) from [reports].[dump_weight_details] where CAST(dwd_updated_date AS DATE)=CAST(GETDATE() AS DATE) and net_weight_stable=1) as veh_count
from  [garbage].[gis_garbage_collection_points] where ggcf_ulb_id_fk=@ulbid
) as t1

END


GO
/****** Object:  StoredProcedure [dbo].[update_Weight_dash2 ]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[update_Weight_dash2 ]
	
	@ulbid int
AS
BEGIN
	SET NOCOUNT ON;
	
	 select (select count(*) as count  from (select count(*) as weightCount from [reports].[dump_weight_details] group by  cast ([dwd_updated_date] as date)) as z) as count,BinTotal,CollectedBin,attntCollectedBin,BinTotal-(CollectedBin+attntCollectedBin) as ntCollectedBin,case when Binweight is null then 0 else Binweight end as Binweight,case when avgBinweight is null then 0 else avgBinweight end as avgBinweight ,veh_count
   from(select sum([ggcf_points_count]) BinTotal,sum(case when [ggcf_bin_collection_status]=1 then [ggcf_collected_bins] 
   else 0 end)CollectedBin,sum(case when [ggcf_bin_collection_status]=3 then [ggcf_points_count] else 0 end) attntCollectedBin,
--(select sum(tcm_weight_disposed) from  reporting.trip_completed_master where CAST(tcm_start_date_time AS DATE)=CAST(GETDATE() AS DATE)   ) as Binweight,
(select sum(CASE WHEN  dwd_disposed_weight IS NULL or [net_weight_stable]=0 THEN 0 ELSE dwd_disposed_weight END) from  [reports].[dump_weight_details] where CAST(dwd_updated_date AS DATE)=CAST(GETDATE() AS DATE)   ) as Binweight,
(select round(avg(dwd_disposed_weight),3) from [reports].[dump_weight_details] where gross_weight_stable=1 and net_weight_stable=1 and cast([dwd_updated_date] as date)=CAST(GETDATE() AS DATE)  ) as avgBinweight,
--(select count(distinct tcm_vehicle_id_fk ) from  reporting.trip_completed_master where CAST(tcm_start_date_time AS DATE)=CAST(GETDATE() AS DATE)  and tcm_weight_disposed>0) as veh_count
(select count(distinct dwd_vehicle_id_fk) from [reports].[dump_weight_details] where CAST(dwd_updated_date AS DATE)=CAST(GETDATE() AS DATE) and net_weight_stable=1) as veh_count
from  [garbage].[gis_garbage_collection_points] where ggcf_ulb_id_fk=@ulbid
) as t1

END

GO
/****** Object:  StoredProcedure [dbo].[updateAction]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[updateAction]
(
 @complid nvarchar(20),
 @assigned_userid  nvarchar(10),
 @assigned_time nvarchar(100),
 @action_status nvarchar(4),
 @usertype nvarchar(4),
 @ward nvarchar(1500),
 @zone nvarchar(50),
 @ulb nvarchar(50)
) 
As
 Begin
 SET NOCOUNT ON;
  Declare @staff_type nvarchar(5);
 set @staff_type=(SELECT cmum_user_type FROM admin.config_mobile_user_master WHERE cmum_id_pk = @assigned_userid);
 update citizen.citizen_complaints_action_status set ccas_action_status=@action_status where ccas_cc_id_fk=@complid;
 if(@action_status=1)
 begin
 insert into citizen.citizen_complaints_action_status(ccas_cc_id_fk,ccas_assigned_user,ccas_assigned_time,ccas_action_status,ccas_user_type,ccas_complaint_ward_id_fk,ccas_complaint_zone_id_fk,ccas_ulb_id_fk)
							values(@complid,@assigned_userid,convert(datetime,@assigned_time,103),@action_status,@staff_type,@ward,@zone,@ulb);
end
else
begin 
update citizen.citizen_complaints_action_status set ccas_action_status=@action_status,ccas_action_time=convert(datetime,@assigned_time,103) where ccas_cc_id_fk=@complid;
end
 End
 SELECT @@ROWCOUNT as status;

GO
/****** Object:  StoredProcedure [dbo].[vehicle_trip_status]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[vehicle_trip_status] 
      
	@userid int  
	     
AS
BEGIN
SET NOCOUNT ON;

with dateRange as (select dt = dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0)))
						   		 where dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE()
						   		 union all select dateadd(dd, 1, dt) from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
						   		 select sum (case when stm_vheicle_id_fk = cfm_id_pk then 1 else 0 end) as total_trip_status_count,
						   		 SUM (case when stm_status = 0 and stm_vheicle_id_fk = cfm_id_pk then 1 else 0 end) pending, 
						   		 SUM (case when stm_status = 1 and stm_vheicle_id_fk = cfm_id_pk then 1 else 0 end) ongoing, 
						   		 SUM (case when stm_status = 2 and stm_vheicle_id_fk = cfm_id_pk then 1 else 0 end) completed, FORMAT( dt,'dd-MM-yyyy')  as stm_date_time 
						   		 from dateRange left join  [scheduling].[schedule_trip_master] 
						   		 on CONVERT(date, stm_date_time)=dt left join  [admin].[config_fleet_master] 
						   		 on stm_vheicle_id_fk = cfm_id_pk AND stm_vheicle_id_fk in (select *  from  dbo.fnSplitString(( select um.cum_assign_fleet 
						   		 from  admin.config_user_master um where um.cum_id_pk= @userid),',')) group by dt order by dt		
END

GO
/****** Object:  StoredProcedure [dbo].[vehicleMaintenanceForSupevisior]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[vehicleMaintenanceForSupevisior]

@ulbid int,
@zoneId int,
@wardId int,
@statusId int,
@fromDate varchar(50),
@endate varchar(50)


   
AS
BEGIN


SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

if @statusId=1

select  SUM(case when vmr_status = 1 then 1 else 0 end) break_down_count,((select count(*) 
as vehicle_count FROM admin.config_fleet_master where cfm_ulb_id_fk = @ulbid
and cfm_vehicle_available_status = 1) - SUM(case when vmr_status = 1 then 1 else 0 end)) working,
cast(vmr_datetime as date) as date from [reports].[vehicle_maintenance_report] where vmr_ulb_id_fk=@ulbid and 
(cast(vmr_datetime as date) between @fromDate and @endate)  group by cast(vmr_datetime as date)




if @statusId=2

select  SUM(case when vmr_status = 1 then 1 else 0 end) break_down_count,((select count(*) 
as vehicle_count FROM admin.config_fleet_master where cfm_ulb_id_fk = @ulbid and cfm_zone_id=@zoneId
and cfm_vehicle_available_status = 1) - SUM(case when vmr_status = 1 then 1 else 0 end)) working,
cast(vmr_datetime as date) as date from [reports].[vehicle_maintenance_report] where vmr_ulb_id_fk=@ulbid and 
(cast(vmr_datetime as date) between @fromDate and @endate)  group by cast(vmr_datetime as date)



if @statusId=3

select  SUM(case when vmr_status = 1 then 1 else 0 end) break_down_count,((select count(*) 
as vehicle_count FROM admin.config_fleet_master where cfm_ulb_id_fk = @ulbid and cfm_zone_id=@zoneId and cfm_ward_id=@wardId
and cfm_vehicle_available_status = 1) - SUM(case when vmr_status = 1 then 1 else 0 end)) working,
cast(vmr_datetime as date) as date from [reports].[vehicle_maintenance_report] where vmr_ulb_id_fk=@ulbid and 
(cast(vmr_datetime as date) between @fromDate and @endate)  group by cast(vmr_datetime as date)






COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	
	  END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[vehicleTripAvailabilityForSupevisior]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[vehicleTripAvailabilityForSupevisior]

@ulbid int,
@zoneId int,
@wardId int,
@statusId int,
@fromDate varchar(50),
@endDate varchar(50)


   
AS
BEGIN


SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

if @statusId=1

 select count(distinct( stm_vheicle_id_fk)) as assingedVehicle, count(distinct( cfm_id_pk)) as total,count(distinct( cfm_id_pk))-count(distinct( stm_vheicle_id_fk))
  as unassignedVehicle , cast (stm_date_time as date) as date from scheduling.schedule_trip_master  
  left join  [admin].[config_fleet_master] on stm_vheicle_id_fk = cfm_id_pk where  cfm_ulb_id_fk = @ulbid
  and  cast (stm_date_time as date) between @fromDate and @endDate 
   group by cast (stm_date_time as date)


if @statusId=2

 select count(distinct( stm_vheicle_id_fk)) as assingedVehicle, count(distinct( cfm_id_pk)) as total,count(distinct( cfm_id_pk))-count(distinct( stm_vheicle_id_fk))
  as unassignedVehicle , cast (stm_date_time as date) as date from scheduling.schedule_trip_master  
  left join  [admin].[config_fleet_master] on stm_vheicle_id_fk = cfm_id_pk where  cfm_ulb_id_fk = @ulbid
  and  cast (stm_date_time as date) between @fromDate and @endDate and [cfm_zone_id]=@zoneId
   group by cast (stm_date_time as date)


if @statusId=3

 select count(distinct( stm_vheicle_id_fk)) as assingedVehicle, count(distinct( cfm_id_pk)) as total,count(distinct( cfm_id_pk))-count(distinct( stm_vheicle_id_fk))
  as unassignedVehicle , cast (stm_date_time as date) as date from scheduling.schedule_trip_master  
  left join  [admin].[config_fleet_master] on stm_vheicle_id_fk = cfm_id_pk where  cfm_ulb_id_fk = @ulbid
  and  cast (stm_date_time as date) between @fromDate and @endDate and [cfm_zone_id]=@zoneId and [cfm_ward_id]=@wardId
   group by cast (stm_date_time as date)





COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	
	  END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[WorkforceBinCollectionByCEP]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[WorkforceBinCollectionByCEP]

@tripid int,
@fleetId int
   
AS
BEGIN

Declare @status Bit
Declare @taskId int
Declare @count int
SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

select @taskId=tom_id_pk from [reporting].[trip_ongoing_master] where tom_trip_id_fk=@tripid

update [reporting].[trip_ongoing_details] set tod_collection_status='1',tod_bins_collected=tod_bins_to_be_collected,tod_bin_entry_time=CURRENT_TIMESTAMP  where  tod_bin_id_fk=@taskId and tod_master_id_fk=@tripid

SELECT @count=COUNT(*) FROM reporting.trip_ongoing_captured_data where tocd_trip_id_fk=@tripid and tocd_bin_id_fk=@taskId

if @count=0
begin
insert into reporting.trip_ongoing_captured_data(tocd_trip_id_fk,tocd_bin_id_fk,tocd_bin_coordinates,tod_collected_datetime)  values (@tripid,@taskId,'',CURRENT_TIMESTAMP)
end

else
begin
update reporting.trip_ongoing_captured_data set tod_collected_datetime=CURRENT_TIMESTAMP where tocd_trip_id_fk= @taskId and tocd_bin_id_fk=@taskId
end


Set @status=1
SELECT @status AS status,'Bin Status updated successful' AS message

COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	 set @status=0
	 SELECT @status AS status,ERROR_MESSAGE() AS message
	  END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[WorkforceTripEndByCEP]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[WorkforceTripEndByCEP]

@tripid int,
@macID varchar(250),
@alertTime datetime

   
AS
BEGIN

Declare @status Bit;
DECLARE @fleetid int;
Declare @count int;

SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

select @fleetid=[cfm_id_pk] from  [admin].[config_fleet_master] where [macAddress]=@macID

update [dbo].[view_online_master] set [vom_trip_id]=@tripid where [vom_vehicle_id]=@fleetId

update reporting.trip_ongoing_master set tom_end_date_time=@alertTime  , tom_trip_status='2' where tom_trip_id_fk=@tripid

update scheduling.schedule_trip_master set stm_status='2' where stm_id_pk=@tripid

select @count=count(*) from [admin].[config_mobile_user_master] left join  [admin].[config_fleet_master] on [cfm_id_pk]=[cmum_vehicle_id] where [cmum_vehicle_id]=@fleetid

if @count>0
begin
set @status=1
 select @status as workForceStatus ,cmum_workforce_id_fk as workforceUserId from  [scheduling].[schedule_trip_master] left join [admin].[config_mobile_user_master] on [stm_vheicle_id_fk] = cmum_vehicle_id where [stm_id_pk]=@tripid
 end

if @count=0
begin
set @status=0
select @status as workForceStatus , 0 as workforceUserId
end


COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	
	
	  END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[WorkforceTripStart]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[WorkforceTripStart]
 
     
AS
BEGIN
Declare @status Bit

SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY


COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	 set @status=0
	 SELECT @status AS status,ERROR_MESSAGE() AS message
	  END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[WorkforceTripStartByCEP]    Script Date: 12-04-2021 18:30:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[WorkforceTripStartByCEP]

@tripid int,
@macID varchar(250),
@alertTime datetime
   
AS
BEGIN

Declare @status Bit;
DECLARE @fleetid int;
Declare @count int;


SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

select @fleetid=[cfm_id_pk] from  [admin].[config_fleet_master] where [macAddress]=@macID



update [dbo].[view_online_master] set [vom_trip_id]=@tripid where [vom_vehicle_id]=@fleetId

update reporting.trip_ongoing_master set tom_start_date_time= @alertTime, tom_trip_status='1' where tom_trip_id_fk=@tripid

update scheduling.schedule_trip_master set stm_status='1'  where stm_id_pk=@tripid


select @count=count(*) from [admin].[config_mobile_user_master] left join  [admin].[config_fleet_master] on [cfm_id_pk]=[cmum_vehicle_id] where [cmum_vehicle_id]=@fleetid
print @count

if @count>0
begin
set @status=1
 select @status as workForceStatus ,cmum_workforce_id_fk as workforceUserId from  [scheduling].[schedule_trip_master] left join [admin].[config_mobile_user_master] on [stm_vheicle_id_fk] = cmum_vehicle_id where [stm_id_pk]=@tripid
 end

if @count=0
begin
set @status=0
select @status as workForceStatus , 0 as workforceUserId
end





COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	
	 
	  END CATCH
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo].[InsertSurvelliceAlertsToDB]'1970-01-19','gatewayuuid','Bangaluru','14','13.11851','80.29736','CP_Box1_GM_Pet','CP Box1 GM Pet',''
CREATE OR ALTER PROCEDURE [dbo].[InsertSurvelliceAlertsToDB] 
      
@alertTime datetime,
@deviceId varchar(250),
@tenantcode varchar(350),
@alertype int,
@lat varchar(250),
@lon varchar(250),
@location varchar(250),
@devicdName varchar(250),
@imgUrl varchar(300)

AS
BEGIN
SET NOCOUNT ON;
DECLARE @countMac int;
DECLARE @alertName varchar(250);
DECLARE @deviceLat float;
DECLARE @deviceLon float;
DECLARE @binLocId int;
DECLARE @deviceTenantCode varchar(250);
DECLARE @deviceULB int;

set @binLocId=null

 

select @countMac=count(*) from [admin].[DeviceManagementDetails] where [DeviceMacaddress]=@deviceId

if @countMac=1
begin

select @alertName=[cat_type] from [admin].[config_alert_type] where [cat_id_pk]=@alertype

    select @deviceLat= [DeviceLatitude] ,@deviceLon=[DeviceLongtitude] ,@deviceTenantCode= [DeviceTanentCode],@deviceULB=[DeviceULbID] from [admin].[DeviceManagementDetails] where [DeviceMacaddress]=@deviceId
	  
    select top (1) @binLocId=[ggcf_points_id_pk]  from [garbage].[gis_garbage_collection_points] where [ggcf_ulb_id_fk]=@deviceULB and [the_fence_geom].STBuffer(.00050).STContains(geometry::Point(@deviceLon,@deviceLat,4326))=1

insert into [admin].[config_alerts_recived_log] (
       [arl_alert_type_fk]
      ,[arl_received_date_time]
      ,[arl_latitude]
      ,[arl_longitude]
	  ,[arl_alert_type]
	  ,[arl_Tenant_Code]
	  ,[arl_location]
	  ,[arl_vehicle_no]
	  ,[arl_binloc_id]
	  ,[arl_ulb_id_fk]
	  ,[arl_uuid]
	  ,[arl_img_url]
	  
      ) values(@alertype,CURRENT_TIMESTAMP,@lat,@lon,@alertName,@deviceTenantCode,@location,@devicdName,@binLocId,@deviceULB,@deviceId,@imgUrl) 
	  end

	  

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [dbo].[ChatbotSupervisorDetails] 13.0210896554153, 77.571997163727
CREATE OR ALTER PROCEDURE [dbo].[ChatbotSupervisorDetails] 
      

@latitude float,
@longitude float


AS
BEGIN
SET NOCOUNT ON;

DECLARE @count int;
Declare @status Bit;
declare @SupervisorName varchar(30);
declare @phno varchar(30);
declare @address varchar(100);
declare @email varchar(30);


BEGIN TRAN
BEGIN TRY

select @count=count(*) from [admin].[config_staff_master] 
   where [cssm_id_pk] =(select top 1 [cwm_id_pk] from [admin].[config_ward_master] where [cwm_geometry].STContains(geometry::Point(@longitude,@latitude,4326))=1)
 
 if @count>0
 begin
 set @status=1 

 select  top 1 @SupervisorName=[cssm_staff_name],@phno=[cssm_phone_no] ,@address=[cssm_address],@email=[cssm_email_id]  from [admin].[config_staff_master] 
   where [cssm_id_pk] =(select top 1 [cwm_id_pk] from [admin].[config_ward_master] where [cwm_geometry].STContains(geometry::Point(@longitude,@latitude,4326))=1)
  
  select @SupervisorName as SupervisorName,@phno as phno,@address as address,@email as email, @status as Status
 end

 else
 begin
 set @status=0 
 select  @status as Status,'There are no Supervisors assigned to this location' as 'message'
 end

COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	 set @status=0
	 SELECT @status AS status,ERROR_MESSAGE() AS message
	  END CATCH


END

------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [dbo].[ChatbotRequestForScheduletime] 12.998739959127, 77.6279218389409
CREATE or ALTER PROCEDURE [dbo].[ChatbotRequestForScheduletime] 
      

@latitude float,
@longitude float


AS
BEGIN
SET NOCOUNT ON;

DECLARE @tripDayCount int;
DECLARE @count int;
Declare @status Bit
declare @shiftTime int
BEGIN TRAN
BEGIN TRY

select  @count=count(*) from garbage.gis_garbage_collection_points 
 WHERE (SQRT(power((69.1 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STX) -@longitude)) , 2 ) +power((53 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]),
  4326).STY) - @latitude)), 2)) * 1609 between 0 and 100)	 
  
 select @tripDayCount=count(*)
	 from [reporting].[trip_ongoing_details]  left join [reporting].[trip_ongoing_master] on tom_id_pk=[tod_master_id_fk] 
	 left join admin.config_fleet_master on cfm_id_pk=tom_vehicle_id_fk left join [admin].[config_shift_master] on cfm_shift_type=[csm_id_pk]
	where [tod_bin_id_fk]=(select  TOP 1 [ggcf_points_id_pk] from garbage.gis_garbage_collection_points 
 WHERE (SQRT(power((69.1 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STX) -@longitude)) , 2 ) +power((53 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]),
  4326).STY) - @latitude)), 2)) * 1609 between 0 and 100)) and cast([tom_trip_schedule_date_time] as date)=cast(getdate() as date) 

  
 if @count>0 and @tripDayCount>0
 begin
   select @shiftTime=cfm_shift_type
	 from [reporting].[trip_ongoing_details]  left join [reporting].[trip_ongoing_master] on tom_id_pk=[tod_master_id_fk] 
	 left join admin.config_fleet_master on cfm_id_pk=tom_vehicle_id_fk left join [admin].[config_shift_master] on cfm_shift_type=[csm_id_pk]
	where [tod_bin_id_fk]=(select  TOP 1 [ggcf_points_id_pk] from garbage.gis_garbage_collection_points 
 WHERE (SQRT(power((69.1 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STX) -@longitude)) , 2 ) +power((53 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]),
  4326).STY) - @latitude)), 2)) * 1609 between 0 and 100)) and cast([tom_trip_schedule_date_time] as date)=cast(getdate() as date) 

  if @shiftTime=1
  begin
   Set @status=1
  SELECT @status AS status, 'Garbage pickup schedule timings for a location is between 6 AM to 5 PM' AS message
   

  end

  if @shiftTime=2
   begin
    Set @status=1
  SELECT @status AS status, 'Garbage pickup schedule timings for a location is between 9 PM to 5 AM' AS message
  
  end



end   

if @count=0 or @tripDayCount=0
begin
  Set @status=1
if @count=0
  SELECT @status AS status,'There are no Bin Locations near the provided location' AS message



else if @tripDayCount=0

  SELECT @status AS status, 'There are no trips Scheduled today for this location' AS message
 

end

COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	 set @status=0
	 SELECT @status AS status,ERROR_MESSAGE() AS message
	  END CATCH


END


-----------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [dbo].[ChatbotNearestBin] '13.0210896554153', '77.571997163727'
CREATE OR ALTER PROCEDURE [dbo].[ChatbotNearestBin] 
      

@latitude varchar(50),
@longitude varchar(50)


AS
BEGIN
SET NOCOUNT ON;

DECLARE @count int;
Declare @status Bit;
Declare @meter int;
Declare @lat varchar(50);
Declare @lon varchar(50);
Declare @address varchar(200);
declare @binLocName varchar(200);
declare @zoneName varchar(50);
declare @warName varchar(50);


BEGIN TRAN
BEGIN TRY
 
 set @status=1 

select @count=count(*) from garbage.gis_garbage_collection_points left join admin.config_zone_master on ggcf_zone_id=czm_id_pk left join admin.config_ward_master on ggcf_ward_id=cwm_id_pk
 WHERE (SQRT(power((69.1 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STY) -@latitude)) , 2 ) +power((53 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STX) - @longitude)), 2)) * 1609 between 0 and 1000)
  

if   @count>0
begin

set @status=1

select TOP 1 @address=ggcf_points_address ,@binLocName=ggcf_points_name,@zoneName=czm_zone_name,@warName=cwm_ward_name,@lat=the_geom.STY ,@lon=the_geom.STX 
from garbage.gis_garbage_collection_points left join admin.config_zone_master on ggcf_zone_id=czm_id_pk left join admin.config_ward_master on ggcf_ward_id=cwm_id_pk
 WHERE (SQRT(power((69.1 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STY) -@latitude)) , 2 ) +power((53 * ((geometry::STGeomFromText(CONVERT(nvarchar(50),[the_geom]), 4326).STX) - @longitude)), 2)) * 1609 between 0 and 1000)

 DECLARE @source geography ='POINT ('+ @latitude+' '+@longitude +')' DECLARE @target geography ='POINT ('+ @lat+' '+@lon +')' SELECT @meter=cast(@source.STDistance(@target) as int)

 --select time/60 as min from (select (@meter)/1 as time) as t1 

 select  @status as Status ,@address as bin_location_address,@binLocName as bin_location , @zoneName as zone_name , @warName as ward_name ,@lat as lat , @lon as lon,(select time/60 as min from (select (@meter)/1 as time) as t1) as min

end
 
 else
 begin
 set @status=0;
 select @status as Status , 'Location Given Is Not Near To Bin Location' as 'Message' 
 end
 

COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	 set @status=0
	 SELECT @status AS status,ERROR_MESSAGE() AS message
	  END CATCH


END


-----------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec[dbo].[BinCollectionRfidNotRequired] 20450,13,'2020-09-14 17:24:00:000'
CREATE OR ALTER PROCEDURE [dbo].[BinCollectionRfidNotRequired]

@tripid int,
@binlocid int,
@alertTime datetime  
AS
BEGIN
SET NOCOUNT ON;
Declare @status Bit;

DECLARE @tomidpk int;
DECLARE @count int,@I int,@count_1 int;

DECLARE @todidpk int;
DECLARE @insertIntoReeb table(rowid INT,rfidNo varchar(50),binLocId int,binidPk int,BinIdName varchar(50),todIdPk int,todMasterId int);
DECLARE @strRfid varchar(75),@StrbinId int,@strBinLocID int,@strBinName varchar(75),@strTodIdPk int,@strTodMasterId int,@collectionCount int;


BEGIN TRAN
BEGIN TRY
		select @tomidpk=tom_id_pk from [reporting].[trip_ongoing_master] where tom_trip_id_fk=@tripid;

	print @tomidpk


		--------RFID procedure-------------

		 UPDATE [garbage].[gis_garbage_collection_points] SET [ggcf_bin_collection_status]=1,[ggcf_last_collected_date]=@alertTime WHERE [ggcf_points_id_pk]=@binlocid

		 UPDATE [admin].[config_bin_sensor_master] SET cbsm_bin_sensor_capasity=0,cbsm_bin_full_status=0,cbsm_check_count=0,cbsm_collection_status=1,[cbsm_collected_time]=@alertTime WHERE [cbsm_bin_loc_id]= @binlocid

		 INSERT INTO @insertIntoReeb select row_number() over( order by cbm_id_pk),[crm_rfid_no],cbm_bin_loc_id,[cbm_id_pk],[cbm_bin_name],tod_id_pk,tod_master_id_fk from [admin].[config_bin_master]  left join [admin].[config_rfid_master] on [crm_bin_id] = [cbm_id_pk] inner join [reporting].[trip_ongoing_details] on [tod_bin_id_fk]=[cbm_bin_loc_id] where cbm_bin_loc_id=@binlocid
			 and [tod_master_id_fk]= @tomidpk

		
			

			SET @count_1 = (SELECT COUNT(*) FROM @insertIntoReeb);
			
			SET @I = 1;
		
			WHILE (@I <= @count_1)
			
			BEGIN
		
				SELECT @strRfid=rfidNo,@strBinLocID=binLocId,@StrbinId=binidPk,@strBinName=BinIdName,@strTodIdPk=todIdPk,@strTodMasterId=todMasterId  FROM @insertIntoReeb WHERE rowid=@I
		
		select @collectionCount=count(*) from reporting.rfid_read_in_each_binLocation where rreb_trip_ongoing_details_id_fk=@strTodIdPk and rreb_bin_loc_id_fk=@binlocid and rreb_bin_id_fk=@StrbinId
	
		if @collectionCount=0
		  begin
				INSERT INTO  reporting.rfid_read_in_each_binLocation (rreb_rfid_tag,rreb_bin_loc_id_fk,rreb_bin_id_fk,rreb_bin_name,rreb_trip_ongoing_details_id_fk, rreb_date_time)
					VALUES (@strRfid,@strBinLocID,@StrbinId,@strBinName,@strTodIdPk, @alertTime)
          end 
        else 
		  begin
		      update reporting.rfid_read_in_each_binLocation set [rreb_date_time]=@alertTime where rreb_trip_ongoing_details_id_fk=@strTodIdPk and rreb_bin_loc_id_fk=@binlocid
		  end
       

				SET @I = @I+1;
			End



set @status=1
select @status as status  




COMMIT TRAN
END TRY

 BEGIN CATCH
 ROLLBACK TRAN
	
END CATCH
END
---------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [dbo].[DTDSkippedAlertPush]

CREATE OR ALTER PROCEDURE [dbo].[DTDSkippedAlertPush]

   
AS
BEGIN
DECLARE @tripId int,@status bit,@macID varchar(100),@tenantCode varchar(100);

BEGIN TRAN
BEGIN TRY

select @tripId=[tcm_trip_id_fk] ,@macID=[macAddress], @tenantCode=cfm_ulb_code  from [reporting].[trip_completed_master] 
left join [admin].[config_fleet_master] on [cfm_id_pk]=[tcm_vehicle_id_fk] left join [scheduling].[schedule_trip_master] on [tcm_trip_id_fk]=[stm_id_pk] where
 cast([tcm_trip_date_time] as Date)=cast(getdate() as Date) and tcm_route_type=1  and notifyICCC=0


  select GETUTCDATE() as alertTime,@tenantCode as tenantCode, @tripId as tripId,@macID as macId, [crm_rfid_no] as QRCode,[cbm_person_name] as houseOwner,
  [cbm_house_no] houseNo,[crm_bin_lat] as lat,[crm_bin_long] as lon from [admin].[config_rfid_master] left join
  [admin].[config_bin_master] on [cbm_id_pk]=[crm_bin_id] left join [garbage].[gis_road_area] on [gra_id_pk]=[crm_bin_loc_id_fk]
   where [TripId]=@tripId and [crm_bin_collection_status]=0

   update [scheduling].[schedule_trip_master] set notifyICCC=1 where [stm_id_pk]=@tripId




COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	 SELECT ERROR_MESSAGE() AS message
	  END CATCH
END
-----------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or ALTER PROCEDURE [dbo].[analytics_predictiveBinInsertion] 
	@datatime varchar(150),  
	@binId int,  
	@hour int,
	@binVolumne FLOAT
	    	
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

DECLARE @binName varchar(150),@binLocationId int,@binLat float,@binLon float,@alertPick bit,@wardId int

select @binName=[cbm_bin_name],@binLocationId=[cbm_bin_loc_id],@wardId=[cbm_ward_id],@binLat=[cbsm_bin_latitude],@binLon=[cbsm_bin_longitude]
 from [admin].[config_bin_master] left join [admin].[config_bin_sensor_master] on [cbm_id_pk]=[cbsm_bin_id] where [cbm_id_pk]=@binId

 set @alertPick=0
 if @binVolumne>90
 begin
  set  @alertPick=1
 end

INSERT INTO [analytics].[bin_sensor_predictive_alert_new] 
(bspa_DateTime,bspa_Bin_ID,bspa_Predicted_Volume,bspa_bin_name,bspa_ward_id,bspa_bin_location_id,bspa_lat,bspa_lon,bspa_hour,bspa_Predicted_Pick_Up_Alert)
VALUES (@datatime,@binId,@binVolumne,@binName,@wardId,@binLocationId,@binLat,@binLon,@hour,@alertPick)

 SELECT 'true' AS status,'Successfull insertion' AS message

COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	SELECT 'false' AS status,ERROR_MESSAGE() AS message
	 
	  END CATCH

END;

-------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE  [dbo].[insert_citizen_complaint_web] 
@name varchar(200),
@email varchar(200),
@address varchar(1000),
@phoneNo varchar(20),
@wardId int,
@zoneId int,
@complaintTypeId int,
@complaintMode int,
@pointValue varchar(2000),
@priority int,
@complaintDateTime datetime,
@ulbId int,
@incidentId varchar(50),
@images varchar(4000),
@description varchar(2000)

AS

BEGIN
SET NOCOUNT ON;
DECLARE @status int;
BEGIN TRAN
BEGIN TRY

    INSERT INTO  citizen.citizen_complaints ([cc_informer_name],[cc_email_id],[cc_location],[cc_phone_no],[cc_ward],[cc_zone],[cc_complaint_type],[cc_complain_mode],[cc_citizen_geom],[cc_priority],[cc_complaint_time],[cc_ulb_id_fk],[cc_complaint_key],[cc_image_url],[cc_discription])
	VALUES (@name,@email,@address,@phoneNo,@wardId,@zoneId,@complaintTypeId,1,geometry::STGeomFromText(@pointValue, 4326),@priority,@complaintDateTime,@ulbId,@incidentId,@images,@description)

	SET	@status =1
	SELECT @status
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
SET	@status =0
SELECT @status 
END CATCH
END;
---------------------------------------------------------------------------------------------------------------------------



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE  [dbo].[alertPushDelayTripStart]

   
AS
BEGIN

DECLARE @tripId int;
Declare @vehicleId int;
Declare @vehicleNo varchar(50);
Declare @routeId int;
Declare @ulbId int;
Declare @ulbCode varchar(50);


BEGIN TRAN
BEGIN TRY

select top(1) @tripId=[tom_trip_id_fk],@vehicleId=[tom_vehicle_id_fk],@routeId=[tom_route_id_fk],@ulbId=[cfm_ulb_id_fk],@ulbCode=[cfm_ulb_code],@vehicleNo=[cfm_vehicle_no] from [reporting].[trip_ongoing_master] 
left join [admin].[config_fleet_master] on [cfm_id_pk]=[tom_vehicle_id_fk] left join [garbage].[route_master] on [rm_id_pk]=[tom_route_id_fk]
 where datediff(hour, [tom_trip_schedule_date_time], getdate()) >= 1 and tom_trip_status=0 and [Maitenance]=0

 insert into [admin].[config_alerts_recived_log] (arl_alert_type_fk,[arl_received_date_time],[arl_vehicle_id_fk],[arl_route_id],[arl_trip_id],[arl_ulb_id_fk],[arl_Tenant_Code],[arl_vehicle_no],[arl_alert_type]) 
 values (14,CURRENT_TIMESTAMP,@vehicleId,@routeId,@tripId,@ulbId,@ulbCode,@vehicleNo,'Trip Delay Start Alert')

 update [reporting].[trip_ongoing_master] set [Maitenance]=1 where [tom_trip_id_fk]=@tripId

SELECT 'Success' AS message

COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	 SELECT ERROR_MESSAGE() AS message
	  END CATCH
END

--------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER PROCEDURE [dbo].[importRouteMasterData]
	
	
	@route_name varchar(250),
	@ULB_Id int,
	@routeGeom varchar(max),
	@zoneId int,
	@routeGeomBuffer varchar(max),
	@routeType int,
	@wardId int
		
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @routeIdpk int;
	DECLARE @roadIdpk int;

	BEGIN TRAN
	------------------------
	BEGIN TRY

	if @routeType=1
	begin
	insert into [garbage].[gis_road_area] ([gra_name],[gra_ulb_id_fk],[gra_created_date],[gra_ward_id],[gra_zone_id],[gra_fence],[gra_route],[gra_points_count])
	 values (@route_name,@ULB_Id,CURRENT_TIMESTAMP,@wardId,@zoneId,geometry::STGeomFromText(@routeGeomBuffer, 4326),geometry::STGeomFromText(@routeGeom, 4326),0)

	end

	
	insert into [garbage].[route_master] ([rm_route_name],[rm_ulb_id_fk],[rm_geom],[rm_zone_id],[rm_ward_id],[rm_fence_geom],[rm_type],[rm_created_date])
    values (@route_name,@ULB_Id,geometry::STGeomFromText(@routeGeom, 4326),@zoneId,0,geometry::STGeomFromText(@routeGeomBuffer, 4326),@routeType,CURRENT_TIMESTAMP)


	if @routeType=1
	begin

	select @routeIdpk=[rm_id_pk] from [garbage].[route_master] where [rm_route_name]=@route_name
	select @roadIdpk=[gra_id_pk] from [garbage].[gis_road_area] where [gra_name]=@route_name

	insert into [garbage].[route_details] ([rd_route_id_fk],[rd_order_no],[rd_check_points],[rd_check_point_id_fk],[rd_the_geom])
	 values (@routeIdpk,1,@route_name,@roadIdpk,geometry::STGeomFromText(@routeGeom, 4326))
	end

        SELECT 'success' AS status
  
 

   COMMIT TRAN
   END TRY

	---------------------------------
	BEGIN CATCH
        ROLLBACK TRAN
        SELECT 'failure' AS status, ERROR_MESSAGE() AS message 
    END CATCH
END

-----------------------------------------------------------------------------------------------------------------------------


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER PROCEDURE [dbo].[importRouteDetailsData]
	
	
	@routeID int,
	@orderNo int,
	@checkPointName varchar(50),
	@checkPointId int,
	@pointGeom varchar(max)
		
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @binIdpk int;

	BEGIN TRAN
	------------------------
	BEGIN TRY
	
	insert into [garbage].[route_details] ([rd_route_id_fk],[rd_order_no],[rd_check_points],[rd_check_point_id_fk],[rd_the_geom])
    values (@routeID,@orderNo,@checkPointName,@checkPointId,geometry::STGeomFromText(@pointGeom, 4326))

        SELECT 'success' AS status
  
 

   COMMIT TRAN
   END TRY

	---------------------------------
	BEGIN CATCH
        ROLLBACK TRAN
        SELECT 'failure' AS status, ERROR_MESSAGE() AS message 
    END CATCH
END

----------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER  PROCEDURE [dbo].[closeTripExcededTwoHours]
	
	
		
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @tripIdpk int;

	BEGIN TRAN
	------------------------
	BEGIN TRY
	
	  select top(1) @tripIdpk=stm_id_pk from [scheduling].[schedule_trip_master]  where cast(stm_date_time as date) = cast( GETDATE() as date) and DATEDIFF(hour,[stm_end_time],CURRENT_TIMESTAMP)  >=2

	  update reporting.trip_ongoing_master set tom_end_date_time=CURRENT_TIMESTAMP, tom_trip_status='2' where tom_trip_id_fk=@tripIdpk

	  update scheduling.schedule_trip_master set stm_status='2' where stm_id_pk=@tripIdpk


        --SELECT 'success' AS status
  
 

   COMMIT TRAN
   END TRY

	---------------------------------
	BEGIN CATCH
        ROLLBACK TRAN
        --SELECT 'failure' AS status, ERROR_MESSAGE() AS message 
    END CATCH
END

-------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER  PROCEDURE [dbo].[vehicleMaintanceDailyPush]
	
	
		
AS
BEGIN

Declare @vehId int,@uldId int,@userID int

SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY

select @vehId=[vmhc_vehicle_id],@uldId=[vmhc_ulbId],@userID=[vmhc_userId] from [reports].[vehicle_maintenance_history_count] 
where [vmhc_status]=1 and [vmhc_date] >= DATEADD(day, -1, GETDATE())

insert into [reports].[vehicle_maintenance_history_count] (vmhc_vehicle_id,vmhc_date,[vmhc_status],[vmhc_ulbId],[vmhc_userId]) values
(@vehId,GETDATE(),1,@uldId,@userID)


COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	  END CATCH
END

-------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER  PROCEDURE [dbo].[vehicleMaintanceExce]
	
	
	AS
BEGIN


SET NOCOUNT ON;

BEGIN TRAN
BEGIN TRY





 --with dateRange as (select dt = dateadd(dd, 1, 
	--                             CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) 
	--						   	 where dateadd(dd, 1, CONVERT(date, dateadd(day,datediff(day,7,GETDATE()),0))) < GETDATE() 
	--						   		 union all select dateadd(dd, 1, dt)from dateRange where dateadd(dd, 1, dt) < GETDATE()) 
	--						   		 select --((select count(*) 
	--						   		-- as vehicle_count FROM admin.config_fleet_master where cfm_ulb_id_fk = 2
	--						       --  and cfm_vehicle_available_status = 1) ) total,
	--								 count(*) break_down_count , FORMAT( dt,'dd-MM-yyyy') as vmhc_date from dateRange 
	--								 left join [reports].[vehicle_maintenance_history_count]
	--						   		 on CONVERT(date, vmhc_date)=dt AND [vmhc_ulbId] = 2
	--						         group by dt,CONVERT(date, vmhc_date) order by dt

	declare @period INT, @date_start datetime, @date_end datetime, @i int;
set @period = 6
set @date_start = convert(date,DATEADD(D, -@period, GETDATE()))
set @date_end = convert(date,GETDATE())
set @i = 1

create table #datesList(dts datetime)
insert into #datesList values (@date_start)
while @i <= @period
    Begin
        insert into #datesList values (dateadd(d,@i,@date_start))
        set @i = @i + 1
    end
select cast(dts as DATE) AS FROM_TO_DATES,
(SELECT COUNT(*) FROM [reports].[vehicle_maintenance_history_count]
 WHERE cast(vmhc_date as DATE)=cast(dts as DATE)) AS break_down_count from #datesList
 DROP TABLE #datesList




COMMIT TRAN
END TRY

 BEGIN CATCH
	 ROLLBACK TRAN
	  END CATCH
END

