# 处理流程、AXI与源码

摄像头OV5640 → PL demosaic → frame_dma S2MM → PS读取并复制原帧 → BGR/旋转镜像/640×360输入准备 → 专用moments_dma MM2S → PL BGR转HSV与肤色阈值 → S2MM回传紧凑mask → PS形态学、轮廓选择、凸包/缺陷、质心及RPS候选 → control JSON提前发布 → PS标注/JPEG/六宫格。

“moments_dma”是继承的IP实例名，v6内核已替换为skin_kernel；不要因此用旧HSV/gate矩核协议调用。
默认host-only不启动摄像头VDMA的MM2S显示通道，不分配输出帧、不等待PL OSD显示应用；采集S2MM和算法专用DMA继续运行。
此版并非摄像头直连算法的全流式设计，仍有PS搬运和DDR往返。

## 实现边界

| 环节 | 位置 |
|---|---|
| 摄像头接口、去马赛克、DMA、HSV及肤色阈值 | PL |
| 输入变换、膨胀/Gaussian、轮廓/凸包/RPS、控制平滑与滞回、JPEG | PS |
| 游戏运动/动画/动作、客户端失联释放 | 队友游戏端，尚未接入 |

Gaussian结果不是二值图。未来硬件替换形态学须保持边界、迭代和非二值语义，不能直接换成近似二值闭运算。
质心只统计选中目标区域，不使用所有肤色像素总质心。坐标与控制使用同帧结果。

## SKN6专用DMA包

输入u32小端5字头：magic=0x534B4E36、w|(h<<16)、frame_id、Hlo|Hhi<<8|Slo<<16|Shi<<24、Vlo|Vhi<<8；随后紧凑BGR8字节，末尾补零对齐4字节。
尺寸最大1280×720；H范围0..179，S/V 0..255，阈值上下界均包含。
输出ceil(w*h/4)个mask u32（每像素0或255，高位padding为0），加8字状态：magic、frame_id、尺寸、像素数、error、0、0、0。DMA包TLAST不是视频EOL。
PS检查长度、魔数、帧ID、尺寸、错误标志和掩码值；固定映射缓冲区，先停DMA再释放。HTTP线程只拿不可变bytes，不持有DMA数组。
100MHz色彩核心无反压II=1；紧凑BGR DMA适配器并非整体II=1，不能把核理论周期当摄像头FPS。

## 硬件快照

hardware/workspace/b/cskin/cskin.xpr和同级srcs保存原工程；关联的自定义RTL、rgb2dvi IP和约束按原相对目录保存。
generated wrapper保留；未包括Vivado安装、许可证、board store、缓存、实现run/DCP。
使用Vivado2026.1，先在复制工作区检查IP状态并重新生成输出产品。跨机器路径/供应商IP环境仍需检查，未声称全新环境一键完整布线。
hardware/legacy_build里的集成脚本依赖原cacc工程和本机绝对路径，仅供追溯，不要在新电脑直接运行。
hardware/frontend提供向量生成器，可安装numpy/OpenCV后运行：

```bash
cd hardware/frontend
python generate_vectors.py
python generate_dma_vectors.py
```

输出golden/*.hex、summary.json、dma_summary.json、dma_sizes.svh及倒数表；大体积hex未上传，可由脚本生成。
独立综合命令为 `vivado -mode batch -source synth_frontend.tcl`，生成synth/*.rpt和frontend.dcp，仅核心OOC，不是整机bit。
仿真原脚本存档有原许可证路径；应使用自己已有的Vivado许可，不能分发/使用他人的许可证。

## 地址快照

专用DMA 0x40400000，算法reset GPIO 0x41200000，frame_dma 0x43000000，hand_osd 0x43C10000，camera_iic 0x41600000，demosaic 0x43C00000。以配对HWH和verify_package为准，不能混用旧bit/HWH。
