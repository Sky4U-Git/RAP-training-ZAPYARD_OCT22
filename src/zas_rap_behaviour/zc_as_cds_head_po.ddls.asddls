@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection BO: PO header'
@ObjectModel.semanticKey: ['PurchaseOrder']
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_AS_CDS_HEAD_PO
  provider contract transactional_query
  as projection on ZI_AS_PO_HEADER_BO
{
      @ObjectModel.text.element: ['Description']
  key PurchaseOrder,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #HIGH
      Description,
      @Semantics.amount.currencyCode: 'PriceUnit'
      PurchaseTotalPrice,
      @UI.hidden: true
      PriceUnit,
      @Consumption.valueHelpDefinition: [{ entity:{name: 'ZC_AS_ORDERTYPE',element: 'OrderType'  } } ]
      OrderType,
      CompanyCode,
      Organization,
      @Consumption.valueHelpDefinition: [{ entity:{name: 'ZC_AS_PO_STATUS',element: 'Postatus'  } } ]
      @ObjectModel.text.element: ['StatusDesc']
      OrderStatus,
      _Status.Statusdesc,
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_AS_SUPPLIER', element: 'Supplierid' },
      additionalBinding: [{ element: 'CompanyCodeSupplier' ,localElement: 'CompanyCode'}] }]
      @ObjectModel.text.element: ['SupplierName']
      @Consumption.filter:{multipleSelections: false }
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
      @Search.defaultSearchElement: true
      _PurchaseItems : redirected to composition child ZC_AS_CDS_ITEM_PO,
      _Status,
      _Supplier
}
