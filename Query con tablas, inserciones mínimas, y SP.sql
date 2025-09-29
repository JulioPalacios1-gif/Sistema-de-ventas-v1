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

INSERT INTO ROL (nombreRol, descripcionRol) VALUES 
('Administrador', 'Acceso total al sistema'),
('Empleado', 'Acceso limitado a funciones específicas');

create table USUARIO(
IdUsuario int primary key identity(1,1),
DocumentoUsuario varchar (100) unique not null,
nombreCompletoUsuario varchar (60) not null,
correoUsuario varchar (50) unique not null,
Clave varchar (60) not null,
rol_id int not null,
foreign key (rol_id) references ROL(IdRol),
Estado bit not null,
FechaCreacionUsuario datetime default getdate());
go

INSERT INTO USUARIO (DocumentoUsuario, nombreCompletoUsuario, correoUsuario, Clave, rol_id, Estado)
VALUES
('0001', 'Admin', 'admin@elbalde.com', '$2a$11$wBKl1qAy88aZKr0R83z9Te1/sblMb0Nt0gXgL3PpsIrKaUvwfzzsW', 1, 1),
('0002', 'Empleado', 'empleado@elbalde.com', '$2a$11$3.ju6JtLj/9HWch6Nx5LouaUzk8xy6Go8B9Pmh1v8qb4lF.UZLa1S', 2, 1);

create table CATEGORIA(
IdCategoria int primary key identity(1,1),
descripcionCategoria varchar (100) not null,
Estado bit not null,
FechaCreacionCategoria datetime default getdate())
go

INSERT INTO CATEGORIA (descripcionCategoria, Estado)
VALUES 
('Categoría', 1);

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
foreign key (categoria_id) references CATEGORIA(IdCategoria) on delete cascade,
proveedor_id int not null,
foreign key (proveedor_id) references PROVEEDOR(IdProveedor) on delete cascade,
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

INSERT INTO CLIENTE (documentoCliente, nombreCompletoCliente, correoCliente, telefonoCliente, Estado) VALUES
('########-#', 'Cliente', 'cliente@gmail.com', '####-####', 1),

create table TipoDocumentoCompra(
idTipoDocumentoCompra int identity(1,1) primary key,
nombreDocumentoCompra varchar (20));
go

INSERT INTO TipoDocumentoCompra (nombreDocumentoCompra) VALUES 
('Factura'),
('Boleta'),
('Crédito Fiscal');

create table COMPRA(
IdCompra int identity(1,1) primary key,
usuario_id int not null,
NumeroDocumentoCompra int unique,
foreign key (usuario_id) references USUARIO(IdUsuario) on delete cascade,
tipoDocumentoCompra_id int,
foreign key (tipoDocumentoCompra_id) references TIpoDocumentoCompra(idTipoDocumentoCompra),
MontoTotal decimal (10, 2),
FechaRegistro datetime default getdate());
go

create table DETALLE_COMPRA(
IdDetalleCompra int primary key identity(1,1),
producto_id int not null,
foreign key (producto_id) references PRODUCTO(IdProducto) on delete cascade,
compra_id int not null, 
foreign key (compra_id) references COMPRA(IdCompra) on delete cascade,
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

INSERT INTO TipoDocumentoVenta (nombreTipoDocumentoVenta) VALUES 
('Factura'),
('Boleta'),
('Crédito Fiscal');

create table VENTA(
IdVenta int primary key identity,
NumeroDocumentoVenta int,
usuario_id int not null,
foreign key (usuario_id) references USUARIO(IdUsuario) on delete cascade,
cliente_id int not null,
foreign key (cliente_id) references CLIENTE(IdCliente) on delete cascade,
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
foreign key (venta_id) references VENTA(IdVenta) on delete cascade,
producto_id int not null,
foreign key (producto_id) references PRODUCTO(IdProducto) on delete cascade,
PrecioVenta decimal (10, 2) default 0,
Cantidad int not null,
SubTotal decimal (10, 2) default 0,
FechaRegistro datetime default getdate());
go

create table DatosNegocio(
idNegocio int primary key,
nombreNegocio varchar (20) not null,
NIT_DatoNegocio char(17) unique not null, --Se le da al NIT del negocio una longitud de 17 caracteres fijos, ya que son 14 números separados en bloques por 3 guiones
ubicacionNegocio varchar (100) not null,
logoNegocio varbinary(max) null);
go

insert into DatosNegocio (idNegocio, nombreNegocio, NIT_DatoNegocio, ubicacionNegocio) values (1, '.', '####-######-###-#', '.');
go

create PROC SP_REGISTRARUSUARIO(
@Documento varchar(50),
@nombreCompletoUsuario varchar (100),
@correoUsuario varchar (100),
@Clave varchar (100),
@rol_id int,
@Estado bit,
@IdUsuarioResultado int output,
@Mensaje varchar (500) output
)
as
begin 
	set @IdUsuarioResultado = 0 
	set @Mensaje = ''

	if not exists(select * from USUARIO where DocumentoUsuario = @Documento)
	begin
		insert into USUARIO (DocumentoUsuario, nombreCompletoUsuario, correoUsuario, Clave, rol_id, Estado) values
		(@Documento, @nombreCompletoUsuario, @correoUsuario, @Clave, @rol_id, @Estado)

		set @IdUsuarioResultado = SCOPE_IDENTITY()

	end
	else
		set @Mensaje = 'No se puede repetir el documento para mas de un usuario'

end
go


create PROC SP_EDITARUSUARIO(
@idUsuario int,
@Documento varchar(50),
@nombreCompletoUsuario varchar (100),
@correoUsuario varchar (100),
@Clave varchar (100),
@rol_id int,
@Estado bit output,
@Respuesta BIT output,
@Mensaje varchar (500) output
)
as
begin 
	set @Respuesta = 0 
	set @Mensaje = ''

	if not exists(select * from USUARIO where DocumentoUsuario = @Documento and IdUsuario != @idUsuario)
	begin
		update USUARIO set
		DocumentoUsuario = @Documento,
		nombreCompletoUsuario = @nombreCompletoUsuario,
		correoUsuario = @correoUsuario,
		Clave = @Clave,
		rol_id = @rol_id,
		Estado = @Estado
		where IdUsuario = @idUsuario
		

		set @Respuesta = 1

	end
	else
		set @Mensaje = 'No se puede repetir el documento para mas de un usuario'

end
go


create PROC SP_ELIMINARUSUARIO(
@idUsuario int,
@Respuesta BIT output,
@Mensaje varchar (500) output
)
as
begin 
	set @Respuesta = 0 
	set @Mensaje = ''
	declare @PasoReglas bit = 1

	IF Exists(select * from VENTA V 
	inner join USUARIO U on U.IdUsuario = V.usuario_id 
	where U.IdUsuario = @idUsuario)

	begin
		set @PasoReglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar, el usuario se encuentra relacionado a una venta\n'
	end

		IF Exists(select * from COMPRA C 
	inner join USUARIO U on U.IdUsuario = C.usuario_id 
	where U.IdUsuario = @idUsuario)

	begin
		set @PasoReglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar, el usuario se encuentra relacionado a una compra\n'
	end

	if (@PasoReglas = 1)
	begin
		delete from USUARIO where IdUsuario = @idUsuario
		set @Respuesta = 1
	end
end
go

create Proc SP_RegistrarProveedor(
@Documento varchar (50),
@RazonSocial varchar (50),
@Correo varchar (50),
@Telefono varchar (50),
@Estado bit,
@Resultado int output,
@Mensaje varchar (500) output)
as
begin
	SET @Resultado = 0
	declare @IDPERSONA int
	if not exists (select * from PROVEEDOR where documentoProveedor = @Documento)
	begin
	insert into PROVEEDOR (documentoProveedor, razonSocialProveedor, correoProveedor, telefonoProveedor, Estado) values (
	@Documento, @RazonSocial, @Correo, @Telefono, @Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'El numero de documento ya existe'
	end
go

create Proc SP_ModificarProveedor(
@idProveedor int,
@Documento varchar (50),
@RazonSocial varchar (50),
@Correo varchar (50),
@Telefono varchar (50),
@Estado bit,
@Resultado int output,
@Mensaje varchar (500) output)
as
begin 
	set @Resultado = 1 
	declare @ISPERSONA int 
	if NOT EXISTS (select * from PROVEEDOR where documentoProveedor = @Documento and IdProveedor != @idProveedor)
	begin 
		update PROVEEDOR set 
		documentoProveedor = @Documento,
		razonSocialProveedor = @RazonSocial,
		correoProveedor = @Correo,
		telefonoProveedor = @Telefono,
		Estado = @Estado
		where IdProveedor = @idProveedor
	end
	else
	begin
			set @Resultado = 0
			set @Mensaje = 'El numero de documento ya existe'
	end
end
go

create Proc SP_EliminarProveedor(
@IdProveedor int, 
@Resultado bit output,
@Mensaje varchar (500) output)
as
begin 
	set @Resultado = 1
	begin 
	delete top(1) from PROVEEDOR where IdProveedor = @IdProveedor
	end
	end
go

create  proc SP_CrearCategoria(
@Descripcion varchar(50),
@Resultado bit output,
@Estado bit,
@Mensaje varchar(500) output
) as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT *FROM CATEGORIA WHERE descripcionCategoria = @Descripcion)
	begin
		insert into CATEGORIA(descripcionCategoria, Estado) values (@Descripcion, @Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	ELSE
		set @Mensaje='No se puede repetir la descripción de una categoría'
end
go

create PROC SP_ModificarCategoria(
@IdCategoria int,
@Estado bit,
@Descripcion varchar(50),
@Resultado bit output,
@Mensaje varchar(500) output
) as
begin
	SET @Resultado = 1
	IF NOT EXISTS (SELECT *FROM CATEGORIA WHERE descripcionCategoria = @Descripcion and IdCategoria!=@IdCategoria)
		update CATEGORIA set descripcionCategoria=@Descripcion, Estado=@Estado where IdCategoria=@IdCategoria
	else
	begin
		set @Resultado=0
		set @Mensaje='No se puede repetir la descripción de una categoría'
	end
end
go

CREATE PROC SP_EliminarCategoria(
@IdCategoria int,
@Resultado bit output,
@Mensaje varchar(500) output
) as
begin
	SET @Resultado = 1
	IF NOT EXISTS (select *from CATEGORIA c inner join Producto p on p.categoria_id=c.IdCategoria where c.IdCategoria = @IdCategoria)
	begin
		delete top(1) from CATEGORIA where IdCategoria = @IdCategoria
	end
	else
	begin
		set @Resultado=0
		set @Mensaje='La categoría no puede ser eliminada, puesto que se encuentra relacionada a un producto'
	end
end
go

create proc SP_CrearProducto(
@CodigoProducto varchar(50),
@nombreProducto varchar (75),
@descripcionProducto varchar (100),
@IdCategoria int,
@IdProveedor int,
@Stock int,
@PrecioCompra decimal (10,2),
@PrecioVenta decimal (10,2),
@Estado bit,
@Resultado bit output,
@Mensaje varchar (500) output
)
as
begin
	SET @Resultado=0
	If not exists (Select *from PRODUCTO where codigoProducto=@CodigoProducto)
	begin
		insert into PRODUCTO (codigoProducto,nombreProducto,descripcionProducto,categoria_id,proveedor_id, Stock, PrecioCompra, PrecioVenta, Estado) values(@CodigoProducto, @nombreProducto,  @descripcionProducto, @IdCategoria, @IdProveedor, @Stock, @PrecioCompra, @PrecioVenta, @Estado)
		SET @Resultado=SCOPE_IDENTITY()
	end
	else
	set @Mensaje='Ya existe un producto con el mismo código'
end
GO

Create proc SP_ModificarProducto(
@IdProducto int,
@CodigoProducto varchar(50),
@nombreProducto varchar (75),
@descripcionProducto varchar (100),
@IdCategoria int,
@IdProveedor int,
@Stock int,
@PrecioCompra decimal (10,2),
@PrecioVenta decimal (10,2),
@Estado bit,
@Resultado bit output,
@Mensaje varchar (500) output
)
as
begin
	SET @Resultado=1
	If not exists (Select *from PRODUCTO where codigoProducto=@CodigoProducto and IdProducto!=@IdProducto)
	begin
		update PRODUCTO set
			codigoProducto=@CodigoProducto,
			nombreProducto=@nombreProducto,
			descripcionProducto=@descripcionProducto,
			categoria_id=@IdCategoria,
			proveedor_id=@IdProveedor,
			Stock=@Stock,
			PrecioCompra=@PrecioCompra,
			PrecioVenta=@PrecioVenta,
			Estado=@Estado
			where IdProducto=@IdProducto
	end
	else
		begin
			set @Resultado=0
			set @Mensaje='Ya existe un producto con el mismo código'
		end
end
go

create proc SP_EliminarProducto(
@IdProducto int, 
@Respuesta bit output,
@Mensaje varchar (500) output
) as
begin
	set @Respuesta=0
	set @Mensaje=''
	declare @pasoreglas bit =1
	if exists (select *from DETALLE_COMPRA dc
	inner join PRODUCTO p on p.IdProducto=dc.producto_id
	where p.IdProducto=@IdProducto)
	begin
		set @pasoreglas=0
		set @Respuesta=0
		set @Mensaje = @Mensaje + 'No se puede elimnar el producto, puesto que se encuentra relacionado a una compra\n'
	end
	if exists (select *from DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto=dv.producto_id
	where p.IdProducto=@IdProducto)
	begin
		set @pasoreglas=0
		set @Respuesta=0
		set @Mensaje = @Mensaje + 'No se puede elimnar el producto, puesto que se encuentra relacionado a una venta\n'
	end
	if (@pasoreglas=1)
		begin
			delete from PRODUCTO where IdProducto=@IdProducto
			SET @Respuesta=1
		end
end
go

create Proc sp_RegistrarCliente(
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@telefono varchar(50),
@Estado bit,
@Resultado bit output,
@Mensaje varchar(500)
)as 
begin 
	set @Resultado=0
	declare @IDPERSONA int 
	if not exists (select *from CLIENTE WHERE documentoCliente = @Documento)

		begin 
		insert into CLIENTE(documentoCliente,nombreCompletoCliente,correoCliente,telefonoCliente,Estado) values
		(@Documento,@NombreCompleto,@Correo,@telefono,@Estado)  

		set @Resultado= SCOPE_IDENTITY()
	end
	else 
		set @Mensaje= 'El número de documento ya existe'
end
go

create Proc sp_ModificarCliente(
@idCliente int,
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado int,
@Resultado bit output,
@mensaje varchar(500) output
)as
begin 
	set @Resultado=1
	declare @idPERSONA int 
	if not exists(select *from CLIENTE where documentoCliente=@Documento and IdCliente != @idCliente)
	begin 
	update CLIENTE set 
	documentoCliente = @Documento,
	nombreCompletoCliente= @NombreCompleto,
	correoCliente = @Correo,
	Estado = @Estado
	where IdCliente = @idCliente
	end 

	else 
	begin
		set @Resultado = 0 
		set @mensaje = 'El número de documento ya existe '
	end 
end
go

CREATE TYPE [dbo].[EDetalle_Compra] AS TABLE(
[IdProducto] int NULL,
[PrecioCompra] decimal (10,2) NULL,
[PrecioVenta] decimal (10,2) NULL,
[Cantidad] int NULL,
[MontoTotal] decimal (10,2) NULL
)
GO

--Si ya creó el procedimiento almacenado, por favor, eliminarlo y volverlo a crear tal y como está en este momento
CREATE PROCEDURE sp_RegistrarCompra(
    @IdUsuario int,
    @IdProveedor int,
    @TipoDocumento varchar(500),
    @NumeroDocumento varchar(500),
    @MontoTotal decimal(10,2),
    @DetalleCompra [EDetalle_Compra] READONLY,
    @Resultado bit output,
    @Mensaje varchar(500) output
)
AS
BEGIN
    BEGIN TRY
        DECLARE @idcompra int = 0
        SET @Resultado = 1
        SET @Mensaje = ''
 
        -- Validar que todos los productos pertenezcan al proveedor especificado
        IF EXISTS (
            SELECT 1 
            FROM @DetalleCompra dc
            INNER JOIN PRODUCTO p ON dc.IdProducto = p.IdProducto
            WHERE p.proveedor_id != @IdProveedor
        )
        BEGIN
            SET @Resultado = 0
            SET @Mensaje = 'Todos los productos deben pertenecer al mismo proveedor'
            RETURN
        END
 
        BEGIN TRANSACTION registro
 
        -- Insertar en COMPRA (sin IdProveedor)
        INSERT INTO COMPRA (usuario_id, tipoDocumentoCompra_id, NumeroDocumentoCompra, MontoTotal)
        VALUES (@IdUsuario, 
                (SELECT idTipoDocumentoCompra FROM TipoDocumentoCompra WHERE nombreDocumentoCompra = @TipoDocumento), 
                @NumeroDocumento, @MontoTotal)
 
        SET @idcompra = SCOPE_IDENTITY()
 
        -- Insertar detalle de compra
        INSERT INTO DETALLE_COMPRA (producto_id, compra_id, PrecioCompra, PrecioVenta, Cantidad, MontoTotal)
        SELECT IdProducto, @idcompra, PrecioCompra, PrecioVenta, Cantidad, MontoTotal
        FROM @DetalleCompra

		update p set p.Stock = p.Stock + dc.Cantidad,
		p.PrecioCompra = dc.PrecioCompra,
		p.PrecioVenta = dc.PrecioVenta
		from PRODUCTO p
		inner join @DetalleCompra dc on dc.IdProducto= p.IdProducto

 
        COMMIT TRANSACTION registro
 
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION registro
        SET @Resultado = 0
        SET @Mensaje = ERROR_MESSAGE()
    END CATCH
END
go

CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE(
[IdProducto] int NULL,
[PrecioVenta] decimal (10,2) NULL,
[Cantidad] int NULL,
[MontoTotal] decimal (10,2) NULL)
GO

CREATE PROCEDURE sp_RegistrarVenta(
    @IdUsuario int,
    @IdCliente int,
    @TipoDocumento varchar(500),
    @NumeroDocumento varchar(500),
    @MontoPago decimal (10,2),
    @MontoCambio decimal (10,2),
    @MontoTotal decimal(10,2),
    @DetalleVenta [EDetalle_Venta] READONLY,
    @Resultado bit output,
    @Mensaje varchar(500) output
)
AS
BEGIN
    BEGIN TRY
        DECLARE @idventa int = 0
        SET @Resultado = 1
        SET @Mensaje = ''
 
        BEGIN TRANSACTION registro
 
        INSERT INTO VENTA(usuario_id, cliente_id, tipoDocumentoVenta_id, NumeroDocumentoVenta, MontoPago, MontoCambio, MontoTotal)
        VALUES (@IdUsuario, @IdCliente, 
                (SELECT idTipoDocumentoVenta FROM TipoDocumentoVenta WHERE nombreTipoDocumentoVenta = @TipoDocumento), 
                @NumeroDocumento, @MontoPago, @MontoCambio, @MontoTotal)
 
        SET @idventa = SCOPE_IDENTITY()
 
        -- Insertar detalle de compra
        INSERT INTO DETALLE_VENTA (producto_id, venta_id, PrecioVenta, Cantidad, SubTotal)
        SELECT IdProducto, @idventa, PrecioVenta, Cantidad, MontoTotal
        FROM @DetalleVenta

		update p set p.Stock = p.Stock - dv.Cantidad
		from PRODUCTO p 
		inner join @DetalleVenta dv on dv.IdProducto= p.IdProducto

 
        COMMIT TRANSACTION registro
 
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION registro
        SET @Resultado = 0
        SET @Mensaje = ERROR_MESSAGE()
    END CATCH
END
go

CREATE PROCEDURE sp_ReporteCompras
    @fechaInicio VARCHAR(10),
    @fechaFin VARCHAR(10),
    @idProveedor INT
AS
BEGIN
    -- Establecer formato de fecha pa no confundirse
    SET DATEFORMAT dmy;

    SELECT 
        CONVERT(CHAR(10), c.FechaRegistro, 103) AS [FechaRegistro],
        td.nombreDocumentoCompra AS [TipoDocumento],
        c.NumeroDocumentoCompra,
        c.MontoTotal,
        u.nombreCompletoUsuario AS [UsuarioRegistro],
        pr.documentoProveedor AS [DocumentoProveedor],
        pr.razonSocialProveedor AS [RazonSocial],
        p.codigoProducto AS [CodigoProducto],
        p.nombreProducto AS [NombreProducto],
        ca.descripcionCategoria AS [Categoria],
        dc.PrecioCompra,
        dc.PrecioVenta,
        dc.Cantidad,
        dc.PrecioCompra * dc.Cantidad AS [SubTotal]
    FROM COMPRA c
    INNER JOIN USUARIO u ON u.idUsuario = c.usuario_id
    INNER JOIN DETALLE_COMPRA dc ON dc.compra_id = c.idCompra
    INNER JOIN PRODUCTO p ON p.idProducto = dc.producto_id
    INNER JOIN PROVEEDOR pr ON pr.idProveedor = p.proveedor_id
    INNER JOIN CATEGORIA ca ON ca.idCategoria = p.categoria_id
    INNER JOIN TipoDocumentoCompra td ON td.idTipoDocumentoCompra = c.tipoDocumentoCompra_id
    WHERE CONVERT(DATE, c.FechaRegistro) BETWEEN CONVERT(DATE, @fechaInicio, 103) AND CONVERT(DATE, @fechaFin, 103)
      AND pr.idProveedor = CASE WHEN @idProveedor = 0 THEN pr.idProveedor ELSE @idProveedor END;
END
go

CREATE PROCEDURE sp_ReporteVentas
    @fechaInicio VARCHAR(10),
    @fechaFin VARCHAR(10),
    @idCliente INT
AS
BEGIN
    -- Establecer formato de fecha pa no confundirse
    SET DATEFORMAT dmy;

    SELECT 
        CONVERT(CHAR(10), v.FechaRegistro, 103) AS [Fecha de registro],
        td.nombreTipoDocumentoVenta AS [TipoDocumento],
        v.NumeroDocumentoVenta,
        v.MontoTotal,
        u.nombreCompletoUsuario AS [UsuarioRegistro],
        cl.IdCliente AS [Documento del Cliente],
        cl.nombreCompletoCliente AS [Cliente],
        p.codigoProducto AS [Código Producto],
        p.nombreProducto AS [Nombre Producto],
        ca.descripcionCategoria AS [Categoría],
        dv.PrecioVenta,
        dv.Cantidad,
        dv.PrecioVenta * dv.Cantidad AS [SubTotal]
    FROM VENTA v
    INNER JOIN USUARIO u ON u.idUsuario = v.usuario_id
    INNER JOIN DETALLE_VENTA dv ON dv.venta_id = v.IdVenta
    INNER JOIN PRODUCTO p ON p.idProducto = dv.producto_id
    INNER JOIN CLIENTE cl ON cl.IdCliente=v.cliente_id
    INNER JOIN CATEGORIA ca ON ca.idCategoria = p.categoria_id
    INNER JOIN TipoDocumentoVenta td ON td.idTipoDocumentoVenta = v.tipoDocumentoVenta_id
    WHERE CONVERT(DATE, v.FechaRegistro) BETWEEN CONVERT(DATE, @fechaInicio, 103) AND CONVERT(DATE, @fechaFin, 103)
      AND cl.IdCliente = CASE WHEN @idCliente = 0 THEN cl.IdCliente ELSE @idCliente END;
END
go