@EndUserText.label: 'Consumption view: PO header TP'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['PurchaseOrder']
@Search.searchable: true
define root view entity ZC_AS_PO_HEADER_TP
  provider contract transactional_query
  as projection on ZI_AS_PO_HEADER_TP
{
      @ObjectModel.text.element: ['Description']
  key PurchaseOrder,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #HIGH
      Description,
      @Semantics.amount.currencyCode: 'PriceUnit'
      PurchaseTotalPrice,
      //      @UI.hidden: true
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_Currency', element: 'Currency'} }]
      PriceUnit,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZC_AS_ORDERTYPE', element: 'OrderType'} }]
      OrderType,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZC_AS_PO_STATUS', element: 'Postatus'} }]
      @ObjectModel.text.element: ['Statusdesc']
      OrderStatus,
      _OrderStatus.Statusdesc,
      CompanyCode,
      Organization,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #HIGH
      @ObjectModel.text.element: ['SupplierName']
      @Consumption.filter.selectionType: #SINGLE
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_AS_SUPPLIER', element: 'Supplierid' } }]
      Supplier,
      _Supplier.SupplierName,
      @Semantics.imageUrl: true
      Imageurl,
      @UI.hidden: true
      CriticalityValue,
      CreateBy,
      CreatedDateTime,
      ChangedDateTime,
      LocalLastChangedBy,
      LastChangedAt,
      /* Associations */
      _OrderType,
      _PurchaseItems : redirected to composition child ZC_AS_PO_ITEM_TP,
      _PoAttachments : redirected to composition child ZC_AS_PO_ATTACH_TP,
      _Currency,
      _Supplier
}
