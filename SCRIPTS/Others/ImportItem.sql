select * from item where ItemId = 197
select * from item where ParentProdId = 197
--select * from importitem

--Insert into Item
--(
--	ItemType, HSNCode, ItemName, ItemSellingPrice, ItemStage
--)
--select ProdType, HSN, Item_Name, Price, Stage from importitem


select ItemType, HSNCode, ItemName, ItemSellingPrice, ItemStage, ItemSellingPrice from item
where ItemType = 'Assembly'

