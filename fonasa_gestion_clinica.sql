-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 13-05-2024 a las 22:59:21
-- Versión del servidor: 8.0.30
-- Versión de PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `fonasa_gestion_clinica`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `atencion`
--

CREATE TABLE `atencion` (
  `id` int NOT NULL,
  `consulta_id` int NOT NULL,
  `no_historia_clinica` int NOT NULL,
  `fecha_atencion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `atencion`
--

INSERT INTO `atencion` (`id`, `consulta_id`, `no_historia_clinica`, `fecha_atencion`) VALUES
(3, 5, 1, '2024-05-10 23:57:58'),
(4, 5, 3, '2024-05-10 23:59:04'),
(5, 5, 3, '2024-05-13 16:36:20'),
(6, 4, 4, '2024-05-13 16:59:34');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consulta`
--

CREATE TABLE `consulta` (
  `id` int NOT NULL,
  `cant_pacientes` int DEFAULT '0',
  `nombre_especialista` varchar(100) DEFAULT NULL,
  `tipo_consulta` enum('pediatria','urgencia','cgi') NOT NULL,
  `estado` enum('ocupada','en_espera') NOT NULL,
  `hospital_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `consulta`
--

INSERT INTO `consulta` (`id`, `cant_pacientes`, `nombre_especialista`, `tipo_consulta`, `estado`, `hospital_id`) VALUES
(4, 10, 'Dr. Martinez', 'pediatria', 'ocupada', 1),
(5, 5, 'Dra. Gonzalez', 'urgencia', 'ocupada', 2),
(6, 12, 'Dr. Perez', 'cgi', 'ocupada', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hospital`
--

CREATE TABLE `hospital` (
  `id` int NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `hospital`
--

INSERT INTO `hospital` (`id`, `nombre`) VALUES
(1, 'Hospital Central'),
(2, 'Hospital Regional');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `no_historia_clinica` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `edad` int NOT NULL,
  `riesgo` float NOT NULL,
  `hospital_id` int DEFAULT NULL,
  `prioridad` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`no_historia_clinica`, `nombre`, `edad`, `riesgo`, `hospital_id`, `prioridad`) VALUES
(1, 'Juan Pérez', 5, 1, 1, 6),
(2, 'Ana Gómez', 28, 2, 2, NULL),
(3, 'Carlos López', 70, 0, 1, 7.5),
(4, 'Lucía Torres', 15, 0, 1, 3),
(5, 'Pedro Ramírez', 50, 0, 2, 4.66667);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `panciano`
--

CREATE TABLE `panciano` (
  `no_historia_clinica` int NOT NULL,
  `tiene_dieta` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `panciano`
--

INSERT INTO `panciano` (`no_historia_clinica`, `tiene_dieta`) VALUES
(3, 1),
(5, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pjoven`
--

CREATE TABLE `pjoven` (
  `no_historia_clinica` int NOT NULL,
  `fumador` tinyint(1) NOT NULL,
  `anos_fumador` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `pjoven`
--

INSERT INTO `pjoven` (`no_historia_clinica`, `fumador`, `anos_fumador`) VALUES
(2, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pninno`
--

CREATE TABLE `pninno` (
  `no_historia_clinica` int NOT NULL,
  `relacion_peso_estatura` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `pninno`
--

INSERT INTO `pninno` (`no_historia_clinica`, `relacion_peso_estatura`) VALUES
(1, 3),
(4, 2);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `atencion`
--
ALTER TABLE `atencion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `consulta_id` (`consulta_id`),
  ADD KEY `no_historia_clinica` (`no_historia_clinica`);

--
-- Indices de la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hospital_id` (`hospital_id`);

--
-- Indices de la tabla `hospital`
--
ALTER TABLE `hospital`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`no_historia_clinica`),
  ADD KEY `hospital_id` (`hospital_id`);

--
-- Indices de la tabla `panciano`
--
ALTER TABLE `panciano`
  ADD PRIMARY KEY (`no_historia_clinica`);

--
-- Indices de la tabla `pjoven`
--
ALTER TABLE `pjoven`
  ADD PRIMARY KEY (`no_historia_clinica`);

--
-- Indices de la tabla `pninno`
--
ALTER TABLE `pninno`
  ADD PRIMARY KEY (`no_historia_clinica`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `atencion`
--
ALTER TABLE `atencion`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `consulta`
--
ALTER TABLE `consulta`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `hospital`
--
ALTER TABLE `hospital`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `no_historia_clinica` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `atencion`
--
ALTER TABLE `atencion`
  ADD CONSTRAINT `atencion_ibfk_1` FOREIGN KEY (`consulta_id`) REFERENCES `consulta` (`id`),
  ADD CONSTRAINT `atencion_ibfk_2` FOREIGN KEY (`no_historia_clinica`) REFERENCES `paciente` (`no_historia_clinica`);

--
-- Filtros para la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD CONSTRAINT `consulta_ibfk_1` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`id`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`id`);

--
-- Filtros para la tabla `panciano`
--
ALTER TABLE `panciano`
  ADD CONSTRAINT `panciano_ibfk_1` FOREIGN KEY (`no_historia_clinica`) REFERENCES `paciente` (`no_historia_clinica`);

--
-- Filtros para la tabla `pjoven`
--
ALTER TABLE `pjoven`
  ADD CONSTRAINT `pjoven_ibfk_1` FOREIGN KEY (`no_historia_clinica`) REFERENCES `paciente` (`no_historia_clinica`);

--
-- Filtros para la tabla `pninno`
--
ALTER TABLE `pninno`
  ADD CONSTRAINT `pninno_ibfk_1` FOREIGN KEY (`no_historia_clinica`) REFERENCES `paciente` (`no_historia_clinica`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
