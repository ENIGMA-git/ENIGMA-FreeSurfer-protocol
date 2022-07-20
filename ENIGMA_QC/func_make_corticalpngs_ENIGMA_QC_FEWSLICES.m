%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ENIGMA Cortical Protocols
%% QC thickness visualization for FreeSurfer (Fischl Neuroimage, 2012)
%% written by Neda Jahanshad -- neda.jahansad@ini.usc.edu
%% January 2014 - enigma.ini.usc.edu
%% -- updated July 2014 to add another panel and fix insula color (-NJ)
%% -- uses FreeSurfer Matlab Tools for reading in mgh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%     example inputs

%%dirO='/Volumes/enigma/Neda/CoritcalTest/QC/'    %% output directory
%%subject='8003201_JC'
%%imageF=char(strcat('/Volumes/enigma/Neda/FreesurferRuns/',subject,'/mri/orig.mgz'));
%%overlay=char(strcat('/Volumes/enigma/Neda/FreesurferRuns/',subject,'mri/aparc+aseg.mgz'));
%% make_corticalpngsFS(dirO,subject,imageF,overlay)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function make_corticalpngsFS(dirO,subject,imageF,overlay)

subj=subject;
dirOS=char(strcat(dirO,filesep,subject,filesep))
mkdir(dirOS)
s_name=subject;
FSmap=textread('FScortical_RGB.txt');
FSmap=FSmap./256;

img=fopen(imageF,'r','l');
fib=fopen(overlay,'r','l');

if img >0 && fib >0

[inputT1img, mr_parms, Mdc, volsz] =load_mgh(imageF);
Nx=volsz(1);
Ny=volsz(2);
Nz=volsz(3);
[inputLABELimg M]=load_mgh(overlay);
fclose all;

if (length(inputT1img(:))==Nx*Ny*Nz && length(inputLABELimg(:))==Nx*Ny*Nz )

indexs=find(inputT1img~=0);
T1=zeros(Nx,Ny,Nz); T1(indexs)=inputT1img(indexs);

indexs=find(inputLABELimg~=0);
labelsLeft=zeros(Nx,Ny,Nz);
labelsLeft(indexs)=inputLABELimg(indexs);
labelsRight=zeros(Nx,Ny,Nz);
labelsRight(indexs)=inputLABELimg(indexs);

%%Left
labelsLeft(inputLABELimg<1000)=0; labelsLeft(inputLABELimg>1990)=0;
nonZero = find(labelsLeft~=0);
labelsLeft(nonZero)=labelsLeft(nonZero)-1000;

%%Right
labelsRight(inputLABELimg<2000)=0;
nonZero = find(labelsRight~=0);
labelsRight(nonZero)=labelsRight(nonZero)-2000;

Labels=labelsLeft +labelsRight;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% step 1 -- make images with full set of ROIS overlayed

%% find min max of image

indx=find(Labels~=0);
[x y z]=ind2sub([Nx Ny Nz],indx);

XminXmax = quantile(x,[0 1]) ;
YminYmax= quantile(y,[0 1]) ;
ZminZmax = quantile(z,[0 1]) ;

Xmin=max(XminXmax(1),3);Xmax=min(XminXmax(2),Nx-3);
Ymin=max(YminYmax(1),3);Ymax=min(YminYmax(2),Ny-3);
Zmin=max(ZminZmax(1),3);Zmax=min(ZminZmax(2),Nz-3);

T1=T1(Xmin-2:Xmax+2,Ymin-2:Ymax+2,Zmin-2:Zmax+2);
Labels=Labels(Xmin-2:Xmax+2,Ymin-2:Ymax+2,Zmin-2:Zmax+2);

indx=find(Labels~=0);
[x y z]=ind2sub(size(Labels),indx);

sliceSs = round(quantile(x,[.2 .4 .5 .6 .8]));
sliceCs = round(quantile(y,[.2 .4 .5 .6 .8]));
sliceAs = round(quantile(z,[.2 .4 .5 .6 .8]));
txts={'20';'40';'50';'60';'80'};
%% for each slice

    for slice = 1:4
    sliceA=sliceAs(slice);
    sliceC=sliceCs(slice);
    sliceS=sliceSs(slice);
    txt=char(txts(slice));

   % m=64;
   m1=64;
   m2=35;
    mask=Labels~=0;
    cmin=min(T1(:));
    cmax=max(T1(:));

    cminF=0;
    cmaxF=35;

    %%%%%%%%%%%%%%%%%
    %% coronal %%
    h=figure('Visible','off');
    h(1)= image(Xmax+2:-1:Xmin-2,Ymin-2:Ymax+2,transpose(T1(:,:,sliceA)));
    axis off; hold on;
    h(2)= image(Xmax+2:-1:Xmin-2,Ymin-2:Ymax+2,transpose(Labels(:,:,sliceA)));
    set(h(2),'AlphaData',transpose(mask(:,:,sliceA)),'AlphaDataMapping','none');

    text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');


    text('position',[Xmin Ymin+10],'BackgroundColor','w','fontsize',16,'string','Left','Interpreter','none');
    text('position',[Xmax-20 Ymin+10],'BackgroundColor','w','fontsize',16,'string','Right','Interpreter','none');
   % caxis([1 64]);
    colormap([bone(m1); FSmap]);

    C1 = min(m1,round((m1-1)*(T1(:,:,sliceA)-cmin)/(cmax-cmin))+1);
    C2 = Labels(:,:,sliceA) +m1 +1 ;
    set(h(1),'CData',C1');
    set(h(2),'CData',C2');
    
    axis off;axis image;
    colormap([bone(m1); FSmap]);
    hold off;
    saveas(gca,char(strcat(dirOS,'Cortical_set_Coronal_',txt,'.png')),'png')
    print('-dpng','-r70',char(strcat(dirOS,'Cortical_set_Coronal_70_',txt,'.png')));
    close all;
        
    %%%%%%%%%%%%%%%%%
    %% axial %%
    h=figure('Visible','off') ;
        
    C1 = min(m1,round((m1-1)*(squeeze(T1(:,sliceC,:))-cmin)/(cmax-cmin))+1);
    C2 = squeeze(Labels(:,sliceC,:)) +m1 +1 ;
        
    h(1)=image(Xmax+2:-1:Xmin-2,Zmax+2:-1:Zmin-2,transpose(squeeze(T1(:,sliceC,:)))); hold on;axis off;
    set(h(1),'CData',C1');
    h(2)=image(Xmax+2:-1:Xmin-2,Zmax+2:-1:Zmin-2,transpose(squeeze(Labels(:,sliceC,:))));
    set(h(2),'AlphaData',transpose(squeeze(mask(:,sliceC,:))),'AlphaDataMapping','none');
    set(h(2),'CData',C2');
                
    text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
        text('position',[Xmin Zmin+10],'BackgroundColor','w','fontsize',16,'string','Left','Interpreter','none');
        text('position',[Xmax-20 Zmin+10],'BackgroundColor','w','fontsize',16,'string','Right','Interpreter','none');
        
    caxis([1 35]);
    axis off;axis image;
    colormap([bone(m1); FSmap]);
    saveas(gca,char(strcat(dirOS,'Cortical_set_Axial_',txt,'.png')),'png')
    print('-dpng','-r70',char(strcat(dirOS,'Cortical_set_Axial_70_',txt,'.png')));
    hold off;
    close all;
   
    end
end
        
        else
        txts={'20';'40';'60';'80'};
        %% for each slice
    
        for slice = 1:4
        txt=char(txts(slice));
        
        %%%%%%%%%%%%%%%%%
        %% coronal %%
        h=figure('Visible','off');

        text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
        text('position',[0.3 0.5],'BackgroundColor','w','fontsize',16,'string','FS failed to output labels','Interpreter','none');
        axis off;
        saveas(gca,char(strcat(dirOS,'Cortical_set_Coronal_',txt,'.png')),'png')
        print('-dpng','-r70',char(strcat(dirOS,'Cortical_set_Coronal_70_',txt,'.png')));
        close all;
                
        %%%%%%%%%%%%%%%%%
        %% axial %%
        h=figure('Visible','off') ;
        text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
        text('position',[0.3 0.5],'BackgroundColor','w','fontsize',16,'string','FS failed to output labels','Interpreter','none');
        axis off;
        saveas(gca,char(strcat(dirOS,'Cortical_set_Axial_',txt,'.png')),'png')
        print('-dpng','-r70',char(strcat(dirOS,'Cortical_set_Axial_70_',txt,'.png')));
        close all;
        end
        
end

    
