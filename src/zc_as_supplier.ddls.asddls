@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view: Supplier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZC_AS_supplier
  as select from ZI_AS_SUPPLIER
{
      @ObjectModel.text.element: ['SupplierName']
  key Supplierid,
      @EndUserText.label: 'Supplier Name'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Semantics.text: true
      @Semantics.name.fullName: true
      SupplierName,
      @EndUserText.label: 'Email ID'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Semantics.eMail.type: [#WORK]
      EmailAddress,
      @EndUserText.label: 'Phone No.'
      @Semantics.telephone.type: [#WORK]
      PhoneNumber,
      @Semantics.telephone.type: [#FAX]
      @EndUserText.label: 'Fax No.'
      FaxNumber,
      @Semantics.telephone.type: [#FAX]
      @EndUserText.label: 'Website'
      WebAddress
}
