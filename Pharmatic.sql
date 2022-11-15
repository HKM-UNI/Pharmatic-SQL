create database pharmatic
use pharmatic

/*
CONTEXTO:  
	- Nuestra farmacia necesita poder registrar a sus clientes
EJEMPLO: 
	- This query returns total sales (in USD) for each of our stores in Chicago every month before and after COVID, starting from 2019-03-01.
*/
drop table Cliente

create table Cliente (
	idCliente int primary key,

	nombres nvarchar(30) NOT NULL,

	apellidos nvarchar(30) NOT NULL,

	correo nvarchar(30) UNIQUE
	CONSTRAINT [Verifique el formato del correo. ej: 'user@mail.com' ]
	CHECK(correo LIKE '%___@___%.__%'),

	telefono int UNIQUE
	CONSTRAINT [Verifique el formato del numero celular. ej: '+50580808080' ]
	CHECK(telefono <= 99999999 AND telefono >= 10000000),

	sexo char(1) NOT NULL
	CONSTRAINT [Verifique el sexo. ej: 'M' o 'F' ]
	CHECK(sexo = 'M' OR sexo = 'F'),

	edad int
	CONSTRAINT [Verifique que la edad sea valida]
	CHECK(edad > 0 AND edad < 150)
)

select * from Cliente

insert into Cliente(idCliente,nombres,apellidos,correo,telefono,genero,edad)
values(1,'joni','gei','okay@mail.es','12345678','f',9)

create table Factura (
	idFactura int primary key,
	subTotal money,
	subIva money,
	fecha date,
	descuento float,
	idCliente int foreign key references Cliente(idCliente),
	total money
)

create table Categoria (
	idCategoria int primary key,
	nombre nvarchar(30)
)

create table Tag (
	idTag int primary key,
	nombre nvarchar(30)
)

create table Medida (
	idMedida int primary key,
	unidad nvarchar(30)
)

create table Contenido (
	idContenido int primary key,
	idMedida int foreign key references Medida(idMedida),
	cantidad float
)

create table Producto (
	idProducto int primary key,
	idCategoria int foreign key references Categoria(idCategoria),
	nombre nvarchar(30),
	descripcion nvarchar(50)
)

create table TagsProducto (
	idTag int foreign key references Tag(idTag),
	idProducto int foreign key references Producto(idProducto)
)

create table Proveedor (
	idProveedor int primary key,
	nombre nvarchar(30),
	correo nvarchar(30),
	direccion nvarchar(50),
	numero int
)

create table Propiedad (
	idPropiedad int primary key,
	tipo nvarchar(30)
)

create table Lote (
	idLote int primary key,
	idProducto int foreign key references Producto(idProducto),
	idProveedor int foreign key references Proveedor(idProveedor),
	idPropidad int foreign key references Propiedad(idPropiedad),
	idContenido int foreign key references Contenido(idContenido),
	fechaIngreso date,
	fechaVencimiento date,
	precioCompra money,
	precioVenta money,
	stock int
)

create table Venta (
	idVenta int primary key,
	idFactura int foreign key references Factura(idFactura),
	idLote int foreign key references Lote(idLote),
	cantidad int,
	monto money
)


