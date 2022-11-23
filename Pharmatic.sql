create database pharmatic
use pharmatic

/*
Descripci�n:
	La farmacia necesita poder registrar los datos de sus clientes, por lo que la tabla
	registra datos de contacto relacionado al cliente.

	.-----------.-----------------.------------------------------------------------.
	|   campo   |      valor      |                  condiciones                   |
	:-----------+-----------------+------------------------------------------------:
	| idCliente | 243             | PK, auto incremental                           |
	:-----------+-----------------+------------------------------------------------:
	| nombres   | John Lorem      | Not null                                       |
	:-----------+-----------------+------------------------------------------------:
	| apellidos | Doe Ipsum       | Not null                                       |
	:-----------+-----------------+------------------------------------------------:
	| correo    | john.d@mail.com | �nico, debe contener @ y .                     |
	:-----------+-----------------+------------------------------------------------:
	| telefono  | 83481615        | �nico, debe contener 8 d�gitos                 |
	:-----------+-----------------+------------------------------------------------:
	| sexo      | M               | Debe ser un car�cter M o F                     |
	:-----------+-----------------+------------------------------------------------:
	| edad      | 23              | Debe ser un numero mayor que 0 y menor que 150 |
	'-----------'-----------------'------------------------------------------------'
	
*/
drop table Cliente

CREATE TABLE Cliente (

	idCliente int IDENTITY(1,1) PRIMARY KEY,

	nombres nvarchar(30) NOT NULL,

	apellidos nvarchar(30) NOT NULL,

	correo nvarchar(30) UNIQUE
	CHECK(correo LIKE '%__@__%.__%'),

	telefono int UNIQUE
	CHECK(telefono <= 99999999 AND telefono >= 10000000),

	sexo char(1) NOT NULL
	CHECK(sexo = 'M' OR sexo = 'F'),

	edad int
	CHECK(edad > 0 AND edad < 150)

)

select * from Cliente

insert into Cliente(idCliente,nombres,apellidos,correo,telefono,sexo,edad)
values(1,'joni','gei','okay@mail.es','12345678','f',9)

/*
CONTEXTO:

*/
CREATE TABLE Factura (

	idFactura int IDENTITY(1,1) PRIMARY KEY,

	subTotal money NOT NULL
	CHECK(subTotal > 0),

	subIva money NOT NULL
	CHECK(subTotal >= 0),

	fecha timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,

	descuento float NOT NULL
	CHECK(descuento >= 0),

	idCliente int FOREIGN KEY REFERENCES Cliente(idCliente),

	total money NOT NULL
	CHECK(total > 0)

)

create table Categoria (

	idCategoria int IDENTITY(1,1) PRIMARY KEY,

	nombre nvarchar(30) UNIQUE NOT NULL

)

create table Tag (

	idTag int IDENTITY(1,1) PRIMARY KEY,

	nombre nvarchar(30) UNIQUE NOT NULL
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

create table Producto (

	idProducto int IDENTITY(1,1) PRIMARY KEY,

	idCategoria int FOREIGN KEY REFERENCES Categoria(idCategoria) NOT NULL,

	nombre nvarchar(50) UNIQUE NOT NULL,

	descripcion nvarchar(150)

)

create table TagsProducto (

	idTag int FOREIGN KEY REFERENCES Tag(idTag) NOT NULL,

	idProducto int FOREIGN KEY REFERENCES Producto(idProducto) NOT NULL

)

create table Proveedor (

	idProveedor int IDENTITY(1,1) PRIMARY KEY NOT NULL,

	nombre nvarchar(30) UNIQUE NOT NULL,

	correo nvarchar(30) UNIQUE,

	direccion nvarchar(50),

	telefono int UNIQUE
	CHECK(telefono <= 99999999 AND telefono >= 10000000),

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

create table Venta (

	idVenta int IDENTITY(1,1) PRIMARY KEY,

	idFactura int FOREIGN KEY REFERENCES Factura(idFactura) NOT NULL,

	idLote int FOREIGN KEY REFERENCES Lote(idLote) NOT NULL,

	cantidad int DEFAULT(1) NOT NULL
	CHECK(cantidad > 0),

	monto money NOT NULL
	CHECK(cantidad > 0)

)


