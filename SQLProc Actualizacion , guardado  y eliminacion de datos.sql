select * from USUARIO


alter PROC SP_REGISTRARUSUARIO(
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


ALTER PROC SP_EDITARUSUARIO(
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

declare @respuesta bit
declare @mensaje varchar (500)

exec SP_EDITARUSUARIO 17, '123', 'Pruebas 3', 'test@gmail.com', '456', 2,1, @respuesta output, @mensaje output

select @respuesta
select @mensaje

select * from USUARIO

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


	select * from USUARIO
	select IdProveedor, documentoProveedor, razonSocialProveedor, correoProveedor, telefonoProveedor, Estado from PROVEEDOR 