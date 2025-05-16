-- Crear el usuario 'postgres' si no existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'postgres') THEN
        CREATE ROLE postgres LOGIN PASSWORD 'postgres';
        ALTER ROLE postgres WITH SUPERUSER;
    END IF;
END
$$;

-- -- Crear el usuario 'post' si no existe
-- DO $$
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'post') THEN
--         CREATE ROLE post LOGIN PASSWORD 'post123.';
--     END IF;
-- END
-- $$;

-- Crear el esquema 'post' si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_namespace WHERE nspname = 'post'
    ) THEN
        EXECUTE 'CREATE SCHEMA post AUTHORIZATION postgres';
    END IF;
END
$$;

-- Crear tabla 'posts'
CREATE TABLE IF NOT EXISTS post.post (
  id SERIAL PRIMARY KEY,
  content TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Crear función trigger para actualizar el campo updated_at
CREATE OR REPLACE FUNCTION post.actualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger sobre la tabla post.posts
CREATE TRIGGER trigger_update_post_updated_at
BEFORE UPDATE ON post.post
FOR EACH ROW
EXECUTE FUNCTION post.actualizar_updated_at();

CREATE TABLE IF NOT EXISTS post.like (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  post_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT now(),
  CONSTRAINT fk_post FOREIGN KEY (post_id) REFERENCES post.post(id) ON DELETE CASCADE,
  CONSTRAINT unique_like UNIQUE (user_id, post_id)
);

INSERT INTO post.post (content, user_id)
VALUES 
  ('Primer post de prueba', 1),
  ('Post de otro usuario', 2),
  ('Post de otro usuario', 2),
  ('Post de otro usuario', 2),
  ('Post de otro usuario', 2),
  ('Post de otro usuario', 2),
  ('Post de otro usuario', 2),
  ('Post de otro usuario', 2)
ON CONFLICT DO NOTHING;