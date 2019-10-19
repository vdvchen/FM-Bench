function write_patches(path,patches,kpt)
    h5create(path,'/patches',size(patches));
    h5create(path,'/kpt',size(kpt));
    h5write(path,'/patches',patches);
    h5write(path,'/kpt',kpt);

end


