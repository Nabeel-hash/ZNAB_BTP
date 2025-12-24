@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Flight scenario'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZNAB_DMO_FLIGHT as select from /dmo/flight
{
    key carrier_id as CarrierId,
    key connection_id as ConnectionId,
    key flight_date as FlightDate,
    seats_max as SeatsMax,
    seats_occupied as SeatsOccupied,
    coalesce( seats_max , 0 ) - coalesce(seats_occupied , 0) as FreeSeats
}
