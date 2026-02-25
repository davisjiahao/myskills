---
name: zhipu-web-search
description: Zhipu AI's web search API for real-time internet search. Use when you need news, current events, or up-to-date information beyond Claude's knowledge cutoff.
---

# Zhipu AI Web Search

智谱AI联网搜索，通过 REST API 实现实时网络搜索。

## When to Use

- 搜索最新新闻和实时信息
- 查询当前事件、技术动态
- 获取 Claude 知识截止日期之后的信息
- 中英文网络搜索

## Prerequisites

设置环境变量：
```bash
export ZHIPU_API_KEY="your_api_key"
```

获取 API Key: https://open.bigmodel.cn/usercenter/proj-mgmt/apikeys

## Usage

```bash
~/.claude/skills/zhipu-web-search/scripts/zhipu-search.py "<query>" [count] [timeout]
```

**Parameters:**
- `query` (required): 搜索关键词
- `count` (optional): 返回结果数量，默认 10
- `timeout` (optional): 超时秒数，默认 30

**Bash tool invocation:**
```yaml
Bash tool parameters:
- command: ~/.claude/skills/zhipu-web-search/scripts/zhipu-search.py "<query>"
- description: Search web via Zhipu AI
```

## Examples

**基本搜索:**
```bash
~/.claude/skills/zhipu-web-search/scripts/zhipu-search.py "最新AI技术发展"
```

**指定结果数量:**
```bash
~/.claude/skills/zhipu-web-search/scripts/zhipu-search.py "React 19 features" 5
```

**自定义超时:**
```bash
~/.claude/skills/zhipu-web-search/scripts/zhipu-search.py "complex query" 10 60
```

## Output Format

```markdown
## [1] [网页标题](https://example.com)
**Summary:** 网页摘要内容...
**Source:** 网站名称
**Date:** 2026-02-25

## [2] [另一标题](https://example2.com)
...
```

## API Reference

- Endpoint: `https://open.bigmodel.cn/api/paas/v4/web_search`
- Doc: https://open.bigmodel.cn/dev/api/search-model/web-search

## Notes

- 使用 curl 发送请求，需要系统安装 curl
- 通过 ZHIPU_API_KEY 或 BIGMODEL_API_KEY 环境变量认证
- 支持中英文搜索
- 跨平台兼容 (macOS/Linux)
