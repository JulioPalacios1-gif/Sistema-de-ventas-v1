CREATE DATABASE SISTEMA_DE_VENTA

GO

USE SISTEMA_DE_VENTA

GO

create table ROL(
IdRol int primary key identity,
nombreRol varchar (50),
Descripcion varchar (50),
FechaCreacion datetime default getdate()
)
create table USUARIO(
IdUsuario int primary key identity,
Documento varchar (100),
NombreCompleto varchar (50),
Correo varchar (50),
Clave varchar (50),
rol_id int,
foreign key (rol_id) references ROL(IdRol),
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

create table PRODUCTO(
IdProducto int primary key identity,
Codigo varchar (50),
Nombre varchar (75),
Descripcion varchar (100),
categoria_id int,
foreign key (categoria_id) references CATEGORIA(IdCategoria),
proveedor_id int,
foreign key (proveedor_id) references PROVEEDOR(IdProveedor),
Stock int not null default 0,
PrecioCompra decimal (10, 2) default 0,
PrecioVenta decimal (10, 2) default 0,
Estado bit,
FechaRegistro datetime default getdate()
)
go

create table CLIENTE(
IdCliente int primary key identity,
Documento varchar (100),
NombreCompleto varchar (100),
Correo varchar (50),
Telefono varchar (50),
Estado bit,
FechaCreacion datetime default getdate()
)
go
create table COMPRA(
IdCompra int primary key identity,
usuario_id int,
foreign key (usuario_id) references USUARIO(IdUsuario),
TipoDocumento varchar (50),
NumeroDocumento varchar (50),
MontoTotal decimal (10, 2),
FechaRegistro datetime default getdate())
go

create table DETALLE_COMPRA(
IdDetalleCompra int primary key identity,
producto_id int,
foreign key (producto_id) references PRODUCTO(IdProducto),
compra_id int, 
foreign key (compra_id) references COMPRA(IdCompra),
PrecioCompra decimal (10, 2) default 0,
PrecioVenta decimal (10, 2) default 0,
Cantidad int,
MontoTotal decimal (10, 2),
FechaRegistro datetime default getdate())
go

create table VENTA(
IdVenta int primary key identity,
usuario_id int,
foreign key (usuario_id) references USUARIO(IdUsuario),
cliente_id int,
foreign key (cliente_id) references CLIENTE(IdCliente),
MontoPago decimal (10, 2),
MontoCambio decimal (10, 2),
MontoTotal decimal (10, 2),
FechaRegistro datetime default getdate())
go

create table DETALLE_VENTA(
IdDetalleVenta int primary key identity,
venta_id int, 
foreign key (venta_id) references VENTA(IdVenta),
producto_id int,
foreign key (producto_id) references PRODUCTO(IdProducto),
PrecioVenta decimal (10, 2) default 0,
Cantidad int,
SubTotal decimal (10, 2),
FechaRegistro datetime default getdate())
go
