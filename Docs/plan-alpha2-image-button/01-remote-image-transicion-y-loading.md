# Fase 1 — DSRemoteImage: transición y loading personalizable

## Objetivo

Implementar una aparición suave y accesible de la imagen cargada, junto con un
contenido de loading personalizable que preserve el comportamiento existente por
defecto.

## Alcance

- Añadir lectura de `accessibilityReduceMotion` en `DSRemoteImage`.
- Aplicar crossfade cuando una carga válida pasa de `.loading` a `.success`.
- Resolver la animación mediante una política interna comprobable, evitando que
  los tests dependan de sleeps o frames intermedios del simulador.
- Mantener el skeleton `DSSkeletonBlock` y `showsShimmer` para el initializer actual.
- Añadir un overload source-compatible con `@ViewBuilder loading`, válido para
  `Image`, composiciones o cualquier otra View.
- Encajar loading, éxito y error en la misma geometría y clip existentes.
- Mantener las semánticas de loading, success, failure, nil URL y decorative.
- Añadir ejemplos en previews y Gallery para skeleton por defecto, imagen estática
  de carga y View personalizada.

## Fuera de alcance

- Cambiar el `DSImagePipeline`, cache, decodificación, cancelación o retry.
- Animar failure, nil URL o el reset producido por cambiar de URL/loader.
- Añadir contenido de error arbitrario; `placeholder: DSSymbol?` permanece igual.
- Aplicar shimmer automáticamente al loading personalizado.
- Regrabar snapshots no relacionados o actualizar el baseline antes de revisar y
  aprobar explícitamente la nueva superficie pública.

## Entregables concretos

1. Initializer existente sin cambios de firma ni comportamiento inicial.
2. Nuevo initializer público con loading closure, documentando que el componente
   aporta frame, clip y accesibilidad.
3. Crossfade `loading → success` gobernado por tokens de motion del tema.
4. Ruta Reduce Motion que cambia de contenido sin animación.
5. Tests behavior-first para política de transición, carga cancelada, cambio de
   identidad y contenido personalizado.
6. Casos visuales específicos de loading personalizado y estado cargado; no usar
   una animación temporal como baseline de snapshot.
7. Ejemplos públicos compilables, previews y Gallery actualizados.
8. Diff de API capturado para demostrar que el único cambio público esperado es el
   initializer aditivo de loading; su aprobación y baseline pertenecen a fase 3.

## Criterios de salida

- Un URL válido muestra loading y revela la imagen con crossfade al terminar.
- Con Reduce Motion, el mismo cambio es inmediato.
- Nil URL entra directamente al placeholder sin skeleton ni animación.
- Failure conserva el placeholder actual y no ejecuta crossfade.
- Cambiar URL o loader no permite que una tarea cancelada revele una imagen vieja.
- El initializer legado sigue compilando y renderizando el skeleton existente.
- Una `Image` y una View compuesta pueden usarse como loading content mediante la
  misma API.
- La nueva firma pública coincide exactamente con el diff que se llevará a
  aprobación; no se actualiza todavía el baseline para silenciar discrepancias.
- Accesibilidad anuncia un solo elemento con estado loading, aunque la View
  personalizada contenga texto o imágenes.

## Pruebas requeridas

- `DSRemoteImageBehaviorTests`:
  - política de animación para Reduce Motion on/off;
  - sólo success desde loading es animable;
  - cancellation y stale result no cambian el contenido;
  - etiquetas/traits existentes permanecen iguales.
- `PublicAPICompilationTests`:
  - initializer legado;
  - custom loading con `Image`;
  - custom loading con una composición `ZStack`/`ProgressView`.
- `DSRemoteImageSnapshotTests`:
  - skeleton default estable;
  - custom loading estático en light/dark y geometría recortada;
  - success final capturado sin depender del punto medio de la animación.
- Previews/Gallery con Reduce Motion verificable manualmente.
- Suite de runtime mínimo iOS 17.5 para asegurar disponibilidad de APIs SwiftUI.

## Riesgos

- Animar `phase` antes de asignar `decodedImage` puede mostrar el placeholder en
  lugar de la imagen; el orden de estado debe ser determinista.
- `withAnimation` dentro de una tarea puede capturar resultados obsoletos si no se
  comprueba cancelación inmediatamente antes de mutar estado.
- Snapshots de una transición en curso son inherentemente flaky; deben fijar un
  estado estable y probar la política temporal por separado.
- El loading personalizado puede duplicar accesibilidad si no se ocultan sus hijos.
- La type erasure puede reinicializar contenido con estado; documentar que el
  loading content es transitorio y probar identidad básica.

## Archivos probables

- `Sources/DaVinciComponents/DSRemoteImage.swift`
- `Sources/DaVinciComponents/DSRemoteImage+Previews.swift`
- `Sources/DaVinciGallery/Components/DSRemoteImageGalleryScreen.swift`
- `Tests/DaVinciComponentsTests/DSRemoteImageBehaviorTests.swift`
- `Tests/DaVinciComponentsTests/DSRemoteImageSnapshotTests.swift`
- `Tests/DaVinciComponentsTests/PublicAPICompilationTests.swift`
- `Tests/DaVinciComponentsTests/DaVinciComponentsTests.swift`
- `README.md`
- `Docs/Usage.md`
- `Docs/Migration-2.0.md`
- `CHANGELOG.md`
