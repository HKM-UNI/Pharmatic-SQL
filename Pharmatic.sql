create database pharmatic
use pharmatic

/*
Descripcion:
	La Categoria es una abstracción a la cual pertenece un
	grupo de medicamentos (Productos).

Esquema:
	.-------------.--------------.------------------------.
	|    Campo    |    Valor     |      Condiciones       |
	:-------------+--------------+------------------------:
	| idCategoria | 1            | PK, auto incrementable |
	:-------------+--------------+------------------------:
	| nombre*     | Antibioticos | Unico                  |
	'-------------'--------------'------------------------'

	*: El campo es requerido (Condicion NOT NULL)
*/
create table Categoria (

	idCategoria int IDENTITY(1,1) PRIMARY KEY,

	nombre nvarchar(30) UNIQUE NOT NULL

)

/*
Descripcion:
	El Producto es la entidad mas basica que identifica a un medicamento en la farmacia.

Esquema:
	.--------------.-----------------------------------------.------------------------.
	|    Campo     |                  Valor               	 |      Condiciones       |
	:--------------+-----------------------------------------+------------------------:
	| idProducto   | 1                                       | PK, auto incrementable |
	:--------------+-----------------------------------------+------------------------:
	| idCategoria* | 1                                       | FK                     |
	:--------------+-----------------------------------------+------------------------:
	| nombre*      | Acetaminofen                            | Unico                  |
	:--------------+-----------------------------------------+------------------------:
	| descripcion  | Medicamento para aliviar el dolor		 |						  |
	|			   | ligero o moderado, resfriados y fiebres |                        |
	'--------------'-----------------------------------------'------------------------'

	*: El campo es requerido (Condicion NOT NULL)
*/
create table Producto (

	idProducto int IDENTITY(1,1) PRIMARY KEY,

	idCategoria int FOREIGN KEY REFERENCES Categoria(idCategoria) NOT NULL,

	nombre nvarchar(50) UNIQUE NOT NULL,

	descripcion nvarchar(150)

)

/*
Descripcion:
	La Medida es una normalizacion para identificar que
	un Contenido esta dado en una unidad del sistema
	internacional de unidades.

Esquema:
	.----------.-------.------------------------.
	|  Campo   | Valor |      Condiciones       |
	:----------+-------+------------------------:
	| idMedida | 1     | PK, auto incrementable |
	:----------+-------+------------------------:
	| unidad   | mg    | Unico                  |
	'----------'-------'------------------------'

	*: El campo es requerido (Condicion NOT NULL)
*/
create table Medida (

	idMedida int IDENTITY(1,1) PRIMARY KEY,

	unidad nvarchar(30) UNIQUE NOT NULL

)

/*
Descripcion:
	El Contenido es la cantidad de medicamento que puede haber en una
	sola unidad de un Producto. Esto puede variar en algunos Lotes.

Esquema:
	.-------------.-------.------------------------.
	|    Campo    | Valor |      Condiciones       |
	:-------------+-------+------------------------:
	| idContenido |     1 | PK, auto incrementable |
	:-------------+-------+------------------------:
	| idMedida*   |     1 | FK                     |
	:-------------+-------+------------------------:
	| cantidad*   |    50 | Mayor que 0            |
	'-------------'-------'------------------------'

	*: El campo es requerido (Condicion NOT NULL)
*/
create table Contenido (

	idContenido int IDENTITY(1,1) PRIMARY KEY,

	idMedida int FOREIGN KEY REFERENCES Medida(idMedida) NOT NULL,

	cantidad float NOT NULL
	CHECK(cantidad > 0)

)

/*
Descripcion:
	La farmacia puede registrar opcionalmente la informacion de un Proveedor que suministra
	Lotes de Producto.

Esquema:
	.-------------.--------------------------------------.--------------------------------.
	|    Campo    |                Valor                 |          Condiciones           |
	:-------------+--------------------------------------+--------------------------------:
	| idProveedor | 1                                    | PK, auto incrementable         |
	:-------------+--------------------------------------+--------------------------------:
	| nombres*    | Jane Doe                             | Unico                          |
	:-------------+--------------------------------------+--------------------------------:
	| correo      | jane.d@mail.com                      | Unico                          |
	:-------------+--------------------------------------+--------------------------------:
	| direccion   | Rotonda El Gueguense, 30mts al oeste |                                |
	:-------------+--------------------------------------+--------------------------------:
	| telefono    | 76459837                             | Unico, debe contener 8 digitos |
	'-------------'--------------------------------------'--------------------------------'

	*: El campo es requerido (Condicion NOT NULL)
*/
create table Proveedor (

	idProveedor int IDENTITY(1,1) PRIMARY KEY NOT NULL,

	nombre nvarchar(30) UNIQUE NOT NULL,

	correo nvarchar(30) UNIQUE,

	direccion nvarchar(50),

	telefono int UNIQUE
	CHECK(telefono >= 10000000 AND telefono <= 99999999),

)

/*
Descripcion:
	Los Lotes puede contener diferentes presentaciones de un Producto,
	las cuales varian en multiples caracteristicas.

Esquema:
	.-------------------.--------------.------------------------.
	|       Campo       |    Valor     |      Condiciones       |
	:-------------------+--------------+------------------------:
	| idLote            | 1            | PK, auto incrementable |
	:-------------------+--------------+------------------------:
	| idProducto*       | 25           | FK                     |
	:-------------------+--------------+------------------------:
	| idProveedor       | 1            | FK                     |
	:-------------------+--------------+------------------------:
	| idContenido*      | 3            | FK                     |
	:-------------------+--------------+------------------------:
	| enConsigna*       | 1            |                        |
	:-------------------+--------------+------------------------:
	| fechaIngreso      | '2020-07-21' |                        |
	:-------------------+--------------+------------------------:
	| fechaVencimiento* | '2023-05-18' |                        |
	:-------------------+--------------+------------------------:
	| precioCompra      | 300          | Mayor que 0            |
	:-------------------+--------------+------------------------:
	| precioVenta*      | 6            | Mayor que 0            |
	:-------------------+--------------+------------------------:
	| stock*            | 75           | Mayor o igual que 0    |
	'-------------------'--------------'------------------------'

	*: El campo es requerido (Condicion NOT NULL)
*/
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
	La farmacia necesita poder registrar los datos de sus clientes de manera opcional.

Esquema:
	.------------.-----------------.------------------------------------------------.
	|   Campo    |      Valor      |                  Condiciones                   |
	:------------+-----------------+------------------------------------------------:
	| idCliente* | 1               | PK, auto incrementable                         |
	:------------+-----------------+------------------------------------------------:
	| nombres*   | John Lorem      |                                                |
	:------------+-----------------+------------------------------------------------:
	| apellidos* | Doe Ipsum       |                                                |
	:------------+-----------------+------------------------------------------------:
	| correo     | john.d@mail.com | Unico, debe contener '@' y '.'                 |
	:------------+-----------------+------------------------------------------------:
	| telefono   | 83481615        | Unico, debe contener 8 digitos                 |
	:------------+-----------------+------------------------------------------------:
	| sexo*      | M               | Debe ser un caracter 'M' o 'F'                 |
	:------------+-----------------+------------------------------------------------:
	| edad       | 23              | Debe ser un numero mayor que 0 y menor que 150 |
	'------------'-----------------'------------------------------------------------'

	*: El campo es requerido (Condicion NOT NULL)
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
	La factura se encarga de asociar los productos que un cliente adquiere
	mediante la entidad de Venta. Esto representa una unica transaccion,
	con montos computados en base a cada una de ellas.

Esquema:
	.------------.-------------------.--------------------.
	|   Campo    |       Valor       | Valor por defecto  |
	:------------+-------------------+--------------------:
	| idFactura° | 1                 | Auto incrementable |
	:------------+-------------------+--------------------:
	| idCliente  | 1                 |                    |
	:------------+-------------------+--------------------:
	| fecha      | '2022-11-24 8:07' | Fecha actual       |
	:------------+-------------------+--------------------:
	| descuento  | 5                 | 0                  |
	:------------+-------------------+--------------------:
	| subTotal°  | 105               | Auto computable    |
	:------------+-------------------+--------------------:
	| subIva°    | 15.75             | Auto computable    |
	:------------+-------------------+--------------------:
	| total°     | 120.75            | Auto computable    |
	'------------'-------------------'--------------------'

	°:	El campo es computable. No debe especificarse.
		El valor es por propósitos de muestra.
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

/*
Descripcion:
	La Venta representa la compra unica de un Producto por
	un Cliente.

Esquema:
	.------------.-------.------------------------.
	|   Campo    | Valor |      Condiciones       |
	:------------+-------+------------------------:
	| idVenta    |     1 | PK, auto incrementable |
	:------------+-------+------------------------:
	| idFactura* |     3 | FK                     |
	:------------+-------+------------------------:
	| idLote*    |     8 | FK                     |
	:------------+-------+------------------------:
	| cantidad*  |    10 | ¹                      |
	:------------+-------+------------------------:
	| monto°     |    50 | Auto computable        |
	'------------'-------'------------------------'

	*: El campo es requerido (Condicion NOT NULL)

	¹: Si se especifica, debe ser mayor que 0.
	   De lo contrario, su valor por defecto es 1.

	°: El campo es computable. No debe especificarse.
	   El valor es por propósitos de muestra.
*/
create table Venta (

	idVenta int IDENTITY(1,1) PRIMARY KEY,

	idFactura int FOREIGN KEY REFERENCES Factura(idFactura) NOT NULL,

	idLote int FOREIGN KEY REFERENCES Lote(idLote) NOT NULL,

	cantidad int DEFAULT(1) NOT NULL
	CHECK(cantidad > 0),

	monto as dbo.calcMontoVenta(idLote, cantidad)

)

/*
Descripcion:
	Tag es un extranjerismo de la palabra 'etiqueta'. En este
	contexto, permite identificar a un grupo de productos mediante
	palabras clave.

Esquema:
	.---------.-------.------------------------.
	|  Campo  | Valor |      Condiciones       |
	:---------+-------+------------------------:
	| idTag   | 1     | PK, auto incrementable |
	:---------+-------+------------------------:
	| nombre* | gripe | Unico                  |
	'---------'-------'------------------------'

	*: El campo es requerido (Condicion NOT NULL)
*/
create table Tag (

	idTag int IDENTITY(1,1) PRIMARY KEY,

	nombre nvarchar(30) UNIQUE NOT NULL

)

/*
Descripcion:
	TagsProducto es una entidad auxiliar para asociar multiples
	etiquetas a uno o mas Productos.

Esquema:
	.-------------.-------.------------------------.
	|    Campo    | Valor |      Condiciones       |
	:-------------+-------+------------------------:
	| numeroTag   |     1 | PK, auto incrementable |
	:-------------+-------+------------------------:
	| idTag*      |     1 | FK                     |
	:-------------+-------+------------------------:
	| idProducto* |    15 | FK                     |
	'-------------'-------'------------------------'

	*: El campo es requerido (Condicion NOT NULL)
*/
create table TagsProducto (

	numeroTag int IDENTITY(1,1) PRIMARY KEY,

	idTag int FOREIGN KEY REFERENCES Tag(idTag) NOT NULL,

	idProducto int FOREIGN KEY REFERENCES Producto(idProducto) NOT NULL

)
