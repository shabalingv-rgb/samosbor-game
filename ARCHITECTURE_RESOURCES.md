# Архитектура: Система ресурсов и фаз (Sprint 1)

**Автор решения:** Opus (архитектурная задача Sprint 1.2.1)
**Статус:** Реализовано

---

## Проблема

Нужна экономика двух ресурсов (Биомасса, Ужас) и цикл двух фаз (скрытое
накопление ↔ активный самосбор), к которым подключаются UI, NPC, вентиляция,
дерево мутаций и враги — без жёсткой связанности между ними.

## Решение: три роли

| Компонент | Тип | Ответственность |
|-----------|-----|-----------------|
| `GameManager` | **Autoload** | Единственный источник истины: значения ресурсов, `phase`, `detection_risk`, `current_floor` + сигналы. Ничего не «решает», только хранит и оповещает. |
| `ResourceSystem` | Node в `game_scene` | **Правила экономики**: пассивная генерация, ценность событий (звук/видение/сон/алтарь), проверка и трата ресурсов. Читает/пишет через GameManager. |
| `PhaseManager` | Node в `game_scene` | **Переходы фаз** и пороги обнаружения (80% → ликвидаторы, 95% → принудительная Фаза 2). Реагирует на `detection_changed`. |

### Почему так

- **GameManager как autoload, а не как скрипт корня сцены.** Раньше `game_manager.gd`
  висел на корне `game_scene.tscn` — singleton `GameManager` физически не
  существовал, любое обращение `GameManager.biomass` из других систем упало бы.
  Autoload делает состояние глобально доступным и переживает смену этажа.
- **Значения — только в GameManager.** UI подписывается на `resources_changed` /
  `phase_changed` и не знает про экономику. Можно переписать правила генерации,
  не трогая интерфейс.
- **Правила отделены от состояния.** `ResourceSystem` не хранит числа — это
  позволяет тестировать экономику и менять баланс (`@export` ставки) в инспекторе.

## Поток данных

```
события игры ──► ResourceSystem.gain_terror_from("vision")
                       │ modify_terror()
                       ▼
                  GameManager (state) ──emit──► resources_changed ──► HUD
                       │
   detection_risk ──emit──► detection_changed ──► PhaseManager
                                                       │ change_phase("active")
                                                       ▼
                                          GameManager ──emit──► phase_changed ──► все системы
```

## Контракт API (для последующих спринтов)

- `ResourceSystem.gain_terror_from(source: String)` — `"sound"|"vision"|"dream"|"altar"`
- `ResourceSystem.gain_biomass_from_body(survival_ratio: float)` — >0.3 даёт биомассу
- `ResourceSystem.try_spend(biomass, terror) -> bool` — атомарная трата (мутации, двери)
- `PhaseManager.trigger_outbreak()` — игрок добровольно активирует Фазу 2
- `PhaseManager.begin_accumulation()` — сброс в Фазу 1 при заходе на этаж
- Сигналы: `PhaseManager.liquidators_alerted`, `PhaseManager.outbreak_started(forced)`

## Баланс (первичные значения, подлежат плейтесту)

| Параметр | Значение | Источник |
|----------|----------|----------|
| Пассивная биомасса | 0.5 /сек | GDD: «генерируется медленно» |
| Пассивный ужас | 0.8 /сек | GDD: фоновые звуки/тени |
| Ужас: звук / видение / сон / алтарь | 3 / 5 / 6 / 10 | середины диапазонов GDD 2.2 |
| Ликвидаторы активны | risk ≥ 0.80 | GDD Фаза 1 |
| Принудительная Фаза 2 | risk ≥ 0.95 | GDD Фаза 2 |

Мультипликаторы `terror_gen_multiplier` / `biomass_gen_multiplier` = 1.0 по
умолчанию; их поднимают ветки развития (Ментальность/Биомасса) в Sprint 5.
