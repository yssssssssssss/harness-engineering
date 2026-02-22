# Harness Engineering Skills for Codex

面向 Codex 的工程化技能集合，用于把仓库从“聊天驱动协作”升级为“仓库驱动协作”。

本仓库提供 4 个可直接加载的 skills：
- `harness-engineering`：端到端总控（基线评估 -> 合同建立 -> 约束落地 -> 自动化闭环 -> 持续治理）
- `harness-init`：初始化/重建基础 harness
- `harness-audit`：执行成熟度审计与严格门禁
- `harness-governance`：持续治理与熵控制

## 1. 目标与适用场景

当你需要下面任一能力时，这套 skills 可直接使用：
- 快速为仓库创建 `AGENTS.md` 与 `docs/harness/*` 结构
- 把架构规则从“文档约定”转为“可执行检查”
- 在 CI 中增加可失败的质量门禁
- 建立决策日志、backlog、定期清理机制，降低 agent 变更漂移

## 2. 仓库结构

```text
harness-engineering/
├── SKILL.md                     # 总控 skill: harness-engineering
├── scripts/
│   ├── bootstrap_harness.sh
│   └── harness_audit.sh
├── references/
│   ├── harness-engineering-playbook.md
│   └── harness-templates.md
├── harness/                     # 通用聚合 skill: harness
├── harness-init/                # 子 skill: 初始化
├── harness-audit/               # 子 skill: 审计
└── harness-governance/          # 子 skill: 治理
```

每个 skill 子目录都包含最小必需文件：
- `SKILL.md`
- `agents/openai.yaml`
- 可选 `scripts/` 与 `references/`

## 3. 各 Skill 职责边界

### 3.1 harness-engineering（总控）

适合完整改造：从现状盘点到落地治理全流程。

典型触发语：
- “把这个仓库改造成 agent-first”
- “帮我设计 AGENTS + docs/harness + CI 门禁”

### 3.2 harness-init（初始化）

适合首次落地或重建骨架。

核心命令：
```bash
bash scripts/bootstrap_harness.sh .
bash scripts/bootstrap_harness.sh . --with-github-ci
bash scripts/bootstrap_harness.sh . --force
bash scripts/harness_audit.sh . --strict
```

### 3.3 harness-audit（审计）

适合检查仓库是否达到最低可执行标准，并输出可修复项。

核心命令：
```bash
bash scripts/harness_audit.sh .
bash scripts/harness_audit.sh . --strict
```

### 3.4 harness-governance（治理）

适合长期运营：
- 文档去陈旧
- 决策日志与 backlog 维护
- 周期性质量回归检查

## 4. 安装到 Codex 全局

默认全局技能目录为 `~/.codex/skills`（若设置了 `$CODEX_HOME`，则为 `$CODEX_HOME/skills`）。

推荐使用软链接，便于本地改动即时生效：

```bash
ln -sfn "$(pwd)" ~/.codex/skills/harness-engineering
ln -sfn "$(pwd)/harness" ~/.codex/skills/harness
ln -sfn "$(pwd)/harness-init" ~/.codex/skills/harness-init
ln -sfn "$(pwd)/harness-audit" ~/.codex/skills/harness-audit
ln -sfn "$(pwd)/harness-governance" ~/.codex/skills/harness-governance
```

安装后重启 Codex 会话以重新加载技能。

## 5. 在 Codex 中调用

可显式触发：
- `$harness-engineering`
- `$harness`
- `$harness-init`
- `$harness-audit`
- `$harness-governance`

也可自然语言触发（根据 `SKILL.md` 的 `description` 自动匹配）。

## 6. 脚本说明

### 6.1 `bootstrap_harness.sh`

用途：在目标仓库生成最小 harness 文件，不覆盖已有文件（除非 `--force`）。

参数：
- `--force`：覆盖已有文件
- `--with-github-ci`：创建 `.github/workflows/harness-audit.yml`

### 6.2 `harness_audit.sh`

用途：对仓库执行一组确定性检查并输出通过/失败。

参数：
- `--strict`：若存在必需项缺失，以非 0 退出，用于 CI 门禁

## 7. 推荐落地顺序

1. 用 `harness-init` 建立基础结构
2. 用 `harness-audit` 修到严格模式通过
3. 用 `harness-governance` 建立周期性治理
4. 复杂改造场景切到 `harness-engineering` 总控

## 8. 质量与维护约定

- 保持 `AGENTS.md` 简短（导航，不堆细节）
- 规则尽量转为可执行检查
- 优先保留高信号、低成本、可重复的门禁
- 先删复杂度，再加流程

## 9. 发布到 GitHub（维护者）

```bash
git add -A
git commit -m "Add modular harness skills and full README"
git push -u origin main
```

若需要强制覆盖远端（谨慎）：
```bash
git push -u origin main --force
```

## 10. 许可证

当前仓库未单独声明许可证。如需开源分发，建议补充 `LICENSE` 文件并在 `README` 中注明。
