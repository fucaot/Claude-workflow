# /feature-create - 创建新功能模块

你是一个 AI 协作开发助手。用户请求创建一个新的功能模块。

## 参数

- `$ARGUMENTS`：功能模块名称（如 `user-auth`、`payment-system`）

## 执行步骤

### 1. 验证参数

如果 `$ARGUMENTS` 为空，请提示用户：
```
请提供功能名称，例如：/feature-create user-auth
```

### 2. 创建功能目录

在 `agent_docs/` 下创建功能目录：

```
agent_docs/features/{feature-name}/
├── 10_CONTEXT.md          # 功能上下文（必需）
├── 20_DEVELOP_PLAN.md     # 功能上下文（不生陈，/feature-start 时生成）
├── 90_PROGRESS_LOG.yaml   # 进度日志（必需）

```

### 3. 生成 10_CONTEXT.md（智能模式 vs 模板模式）

根据用户是否提供功能描述，选择不同的生成模式：

#### 3.1 智能生成模式（用户提供了功能描述）

如果用户提供了功能描述（如 `/new-feature user-auth "用户登录注册模块，支持邮箱验证"`），则：

**步骤 A 确保需求理解充分**

根据以下基础标准判断是否对现有需求可以充分理解，无法充分理解则使用 /interview 对用户进行提问，直到理解充分为止，之后进入步骤 B；
- 是否清楚需求是新功能还说对原有功能的改造，又或者两者都有？
- 如果是新功能，是否知道或用户提到应该写在哪个目录、模块、代码包下？
- 如果是原有功能改造，用户是否提到原有功能入口在哪里？修改应该从那里入手？
- 目标是否清晰？是否知道应该实现什么？

**步骤 B：解析需求描述**

从用户描述中自动提取：
- **核心功能点**：登录、注册、邮箱验证...
- **目标用户**：普通用户、管理员...
- **业务价值**：提高安全性、改善用户体验...
- **关键约束**：密码加密、Token 有效期...


**步骤 C：解析提取规范或约束信息**

```markdown
### 技术约束
- 密码必须加密存储（bcrypt）
- Token 有效期 24 小时

### 业务约束
- 邮箱必须唯一
- 密码至少 8 位
```

**步骤 D：生成需求上下文需求文档**

如果依然无法确定需求充分理解，返回步骤 A 重新执行。

在确定需求充分理解的前提下，按照 `.claude/template/10_CONTEXT.md` 中的模板生成 `10_CONTEXT.md` 并编写详细需求，只分析并编写需求，不涉及技术实施方案


#### 3.2 模板模式（用户未提供描述）

如果用户只提供了功能名称，按照 `.claude/template/10_CONTEXT.md` 中的模板生成 `10_CONTEXT.md`


### 4. 生成 90_PROGRESS_LOG.yaml

按照 `.claude/template/90_PROCESS_LOG.yaml` 中的模板生成 `90_PROGRESS_LOG.yaml` 到目录 agent_docs/features/{feature-name}/


### 5. 写入任务清单

在 agent_docs/task.md 中, 按照以下格式在 Todo 中新建任务:

```

- [ ] **{feature-name}**: {feature_description}

```

### 6. 输出结果

创建完成后，输出以下信息：

```
✅ 功能模块 "{feature-name}" 创建成功！

📁 目录结构：
agent_docs/features/{feature-name}/
├── 10_CONTEXT.md          # 功能上下文
├── 90_PROGRESS_LOG.yaml   # 进度日志

📝 下一步操作：
1. 补充 10_CONTEXT.md 中的功能描述、目标和范围
2. 补充完毕后通过 /feature-start 开始执行编码

💡 提示：
- 使用 /iresume {feature-name} 恢复工作上下文
```

## 注意事项

- 功能名称使用 kebab-case（如 `user-auth`，不是 `userAuth`）
- 自动生成的文档是框架，需要人工补充内容