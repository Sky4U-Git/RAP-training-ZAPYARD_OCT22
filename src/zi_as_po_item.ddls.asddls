@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Interface view: PO item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_AS_PO_ITEM
  as select from zas_po_item_db
  association [1] to ZI_AS_PO_HEADER as _PurchaseHeader on $projection.PurchaseOrder = _PurchaseHeader.PurchaseOrder
  association [1] to I_Currency      as _Currency       on $projection.PriceUnit = _Currency.Currency
{
  key po_order                                                                                                  as PurchaseOrder,
  key po_item                                                                                                   as PurchaseItem,
      short_text                                                                                                as ShortText,
      material                                                                                                  as Material,
      plant                                                                                                     as Plant,
      mat_group                                                                                                 as MaterialGroup,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      order_qunt                                                                                                as OrderQunt,
      order_unit                                                                                                as OrderUnit,
      @Semantics.amount.currencyCode: 'PriceUnit'
      product_price                                                                                             as ProductPrice,
      price_unit                                                                                                as PriceUnit,
      cast(  cast( order_qunt as abap.dec( 10, 2 )) * cast( product_price as abap.dec(10,2)) as abap.dec(10,2)) as ItemPrice,
      local_last_changed_by                                                                                     as LocalLastChangedBy,
      local_last_changed_at                                                                                     as LocalLastChangedAt,
      _PurchaseHeader,
      _Currency
}
