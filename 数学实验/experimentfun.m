% 读取图像
image = imread('D:\限速图片集\60-4.png');
grayImage = rgb2gray(image); % 转换为灰度图
bwImage = imbinarize(grayImage); % 二值化

% 准备多个模板
templates = {'D:\限速图片集\5-3.png', 'D:\限速图片集\10-1.png', 'D:\限速图片集\20-1.png', 'D:\限速图片集\40-2.png', 'D:\限速图片集\60-1.png', 'D:\限速图片集\100-2.png', 'D:\限速图片集\120-1.png'}; % 模板文件名列表
templateValues = [5, 10, 20, 40, 60,100,120]; % 与模板对应的速度值
numTemplates = length(templates);
highestCorr = 0;
detectedValue = 0;

% 循环处理每个模板
for i = 1:numTemplates
    % 读取并预处理模板
    template = imread(templates{i});
    template = imbinarize(rgb2gray(template)); % 转换为二值图

    % 确保模板尺寸小于原图像尺寸
    if any(size(template) > size(bwImage))
        scaleFactor = min(size(bwImage) ./ size(template));
        template = imresize(template, scaleFactor); % 调整模板尺寸
    end
    % 确保原图像大于模板图像
    if any(size(template) > size(bwImage))
     % 计算缩放因子
        scaleFactor = min(size(bwImage) ./ size(template));
        % 缩放模板图像
        template = imresize(template, scaleFactor);
    end
    % 模板匹配
    corrMap = normxcorr2(template, bwImage);
    maxCorr = max(corrMap(:));

   % 检查是否为最佳匹配
    if maxCorr > highestCorr
        highestCorr = maxCorr;
        detectedValue = templateValues(i);
        [yPeak, xPeak] = find(corrMap == maxCorr, 1); % 寻找最大相关性的位置

        % 计算模板在原图像中的位置
        yoff = yPeak - size(template, 1) + 1;
        xoff = xPeak - size(template, 2) + 1;

        % 记录用于绘制矩形框的位置
        detectedPosition = [xoff, yoff, size(template, 2), size(template, 1)];
    end
end

% 显示检测结果
if detectedValue > 0
    figure; imshow(image); hold on;
    rectangle('Position', detectedPosition, 'EdgeColor', 'r', 'LineWidth', 2);
    title(['Detected Speed Limit: ', num2str(detectedValue)]);
else
    disp('No speed limit sign detected');
end