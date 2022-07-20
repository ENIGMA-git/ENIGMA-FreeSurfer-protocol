function func_QC_enigmaDTI_FAV1(subj,Fa,Vec,dirO,varargin)

if (nargin ==4)
thresh=0.1;
else
thresh=varargin(5);
if (isstr(thresh)),thresh=str2num(thresh); end;
end

mkdir(dirO);

dirOS=char(strcat(dirO,'/',subj,'/'));
mkdir(dirOS);

%if ~isdeployed
%addpath('./QC_ENIGMA/')
%end

%Fa = 'XXX_FA.nii.gz';
Fa=char(Fa);
iFA = load_image(Fa);
MDT = iFA.img;

%Vec = 'XXX_V1.nii.gz';
Vec=char(Vec);
iV1 = load_image(Vec);
V1 = iV1.img;


fclose all;

% setting dimenions of images
Nx = iFA.hdr.dime.dim(2);
Ny = iFA.hdr.dime.dim(3);
Nz = iFA.hdr.dime.dim(4);
V=zeros(Nx,Ny,Nz,3);

dx = iFA.hdr.dime.pixdim(2);
dy = iFA.hdr.dime.pixdim(3);
dz = iFA.hdr.dime.pixdim(4);

V=zeros(Nx,Ny,Nz,3);


% setting max and min values for each template
cminMDT = min(MDT(:));
cmaxMDT = max(MDT(:));

indx = find(MDT>(thresh*cmaxMDT));
[i j k]= ind2sub([Nx Ny Nz],indx);
for l=1:length(i)
V(i(l),j(l),k(l),:)=V1(i(l),j(l),k(l),:);
end


m=64;

% setting the slice numbers to make pngs for
sliceS = floor(Nx/3);
sliceC = floor(Ny/2);
sliceA = floor(Nz/2);

h1 = figure;
colormap(bone(m));
C1 = min(m,round((m-1)*(MDT(Nx:-1:1,:,sliceA)-cminMDT)/(cmaxMDT-cminMDT))+1);
h1(1)=image(transpose(squeeze(MDT(Nx:-1:1,:,sliceA))));  hold on;
set(gca,'YDir','normal');
h1(2)=quiver(transpose(V(Nx:-1:1,:,sliceA,1)),transpose(V(Nx:-1:1,:,sliceA,2)),'--r');
set(gca,'YDir','normal');
text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',18,'string',subj,'Interpreter','none');

set(h1(1),'CData',C1');
    axis off;
    axis image;
    set(gca,'DataAspectRatio',[dx/dy 1 1])
    hold off;
    print('-dpng','-r70',char(strcat(dirOS,'Axial_V1_check_lowRez.png')));
    saveas(gca,char(strcat(dirOS,'Axial_V1_check.png')),'png')
    
    h2 = figure;
    colormap(bone(m));
    C2=min(m,round((m-1)*(squeeze(MDT(Nx:-1:1,sliceC,:))-cminMDT)/(cmaxMDT-cminMDT))+1);
    
    h2(1)=image(transpose(squeeze(MDT(Nx:-1:1,sliceC,:)))); hold on;
    h2(2)=quiver(transpose(squeeze(V(Nx:-1:1,sliceC,:,1))),transpose(squeeze(V(Nx:-1:1,sliceC,:,3))),'--r');
    set(gca,'YDir','normal');
    text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',18,'string',subj,'Interpreter','none');
    
    set(h2(1),'CData',C2');
        axis off;axis image;
        hold off;
        set(gca,'DataAspectRatio',[dz/dx 1 1])
        print('-dpng','-r70',char(strcat(dirOS,'Coronal_V1_check_lowRez.png')));
        saveas(gca,char(strcat(dirOS,'Coronal_V1_check.png')),'png')
        
        h3 = figure
        colormap(bone(m));
        C3=min(m,round((m-1)*(squeeze(MDT(sliceS,:,:))-cminMDT)/(cmaxMDT-cminMDT))+1);
        
        h3(1)=image(transpose(squeeze(MDT(sliceS,:,:)))); hold on;
        h3(2)=quiver(transpose(squeeze(V(sliceS,:,:,2))),transpose(squeeze(V(sliceS,:,:,3))),'--r');
        set(gca,'YDir','normal');
        text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',18,'string',subj,'Interpreter','none');
        
        set(h3(1),'CData',C3');
            axis off;axis image;
            set(gca,'DataAspectRatio',[dz/dy 1 1])
            hold off;
            print('-dpng','-r70',char(strcat(dirOS,'Sagittal_V1_check_lowRez.png')));
            saveas(gca,char(strcat(dirOS,'Sagittal_V1_check.png')),'png')

            close all;


