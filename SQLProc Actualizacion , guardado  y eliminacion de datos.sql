select * from USUARIO
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

declare @respuesta bit
declare @mensaje varchar (500)

exec SP_EDITARUSUARIO 17, '123', 'Pruebas 3', 'test@gmail.com', '456', 2,1, @respuesta output, @mensaje output

select @respuesta
select @mensaje

select * from USUARIO
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


	select * from USUARIO
	select IdProveedor, documentoProveedor, razonSocialProveedor, correoProveedor, telefonoProveedor, Estado from PROVEEDOR 

--Ejecutar a partir de CREATE TYPE
--Procesos para registrar una compra


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
truncate table Compra

select *from COMPRA









--Script de reporte de compra, ejecutar si no se ha hecho
--inner join del cual se hace el proc
SELECT 
    CONVERT(char(10), c.FechaRegistro, 103) AS [FechaRegistro],
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
INNER JOIN TipoDocumentoCompra td ON td.idTipoDocumentoCompra = c.tipoDocumentoCompra_id;




--ejecutrar el procedimiento almacenado en caso que no se haya ejecutado
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

select*from compra
select *from PROVEEDOR
-- si se filtra a traves del 0 entonces mostrara todos los proveedores a los que se realizo la compra en esa fecha
--si se utiliza otro numero mostrara el numero del proveedor al cual se compro esa fecha 
exec sp_ReporteCompras '01/08/2025','04/09/2025',0
--fin del proc


--Procesos para registrar una compra


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
    
--Select para ver los detalles de la venta
select 
    v.IdVenta, 
    u.nombreCompletoUsuario, 
    c.documentoCliente, 
    c.nombreCompletoCliente, 
    tdv.nombreTipoDocumentoVenta, 
    v.NumeroDocumentoVenta, 
    v.MontoPago, v.MontoCambio, 
    v.MontoTotal, 
    CONVERT(char(10), v.FechaRegistro, 103) AS [FechaRegistro]
from Venta v
inner join USUARIO u on u.IdUsuario=v.usuario_id
inner join CLIENTE c on c.IdCliente = v.cliente_id
inner join TipoDocumentoVenta tdv on tdv.idTipoDocumentoVenta=v.tipoDocumentoVenta_id

select p.nombreProducto, p.PrecioVenta, dv.Cantidad, dv.SubTotal
from DETALLE_VENTA dv
inner join PRODUCTO p on p.IdProducto=dv.producto_id