---
name: workflow-up
description: 更新 Claude Workflow 的 commands 和 template
---

# /workflow-up - 更新工作流

从 GitHub 拉取最新的 commands 和 template，仅覆盖新增或变更的文件，已有且未变更的文件保持不变。

## 执行步骤

### 1. 执行远程更新脚本

```bash
curl -sSL https://raw.githubusercontent.com/fucaot/Claude-workflow/main/update.sh | bash
```

### 2. 输出结果

将脚本输出的更新摘要展示给用户。
