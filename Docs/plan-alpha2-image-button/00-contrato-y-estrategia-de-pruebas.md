# Fase 0 — Contrato y estrategia de pruebas

## Objetivo

Cerrar antes de tocar producto el comportamiento público de la transición de
`DSRemoteImage`, su contenido de carga personalizable y el nuevo dimensionamiento
intrínseco de `DSButton`.

## Alcance

- Definir una transición de opacidad únicamente de `loading` a imagen cargada.
- Usar la duración normal del tema para la transición y reemplazar el contenido
  inmediatamente cuando `accessibilityReduceMotion` esté activo.
- Conservar el initializer actual de `DSRemoteImage` y su skeleton con shimmer
  como comportamiento por defecto.
- Añadir un único punto de personalización `@ViewBuilder` para cualquier View de
  carga. `Image` ya es una View, por lo que no se diseñará una API paralela sólo
  para imágenes.
- Mantener `DSRemoteImage` como tipo público no genérico. La alternativa preferida
  es un initializer genérico que encapsule privadamente el contenido de carga,
  preservando los call sites y la identidad pública del tipo.
- Establecer que el componente conserva la propiedad del frame, clip y descriptor
  de accesibilidad. El contenido de carga personalizado ocupa esa geometría y no
  debe anunciar un segundo elemento accesible.
- Definir que `showsShimmer` afecta sólo al skeleton por defecto; DaVinci no añade
  shimmer implícito a una View personalizada.
- Definir que el placeholder `DSSymbol` continúa siendo contenido de error/nil URL,
  no contenido de carga.
- Cambiar `DSButton` para abrazar su contenido por defecto eliminando el
  `maxWidth` interno.
- Antes de implementar `DSButton`, construir una prueba/prototipo mínimo que
  determine qué composición de modificadores SwiftUI externos controla el ancho
  de la superficie pintada, no sólo el contenedor transparente. No asumir que
  `.frame(maxWidth: .infinity)` aplicado después del componente lo consigue.
- Si ninguna composición SwiftUI estándar satisface ancho intrínseco por defecto y
  fill pintado opt-in sin API DaVinci adicional, detener la fase 2 y pedir una
  decisión explícita al usuario.
- Conservar tamaños `regular`/`compact`, padding, alto pintado, hit target,
  apariencias, estados e iconos.

## Fuera de alcance

- Diseñar enums o parámetros `width`, `fill`, `fit`, `fullWidth` o equivalentes.
- Personalizar el contenido de error de `DSRemoteImage` o cambiar su retry/cache.
- Animar transiciones hacia failure, nil URL o cancelación.
- Cambiar geometría, content mode, pipeline, deduplicación o límites de imágenes.
- Actualizar snapshots, código de producto o baselines en esta fase.

## Entregables concretos

1. Contrato escrito de `DSRemoteImage`:
   - crossfade sólo `loading → success`;
   - duración `theme.motion.normal` con curva ease-in-out;
   - reemplazo inmediato con Reduce Motion;
   - default skeleton intacto;
   - overload `@ViewBuilder loading` para cualquier View;
   - placeholder de error intacto.
2. Contrato escrito de `DSButton`: ancho intrínseco por defecto y ancho controlado
   exclusivamente por el layout SwiftUI del consumidor.
3. Matriz de pruebas previa a implementación para estados, accesibilidad,
   reducción de movimiento, layout intrínseco y opt-in a ancho completo.
4. Política de baseline en dos momentos:
   - no actualizarlo ahora, durante diseño, ni para ocultar un fallo;
   - después de implementar y aprobar explícitamente el initializer público de
     loading, revisar el diff de API anterior/nuevo y actualizar deliberadamente
     el baseline 2.0 para proteger esa superficie.
5. Prototipo de layout que identifique una receta SwiftUI estándar para controlar
   el ancho pintado de `DSButton`, o un bloqueo documentado para el usuario si no
   existe.

## Criterios de salida

- No queda ambigüedad entre contenido de loading y placeholder de error.
- Está decidido que existe una sola API de View personalizada y que acepta `Image`.
- Reduce Motion tiene resultado observable e inmediato, sin animación residual.
- `DSButton.Size.regular` deja de documentarse como “full width”; sólo describe
  métricas visuales.
- No comienza la fase 2 hasta demostrar con una prueba la receta externa de ancho
  pintado. Si el prototipo falla, el criterio de salida es elevar el bloqueo, no
  continuar basándose en una suposición.
- Está acordado qué snapshots cambiarán y que sólo se regrabarán tras revisar el
  resultado de implementación.

## Decisión de alcance del botón

Validado el 2026-09-18 con el `DSButton` sin su `maxWidth` interno y una
composición consumidora `.frame(maxWidth: .infinity)`: el contenedor externo sí
ocupa el canvas disponible, pero la superficie pintada conserva el ancho
intrínseco. La decisión es dejar `DSButton` sin cambios de producto ni
snapshots; quien implemente una pantalla puede limitar el contenedor que recibe
el botón para controlar el área disponible. No se añade una API DaVinci de
width/fill.

## Pruebas requeridas

- Prueba unitaria de la política de transición: animación habilitada/deshabilitada
  según Reduce Motion y fase destino.
- Compilación de API pública del initializer existente y del nuevo loading closure.
- Pruebas de layout que distingan ancho intrínseco, tamaño del contenedor externo y
  tamaño real de la superficie pintada para cada composición candidata.
- Pruebas de accesibilidad que aseguren un único descriptor durante loading.
- Fixtures/loaders controlables para observar loading y success sin red real.

## Riesgos

- Convertir `DSRemoteImage` en un struct genérico rompería referencias estáticas e
  inferencia en tests; debe evitarse salvo evidencia que invalide la opción elegida.
- Una animación aplicada al contenedor completo puede animar failure o cambios de
  URL por accidente.
- Type erasure del loading view puede afectar identidad o rendimiento; debe quedar
  confinada al contenido temporal y medirse si aparece una regresión.
- El cambio de ancho de `DSButton` es source-compatible pero visualmente breaking;
  documentación y snapshots deben tratarlo como cambio de contrato de alpha.2.
- Un `.frame(maxWidth: .infinity)` externo puede expandir sólo un contenedor
  transparente. Tratarlo como checkpoint bloqueante evita documentar una receta
  que no controla el botón pintado.

## Archivos probables

- `Sources/DaVinciComponents/DSRemoteImage.swift`
- `Sources/DaVinciComponents/DSButton.swift`
- `Tests/DaVinciComponentsTests/DSRemoteImageBehaviorTests.swift`
- `Tests/DaVinciComponentsTests/PublicAPICompilationTests.swift`
- `Tests/DaVinciComponentsTests/DSButtonSnapshotTests.swift`
- `Docs/Migration-2.0.md`
- `CHANGELOG.md`

## Auditoría de planes existentes

- `Docs/plan-2.0-xcode27/00...05`: conservar. Aunque gran parte está ejecutada,
  quedan acciones abiertas o no verificables en los propios documentos: baseline
  final, consumidor desde tag, integración, publicación y observación post-release.
  Además, el directorio está excluido localmente de Git.
- `Docs/2.0-Alpha-2-Checklist.md`: conservar; todas las tareas de alpha.2 están
  abiertas.
- `Docs/2.0-Release-Checklist.md`: conservar; PR, publicación y smoke post-release
  siguen abiertos.
- `Docs/Post-2.0-Continuity.md`: conservar; es política futura y backlog vigente.
- No se elimina ningún documento. Ante la duda sobre el cierre completo de las
  fases históricas se aplica la regla conservadora solicitada.
