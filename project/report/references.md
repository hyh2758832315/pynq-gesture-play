# 参考资料

本页汇总赛事要求、器件与接口资料、软件依赖和项目来源。引用日期统一为 2026-11-04；仓库内第三方组件以随附版本和许可为准。

## 赛事、器件与设计文档

[1] AMD. [FPGA 创新设计赛道选题指南：AMD 自主选题赛道](https://gitee.com/Vickyiii/fpgachina26-amd/blob/master/tracks/open-topic/GUIDE.md)[EB/OL]. 参赛材料组织与 Skill 要求依据。

[2] TUL. PYNQ-Z2 Product Information[EB/OL]. [仓库内 PDF](sources/pynq_z2_tul_product.pdf)；[TUL 原始文件](https://www.tul.com.tw/images/PYNQ-Z2_PA_v2_pp_20201209_STD.pdf). 器件、板卡接口与硬件配置参考。

[3] PYNQ Project. [PYNQ Documentation, Release 3.1](https://pynq.readthedocs.io/en/v3.1/)[EB/OL]. 板端 Overlay、内存分配与硬件访问接口参考。

[4] AMD. [AXI DMA LogiCORE IP Product Guide, PG021](https://docs.amd.com/r/en-US/pg021_axi_dma)[EB/OL]. DMA 配置、状态、传输和复位行为参考。

[5] AMD. [Vivado Design Suite User Guide: Using Constraints, UG903](https://docs.amd.com/r/en-US/ug903-vivado-using-constraints)[EB/OL]. 时钟、I/O 与时序约束参考。

[6] AMD. [Vivado Design Suite User Guide: Design Analysis and Closure Techniques, UG906](https://docs.amd.com/r/en-US/ug906-vivado-design-analysis)[EB/OL]. 资源、时序分析与实现收敛方法参考。

## 组件与软件来源

[7] Digilent. [rgb2dvi OutputSERDES 源码](https://github.com/Digilent/vivado-library/blob/master/ip/rgb2dvi/src/OutputSERDES.vhd)[CP/OL]. HDMI/DVI 输出串行化模块来源。

[8] ORCAHand. [ORCA Hand 硬件设计与三维打印文件](https://github.com/orcahand/orcahand_hardware)[DS/OL]. 灵巧手机械结构与装配参考。

[9] N-B-Studio. [orca_core：面向 SCS225 / ST3215 舵机的 ORCA Hand 控制适配](https://github.com/N-B-Studio/orca_core)[CP/OL]. 本项目使用的 ORCA 软件分支；[SCS-225 改装资料](https://github.com/N-B-Studio/orca_core/tree/main/SCS-225)。

[10] KPTKleist. [Pynq_Gesture_Detect：手势识别算法与实现](https://github.com/KPTKleist/Pynq_Gesture_Detect)[CP/OL]. OpenCV 手势识别参考实现，相关代码保留 MIT 声明。

[11] OpenMV. [openmv：相机与传感器驱动](https://github.com/openmv/openmv)[CP/OL]. [项目参考的 OV5640 驱动版本](https://github.com/openmv/openmv/blob/62369938a94bd04624cf53ffb25a2d923031ebdd/drivers/sensors/ov5640.c)，用于传感器初始化和寄存器配置参考。

[12] Xilinx. [PYNQ：板端硬件访问与运行框架](https://github.com/Xilinx/PYNQ)[CP/OL]. 板端运行依赖。

[13] OpenCV. [OpenCV 计算机视觉库](https://github.com/opencv/opencv)[CP/OL]. PS 视觉处理与算法参考依赖。

[14] FORENCICH A. [verilog-axis：AXI 流接口组件库](https://github.com/alexforencich/verilog-axis)[CP/OL]. 本项目采用的 AXI 流解复用组件来源；随包版本见源码与许可文件。

## 补充项目参考

[15] bambridge. [PainterEngine_embedfpga](https://gitee.com/bambridge/PainterEngine_embedfpga)[CP/OL]；matrixcascade. [PainterEngine](https://github.com/matrixcascade/PainterEngine)[CP/OL]. GPU 指令分发、参数锁存及流水线控制的架构参考；本项目 Scene2D 使用独立的片上索引色缓冲与帧呈现实现。

[16] ORCAHand. [orca_core：ORCA Hand 核心 Python 控制程序](https://github.com/orcahand/orca_core)[CP/OL]. [9] 的官方上游，提供模型、校准与控制框架。

[17] Xilinx. [PYNQ-ComputerVision](https://github.com/Xilinx/PYNQ-ComputerVision)[CP/OL]. PYNQ 中 OpenCV 算子 PL 加速的公开方法参考；本项目硬件实现入口为包内 RTL。

各来源的具体使用范围见 [许可说明](licensing.md)；项目级 MIT 不替代第三方组件许可。
