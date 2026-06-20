INSERT INTO Menus
(MenuId, ParentMenuId, MenuName, MenuPath, MenuIcon, SortOrder, IsActive)
VALUES

-- Dashboard
(1, NULL, 'Dashboard', '/dashboard', 'dashboard', 1, 1),

-- Masters
(2, NULL, 'Masters', NULL, 'database', 2, 1),
(3, 2, 'Customers', '/masters/customers', 'users', 1, 1),
(4, 2, 'Suppliers', '/masters/suppliers', 'truck', 2, 1),
(5, 2, 'Items', '/masters/items', 'box', 3, 1),

-- Sales
(6, NULL, 'Sales', NULL, 'shopping-cart', 3, 1),
(7, 6, 'Enquiry', '/sales/enquiry', 'file-text', 1, 1),
(8, 6, 'Quotation', '/sales/quotation', 'file', 2, 1),
(9, 6, 'Sales Order', '/sales/order', 'shopping-bag', 3, 1),

-- Purchase
(10, NULL, 'Purchase', NULL, 'briefcase', 4, 1),
(11, 10, 'Purchase Order', '/purchase/order', 'file-plus', 1, 1),
(12, 10, 'GRN', '/purchase/grn', 'archive', 2, 1),

-- Reports
(13, NULL, 'Reports', NULL, 'bar-chart', 5, 1),
(14, 13, 'Sales Report', '/reports/sales', 'pie-chart', 1, 1),
(15, 13, 'Purchase Report', '/reports/purchase', 'activity', 2, 1),

-- Settings
(16, NULL, 'Settings', NULL, 'settings', 6, 1),
(17, 16, 'Users', '/settings/users', 'user', 1, 1),
(18, 16, 'Roles', '/settings/roles', 'shield', 2, 1),
(19, 16, 'Menu Permissions', '/settings/permissions', 'lock', 3, 1);