CREATE DATABASE SISTEMA_DE_VENTA

GO

USE SISTEMA_DE_VENTA

GO

--Las tablas están declaradas en el orden en que deben ser creadas para evitar problemas; las tablas deben ser creadas una por una

create table ROL(
IdRol int primary key identity(1,1),
nombreRol varchar (50) not null,
descripcionRol varchar (50) not null,
FechaCreacionRol datetime default getdate());
GO

create table USUARIO(
IdUsuario int primary key identity(1,1),
DocumentoUsuario varchar (100) unique not null,
nombreCompletoUsuario varchar (60) not null,
correoUsuario varchar (50) unique not null,
Clave varchar (50) not null,
rol_id int not null,
foreign key (rol_id) references ROL(IdRol),
Estado bit not null,
FechaCreacionUsuario datetime default getdate());
go

create table CATEGORIA(
IdCategoria int primary key identity(1,1),
descripcionCategoria varchar (100) not null,
Estado bit not null,
FechaCreacionCategoria datetime default getdate())
go

create table PROVEEDOR(
IdProveedor int primary key identity(1,1),
documentoProveedor varchar (100) unique not null,
razonSocialProveedor varchar (50) not null,
correoProveedor varchar (50) unique not null,
telefonoProveedor varchar (50) not null,
Estado bit not null,
FechaCreacionProveedor datetime default getdate());
go

create table PRODUCTO(
IdProducto int primary key identity(1,1),
codigoProducto varchar (50) unique not null,
nombreProducto varchar (75) not null,
descripcionProducto varchar (100) not null,
categoria_id int not null,
foreign key (categoria_id) references CATEGORIA(IdCategoria),
proveedor_id int not null,
foreign key (proveedor_id) references PROVEEDOR(IdProveedor),
Stock int not null default 0,
PrecioCompra decimal (10, 2) default 0,
PrecioVenta decimal (10, 2) default 0,
Estado bit not null,
FechaRegistroProducto datetime default getdate());
go

create table CLIENTE(
IdCliente int primary key identity(1,1),
documentoCliente varchar (100) unique not null,
nombreCompletoCliente varchar (100) not null,
correoCliente varchar (50) unique not null,
telefonoCliente varchar (50) not null,
Estado bit not null,
FechaCreacionCliente datetime default getdate());
go

create table TipoDocumentoCompra(
idTipoDocumentoCompra int identity(1,1) primary key,
nombreDocumentoCompra varchar (20));
go

create table COMPRA(
IdCompra int identity(1,1) primary key,
usuario_id int not null,
foreign key (usuario_id) references USUARIO(IdUsuario),
tipoDocumentoCompra_id int,
foreign key (tipoDocumentoCompra_id) references TIpoDocumentoCompra(idTipoDocumentoCompra),
MontoTotal decimal (10, 2),
FechaRegistro datetime default getdate());
go

create table DETALLE_COMPRA(
IdDetalleCompra int primary key identity(1,1),
producto_id int not null,
foreign key (producto_id) references PRODUCTO(IdProducto),
compra_id int not null, 
foreign key (compra_id) references COMPRA(IdCompra),
PrecioCompra decimal (10, 2) default 0.00,
PrecioVenta decimal (10, 2) default 0.00,
Cantidad int not null,
MontoTotal decimal (10, 2) default 0.00,
FechaRegistro datetime default getdate())
go

create table TipoDocumentoVenta(
idTipoDocumentoVenta int identity(1,1) primary key,
nombreTipoDocumentoVenta varchar (20) not null);
go

create table VENTA(
IdVenta int primary key identity,
usuario_id int not null,
foreign key (usuario_id) references USUARIO(IdUsuario),
cliente_id int not null,
foreign key (cliente_id) references CLIENTE(IdCliente),
tipoDocumentoVenta_id int,
foreign key (tipoDocumentoVenta_id) references TipoDocumentoVenta(idTipoDocumentoVenta),
MontoPago decimal (10, 2) default 0.00,
MontoCambio decimal (10, 2) default 0.00,
MontoTotal decimal (10, 2) default 0.00,
FechaRegistro datetime default getdate());
go


create table DETALLE_VENTA(
IdDetalleVenta int primary key identity,
venta_id int not null, 
foreign key (venta_id) references VENTA(IdVenta),
producto_id int not null,
foreign key (producto_id) references PRODUCTO(IdProducto),
PrecioVenta decimal (10, 2) default 0,
Cantidad int not null,
SubTotal decimal (10, 2) default 0,
FechaRegistro datetime default getdate());
go

create table DatosNegocio(
idNegocio int identity (1,1) primary key,
nombreNegocio varchar (20) not null,
NIT_DatoNegocio char(17) unique not null, --Se le da al NIT del negocio una longitud de 17 caracteres fijos, ya que son 14 números separados en bloques por 3 guiones
ubicacionNegocio varchar (60) not null);
go






INSERT INTO TipoDocumentoCompra (nombreDocumentoCompra) VALUES 
('Factura'),
('Boleta'),
('Crédito Fiscal');




INSERT INTO TipoDocumentoVenta (nombreTipoDocumentoVenta) VALUES 
('Factura'),
('Boleta'),
('Crédito Fiscal');



INSERT INTO PROVEEDOR (documentoProveedor, razonSocialProveedor, correoProveedor, telefonoProveedor, Estado) VALUES
('06123123-4', 'Distribuidora San Jorge', 'sanjorge@proveedor.com', '7890-1234', 1),
('06123124-5', 'Bebidas El Salvador', 'bebidassv@proveedor.com', '7890-5678', 1),
('06123125-6', 'Carnes Don Julio', 'carnesjulio@proveedor.com', '7890-9012', 1),
('06123126-7', 'Verduras Frescas', 'verduras@proveedor.com', '7890-3456', 1),
('06123127-8', 'Lácteos del Valle', 'lacteos@proveedor.com', '7890-7890', 1),
('06123128-9', 'Panadería Central', 'panes@proveedor.com', '7890-2345', 1),
('06123129-0', 'Embutidos Selectos', 'embutidos@proveedor.com', '7890-6789', 1),
('06123130-1', 'Huevos La Granja', 'huevos@proveedor.com', '7890-1122', 1),
('06123131-2', 'Frutas Tropicales', 'frutas@proveedor.com', '7890-3344', 1),
('06123132-3', 'Utensilios de Cocina SV', 'utensilios@proveedor.com', '7890-5566', 1),
('06123133-4', 'Café de Altura', 'cafe@proveedor.com', '7890-7788', 1),
('06123134-5', 'Salsas y Condimentos', 'salsas@proveedor.com', '7890-9900', 1),
('06123135-6', 'Productos Congelados', 'congelados@proveedor.com', '7890-2244', 1),
('06123136-7', 'Arroz y Granos', 'granos@proveedor.com', '7890-6688', 1),
('06123137-8', 'Galletas y Postres', 'postres@proveedor.com', '7890-8800', 1);



INSERT INTO CLIENTE (documentoCliente, nombreCompletoCliente, correoCliente, telefonoCliente, Estado) VALUES
('07012345-6', 'Ana Morales', 'ana.morales@gmail.com', '7777-1111', 1),
('07012346-7', 'Carlos García', 'carlos.garcia@gmail.com', '7777-2222', 1),
('07012347-8', 'Beatriz López', 'beatriz.lopez@gmail.com', '7777-3333', 1),
('07012348-9', 'Diego Pérez', 'diego.perez@gmail.com', '7777-4444', 1),
('07012349-0', 'Fátima Romero', 'fatima.romero@gmail.com', '7777-5555', 1),
('07012350-1', 'Luis Hernández', 'luis.hernandez@gmail.com', '7777-6666', 1),
('07012351-2', 'Gloria Méndez', 'gloria.mendez@gmail.com', '7777-7777', 1),
('07012352-3', 'Marcos Castillo', 'marcos.castillo@gmail.com', '7777-8888', 1),
('07012353-4', 'Iván Torres', 'ivan.torres@gmail.com', '7777-9999', 1),
('07012354-5', 'Carmen Aguilar', 'carmen.aguilar@gmail.com', '7777-0000', 1),
('07012355-6', 'Sofía Cabrera', 'sofia.cabrera@gmail.com', '7777-1212', 1),
('07012356-7', 'Eduardo Vásquez', 'eduardo.vasquez@gmail.com', '7777-3434', 1),
('07012357-8', 'Rebeca Cruz', 'rebeca.cruz@gmail.com', '7777-5656', 1),
('07012358-9', 'Tomás Jiménez', 'tomas.jimenez@gmail.com', '7777-7878', 1),
('07012359-0', 'Lorena Mejía', 'lorena.mejia@gmail.com', '7777-9090', 1);


INSERT INTO ROL (nombreRol, descripcionRol) VALUES 
('Administrador', 'Acceso total al sistema'),
('Empleado', 'Acceso limitado a funciones específicas');



--- rol_id = 1  sera el administrador del negocio y tendra acceso a todo el sistema
--- rol_id = 2  seran los empleados y tendran acceso limitado en el sistema

INSERT INTO USUARIO (DocumentoUsuario, nombreCompletoUsuario, correoUsuario, Clave, rol_id, Estado)
VALUES
('0001', 'Admin Isaac Valencia', 'admin@elbalde.com', 'admin123', 1, 1),
('0002', 'Carlos López', 'carlos@elbalde.com', 'empleado01', 2, 1),
('0003', 'Ana García', 'ana@elbalde.com', 'empleado02', 2, 1),
('0004', 'José Pérez', 'jose@elbalde.com', 'empleado03', 2, 1),
('0005', 'Lucía Torres', 'lucia@elbalde.com', 'empleado04', 2, 1),
('0006', 'David Morales', 'david@elbalde.com', 'empleado05', 2, 1),
('0007', 'Sofía Méndez', 'sofia@elbalde.com', 'empleado06', 2, 1),
('0008', 'Luis Ramírez', 'luis@elbalde.com', 'empleado07', 2, 1),
('0009', 'Paola Castro', 'paola@elbalde.com', 'empleado08', 2, 1),
('0010', 'Andrés Chávez', 'andres@elbalde.com', 'empleado09', 2, 1),
('0011', 'María Aguilar', 'maria@elbalde.com', 'empleado10', 2, 1),
('0012', 'Fernando Rivas', 'fernando@elbalde.com', 'empleado11', 2, 1),
('0013', 'Daniela Molina', 'daniela@elbalde.com', 'empleado12', 2, 1),
('0014', 'Esteban Cruz', 'esteban@elbalde.com', 'empleado13', 2, 1),
('0015', 'Gabriela Flores', 'gabriela@elbalde.com', 'empleado14', 2, 1);



---Estado =1 significa que hay stock o productos que pertenecen a esta categoria
--- Estado =2 significa que NO hay stock o producto que pertenecen a esta categoria
INSERT INTO CATEGORIA (descripcionCategoria, Estado)
VALUES 
('Carnes', 1),
('Embutidos', 1),
('Lácteos', 1),
('Panadería', 1),
('Postres', 1);


INSERT INTO PRODUCTO (codigoProducto, nombreProducto, descripcionProducto, categoria_id, proveedor_id, Stock, PrecioCompra, PrecioVenta, Estado)
VALUES
-- Bebidas (categoria_id = 1)
('B006', 'Gatorade 500ml', 'Bebida hidratante', 1, 2, 60, 0.50, 0.95, 1),
('B007', 'Té helado limón', 'Bebida fría sabor limón', 1, 2, 70, 0.45, 0.85, 1),

-- Comidas preparadas (categoria_id = 2)
('C011', 'Enchiladas', 'Tortilla con carne y vegetales', 2, 3, 25, 0.70, 1.25, 1),
('C012', 'Tacos al pastor', 'Tacos de cerdo', 2, 13, 35, 0.80, 1.40, 1),

-- Carnes (categoria_id = 3)
('CA01', 'Carne de res molida', 'Paquete de 1 lb', 3, 3, 40, 2.00, 3.00, 1),
('CA02', 'Carne de cerdo', 'Chuletas frescas', 3, 3, 30, 1.80, 2.70, 1),

-- Embutidos (categoria_id = 4)
('E001', 'Chorizo Argentino', 'Paquete de 10 unidades', 4, 7, 50, 1.50, 2.25, 1),
('E002', 'Salchicha Toledo', 'Paquete de 6', 4, 7, 60, 1.20, 2.00, 1),

-- Lacteos (categoria_id = 5)
('L001', 'Queso fresco', '250g de queso artesanal', 5, 5, 45, 0.90, 1.60, 1),
('L002', 'Yogurt natural', 'Botella de 500ml', 5, 5, 50, 0.60, 1.00, 1),

-- Pan (categoria_id = 6)
('P001', 'Pan francés', 'Bolsita con 6 piezas', 6, 6, 100, 0.40, 0.75, 1),
('P002', 'Pan dulce', 'Empaquetado surtido', 6, 6, 80, 0.50, 0.90, 1),

-- Postres (categoria_id = 7)
('PS01', 'Flan de vainilla', 'Porción individual', 7, 15, 40, 0.50, 1.00, 1),
('PS02', 'Gelatina de colores', 'Vaso mediano', 7, 15, 30, 0.30, 0.60, 1);

select * from USUARIO