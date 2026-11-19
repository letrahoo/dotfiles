# Letra's dotfiles

我的 macOS 终端配置：iTerm2、tmux、Zsh 和 Vim/Neovim。配色用 Everforest Dark，字体用 Maple Mono NF CN。

## 安装

```bash
git clone https://github.com/letrahoo/dotfiles.git ~/personal/dotfiles
cd ~/personal/dotfiles
./brew.sh
```

在 iTerm2 中准备一个名为 `Everforest Medium` 的普通 Profile，供热键窗口继承。然后运行：

```bash
./bootstrap.sh
```

`bootstrap.sh` 会把本机的 `.zshrc`、`.tmux.conf` 等配置替换为指向仓库的软链接。已有自己的配置请先备份。工作用的别名和环境变量放在 `~/.zshrc.local`，不进仓库。

## iTerm2

平时用 `Everforest Medium`。按 `Shift+Space` 显示或隐藏 [Hotkey Window (Everforest)](iterm2/DynamicProfiles/hotkey-window.json)：它停在屏幕底部，40 行高。安装脚本只加载这一个热键 Profile，不更改默认 Profile。

如果希望**启动 iTerm2 时也显示同一个热键窗口**，在 Settings → General → Startup 选择 **Only Restore Hotkey Window**，再从仓库根目录运行：

```bash
scripts="$HOME/Library/Application Support/iTerm2/Scripts"
mkdir -p "$scripts"
if [[ ! -e "$scripts/AutoLaunch.scpt" && ! -L "$scripts/AutoLaunch.scpt" ]]; then
  osacompile -o "$scripts/AutoLaunch.scpt" iterm2/reveal-hotkey.applescript
fi
```

如果已有 `AutoLaunch.scpt`，上面的命令不会覆盖它。需要时把[显示热键窗口的逻辑](iterm2/reveal-hotkey.applescript)合入现有脚本。

## tmux

macOS 上由 `launchd` 单独运行 tmux。即使 iTerm2 退出，也可以从另一个终端接回工作区：

```bash
tmux new-session -A -s work
```

如果接不回去，用 `launchctl print "gui/$(id -u)/com.user.tmux"` 检查服务，日志在 `~/Library/Logs/tmux-server.log`。

## 配置文件

- [zsh/](zsh/)：Agnoster 提示符、语法高亮和自动建议。
- [vim/](vim/)：Vim 和 Neovim 共用的编辑器配置。
- [tmux/](tmux/)：快捷键、状态栏和 macOS LaunchAgent。
- [iterm2/](iterm2/)：热键窗口配置、启动脚本和 GoLand 文件跳转。
