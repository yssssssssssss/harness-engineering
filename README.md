# Harness Engineering 技能包

## 1. 这是什么

`harness-engineering` 是一套把“Agent-First 工程方法”落到代码仓库里的可复用能力。  
目标是让智能体在不同项目中都能稳定执行：有规则可读、有边界可守、有检查可跑、有回路可迭代。

本项目当前提供：
- 一个可触发的技能定义：`skills/harness-engineering/SKILL.md`
- 一个一键初始化脚本：`skills/harness-engineering/scripts/bootstrap_harness.sh`
- 一个审计脚本：`skills/harness-engineering/scripts/harness_audit.sh`
- 两份参考文档：
  - `skills/harness-engineering/references/harness-engineering-playbook.md`
  - `skills/harness-engineering/references/harness-templates.md`

## 2. 核心能力介绍

这套方法聚焦四个工程能力：

1. 规则显式化  
把关键约束从“口头约定/聊天上下文”转为仓库内可版本化文件（如 `AGENTS.md`、`docs/harness/*`）。

2. 边界工程化  
把架构边界写清楚并绑定到检查机制，减少跨层依赖和隐性耦合。

3. 反馈自动化  
通过脚本和 CI 在 PR 阶段自动检查，尽早发现偏离，而不是依赖人工兜底。

4. 持续清理  
把“文档过期、规则失效、流程膨胀”当成常规维护项，持续减复杂度。

## 3. 使用流程（推荐）

### 步骤 1：引入技能目录

将本仓库中的技能目录复制到你的项目（或你的全局技能目录）：

- 技能根目录：`skills/harness-engineering`

如果你的运行环境支持全局技能目录（如 `~/.codex/skills`），可安装后跨项目复用。

### 步骤 2：初始化目标仓库

在目标项目根目录执行：

```bash
bash skills/harness-engineering/scripts/bootstrap_harness.sh . --with-github-ci
```

该操作会生成最小可用的 Harness 结构（若文件已存在默认不覆盖）：
- `AGENTS.md`
- `docs/harness/README.md`
- `docs/harness/architecture-boundaries.md`
- `docs/harness/runbook.md`
- `docs/harness/decision-log.md`
- `docs/harness/backlog.md`
- `scripts/check.sh`
- `.github/workflows/harness-audit.yml`（可选参数启用）

### 步骤 3：执行审计

```bash
bash skills/harness-engineering/scripts/harness_audit.sh . --strict
```

说明：
- 默认模式：输出通过/失败项，返回码不阻断
- `--strict`：存在失败项时返回非 0，适合集成到 CI

### 步骤 4：按项目实际收敛

把占位规则替换为真实规则：
- 在 `scripts/check.sh` 写入你项目真实的 `lint/test/build`
- 在 `docs/harness/architecture-boundaries.md` 落实真实层级边界与检查方式
- 在 `docs/harness/runbook.md` 固化标准发布和变更流程
- 在 `docs/harness/decision-log.md` 记录关键技术决策

### 步骤 5：纳入日常迭代

- 每次重大改动后跑一遍 `harness_audit.sh`
- 每个迭代周期清理一次 backlog 和过期规则
- 规则“无 owner / 无检查 / 无收益”则删除

## 4. 目录结构

```text
harness-engineering/
├── README.md
└── skills/
    └── harness-engineering/
        ├── SKILL.md
        ├── agents/
        │   └── openai.yaml
        ├── scripts/
        │   ├── bootstrap_harness.sh
        │   └── harness_audit.sh
        └── references/
            ├── harness-engineering-playbook.md
            └── harness-templates.md
```

## 5. 适用场景

建议在以下场景使用：
- 新仓库从 0 到 1 建立 Agent-First 开发约束
- 老仓库补齐工程规范、架构边界、CI 守门
- 多团队并行开发时统一“智能体可读”的协作标准

## 6. 一句话实践建议

先把规则写短、写清、写进仓库，再把规则变成可执行检查；先保证可运行，再逐步收紧门禁。
