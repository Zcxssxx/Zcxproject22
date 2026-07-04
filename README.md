# MoonActor 🌙🎭

[![MoonBit Version](https://img.shields.io/badge/MoonBit-0.1.0-blue)](https://www.moonbitlang.cn/)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen)]()

**MoonActor** 是一款专为 MoonBit 生态系统设计的高性能、轻量级、类型安全的**协程式 Actor 并发框架**。本项目基于非抢占式的协作调度器构建，完美避开了跨平台 WebAssembly (WASM) 运行时的局限性，在 Native、WASM 和 JavaScript 后端均可实现极速、确定性的消息处理。

---

## 🌟 核心特性 (Features)

- 🔒 **零生命周期泄漏**：基于非阻塞式协作调度，在没有任何底层线程开销的情况下实现高并发。
- ⚡ **零反射与超低内存消耗**：避开运行时反射，通过闭包机制极速分发与捕获状态。
- 📦 **跨平台与零依赖**：完美契合 MoonBit 语言设计，100% 纯 MoonBit 编写，无第三方库依赖。
- 🎛 **双模式消息分发**：
  - **Tell 模式**（Fire-and-Forget）：非阻塞异步投递。
  - **Ask 模式**（Request-Response）：带类型推导的同步协作式请求应答。

---

## 🏗 架构设计 (Architecture)

MoonActor 在内存中维护了一套基于闭包调度的轻量级消息队列。

```
+------------------------------------------+
|                 System                   | (Cooperative Scheduler Loop)
|  +--------------------+                  |
|  |  active_contexts   | Array[() -> Bool]|
|  +---------+----------+                  |
+------------|-----------------------------+
             | triggers
             v
+------------|-----------------------------+
|            v  Context[Msg]               | (Actor Mailbox & State)
|  +---------+----------+                  |
|  |      mailbox       | Array[Msg]       |
|  +--------------------+                  |
|  |   mailbox_index    | Int (O(1) Head)  |
|  +--------------------+                  |
|  |       actor        | Actor[Msg]       |
|  +--------------------+                  |
+------------------------------------------+
```

1. **System**：全局生命周期管理器与协作调度器，通过轮询无锁队列中的函数闭包来分发并处理消息。
2. **Actor**：包含三个基础生命周期闭包 (`started`, `stopped`, `receive`) 的结构体。
3. **Context**：持有特定 Actor 的状态与消息队列，采用 O(1) 头部移动游标实现极速出队。
4. **Address**：向外部暴露的安全引用，用作向对应 Actor 投递消息的媒介。

---

## 🚀 快速上手 (Quick Start)

### 1. 定义消息与状态
```moonbit
enum CounterMsg {
  Increment
  Decrement
  Get
}

struct CounterState {
  mut value: Int
}
```

### 2. 创建并运行 Actor System
```moonbit
test "actor system demonstration" {
  // 创建 Actor 运行系统
  let system = System::new("DemoSystem")
  
  // 声明状态
  let state = { value: 0 }
  
  // 创建 Actor 实例并捕获状态
  let actor = Actor::new(
    fn(_ctx) { println("Actor started!") },
    fn(_ctx) { println("Actor stopped!") },
    fn(msg, _ctx) {
      match msg {
        Increment => state.value += 1
        Decrement => state.value -= 1
        Get => ()
      }
    }
  )
  
  // 注册并启动 Actor，获取安全引用地址
  let addr = system.spawn(actor)
  
  // 1. Tell 异步投递消息
  addr.tell(Increment)
  addr.tell(Increment)
  addr.tell(Decrement)
  
  // 驱动协作式事件循环处理消息
  system.run_pending()
  
  // 2. Ask 同步请求应答
  let count = addr.ask(Get, fn(_msg) { state.value })
  println("Final count: \{count}") // 输出: 1
}
```

---

## 📂 项目结构 (Directory Structure)

```
moon_actor/
├── LICENSE                 # Apache 2.0 开源证书
├── README.md               # 项目技术说明文档
├── moon.mod.json           # 模块配置信息
└── src/
    ├── actor.mbt           # Actor 结构体与构造器
    ├── context.mbt         # Mailbox 与出入队消息上下文
    ├── address.mbt         # Tell/Ask 消息投递接口
    ├── system.mbt          # 协作式并发调度器与 System 引擎
    ├── message.mbt         # 核心 Message 约束定义
    ├── supervisor.mbt      # 监督策略基础类型
    ├── envelope.mbt        # 消息信封封装定义
    └── actor_test.mbt      # 单元测试与用例验证
```

---

## 🤝 参与贡献
本项目是 **2026 MoonBit 基础软件生态开源大赛** 的参赛作品。
欢迎随时提交 Issue 与 Pull Request 帮助我们完善它！
