@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Interface view: PO attachment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_as_po_attach_tp
  as select from zas_po_attachmnt
  association to parent ZI_AS_PO_HEADER_TP as _PurchaseHeader on $projection.PurchaseOrder = _PurchaseHeader.PurchaseOrder
{
  key po_order        as PurchaseOrder,
  key attach_id       as AttachId,
      @Semantics.largeObject:{ mimeType: 'Mimetype',
                               fileName: 'Filename',
                               contentDispositionPreference: #INLINE }
      attachment      as Attachment,
      @Semantics.mimeType: true
      mimetype        as Mimetype,
      filename        as Filename,
      last_changed_at as LastChangedAt,
      _PurchaseHeader
}
