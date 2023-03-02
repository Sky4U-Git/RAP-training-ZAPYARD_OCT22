@EndUserText.label: 'Projection BO: PO item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo:{
typeName: 'PurchaseItem',
typeNamePlural: 'Purchase Items',

title:{ value: 'ShortText' },
description:{

label: 'Manage Purchase Orders',
type: #STANDARD,
value: 'PurchaseItem'
}
}
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZC_AS_CDS_ITEM_PO
  as projection on ZI_AS_PO_ITEM_BO
{
  key PurchaseOrder,
      @ObjectModel.text.element: ['ShortText']
  key PurchaseItem,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      ShortText,
      Material,
      Plant,
      MaterialGroup,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      OrderQunt,
      OrderUnit,
      @Semantics.amount.currencyCode: 'PriceUnit'
      ProductPrice,
      @Semantics.amount.currencyCode: 'PriceUnit'
      ItemPrice,
      @UI.identification: [{ position: 80, label: 'Currency' }]
      PriceUnit,
      LocalLastChangedBy,
      LocalLastChangedAt,
      /* Associations */
      _Currency,
      _PurchaseHeader : redirected to parent ZC_AS_CDS_HEAD_PO
}
