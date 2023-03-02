@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Behavioural feature: PO Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_AS_PO_ITEM_BO
  as select from ZI_AS_PO_ITEM
  association to parent ZI_AS_PO_HEADER_BO as _PurchaseHeader on $projection.PurchaseOrder = _PurchaseHeader.PurchaseOrder
{
  key PurchaseOrder,
  key PurchaseItem,
      ShortText,
      Material,
      Plant,
      MaterialGroup,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      OrderQunt,
      OrderUnit,
      @Semantics.amount.currencyCode: 'PriceUnit'
      ProductPrice,
      PriceUnit,
      ItemPrice,
      LocalLastChangedBy,
      LocalLastChangedAt,
      /* Associations */
      _Currency,
      _PurchaseHeader
}
