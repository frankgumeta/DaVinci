# Fase 2 — DSButton con ancho intrínseco

## Objetivo

Hacer que `DSButton` abrace su contenido por defecto y que el ancho completo sea
una decisión explícita del layout consumidor mediante modificadores SwiftUI.

## Estado de ejecución

Bloqueada en el checkpoint previo a implementación, 2026-09-18. El prototipo
retiró temporalmente el `maxWidth` interno y probó
`.frame(maxWidth: .infinity)` desde el consumidor: el wrapper se expandió, pero
el fondo pintado permaneció intrínseco. No se cambió `DSButton` ni sus snapshots.
Se necesita decidir cómo debe obtenerse un CTA full-width con el appearance de
DaVinci antes de continuar.

## Alcance

- Prerrequisito bloqueante: fase 0 debe haber demostrado con una prueba qué
  composición SwiftUI externa modifica el ancho de la superficie pintada. Si no
  existe una receta válida sin API width/fill/fit, no implementar esta fase y
  solicitar decisión al usuario.
- Eliminar el `.frame(maxWidth: .infinity)` interno de `DSButton` para todos los
  tamaños y apariencias.
- Mantener padding, altura pintada, radio, iconos, loading, disabled, accesibilidad
  y `DSPressableButtonStyle`.
- Mantener el hit target mínimo de `compact`; el cambio no debe reducir su área
  interactiva debajo de `ControlHeightTokens.minimumHitTarget`.
- Actualizar DocC: `Size.regular` describe altura/padding regular, no full width.
- Mostrar en previews y Gallery tanto el ancho intrínseco por defecto como el opt-in
  del consumidor usando únicamente la composición validada en el checkpoint.
- Documentar la migración visual para layouts que dependían del fill implícito.

## Fuera de alcance

- Añadir parámetros o enums de ancho, fill, fit o alignment.
- Cambiar `DSButton.Size`, sus valores o el initializer público.
- Cambiar estilos, colores, tipografía, animaciones o accesibilidad.
- Modificar `DSIconButton`.
- Alterar tolerancias de snapshot o regenerar baselines de API.

## Entregables concretos

1. Implementación sin `maxWidth` interno.
2. Test de layout intrínseco que demuestre que un botón corto ocupa menos que su
   contenedor disponible.
3. Test de composición que demuestre que la receta SwiftUI validada produce una
   superficie pintada de ancho completo, no sólo un contenedor externo ancho.
4. Cobertura de etiquetas cortas, largas, con iconos, loading, regular y compact.
5. Snapshots regrabados únicamente después de revisar el diff esperado.
6. DocC, README, Usage, Gallery y guía de migración coherentes con el nuevo default.

## Criterios de salida

- `DSButton("OK")` abraza el texto más padding y métricas propias.
- El padre puede controlar el ancho pintado usando la composición SwiftUI estándar
  demostrada por el prototipo.
- Si ninguna receta estándar funciona, la fase termina bloqueada antes de cambiar
  producto y registra la decisión que necesita del usuario.
- Loading conserva el ancho de su contenido invisible y no provoca layout jump.
- Etiquetas largas envuelven o se restringen según el espacio impuesto por el padre.
- Regular y compact mantienen sus alturas y hit targets actuales.
- Ninguna firma pública nueva aparece en el diff de API.
- Todo cambio visual aprobado está limitado a snapshots de botón o composiciones
  que dependían del fill implícito.

## Pruebas requeridas

- Nueva prueba de medición/layout con contenedor ancho y título corto.
- Prototipo que mida por separado bounds externos y superficie pintada con
  `.frame(maxWidth: .infinity)` y cualquier otra composición SwiftUI candidata.
- Test definitivo de la única receta que demuestre fill pintado, si existe.
- Estados primary/secondary/outline/ghost, loading y disabled.
- Iconos leading/trailing y etiqueta larga con ancho restringido.
- Verificación del mínimo de hit target para compact.
- Snapshots light/dark de ancho intrínseco y de fill explícito.
- Gallery smoke y compilación de previews tras ajustar sus layouts.
- API digester en modo check; se espera cero cambio de interfaz por esta fase.

## Riesgos

- Aplicar `.frame(maxWidth: .infinity)` después de `DSButton` expande el espacio de
  la View, pero no necesariamente el fondo interno. Si el prototipo no encuentra
  una composición estándar que ensanche el control pintado, esto es un bloqueo y
  una duda para el usuario, no permiso para inventar una API o continuar.
- Stacks y formularios que dependían del fill implícito cambiarán visualmente.
- Loading puede reducirse si el contenido invisible deja de participar en layout.
- Snapshots con canvas fijo pueden ocultar el ancho real si el harness impone frame.
- La documentación existente contiene ejemplos que asumen botones full width.

## Archivos probables

- `Sources/DaVinciComponents/DSButton.swift`
- `Sources/DaVinciComponents/DSButton+Previews.swift`
- `Sources/DaVinciGallery/Components/DSButtonGalleryScreen.swift`
- `Tests/DaVinciComponentsTests/DSButtonSnapshotTests.swift`
- `Tests/DaVinciComponentsTests/DaVinciComponentsTests.swift`
- `Tests/DaVinciComponentsTests/PublicAPICompilationTests.swift`
- `README.md`
- `Docs/Usage.md`
- `Docs/Migration-2.0.md`
- `CHANGELOG.md`
