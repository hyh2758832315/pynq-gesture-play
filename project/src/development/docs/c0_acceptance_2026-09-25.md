# C0 最小 Overlay 验收记录

日期：2026-09-25

## 文档标识

| 字段 | 内容 |
| --- | --- |
| 文档类型 | 项目级上板事实记录（编辑源） |
| 当前文件路径 | `docs/c0_acceptance_2026-09-25.md` |
| 所属项目 | `voice-view-game` |
| 板卡/阶段 | PYNQ-Z2 / C0 |
| 最终结果 | `PASS` |
| 经验提炼源文件 | `xilinx-skill/plugins/xilinx-suite/references/pynq_z2_c0_overlay.md` |
| Skill 部署副本 | `~/.agents/skills/xilinx-suite/references/pynq_z2_c0_overlay.md` |
| 记录关系 | 本文件保存本次实测事实；Skill 源文件保存跨项目可复用经验 |

## 环境

| 项目 | 结果 |
| --- | --- |
| 开发板 | PYNQ-Z2，XC7Z020CLG400-1 |
| Vivado | 2026.1，Build 6511674 |
| 板端 PYNQ Python 包 | 3.1 |
| 板端系统 | PynqLinux 3.0，Linux `6.6.10-xilinx-v2024.1-gb36799f4e960` |
| SSH | `pynq-z2` 主机别名，ED25519 密钥免密登录 |

PS7 DDR/MIO 参数来自 Xilinx/PYNQ 的 Pynq-Z2 Base Overlay：

- PYNQ 标签：`v3.1`
- 提交：`19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa`
- `base.tcl` SHA-256：`AB0A99865CE597B68E72F4DB71B8D5D3D60929613183FAE27EF44DB6A985CFE3`
- 官方参数：DDR3 525 MHz、32-bit PS DDR 数据宽度、Pynq-Z2 MIO 映射

## 设计

```text
PS7 M_AXI_GP0 -> SmartConnect -> AXI GPIO <- XLConstant 0xC0010001
```

| 项目 | 值 |
| --- | --- |
| BUILD_ID | `0xC0010001` |
| AXI 基地址 | `0x41200000` |
| AXI 地址范围 | `0x00010000` |
| 数据寄存器偏移 | `0x0` |
| PL 时钟 | 100 MHz，PS7 FCLK_CLK0 |

## Vivado 验收

| 检查 | 结果 |
| --- | --- |
| Block Design 校验 | 通过 |
| 综合 | 通过 |
| 实现与 bitstream | 通过 |
| DRC | 0 项 |
| WNS | +2.985 ns |
| TNS | 0.000 ns |
| WHS | +0.041 ns |
| THS | 0.000 ns |
| 时序约束 | 全部满足 |

XSA 平台导出成功。最小固定设计未声明可供 Vitis 链接扩展的 PFM AXI 从端口，Vivado 对此给出平台扩展能力提示；该提示不影响 PYNQ `.bit/.hwh` 加载路径。

## 产物

| 文件 | 字节数 | SHA-256 |
| --- | ---: | --- |
| `c0_overlay.bit` | 4,045,765 | `2686034D65214A54D685CF89C8DBA02BD3EA7702E2EFC03B463D1702644BFC78` |
| `c0_overlay.hwh` | 135,385 | `C8F8218009A5357A1C42F4582D0E427B56B63098CA43263203B036443E15B96C` |
| `c0_overlay.xsa` | 7,106,297 | `7F32470744807D1E90C435DB07BCF771932AFDA3C0FF503BA6EDA505C08934DC` |

## 板端验收

在 `192.168.2.99` 上使用 PYNQ 3.1 虚拟环境执行 `verify_c0.py`，连续下载 Overlay 10 次。每次均从 AXI GPIO 数据寄存器读取：

```text
C0_LOAD_01=0xC0010001
C0_LOAD_02=0xC0010001
C0_LOAD_03=0xC0010001
C0_LOAD_04=0xC0010001
C0_LOAD_05=0xC0010001
C0_LOAD_06=0xC0010001
C0_LOAD_07=0xC0010001
C0_LOAD_08=0xC0010001
C0_LOAD_09=0xC0010001
C0_LOAD_10=0xC0010001
C0_VERIFY_STATUS=PASS (10/10)
```

结论：C0 自动验收通过，Vivado 2026.1 生成的 `.bit/.hwh` 已在板端 PYNQ 3.1 完成稳定加载和 MMIO 读取验证，可进入 C2/C3 开发。

## 经验提炼状态

| 字段 | 内容 |
| --- | --- |
| 可复用经验 | 已提炼 |
| 提炼目标 | `xilinx-skill/plugins/xilinx-suite/references/pynq_z2_c0_overlay.md` |
| 提炼范围 | PS7 配置溯源、Vivado 2026.1 XSA/PFM、PYNQ venv、XRT、设备组与 root 权限、重复加载验收 |
| Skill 同步 | 已同步到 `~/.agents/skills/xilinx-suite/`，4 个关键文件 SHA-256 一致性校验通过 |