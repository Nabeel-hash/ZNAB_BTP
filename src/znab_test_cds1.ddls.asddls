@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sample test CDS view'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
serviceQuality: #X ,
sizeCategory: #S ,
dataClass: #MIXED
}
define view entity ZNAB_TEST_CDS1 as select from /dmo/travel_m
{
  key travel_id as TravelId,
  agency_id as AgencyId,
  customer_id as CustomerId,
  begin_date as BeginDate,
  end_date as EndDate,
  booking_fee as BookingFee,
  total_price as TotalPrice,
  currency_code as CurrencyCode,
  description as Description,
  overall_status as OverallStatus,
  created_by as CreatedBy,
  created_at as CreatedAt,
  last_changed_by as LastChangedBy,
  last_changed_at as LastChangedAt
}
