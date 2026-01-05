-- Crear base de datos
CREATE DATABASE IF NOT EXISTS biblioteca_escolar;
USE biblioteca_escolar;

-- Tabla Libros
CREATE TABLE Libros (
    id_libro INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(100),
    autor VARCHAR(100),
    editorial VARCHAR(50),
    isbn VARCHAR(20),
    año_publicacion INTEGER,
    disponible BOOLEAN DEFAULT true,
    portada VARCHAR(300),
    PRIMARY KEY(id_libro)
);

-- Tabla Estudiantes
CREATE TABLE Estudiantes (
    id_estudiante INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    password VARCHAR(100),
    nombre VARCHAR(50),
    apellidos VARCHAR(100),
    codigo_estudiante VARCHAR(20) UNIQUE,
    curso VARCHAR(30),
    telefono VARCHAR(15),
    PRIMARY KEY(id_estudiante)
);

-- Tabla Prestamos
CREATE TABLE Prestamos (
    id_prestamo INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    id_estudiante INTEGER UNSIGNED,
    id_libro INTEGER UNSIGNED,
    fecha_prestamo DATETIME,
    fecha_devolucion DATETIME,
    devuelto BOOLEAN DEFAULT false,
    PRIMARY KEY(id_prestamo),
    FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_estudiante) ON DELETE CASCADE,
    FOREIGN KEY (id_libro) REFERENCES Libros(id_libro) ON DELETE CASCADE
);

-- Insertar datos de ejemplo en Libros
INSERT INTO Libros (titulo, autor, editorial, isbn, año_publicacion, disponible, portada) VALUES
('Cien años de soledad', 'Gabriel García Márquez', 'Sudamericana', '978-0307474728', 1967, true, 'cien_anos.jpg'),
('El principito', 'Antoine de Saint-Exupéry', 'Reynal & Hitchcock', '978-0156013987', 1943, true, 'principito.jpg'),
('1984', 'George Orwell', 'Secker & Warburg', '978-0451524935', 1949, false, '1984.jpg'),
('Don Quijote de la Mancha', 'Miguel de Cervantes', 'Francisco de Robles', '978-8424116196', 1605, true, 'quijote.jpg'),
('Harry Potter y la piedra filosofal', 'J.K. Rowling', 'Bloomsbury', '978-8478884452', 1997, true, 'harry_potter.jpg');

-- Insertar datos de ejemplo en Estudiantes
INSERT INTO Estudiantes (nombre, apellidos, codigo_estudiante, curso, telefono, password) VALUES
('María', 'González Pérez', 'EST2024001', '4º ESO', '611223344', 'password123'),
('Carlos', 'Ruiz López', 'EST2024002', '1º Bachillerato', '622334455', 'password123'),
('Ana', 'Martínez Sánchez', 'EST2024003', '3º ESO', '633445566', 'password123'),
('Javier', 'Fernández Díaz', 'EST2024004', '2º Bachillerato', '644556677', 'password123');

-- Insertar datos de ejemplo en Prestamos
INSERT INTO Prestamos (id_estudiante, id_libro, fecha_prestamo, fecha_devolucion, devuelto) VALUES
(1, 3, '2024-01-15 10:30:00', '2024-02-15 10:30:00', false),
(2, 1, '2024-01-20 14:00:00', '2024-02-20 14:00:00', true),
(3, 2, '2024-02-01 09:15:00', '2024-03-01 09:15:00', false);