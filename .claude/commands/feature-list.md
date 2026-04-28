---
name: feature-list
description: 查看功能列表
model: haiku
---

# /feature-list - 查看功能列表

## 参数

- `$ARGUMENTS`：参数选项（如 `all`、`completed`、`running`、`todo`）, 例如: `/feature-list todo` 查询待办

如果 `$ARGUMENTS` 为空, 则视为查询全部, 等同于 `all`, 例如: `/feature-list `

## 执行步骤

读取 `agent_docs/task.md` 任务文件, 根据不同的参数读取不同的信息.

### 1. 查询全部

`$ARGUMENTS` 如果为空或者为 `all`, 则读取全部功能信息


### 2. 查询完成

`$ARGUMENTS` 如果为空或者为 `completed`, 则读取 `Completed Tasks` 中信息


### 3. 查询进行中

`$ARGUMENTS` 如果为空或者为 `completed`, 则读取 `Running Task` 中信息

### 4. 查询待办

`$ARGUMENTS` 如果为空或者为 `completed`, 则读取 `Todo Task` 中信息

### 5. 输出

按照以下模板输出信息:

```
✅ 查询到目前有以下任务:

执行中:

- {running_features}

待办:

- {todo_features}

📝 下一步操作：
1. 补充完毕后通过 /feature-start 开始继续编码
```