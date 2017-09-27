clear;clc
%% 
BG = imread('left0_bg.png');
FB = imread('left0_bgfg.png');
% FB = imread('398940709150.png');
[rows, cols, ~] = size(BG);
% figure
% subplot(2,1,1)
% imshow(BG)
% subplot(2,1,2)
% imshow(FB)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%
diff = abs(double(FB) - double(BG));
% diff_gray = rgb2gray(uint8(diff));
% diff_sum = sum(diff, 3);
% figure
% imshow(uint8(diff))
% % saveas(gcf, 'fg.png');
% %% 
% % diff_gray(find(diff_gray > 8)) = 255;
% FG = zeros(rows, cols);
% FG(find(diff_sum > 90)) = 1;
% figure
% imshow(FG)
% %%
% se = strel('disk',8);
% FG_close = imclose(FG, se);
% FG_open = imopen(FG_close, se);
% figure
% imshow(FG_open)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BGgray = im2double(rgb2gray(BG));
FBgray = im2double(rgb2gray(FB));
% zz = load('Zig-Zag Pattern.txt')+1;
% vector64BG = zeros(1,64);
% vector64FB = zeros(1,64);
% structureBG = zeros(rows*cols, 64+2);
% structureFB = zeros(rows*cols, 64+2);
% diff = zeros(rows*cols, 64+2);

FG = zeros(rows, cols);

cnt = 1;

for i = 1 : rows-7
    for j = 1 : cols-7
        if sum(diff(i,j,:),3) > 40
            dctBG = dct2(BGgray(i:i+7,j:j+7));
            dctFB = dct2(FBgray(i:i+7,j:j+7));
            dctdiff = abs(dctBG - dctFB);
            if (sum(dctdiff(:)) - dctdiff(1,1)> 0.4)
                FG(i,j) = 1;
            end
%             if (abs(dctBG(1,2) - dctFB(1,2)) + abs(dctBG(2,1) - dctFB(2,1))) > 0.01
%             if abs(dctBG(1,2) - dctFB(1,2)) > 0.5 || abs(dctBG(2,1) - dctFB(2,1)) > 0.01
%                 FG(i,j) = 1;
%             end
        end
        
        
%         for ii = 1:8
%             for jj = 1:8
%             vector64BG(1,zz(ii,jj)) = tmpBG(ii,jj);
%             vector64FB(1,zz(ii,jj)) = tmpFB(ii,jj);
%             end
%         end
%         structureBG(cnt, :) = [i,j,vector64BG];
%         structureFB(cnt, :) = [i,j,vector64FB];
%         diff(cnt, :) = [i,j, abs(vector64BG - vector64FB)];
%         cnt = cnt + 1;
    end
end
%%


% imwrite(FG, 'edge.png');
% FG(619:627,730:790) = 0;
% FG(649:664,720:770) = 0;
figure
imshow(FG);
FG_fill = imfill(FG,'holes');
figure
imshow(FG_fill);

% FG(597:608,771:827) = 0;
% FG(628:646,764:806) = 0;

% se = strel('disk',8);
% FG_fill = imfill(imdilate(FG,se),'holes');
% figure
% imshow(FG_fill)
% 
% se = strel('disk', 15);
% FG_open = imopen(FG_fill,se);
% figure
% imshow(FG_open)

% se = strel('rectangle',[2,15]);
% FG_close = imclose(FG, se);
% figure
% imshow(FG_close)
% 
% se = strel('rectangle',[10,1]);
% FG_open = imopen(FG_close, se);
% figure
% imshow(FG_open)
% 
% FG_fill = imfill(FG_open,'holes');
% figure
% imshow(FG_fill)
% 
% se = strel('disk', 15);
% figure
% imshow(imopen(FG_fill,se))

%% Label
[L,num] = bwlabel(FG_fill);
maxnum = 0;
maxlabel = 0;
for i = 1:num
    if(numel(find(L == i)) <= maxnum)
        L(find(L == i)) = 0;
    else
        L(find(L == maxlabel)) = 0;
        maxnum = numel(find(L == i));
        maxlabel = i;
    end
end
imwrite(L, 'final.png');
figure
imshow(L)










