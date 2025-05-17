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
  ('Hay días en los que no me reconozco. Me miro al espejo y hay alguien ahí, respirando con mi cara, con mis gestos, pero no soy yo. Tal vez es solo el peso de tantas versiones de mí mismo que ya no existen. Tal vez es solo cansancio. Pero quiero encontrarme otra vez, en el silencio, en una canción, en un café sin prisas. Quiero regresar.', 1),
  ('A veces me pregunto si pensás en mí con la misma intensidad con la que yo te pienso. Si acaso tu corazón se acelera al recordar un momento tonto que para mí significó todo. Es curioso cómo alguien puede ser el centro de tu universo y, al mismo tiempo, apenas una estrella lejana en el suyo.', 2),
  ('Crecer no fue como me lo contaron. No se sintió como libertad, sino como aprender a callar ciertas cosas, a fingir sonrisas, a pagar cuentas con el alma. Pero también fue aprender a cuidarme, a quedarme solo si hace falta, a soltar con cariño. Tal vez madurar no es endurecerse, sino suavizarse con sabiduría.', 2),
  ('Es como si el aire se volviera más denso, como si el mundo hablara en un idioma que ya no entiendo. La ansiedad no siempre grita, a veces solo susurra al oído: "algo va mal", aunque todo parezca estar bien. Y ahí estoy yo, tratando de calmarme con respiraciones profundas y pensamientos rotos.', 3),
  ('No quiero morir, pero a veces quisiera dejar de estar. Ser invisible por un rato. Que nadie espere nada de mí, que el tiempo se detenga y me dé una tregua. No es tristeza, es agotamiento. Solo quiero un refugio donde pueda existir sin presión, sin tener que justificar mi cansancio.', 4),
  ('Hay personas con las que el silencio no incomoda. Con ellas, no hace falta llenar los espacios con palabras, porque la presencia basta. Y a veces, en medio del ruido del mundo, esos silencios compartidos se sienten más sinceros que mil conversaciones forzadas.', 5),
  ('Hay noches que no terminan cuando sale el sol. Se quedan pegadas a la piel como un recuerdo que no sabes si fue sueño o pesadilla. Me quedo mirando el techo, como si esperara respuestas que nunca llegan. Y aun así, cada noche vuelvo a cerrar los ojos con la esperanza de que el sueño me salve un poco.', 5),
  ('Me han dicho que siento demasiado, que pienso demasiado, que hablo demasiado de lo que no debería. Pero si intento ser menos, ¿quién soy? Prefiero ser demasiado antes que ser nada. Aunque a veces duela, ser sensible también es una forma de resistencia.', 5)
ON CONFLICT DO NOTHING;