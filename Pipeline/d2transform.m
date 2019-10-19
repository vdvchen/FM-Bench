function d2transform(wkdir,dataset)
%Transform .d2-net into .keypoints & .descriptors

dataset_dir = [wkdir 'Features/' dataset '/'];
d2_dir=['../../d2-net-master/Desc/' dataset '/'];

if exist(dataset_dir)==0
    mkdir(dataset_dir);
end

filelist=dir([d2_dir,'*','.d2-net']);

for i=1:length(filelist)
    file=filelist(i).name;
    d2file=[d2_dir file];
    data=load(d2file,'-mat');
    kpt=data.keypoints;
    fea=data.descriptors;
    kptfile=[dataset_dir file(1:length(file)-6) 'keypoints'];
    feafile=[dataset_dir file(1:length(file)-6) 'descriptors'];
    write_keypoints(kptfile,kpt);
    write_descriptors(feafile,fea);
end

end