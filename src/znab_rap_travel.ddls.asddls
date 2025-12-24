@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Root Entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZNAB_RAP_TRAVEL as select from /dmo/travel_m
composition[0..*] of ZNAB_RAP_BOOKING as _bookings
association[1] to /DMO/I_Agency as _Agency on $projection.AgencyId = _Agency.AgencyID
association[1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID
association[1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
association[1] to /DMO/I_Overall_Status_VH as _overall_status on $projection.OverallStatus = 
_overall_status.OverallStatus
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
    @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Overall_Status_VH' ,
                                                     element: 'OverallStatus'  } }]
    @EndUserText.label: 'Status'
    overall_status as OverallStatus,
    case overall_status
        when 'X' then 1
        when 'O' then 2 
        when 'A' then 3
        else 4
        end as StatusCricticality,  
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    _Agency,
    _Customer,
    _Currency,
    _overall_status,
    _bookings
}
