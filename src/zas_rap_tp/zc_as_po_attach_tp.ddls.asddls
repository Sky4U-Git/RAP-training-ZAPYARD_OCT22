@EndUserText.label: 'Projection view: PO attachment'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI: {
headerInfo: {
typeName: 'Attachment',
typeNamePlural: 'Attachments',
title:       { type: #STANDARD, value: 'Purchaseorder' },
description: { type: #STANDARD, value: 'Purchaseorder' }
            }
            ,
         presentationVariant: [{
         sortOrder: [{ by: 'AttachId', direction: #DESC }],
         visualizations: [{type: #AS_LINEITEM}]
         }]
      }
define view entity ZC_AS_PO_ATTACH_TP
  as projection on zi_as_po_attach_tp
{
      @UI.facet: [    {
                 label: 'General Information',
                 id: 'GeneralInfo',
                 type: #COLLECTION,
                 position: 10
                 },
                   {
                     id:            'POInfo',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Purchase Order',
                     parentId: 'GeneralInfo',
                     position:      10 },
                   {
                     id: 'Upload',
                     purpose: #STANDARD,
                     type: #FIELDGROUP_REFERENCE,
                     parentId: 'GeneralInfo',
                     label: 'Upload Attachment',
                     position: 20,
                     targetQualifier: 'Upload'
                   } ]
      @UI.lineItem: [{ position: 10, label: 'Purchase Order' }]
      @UI.identification: [{ position: 10, label: 'Purchase Order' }]
  key PurchaseOrder,
      @UI.lineItem: [{ position: 20, label: 'Attachment Id' }]
      @UI.identification: [{ position: 20, label: 'Attachment Id' }]
  key AttachId,
      @UI.fieldGroup: [{ position: 10, label: 'Attachment',qualifier: 'Upload' }]
      @UI.lineItem: [{ position: 30, label: 'File',importance: #HIGH  }]
      Attachment,
      @UI.hidden: true
      Mimetype,
      @UI.hidden: true
      Filename,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _PurchaseHeader : redirected to parent ZC_AS_PO_HEADER_TP
}
