%% visualize_inference.m — 直观展示 baseline 模型的推理全链路
%  输入: data/models/model_params.mat (由 tools/export_model_mat.py 导出)
%  内容: 5 类动作各取一个 200ms 窗口, 逐行显示
%        [原始 8 通道波形 | 40 维特征 | 两层隐藏层激活 | 输出概率]
%  输出: report/figures/model_inference_matlab.png + 命令行摘要
%  运行: matlab -batch "run('tools/visualize_inference.m')" (仓库根目录下)
%        或双击 build/scripts/run_inference_viz_matlab.bat

clear; clc; close all;

ROOT = fileparts(fileparts(mfilename('fullpath')));
load(fullfile(ROOT, 'data', 'models', 'model_params.mat'));  % W1..b3, scaler_*, windows, classes

classes = string(classes);
classes = reshape(classes, 1, []);
nC = numel(classes);
cn = ["放松", "张手", "握拳", "屈腕", "伸腕"];   % README 基线五类中文名

fig = figure('Name', 'sEMG baseline inference', 'Position', [40 40 1500 900], ...
             'Color', 'w');
tl = tiledlayout(fig, nC, 4, 'TileSpacing', 'compact', 'Padding', 'compact');
title(tl, 'sEMG 基线模型 (MLP 40-64-32-5) — NinaPro DB5 被试 s1（训练集未包含）', ...
      'FontWeight', 'bold');

summary = strings(nC, 1);

for k = 1:nC
    w = windows.(char(classes(k)));          % 40x8 raw codes
    feat = window_features(w);               % 1x40, 与 PL/训练定义一致
    f  = (feat - scaler_mean) ./ scaler_scale;
    a1 = max(0, f*W1 + b1);                  % 1x64
    a2 = max(0, a1*W2 + b2);                 % 1x32
    logits = a2*W3 + b3;
    p = exp(logits) ./ sum(exp(logits));     % 1x5 softmax

    % --- 1) 原始 8 通道波形 (上下 4+4 两簇) ---
    ax1 = nexttile;
    hold(ax1, 'on');
    amp = max(abs(w(:)));
    gap = max(2.5*amp, 30);                  % 组内间距随信号幅度自适应
    for c = 1:8
        off = mod(c-1,4)*gap + floor((c-1)/4)*(5*gap);
        plot(ax1, (1:40)/200*1000, w(:,c) + off, 'LineWidth', 0.5);
    end
    set(ax1, 'YTick', [1.5*gap, 6.5*gap], ...
        'YTickLabel', {'环1 近端 E03/05/06/08', '环2 远端 E09/10/14/15'}, ...
        'XLim', [0 200], 'FontSize', 8, 'TickLength', [0 0]);
    if k == nC; xlabel(ax1, '时间 (ms)', 'FontSize', 8); end
    ylabel(ax1, sprintf('%s\n原始码值', cn(k)), 'FontSize', 9, 'FontWeight', 'bold');
    title(ax1, '输入窗口：8 通道肌电 (200 ms)', 'FontSize', 9);

    % --- 2) 40 维特征 ---
    ax2 = nexttile;
    bar(ax2, feat, 1);
    set(ax2, 'YTick', [], 'FontSize', 8, 'XTick', [1 8 9 16 17 24 25 32 33 40]);
    title(ax2, '特征：[MAV 波长 能量 过零 斜率变化] \times 8 通道', 'FontSize', 9);

    % --- 3) 隐藏层激活 ---
    ax3 = nexttile;
    hold(ax3, 'on');
    plot(ax3, a1, '-',  'LineWidth', 0.8);
    plot(ax3, a2, '--', 'LineWidth', 1.4);
    set(ax3, 'YTick', [], 'FontSize', 8);
    legend(ax3, {'隐藏层1 (64 神经元)', '隐藏层2 (32 神经元)'}, ...
           'Location', 'best', 'FontSize', 7);
    title(ax3, '隐藏层激活值', 'FontSize', 9);

    % --- 4) 输出概率 ---
    ax4 = nexttile;
    barh(ax4, p, 0.6, 'FaceColor', [0.20 0.45 0.85]);
    text(ax4, p + 0.03, 1:5, compose('%.2f', p), 'FontSize', 7, 'VerticalAlignment', 'middle');
    text(ax4, repmat(1.08, 1, 5), 1:5, cellstr(cn), 'FontSize', 8, ...
         'VerticalAlignment', 'middle', 'FontWeight', 'bold');
    set(ax4, 'XLim', [0 1.45], 'XTick', 0:0.5:1, 'FontSize', 8, ...
        'YTickLabel', cn, 'YTick', 1:5, 'YDir', 'reverse', 'Box', 'off');
    [~, pi_] = max(p);
    title(ax4, sprintf('输出：%s（%.0f%%）', cn(pi_), 100*p(pi_)), 'FontSize', 9, ...
          'FontWeight', 'bold');
    ylim(ax4, [0 1.1]);

    summary(k) = sprintf('%-6s（%s）-> %-6s（%s） %.0f%%', ...
                         cn(k), classes(k), cn(pi_), classes(pi_), 100*p(pi_));
end

out_dir = fullfile(ROOT, 'report', 'figures');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end
out_png = fullfile(out_dir, 'model_inference_matlab.png');
exportgraphics(fig, out_png, 'Resolution', 120);
exportgraphics(fig, out_png, 'Resolution', 120);  % 第二次导出去掉坐标区工具栏
fprintf('saved %s\n\n', out_png);
fprintf('%s\n', join(summary, newline));

%% ---- local functions ----
function feat = window_features(w)
% 40x8 window -> 1x40 feature row [MAV WL Energy ZC SSC] x 8 channels.
% Integer definitions identical to src/rtl/emg_window_features.v and
% tools/train_baseline.py (thresholds 0).
    d  = diff(w);
    s1 = w(2:end-1,:) - w(1:end-2,:);
    s2 = w(3:end,:)   - w(2:end-1,:);
    mav    = sum(abs(w), 1);
    wl     = sum(abs(d), 1);
    energy = sum(w.^2, 1);
    zc     = sum((w(1:end-1,:) < 0) ~= (w(2:end,:) < 0), 1);
    ssc    = sum(((s1 < 0) ~= (s2 < 0)) & (abs(s1) > 0) & (abs(s2) > 0), 1);
    feat   = [mav, wl, energy, zc, ssc];
end
