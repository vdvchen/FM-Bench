function MatchTransform(wkdir,corrsmodel,dataset,matcher,ist4k)
%Tansform OANet .corr into match.mat


dataset_dir = [wkdir 'Dataset/' dataset '/'];
feature_dir = [wkdir 'Features/' dataset '/'];
corr_dir=[wkdir corrsmodel '/' dataset '/'];
matches_dir = [wkdir 'Matches/' dataset '/'];
if exist(matches_dir, 'dir') == 0
    mkdir(matches_dir);
end

pairs_gts = dlmread([dataset_dir 'pairs_with_gt.txt']);
pairs_which_dataset = importdata([dataset_dir 'pairs_which_dataset.txt']);

pairs = pairs_gts(:,1:2);
l_pairs = pairs(:,1);
r_pairs = pairs(:,2);

num_pairs = size(pairs,1);
Matches = cell(num_pairs, 1);

for idx = 1 : num_pairs
    l = l_pairs(idx);
    r = r_pairs(idx);
    
    I1 = imread([dataset_dir pairs_which_dataset{idx} 'Images/' sprintf('%.8d.jpg', l)]);
    I2 = imread([dataset_dir pairs_which_dataset{idx} 'Images/' sprintf('%.8d.jpg', r)]);
    
    size_l = size(I1);
    size_l = size_l(1:2);
    size_r = size(I2);
    size_r = size_r(1:2);
    
    if ist4k
        path_l = [corr_dir sprintf('%.4d_l_t4k.corr', idx)];
        path_r = [corr_dir sprintf('%.4d_r_t4k.corr', idx)];
    else
        path_l = [corr_dir sprintf('%.4d_l.corr', idx)];
        path_r = [corr_dir sprintf('%.4d_r.corr', idx)];
    end
    
    X_l=hdf5read(path_l,'corr');
    X_r=hdf5read(path_r,'corr');
    
    Matches{idx}.size_l = size_l;
    Matches{idx}.size_r = size_r;
    
    Matches{idx}.X_l = X_l';
    Matches{idx}.X_r = X_r';
end

matches_file = [matches_dir matcher '.mat'];
save(matches_file, 'Matches');
end
