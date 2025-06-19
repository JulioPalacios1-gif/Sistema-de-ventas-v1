

CREATE DATABASE SISTEMA_DE_VENTA

GO

USE SISTEMA_DE_VENTA

GO

create table ROL(
IdRol int primary key identity,
Descripcion varchar (50),
FechaCreacion datetime default getdate()
)

create table PERMISOS(
IdPermiso int primary key identity,
IdRol int references ROL(IdRol),
NombreMenu varchar (100),
FechaCreacion datetime default getdate()
)

go


create table PROVEEDOR(
IdProveedor int primary key identity,
Documento varchar (100),
RazonSocial varchar (50),
Correo varchar (50),
Telefono varchar (50),
Estado bit,
FechaCreacion datetime default getdate()
)

go



create table CLIENTE(
IdCliente int primary key identity,
Documento varchar (100),
NombreCompleto varchar (50),
Correo varchar (50),
Telefono varchar (50),
Estado bit,
FechaCreacion datetime default getdate()
)

go

create table USUARIO(
IdUsuario int primary key identity,
Documento varchar (100),
NombreCompleto varchar (50),
Correo varchar (50),
Clave varchar (50),
IdRol int references ROL(IdRol),
Estado bit,
FechaCreacion datetime default getdate()
)

go


create table CATEGORIA(
IdCategoria int primary key identity,
Descripcion varchar (100),
Estado bit,
FechaCreacion datetime default getdate()
)

go

create table PRODUCTO(
IdProducto int primary key identity,
Codigo varchar (50),
Nombre varchar (75),
Descripcion varchar (100),
IdCategoria int references CATEGORIA(IdCategoria),
Stock int not null default 0,
PrecioCompra decimal (10, 2) default 0,
PrecioVenta decimal (10, 2) default 0,
Estado bit,
FechaRegistro datetime default getdate()
)

go

create table COMPRA(
IdCompra int primary key identity,
IdUsuario int references USUARIO(IdUsuario),
IdProveedor int references PROVEEDOR(IdProveedor),
TipoDocumento varchar (50),
NumeroDocumento varchar (50),
MontoTotal decimal (10, 2),
FechaRegistro datetime default getdate()
)

go


create table DETALLE_COMPRA(
IdDetalleCompra int primary key identity,
IdCompra int references COMPRA(IdCompra),
IdProducto int references PRODUCTO(IdProducto),
PrecioCompra decimal (10, 2) default 0,
PrecioVenta decimal (10, 2) default 0,
Cantidad int,
MontoTotal decimal (10, 2),
FechaRegistro datetime default getdate()
)

go

create table VENTA(
IdVenta int primary key identity,
IdUsuario int references USUARIO(IdUsuario),
TipoDocumento varchar (50),
NumeroDocumento varchar (50),
DocumentoCliente varchar (50),
NombreCliente varchar (50),
MontoPago decimal (10, 2),
MontoCambio decimal (10, 2),
MontoTotal decimal (10, 2),
FechaRegistro datetime default getdate()
)

go

create table DETALLE_VENTA(
IdDetalleVenta int primary key identity,
IdVenta int references VENTA(IdVenta),
IdProducto int references PRODUCTO(IdProducto),
PrecioVenta decimal (10, 2) default 0,
Cantidad int,
SubTotal decimal (10, 2),
FechaRegistro datetime default getdate()
)

go







