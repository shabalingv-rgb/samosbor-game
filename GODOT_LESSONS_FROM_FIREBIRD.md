# Godot 4 уроки из firebird-protocol проекта

**Источник:** Документы из соседнего проекта firebird-protocol  
**Версия:** Godot 4.6.2 Mono

---

## 🏗 Гибридная архитектура (GDScript + C#)

Firebird Protocol использует:
- **GDScript** для UI, сцен, анимаций (быстрая разработка)
- **C#** для бизнес-логики, БД, типизации (надёжность)

Коммуникация: **Сигналы + вызовы методов**

> **Для Samosbor:** Будем использовать **только GDScript** в MVP, но учитываем эту архитектуру на случай расширения.

---

## 📁 Правильная структура проекта

```
projeto/
├── project.godot              # Конфигурация
├── scenes/                    # .tscn файлы (по типам)
│   ├── main/
│   │   └── game_scene.tscn
│   ├── ui/                    # UI компоненты
│   ├── npc/                   # NPC объекты
│   └── effects/               # Визуальные эффекты
├── scripts/                   # .gd файлы
│   ├── managers/              # GameManager, ResourceManager
│   ├── systems/               # VentilationSystem, InfluenceSystem
│   ├── npc/                   # NPC behaviors
│   └── data/                  # Data structures
├── assets/                    # Спрайты, звуки
├── docs/                      # Документация
└── .gitignore
```

**Ключевой момент:** scenes/ и scripts/ разделены по назначению, не по типу.

---

## 🔧 Autoload (Автозагрузка) — ОЧЕНЬ ВАЖНО

В `project.godot → [autoload]` можно определить **глобальные сценарии**, которые загружаются автоматически:

```ini
[autoload]
GameManager="*res://scripts/managers/game_manager.tscn"
ResourceSystem="res://scripts/systems/resource_system.gd"
EventSystem="res://scripts/systems/event_system.gd"
```

**В коде:**
```gdscript
# Доступны везде без импорта
GameManager.change_phase("active")
ResourceSystem.modify_biomass(10)
EventSystem.emit_signal("phase_changed", "active")
```

> **Для Samosbor:** Используем GameManager как autoload для глобального состояния.

---

## 📊 Поток данных (Data Flow)

### Инициализация проекта
```
Godot запускает project.godot
    ↓
Загружаются Autoload скрипты (по порядку в project.godot)
    ↓
_ready() вызывается для каждого autoload
    ↓
Первая сцена загружается (main_scene)
    ↓
_ready() сцены и её детей
```

### Игровой цикл
```
_process(delta) → каждый кадр
    ↓
_physics_process(delta) → каждый физ. кадр
    ↓
Сигналы испускаются при событиях
    ↓
Подключённые функции вызываются
```

> **Gotcha:** `_ready()` не гарантирует загрузку children. Используйте `tree_entered` для безопасности.

---

## 🔴 Типичные ошибки Godot 4

### 1. Сигналы в старом стиле (Godot 3)
```gdscript
# ❌ НЕПРАВИЛЬНО (Godot 3)
object.connect("signal_name", self, "_on_signal")

# ✅ ПРАВИЛЬНО (Godot 4)
object.signal_name.connect(_on_signal)
```

### 2. Yield → Await
```gdscript
# ❌ НЕПРАВИЛЬНО (Godot 3)
yield(get_tree(), "process_frame")

# ✅ ПРАВИЛЬНО (Godot 4)
await get_tree().process_frame
```

### 3. Типизация обязательна в GDScript 4
```gdscript
# ❌ НЕПРАВИЛЬНО (будет warning)
var my_var = 10

# ✅ ПРАВИЛЬНО
var my_var: int = 10
```

### 4. Экспорт переменных
```gdscript
# ❌ НЕПРАВИЛЬНО (Godot 3)
export var health = 100

# ✅ ПРАВИЛЬНО (Godot 4)
@export var health: int = 100
```

### 5. Onready переменные
```gdscript
# ❌ НЕПРАВИЛЬНО (Godot 3)
onready var sprite = $Sprite2D

# ✅ ПРАВИЛЬНО (Godot 4)
@onready var sprite: Sprite2D = $Sprite2D
```

---

## 📋 Конфигурация project.godot

**Минимальный правильный проект.godot:**

```ini
[gd_project]

config_version=5

[application]

config/name="My Game"
run/main_scene="res://scenes/main/game_scene.tscn"
config/features=PackedStringArray("4.6", "Forward Plus")

[physics]

2d_physics/layer_names/physics_layer_1="World"

[debug]

gd_script/warnings/unused_variable=1
gd_script/warnings/unused_argument=1
gd_script/warnings/unreachable_code=1
```

**Важные поля:**
- `config_version=5` — версия конфига (обязательно 5 для 4.x)
- `run/main_scene` — главная сцена (с полным путём и расширением)
- `config/features` — перечислить версию и возможности ("4.6", "Forward Plus")
- `2d_physics/layer_names` — именовать слои физики

---

## 🎯 Best Practices из firebird-protocol

### 1. Сигналы для коммуникации
```gdscript
# Вместо прямых вызовов методов, используйте сигналы
signal phase_changed(new_phase: String)
signal resources_changed(new_biomass: int, new_terror: int)

# Испусти сигнал
phase_changed.emit("active")

# Подключи слушателя
game_manager.phase_changed.connect(_on_phase_changed)
```

### 2. Разделение логики
```gdscript
# ❌ ПЛОХО: Всё в одном скрипте
class_name GameScene
extends Node2D

func _ready():
    # Физика
    # UI
    # Враги
    # Состояние игры

# ✅ ХОРОШО: Разделить на компоненты
class_name GameScene
extends Node2D

@onready var resource_system: ResourceSystem = $ResourceSystem
@onready var npc_manager: NPCManager = $NPCManager
@onready var ventilation_system: VentilationSystem = $VentilationSystem

func _ready():
    pass  # Дети инициализируются сами
```

### 3. Кэширование для производительности
```gdscript
# ❌ ПЛОХО: Ищем узел каждый кадр
func _process(delta):
    var sprite = get_node("Sprite2D")
    sprite.modulate = Color.RED

# ✅ ХОРОШО: Кэшируем в _ready
@onready var sprite: Sprite2D = $Sprite2D

func _process(delta):
    sprite.modulate = Color.RED
```

### 4. Конфигурация в одном месте
```gdscript
# constants.gd
class_name GameConstants

const FLOOR_COUNT: int = 100
const INITIAL_BIOMASS: int = 50
const INITIAL_TERROR: int = 30
const MAX_CULTISTS_PER_FLOOR: int = 3

# Использование
var biomass: int = GameConstants.INITIAL_BIOMASS
```

---

## 🐛 Частые проблемы и решения

| Проблема | Причина | Решение |
|----------|---------|---------|
| Сцена не загружается | `run/main_scene` неправильный путь | Проверить path и расширение .tscn |
| "Nonexistent method" | Метод приватный или класс не наследует Node | Сделать `public` или наследовать Node |
| Сигнал не работает | Старый синтаксис (Godot 3) | Использовать `signal_name.connect()` |
| FPS падает | Слишком много объектов или процессов | Использовать culling, pooling, @onready |
| Ошибка при открытии .tscn | .tscn повреждён | Пересохранить сцену в редакторе |

---

## 🎮 Минимальный рабочий проект

```gdscript
# game_manager.gd
extends Node

var current_floor: int = 1
var phase: String = "accumulation"
var biomass: int = 50
var terror: int = 30

signal phase_changed(new_phase: String)
signal resources_changed

func _ready() -> void:
    print("Game initialized: Floor %d | Phase: %s" % [current_floor, phase])

func change_phase(new_phase: String) -> void:
    if new_phase in ["accumulation", "active"]:
        phase = new_phase
        phase_changed.emit(new_phase)
        print("Phase changed to: %s" % new_phase)

func advance_floor() -> void:
    current_floor += 1
    biomass = 50
    terror = 30
    print("Advanced to floor: %d" % current_floor)
```

```gdscript
# game_scene.gd
extends Node2D

func _ready() -> void:
    # Инициализация
    GameManager.phase_changed.connect(_on_phase_changed)

func _on_phase_changed(new_phase: String) -> void:
    print("UI update: phase is now %s" % new_phase)

func _process(delta: float) -> void:
    # Основной цикл
    pass
```

---

## 📚 Дополнительные ресурсы

- [Godot 4.6 Official Docs](https://docs.godotengine.org/en/stable/)
- [GDScript Language Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html)
- [Godot 4 Migration Guide](https://docs.godotengine.org/en/latest/contributing/development/core_types/migrating_to_godot_4.html)

---

**Обновлено:** 2 июля 2026  
**Версия:** Godot 4.6.2 Mono
