  CREATE TABLE [reporting].[DTDTransactionTable] (
    [dtt_id_pk] int NOT NULL IDENTITY(1, 1),
    [dtt_bin_id] int,
	[dtt_trip_id] int,
    [dtt_collection_status] int,
	[dtt_inserted_date] datetime
  
);

