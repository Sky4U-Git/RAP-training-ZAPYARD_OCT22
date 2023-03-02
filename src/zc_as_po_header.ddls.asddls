@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption/Projection Views: PO header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['PurchaseOrder']
@Search.searchable: true
define view entity ZC_AS_PO_HEADER
  as select from zi_as_po_overallprice
  association [*] to ZC_AS_PO_ITEM   as _PurchaseItems on $projection.PurchaseOrder = _PurchaseItems.PurchaseOrder
  association [1] to ZC_AS_Ordertype as _OrderType     on $projection.OrderType = _OrderType.OrderType
  association [1] to ZC_AS_supplier  as _Supplier      on $projection.Supplier = _Supplier.Supplierid
  association [1] to ZC_as_po_status as _PoStatus      on $projection.OrderStatus = _PoStatus.Postatus
{
      @ObjectModel.text.element: ['Description']
  key PurchaseOrder,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #HIGH
      Description,
      @Semantics.amount.currencyCode: 'PriceUnit'
      PurchaseTotalPrice,
      PriceUnit,
      OrderType,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_AS_PO_STATUS', element: 'Postatus' } } ]
      @ObjectModel.text.element: ['Statusdesc']
      OrderStatus,
      _PoStatus.Statusdesc         as Statusdesc,
      CompanyCode,
      Organization,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_AS_SUPPLIER', element: 'Supplierid'} }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #MEDIUM
      @ObjectModel.text.element: ['SupplierName']
      @Consumption.filter.selectionType: #SINGLE
      Supplier,
      _Supplier.SupplierName       as SupplierName,
      case _PoStatus.Statusdesc
      when 'In Process' then 02           //Yellow
      when 'In Completed' then 03         //Green
      when 'Rejected' then 01             //Red
      else 00
      end                          as CriticalityValue,
      @Semantics.imageUrl: true
      Imageurl,

      CreateBy,
      CreatedDateTime,
      ChangedDateTime,
      LocalLastChangedBy,
      LastChangedAt,
      /* Associations */
      _OrderType,
      _PurchaseItems,
      _Supplier,
      _PoStatus
}
