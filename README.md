# Proyecto Microservicios: Auth y Posts

Este proyecto está compuesto por dos microservicios independientes. Cada uno tiene su propia base de datos y está diseñado con el framework Nodejs con NestJS, utilizando PostgreSQL con el ORM Prisma.

## Descripción



### 1. `auth-mss`
Microservicio encargado de la autenticación y gestión de usuarios.

- **Stack:** NestJS, PostgreSQL, Prisma, JWT, bcrypt
- **Responsabilidades:**
  - R de perfil de usuario logueado
  - Inicio de sesión (login) y generación de tokens JWT
- **Base de datos (auth_mss):**
  - Tabla: `user`, `profile`

### 2. `posts-mss`
Microservicio encargado de la gestión de publicaciones.

- **Stack:** NestJS, PostgreSQL, Prisma
- **Responsabilidades:**
  - CR de publicaciones
  - Validación del `userId` (relación con el usuario autenticado)
- **Base de datos (post_mss):**
  - Tablas: `post`, `like`
  
## Requisitos

1. **Docker** y **Docker Compose** para ejecutar los servicios en contenedores.

## Configuración de Docker Compose

El archivo `docker-compose.yml` define los siguientes servicios:

- **postgres_auth**: Contenedor de base de datos PostgreSQL para el login/perfil.
- **postgres_post**: Contenedor de base de datos PostgreSQL para los posts y likes.
- **auth_service**: Microservicio que maneja la autenticación.
- **post_service**: Microservicio que maneja las posts y likes.

### Estructura del `docker-compose.yml`

```yaml
version: '3.8'

services:
  postgres_auth:
    image: postgres:15
    container_name: auth-db
    environment:
      POSTGRES_DB: mss_auth
      POSTGRES_USER: auth
      POSTGRES_PASSWORD: auth123.
    ports:
      - "5432:5432"
    volumes:
      - pgdata_auth:/var/lib/postgresql/data
      - ./init_auth.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - backend

  postgres_post:
    image: postgres:15
    container_name: post-db
    environment:
      POSTGRES_DB: mss_post
      POSTGRES_USER: post
      POSTGRES_PASSWORD: post123.
    ports:
      - "5433:5432"
    volumes:
      - pgdata_post:/var/lib/postgresql/data
      - ./init_posts.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - backend

  auth_service:
    build: ./auth-mss
    container_name: auth_mss
    depends_on:
      - postgres_auth
    environment:
      DATABASE_URL: postgres://auth:auth123.@postgres_auth:5432/mss_auth
    ports:
      - "3000:3000"
    networks:
      - backend

  post_service:
    build: ./posts-mss
    container_name: posts-service
    ports:
      - "3001:3001"
    environment:
      DATABASE_URL: postgres://post:post123.@postgres_post:5432/mss_post
    depends_on:
      - postgres_post
    networks:
      - backend
      
networks:
  backend:
    driver: bridge

volumes:
  pgdata_auth:
  pgdata_post:
```



# Guía para Clonar el Repositorio y Levantar los Contenedores Docker

## 1. Clonar el Repositorio

Sigue estos pasos para clonar el repositorio:

1. Abre una terminal en tu computadora.
2. Navega al directorio donde deseas guardar el proyecto.
3. Clona el repositorio usando el siguiente comando:

   ```bash
   git@github.com:oskrg03/test-backend.git
   ```

4. Una vez clonado el repositorio, navega al directorio del proyecto con el siguiente comando:

   ```bash
   cd test-backend
   ```

## 2. Construir las Imágenes de Docker

Para construir las imágenes de Docker, sigue estos pasos:

1. Abre una terminal en el directorio donde tienes el `docker-compose.yml`.
2. Ejecuta el siguiente comando para construir las imágenes de Docker:

   ```bash
   docker-compose build
   ```

   Este comando descargará las imágenes necesarias y construirá los servicios definidos en el archivo `docker-compose.yml`.

## 3. Subir los Contenedores de Docker

Una vez que las imágenes hayan sido construidas, puedes iniciar los contenedores con el siguiente comando:

```bash
docker-compose up
```

Esto iniciará todos los servicios definidos en el `docker-compose.yml`.

## 4. Verificar que los Contenedores Están Corriendo

Para verificar que los contenedores están corriendo correctamente, usa el siguiente comando:

```bash
docker ps
```

Esto te mostrará todos los contenedores en ejecución. Asegúrate de que los contenedores `microservicio-clientes` y `microservicio-account` estén en la lista.

## 5. Verificar la Base de Datos

Si necesitas verificar que las bases de datos están correctamente configuradas, puedes conectarte a los contenedores de las bases de datos y comprobar que las tablas estén creadas. Usa los siguientes comandos:

Para la base de datos de clientes:

```bash
docker exec -it auth-db psql -U auth -d auth_mss
```

Para la base de datos de cuentas:

```bash
docker exec -it post-db psql -U post -d mss_post
```

## 6. Usuarios creados
Una vez subas las bases de datos, se crearán automáticamente los siguientes usuarios:
- admin@correo.com / admin123 / 1 publicación
- admin2@correo.com / admin123 / 2 publicaciones
- admin3@correo.com / admin123 / 1 publicación
- admin4@correo.com / admin123 / 1 publicación
- admin5@correo.com / admin123 / 3 publicaciones
- admin6@correo.com / admin123 / 0 publicaciones


# Guía para levantar el frontend

## 1. Clonar el Repositorio

Sigue estos pasos para clonar el repositorio:

1. Abre una terminal en tu computadora.
2. Navega al directorio donde deseas guardar el proyecto.
3. Clona el repositorio usando el siguiente comando:

   ```bash
   git@github.com:oskrg03/test-backend.git
   ```

4. Una vez clonado el repositorio, navega al directorio del proyecto con el siguiente comando:

   ```bash
   cd test-frontend
   ```
5. ejecuta el siguiente comando:

   ```bash
   npm install
   ```
6. ejecuta el siguiente comando:

   ```bash
   npm run dev
   ```
