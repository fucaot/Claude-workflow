# /feature-start - 开始功能开发

## 参数

- `$ARGUMENTS`：功能模块名称（如 `user-auth`、`payment-system`）

## 执行步骤

### 1. 验证参数

如果 `$ARGUMENTS` 为空，请提示用户：
```
请提供功能名称，例如：/feature-create user-auth
```

### 2. 读取功能

在 `agent_docs/` 下读取任务相关信息:

```
agent_docs/features/{feature-name}/
├── 10_CONTEXT.md          # 功能上下文（必需）
├── 20_DEVELOP_PLAN.md     # 开发记录（非必须存在）
├── 90_PROGRESS_LOG.yaml   # 进度日志（必需）

```

读取并分析 10_CONTEXT.md 中的功能相关需求、技术设计、任务拆分相关信息来获取并理解需求, 如果对现有需求依然不能充分理解, 使用 /interview 对用户进行提问。

读取并分析 20_DEVELOP_PLAN.md 中的开发实施计划，如果 20_DEVELOP_PLAN.md 为空或不存在则继续执行，进行规划开发任务。

读取并分析 90_PROGRESS_LOG.yaml 来获取任务元信息, 以及端点信息.

### 3. 规划开发任务

#### 3.1 装载任务

读取 20_DEVELOP_PLAN.md 中的开发实施计划。

如果内容为空不存在, 则调用 omc 的 `planner` agent 按照 `.claude/template/20_DEVELOP_PLAN.md` 这个模板的格式，进行计划, 包含技术方案和子任务.

最终计划结果写入到 `agent_docs/features/{feature-name}/20_DEVELOP_PLAN.md` 中.


####  3.2 输出信息

按照模版输出以下信息:

```

✅ 功能模块 "{feature-name}" 装载成功！

功能需求概述: {}

开发任务: {}

目前进度: {}

```


#### 3.3 开始任务

使用 `Ask Usr` 工具向用户提问并根据用户选择的选项来继续执行, 有以下选项:
1. 使用 omc 的 ulw 模式进行最大并行度任务执行, 参考示例指令`/ultrawork`
2. 使用 omc 的 teams 模式进行 Agent 并行任务执行，默认 agent 数量 3, 参考示例指令: `/team 3:executor "fix all TypeScript errors"`
3. 直接开始任务

执行的过程中遵循全局和项目的 CLAUDE.md，保持每一个任务都先通过计划再执行.