create database pharmatic
use pharmatic

create table Categoria (

	idCategoria int IDENTITY(1,1) PRIMARY KEY,

	nombre nvarchar(30) UNIQUE NOT NULL

)

create table Producto (

	idProducto int IDENTITY(1,1) PRIMARY KEY,

	idCategoria int FOREIGN KEY REFERENCES Categoria(idCategoria) NOT NULL,

	nombre nvarchar(50) UNIQUE NOT NULL,

	descripcion nvarchar(150)

)

create table Medida (

	idMedida int IDENTITY(1,1) PRIMARY KEY,

	unidad nvarchar(30) UNIQUE NOT NULL

)

create table Contenido (

	idContenido int IDENTITY(1,1) PRIMARY KEY,

	idMedida int FOREIGN KEY REFERENCES Medida(idMedida) NOT NULL,

	cantidad float NOT NULL
	CHECK(cantidad > 0)

)

create table Proveedor (

	idProveedor int IDENTITY(1,1) PRIMARY KEY NOT NULL,

	nombre nvarchar(30) UNIQUE NOT NULL,

	correo nvarchar(30) UNIQUE,

	direccion nvarchar(50),

	telefono int UNIQUE
	CHECK(telefono >= 10000000 AND telefono <= 99999999),

)

create table Lote (

	idLote int IDENTITY(1,1) PRIMARY KEY,

	idProducto int FOREIGN KEY REFERENCES Producto(idProducto) NOT NULL,

	idProveedor int FOREIGN KEY REFERENCES Proveedor(idProveedor),

	idContenido int FOREIGN KEY REFERENCES Contenido(idContenido) NOT NULL,

	enConsigna bit NOT NULL,

	fechaIngreso date,

	fechaVencimiento date NOT NULL,

	precioCompra money
	CHECK(precioCompra > 0),

	precioVenta money NOT NULL
	CHECK(precioVenta > 0),

	stock int NOT NULL
	CHECK(stock >= 0)

)

/*
Descripcion:
	La farmacia necesita poder registrar los datos de sus clientes, por lo que la tabla
	registra datos personales relacionados al cliente.
	
Contiene:
	idCliente:	 codigo unico por cliente
	nombres:	 El o los nombres del cliente que son obligatorios
	apellidos:	 El o los apellidos del cliente que son obligatorios
	correo:		 La direccion de coreo que puede o no asociarse pero que si se hace, esta debe ser valida
	telefono:	 Numero de telefono que puede o no ser asociado pero en caso de hacerse este debe ser valido
	sexo:		 Sexo del cliente, obligatorio y solo puede ser "M" o "F"
	edad:		 La edad del cliente que debe ser mayor que 0 y menor a 150

Ejemplo:
	.-----------.-----------------.------------------------------------------------.
	|   campo   |      valor      |                  condiciones                   |
	:-----------+-----------------+------------------------------------------------:
	| idCliente | 243             | PK, auto incremental                           |
	:-----------+-----------------+------------------------------------------------:
	| nombres   | John Lorem      | Not null                                       |
	:-----------+-----------------+------------------------------------------------:
	| apellidos | Doe Ipsum       | Not null                                       |
	:-----------+-----------------+------------------------------------------------:
	| correo    | john.d@mail.com | Unico, debe contener @ y .                     |
	:-----------+-----------------+------------------------------------------------:
	| telefono  | 83481615        | Unico, debe contener 8 digitos                 |
	:-----------+-----------------+------------------------------------------------:
	| sexo      | M               | Debe ser un caracter M o F                     |
	:-----------+-----------------+------------------------------------------------:
	| edad      | 23              | Debe ser un numero mayor que 0 y menor que 150 |
	'-----------'-----------------'------------------------------------------------'
	
*/
create table Cliente (

	idCliente int IDENTITY(1,1) PRIMARY KEY,

	nombres nvarchar(30) NOT NULL,

	apellidos nvarchar(30) NOT NULL,

	correo nvarchar(30) UNIQUE
	CHECK(correo LIKE '%__@__%.__%'),

	telefono int UNIQUE
	CHECK(telefono >= 10000000 AND telefono <= 99999999),

	sexo char(1) NOT NULL
	CHECK(sexo = 'M' OR sexo = 'F'),

	edad int
	CHECK(edad > 0 AND edad < 150)

)

go
-- Retorna el subtotal de una factura dado su id
create function dbo.calcSubtotalFactura(@idFactura int)
returns money
as
begin
	return (
		select coalesce(sum(monto), 0)
		from Venta
		where idFactura = @idFactura
	)
end
go

go
-- Retorna el IVA aplicado a una factura dado su id
create function dbo.calcSubIva(@idFactura int)
returns money
as
begin
	declare @subtotal as money
	select @subtotal = subtotal from Factura where idFactura = @idFactura
	return @subtotal * 0.15
end
go

go
-- Retorna el total de una factura dado su id
create function dbo.calcTotalFactura(@idFactura int)
returns money
as
begin
	declare @subTotal money, @subIva money, @descuento money
	select @subTotal = dbo.calcSubtotalFactura(@idFactura)
	select @subIva = @subtotal * 0.15
	select @descuento = descuento from Factura where idFactura = @idFactura
	return (@subTotal + @subIva) * (100 - @descuento)/100;
end
go

/*
Descripcion:
	La factura es la que se encarga de reunir todos los productos que adquiere el cliente(ventas) en una sola transaccion
	
Contiene:
	idFactura:	 codigo unico por factura
	idCliente:	 Sexo del cliente, obligatorio y solo puede ser "M" o "F"
	fecha:		 La direccion de coreo que puede o no asociarse pero que si se hace, esta debe ser valida
	descuento:	 Numero de telefono que puede o no ser asociado pero en caso de hacerse este debe ser valido
	subTotal:	 El o los nombres del cliente que son obligatorios
	subIva:		 El o los apellidos del cliente que son obligatorios
	total:		 La edad del cliente que debe ser mayor que 0 y menor a 150

Ejemplo:
	.-----------.-----------------.------------------------------------------------.
	|   campo   |      valor      |                  condiciones                   |
	:-----------+-----------------+------------------------------------------------:
	| idCliente | 243             | PK, auto incremental                           |
	:-----------+-----------------+------------------------------------------------:
	| nombres   | John Lorem      | Not null                                       |
	:-----------+-----------------+------------------------------------------------:
	| apellidos | Doe Ipsum       | Not null                                       |
	:-----------+-----------------+------------------------------------------------:
	| correo    | john.d@mail.com | unico, debe contener @ y .                     |
	:-----------+-----------------+------------------------------------------------:
	| telefono  | 83481615        | unico, debe contener 8 digitos                 |
	:-----------+-----------------+------------------------------------------------:
	| sexo      | M               | Debe ser un caracter M o F                     |
	:-----------+-----------------+------------------------------------------------:
	| edad      | 23              | Debe ser un numero mayor que 0 y menor que 150 |
	'-----------'-----------------'------------------------------------------------'
	
*/
create table Factura (

	idFactura int IDENTITY(1,1) PRIMARY KEY,

	idCliente int FOREIGN KEY REFERENCES Cliente(idCliente),

	fecha datetime DEFAULT GetDate() NOT NULL,

	descuento float DEFAULT 0 NOT NULL
	CHECK(descuento >= 0),

	subTotal as dbo.calcSubtotalFactura(idFactura),

	subIva as dbo.calcSubIva(idFactura),

	total as dbo.calcTotalFactura(idFactura)

)

go
-- Retorna el monto de la venta dado una cantidad por lote
create function dbo.calcMontoVenta(@idLote int, @cantidad int)
returns money
as
begin
	return (
		select precioVenta * @cantidad
		from Lote
		where idLote = @idLote
	)
end
go

create table Venta (

	idVenta int IDENTITY(1,1) PRIMARY KEY,

	idFactura int FOREIGN KEY REFERENCES Factura(idFactura) NOT NULL,

	idLote int FOREIGN KEY REFERENCES Lote(idLote) NOT NULL,

	cantidad int DEFAULT(1) NOT NULL
	CHECK(cantidad > 0),

	monto as dbo.calcMontoVenta(idLote, cantidad)

)

create table Tag (

	idTag int IDENTITY(1,1) PRIMARY KEY,

	nombre nvarchar(30) UNIQUE NOT NULL

)

create table TagsProducto (

	numeroTag int IDENTITY(1,1) PRIMARY KEY,

	idTag int FOREIGN KEY REFERENCES Tag(idTag) NOT NULL,

	idProducto int FOREIGN KEY REFERENCES Producto(idProducto) NOT NULL

)
