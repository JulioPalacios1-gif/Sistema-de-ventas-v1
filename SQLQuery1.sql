CREATE DATABASE SISTEMA_DE_VENTA

GO

USE SISTEMA_DE_VENTA

GO

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