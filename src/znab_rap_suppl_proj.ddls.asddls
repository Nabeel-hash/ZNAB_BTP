@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplement Projection View'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define view entity ZNAB_RAP_SUPPL_PROJ
  as projection on ZNAB_RAP_SUPPLEMENT
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Booking : redirected to parent ZNAB_RAP_BOOKING_PROJ,
      _Supplement,
      _SupplementText,
      _Travel:redirected to ZNAB_RAP_TRAVEL_PROJ
}
