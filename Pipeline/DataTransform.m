function DataTransform(wkdir,dataset)
%Transform .h5(contextdesc submission) into .keypoints & .descriptors

dataset_dir = [wkdir 'Features/' dataset '/'];
h5_dir=['../../contextdesc_code/submission-fmbench/' dataset '/'];

if exist(dataset_dir)==0
    mkdir(dataset_dir);
end

filelist=dir([h5_dir,'*','.h5']);

for i=1:length(filelist)
    file=filelist(i).name;
    h5file=[h5_dir file];
    kpt=hdf5read(h5file,'kpt')';
    fea=hdf5read(h5file,'fea')';
    
    kptfile=[dataset_dir file(1:length(file)-2) 'keypoints'];
    feafile=[dataset_dir file(1:length(file)-2) 'descriptors'];
    write_keypoints(kptfile,kpt);
    write_descriptors(feafile,fea);
end

end