@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption/Projection Views: PO item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_AS_PO_ITEM
  as select from ZI_AS_PO_ITEM
  association [1] to ZC_AS_PO_HEADER as _PurchaseHeader on $projection.PurchaseOrder = _PurchaseHeader.PurchaseOrder
{
      @ObjectModel.text.element: ['PurchaseItem']
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
      @Semantics.amount.currencyCode: 'PriceUnit'
      ItemPrice,
      LocalLastChangedBy,
      LocalLastChangedAt,
      /* Associations */
      _PurchaseHeader,
      _Currency
}
