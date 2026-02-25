# Zhipu Web Search Skill

智谱 AI 联网搜索技能，为 AI 编码助手提供实时网络搜索能力。

## 功能特点

- 🌐 **实时网络搜索** - 获取最新新闻、技术动态和实时信息
- 🔍 **中英文支持** - 同时支持中文和英文搜索
- 🤖 **多客户端支持** - 兼容 Claude Code、OpenClaw、Cline 等 AI 编码助手
- ⚡ **轻量级** - 基于 Python + curl，无复杂依赖
- 📦 **一键安装** - 提供自动化安装脚本

## 快速安装

### 方法一：一键安装（推荐）

```bash
# 克隆仓库并安装到 Claude Code
git clone https://github.com/davisjiahao/myskills.git && cd myskills && ./install.sh --claude

# 或者安装到所有支持的客户端
git clone https://github.com/davisjiahao/myskills.git && cd myskills && ./install.sh --all
```

### 方法二：手动安装

```bash
# 克隆仓库
git clone https://github.com/davisjiahao/myskills.git
cd myskills

# 运行安装脚本（交互模式）
./install.sh
```

### 安装选项

| 选项 | 说明 |
|------|------|
| `--claude` | 安装到 Claude Code (`~/.claude/skills/`) |
| `--openclaw` | 安装到 OpenClaw (`~/.openclaw/skills/`) |
| `--cline` | 安装到 Cline (`~/.cline/skills/`) |
| `--all` | 安装到所有支持的客户端 |
| `-h, --help` | 显示帮助信息 |

## 配置 API Key

使用前需要设置智谱 AI 的 API Key：

```bash
# 添加到 ~/.zshrc 或 ~/.bashrc
export ZHIPU_API_KEY="your_api_key"

# 或使用备用环境变量名
export BIGMODEL_API_KEY="your_api_key"
```

获取 API Key: https://open.bigmodel.cn/usercenter/proj-mgmt/apikeys

## 使用方法

### 在 AI 编码助手中使用

安装后，在 Claude Code / OpenClaw 等助手中可以直接请求网络搜索：

```
请搜索最新的 React 19 特性
```

助手会自动调用此技能进行网络搜索。

### 命令行直接调用

```bash
# 基本搜索
~/.claude/skills/zhipu-web-search/scripts/zhipu-search.py "最新AI技术发展"

# 指定结果数量（默认 10 条）
~/.claude/skills/zhipu-web-search/scripts/zhipu-search.py "React 19 features" 5

# 自定义超时（默认 30 秒）
~/.claude/skills/zhipu-web-search/scripts/zhipu-search.py "complex query" 10 60
```

## 输出格式

```markdown
## [1] [网页标题](https://example.com)
**Summary:** 网页摘要内容...
**Source:** 网站名称
**Date:** 2026-02-25

## [2] [另一标题](https://example2.com)
...
```

## 依赖

- Python 3.6+
- curl（系统自带）

## 项目结构

```
myskills/
├── install.sh                    # 安装脚本
├── README.md                     # 本文档
└── skills/
    └── zhipu-web-search/
        ├── SKILL.md              # Skill 元数据
        └── scripts/
            └── zhipu-search.py   # 搜索脚本
```

## API 参考

- Endpoint: `https://open.bigmodel.cn/api/paas/v4/web_search`
- 文档: https://open.bigmodel.cn/dev/api/search-model/web-search

## License

MIT
