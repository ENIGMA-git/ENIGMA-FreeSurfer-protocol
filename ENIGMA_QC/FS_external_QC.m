function []=FS_external_QC(indir,outdir,subject)

fprintf ('Generate External QC images for Freeurfer - qsub\n');
fprintf ('written by Iyad Ba Gari - updated Mar 2021 - enigma.ini.usc.edu\n');


% *Read label (cortical):*
[vertex_coordsR, facesR] = read_surf(fullfile(indir,subject,'surf', 'rh.pial'));
[vertex_coordsL, facesL] = read_surf(fullfile(indir,subject,'surf', 'lh.pial'));

% *Read FreeSurfer annotation file:*
cd(fullfile(indir, subject, 'label'));
[verticesR, labelR, colortableR] = read_annotation('rh.aparc.annot');
[verticesL, labelL, colortableL] = read_annotation('lh.aparc.annot');
XR = vertex_coordsR(:, 1); YR = vertex_coordsR(:, 2); ZR = vertex_coordsR(:, 3);
XL = vertex_coordsL(:, 1); YL = vertex_coordsL(:, 2); ZL = vertex_coordsL(:, 3);

% *RGB color: rgb for each vertex*
tableR = colortableR.table(:, 5);
tableL = colortableL.table(:, 5);
rgbR = zeros(size(colortableR.table(:, 3)));
rgbL = zeros(size(colortableL.table(:, 3)));

% *Right*
for lbR = 1:length(tableR)
    mR = tableR(lbR);
    for vR = 1:length(labelR)
        if mR == labelR(vR)
           rgbR(vR, 1:3) = colortableR.table(lbR, 1:3);
        end
    end
end

% *Left*
for lbL = 1:length(tableL)
    mL = tableL(lbL);
    for vL = 1:length(labelL)
        if mL == labelL(vL)
           rgbL(vL, 1:3) = colortableL.table(lbL, 1:3);
        end
    end
end

% *Fix color of black unkown ROI to dark gray color && Convert RGB to [0 1] scale*
if size(rgbR,1) == size(vertex_coordsR,1)
    rgbR(all(rgbR==0,2),:) = 100;
    rgbR = rgbR/255;
else
    rgbR(end+(size(vertex_coordsR,1) - size(rgbR,1)),:) = 0;
    rgbR(all(rgbR==0,2),:) = 100;
    rgbR = rgbR/255;
end

if size(rgbL,1) == size(vertex_coordsL,1)
    rgbL(all(rgbL==0,2),:) = 100;
    rgbL = rgbL/255;
else
    rgbL(end+(size(vertex_coordsL,1) - size(rgbL,1)),:) = 0;
    rgbL(all(rgbL==0,2),:) = 100;
    rgbL = rgbL/255;
end


% *Right hemisphere: Plot Figure*
figR = figure('Visible','off');
surfR = trisurf(1+facesR, XR, YR, ZR);
set(surfR,'FaceVertexCData', rgbR,'FaceColor','interp','EdgeColor',[0, 0, 0],'CDataMapping','scaled',...
    'FaceAlpha',1,'EdgeAlpha',0,'AlphaDataMapping','none',...
    'LineWidth',0.5,...
    'FaceLighting','gouraud','BackFaceLighting','reverselit','EdgeLighting','gouraud',...
    'AmbientStrength',0.2, 'DiffuseStrength',0.8,'SpecularStrength', 0.1,'SpecularExponent',5,...
    'SpecularColorReflectance', 0.1);
set(figR, 'PaperSize',[8.5000 11],'PaperType','usletter','PaperUnits', 'inches','PaperPosition',[0 0 4 4], 'InvertHardCopy', 'off', 'Color',[0 0 0]);
axis off;
axis equal
axis tight;

light('position',[5 0.2 0.2]);
view(90, 0);
saveas(figR, fullfile(outdir, strcat(subject, '.rh.lat.png')),'png')


light('position',[-5 -0.75 -0.25]);
view(-90, 0);
saveas(figR, fullfile(outdir, strcat(subject, '.rh.med.png')),'png')


% *Left hemisphere: Plot Figure*
figL = figure('Visible','off');
surfL = trisurf(1+facesL, XL, YL, ZL);
set(surfL,'FaceVertexCData', rgbL,'FaceColor','interp','EdgeColor',[0, 0, 0],'CDataMapping','scaled',...
    'FaceAlpha',1,'EdgeAlpha',0,'AlphaDataMapping','none',...
    'LineWidth',0.5,...
    'FaceLighting','gouraud','BackFaceLighting','reverselit','EdgeLighting','gouraud',...
    'AmbientStrength',0.2, 'DiffuseStrength',0.8,'SpecularStrength', 0.1,'SpecularExponent',5,...
    'SpecularColorReflectance', 0.1);
set(figL, 'PaperSize',[8.5000 11],'PaperType','usletter','PaperUnits', 'inches','PaperPosition',[0 0 4 4], 'InvertHardCopy', 'off', 'Color',[0 0 0]);
axis off;
axis equal
axis tight;

light('position',[-5 -0.75 -0.25]);
view(-90, 0);
saveas(figL, fullfile(outdir, strcat(subject, '.lh.lat.png')),'png')

light('position',[5 0.2 0.2]);
view(90, 0);
saveas(figL, fullfile(outdir, strcat(subject, '.lh.med.png')),'png')

end