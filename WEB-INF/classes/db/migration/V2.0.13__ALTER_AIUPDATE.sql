 ALTER TABLE [analytics].[schedulePublish_master]
 ADD spm_wf_status int DEFAULT 0; 

alter table [analytics].[schedulePublish_Details]
add spdt_bin_location_id int;