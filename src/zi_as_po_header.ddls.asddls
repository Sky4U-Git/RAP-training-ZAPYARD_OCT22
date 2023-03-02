@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Interface view: PO header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_AS_PO_HEADER
  as select from zas_po_header_db
  association [0..*] to ZI_AS_PO_ITEM    as _PurchaseItems on $projection.PurchaseOrder = _PurchaseItems.PurchaseOrder
  association [1]    to ZI_AS_ORDER_TYPE as _OrderType     on $projection.OrderType = _OrderType.OrderType
  association [1]    to ZI_AS_SUPPLIER   as _supplier      on $projection.Supplier = _supplier.Supplierid
  association [1]    to ZI_PO_STATUS     as _Status        on $projection.OrderStatus = _Status.Postatus
{
  key po_order              as PurchaseOrder,
      po_desc               as Description,
      po_type               as OrderType,
      comp_code             as CompanyCode,
      po_org                as Organization,
      po_status             as OrderStatus,
      supplier              as Supplier,
      imageurl              as Imageurl,
      create_by             as CreateBy,
      created_date_time     as CreatedDateTime,
      changed_date_time     as ChangedDateTime,
      local_last_changed_by as LocalLastChangedBy,
      last_changed_at       as LastChangedAt,
      _PurchaseItems,
      _OrderType,
      _supplier,
      _Status
}
