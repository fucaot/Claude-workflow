---
name: feature-save
description: 保存当前功能开发进度
model: haiku
---

# /feature-save - 保存当前功能开发进度

无需参数，自动保存当前上下文中正在开发的功能进度。

## 前提条件

当前会话必须已通过 `/feature-start` 开始了某个功能开发。

如果当前会话没有启动过任何功能，拒绝并提示：
```
❌ 当前没有正在开发的功能，请先使用 /feature-start 开始开发
```

## 执行步骤

### 1. 确认当前功能

从当前会话上下文中获取已启动的功能名称（即 `/feature-start` 加载的功能）。

### 2. 收集当前进度信息

读取 `agent_docs/features/{feature-name}/90_PROGRESS_LOG.yaml` 获取当前进度快照。

向用户询问：
1. **本次完成的操作**：完成了什么？
2. **下一步计划**：下次继续时应该做什么？

### 3. 收集编辑文件列表

通过 `git diff --name-only` 获取当前未提交的变更文件列表。

与 `90_PROGRESS_LOG.yaml` 中已有的 `edit_files` 合并去重。

### 4. 更新 90_PROGRESS_LOG.yaml

更新以下字段：

```yaml
meta:
  last_updated: {current_datetime}

cc_checkpoint:
  session_id: "cc-{current_date}-{feature-name}"
  last_file_edited: "{edit_files 中最后一个文件}"
  last_action: "{本次完成的操作}"
  next_step: "{下一步计划}"
  context_files:
    - "agent_docs/features/{feature-name}/10_CONTEXT.md"
    - "agent_docs/features/{feature-name}/20_DEVELOP_PLAN.md"
    - "agent_docs/features/{feature-name}/90_PROGRESS_LOG.yaml"
  edit_files:
    - {合并去重后的文件列表}

stats:
  edit_files: {合并后的文件总数}
```

### 5. 输出结果

```
✅ 进度已保存！

📁 功能模块：{feature-name}
📝 最后操作：{last_action}
📂 涉及文件（{edit_files 数量}个）：
   - {file_1}
   - {file_2}
   - ...
📋 下一步：{next_step}

💡 恢复开发：/feature-start {feature-name}
```
