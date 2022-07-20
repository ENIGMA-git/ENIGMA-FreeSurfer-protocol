function func_QC_enigmaDTI_FA_skel(subj,Fa,skel,dirO)


mkdir(dirO);

dirOS=char(strcat(dirO,'/',subj,'/'));
mkdir(dirOS);

%Fa = 'XXX_FA.nii.gz';
Fa=char(Fa);
iFA = load_image(Fa);
MDT = iFA.img;

%skel = 'XXX_skel.nii.gz';
skel=char(skel);
iskel = load_image(skel);
SK1 = iskel.img;


fclose all;

% setting dimenions of images
Nx = iFA.hdr.dime.dim(2);
Ny = iFA.hdr.dime.dim(3);
Nz = iFA.hdr.dime.dim(4);

dx = iFA.hdr.dime.pixdim(2);
dy = iFA.hdr.dime.pixdim(3);
dz = iFA.hdr.dime.pixdim(4);


% setting max and min values for each template
cminMDT = min(MDT(:));
cmaxMDT = max(MDT(:));

cminSK1 = min(SK1(:));
cmaxSK1 = max(SK1(:));

mask=SK1~=0;

m=64;

% setting the slice numbers to make pngs for
sliceS = floor(Nx/3);
sliceC = floor(Ny/2);
sliceA = floor(Nz/2);

h1 = figure;
colormap([bone(m);winter(m)]);

h1(1)=image(transpose(squeeze(MDT(Nx:-1:1,:,sliceA))));  hold on;
set(gca,'YDir','normal');
h1(2)=image(squeeze(transpose(SK1(Nx:-1:1,:,sliceA))));
set(h1(2),'AlphaData',transpose(mask(:,:,sliceA)),'AlphaDataMapping','none');
set(gca,'YDir','normal');
text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',18,'string',subj,'Interpreter','none');

C1 = min(m,round((m-1)*(MDT(Nx:-1:1,:,sliceA)-cminMDT)/(cmaxMDT-cminMDT))+1);
C2 = min(m,round((m-1)*(SK1(Nx:-1:1,:,sliceA)-cminSK1)/(cmaxSK1-cminSK1))+m+1);
    set(h1(1),'CData',C1');
    set(h1(2),'CData',C2');
        
    axis off;
    axis image;
    set(gca,'DataAspectRatio',[dx/dy 1 1])
    hold off;
    print('-dpng','-r70',char(strcat(dirOS,'Axial_Skel_check_lowRez.png')));
    saveas(gca,char(strcat(dirOS,'Axial_Skel_check.png')),'png')
    
    h2 = figure; colormap([bone(m);winter(m)]);
    h2(1)=image(transpose(squeeze(MDT(Nx:-1:1,sliceC,:)))); hold on;
    h2(2)=image(transpose(squeeze(SK1(Nx:-1:1,sliceC,:))));
    set(h2(2),'AlphaData',transpose(squeeze(SK1(Nx:-1:1,sliceC,:))),'AlphaDataMapping','none');
    set(gca,'YDir','normal');
    text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',18,'string',subj,'Interpreter','none');
        C1 = min(m,round((m-1)*(squeeze(MDT(Nx:-1:1,sliceC,:))-cminMDT)/(cmaxMDT-cminMDT))+1);
        C2 = min(m,round((m-1)*(squeeze(SK1(Nx:-1:1,sliceC,:))-cminSK1)/(cmaxSK1-cminSK1))+m+1);
        set(h2(1),'CData',C1');
        set(h2(2),'CData',C2');
    
        axis off;axis image;
        hold off;
        set(gca,'DataAspectRatio',[dz/dx 1 1])
        print('-dpng','-r70',char(strcat(dirOS,'Coronal_Skel_check_lowRez.png')));
        saveas(gca,char(strcat(dirOS,'Coronal_Skel_check.png')),'png')
        
        h3 = figure;colormap([bone(m);winter(m)]);
        h3(1)=image(transpose(squeeze(MDT(sliceS,:,:)))); hold on;
        h3(2)=image(transpose(squeeze(SK1(sliceS,:,:))));
        set(h3(2),'AlphaData',transpose(squeeze(SK1(sliceS,:,:))),'AlphaDataMapping','none');
        set(gca,'YDir','normal');
        text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',18,'string',subj,'Interpreter','none');
        
            C1 = min(m,round((m-1)*(squeeze(MDT(sliceS,:,:))-cminMDT)/(cmaxMDT-cminMDT))+1);
            C2 = min(m,round((m-1)*(squeeze(SK1(sliceS,:,:))-cminSK1)/(cmaxSK1-cminSK1))+m+1);
            set(h2(1),'CData',C1');
            set(h2(2),'CData',C2');
                    
                    
            axis off;axis image;
            set(gca,'DataAspectRatio',[dz/dy 1 1])
            hold off;
            print('-dpng','-r70',char(strcat(dirOS,'Sagittal_Skel_check_lowRez.png')));
            saveas(gca,char(strcat(dirOS,'Sagittal_Skel_check.png')),'png')

            close all;


