% Load a ANALYZE image and deal with if it is gziped.
function [image_type] = load_image(name)

if(strcmp(name(end-2:end),'.gz'))
    
    gunzip(name); % Unzip the image.
    image_type = load_nii(name(1:end-3)); % Load using the NIFTI library.
    gzip(name(1:end-3)); % Zip it back up again.
    delete(name(1:end-3)); % Delete the unzipped version.
    
else
    
    image_type = load_nii(name); % Load using the NIFTI library.
    
end

end
