# DEVELOPMENT_PLAN V2: Самосбор (с AI моделями)

**Обновлено:** Интегрирует GDD + видение игрока + AI рекомендации

---

## 0. AI Model Recommendations

### Модели и их роли

**Claude Opus 4.8** (самая мощная, используется для):
- Архитектурные решения (основные системы)
- Code review и рефакторинг
- Интеграция сложных систем (вентиляция + ресурсы + враги)
- Написание наиболее критичного кода

**Claude Sonnet 5** (универсальная, используется для):
- Основную разработку функций
- Написание скриптов NPC AI
- Процедурную генерацию (с проверкой Opus)
- UI/UX логика

**Claude Haiku 4.5** (быстрая, используется для):
- Быстрые правки и баги
- Небольшие скрипты (эффекты, анимации)
- Документация
- Подготовка кода перед Opus review

---

## 1. Спринт 0: Инициализация проекта (0.5-1 неделя)

**Цель:** Setup Godot MVP + базовая структура проекта

### 1.1 Godot Setup

**AI: Haiku** (быстрая подготовка)

- [ ] Загрузить Godot 4.1+ (скопировать из ~/Downloads/firebird-protocol-main0.1)
- [ ] Инициировать новый проект `/godot/` в корне самосбора
- [ ] Настроить project.godot:
  - Отключить 3D (save memory)
  - Canvas stretch mode: fit
  - Physics: 2D only
- [ ] Структура папок (scenes/, scripts/, assets/)
- [ ] Первая сцена: `scenes/main/game_scene.tscn` (Node2D root)

### 1.2 Git Setup

**AI: Haiku**

- [ ] Добавить .gitignore (Godot 4 standard)
- [ ] Создать branches: `main`, `dev`, `feature/base-systems`
- [ ] Коммит: "Godot project initialization"

### 1.3 Documentation Setup

**AI: Haiku**

- [ ] Обновить README.md с базовой информацией
- [ ] Создать SETUP.md (как запустить проект, требования)
- [ ] GitHub Actions: простой CI для проверки синтаксиса

**Time estimate:** 3-4 часа (с учетом Godot)

---

## 2. Спринт 1: Base Systems (1-2 недели)

**Цель:** Основные системы игры работают (ресурсы, фазы, базовый UI)

### 2.1 Resource & Phase System

**AI: Opus** (архитектура), **Sonnet** (реализация)

**game_manager.gd:**
```gdscript
extends Node

var current_floor: int = 1
var phase: String = "accumulation"  # или "active"
var biomass: int = 50
var terror: int = 30
var detection_risk: float = 0.0

signal phase_changed(new_phase: String)
signal resources_changed
signal detection_changed(risk: float)
```

**resource_system.gd:**
- Генерация биомассы (от контактов с телами)
- Генерация страха (от звуков, видений, слизи)
- Трата ресурсов (мутации, структуры)

**phase_manager.gd:**
- Переключение между фазами
- Триггеры обнаружения (>80% risk = ликвидаторы активны)
- Таймеры для каждой фазы

**Tasks:**
- [ ] Opus: Архитектурное обсуждение системы ресурсов
- [ ] Sonnet: Реализация ResourceSystem.gd
- [ ] Sonnet: Реализация PhaseManager.gd
- [ ] Opus: Code review (критичность высокая)

**Time:** 4-6 часов

### 2.2 Basic Visualization (Side-View Floor)

**AI: Sonnet** (реализация), **Haiku** (эффекты)

**флор_section.tscn:**
- Одна сторона блока (коридор + 3-4 комнаты)
- Простые grey/beige прямоугольники (placeholder)
- TileMap или Node2D вручную

**Вентиляция:**
- Вертикальная магистраль (центр экрана)
- Две боковые магистрали (под потолком/полом)
- Простые линии (пока не анимировано)

**Tasks:**
- [ ] Sonnet: Создать floor_section.tscn (простая архитектура)
- [ ] Sonnet: Вентиляция как Node2D (линии)
- [ ] Haiku: Placeholder спрайты (серые блоки)

**Time:** 3-4 часа

### 2.3 Basic UI

**AI: Haiku** (UI), **Sonnet** (интеграция)

**HUD:**
- Биомасса (число + бар)
- Страх (число + бар)
- Риск обнаружения (%)
- Текущая фаза (текст)

**Minimal aesthetic:** Как почерк на полях обоев (шрифты, цвета)

**Tasks:**
- [ ] Haiku: Создать hud.tscn (простые Label/ProgressBar)
- [ ] Sonnet: Подключить к game_manager (обновление при изменении ресурсов)

**Time:** 2-3 часа

**Total Sprint 1:** ~10-15 часов

---

## 3. Спринт 2: NPC & Enemy Basics (1.5-2 недели)

**Цель:** Гражданские и враги ходят/реагируют на события

### 3.1 NPC System

**AI: Opus** (архитектура AI), **Sonnet** (реализация)

**civilian.gd (базовый NPC):**
```gdscript
extends CharacterBody2D

var will_power: float = randf_range(0.2, 0.9)  # 0.2=слаб, 0.9=сильный
var emotion: float = 0.5  # 0=спокоен, 1.0=паника
var is_cultist: bool = false
var home_position: Vector2
var current_target: Vector2

func _physics_process(delta: float):
    # Простое A* к целям (дома, столовая, убежище)
    # Реакция на ужас (если страх >70, бежит в герметичную комнату)
    pass

func apply_terror(amount: float):
    emotion += amount
    if emotion > 0.7 and will_power < 0.5:
        become_cultist()  # Слабая воля → культист
```

**Tasks:**
- [ ] Opus: Архитектура поведенческой иерархии (idle → panic → cultist → dead)
- [ ] Sonnet: civilian.gd с базовым AI (движение, эмоция)
- [ ] Sonnet: Простая анимация (walking, standing, panicking)

**Time:** 6-8 часов

### 3.2 Commandant System

**AI: Sonnet**

**commandant.gd:**
- Три типа (Параноик, Коррупционер, Рационализатор)
- Простые реакции (если ужас >50, Параноик запускает сирену)

**Tasks:**
- [ ] Sonnet: commandant.gd (три типа, простые триггеры)
- [ ] Haiku: Placeholder спрайт (жёлтый силуэт)

**Time:** 3-4 часа

### 3.3 Liquidator Basics

**AI: Sonnet**

**liquidator.gd:**
- Только в Phase 2
- Простая патрульная система (ходит по коридору)
- Спавнится при detection_risk >95%

**Tasks:**
- [ ] Sonnet: Базовая система патрулей (waypoint-based)
- [ ] Haiku: Placeholder спрайт (оранжевый)

**Time:** 2-3 часа

**Total Sprint 2:** ~15-18 часов

---

## 4. Спринт 3: Ventilation & Infection System (1.5 недели)

**Цель:** Вентиляция распространяет влияние, люди заражаются

### 4.1 Ventilation Propagation

**AI: Opus** (алгоритм), **Sonnet** (реализация)

**ventilation_system.gd:**
- Сегменты вентиляции (главная → боковые → комнаты)
- Распространение фиолетового цвета (visual feedback)
- Сопротивление каждого сегмента (чистая = низко, фильтр = среднее, герметичный = высоко)

```gdscript
func spread_influence(source_segment: String, amount: float):
    # Алгоритм распространения от логова
    # Чем дальше от логова, тем слабее (логистическое истощение)
    pass
```

**Tasks:**
- [ ] Opus: Алгоритм распространения + баланс сопротивления
- [ ] Sonnet: ventilation_system.gd (логика распространения)
- [ ] Sonnet: Анимация фиолетовых сегментов (заполнение)

**Time:** 6-8 часов

### 4.2 Infection & Mutation

**AI: Sonnet**

**infection_system.gd:**
- Люди в заполненной вентиляции получают Ужас
- Вероятность мутации (зависит от contact_time + terror_level)
- Три уровня мутации (лёгкая, средняя, тяжёлая)

**Tasks:**
- [ ] Sonnet: Система заражения
- [ ] Haiku: Визуальные изменения спрайтов (цвет, форма)

**Time:** 4-5 часов

**Total Sprint 3:** ~10-13 часов

---

## 5. Спринт 4: Cultist & Behavioral Trees (1.5 недели)

**Цель:** Культисты работают, враги реагируют правильно

### 4.1 Cultist System

**AI: Sonnet**

**cultist.gd (специфика для культистов):**
- Открывание дверей для Самосбора
- Поклонение биомассе (стояние рядом с алтарями)
- Попытка убедить других присоединиться (увеличение Ужаса у соседей)
- Максимум 3 на этаж

**Tasks:**
- [ ] Sonnet: cultist.gd (поведение)
- [ ] Sonnet: Открывание дверей (механика)
- [ ] Haiku: Анимация поклонения

**Time:** 4-5 часов

### 4.2 Behavioral Trees for Commandants & Liquidators

**AI: Opus** (архитектура), **Sonnet** (реализация)

**behavior_tree.gd (база для врагов):**
```
Commandant (Selection):
  ├─ If emotion > 0.7: Trigger siren
  ├─ Elif emotion > 0.5: Call reinforcements
  └─ Else: Patrol
```

**Tasks:**
- [ ] Opus: Архитектура BT для врагов
- [ ] Sonnet: behavior_tree.gd (простая реализация)
- [ ] Sonnet: Подключить к commandant.gd и liquidator.gd

**Time:** 6-8 часов

**Total Sprint 4:** ~10-13 часов

---

## 6. Спринт 5: Mutation Trees & Progression (2 недели)

**Цель:** Три дерева развития работают, игрок может улучшаться

### 6.1 Skill/Mutation Trees

**AI: Opus** (баланс), **Sonnet** (реализация)

**mutation_tree.gd:**
- Три ветви (Ментальность, Биомасса, Развитие)
- Стоимость в ресурсах (Биомасса + Ужас)
- Бонусы к механикам (например, "Психический резонанс" = +20% генерации Ужаса)

**Tasks:**
- [ ] Opus: Баланс стоимостей и бонусов
- [ ] Sonnet: mutation_tree.gd (логика улучшений)
- [ ] Sonnet: Интеграция с resource_system.gd
- [ ] Haiku: UI для дерева (как изорванные обои)

**Time:** 8-10 часов

### 6.2 Mutation Effects

**AI: Sonnet**

**mutations/** (папка):
- `psychic_resonance.gd` (увеличивает Terror generation)
- `biomass_eruption.gd` (создаёт мясные наросты)
- `nest_protection.gd` (защита логова)
- и т.д.

**Tasks:**
- [ ] Sonnet: Реализация каждой мутации (как применить эффект)
- [ ] Haiku: Визуальные эффекты (частицы, анимации)

**Time:** 8-10 часов

**Total Sprint 5:** ~16-20 часов

---

## 7. Спринт 6: Procedural Generation (2 недели)

**Цель:** Этажи генерируются разнообразно, враги распределяются правильно

### 7.1 Floor Generation

**AI: Opus** (алгоритм), **Sonnet** (реализация)

**floor_generator.gd:**
- Выбрать тип этажа (жилой, производство, казармы, лаборатория, хранилище)
- Расставить комнаты (3-6 на сторону)
- Создать коридор
- Заполнить NPC

```gdscript
func generate_floor(floor_number: int, difficulty: float) -> Dictionary:
    var floor_type = choose_type(floor_number)  # Эволюция типов
    var layout = create_layout(floor_type)
    populate_npcs(layout, difficulty)
    return floor_data
```

**Tasks:**
- [ ] Opus: Алгоритм генерации (как выбирать типы на основе номера)
- [ ] Sonnet: floor_generator.gd
- [ ] Sonnet: module_placer.gd (расставлять комнаты)

**Time:** 8-10 часов

### 7.2 NPC Spawning & Commandant Assignment

**AI: Sonnet**

**population_spawner.gd:**
- Количество NPC зависит от типа этажа
- Распределение по ролям (10% слабая воля → потенциальные культисты)
- Случайный Коммендант назначается

**Tasks:**
- [ ] Sonnet: population_spawner.gd
- [ ] Sonnet: Убедиться, что разнообразие NPC работает

**Time:** 4-5 часов

**Total Sprint 6:** ~12-15 часов

---

## 8. Спринт 7: Full Phase 1 Cycle (1.5 недели)

**Цель:** Полная Фаза 1 (скрытое накопление) работает от начала до конца

### Tasks

- [ ] **Opus:** Интеграция всех систем (архитектурный обзор)
- [ ] **Sonnet:** Тестирование full cycle (накопление → detection → Phase 2 trigger)
- [ ] **Haiku:** Баги и мелкие правки
- [ ] **Sonnet:** Баланс (ресурсы генерируются слишком быстро/медленно?)
- [ ] **Opus:** Code review перед переходом на Phase 2

**Time estimate:** ~12-15 часов

---

## 9. Спринт 8: Phase 2 & Combat (2 недели)

**Цель:** Active Outbreak фаза полностью работает

### Tasks

- [ ] **Sonnet:** Активация Phase 2 (сирена, гермозатворы)
- [ ] **Sonnet:** Spawn mutations (боевые мутанты)
- [ ] **Opus:** Балансировка (Ликвидаторы не слишком сильные?)
- [ ] **Haiku:** Визуальные эффекты (газ, мясные стены, кровь)
- [ ] **Sonnet:** Логика победы/проигрыша этажа

**Time estimate:** ~15-18 часов

---

## 10. Спринт 9: Procedural Polish & Narrative Events (1.5-2 недели)

**Цель:** Событийная система работает, нарратив начинает появляться

### Tasks

- [ ] **Sonnet:** event_system.gd (ключевые события на этажах 10, 20, 30…)
- [ ] **Opus:** Написание событий (сценарии для встреч персонажей)
- [ ] **Sonnet:** Записки и документы (как их находит игрок)
- [ ] **Haiku:** Визуальная интеграция (UI для диалогов, записок)

**Time estimate:** ~10-15 часов

---

## 11. Спринт 10+: Polishing, Testing, Content

**Цель:** Игра готова к публикации (или долгоживущей альфе)

### Final Tasks

- [ ] **Opus:** Финальная архитектурная review
- [ ] **Sonnet:** Баланс и тестирование всех механик
- [ ] **Haiku:** Баги, оптимизация производительности
- [ ] Звук и музыка (опционально: Haiku может помочь с простыми эффектами)
- [ ] Создание скриншотов для README и соцсетей

**Time estimate:** Open-ended (зависит от качества)

---

## Development Estimates

| Спринт | Название | Часы | Неделя | Модели |
|--------|----------|------|--------|--------|
| 0 | Инициализация | 3-4 | 0.5-1 | Haiku |
| 1 | Base Systems | 10-15 | 1-2 | Opus, Sonnet, Haiku |
| 2 | NPC & Enemy | 15-18 | 1.5-2 | Opus, Sonnet, Haiku |
| 3 | Ventilation | 10-13 | 1.5 | Opus, Sonnet, Haiku |
| 4 | Cultist & BT | 10-13 | 1.5 | Opus, Sonnet, Haiku |
| 5 | Mutations | 16-20 | 2 | Opus, Sonnet, Haiku |
| 6 | Gen & Spawn | 12-15 | 1.5-2 | Opus, Sonnet, Haiku |
| 7 | Phase 1 Full | 12-15 | 1.5 | Opus, Sonnet, Haiku |
| 8 | Phase 2 & Combat | 15-18 | 2 | Opus, Sonnet, Haiku |
| 9 | Polish & Events | 10-15 | 1.5-2 | Opus, Sonnet, Haiku |
| **Total MVP** | | **110-150** | **12-17 нед** | |

**Очка:** При 10 часов в неделю = ~3-4 месяца до playable MVP.

---

## Recommended Workflow

### Per Commit

1. **Haiku:** Быстрая реализация (skeleton code, placeholder)
2. **Sonnet:** Полная реализация + интеграция
3. **Opus:** Code review + архитектурные заметки
4. **Haiku:** Финальные правки + сборка

### Per Sprint

1. **Opus:** Архитектурное планирование спринта
2. **Sonnet:** Основная разработка
3. **Opus:** Code review перед завершением спринта
4. **Haiku:** Баги и мелкие оптимизации

---

## Key Milestones

- ✅ **Sprint 0:** Godot работает
- ✅ **Sprint 1:** Основные системы на месте
- ✅ **Sprint 3:** Визуальный feedback (вентиляция, Ужас)
- ✅ **Sprint 7:** Фаза 1 полностью играбельна
- ✅ **Sprint 8:** Фаза 2 работает (победа/проигрыш)
- ✅ **Sprint 10:** Готово к альфа-тесту

---

**Документ обновлён:** 2 июля 2026  
**Статус:** Готово к началу спринта 0
