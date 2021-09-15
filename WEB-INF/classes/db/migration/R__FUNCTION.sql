/****** Object:  UserDefinedFunction [dbo].[fnAppendString]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString]   
(   
    @trip_id int
)   
RETURNS @output TABLE(staffName NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		SELECT @temp = COALESCE(@temp+', ' ,'') + cssm_staff_name
		from admin.config_staff_master where cssm_id_pk in 
		(select splitdata from fnSplitString((select stm_staff from 
		scheduling.schedule_trip_master  where stm_id_pk=@trip_id) ,',') )
		--SELECT @temp
		 INSERT INTO @output (staffName)    
        VALUES(@temp)  
    RETURN   
END 





GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendString_binName]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString_binName]   
(   
    @binloc_id int
)   
RETURNS @output TABLE(binName NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		SELECT @temp = COALESCE(@temp+', ' ,'') + cbm_bin_name
		from [admin].[config_bin_master] where cbm_bin_loc_id=@binloc_id
		 INSERT INTO @output (binName)    
        VALUES(@temp)  
    RETURN   
END 

GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendString_binName_For_ward]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString_binName_For_ward]   
(   
    @ward_id int
)   
RETURNS @output TABLE(binName NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		SELECT @temp = COALESCE(@temp+', ' ,'') + t1.cbm_bin_name
		from [admin].[config_bin_master] as t1
		left join [dbo].[compactor_bin_collection_status_view] on t1.cbm_bin_loc_id=[cbsm_bin_loc_id]
		where t1.cbm_ward_id=@ward_id  and [cbsm_collection_status]=1
		 INSERT INTO @output (binName)    
        VALUES(@temp)  
    RETURN   
END 



GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendString_for_routename]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString_for_routename]   
(   
    @veh_id int
)   
RETURNS @output TABLE(routeName NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		SELECT @temp = COALESCE(@temp+', ' ,'') + rm_route_name
		from  [garbage].[route_master] where rm_id_pk in 
		( select distinct rtid from (
					 select tom_route_id_fk as rtid FROM  [reporting].[trip_ongoing_master]
					 where cast(tom_trip_schedule_date_time as date)  = cast(GETDATE() as date)
					 and tom_vehicle_id_fk =@veh_id
					 			union all
					 select tcm_route_id_fk as rtid FROM  [reporting].[trip_completed_master]
					 where cast(tcm_trip_date_time as date) = cast(GETDATE() as date)   and 
							tcm_vehicle_id_fk =@veh_id
					 ) as dd  )
		--SELECT @temp
		 INSERT INTO @output (routeName)    
        VALUES(@temp)  
    RETURN   
END 







GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendString_trip_For_report]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString_trip_For_report]   
(   
    @ward_id int,
	@start_date datetime,
	@end_date datetime
)   
RETURNS @output TABLE(tripid NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		SELECT @temp = COALESCE(@temp+', ' ,'') + convert(nvarchar(10),tom_trip_id_fk)
		  from (select distinct tom_trip_id_fk from reporting.trip_ongoing_master  join reporting.trip_ongoing_details on tod_master_id_fk=tom_id_pk  join [dbo].[bin_collection_status_view] on tod_bin_id_fk=[cbsm_bin_loc_id]  where tom_trip_schedule_date_time between @start_date and @end_date and cbsm_ward_id=@ward_id
union all(select distinct tcm_trip_id_fk from reporting.trip_completed_master join reporting.trip_completed_details on  tcd_master_id_fk=tcm_id_pk  join [dbo].[bin_collection_status_view] on tcd_bin_id_fk=[cbsm_bin_loc_id] where tcm_trip_date_time between @start_date and @end_date  and cbsm_ward_id=@ward_id)) as t1 
		 INSERT INTO @output (tripid)    
        VALUES(@temp)  
    RETURN   
END 





GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendString_vehicle]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString_vehicle]   
(   
    @ulb_id int
)   
RETURNS @output TABLE(vehId NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		SELECT @temp = COALESCE(@temp+',' ,'') + cast(cfm_id_pk as varchar(10))
		from admin.config_fleet_master where cfm_ulb_id_fk=@ulb_id
		 INSERT INTO @output (vehId)    
        VALUES(@temp)  
    RETURN   
END 

GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendString_vehicle_For_report]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString_vehicle_For_report]   
(   
    @ward_id int,
	@start_date datetime,
	@end_date datetime
)   
RETURNS @output TABLE(vehicleno NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		SELECT @temp = COALESCE(@temp+', ' ,'') + cfm_vehicle_no
		  from (select distinct tom_vehicle_id_fk from reporting.trip_ongoing_master  join reporting.trip_ongoing_details on tod_master_id_fk=tom_id_pk  join [dbo].[bin_collection_status_view] on tod_bin_id_fk=[cbsm_bin_loc_id]  where tom_trip_schedule_date_time between @start_date and @end_date and cbsm_ward_id=@ward_id
union all(select distinct tcm_vehicle_id_fk from reporting.trip_completed_master join reporting.trip_completed_details on  tcd_master_id_fk=tcm_id_pk  join [dbo].[bin_collection_status_view] on tcd_bin_id_fk=[cbsm_bin_loc_id] where tcm_trip_date_time between @start_date and @end_date  and cbsm_ward_id=@ward_id)) as t1 left join admin.config_fleet_master on cfm_id_pk=tom_vehicle_id_fk

		 INSERT INTO @output (vehicleno)    
        VALUES(@temp)  
    RETURN   
END 






GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendString_wardNo]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString_wardNo]   
(   
    @ward_id nvarchar(max),
	@package int
)   
RETURNS @output TABLE(ward_name NVARCHAR(MAX)   

)
AS
BEGIN
DECLARE @temp VARCHAR(MAX)
		 if(@package=0)
		SELECT @temp = COALESCE(@temp+', ' ,'') + cwm_ward_name
		from admin.[config_ward_master] where cwm_id_pk in
		(select splitdata from  [dbo].[fnSplitString] (@ward_id,',') ) 
		
		--SELECT @temp
		--if(@package=1)
		--SELECT @temp = COALESCE(@temp+', ' ,'') + cpm_package_name
		--from admin.[config_package_master] where cpm_id_pk in
		--(select splitdata from  [dbo].[fnSplitString] (@ward_id,',') ) 
		
		 INSERT INTO @output (ward_name)    
        VALUES(@temp)  
	
	RETURN 
END

GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendString_weight_For_report]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString_weight_For_report]   
(   
    @trip_id varchar(500)
	
)   
RETURNS @output TABLE(weight1 float   
) 
BEGIN   
		 DECLARE @temp float
		 select  @temp= sum([tom_weight_disposed]) from ((select [tom_weight_disposed] from reporting.trip_ongoing_master   where tom_trip_id_fk in (select splitdata from [dbo].[fnSplitString]  (@trip_id,',')))
union all(select tcm_weight_disposed from reporting.trip_completed_master where tcm_trip_id_fk in (select splitdata from [dbo].[fnSplitString]  (@trip_id,','))) )as t1 
		 INSERT INTO @output (weight1)    
        VALUES(@temp)  
    RETURN   
END 





GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendString_zoneNo]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendString_zoneNo] 
(
	 @zone_id nvarchar(max)
)
RETURNS @output TABLE(zone_name NVARCHAR(MAX)  

)
AS
BEGIN
	 DECLARE @temp VARCHAR(MAX)
		SELECT @temp = COALESCE(@temp+', ' ,'') + czm_zone_name
		from admin.[config_zone_master] where czm_id_pk in
		(select splitdata from  [dbo].[fnSplitString] (@zone_id,',') )
		--SELECT @temp
		
		
		
		 INSERT INTO @output (zone_name)    
        VALUES(@temp)  
	RETURN 
END

GO
/****** Object:  UserDefinedFunction [dbo].[fnAppendStringforAnalytics]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnAppendStringforAnalytics]   
(   
    @spm_id_pk int
)   
RETURNS @output TABLE(staffName NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		SELECT @temp = COALESCE(@temp+', ' ,'') + cssm_staff_name
		from admin.config_staff_master where cssm_id_pk in 
		(select splitdata from fnSplitString((select spm_staff_id from 
		[analytics].[schedulePublish_master]  where spm_id_pk=@spm_id_pk) ,',') )
		--SELECT @temp
		 INSERT INTO @output (staffName)    
        VALUES(@temp)  
    RETURN   
END 





GO
/****** Object:  UserDefinedFunction [dbo].[fnGetBinCollectionStatus]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnGetBinCollectionStatus]   
(   
   @startDateTime NVARCHAR(25), 
	@endDateTime NVARCHAR(25),
	@zoneid NVARCHAR(max),
	@wardid NVARCHAR(max)
)   
RETURNS @output TABLE(t_date NVARCHAR(10),  total_bins int, ward_name nvarchar(50),zone_name nvarchar(50),collected_bins int,not_collected_bins int
) 
BEGIN   
		 
	--declare @dptId varchar(max)=SUBSTRING(@cfm_vehicle_no, 1, LEN(@cfm_vehicle_no));
	--print @dptId;  vehID IN (SELECT * FROM fnSplitString(@cfm_vehicle_no, ','))

	declare @date_diff int
	declare @lastdate date
	set @lastdate=@endDateTime
	set @date_diff=datediff(day,@startDateTime,@endDateTime)
	;
	
with dateRange as( select dt = dateadd(dd, 1, CONVERT(date,  dateadd(day,datediff(day,@date_diff,@lastdate),-1)))    where   dateadd(dd, 1, CONVERT(date,  dateadd(day,datediff(day,@date_diff,@lastdate),-1))) <= @lastdate   union all  select dateadd(dd, 1, dt) from dateRange where dateadd(dd, 1, dt) <= @lastdate)  
INSERT INTO @output
 select t_date,total_bins,cwm_ward_name,czm_zone_name,  case when collected_bins is null then 0 else collected_bins end as collected_bins,  total_bins-(case when collected_bins is null then 0 else collected_bins end) as not_collected_bins from  ( select FORMAT( dt,'dd-MM-yyyy') as t_date,sum([ggcf_points_count]) as total_bins,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,  czm_zone_name,[cwm_id_pk],(select case when dt=cast(getdate() as date) then sum(case when  [ggcf_bin_collection_status]=1 then [ggcf_points_count] else 0 end) else (select [bcr_bin_collected]  from [dashboard].[bin_collection_report] where [bcr_date]=dt and [bcr_ward_id]=[cwm_id_pk]) end )  collected_bins  from dateRange,[garbage].[gis_garbage_collection_points]   left join  admin.config_ward_master on [cwm_id_pk]=[ggcf_ward_id] left join    admin.config_zone_master on cwm_zone_id_fk=czm_id_pk  where ggcf_ulb_id_fk='16179'  group by dt,cwm_ulb_id_fk,[cwm_zone_id_fk],cwm_ward_name,czm_zone_name,[cwm_id_pk]) as t1 
		where cwm_zone_id_fk in (select  splitdata from  dbo.fnSplitString(@zoneid,',')) and cwm_id_pk in (select  splitdata from  dbo.fnSplitString(@wardid,','))
		option (maxrecursion 0)
		
		--SELECT @temp
		-- INSERT INTO @output (binName)    
       -- VALUES(@temp)  
    RETURN   
END 
--select * from admin.config_bin_master

--SELECT * FROM [dbo].[fnGetBins]   (13337,2)



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetBins]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnGetBins]   
(   
    @loc_id int,
	@route_type int,
	@mod int--0 for dynamic scheduling, 1 for reporting , 2 Map or bin alert page
)   
RETURNS @output TABLE(binName NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		--SELECT @temp = COALESCE(@temp+', ' ,'') + cbm_bin_name
		--from admin.config_bin_master where cbm_bin_loc_id = @loc_id
		IF @mod=0 
		BEGIN
			SELECT  @temp =COALESCE(@temp+'   ' ,'') + cbm_bin_name+' -- '+cast([cbm_bin_capacity] as varchar(5))+ case when [cbsm_bin_sensor_capasity] is null then ' -- 0' else ' -- '+cast([cbsm_bin_sensor_capasity] as varchar(5)) end 
		from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where cbm_bin_loc_id = @loc_id	and cbm_binRroad_status=0
		END
		IF  @mod=1
		BEGIN
			SELECT  @temp =COALESCE(@temp+', ' ,'') + cbm_bin_name
		from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where cbm_bin_loc_id = @loc_id and cbm_binRroad_status=0
		 
		END

		IF  @mod=2
		BEGIN
			--SELECT  @temp =COALESCE(@temp+',' ,'') + cbm_bin_name+'@@'+cast([cbsm_bin_sensor_capasity] as varchar(5))+ case when [cbsm_bin_sensor_capasity] is null then '@@0' else '@@'+CONVERT(nvarchar(10),[cbsm_sensor_updated_date],105)+' '+convert(varchar(8),cbsm_sensor_updated_date,108 )+'@@'+CONVERT(nvarchar(10),[cbsm_alert_time],105)+' '+convert(varchar(8),[cbsm_alert_time],108 )+'@@'+CONVERT(nvarchar(10),[cbsm_sla_time],105)+' '+convert(varchar(8),[cbsm_sla_time],108)+'@@'+convert(nvarchar(10),cbsm_collected_time,105)+' '+convert(varchar(8),cbsm_collected_time,108)+'@@'+convert(varchar(2),cbsm_sla_hours)  end  
--from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where cbm_bin_loc_id = @loc_id
	--	SELECT  @temp =COALESCE(@temp+',' ,'') + cbm_bin_name+'@@'+cast([cbsm_bin_sensor_capasity] as varchar(5))+ case when [cbsm_bin_sensor_capasity] is null then '@@0' else +'@@'+(case when [cbsm_sensor_updated_date] is null then '--' else CONVERT(nvarchar(10),[cbsm_sensor_updated_date],105)+' '+convert(varchar(8),cbsm_sensor_updated_date,108 )end )+'@@'+(case when [cbsm_alert_time] is null then '--' else CONVERT(nvarchar(10),[cbsm_alert_time],105)+' '+convert(varchar(8),[cbsm_alert_time],108 ) end)+'@@'+(case when [cbsm_sla_time] is null then '--' else CONVERT(nvarchar(10),[cbsm_sla_time],105)+' '+convert(varchar(8),[cbsm_sla_time],108) end)+'@@'+(case when cbsm_collected_time is null then '--' else convert(nvarchar(10),cbsm_collected_time,105)+' '+convert(varchar(8),cbsm_collected_time,108)end)+'@@'+(case when cbsm_sla_hours is null then '--' else convert(varchar(2),cbsm_sla_hours) end ) end  
--from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where cbm_bin_loc_id = @loc_id
	 
	SELECT @temp =COALESCE(@temp+',' ,'') + cbm_bin_name+'@@'+(case when [cbsm_bin_sensor_capasity] is null then '0' else cast([cbsm_bin_sensor_capasity] as varchar(5))end)+'@@'+(case when [cbsm_sensor_updated_date] is null then '--' else CONVERT(nvarchar(10),[cbsm_sensor_updated_date],105)+' '+convert(varchar(8),cbsm_sensor_updated_date,108 )end )+'@@'+(case when [cbsm_alert_time] is null then '--' else CONVERT(nvarchar(10),[cbsm_alert_time],105)+' '+convert(varchar(8),[cbsm_alert_time],108 ) end)+'@@'
	--+(case when [cbsm_sla_time] is null then '--' else CONVERT(nvarchar(10),[cbsm_sla_time],105)+' '+convert(varchar(8),[cbsm_sla_time],108) end)+'@@'
	+(case when cbsm_collected_time is null then '--' else convert(nvarchar(10),cbsm_collected_time,105)+' '+convert(varchar(8),cbsm_collected_time,108)end)+'@@'+(case when [cbsm_collection_status] is null then '--' else convert(varchar(2),[cbsm_collection_status]) end )
	--+'@@'+(case when cbsm_sla_hours is null then '--' else convert(varchar(20),cbsm_sla_hours) end )  
from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where 
cbm_bin_loc_id = @loc_id and cbm_binRroad_status=0

		END

		IF @mod=3

		BEGIN

		SELECT @temp =COALESCE(@temp+',' ,'') + cbm_bin_name+'@@'+(case when [cbsm_collection_status] is null then '--' else convert(varchar(2),[cbsm_collection_status]) end )+'@@'+(case when cbsm_collected_time is null then '--' else convert(nvarchar(10),cbsm_collected_time,105)+' '+convert(varchar(8),cbsm_collected_time,108)end) 
from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where 
cbm_bin_loc_id = @loc_id and cbm_binRroad_status=0

		
		END
		If @mod=4

		BEGIN

		
SELECT  @temp =COALESCE(@temp+'   ' ,'') +cbm_bin_name+' -- '+cast([cbm_bin_capacity] as varchar(5))+ case when bspa_Predicted_Volume is null then ' -- 0' else ' -- '+cast(bspa_Predicted_Volume as varchar(5)) end from(
select row_number() over (partition by cbm_bin_name order by bspa_Predicted_Volume desc ) as Row#,cbm_bin_name,[cbm_bin_capacity],[cbsm_bin_sensor_capasity],bspa_DateTime,bspa_Predicted_Volume
from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk] 
	left join [analytics].[bin_sensor_predictive_alert] on cbm_bin_name=bspa_Bin_ID COLLATE SQL_Latin1_General_CP1_CI_AS where
	cbm_bin_loc_id =@loc_id and cbm_binRroad_status=0 and bspa_Predicted_Volume>50 and bspa_DateTime between 
 convert(varchar(10),getdate(),120)+' 00:00' and convert(varchar(10),getdate(),120)+' 23:59') as t1 where Row#=1

		END
		--SELECT @temp
		 INSERT INTO @output (binName)    
        VALUES(@temp)  
    RETURN   
END 
--select * from admin.config_bin_master

--SELECT * FROM [dbo].[fnGetBins]   (13259,3)
--[cbsm_sla_time] ,[cbsm_collected_time] ,[cbsm_sla_hours]

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetBins_for_location]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnGetBins_for_location]   
(   
    @loc_id int,
	@route_type int,
	@mod int
	--0 for dynamic scheduling, 1 for reporting , 2 Map or bin alert page
)   
RETURNS @output TABLE(binName NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
	
		

		IF  @mod=1
		BEGIN
	
		SELECT @temp =COALESCE(@temp+',' ,'') + cbm_bin_name+'@@'+(case when [cbsm_collection_status] is null then '0' else convert(varchar(2),[cbsm_collection_status]) end )+'@@'+(case when cbsm_collected_time is null then '--' else convert(nvarchar(10),cbsm_collected_time,105)+' '+convert(varchar(8),cbsm_collected_time,108)end) 
from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where 
cbm_bin_loc_id = @loc_id and  cbm_binRroad_status=@route_type 


		END


	

		--SELECT @temp
		 INSERT INTO @output (binName)    
        VALUES(@temp)  
    RETURN   
END 
--select * from admin.config_bin_master

--SELECT * FROM [dbo].[fnGetBins]   (13259,3)
--[cbsm_sla_time] ,[cbsm_collected_time] ,[cbsm_sla_hours]
--select * from [dbo].[fnGetBins_for_location](14498,1)

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetBins_for_road]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnGetBins_for_road]   
(   
    @loc_id int,
	@mod int--0 for dynamic scheduling, 1 for reporting
)   
RETURNS @output TABLE(binName NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
		--SELECT @temp = COALESCE(@temp+', ' ,'') + cbm_bin_name
		--from admin.config_bin_master where cbm_bin_loc_id = @loc_id
		IF @mod=0 
		BEGIN
			SELECT  @temp =COALESCE(@temp+'   ' ,'') + cbm_bin_name+' -- '+cast([cbm_bin_capacity] as varchar(5))+ case when [cbsm_bin_sensor_capasity] is null then ' -- 0' else ' -- '+cast([cbsm_bin_sensor_capasity] as varchar(5)) end 
		from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where cbm_bin_loc_id = @loc_id	 
		END
		ELSE
		BEGIN
			SELECT  @temp =COALESCE(@temp+',' ,'') + cast(cbm_id_pk as nvarchar(max))
		from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where cbm_bin_loc_id = @loc_id
		 
		END
		
		--SELECT @temp
		 INSERT INTO @output (binName)    
        VALUES(@temp)  
    RETURN   
END 
--select * from admin.config_bin_master





GO
/****** Object:  UserDefinedFunction [dbo].[fnGetBins_for_trip]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnGetBins_for_trip]   
(   
    @loc_id int,
	@mod int
	--0 for dynamic scheduling, 1 for reporting , 2 Map or bin alert page
)   
RETURNS @output TABLE(binName NVARCHAR(MAX)   
) 
BEGIN   
		 DECLARE @temp VARCHAR(MAX)
	
		

		IF  @mod=1
		BEGIN
	
		SELECT @temp =COALESCE(@temp+',' ,'') + cbm_bin_name+'@@'+	CAST(cbsm_bin_latitude AS VARCHAR(100))+'@@'+CAST(cbsm_bin_longitude AS VARCHAR(100))+'@@'+(case when [cbm_person_name] is null then '--' else [cbm_person_name] end )+'@@'+(case when [cbm_house_no] is null then '--' else [cbm_house_no] end) 
from admin.config_bin_master left join [admin].[config_bin_sensor_master] on [cbsm_bin_id]=[cbm_id_pk]  where 
cbm_bin_loc_id = @loc_id

		END


			--CAST(CAST(cbsm_bin_longitude AS DECIMAL(20)) AS VARCHAR(20))

		--SELECT @temp
		 INSERT INTO @output (binName)    
        VALUES(@temp)  
    RETURN   
END 
--select * from admin.config_bin_master

--SELECT * FROM [dbo].[fnGetBins]   (13259,3)
--[cbsm_sla_time] ,[cbsm_collected_time] ,[cbsm_sla_hours]
--select * from [dbo].[fnGetBins_for_trip](5010,1)

GO
/****** Object:  UserDefinedFunction [dbo].[fnsensorchartview]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnsensorchartview]  
(   
    @fromdate varchar(10)
	
)   
RETURNS @output TABLE(hr int ,name varchar(50)   
) 
BEGIN   
		DECLARE @StartDateTime DATETIME
DECLARE @EndDateTime DATETIME
DECLARE @temp_sensor table(hr INT,bin varchar(max) )
DECLARE @temp_sensor_1 table(hr INT,name varchar(max) )
SET @StartDateTime = @fromdate+' 00:00:00'
SET @EndDateTime = @fromdate+' 23:59:59'

;WITH DateRange(DateData) AS 
(
    SELECT @StartDateTime as Datetime
    UNION ALL
    SELECT DATEADD(HOUR,1,DateData)
    FROM DateRange 
    WHERE DateData <= @EndDateTime
)

		 INSERT INTO @temp_sensor     
        select case when datepart(HOUR,DateData1)=0 then 24 else
		 datepart(HOUR,DateData1) end,bspa_Bin_ID from (SELECT DateData,lead(DateData) 
		 over(order by DateData)  as DateData1
FROM DateRange)as t1 left join  dbo.bin_sensor_predictive_alert on (cast(bspa_DateTime as date)<=cast(DateData as date) and cast(case when bspa_DateTime is null then getdate() else bspa_DateTime end  as date)>=cast(DateData as date) and cast(bspa_DateTime as time) between cast(DateData as time) and cast(DateData1 as time) )
where DateData1 is not null 

insert into @temp_sensor_1

SELECT Main.hr,Main.bin FROM
    (
        SELECT DISTINCT ST2.hr,ST2.bin FROM @temp_sensor ST2  group by  ST2.hr,ST2.bin


		 
    ) [Main] 


	insert into @output
	select g.hr,g1.name from @temp_sensor g join @temp_sensor_1 g1 on g1.hr=g.hr  group by g.hr,g1.name

    RETURN   
END 


	--select * from 	  dbo.bin_sensor_predictive_alert
	--select  CONVERT(VARCHAR(10),bspa_DateTime,120) AS date ,DATEPART(hour,bspa_DateTime) AS OnHour,bspa_Bin_ID from dbo.bin_sensor_predictive_alert
---GROUP BY CONVERT(VARCHAR(10),bspa_DateTime,120),DatePart(hh,bspa_DateTime),bspa_Bin_ID

GO
/****** Object:  UserDefinedFunction [dbo].[fnSplitString]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnSplitString]   
(   
    @string NVARCHAR(MAX),   
    @delimiter CHAR(1)   
)   
RETURNS @output TABLE(splitdata NVARCHAR(MAX)   
)   
BEGIN   
    DECLARE @start INT, @end INT   
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string)   
    WHILE @start < LEN(@string) + 1 BEGIN   
        IF @end = 0    
            SET @end = LEN(@string) + 1  
         
        INSERT INTO @output (splitdata)    
        VALUES(SUBSTRING(@string, @start, @end - @start))   
        SET @start = @end + 1   
        SET @end = CHARINDEX(@delimiter, @string, @start)  
          
    END   
    RETURN   
END 




GO
/****** Object:  UserDefinedFunction [dbo].[fnToGetShift]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[fnToGetShift]   
(   
    @temp_datetime datetime
)   
RETURNS @output TABLE(shift_id int,shift_type varchar(50)   
) 
BEGIN   
DECLARE @id int, @shift_name varchar(50)
		SELECT @id=csm_id_pk,@shift_name=csm_shift_name FROM ((SELECT  CASE WHEN @temp_datetime BETWEEN  CONVERT(datetime,CONVERT(varchar,@temp_datetime,23)+' '+CONVERT(varchar,csm_shift_start_time,8)) AND 
	 CONVERT(datetime,CONVERT(varchar,@temp_datetime,23)+' '+CONVERT(varchar,csm_shift_end_time,8)) THEN 1 ELSE 0 END AS status,csm_id_pk,csm_shift_name FROM admin.config_shift_master WHERE csm_id_pk = 1)
	 UNION ALL(SELECT  CASE WHEN @temp_datetime BETWEEN  CONVERT(datetime,CONVERT(varchar,@temp_datetime,23)+' '+CONVERT(varchar,csm_shift_start_time,8)) AND 
	 CONVERT(datetime,CONVERT(varchar,@temp_datetime,23)+' '+CONVERT(varchar,csm_shift_end_time,8)) THEN 1 ELSE 0 END AS status,csm_id_pk,csm_shift_name FROM admin.config_shift_master WHERE csm_id_pk = 2)
	 UNION ALL(SELECT  CASE WHEN @temp_datetime BETWEEN  CONVERT(datetime,CONVERT(varchar,@temp_datetime,23)+' '+CONVERT(varchar,csm_shift_start_time,8)) AND 
	 CONVERT(datetime,CONVERT(varchar,@temp_datetime,23)+' 23:59:59') THEN 1 WHEN @temp_datetime BETWEEN  DATEADD(DAY,1,CONVERT(datetime,CONVERT(varchar,@temp_datetime,23)+' 00:00:00')) AND 
	 DATEADD(DAY,1,CONVERT(datetime,CONVERT(varchar,@temp_datetime,23)+' '+CONVERT(varchar,csm_shift_end_time,8))) THEN 1 ELSE 0 END AS status,csm_id_pk,csm_shift_name FROM admin.config_shift_master WHERE csm_id_pk = 3))
	 AS TEMP_TABLE WHERE status=1

		--SELECT @temp
		 INSERT INTO @output (shift_id,shift_type)    
        VALUES(@id,@shift_name)  
    RETURN   
END 





GO
/****** Object:  UserDefinedFunction [dbo].[geometry2json]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[geometry2json]( @geo geometry, @radius varchar(10) = 50)
 RETURNS nvarchar(MAX) AS
 BEGIN
 RETURN (
 '{' +
 (CASE @geo.STGeometryType()
 WHEN 'POINT' THEN
 '"type": "Circle","coordinates":' +
 REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'POINT ',''),'(','['),')',']'),' ',',')+', "radius":'+@radius
 WHEN 'POLYGON' THEN 
 '"type": "Polygon","coordinates":' +
 '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'POLYGON ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
 WHEN 'MULTIPOLYGON' THEN 
 '"type": "MultiPolygon","coordinates":' +
 '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'MULTIPOLYGON ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
 WHEN 'MULTIPOINT' THEN
 '"type": "MultiPoint","coordinates":' +
 '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'MULTIPOINT ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
 WHEN 'LINESTRING' THEN
 '"type": "LineString","coordinates":' +
 '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'LINESTRING ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
 ELSE NULL
 END)
 +'}')
 END





GO
/****** Object:  UserDefinedFunction [dbo].[Split_To_Array]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[Split_To_Array]
(
    @String NVARCHAR(4000),
    @Delimiter NCHAR(1)
)
RETURNS TABLE 
AS
RETURN 
(
    WITH Split_To_table(stpos,endpos,row_id) 
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos,1 AS val
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1),row_id+1
            FROM Split_To_table
            WHERE endpos > 0
    )
    SELECT 'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos),row_id
    FROM Split_To_table
)


GO
/****** Object:  UserDefinedFunction [dbo].[Split_To_table]    Script Date: 12-04-2021 18:31:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  OR ALTER  FUNCTION [dbo].[Split_To_table]
(
    @String NVARCHAR(4000),
    @Delimiter NCHAR(1)
)
RETURNS TABLE
AS
RETURN
(
    WITH Split_To_table(stpos,endpos)
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split_To_table
            WHERE endpos > 0
    )
    SELECT 'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
    FROM Split_To_table
)

GO
