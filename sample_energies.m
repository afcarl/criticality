function [ energy_samples, r ] = sample_energies(r, t, numsamples, burnin, thinning, fig, video)
%SAMPLE_ENERGIES Samples energies from GRBM at specified temperature.
    energy_samples = [];
    for j=1:(burnin + numsamples*thinning)
        % sample visible nodes from hidden nodes
        r = r.visGivHid(r.aHid, 1, t);
        % sample hidden nodes from visible nodes
        r = r.hidGivVis(r.aVis, 0, 1, t);
        
        % discard first samples as burn-in
        if j > burnin
            % calculate energy of this configuration
            energy = sum(bsxfun(@minus, r.aVis, r.b).^2, 2) ./ 2 ...
                - sum(bsxfun(@times, r.aHid, r.c), 2) ...
                - sum((r.aVis * r.W) .* r.aHid, 2);
            % collect energies for variance calculation
            energy_samples = [energy_samples energy];
        end

        if ishandle(fig)
            % visualize sample
            img = mat2gray(myvisualize(r.aVis', 10)');
            imgsize = size(img);
            img = insertText(img, [imgsize(1)/2 imgsize(2)], ...
                strcat('Temperature: ', num2str(t)), ...
                'AnchorPoint','CenterBottom');
            % show image on screen
            figure(fig);
            imshow(img);
            if video
                % write image to video file
                writeVideo(video, img)
            end
        end
    end
end
