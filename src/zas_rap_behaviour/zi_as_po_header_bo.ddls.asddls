@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Behavioural feature: PO head'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_AS_PO_HEADER_BO
  as select from zi_as_po_overallprice
  composition [*] of ZI_AS_PO_ITEM_BO   as _PurchaseItems
  
  association [1] to ZC_AS_supplier     as _Supplier on $projection.Supplier = _Supplier.Supplierid
  association [1] to ZC_as_po_status    as _Status   on $projection.OrderStatus = _Status.Postatus
{
  key PurchaseOrder,
      Description,
      PurchaseTotalPrice,
      PriceUnit,
      OrderType,
      CompanyCode,
      Organization,
      OrderStatus,
      Supplier,
      Imageurl,
      case
      when OrderStatus = '01' then 2
      when OrderStatus = '02' then 3
      when OrderStatus = '03' then 1
      else 0
      end as CriticalityValue,
      @Semantics.user.createdBy: true
      CreateBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedDateTime,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      ChangedDateTime,
      @Semantics.user.lastChangedBy: true
      LocalLastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _OrderType,
      _PurchaseItems,
      _Status,
      _Supplier
}
