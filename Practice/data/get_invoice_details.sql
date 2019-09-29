SELECT
	toi.OriginalInvoiceId,
	toi.DocumentId,
	tis.Type AS ProcessingStatus,
	td.DocumentSubType AS DocumentSubType,
	tci.InvoiceNo,
	tci.InvoiceDate,
	tci.DueDate,
	tci.TransactionCurrency,
	tci.BaseCurrency,
	tei.CurrencyCode AS EntityInformationBaseCurrency,
	tci.ConversionRate,
	tci.NetAmount,
	tci.TaxAmount,
	tci.GrossAmount,
	tci.ConvertedNetAmount,
	tci.ConvertedVatAmount,
	tci.ConvertedGrossAmount,
	tci.SupplierName AS SupplierID,
	vi.CompanyName AS SupplierName,
	tci.CategoryId AS CategoryID,
	c.Title AS CategoryName,
	tci.PaymentMethod AS PaymentMethodID,
	pm.AccountName AS PaymentMethodName,
	tci.TaxPercent AS VATID,
	v.VATName AS VATName,
	v.Percentage,
	tci.Details,		
	tci.CommentText,
	'app.receipt-bot.com'+toi.FilePath + CONCAT('/', toi.FileName) AS FilePath
FROM dbo.tblOriginalInvoice toi
	LEFT OUTER JOIN dbo.tblEntityInformation tei ON toi.EntityId = tei.EntityId
	JOIN dbo.tblOrganizationInformation toi2 ON toi2.OrgId = tei.OrganizationId
	LEFT OUTER JOIN dbo.tblInvoiceStatus tis ON toi.OriginalInvoiceId = tis.OrigionalInvoiceId
	LEFT OUTER JOIN dbo.tblConvertedInvoice tci ON toi.OriginalInvoiceId = tci.OrigionalInvoiceId
	--LEFT OUTER JOIN v_Documents vd ON toi.OriginalInvoiceId = vd.DocumentId AND vd.FileType = 'Invoices'
	LEFT OUTER JOIN tblDocuments td ON toi.DocumentId = td.DocumentId AND toi.EntityID = td.EntityId
	LEFT OUTER JOIN dbo.tblExternalErrorMessage teem ON toi.OriginalInvoiceId = teem.OrignalInvoiceId
	LEFT OUTER JOIN MasterData.VendorInformation vi ON tci.SupplierName = vi.RebotVendorMasterID
	LEFT OUTER JOIN MasterData.COA c ON tci.CategoryId = c.COAID
	LEFT OUTER JOIN MasterData.PaymentMethod pm ON tci.PaymentMethod = pm.PaymentMethodID
	LEFT OUTER JOIN MasterData.VAT v ON tci.TaxPercent = v.VATID
WHERE 	
	tei.isArchive = 0 AND tei.isActive = 1
	AND tei.EntityName LIKE '%{entityName}%'
ORDER BY 
	toi.DocumentId;