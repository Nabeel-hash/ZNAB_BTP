@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Projection View'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define view entity ZNAB_RAP_BOOKING_PROJ 
as projection on ZNAB_RAP_BOOKING
{

    key TravelId,
    key BookingId,
    BookingDate,
    @Consumption.valueHelpDefinition: [{ entity:{ name: '/DMO/I_Customer' ,
                                                  element: 'CustomerID' } 
                                      }]
    CustomerId,
    @Consumption.valueHelpDefinition: [{ entity:{ name: '/DMO/I_Carrier',
                                                  element: 'AirlineID' }
                                       }]
    CarrierId,
    @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Connection', 
                                                   element: 'ConnectionID' 
                                                 } , 
                                         additionalBinding: [{ localElement: 'CarrierId' ,
                                                               element: 'AirlineID'  }] 
                                      }] 
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _BookingStatus,
    _Carrier,
    _Connection,
    _Customer,
    _Supplement:redirected to composition child ZNAB_RAP_SUPPL_PROJ,
    _Travel:redirected to parent ZNAB_RAP_TRAVEL_PROJ 
}
