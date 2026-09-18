# Fase 3 — Integración, documentación y validación de alpha.2

## Objetivo

Integrar ambos cambios como un contrato coherente de alpha.2, revisar sus efectos
visuales y cerrar la matriz de calidad sin congelar todavía la API estable 2.0.

## Estado de ejecución

Completada el 2026-09-18. `DSRemoteImage` quedó documentado, su initializer
aditivo fue incorporado al baseline 2.0 y el contrato de `DSButton` quedó
explícitamente sin cambio de producto. Pasaron SwiftLint, suite iOS 27.0,
cobertura, runtime mínimo iOS 17.5, DocC, scripts de validación, API check y
consumidor externo. No se creó ningún tag.

## Alcance

- Actualizar documentación pública y notas de alpha.2 con ambos cambios.
- Registrar que `DSButton` no cambia su default visual; la nueva carga de
  `DSRemoteImage` es la única API aditiva de pre-release.
- Revisar y aprobar sólo snapshots directamente afectados.
- Ejecutar la matriz Xcode 27 e iOS 17.5 establecida por el repositorio.
- Confirmar lint y cobertura de Gallery tras añadir ejemplos.
- Ejecutar API check y generar un diff revisable contra el baseline 2.0 existente.
- Tras aprobación explícita del initializer aditivo de `DSRemoteImage`, actualizar
  deliberadamente el baseline 2.0 y verificar que la comparación posterior pasa.
- Conservar el plan y los checklists de release que todavía tienen acciones abiertas.

## Fuera de alcance

- Publicar `v2.0.0-alpha.2` o `v2.0.0`.
- Actualizar baselines para ocultar fallos, mezclar símbolos no aprobados o relajar
  filtros del digester. La actualización aprobada del initializer de loading sí
  forma parte de esta fase.
- Cambiar tolerancias globales de snapshots o performance.
- Resolver deuda post-2.0 no relacionada.
- Diseñar nuevas opciones de ancho o personalización del estado de error.

## Entregables concretos

1. `CHANGELOG.md`, Migration, README y Usage describen:
   - crossfade de remote image y Reduce Motion;
   - loading View personalizada y skeleton default;
   - placeholder de error sin cambios;
   - el default full-width actual de `DSButton` y la recomendación de limitar su
     contenedor cuando una pantalla necesite un ancho menor.
2. Gallery y previews permiten revisar todos los casos nuevos.
3. Snapshots afectados acompañados por una explicación concreta del diff.
4. Suite completa, runtime mínimo, cobertura, DocC, lint, consumer y API check
   verdes sobre el mismo SHA candidato.
5. Checklist de alpha.2 actualizado con evidencia y pendientes reales.
6. Evidencia de API en tres pasos: baseline anterior intacto, diff aprobado de la
   nueva firma y baseline 2.0 actualizado que pasa contra el mismo build.

## Criterios de salida

- Los ejemplos siguen describiendo correctamente `regular` como full width por
  defecto; no se documenta un cambio de ancho que no se implementó.
- No se confunden loading personalizado y placeholder de error.
- Reduce Motion fue probado automática y manualmente.
- Dos corridas visuales limpias consecutivas producen cero diff tras aprobar los
  nuevos PNG.
- Tokens >= 100%, Components >= 95% y Gallery >= 60% continúan pasando.
- DocC no introduce warnings propios y el consumidor externo compila.
- Antes de actualizar, el diff de API contiene sólo el initializer aditivo esperado.
- La nueva API recibe aprobación explícita; después se actualiza el baseline 2.0
  de forma deliberada y `check-api-baseline.sh --check` pasa.
- El checkpoint de ancho pintado de `DSButton` tiene evidencia y la decisión de
  no cambiar el componente está registrada.
- El working tree queda limpio y los cambios se agrupan en commits revisables.

## Pruebas requeridas

- `swiftlint lint --strict`.
- Suite de scripts Python.
- Build genérico/previews con deployment iOS 17.
- Tests completos con Xcode 27 y cobertura por producto.
- Dos corridas de suites snapshot en simuladores limpios.
- Carril iOS 17.5 sin snapshots/performance según la política vigente.
- DocC y gate de diagnósticos propios.
- Consumidor externo de Tokens, Components y Gallery.
- API baseline en modo check antes del cambio, inspección del diff, actualización
  aprobada y nuevo check después de actualizar.
- Revisión manual de Reduce Motion, custom loading y recetas de ancho en Gallery.

## Riesgos

- Mezclar regrabación visual con correcciones funcionales dificulta revisar la
  causa de cada PNG; separar commits o al menos secciones del diff.
- El workflow puede quedar verde aunque la receta documentada de full width no
  pinte realmente todo el ancho; validarla visualmente en Gallery.
- Una View de loading con animación propia puede ignorar Reduce Motion; DaVinci
  sólo puede garantizar su transición y debe documentar la responsabilidad del
  contenido suministrado por el consumidor.
- Una API aditiva puede aparecer en el diff del digester aunque no sea breaking;
  debe revisarse y luego incorporarse al baseline para que no quede desprotegida.

## Archivos probables

- `README.md`
- `Docs/Usage.md`
- `Docs/Migration-2.0.md`
- `Docs/Support.md`
- `Docs/Release-2.0.0-alpha.2.md`
- `Docs/2.0-Alpha-2-Checklist.md`
- `CHANGELOG.md`
- `.github/workflows/ci.yml` sólo si la matriz actual no ejecuta un gate requerido
- Snapshots específicos bajo `Tests/DaVinciComponentsTests/__Snapshots__/`
