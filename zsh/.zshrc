# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)
# OPENSPEC:END

typeset -U path
path=("$HOME/.local/bin" "$HOME/go/bin" $path)
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
export EDITOR=nvim
export VISUAL=nvim

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ------------------------------------------------------------------------------
# 主题与 Agnoster 高对比度配色优化 (兼容亮色与暗色终端背景)
# ------------------------------------------------------------------------------
ZSH_THEME="agnoster"

# 隐藏冗余的本机 user@hostname 前缀（仅在 SSH 或 root 时显示），让提示符更清爽
DEFAULT_USER="$USER"

# 彻底解决默认 blue底black字、black底default字 对比度极低的问题
# 使用高对比度 256 色块，无论终端是深色还是浅色背景都清晰醒目：
AGNOSTER_CONTEXT_BG=236          # user@host 背景：深炭灰
AGNOSTER_CONTEXT_FG=255          # user@host 文字：亮白
AGNOSTER_DIR_BG=25               # 目录背景：深海蓝 (#005faf)
AGNOSTER_DIR_FG=255              # 目录文字：亮白 (#eeeeee)
AGNOSTER_GIT_CLEAN_BG=28         # Git 干净背景：森林绿 (#008700)
AGNOSTER_GIT_CLEAN_FG=255        # Git 干净文字：亮白
AGNOSTER_GIT_DIRTY_BG=214        # Git 修改背景：琥珀橙黄 (#ffaf00)
AGNOSTER_GIT_DIRTY_FG=16         # Git 修改文字：纯黑 (#000000)
AGNOSTER_VENV_BG=91              # 虚拟环境背景：深紫 (#8700af)
AGNOSTER_VENV_FG=255             # 虚拟环境文字：亮白
AGNOSTER_STATUS_BG=236           # 状态块背景：深炭灰
AGNOSTER_STATUS_FG=255           # 状态块文字：亮白
AGNOSTER_STATUS_RETVAL_FG=196    # 错误状态符号：亮红
AGNOSTER_STATUS_ROOT_FG=220      # Root 状态符号：亮金黄
AGNOSTER_STATUS_JOB_FG=51        # 后台任务符号：亮青

if command -v fortune >/dev/null 2>&1; then
  fortune
fi

# ------------------------------------------------------------------------------
# 插件配置
# ------------------------------------------------------------------------------
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump"
mkdir -p "$HOME/.cache/zsh"
source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------------------------
# 颜色与视觉可读性增强 (Syntax Highlighting / Autosuggestions / LS / 补全)
# ------------------------------------------------------------------------------

# 1. 自动补全建议 (zsh-autosuggestions)
# 适配 Everforest Dark 深色背景：中性灰，与正文区分又不至于看不清
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#859289"

# 2. 语法高亮 (zsh-syntax-highlighting)
# 采用 Everforest 调色板 (truecolor)，在深色背景 #2d353b 上保持足够对比度
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e67e80,bold'                # 错误命令：红色加粗
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#d699b6,bold'                # 保留字 (if/for/while)：紫色加粗
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a7c080,bold'                        # 别名：绿色加粗
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a7c080,underline'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#83c092,bold'                 # 全局别名：青色加粗
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a7c080,bold'                      # 内建命令：绿色加粗
ZSH_HIGHLIGHT_STYLES[function]='fg=#a7c080,bold'                     # 函数：绿色加粗
ZSH_HIGHLIGHT_STYLES[command]='fg=#a7c080,bold'                      # 外部命令：绿色加粗
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a7c080,underline'              # sudo/env 等前置命令：绿色下划线
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#e69875,bold'             # 分隔符 (;|&&)：橙色加粗
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#7fbbb3,underline'           # 自动目录：蓝色下划线
ZSH_HIGHLIGHT_STYLES[path]='fg=#7fbbb3,underline'                    # 路径：蓝色下划线
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#d699b6,bold'                     # 通配符 (*, ?)：紫色加粗
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#d699b6,bold'            # 历史展开 (!)：紫色加粗
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#e69875,bold' # $() 分隔符：橙色加粗
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#e69875,bold'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#e69875,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#83c092'              # 单横线参数 (-l)：青色
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#83c092'              # 双横线参数 (--help)：青色
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#dbbc7f'            # 单引号字符串：黄色
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#dbbc7f'            # 双引号字符串：黄色
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#dbbc7f'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#83c092'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#7fbbb3,bold' # 双引号内变量 ($VAR)：蓝色加粗
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#7fbbb3,bold'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#7fbbb3,bold'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#7fbbb3'                            # 变量赋值 (A=B)：蓝色
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#e69875,bold'                  # 重定向 (>, 2>&1)：橙色加粗
ZSH_HIGHLIGHT_STYLES[comment]='fg=#859289,italic'                    # 注释 (#...)：灰色斜体
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#a7c080,bold'                         # 有效命令：绿色加粗

# 3. ls 与 Tab 补全列表颜色优化
# macOS BSD ls: 目录用蓝色加粗(Ex)，跟随终端 ANSI 调色板 (Everforest 下为柔和蓝)
export LSCOLORS="Exfxcxdxbxegedabagacad"
# GNU ls / Zsh Tab 补全菜单颜色：目录深蓝加粗、软链紫红、可执行文件深绿加粗
export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ------------------------------------------------------------------------------
# 个人别名与工具初始化
# ------------------------------------------------------------------------------
dev() {
  cd "$HOME/work/${1:-}"
}

# Directory tree view
alias tv="tree -C -L 2 ./"

# Get disk usage
alias disk="du -h -d 1"

# Get External IP / Internet Speed
alias myip="curl https://ipinfo.io/json"

# Quickly serve the current directory as HTTP
alias serve='python3 -m http.server 8000'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
[[ -f /opt/homebrew/etc/profile.d/autojump.sh ]] && source /opt/homebrew/etc/profile.d/autojump.sh

export npm_config_cache="$HOME/.cache/npm"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  ":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Java & Android SDK
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/build-tools/37.0.0:$ANDROID_HOME/platform-tools:$PATH"

# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# Load local/work overrides (untracked in public dotfiles)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
