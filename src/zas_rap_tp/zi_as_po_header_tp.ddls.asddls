@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view: PO header TP'
define root view entity ZI_AS_PO_HEADER_TP
  as select from zi_as_po_overallprice
  composition [0..*] of ZI_AS_PO_item_TP as _PurchaseItems
  composition [*] of zi_as_po_attach_tp as _PoAttachments
  
  association to ZC_AS_supplier       as _Supplier    on $projection.Supplier = _Supplier.Supplierid
  association to ZC_AS_Ordertype      as _OrderType   on $projection.OrderType = _OrderType.OrderType
  association to ZC_as_po_status      as _OrderStatus on $projection.OrderStatus = _OrderStatus.Postatus
  association to I_Currency           as _Currency    on $projection.PriceUnit = _Currency.Currency
{
  key PurchaseOrder,
      Description,
      PurchaseTotalPrice,
      PriceUnit,
      OrderType,
      OrderStatus,
      CompanyCode,
      Organization,
      Supplier,
      case _OrderStatus.Statusdesc
            when 'In Process' then 02           //Yellow
            when 'In Completed' then 03         //Green
            when 'Rejected' then 01             //Red
            else 00
      end as CriticalityValue,
      Imageurl,
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
      _PoAttachments,
      _OrderStatus,
      _Currency,
      _Supplier // Make association public
}
