@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplement Child Entity'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZNAB_RAP_SUPPLEMENT as select from /dmo/booksuppl_m
association to parent ZNAB_RAP_BOOKING as _Booking
    on $projection.BookingId = _Booking.BookingId
    and $projection.TravelId = _Booking.TravelId
 association[1..1] to ZNAB_RAP_TRAVEL as _Travel
    on $projection.TravelId = _Travel.TravelId
association[1..1] to /DMO/I_Supplement as _Supplement
    on $projection.SupplementId = _Supplement.SupplementID
association[1..*] to /DMO/I_SupplementText as _SupplementText
    on $projection.SupplementId = _SupplementText.SupplementID
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    price as Price,
    currency_code as CurrencyCode,
    last_changed_at as LastChangedAt,
    _Supplement,
    _SupplementText,
    _Booking,
    _Travel
}
