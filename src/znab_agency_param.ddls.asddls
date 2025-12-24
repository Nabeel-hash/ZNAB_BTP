@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Parameterized CDS View Agency Info'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZNAB_AGENCY_PARAM
  with parameters
    p_status : /dmo/travel_status
  as select from ZNAB_CDS_EXERCISE1
{
  key AgencyId                            as AgencyId,
      _agency.name                        as AgencyName,
      count( distinct TravelId )          as TravelCount,
      @Semantics.amount.currencyCode: 'TargetCurrency'
      sum( TotalValue )                   as TotalValueUSD,
      avg( Duration as abap.dec( 13, 2) ) as AverageDuration,
      cast( 'USD' as abap.cuky )          as TargetCurrency,
      case $parameters.p_status
      when 'N'
      then 'New'
      when 'O'
      then 'Open'
      else 'Not Sure'
      end                                 as Status_Desc
}
where
  Status = $parameters.p_status
group by
  AgencyId,
  _agency.name
having
  count( distinct TravelId ) > 1;
