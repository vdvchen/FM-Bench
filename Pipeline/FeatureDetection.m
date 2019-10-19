function FeatureDetection(wkdir, dataset,istop4k)
% Detect and save DoG keypoints

disp('Detecting keypoints...');

dataset_dir = [wkdir 'Dataset/' dataset '/'];

feature_dir = [wkdir 'Features/' dataset '/'];
if exist(feature_dir, 'dir') == 0
    mkdir(feature_dir);
end

pairs_gts = dlmread([dataset_dir 'pairs_with_gt.txt']);
pairs_which_dataset = importdata([dataset_dir 'pairs_which_dataset.txt']);

pairs = pairs_gts(:,1:2);
l_pairs = pairs(:,1);
r_pairs = pairs(:,2);

num_pairs = size(pairs,1);
for idx = 1 : num_pairs
    l = l_pairs(idx);
    r = r_pairs(idx);
    
    I1 = imread([dataset_dir pairs_which_dataset{idx} 'Images/' sprintf('%.8d.jpg', l)]);
    I2 = imread([dataset_dir pairs_which_dataset{idx} 'Images/' sprintf('%.8d.jpg', r)]);
    
    if size(I1,3) == 3
        I1gray = rgb2gray(I1);
    else
        I1gray = I1;
    end
    
    if size(I2,3) == 3
        I2gray = rgb2gray(I2);
    else
        I2gray = I2;
    end
    
    path_l = [feature_dir sprintf('%.4d_l', idx)];
    path_r = [feature_dir sprintf('%.4d_r', idx)];
    
    if exist([path_l '.keypoints'], 'file') == 2 && exist([path_r '.keypoints'], 'file') == 2
        continue;
    end
    
    keypoints_l = vl_sift(single(I1gray))';
    write_keypoints([path_l '.keypoints'], keypoints_l);
    if size(keypoints_l,1)<=4000
        top_4k_l=keypoints_l;
    else
        [N,I]=maxk(keypoints_l,4000,1);
        I=I(:,3)';
        top_4k_l=keypoints_l(I,:);
    end
    if istop4k
        write_keypoints([path_l '_t4k.keypoints'], top_4k_l);
    end
    
    keypoints_r = vl_sift(single(I2gray))';
    write_keypoints([path_r '.keypoints'], keypoints_r);
    if size(keypoints_r,1)<=4000
        top_4k_r=keypoints_r;
    else
        [N,I]=maxk(keypoints_r,4000,1);
        I=I(:,3)';
        top_4k_r=keypoints_r(I,:);
    end
    if istop4k
        write_keypoints([path_r '_t4k.keypoints'], top_4k_r);
    end
end

disp('Finished.');
end

