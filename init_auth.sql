DO
$$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'postgres') THEN
        CREATE USER postgres WITH PASSWORD 'postgres';
        ALTER USER postgres WITH SUPERUSER;
    END IF;
END
$$;

-- Crear el usuario 'auth' si no existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'auth') THEN
        CREATE ROLE auth LOGIN PASSWORD 'auth123.';
    END IF;
END $$;



-- Crear el esquema si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_namespace WHERE nspname = 'auth'
    ) THEN
        EXECUTE 'CREATE SCHEMA auth AUTHORIZATION auth';
    END IF;
END $$;


-- Crear tabla 'user' dentro del esquema 'auth'
CREATE TABLE IF NOT EXISTS auth.user (
    id SERIAL PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Trigger para actualizar 'updatedAt' automáticamente
CREATE OR REPLACE FUNCTION auth.actualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updated_at" := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_user_updated_at
BEFORE UPDATE ON auth.user
FOR EACH ROW
EXECUTE FUNCTION auth.actualizar_updated_at();

CREATE TABLE IF NOT EXISTS auth.profile (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    avatar TEXT,
    user_id INTEGER UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES auth."user"(id) ON DELETE CASCADE
);

-- Insertar usuario de prueba
INSERT INTO auth.user (email, password)
VALUES 
  ('admin@correo.com', '$2b$10$rSJe7yo54WU7LY1mv/ORgew8cRMim/sbMmLJhRRtx075Y6IQs9HJK'),
  ('admin2@correo.com', '$2b$10$rSJe7yo54WU7LY1mv/ORgew8cRMim/sbMmLJhRRtx075Y6IQs9HJK'),
  ('admin3@correo.com', '$2b$10$rSJe7yo54WU7LY1mv/ORgew8cRMim/sbMmLJhRRtx075Y6IQs9HJK'),
  ('admin4@correo.com', '$2b$10$rSJe7yo54WU7LY1mv/ORgew8cRMim/sbMmLJhRRtx075Y6IQs9HJK'),
  ('admin5@correo.com', '$2b$10$rSJe7yo54WU7LY1mv/ORgew8cRMim/sbMmLJhRRtx075Y6IQs9HJK'),
  ('admin6@correo.com', '$2b$10$rSJe7yo54WU7LY1mv/ORgew8cRMim/sbMmLJhRRtx075Y6IQs9HJK')
ON CONFLICT (email) DO NOTHING;

INSERT INTO auth.profile (name, avatar, user_id)
SELECT 'Test User', 'https://i.imgur.com/avatar.png', id FROM auth."user" WHERE email = 'admin@correo.com'
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO auth.profile (name, avatar, user_id)
SELECT 'Test User 2', 'https://i.imgur.com/avatar.png', id FROM auth."user" WHERE email = 'admin2@correo.com'
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO auth.profile (name, avatar, user_id)
SELECT 'Test User 3', 'https://i.imgur.com/avatar.png', id FROM auth."user" WHERE email = 'admin3@correo.com'
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO auth.profile (name, avatar, user_id)
SELECT 'Test User 4', 'https://i.imgur.com/avatar.png', id FROM auth."user" WHERE email = 'admin4@correo.com'
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO auth.profile (name, avatar, user_id)
SELECT 'Test User 5', 'https://i.imgur.com/avatar.png', id FROM auth."user" WHERE email = 'admin5@correo.com'
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO auth.profile (name, avatar, user_id)
SELECT 'Test User 5', 'https://i.imgur.com/avatar.png', id FROM auth."user" WHERE email = 'admin6@correo.com'
ON CONFLICT (user_id) DO NOTHING;