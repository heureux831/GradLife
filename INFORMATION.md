这份文档将作为你开发 **《研究生模拟器 (GradLife: The Thesis)》**（暂定名）的**核心设计圣经**。请保存此内容，后续所有的开发工作都将回溯到这份文档的架构上。

---

# 项目设计文档 (Project Design Document - PDD)

**项目名称：** GradLife (研究生模拟器)
**引擎版本：** Godot 4.5
**核心玩法：** Top-Down 2D 像素风 + 叙事养成 + 时间/资源管理
**类似于：** 《星露谷物语》但把种田换成科研，把战斗换成写论文。

---

## 1. 物理目录结构 (Project Directory Structure)

这是 Godot 编辑器中 `res://` 的标准物理结构。请严格遵守命名规范：**文件夹使用 snake_case (蛇形命名)，场景和类名使用 PascalCase (大驼峰)。**

```text
res://
├── assets/                  # [资源库] 所有的原始美术和音频
│   ├── sprites/             # 精灵图
│   │   ├── characters/      # 玩家与NPC动作表
│   │   ├── environment/     # 地图瓦片 (Tilesets)
│   │   ├── items/           # 物品图标
│   │   └── ui/              # UI 贴图 (边框、按钮)
│   ├── audio/               # 音效与音乐
│   └── fonts/               # 像素字体文件 (.ttf / .otf)
│
├── scenes/                  # [场景库] 所有的 .tscn 文件
│   ├── characters/          # 角色场景 (Player.tscn, NPC_Tutor.tscn)
│   ├── world/               # 地图场景 (Dorm.tscn, Lab.tscn, Canteen.tscn)
│   ├── objects/             # 交互物 (Bed.tscn, Computer.tscn)
│   ├── ui/                  # 界面 (HUD.tscn, DialogBox.tscn, PhoneMenu.tscn)
│   └── main/                # 启动入口 (Main.tscn, TitleScreen.tscn)
│
├── src/                     # [代码库] 所有的 .gd 脚本
│   ├── autoload/            # 全局单例脚本 (TimeSystem.gd, SignalBus.gd)
│   ├── characters/          # 角色逻辑 (Player.gd, NPC.gd, StateMachine.gd)
│   ├── interaction/         # 交互逻辑 (InteractionArea.gd)
│   ├── ui/                  # 界面逻辑
│   └── resources/           # 自定义资源定义 (ItemData.gd, ScheduleData.gd)
│
└── data/                    # [数据中心] 具体的数据资源文件 (.tres)
    ├── dialogs/             # 对话文件 (JSON 或自定义 Resource)
    ├── schedules/           # NPC 行程表
    └── items/               # 道具属性

```

---

## 2. 核心架构与系统 (Core Architecture)

这是游戏的“神经系统”。我们将使用 **Autoload (单例)** 来管理全局状态，使用 **Signal Bus (信号总线)** 来解耦各个模块。

### 2.1 全局单例 (Autoloads)

在 `Project Settings -> Globals` 中注册以下脚本：

1. **`TimeSystem` (TimeSystem.gd)**
* **职责：** 管理游戏时间流逝。
* **核心变量：** `current_day`, `current_hour`, `current_minute`, `game_speed`.
* **逻辑：** 现实 1 秒 = 游戏 1 分钟。
* **信号：** `time_tick`, `hour_changed`, `day_started`, `day_ended`.


2. **`PlayerStats` (PlayerStats.gd)**
* **职责：** 管理玩家核心数值（RPG 属性）。
* **核心变量：**
* `energy` (精力): 移动、工作消耗。归零昏厥。
* `sanity` (San值/心情): 压力过大会导致无法工作或触发负面事件。
* `thesis_progress` (论文进度): 游戏通关核心指标 (0-100%)。
* `knowledge` (学识): 用于解锁更高级的论文章节。


* **方法：** `change_energy(amount)`, `check_game_over()`.


3. **`GlobalSignals` (GlobalSignals.gd)**
* **职责：** 全局事件中心。任何脚本都可以发射信号，任何脚本都可以接收。
* **常用信号：** `dialog_requested(dialog_id)`, `minigame_started`, `scene_change_requested`.



### 2.2 交互系统 (Interaction System)

这是游戏玩法的核心。

* **设计模式：** 接口/继承模式。
* **基础类 `InteractableObject` (class_name):** 所有可交互物体（床、电脑、NPC）都继承或附加此脚本。
* **核心方法 `interact(player_ref)`:** 当玩家按下 E 键时调用。
* **实现：**
* `Bed` -> `interact()` -> 触发“睡觉确认”UI -> 调用 `TimeSystem.skip_to_next_day()`.
* `Computer` -> `interact()` -> 暂停世界 -> 打开“科研小游戏”UI.
* `NPC` -> `interact()` -> 暂停世界 -> 打开“对话框”UI.



---

## 3. 游戏核心循环 (Gameplay Loop)

### 3.1 宏观循环 (Macro Loop - 一天)

1. **早晨 (8:00):** 在宿舍醒来，精力回满（或根据昨晚睡眠质量决定）。
2. **规划:** 查看手机/日程表，决定今天去哪里（实验室/图书馆/上课）。
3. **行动:** 移动到目标地点，消耗现实时间。
4. **工作/社交:** 进行交互，消耗 `Energy` 和游戏时间，获得 `Thesis_Progress` 或 `Knowledge`。
5. **晚上:**
* **自由时间:** 玩游戏、夜宵（恢复 San 值，消耗金钱）。
* **DDL 赶工:** 强行消耗 San 值换取论文进度（高风险）。


6. **睡觉:** 必须在 2:00 AM 前上床，否则次日会有惩罚。

### 3.2 微观循环 (Micro Loop - 科研工作)

这不是简单的点击，而是将“工作”具象化为小游戏或决策：

1. **阅读文献 (获取 Knowledge):**
* *形式：* 简单的卡牌配对或记忆小游戏。
* *消耗：* -20 精力, +2 小时。
* *产出：* +5 学识点。


2. **写代码/跑实验 (获取 Progress):**
* *形式：* 进度条 QTE (Quick Time Event) 或接水管小游戏（模拟连接电路/逻辑）。
* *风险：* 有概率出现 "Bug" (进度回退) 或 "Error" (San 值大跌)。


3. **组会 (Boss Fight):**
* *形式：* 纯对话选择题。导师提问，根据你的 `Knowledge` 储备选择回答。
* *结果：* 回答正确增加导师好感度，回答错误扣除大量 San 值。



---

## 4. NPC 行为系统 (NPC Scheduler)

NPC 不会像柱子一样站着，他们有生活规律。

* **数据结构 (Resource):** `NPCSchedule`
```gdscript
{
  "default": {
    "8:00": {"scene": "Canteen", "pos": Vector2(100, 200)},
    "9:00": {"scene": "Lab", "pos": Vector2(500, 300)},
    "18:00": {"scene": "Dorm", "pos": Vector2(0, 0)} # 回家消失
  },
  "Wednesday": { ... } # 组会日特殊安排
}

```


* **导航:** 使用 Godot 的 `NavigationRegion2D` (画地图导航网格) 和 `NavigationAgent2D` (NPC身上的寻路组件)。
* **逻辑:** `TimeSystem` 发出 `hour_changed` 信号 -> NPC 检查日程表 -> 若当前位置与日程不符 -> 开启寻路走向新目标。

---

## 5. UI/UX 规划

* **HUD (抬头显示):** 常驻屏幕。
* 左上角：时间 (时钟图标)、日期 (第W周/星期X)。
* 右上角：精力条 (绿色)、San值条 (紫色)。
* 左下角：手机图标 (菜单入口)。


* **对话框 (Dialogue Box):**
* 显示 NPC 头像、名字、打字机效果的文本。
* 支持选项 (A/B)，选项会触发不同的回调函数。


* **手机界面 (Smartphone UI):**
* App 风格的菜单：
* "微信/WeChat": 查看 NPC 消息。
* "备忘录": 查看当前任务目标。
* "支付宝": 查看余额（用于买饭、买咖啡）。



---

## 6. 开发路线图 (Roadmap)

按照此顺序开发，确保每一步都能运行。

**Phase 1: 原型搭建 (The Prototype)**

* [ ] 建立文件夹结构。
* [ ] 制作 `Player`，实现 top-down 8方向移动。
* [ ] 制作简单的 `TileMap` 房间（宿舍），设置碰撞和 Y-Sort。
* [ ] 实现 `Interactable` 基础类，放一个测试物体（打印 "Hello"）。

**Phase 2: 核心数值与时间 (Systems)**

* [ ] 编写 `TimeSystem`，在 UI 上显示时间跳动。
* [ ] 编写 `PlayerStats`，并在 UI 上显示精力条。
* [ ] 实现：按 E 睡觉 -> 时间变第二天 -> 精力回满。

**Phase 3: 场景切换与数据 (World)**

* [ ] 制作两个场景：宿舍、实验室。
* [ ] 实现“传送门”：走到门口切换场景。
* [ ] 实现简单的“电脑工作”：交互后精力减少，论文进度增加。

**Phase 4: NPC 与 叙事 (Life)**

* [ ] 制作 NPC 预制体。
* [ ] 引入对话系统（可以使用插件如 Dialogue Manager，或手写简单的 JSON 解析）。
* [ ] 实现 NPC 简单的日程移动。

---