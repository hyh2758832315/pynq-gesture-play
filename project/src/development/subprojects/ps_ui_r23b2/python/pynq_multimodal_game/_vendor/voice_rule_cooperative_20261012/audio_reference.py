# -*- coding: utf-8 -*-
"""
audio_reference.py —— 音频 Python 参考模型 V3.5.7（单用户 golden model）

修订记录（2026-09-26，依据外部评审 + 实测重扫）：
  V2.0 -> V3.0
  [P0-1] 参数不再硬编码，改为读取 audio_config.json（唯一参数源）
  [P0-2] 特征正名为"高频幅度占比"（|X| 谱 L1 和占比）。经 23 文件实测，
        幅度占比 vs 功率占比(|X|^2)：幅度占比分离性显著更优，保留为主特征。
  [P0-3] 自相关置信度改为标准归一化 Q[k]=R[k]^2/(E1[k]*E2[k])
  [P0-4] FIR 由非因果 mode="same" 改为因果流式实现
  [P0-5] 能量字段明确为 mean-square power = sum(x^2)/N
  [P0-6] 采样率 != 48kHz 直接报错
  [P0-7] 双声道选 RMS 更大的声道
  [P1-1] 护盾/攻击状态机改为整数窗计数
  [P1-2] 攻击确认拆分为 high_run + rise_seen
  [P1-3] voiced 不再把精确 f0 作为硬分类条件
  [P1-4] 修复注释中 15%/34% 不一致
  [P1-5] 阈值重扫：low_hi_max=0.10, high_hi_min=0.32, high_power_min=2e-5

  V3.0 -> V3.1
  [P1-6] 新增攻击"起音窗自相关质量上限" q_cap=0.80（说话误攻击 3→0）

  V3.1 -> V3.2（外部评审第二轮）
  [P2-1] 新增 high_armed 单次布防，修复持续高音重复攻击
  [P2-2] q_cap 语义明确为起音窗门限（rise_q_ok）
  [P2-3] 冷却语义明确（事件窗不计入冷却，从下一窗完整持续）
  [P2-4] 配置合法性校验、无声窗 pitch_lag=0、CSV 增加 window_time_ms

  V3.2 -> V3.3（外部评审第三轮）
  [P3-1] 冷却计数修复：事件所在窗口不消耗新设置的计数（cooling 快照），
        实际阻塞完整 refract_w 窗（t+1..t+W 禁止，t+W+1 允许）。
  [P3-2] rise_q_ok 改为锁存式（候选段内任一 rise 窗满足 q_cap 即成立），
        后续 rise 不再覆盖之前的成功。
  [P3-3] shield_on_windows/shield_off_windows 加入 REQUIRED_CFG 并做一致性
        校验（毫秒换算 ceil 必须等于窗口数字段，方案B）。
  [P3-4] q_cap 支持 null 表示"关闭规则"（真正关闭，而非 1.0 近似）。
  [P3-5] 新增 high_rearm_gap_windows：候选段连续失效 N 窗后才重新布防，
        避免噪声把同一个音短暂掉窗后拆成两段重复触发。
  [P3-6] CSV 时间戳拆为 start / center / data_ready；V3.4.0 起 ready
        明确定义为最后一个8k样本所对应的48k输入采样时刻，并输出原始采样索引。
  [P3-7] load_wav 修复 24-bit 多声道读取（reshape(n,ch,3) 逐通道组装），
        并校验 ch<=0。
  [P3-8] 自相关质量 q 显式限制到 [0,1]。

  V3.3 -> V3.3.1（外部评审第三轮·规格对齐修订，2026-09-26）
  [S1] 可调参数补全入 JSON：dc_block_a / fft_window / autocorr_eps /
       spectrum_eps。JSON 为唯一参数源：所有可调判决参数来自 JSON，
       数学实现常量固定在代码版本中。
  [S2] rise 起音判据改进：要求 power >= high_power_min，且
       (prev_power < power_min 或 power >= prev_power*onset_ratio)。
       不再用 prev_power>0 作为有效历史帧判据（避免极小功率噪声
       被算作起音）。
  [S2b] rise 进一步要求 q >= q_min（有声）：无周期性的摩擦/爆破音
        （q<=q_min，如 speech_07 的 q=0.115 弱 rise 窗）不算有效起音，
        不得锁存 rise_q_ok。这是换 Kaiser FIR 后说话误攻 2→0 的关键。
  V3.3.1 -> V3.3.2（外部评审第四轮·规格冻结审计，2026-09-26）
  [A1] 版本/文档全链统一为 V3.3.2；threshold_scan_note 更新为
       q_cap=0.52 与可行区间结论（旧 0.60 窄桥结论基于首 rise 窗分布，
       已用完整 rise 窗分布推翻：可行区间 0.44~0.60，取中心 0.52）。
  [A2] FIR 规格表述诚实化：fir_stop_db=60 是 Kaiser β 设计目标
       （β=0.1102*(60-8.7)=5.65），实测阻带（4k~8k）最大 74.2dB 为
       盈余结果；fir_stop_hz=4000 为阻带验证起点，不参与设计
       （设计由 fc + stop_db + taps 决定）。配置新增
       fir_passband_hz=3200 / fir_stopband_hz=4000 / fir_stop_db_measured=74.2
       说明字段。
  [A3] 补充冷却+rearm 组合边界单元测试（H 用例），单测 8/8。

  V3.3.2 -> V3.4.0（FPGA 冻结前一致性修订，2026-09-27）
  [F1] 状态机抽为 detector_step，主模型/扫描/单测共用唯一实现。
  [F2] 重新布防要求连续 unvoiced release 且冷却结束，单个发声不连发。
  [F3] q_min 全链统一为 >=；CSV 改为显式 8k/48k 坐标和数据就绪时刻。
  [F4] hi_first_bin 与频率参数强一致性校验，帧特征直接使用冻结 bin。
  [F5] 攻击改为四个相隔32采样的交错帧相位，16ms内至少2票；q_cap=0.60。

  V3.4.0 -> V3.5.0（单用户重新标定，2026-09-27）
  [C1] 新标定集为10个“啊”、10个“哦”、普通说话、噪声与静音；固定网格扫描
       选定 high_hi_min=0.50、high_power_min=1e-5，保留四相2票和q_cap=0.60。
       本版本明确只对该用户/该录音链路有效，换用户或硬件需重新标定。
  V3.5.0 -> V3.5.1（新增音乐/喊叫负样本，2026-09-27）
  [C2] 维持高频门限0.50和四相2票；high_power_min=2e-5、q_cap=0.75
       将新增负样本下攻击误触3→2，命令召回仍为10/10。剩余音乐/喊叫
       误触证明需新增特征，不以牺牲召回的静态阈值掩盖问题。
  V3.5.1 -> V3.5.2（音乐负样本特征补强，2026-09-27）
  [C3] 攻击候选新增 ZCR 上限0.40。music 候选 ZCR=0.45~0.46，而10个真实
       “啊”候选最大为0.39；该特征已在原链路计算，PL 只需比较器。
  V3.5.2 -> V3.5.3（长喊叫负样本特征补强，2026-09-27）
  [C4] 攻击候选新增基频上限400Hz。长喊叫候选为444~471Hz，真实“啊”候选最大
       为347.8Hz。PL 侧无需计算 Hz：以 autocorr best_lag >= ceil(8000/400)=20 比较。
  V3.5.3 -> V3.5.5（连续音乐/吹气混音抑制，2026-09-27）
  [C5] 攻击候选新增80~500Hz低频幅度占比上限0.10；PL只需累加FFT bin6..32。
  [C6] 试验q_cap=0.60可拦截一处吹气误触，但原标定攻击召回降至6/10，
       因而拒绝；保持q_cap=0.75，以命令召回为不可退让约束。
  V3.5.5 -> V3.5.6（混音人工标注修订，2026-09-27）
  [C7] 15.496秒事件由用户确认属于音乐；low_ratio上限由0.10收紧至0.09。
  V3.5.6 -> V3.5.7（长“啊”混音负样本抑制，2026-09-27）
  [C8] 攻击候选增加hi_ratio上限0.80；长“啊”起音为81.9%，15个短“啊”最大77.2%。

链路: 48k WAV -> DC去除 -> 因果Kaiser FIR低通(fc=3600Hz,1201tap,
      设计目标60dB/β=5.65，实测阻带4k~8k最大74.2dB)
     -> 6倍抽取至8k -> 512窗；护盾128步，攻击四相32步取特征
     -> power/ZCR/自相关质量/高频幅度占比
     -> 四相候选投票状态机（q>=q_min；q_cap=0.75；2/4票）

用法: py -3.9 audio_reference.py <输入.wav> <输出.csv> [config.json]
"""
import sys
import os
import json
import wave
import struct
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(HERE, ".."))
_CFG_CANDIDATES = [
    os.path.join(HERE, "audio_config.json"),       # 独立发布包
    os.path.join(PROJECT_ROOT, "config", "audio_config.json"),
]
DEFAULT_CFG = next((p for p in _CFG_CANDIDATES if os.path.exists(p)),
                   _CFG_CANDIDATES[-1])

REQUIRED_CFG = [
    "fs_input", "fs_processed", "win", "hop", "hi_freq_cut_hz",
    "low_hi_max", "high_hi_min", "attack_hi_ratio_max", "attack_zcr_max", "attack_pitch_max_hz", "attack_low_ratio_max", "power_min", "high_power_min", "q_min",
    "q_cap", "low_band_hz", "shield_on_ms", "shield_off_ms",
    "shield_on_windows", "shield_off_windows", "high_rearm_gap_windows",
    "high_rearm_release", "high_rearm_after_cooldown",
    "high_pre_silence_windows",
    "high_onset_max_windows",
    "feature_stride", "attack_phase_count", "attack_votes_required",
    "attack_vote_span_samples",
    "onset_ratio", "onset_confirm", "high_refract_ms",
    "fir_fc_hz", "fir_taps", "fir_window", "fir_stop_hz", "fir_stop_db",
    "dc_block_a", "fft_window", "autocorr_eps", "spectrum_eps",
    "fir_passband_hz", "fir_stopband_hz", "fir_stopband_end_hz",
    "fir_stop_db_measured", "hi_first_bin",
]


def validate_config(cfg):
    """配置合法性校验（与 FPGA 移植前置条件一致）"""
    if cfg["fs_input"] % cfg["fs_processed"] != 0:
        raise ValueError("fs_input must be integer multiple of fs_processed: %d %% %d"
                         % (cfg["fs_input"], cfg["fs_processed"]))
    if cfg["fir_taps"] % 2 != 1:
        raise ValueError("fir_taps must be odd (linear-phase FIR)")
    if not (cfg["win"] > 0 and cfg["hop"] > 0 and cfg["hop"] <= cfg["win"]):
        raise ValueError("win/hop invalid: win=%s hop=%s" % (cfg["win"], cfg["hop"]))
    if int(cfg["onset_confirm"]) < 1:
        raise ValueError("onset_confirm must be >= 1")
    # q_cap 可为 null（关闭规则）或 [0,1] 数值
    if cfg["q_cap"] is not None:
        cfg["q_cap"] = float(cfg["q_cap"])
        if not (0.0 <= cfg["q_cap"] <= 1.0):
            raise ValueError("q_cap must be in [0,1] or null, got %r" % cfg["q_cap"])
    # shield 窗口数与毫秒一致性（方案B：毫秒为源，窗口数字段做校验）
    hop_ms = cfg["hop"] / cfg["fs_processed"] * 1000.0
    on_calc = int(np.ceil(cfg["shield_on_ms"] / hop_ms))
    off_calc = int(np.ceil(cfg["shield_off_ms"] / hop_ms))
    if int(cfg["shield_on_windows"]) != on_calc:
        raise ValueError("shield_on_windows=%s inconsistent with shield_on_ms=%s (calc=%d)"
                         % (cfg["shield_on_windows"], cfg["shield_on_ms"], on_calc))
    if int(cfg["shield_off_windows"]) != off_calc:
        raise ValueError("shield_off_windows=%s inconsistent with shield_off_ms=%s (calc=%d)"
                         % (cfg["shield_off_windows"], cfg["shield_off_ms"], off_calc))
    if int(cfg["shield_on_windows"]) < 1 or int(cfg["shield_off_windows"]) < 1:
        raise ValueError("shield windows must be >= 1")
    if int(cfg["high_rearm_gap_windows"]) < 1:
        raise ValueError("high_rearm_gap_windows must be >= 1")
    if int(cfg["high_pre_silence_windows"]) < 1:
        raise ValueError("high_pre_silence_windows must be >= 1")
    if int(cfg["high_onset_max_windows"]) < int(cfg["onset_confirm"]):
        raise ValueError("high_onset_max_windows must be >= onset_confirm")
    if int(cfg["feature_stride"]) * int(cfg["attack_phase_count"]) != int(cfg["hop"]):
        raise ValueError("feature_stride * attack_phase_count must equal hop")
    if not (1 <= int(cfg["attack_votes_required"]) <= int(cfg["attack_phase_count"])):
        raise ValueError("attack_votes_required out of range")
    if int(cfg["attack_vote_span_samples"]) < int(cfg["feature_stride"]):
        raise ValueError("attack_vote_span_samples too small")
    if cfg["high_rearm_release"] not in ("unvoiced", "not_in_high"):
        raise ValueError("high_rearm_release must be unvoiced/not_in_high")
    if not isinstance(cfg["high_rearm_after_cooldown"], bool):
        raise ValueError("high_rearm_after_cooldown must be boolean")
    if not (0.0 <= float(cfg["q_min"]) <= 1.0):
        raise ValueError("q_min must be in [0,1]")
    if not (0.0 <= float(cfg["low_hi_max"]) < float(cfg["high_hi_min"]) <= 1.0):
        raise ValueError("require 0 <= low_hi_max < high_hi_min <= 1")
    if not (0.0 <= float(cfg["attack_zcr_max"]) <= 1.0):
        raise ValueError("attack_zcr_max must be in [0,1]")
    if not (0.0 < float(cfg["attack_pitch_max_hz"]) <= cfg["fs_processed"] / 2.0):
        raise ValueError("attack_pitch_max_hz must be in (0, processed Nyquist]")
    if not (0.0 <= float(cfg["attack_low_ratio_max"]) <= 1.0):
        raise ValueError("attack_low_ratio_max must be in [0,1]")
    if not (float(cfg["high_hi_min"]) <= float(cfg["attack_hi_ratio_max"]) <= 1.0):
        raise ValueError("attack_hi_ratio_max must be in [high_hi_min,1]")
    if not (0.0 <= float(cfg["power_min"]) <= float(cfg["high_power_min"])):
        raise ValueError("require 0 <= power_min <= high_power_min")
    if not (0.0 < float(cfg["dc_block_a"]) < 1.0):
        raise ValueError("dc_block_a must be in (0,1)")
    if cfg["fft_window"] not in ("hamming", "hann", "none"):
        raise ValueError("fft_window must be hamming/hann/none")
    if cfg["fir_window"] not in ("hamming", "hann", "kaiser"):
        raise ValueError("fir_window must be hamming/hann/kaiser")
    if float(cfg["autocorr_eps"]) <= 0 or float(cfg["spectrum_eps"]) <= 0:
        raise ValueError("eps must be > 0")
    if cfg["fir_window"] == "kaiser":
        if not (float(cfg["fir_stop_hz"]) > float(cfg["fir_fc_hz"])):
            raise ValueError("fir_stop_hz must be > fir_fc_hz")
        if not (20 <= float(cfg["fir_stop_db"]) <= 120):
            raise ValueError("fir_stop_db out of range")
    # FIR 验证规格一致性（P1-6）：passband < stopband < 输入 Nyquist；
    # fir_stop_hz 为兼容别名（设计后阻带验证起点），必须与 fir_stopband_hz 相等，
    # 防止两个字段漂移；measured 不能低于设计目标。
    if not (0.0 < float(cfg["fir_passband_hz"]) < float(cfg["fir_stopband_hz"])):
        raise ValueError("fir_passband_hz must be < fir_stopband_hz: %s < %s"
                         % (cfg["fir_passband_hz"], cfg["fir_stopband_hz"]))
    if not (float(cfg["fir_stopband_hz"]) < cfg["fs_input"] / 2.0):
        raise ValueError("fir_stopband_hz must be < fs_input/2 (Nyquist): %s < %s"
                         % (cfg["fir_stopband_hz"], cfg["fs_input"] / 2.0))
    if not (float(cfg["fir_stopband_hz"]) < float(cfg["fir_stopband_end_hz"])
            <= cfg["fs_input"] / 2.0):
        raise ValueError("fir_stopband_end_hz must be in (stopband, Nyquist]")
    if float(cfg["fir_stop_hz"]) != float(cfg["fir_stopband_hz"]):
        raise ValueError("fir_stop_hz=%s inconsistent with fir_stopband_hz=%s"
                         % (cfg["fir_stop_hz"], cfg["fir_stopband_hz"]))
    if float(cfg["fir_stop_db_measured"]) < float(cfg["fir_stop_db"]):
        raise ValueError("fir_stop_db_measured=%s below design target %s"
                         % (cfg["fir_stop_db_measured"], cfg["fir_stop_db"]))
    # hi_first_bin 规格（P1-10）：1200Hz 在 8k/512 FFT 下 searchsorted(side=left)
    # -> bin 77 = 1203.125Hz。FPGA 必须从 bin 77 累加，与参考模型一致。
    expected_bin = int(np.searchsorted(
        np.fft.rfftfreq(int(cfg["win"]), 1.0 / float(cfg["fs_processed"])),
        float(cfg["hi_freq_cut_hz"]), side="left"))
    if int(cfg["hi_first_bin"]) != expected_bin:
        raise ValueError("hi_first_bin=%s inconsistent with hi_freq_cut_hz=%s (expected %d)"
                         % (cfg["hi_first_bin"], cfg["hi_freq_cut_hz"], expected_bin))
    return cfg


def load_config(path):
    with open(path, "r", encoding="utf-8") as f:
        cfg = json.load(f)
    for key in REQUIRED_CFG:
        if key not in cfg:
            raise KeyError("config missing field: %s (%s)" % (key, path))
    return validate_config(cfg)


def load_wav(path):
    with wave.open(path, "rb") as w:
        sr = w.getframerate()
        ch = w.getnchannels()
        sw = w.getsampwidth()
        n = w.getnframes()
        raw = w.readframes(n)
    if ch <= 0:
        raise ValueError("invalid channel count %d (%s)" % (ch, path))
    if sw == 2:
        m = np.array(struct.unpack("<%dh" % (n * ch), raw),
                     dtype=np.int16).astype(np.float64) / 32768.0
        m = m.reshape(n, ch)
    elif sw == 3:
        # 24-bit 每声道 3 字节（小端），交错排列 L0 R0 L1 R1 ...
        d = np.frombuffer(raw, dtype=np.uint8).reshape(n, ch, 3).astype(np.int32)
        m = (d[:, :, 0] | (d[:, :, 1] << 8) | (d[:, :, 2] << 16))
        m = np.where(m >= 0x800000, m - 0x1000000, m).astype(np.float64) / 8388608.0
    else:
        raise ValueError("unsupported sampwidth %d" % sw)
    if ch > 1:
        rms = np.sqrt(np.mean(m ** 2, axis=0))
        m = m[:, int(np.argmax(rms))]   # 选能量更大的声道
    else:
        m = m[:, 0]
    return m, sr


def dc_blocker(x, a):
    y = np.empty_like(x)
    acc = 0.0
    for i in range(len(x)):
        acc = x[i] - (x[i - 1] if i > 0 else 0.0) + a * acc
        y[i] = acc
    return y


def _i0(x):
    """修正贝塞尔 I0，向量化级数求和（Kaiser 窗用）"""
    x = np.asarray(x, dtype=float)
    s = np.ones_like(x)
    t = np.ones_like(x)
    xh = x / 2.0
    for k in range(1, 61):
        t = t * (xh / k) ** 2
        s = s + t
    return s


def design_fir(fc, fs, taps, window="hamming", stop_hz=None, stop_db=None):
    n = np.arange(taps) - (taps - 1) / 2
    if window == "kaiser":
        # 设计参数语义（与 config 对齐）：
        #   fc = sinc 截止 = 通带/阻带过渡带几何中点（-6dB 点），唯一参与
        #       滤波器主体设计的频率参数；
        #   stop_db = Kaiser 阻带衰减设计目标，决定 β=0.1102*(stop_db-8.7)，
        #       参与窗函数设计；当前配置 stop_db=60 → β≈5.65；
        #   stop_hz = 阻带验证起点（4000Hz=抽取 Nyquist），仅用于设计后
        #       校验/文档，不参与本函数设计。实测 4k~8k 阻带最大 74.2dB
        #       （优于 60dB 设计目标，属长阶数盈余）。
        beta = 0.1102 * (float(stop_db) - 8.7)
        w = _i0(beta * np.sqrt(np.maximum(0.0, 1.0 - (2 * n / (taps - 1)) ** 2)))
        w = w / _i0(beta)
        h = np.sinc(2 * fc / fs * n) * (2 * fc / fs) * w
    else:
        h = np.sinc(2 * fc / fs * n) * (2 * fc / fs)
        if window == "hamming":
            h *= np.hamming(taps)
        elif window == "hann":
            h *= np.hanning(taps)
    h /= h.sum()
    return h


def fir_causal(x, h):
    """因果流式 FIR（算法语义 = y[i]=sum_j h[j]*x[i-j]，不使用未来样本）：
    本实现用 FFT 卷积加速离线参考计算（1201tap 直接卷积过慢），
    输出与直接因果卷积一致（误差 ~1e-16，已实测）。
    FPGA 侧不采用 FFT 卷积，而用 6 相多相抽取 FIR：
    每个 8kHz 输出需要全部 1201 个系数贡献：约 9.608M MAC/s；若利用
    对称系数预加，可降到约 601 次乘法/输出（4.808M mul/s）。六相中的
    每相约 200 taps 不是总工作量。系数与抽取相位必须与本文件 x[::6]
    （相位 0）严格一致。
    """
    taps = len(h)
    xp = np.concatenate([np.zeros(taps - 1), x])
    nfft = 1 << int(np.ceil(np.log2(len(xp) + len(h) - 1)))
    y = np.fft.irfft(np.fft.rfft(xp, nfft) * np.fft.rfft(h, nfft), nfft)
    return y[taps - 1:taps - 1 + len(x)]


def autocorr_confidence(w, kmin, kmax, eps):
    """标准归一化自相关 Q[k] = R[k]^2/(E1[k]*E2[k])"""
    best_q = 0.0
    best_k = kmin
    for k in range(kmin, kmax + 1):
        a = w[k:]
        b = w[:-k]
        rk = float(np.dot(a, b))
        e1 = float(np.dot(a, a))
        e2 = float(np.dot(b, b))
        q = (rk * rk) / (e1 * e2 + eps) if (rk > 0 and e1 > eps and e2 > eps) else 0.0
        if q > best_q:
            best_q = q
            best_k = k
    return best_k, best_q


def frame_feature(w, cfg):
    """单窗特征: power, zcr, best_lag, f0, quality, 高频/低频幅度占比。"""
    fs = cfg["fs_processed"]
    w = w - w.mean()
    e0 = float(np.dot(w, w))
    n = len(w)
    power = e0 / n                       # mean-square power
    zcr = float(np.mean(np.abs(np.diff(np.sign(w)))) / 2) if n > 1 else 0.0
    fmin, fmax = cfg["low_band_hz"][0], cfg["low_band_hz"][1]
    kmin = int(fs / fmax)
    kmax = int(fs / fmin)
    best_k, q = autocorr_confidence(w, max(kmin, 1), min(kmax, n - 1),
                                    float(cfg["autocorr_eps"]))
    q = min(1.0, max(0.0, q))          # 显式限制到 [0,1]，防浮点越界
    pitch_valid = q >= float(cfg["q_min"])   # q_min 边界统一为 >=（达到门限即有效）
    if not pitch_valid:
        best_k = 0                      # 低质量/无声窗不输出虚假基频滞后
    f0 = fs / best_k if pitch_valid else 0.0
    # 高频幅度占比：|X| 谱，>hi_freq_cut_hz 频段幅度和 / 全频幅度和
    win_t = cfg["fft_window"]
    wdw = (np.hamming(n) if win_t == "hamming"
           else np.hanning(n) if win_t == "hann" else np.ones(n))
    sp = np.abs(np.fft.rfft(w * wdw))
    cut = int(cfg["hi_first_bin"])
    tot = float(sp.sum())
    hi = float(sp[cut:].sum())
    hi_ratio = hi / tot if tot > float(cfg["spectrum_eps"]) else 0.0
    # 低频占比用 80~500Hz，对音乐中的低频伴奏/鼓点有抑制作用；使用幅度 L1
    # 而非功率，确保与 hi_ratio 和 PL 的 FFT 分带累加实现完全一致。
    low_first = int(np.ceil(float(cfg["low_band_hz"][0]) * n / fs))
    low_last = int(np.floor(float(cfg["low_band_hz"][1]) * n / fs))
    low = float(sp[low_first:low_last + 1].sum())
    low_ratio = low / tot if tot > float(cfg["spectrum_eps"]) else 0.0
    return power, zcr, best_k, f0, q, hi_ratio, low_ratio, pitch_valid


def initial_detector_state():
    """创建连续流检测器状态；PL 上电或显式复位时与此状态一致。"""
    return {
        "low_good": 0, "low_bad": 0, "low_active": 0,
        "high_run": 0, "high_gap": 0,
        "rise_seen": False, "rise_q_ok": False,
        "utterance_age": 0, "unvoiced_run": 0,
        "high_armed": True, "refract": 0,
        "prev_power": 0.0,
    }


def detector_step(power, q, hi, state, cfg, refract_w=None, zcr=0.0, pitch_hz=0.0,
                  low_ratio=0.0):
    """单窗状态机唯一实现，供主模型、阈值扫描和单元测试共同调用。"""
    if refract_w is None:
        hop_ms = cfg["hop"] / cfg["fs_processed"] * 1000.0
        refract_w = int(np.ceil(cfg["high_refract_ms"] / hop_ms))
    on_count = int(cfg["shield_on_windows"])
    off_count = int(cfg["shield_off_windows"])
    rearm_gap = int(cfg["high_rearm_gap_windows"])
    q_cap = cfg.get("q_cap")

    voiced = (power > cfg["power_min"]) and (q >= cfg["q_min"])
    in_low = voiced and (hi < cfg["low_hi_max"])
    pitch_ok = pitch_hz <= 0.0 or pitch_hz <= cfg["attack_pitch_max_hz"]
    in_high = (voiced and power > cfg["high_power_min"]
               and hi >= cfg["high_hi_min"]
               and hi <= cfg["attack_hi_ratio_max"]
               and zcr <= cfg["attack_zcr_max"] and pitch_ok
               and low_ratio <= cfg["attack_low_ratio_max"])

    if in_low:
        state["low_good"] = min(state["low_good"] + 1, on_count)
        state["low_bad"] = 0
    else:
        state["low_bad"] = min(state["low_bad"] + 1, off_count)
        state["low_good"] = 0
    if not state["low_active"] and state["low_good"] >= on_count:
        state["low_active"] = 1
    if state["low_active"] and state["low_bad"] >= off_count:
        state["low_active"] = 0

    prior_unvoiced = state["unvoiced_run"]
    if voiced:
        if prior_unvoiced >= int(cfg["high_pre_silence_windows"]):
            state["utterance_age"] = 1
        elif state["utterance_age"] > 0:
            state["utterance_age"] += 1
        state["unvoiced_run"] = 0
    else:
        state["unvoiced_run"] += 1
        if state["unvoiced_run"] >= int(cfg["high_pre_silence_windows"]):
            state["utterance_age"] = 0
        elif state["utterance_age"] > 0:
            state["utterance_age"] += 1
    onset_gate_ok = (0 < state["utterance_age"]
                     <= int(cfg["high_onset_max_windows"]))

    # 冷却快照：事件窗不消耗新装入的计数，t+1..t+W 完整阻塞。
    cooling = state["refract"] > 0
    rise = (power >= cfg["high_power_min"] and q >= cfg["q_min"]
            and (state["prev_power"] < cfg["power_min"]
                 or power >= state["prev_power"] * cfg["onset_ratio"]))
    high_event = 0
    if in_high:
        state["high_run"] += 1
        if rise:
            state["rise_seen"] = True
            state["rise_q_ok"] = state["rise_q_ok"] or (
                True if q_cap is None else (q < float(q_cap)))
        if (state["high_armed"]
                and state["high_run"] >= int(cfg["onset_confirm"])
                and state["rise_seen"] and state["rise_q_ok"]
                and onset_gate_ok and not cooling):
            high_event = 1
            state["high_armed"] = False
            state["refract"] = refract_w
    else:
        state["high_run"] = 0
        state["rise_seen"] = False
        state["rise_q_ok"] = False

    # 单事件语义：重新布防要求明确 release；默认 release=unvoiced，避免同一
    # 发声因 hi_ratio 抖动被切成两段。默认还要求冷却已结束。
    release = (not voiced if cfg["high_rearm_release"] == "unvoiced"
               else not in_high)
    if release:
        state["high_gap"] += 1
    else:
        state["high_gap"] = 0
    can_rearm = (not cfg["high_rearm_after_cooldown"] or not cooling)
    if state["high_gap"] >= rearm_gap and can_rearm:
        state["high_armed"] = True

    if not high_event and state["refract"] > 0:
        state["refract"] -= 1
    state["prev_power"] = power
    return {
        "voiced": int(voiced), "in_low": int(in_low), "in_high": int(in_high),
        "rise": int(rise), "low_active": int(state["low_active"]),
        "high_event": high_event, "rise_q_ok": int(state["rise_q_ok"]),
        "high_run": state["high_run"], "high_gap": state["high_gap"],
        "onset_gate_ok": int(onset_gate_ok),
        "utterance_age": state["utterance_age"],
        "high_armed": int(state["high_armed"]), "refract": state["refract"],
    }


class MultiphaseDetector:
    """四相攻击候选投票；每相内部仍按 512窗/128步运行。"""
    def __init__(self, cfg):
        self.cfg = cfg
        self.stride = int(cfg["feature_stride"])
        self.phase_count = int(cfg["attack_phase_count"])
        self.states = [initial_detector_state() for _ in range(self.phase_count)]
        self.votes = []
        self.global_refract = 0
        stride_ms = self.stride / cfg["fs_processed"] * 1000.0
        phase_hop_ms = cfg["hop"] / cfg["fs_processed"] * 1000.0
        # 保持旧语义：相位候选事件后的 W 个16ms窗阻塞，下一窗才允许。
        allow_after_ms = (int(np.ceil(cfg["high_refract_ms"] / phase_hop_ms)) + 1) * phase_hop_ms
        self.global_refract_w = int(np.ceil(allow_after_ms / stride_ms)) - 1
        self.low_active = 0

    def step(self, start_sample_8k, power, q, hi, zcr=0.0, pitch_hz=0.0,
             low_ratio=0.0):
        phase_id = (start_sample_8k // self.stride) % self.phase_count
        local = detector_step(power, q, hi, self.states[phase_id], self.cfg,
                              zcr=zcr, pitch_hz=pitch_hz, low_ratio=low_ratio)
        if phase_id == 0:
            self.low_active = local["low_active"]

        candidate = int(local["high_event"])
        if candidate:
            self.votes.append((start_sample_8k, phase_id))
        span = int(self.cfg["attack_vote_span_samples"])
        self.votes = [(s, p) for s, p in self.votes
                      if start_sample_8k - s <= span]
        vote_count = len({p for _, p in self.votes})
        cooling = self.global_refract > 0
        high_event = 0
        if vote_count >= int(self.cfg["attack_votes_required"]) and not cooling:
            high_event = 1
            self.global_refract = self.global_refract_w
            self.votes = []
        if not high_event and self.global_refract > 0:
            self.global_refract -= 1

        result = dict(local)
        result.update({
            "phase_id": phase_id,
            "high_candidate": candidate,
            "attack_vote_count": vote_count,
            "high_event": high_event,
            "low_active": self.low_active,
            "phase_refract": local["refract"],
            "global_refract": self.global_refract,
        })
        return result


def main(wav_in, csv_out, cfg_path=None):
    cfg = load_config(cfg_path or DEFAULT_CFG)
    x, sr = load_wav(wav_in)
    if sr != cfg["fs_input"]:
        raise ValueError("unsupported sample rate %d, expected %d (%s)"
                         % (sr, cfg["fs_input"], wav_in))
    x = dc_blocker(x, float(cfg["dc_block_a"]))
    h = design_fir(cfg["fir_fc_hz"], cfg["fs_input"], cfg["fir_taps"],
                   cfg["fir_window"], float(cfg["fir_stop_hz"]),
                   float(cfg["fir_stop_db"]))
    x = fir_causal(x, h)
    x = x[::cfg["fs_input"] // cfg["fs_processed"]]  # 抽取相位 0

    win = int(cfg["win"])
    stride = int(cfg["feature_stride"])
    n_win = (len(x) - win) // stride + 1
    if n_win < 1:
        print("信号太短"); return
    detector = MultiphaseDetector(cfg)
    rows = []
    for i in range(n_win):
        start = i * stride
        w = x[start:start + win]
        power, zcr, lag, f0, q, hi, low_ratio, pitch_valid = frame_feature(w, cfg)
        decision = detector.step(start, power, q, hi, zcr, f0, low_ratio)
        start_ms = start / cfg["fs_processed"] * 1000.0
        center_ms = (start + (win - 1) / 2.0) / cfg["fs_processed"] * 1000.0
        dec = cfg["fs_input"] // cfg["fs_processed"]
        ready_sample_48k = (start + win - 1) * dec
        ready_ms = ready_sample_48k / cfg["fs_input"] * 1000.0
        rows.append([start,
                     round(power, 12), round(zcr, 6), round(lag, 2),
                     round(f0, 2), round(q, 8), round(hi, 8), round(low_ratio, 8),
                     decision["low_active"], decision["high_event"],
                     decision["high_candidate"], decision["phase_id"],
                     decision["attack_vote_count"],
                     round(start_ms, 3), round(center_ms, 3), round(ready_ms, 3),
                     ready_sample_48k, int(pitch_valid), decision["voiced"],
                     decision["in_low"], decision["in_high"], decision["rise"],
                     decision["rise_q_ok"], decision["high_run"], decision["high_gap"],
                     decision["onset_gate_ok"], decision["utterance_age"],
                     decision["high_armed"], decision["phase_refract"],
                     decision["global_refract"]])

    with open(csv_out, "w", newline="", encoding="utf-8") as fh:
        fh.write("window_start_sample_8k,power,zcr,pitch_lag,pitch_hz,confidence,hi_ratio,low_ratio,low_active,high_event,high_candidate,attack_phase_id,attack_vote_count,window_start_ms,window_center_ms,window_data_ready_ms,input_ready_sample_48k,pitch_valid,voiced,in_low,in_high,rise,rise_q_ok,high_run,high_gap,onset_gate_ok,utterance_age,high_armed,phase_refract,global_refract\n")
        for r in rows:
            fh.write(",".join(str(v) for v in r) + "\n")
    print(csv_out, "写入", len(rows), "窗")


if __name__ == "__main__":
    args = sys.argv[1:]
    cfg_arg = args[2] if len(args) > 2 else None
    main(args[0], args[1], cfg_arg)
