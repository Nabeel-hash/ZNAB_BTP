@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Define CDS modeling'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZNAB_CDS_EXERCISE1 as select from /dmo/travel
association[1..1] to /dmo/agency as _agency
on $projection.AgencyId = _agency.agency_id
association[1..1 ] to /dmo/customer as _customer
on $projection.CustomerId = _customer.customer_id
{
    key travel_id as TravelId,
    agency_id as AgencyId,
    customer_id as CustomerId,
    begin_date as BeginDate,
    end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    total_price as TotalPrice,
    currency_code as CurrencyCode,
    description as Description,
    status as Status,
    dats_days_between( begin_date , end_date ) as Duration,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    total_price + booking_fee as TotalValue,
    _agency,
    _customer
   
}
