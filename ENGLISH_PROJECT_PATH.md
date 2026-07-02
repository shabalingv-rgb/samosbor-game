# ✅ РЕШЕНИЕ: Папка переименована в English

**Дата:** 2 июля 2026

## Что было сделано

**Проблема:** Кириллица в пути (`/Downloads/самосбор/`) вызывала ошибку "Отсутствующий проект" в Godot.

**Решение:** Папка переименована в **`samosbor`** (английское имя).

```
❌ ~/Downloads/самосбор/godot
✅ ~/Downloads/samosbor/godot
```

---

## Новые команды

### Открыть проект

```bash
# Способ 1: Через alias (обновлён в ~/.zshrc)
godot --editor ~/Downloads/samosbor/godot

# Способ 2: Полный путь
/Applications/Godot_mono.app/Contents/MacOS/Godot --editor ~/Downloads/samosbor/godot

# Способ 3: Просто перейти и открыть
cd ~/Downloads/samosbor/godot
godot --editor
```

### Запустить игру

- Нажмите **F5** в Godot Editor

---

## Проверка

Убедитесь что проект теперь распознаётся:

1. ✅ В Project Manager проект больше НЕ "Отсутствующий"
2. ✅ `scenes/main/game_scene.tscn` открывается нормально
3. ✅ F5 запускает игру, консоль показывает "Game Manager initialized"

---

## Старые ссылки обновлены

Все ссылки в документации и alias переведены на новый путь:
- ✅ ~/.zshrc обновлён
- ✅ git remote работает
- ✅ GitHub синхронизирован

---

**Теперь проект должен открыться нормально! 🎮**
