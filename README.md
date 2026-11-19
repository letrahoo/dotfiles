# Letra's dotfiles

个人 macOS 终端、Shell（Zsh / Oh My Zsh）与 Vim/Neovim 核心配置仓库，采用定制的 **Everforest Dark（暖金 + 森林绿高亮层次版）** 作为全局主视觉主题，并通过**软链接（Symlink）**与本机配置实时同步。

- **本机常驻路径**：`~/personal/dotfiles`

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

## 2. iTerm2 普通窗口与热键窗口

- `Everforest Medium`：用户在 iTerm2 中维护的普通 Profile。新机器上请先准备这个父 Profile；bootstrap 不创建普通 Profile，也不更改默认 Profile。
- `Hotkey Window (Everforest)`：唯一由 bootstrap 安装的动态 Profile。`⇧Space` 唤起专用窗口，贴底满宽、40 行、不透明、关闭状态栏。旧 Dark / High Contrast JSON 只是模板，不再自动加载。

**可选：让冷启动和快捷键复用同一窗口。** 在 iTerm2 的 Settings → General → Startup 选择 “Only Restore Hotkey Window”。从仓库根目录执行以下命令安装启动脚本；如果已有 `AutoLaunch.scpt`，保留原文件，手动整合 [reveal-hotkey.applescript](iterm2/reveal-hotkey.applescript) 的逻辑：

```bash
scripts="$HOME/Library/Application Support/iTerm2/Scripts"
mkdir -p "$scripts"
if [[ ! -e "$scripts/AutoLaunch.scpt" && ! -L "$scripts/AutoLaunch.scpt" ]]; then
  osacompile -o "$scripts/AutoLaunch.scpt" iterm2/reveal-hotkey.applescript
fi
```

- **顶部 Tab 栏美化**：使用 `Minimal` 主题，隐藏 Tab 编号与关闭按钮，Tab 自动铺满整行，与 `#2d353b` / `#343f44` 背景无缝融合。

---

## 3. Zsh 与 Oh My Zsh 配置 (`zsh/`)

- **提示符**：`oh-my-zsh` + `agnoster` 高对比度定制色块，隐藏本机冗余 `user@hostname`。
- **外部插件（由 `bootstrap.sh` 自动检测拉取）**：
  - `zsh-users/zsh-syntax-highlighting`（Everforest TrueColor 语法高亮）
  - `zsh-users/zsh-autosuggestions`（`fg=#859289` 苔藓灰绿自动补全建议）
- **本地私有配置隔离**：工作环境特有的别名或内网环境变量存放于 `~/.zshrc.local`（由 `.zshrc` 自动加载，不进公开仓库）。

---

## 4. Tmux 独立守护架构与配置 (`tmux/`)

为解决 macOS 上在 iTerm2 内首次拉起 `tmux` 时，`tmux: server` 归属于 iTerm2 的 `launchd` Application Coalition（导致强杀/崩溃 iTerm2 时 `tmux: server` 被系统连坐发送 `SIGKILL` 清场）的问题，采用 **`LaunchAgent` 独立托管架构**，使 `tmux` 与 iTerm2 成为完全平级的系统进程。

### 前置要求
- **系统环境**：macOS `launchd` 用户桌面域（`Aqua` 会话，保留 `pbcopy`/`pbpaste` 剪贴板、Keychain 与 `SSH_AUTH_SOCK` 访问权限）
- **软件包依赖**：`tmux >= 3.2`（依赖原生的 `-D` 前台非 daemon 模式，配合 `set -s exit-empty off` 与 `KeepAlive` 实现常驻保活，由 `./brew.sh` 自动安装）

### 零硬编码与环境变量动态解析
由于 `launchd` 原生 XML 不展开 `$HOME` 等变量，采用 **双 `exec` 原地替换链路** 彻底消除用户名与芯片架构绝对路径硬编码，跨 Apple Silicon / Intel Mac 开箱复用：

```text
launchd (com.user.tmux, ProcessType=Interactive)
  └─ /bin/sh -c 'HOME="${HOME:-$(echo ~)}"; export HOME; exec "$HOME/.local/bin/tmux-server"'
       └─ tmux-server.sh (动态探测 Homebrew/本地 PATH，最终 exec tmux -D 无多余父进程残留)
```

可通过可选的 `~/.config/tmux/env`（不入公开仓库）注入环境变量覆盖默认行为：
- `TMUX_BIN`：指定自定义的 `tmux` 二进制路径（默认通过 `command -v tmux` 动态查找）
- `TMUX_LOG_DIR` / `TMUX_LOG_FILE`：自定义守护日志路径（默认 `$HOME/Library/Logs/tmux-server.log`）

### 常用状态检查命令
```bash
# 查看独立守护服务运行状态、PID 及独立 Coalition 归属
launchctl print "gui/$(id -u)/com.user.tmux"
```

---

## 5. 新 Mac 一键初始化 & 日常软链同步

```bash
git clone git@github.com:letrahoo/dotfiles.git ~/personal/dotfiles
cd ~/personal/dotfiles

# 1. 安装 Homebrew 基础工具与 MapleMono-NF-CN 终端字体（幂等跳过已安装项）
./brew.sh

# 2. 自动安装 Oh My Zsh + 插件，将配置以软链接（ln -sfn）挂载到本机，并注册 Tmux 独立守护服务
./bootstrap.sh
```

`./bootstrap.sh` 建立的软链接映射：
1. `zsh/.zshrc` ➔ `~/.zshrc`，`zsh/.zprofile` ➔ `~/.zprofile`
2. `tmux/.tmux.conf` ➔ `~/.tmux.conf`，`tmux/tmux-server.sh` ➔ `~/.local/bin/tmux-server`，`tmux/com.user.tmux.plist` ➔ `~/Library/LaunchAgents/com.user.tmux.plist`
3. `vim/*` ➔ `~/.config/nvim/*` 与 `~/.vim/*`（完整保留本机已安装的 `plugged/` 插件目录与 `undodir/` 撤销历史），`vim/vimrc` ➔ `~/.vimrc`
4. 仅将 `iterm2/DynamicProfiles/hotkey-window.json` 链接到 iTerm2 的 `DynamicProfiles/`，保留用户自建 Profile；将 `iterm2/open-in-goland.sh` 链接到 `~/.local/bin/open-in-goland`，并写入 Minimal 外观偏好。
