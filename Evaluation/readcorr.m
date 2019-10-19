clc;
clear all;

wkdir = '../'; % The root foler of FM-Bench
Datasets = {'CPC','TUM','KITTI','Tanks_and_Temples'};

Methods = {'SIFT-RT-RANSAC'};

for d = 1 : length(Datasets) 
    dataset = Datasets{d};
    for m = 1 : length(Methods)
        method = Methods{m};
        results_dir = [wkdir 'Results/' dataset '/'];
        filename = [results_dir method '.mat'];
        Results = importdata(filename);
        corr_total=0;
        inlier_total=0;
        for idx = 1 : length(Results)
            size1 = Results{idx}.size_l;
            size2 = Results{idx}.size_r;
            X1 = Results{idx}.X_l';
            X2 = Results{idx}.X_r';
            inliers = Results{idx}.inliers;
            corr=size(X1);
            corr_total=corr_total+corr(2);
            inlier_total=inlier_total+sum(inliers);
        end
        avg_corr=corr_total/length(Results);
        avg_inlier=inlier_total/length(Results);
        fprintf('%s: corr:%f  inlier:%f\n',dataset,avg_corr,avg_inlier);
    end
end
            