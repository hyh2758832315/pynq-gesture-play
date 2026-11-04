# 游戏控制接口交接

目前仅输出数据，不直接控制游戏。队友负责游戏角色、按键状态和动作映射。

## HTTP接口

默认服务地址 http://192.168.2.99:8088 ，IP/端口由--bind/--port配置。

| 路径 | 格式 | 用途 |
|---|---|---|
| / | HTML | 六宫格、实时预览、虚拟方块练习场 |
| /camera.mjpg | multipart MJPEG，boundary=frame | PS绘制标注的640×360预览 |
| /debug.jpg | JPEG；未就绪503 | 最新960×360六宫格，最多1Hz |
| /result.json | JSON，Cache-Control:no-store | 最新识别结果和control，HTTP层添加server_age_ms |

启动尚无结果时/result.json可能只有server_age_ms=null。收到200不代表数据有效。
这是“最新值”接口，不是帧队列、WebSocket或事件历史。每次请求可能拿到相同frame_id。
建议控制轮询50..100ms，轮询不能提高约5.2Hz的实测识别更新率。
预览JPEG和debug有各自刷新节拍，不能按收到图片时间代替控制数据的新鲜度。

## control关键字段

| 字段 | 含义 |
|---|---|
| schema | gesture-control-v1 |
| frame_id | 本次运行单调递增整数；新运行重新从1开始 |
| sample_monotonic_s | 板端单调时钟，不是UTC、不可与PC时钟直接相减 |
| valid / reason | 本帧是否可用：OK或NO_HAND、FRAME_EDGE、FRAME_GAP、ERROR、COORDINATES |
| direction | 平滑与滞回后的LEFT/RIGHT/UP/DOWN/IDLE，游戏移动使用这个字段 |
| raw_direction | 未平滑方向，仅供调试 |
| u、v / smooth_uv | 原始/平滑归一化位置，中心附近为0；u右为正，v下为正 |
| enter / release | 进入阈值0.36、退出阈值0.24，减少中心附近抖动 |
| timeout_ms | 默认1200ms，客户端必须自主失效保护 |
| action_event_seq | 每次有效张掌→握拳事件递增，用于去重；不是移动方向计数 |
| action_event / action_kind | 当帧事件布尔值；HEURISTIC_OPEN_TO_FIST，仅启发式候选 |

外层run_id区分运行实例，server_age_ms表示服务器自最近结果发布经过的时间。
坐标基于已经旋转/镜像后的640×360视图：左上角(0,0)，x向右、y向下。质心为“选中轮廓内肤色像素面积中心”，不是手掌中心。
direction只选主轴，绝对值相等优先水平，不同时产生两个方向。游戏若采用y向上坐标，UP须由游戏层映射为正y。

## 必须落实的安全策略

1. valid!=true、方向非法、缺字段、HTTP失败、JSON失败立即停止移动并释放所有旧方向。
2. server_age_ms缺失/非有限或大于1200ms时拒绝数据。相同frame_id不能刷新本地“新帧到达”计时器。
3. 即使网络持续返回旧JSON，本地超过1200ms未收到新帧也必须停止。网络计时使用客户端自己的单调时钟。
4. 每次新方向先清除旧方向，再设置新状态；IDLE保持不动。游戏每渲染帧按deltaTime持续移动，不要仅在轮询时挪一下。
5. 初次连接、重连、run_id改变时只记住当前action_event_seq作为基线，不补发旧动作。只有已建立连续新鲜连接后seq增长才触发一次。
6. seq增长超过1不证明拥有完整事件历史；不要补播多个旧动作。贴边/丢手也应取消动作准备状态。
7. 不要把RPS_CANDIDATE/稳定标签当成已完成准确率验收的可靠游戏指令，先联调默认方向，再决定握拳事件用途。

现有dashboard已实现练习场的部分失效保护，可参考其代码；examples/control_receiver.py展示标准库轮询与事件基线，不包含游戏SDK或键盘注入。

## 跨域、网络和部署

服务未提供CORS头、认证、TLS。游戏网页在另一个域/端口访问JSON可能被浏览器拒绝；HTTPS网页请求HTTP还可能被混合内容策略阻止。
推荐游戏后端/本机服务请求板端，再将/result.json代理为游戏网页的同源接口。仅设置fetch的no-cors拿不到可解析JSON。
MJPEG用于画面，控制接口独立轮询。USB供电不保证PC具备到192.168.2.99的网络路由；当前已跑通网络保持不变。
不要把这个服务暴露到公网。联调前双方明确角色速度、方向坐标和动作用途。
