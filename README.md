# Letra's dotfiles

个人 macOS 终端、Shell（Zsh）与 Vim/Neovim 核心配置仓库，采用定制的 **Everforest Dark（暖金 + 森林绿高亮层次版）** 作为全局主视觉主题。

---

## 1. 主题与配色规范：Everforest Dark (Custom Highlight Edition)

针对终端长文阅读、代码开发以及 AI CLI（如 `agy`、`claude`）的 Markdown 渲染进行了专门的色彩层级调校，在保留 Everforest 经典温润护眼质感的同时，解决了默认配色下重点不突出、标题与正文同色的问题。

### 核心视觉色板

| 视觉层级 | 绑定属性 / ANSI 槽位 | Hex 色值 | 色彩描述与用途 |
| :--- | :--- | :--- | :--- |
| **终端背景** | `Background Color` | `#2d353b` | Everforest Dark Medium 经典深灰绿底色 |
| **Tab / 光标引导** | `Tab Color` / `Cursor Guide` | `#343f44` | 与 Minimal 极简标签栏融为一体的深灰绿 |
| **选区背景** | `Selection Color` | `#3d484d` | 柔和不刺眼的选中高亮底色 |
| **普通正文** | `Foreground` / `Ansi 7` | `#d8caac` | 复古暖麦色 / 羊皮纸色（原版 `#d3c6aa` 微提亮 2%），长文阅读护眼 |
| **标题 & 加粗重点** | `Bold Color` / `Ansi 15` | `#e6c384` | **Everforest 暖金黄高亮**（源自 Yellow `#dbbc7f`），所有 `**加粗重点**` 与 `# 标题` 自动呈现金色高亮 |
| **行内代码 / 标签** | `Ansi 12` (Bright Blue) | `#83c995` | **Everforest 森林翠绿**（源自 Aqua/Green），让 `` `代码标签` `` 清脆醒目 |
| **思考过程 / 注释** | `Ansi 8` (Bright Black) | `#859289` | **Everforest 苔藓灰绿**，用于 AI 思考过程、Shell 自动补全建议与代码注释 |
| **错误 / 警告 / 语法** | `Ansi 1~6` | `#e67e80` / `#a7c080` / `#dbbc7f` / `#7fbbb3` / `#d699b6` / `#83c092` | 原生 Everforest 红、绿、黄、青蓝、紫、湖青 |

### 关键渲染参数

- **字体与排版**：`MapleMono-NF-CN-Regular 16pt`，行距 `Vertical Spacing: 1.15`，开启连字 `ASCII Ligatures: true`
- **对比度与加粗控制**：
  - `Minimum Contrast`: `0`（关闭强制对比度拉白，保持纯正色彩饱和度与暗字/亮字层次感）
  - `Use Bold Color`: `true` & `Use Bright Bold`: `true`
  - `Brighten Bold Text`: `false`（禁止将暖金色加粗文字强行冲白）
  - `Faint Text Alpha`: `0.75`（适度淡化次要过程文本，既能看清又不抢正文焦点）
- **AI CLI 最佳搭配**：
  - 在 `agy` (`~/.gemini/antigravity-cli/settings.json`) 中设置 `"colorScheme": "terminal"`，使其 Markdown 渲染器直接复用上述终端 ANSI 层级。

---

## 2. iTerm2 三层动态配置架构 (`iterm2/DynamicProfiles/`)

采用 iTerm2 的 **Dynamic Profiles** JSON 继承机制，实现「一处修改，全局窗口与热键窗口自动同步」：

```text
Everforest Dark (everforest-dark.json)
  ├─ 负责：基础 16 色调色板、MapleMono 16pt 字体、1.15 行高
  └─ 派生 ➔ Everforest Dark (High Contrast) (everforest-hc.json) [默认 Profile]
              ├─ 负责：#d8caac 暖麦正文、#e6c384 暖金加粗高亮、#83c995 翠绿标签、#859289 灰绿过程字
              └─ 派生 ➔ Hotkey Window (Everforest) (hotkey-window.json)
                          └─ 负责：⇧Space 全局唤出、贴底满宽窗口、30% 透明度 + 毛玻璃模糊
```

- **顶部 Tab 栏美化**：使用 `Minimal` 主题，隐藏 Tab 编号与关闭按钮，Tab 自动铺满整行，与 `#2d353b` / `#343f44` 背景无缝融合。

---

## 3. Zsh 配置 (`zsh/.zshrc`)

- **提示符**：`oh-my-zsh` + `agnoster` 高对比度定制色块，隐藏本机冗余 `user@hostname`。
- **Everforest TrueColor 语法高亮 (`zsh-syntax-highlighting`)**：
  - 命令/别名/内建函数：`#a7c080`（森林绿加粗）
  - 字符串：`#dbbc7f`（暖黄）
  - 参数选项 (`-l` / `--help`)：`#83c092`（青绿）
  - 路径与变量：`#7fbbb3`（青蓝）
  - 分隔符与重定向：`#e69875`（暖橙加粗）
  - 错误命令：`#e67e80`（珊瑚红加粗）
- **自动补全建议 (`zsh-autosuggestions`)**：`fg=#859289`（与终端 `Ansi 8` 苔藓灰绿保持一致）。
- **本地私有配置隔离**：工作环境特有的别名或内网环境变量存放于 `~/.zshrc.local`（由 `.zshrc` 自动加载，不进公开仓库）。

---

## 4. 快速安装 / 同步

```bash
./bootstrap.sh
```

执行后会自动同步：
1. `vim/` ➔ `~/.vim` 与 `~/.config/nvim`
2. `zsh/.zshrc` ➔ `~/.zshrc`
3. `iterm2/DynamicProfiles/*.json` ➔ `~/Library/Application Support/iTerm2/DynamicProfiles/` 并写入 iTerm2 Minimal 外观偏好。
