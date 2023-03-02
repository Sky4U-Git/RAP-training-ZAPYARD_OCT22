@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view: PO item TP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_AS_PO_item_TP
  as select from ZI_AS_PO_ITEM
  association to parent ZI_AS_PO_HEADER_TP as _purchaseHeader on $projection.PurchaseOrder = _purchaseHeader.PurchaseOrder
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
      _purchaseHeader
}
