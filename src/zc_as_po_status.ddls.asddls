@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view: PO status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZC_as_po_status
  as select from ZI_PO_STATUS
{
      @ObjectModel.text.element: ['Statusdesc']
      @EndUserText.label: 'Status'
  key Postatus,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Semantics.text:true
      @EndUserText.label: 'Description'
      Statusdesc
}
