@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Interface view: Supplier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_AS_SUPPLIER
  as select from zas_supplier_db
{
  key supplierid    as Supplierid,
      supplier_name as SupplierName,
      email_address as EmailAddress,
      phone_number  as PhoneNumber,
      fax_number    as FaxNumber,
      web_address   as WebAddress
}
