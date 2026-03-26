# Technical Requirements

{请在此处阐述技术要求、要点、使用工具、外部引用等一切技术设计和要求相关内容，格式不限}

# Sub Task

{请在此处根据实际情况，将需求拆分为若干个需求，每一个二级标题代表一个子任务，以下 TASK-0 为模板 TASK-1 / TASK-2 为示例}

## TASK-0:{task-name}

{子任务描述}

### Code Endpoint

{入口类型: 接口(request-path) / 定时任务 / 消费监听器 / 代理函数 / ...}
- `{接口类型写: 接口路径}`
- `{定时任务写: 定时任务名称}`
- `{消费监听器写: 监听器名称}`
- `{代理函数写: 代理函数名称}`
- `{...}`

入口文件路径:
- `{入口文件路径}`

入口函数签名:
- `{入口函数签名信息}`

### Implementation Steps

{此处编写任务的操作步骤有哪些}

### Change Files

```
{tree格式展示子任务修改或新增涉及文件}
```

---

## TASK-1: 在用户鉴权 Controller 新增重置密码函数

在现有用户鉴权 Controller 中修改充值密码函数

### Code Endpoint

修改接口(): 
- `/user/auth/reset-password`

入口文件路径: 
- `/user/AuthController.java`

入口函数签名: 
- `public CommonResult<Void> resetPassword(@RequestBod``y UserAuthResetPasswordParam userAuthResetPasswordParam)`

### Implementation Steps

1. 分析现有 AuthController 中的编程范式
2. 新增函数 resetPassword，使用 POST 请求
3. 为 AuthController 添加Spring 依赖 UserAuthDomainService, 并在 resetPassword 中进行调用
   


### Change Files

```
project/
    ├── web/
        └── user/
            └── AuthController.java
```

---

## Task-2:编写用户领域实现

编写用户模块中 API 和 Service 重置密码的实现

### Code Endpoint

修改接口():
- `/user/auth/reset-password`

入口文件路径:
- `/user/AuthController.java`

入口函数签名:
- `public CommonResult<Void> resetPassword(@RequestBody UserAuthResetPasswordParam userAuthResetPasswordParam)`

### Implementation Steps

1. 创建 UserAuthResetPasswordParam 参数模型，定义重置密码所需的请求参数（userId, newPassword 等）
2. 创建 UserType 枚举模型，定义用户类型（如：ORDINARY_USER 普通用户、ADMIN 管理员等）
3. 在 UserDO 实体类中添加 type 字段，用于标识用户类型
4. 在 UserDomainService 接口中添加 resetPassword 函数定义
5. 在 UserDomainServiceImpl 中实现 resetPassword 函数：
   - 根据 userId 查询用户信息
   - 验证用户的 userType 字段
   - 只有当 userType 等于普通用户枚举值时才允许修改密码
   - 执行密码修改操作（加密存储）
   - 调用 UserLogService.log() 记录用户行为日志
6. 在 UserService 接口中添加 resetPassword 函数定义
7. 在 UserServiceImpl 中实现 resetPassword 函数，调用领域服务完成密码重置操作
8. 添加必要的参数校验和业务异常处理（如用户不存在、无权限修改密码等）

### Change Files

```
project/
  └── user-model/
      ├── user-api/
      │   └── user/
      │       ├── model/
      │       │   ├── param/
      │       │   │   └── UserAuthResetPasswordParam.java (新增)
      │       │   ├── enums/
      │       │   │   └── UserType.java (新增)
      │       │   └── dataobj/
      │       │       └── UserDO.java (修改，添加 type 字段)
      │       ├── service/
      │       │   ├── UserService.java (修改)
      │       │   └── UserLogService.java (可能已存在)
      │       └── domainservice/
      │           └── UserDomainService.java (修改)
      └── user-service/
          └── user/
              ├── service/
              │   ├── UserServiceImpl.java (修改)
              │   └── UserLogServiceImpl.java (可能已存在)
              └── domainservice/
                  └── UserDomainServiceImpl.java (修改)
```


---




# All change files

{以 tree 格式展现所有产生了变动的文件}

```
project/
  ├── web/
  │   └── user/
  │       └── AuthController.java
  └── user-model/
      ├── user-api/
      │   └── user/
      │       ├── model/
      │       │   ├── param/
      │       │   │   └── UserAuthResetPasswordParam.java
      │       │   ├── enums/
      │       │   │   └── UserType.java
      │       │   └── dataobj/
      │       │       └── UserDO.java
      │       ├── service/
      │       │   └── UserService.java
      │       └── domainservice/
      │           └── UserDomainService.java
      └── user-service/
          └── user/
              ├── service/
              │   └── UserServiceImpl.java
              └── domainservice/
                  └── UserDomainServiceImpl.java
```
