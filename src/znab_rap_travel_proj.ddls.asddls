@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Processor Projection'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZNAB_RAP_TRAVEL_PROJ
  provider contract transactional_query
  as projection on ZNAB_RAP_TRAVEL
{
      @EndUserText.label: 'Travel'
      @ObjectModel.text.element: [ 'Description' ]    
      key TravelId,
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Agency' ,
                                                     element: 'AgencyID'  } }]      
      AgencyId, 

      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer' ,
                                                     element: 'CustomerID'  } }]   
      @EndUserText.label: 'Customer'
      @ObjectModel.text.element: ['LastName'] 
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      CustomerId,
      _Customer.LastName as LastName,
      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,
      @Search.defaultSearchElement: true
      CurrencyCode,
      Description,
      @ObjectModel.text.element: [ 'OverallStatusText' ]
      OverallStatus,
      _overall_status._Text.Text as OverallStatusText : localized, 
      StatusCricticality,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _Agency,
      _bookings:redirected to composition child ZNAB_RAP_BOOKING_PROJ,
      _Currency,
      _Customer,
      _overall_status
}
