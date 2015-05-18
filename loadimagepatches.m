function m = loadimagepatches(folder, sizex, sizey)
    m = zeros(0, 0, 0, 'uint8');
    files = dir(fullfile(folder, '*.jpg'));
    for file = {files.name}
        filename = fullfile(folder, file{1});
        disp(filename);
        im = rgb2gray(imread(filename));
        for y = 1:sizey:(size(im,1) - sizey + 1)
            for x = 1:sizex:(size(im,2) - sizex + 1)
                m(:,:,end+1) = im(y:(y+sizey-1), x:(x+sizex-1));
            end
        end
    end
end