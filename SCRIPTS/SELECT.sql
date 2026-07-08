----- Masters
--delete from company
select * from company
exec SP_GetCompany

Select * from Branch
exec SP_GetBranch

select * from Employee
select * from Users
--delete Employee
--delete Users
exec SP_GetEmployee

--select DefaultDataName, DefaultDataDesc from defaultdata 
select CreatedUserId, CreatedDate, ModifiedUserId, ModifiedDate from defaultdata

select * from DefaultData

select * from Enqhdr
select * from EnqDtl
select * from EnqLandDoor
select * from EnqCarDoor 
select * from EnqClient
select * from EnqFollowUp

select * from QuoteHdr
--select * from QuoteDtl
select * from EnqDtl

select * from enqLandDoor
select * from enqcardoor

select * from OrdClientHdr
select * from OrdClientAddr

select * from OrdApprove


select * from SOHdr
select * from SoDtl
select * from SOLandDoor
select * from SOcarDoor

select * from JobOrderPVR
select * from JobOrderPVRFloor

select * from JobOrder
select * from JobOrderSVRHdr
select * from JobOrderSVRDtl



select DefaultDataName, DefaultDataDesc from defaultdata 

select * from Employee
select * from EmpAcademic
select * from EmpPastEmployment
select * from EmpAssets
select * from EmpDocs

select * from Item
select ItemType, ItemName from Item where ItemType = 'Product' order by ItemCode
select ItemType, ItemName from Item where ItemType = 'Assembly' order by ItemCode
select ItemType, ItemName from Item where ItemType = 'Raw-Material' 

select * from Users
select * from MenuPermissions
select * from Menus

select * from BOM
select * from filepath

select * from DefaultDataDocs where DefaultDataDocType = 'CRM'
select * from DefaultDataDocs where DefaultDataDocType = 'DESIGN'

select * from JobOrderDoc

select * from JobOrder
select * from JobOrderPVR
select * from JobOrderPVRFloor


select * from JobOrder
select * from JobOrderSVRHdr
select * from JobOrderSVRDtl

select * from JobOrderSCRHdr
select * from JobOrderSCRDtl
select * from JobOrderPTCDtl


Select * from QuoteHdrItem
Select * from QuoteDtlItem

Select * from item


Select * from AssemblyHdr  
Select * from AssemblyItem
Select * from BOMMst

Select * from JobOrderBOM





































--select * from Stock_ImportToSql
  
--select * from Enqhdr where EnqHdrId = 155
--select * from EnqDtl where EnqHdrId = 155
--select * from EnqLandDoor where EnqdtlId = 149
--select * from EnqCarDoor where EnqdtlId = 149

--exec SP_GetEmp_ById 36,'employee'
--exec SP_GetEmp_ById 36,'empacademic'
--exec SP_GetEmp_ById 36,'EMPPASTEMPLOYMENT'
--exec SP_GetEmp_ById 36,'empassets'
--exec SP_GetEmp_ById 36,'empdocs'





















