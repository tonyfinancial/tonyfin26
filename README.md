# Tony Financial

Base inicial para administrar clientes, vehículos, financiamientos y pagos.

## Abrir el proyecto

1. Instala [Node.js LTS](https://nodejs.org/).
2. Descomprime el archivo y abre la carpeta en VS Code.
3. Copia `.env.example` como `.env` y completa las dos variables de Supabase.
4. En Supabase, abre **SQL Editor**, ejecuta `supabase/schema.sql` y crea el primer usuario desde **Authentication > Users**.
5. En la terminal del proyecto ejecuta `npm install` y luego `npm run dev`.

La aplicación quedará disponible normalmente en `http://localhost:5173`.

## Instalar como aplicación

Después de publicarla en Vercel o en otro sitio con HTTPS, ábrela desde el teléfono.
En Android usa el menú del navegador y selecciona **Instalar aplicación**. En iPhone usa **Compartir > Agregar a pantalla de inicio**.

## Punto de continuación

- **Supabase:** esquema, RLS y datos de ejemplo en `supabase/schema.sql`.
- **Autenticación:** inicio/cierre de sesión por correo y contraseña ya conectado a Supabase.
- **Panel administrativo:** métricas básicas y navegación base.
- **Módulos:** pantallas de clientes, vehículos, financiamientos y pagos listas para conectar formularios y operaciones CRUD.

## Próximos pasos sugeridos

1. Crear formularios para altas/ediciones en cada módulo.
2. Agregar roles (administrador, asesor y cobranza) a `profiles`.
3. Calcular saldo y cuotas pendientes desde los pagos.
4. Añadir filtros, exportación y recibos.
