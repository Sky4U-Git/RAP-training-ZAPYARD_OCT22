@EndUserText.label: 'Consumption Views: PO item UM'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: { typeName: 'Purchase Item',
                  typeNamePlural: 'Purchase Items',
                  title : { value: 'ShortText' },
                  description:{ label: 'Manage Purchase Orders',
                                type: #STANDARD,
                                value: 'PurchaseItem'
}
}
@Search.searchable: true
define view entity ZC_AS_PO_ITEM_UM
  as projection on ZI_AS_PO_ITEM_UM
{
      @UI.facet: [{
        id:'ItemData',
        type:#IDENTIFICATION_REFERENCE,
        label: 'Item Info',
        position: 10,
        purpose: #STANDARD
         }]

  key PurchaseOrder,
      @ObjectModel.text.element: ['ShortText']
      @UI.lineItem: [{ position: 10, label: 'Item' }]
  key PurchaseItem,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @UI.identification: [{ position: 10, label: 'Item Description' }]
      ShortText,
      @UI.lineItem: [{ position: 20, label: 'Material' }]
      @UI.identification: [{ position: 20, label: 'Material' }]
      Material,
      @UI.identification: [{ position: 30, label: 'Plant' }]
      @UI.lineItem: [{ position: 30, label: 'Plant' }]
      Plant,
      @UI.identification: [{ position: 40, label: 'Material group' }]
      @UI.lineItem: [{ position: 40, label: 'Material Group' }]
      MaterialGroup,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      @UI.lineItem: [{ position: 50, label: 'Quantity' }]
      // @UI.textArrangement: #TEXT_ONLY
      @UI.identification: [{ position: 50, label: 'Quantity' }]
      OrderQunt,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_UNITOFMEASURE', element: 'UnitOfMeasure'} }]
      //      @UI.identification: [{ position: 50, label: 'Unit' }]
      OrderUnit,
      @Semantics.amount.currencyCode: 'PriceUnit'
      @UI.lineItem: [{ position: 60, label: 'Product Price' }]
      //@UI.textArrangement: #TEXT_ONLY
      @UI.identification: [{ position: 60, label: 'Product Price' }]
      ProductPrice,
      //      @UI.identification: [{ position: 80, label: 'Currency' }]
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_Currency', element: 'Currency'} }]
      PriceUnit,
      @UI.lineItem: [{ position: 70, label: 'Item Total Price' }]
      //       @ObjectModel.readOnly: true
      @Semantics.amount.currencyCode: 'PriceUnit'
      @UI.identification: [{ position: 70, label: 'Item Total Price' }]
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_Currency', element: 'Currency'} }]
      ItemPrice,
      LocalLastChangedBy,
      LocalLastChangedAt,
      /* Associations */
      _Currency,
      _purchaseHeader : redirected to parent ZC_AS_PO_HEAD_UM
}
