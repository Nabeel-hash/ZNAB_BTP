@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agency based summation View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZNAB_AGENCY_SUM
  as select from ZNAB_CDS_EXERCISE1
{
  key AgencyId                            as AgencyId,
      _agency.name                        as AgencyName,
      count( distinct TravelId )          as TravelCount,
      @Semantics.amount.currencyCode: 'TargetCurrency'
      sum( TotalValue ) as TotalValueUSD,
      avg( Duration as abap.dec( 13, 2) ) as AverageDuration,
      cast( 'USD' as abap.cuky ) as TargetCurrency      
     
}
where
  Status = 'N'
group by
  AgencyId,
  _agency.name
  having count( distinct TravelId ) > 1;
