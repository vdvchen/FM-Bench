function PatchExtraction(wkdir, dataset,patch_radius)
disp('Extracting patches...');

dataset_dir = [wkdir 'Dataset/' dataset '/'];

feature_dir = [wkdir 'Features/' dataset '/'];

path_dir=[wkdir 'Patches/' dataset '/'];

if exist(feature_dir, 'dir') == 0
    mkdir(feature_dir);
end

if exist(path_dir, 'dir') == 0
    mkdir(path_dir);
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
    height_l=size(I1,1);
    width_l=size(I1,2);
    height_r=size(I2,1);
    width_r=size(I2,2);
    
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
    pa_path_l=[path_dir sprintf('%d_l.patches', idx)];
    pa_path_r=[path_dir sprintf('%d_r.patches', idx)];
    
    
    keypoints_l = read_keypoints([path_l '.keypoints']);
    keypoints_r = read_keypoints([path_r '.keypoints']);
    keypoints_l(:,4)=0;
    keypoints_r(:,4)=0;
    % Extract and save patches for l
    [~,patches_l] = vl_covdet(single(I1gray), 'Frames', keypoints_l', ...
        'Descriptor', 'patch','patchresolution', patch_radius);
    patches_l = reshape(patches_l, [2 * patch_radius + 1, 2 * patch_radius + 1, ...
                            size(keypoints_l, 1)]);
    patches_l = permute(patches_l, [2, 1,3]);
    %normalize keypoint coordinate
    keypoints_l=(keypoints_l(:,1:2)-[width_l/2,height_l/2])./[width_l/2,height_l/2];
    write_patches(pa_path_l, patches_l,keypoints_l');
    
    % Extract and save patches for r
    [~, patches_r] = vl_covdet(single(I2gray), 'Frames', keypoints_r', ...
        'Descriptor', 'patch','patchresolution', patch_radius);
    patches_r = reshape(patches_r, [2 * patch_radius + 1, 2 * patch_radius + 1, ...
                            size(keypoints_r, 1)]);
    patches_r = permute(patches_r, [2, 1, 3]);
    %normalize keypoint coordinate
    keypoints_r=(keypoints_r(:,1:2)-[width_r/2,height_r/2])./[width_r/2,height_r/2];
    write_patches(pa_path_r, patches_r,keypoints_r');
    
end

disp('Finished.');
end


