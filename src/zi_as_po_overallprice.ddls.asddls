@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Interface view: PO header OP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_as_po_overallprice
  as select from ZI_AS_PO_HEADER
{
  key PurchaseOrder,
      Description,
      @Semantics.amount.currencyCode: 'PriceUnit'
      sum( _PurchaseItems.ItemPrice ) as PurchaseTotalPrice,
      _PurchaseItems.PriceUnit,
      OrderType,
      OrderStatus,
      CompanyCode,
      Organization,
      Supplier,
      Imageurl,
      CreateBy,
      CreatedDateTime,
      ChangedDateTime,
      LocalLastChangedBy,
      LastChangedAt,
      /* Associations */
      _OrderType,
      _PurchaseItems,
      _supplier
}
group by
  PurchaseOrder,
  Description,
  _PurchaseItems.PriceUnit,
  OrderType,
  OrderStatus,
  CompanyCode,
  Organization,
  Supplier,
  Imageurl,
  CreateBy,
  CreatedDateTime,
  ChangedDateTime,
  LocalLastChangedBy,
  LastChangedAt
