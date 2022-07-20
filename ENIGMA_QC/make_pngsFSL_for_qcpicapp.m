%%%
% Written by Neda Jahanshad - 
% Using the Nifti Library for Matlab by Jimmy Shen
% Provided under a BSD License
%%

function make_pngsFSL(dirO,dirO_non,subject,imageF,overlay)

regions={'Thal'; 'none'; 'Caud';'none'; 'Put';'none'; 'Pall';'none'; 'Hip';'none'; 'Amyg';'none'; 'NAcc'};

done=0;
subj=subject;
dirOS=char(strcat(dirO,filesep,subject,filesep));
mkdir(dirOS)
dirOS_non=char(strcat(dirO_non,filesep,subject,filesep));
mkdir(dirOS_non)
s_name=char(subject);

img=fopen(imageF,'r','l');
fib=fopen(overlay,'r','l');

if img >0 && fib >0
    inputFA=load_image(imageF);
    inputFAimg=inputFA.img;
    Nx=inputFA.hdr.dime.dim(2);
    Ny=inputFA.hdr.dime.dim(3);
    Nz=inputFA.hdr.dime.dim(4);
    inputFIB=load_image(overlay);
    inputFIBimg=double(inputFIB.img);
    fclose all;

    if (length(inputFAimg(:))==Nx*Ny*Nz && length(inputFIBimg(:))==Nx*Ny*Nz )
        
        %% zero out structures of no interest
        ROIS=[10 11 12 13 17 18 26 49 50 51 52 53 54 58];
        indexs=ismember(inputFIBimg,ROIS);
        
        inputFIBimg2=zeros(Nx,Ny,Nz);
        inputFIBimg2(indexs)=inputFIBimg(indexs);
        inputFIBimg=inputFIBimg2;
        clear inputFIBimg2;
        
        %thal
        inputFIBimg(inputFIBimg==10)=1;inputFIBimg(inputFIBimg==49)=2;
        %%caud
        inputFIBimg(inputFIBimg==11)=3;inputFIBimg(inputFIBimg==50)=4;
        %%putamen
        inputFIBimg(inputFIBimg==12)=5;inputFIBimg(inputFIBimg==51)=6;
        %%pallidum
        inputFIBimg(inputFIBimg==13)=7;inputFIBimg(inputFIBimg==52)=8;
        %%hippo
        inputFIBimg(inputFIBimg==17)=9;inputFIBimg(inputFIBimg==53)=10;
        %amygdala
        inputFIBimg(inputFIBimg==18)=11;inputFIBimg(inputFIBimg==54)=12;
        %accumbens
        inputFIBimg(inputFIBimg==26)=13;inputFIBimg(inputFIBimg==58)=14;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%% step 1 -- make images with full set of ROIS overlayed
        
        %% find min mean and max of all ROIS in image
        
        indx=find(inputFAimg~=0);
        [x y z]=ind2sub([Nx Ny Nz],indx);
        
        XminXmax = quantile(x,[0 1]) ;
        YminYmax= quantile(y,[0 1]) ;
        ZminZmax = quantile(z,[0 1]) ;
        
        Xmin=max(XminXmax(1),3);Xmax=min(XminXmax(2),Nx-3);
        Ymin=max(YminYmax(1),3);Ymax=min(YminYmax(2),Ny-3);
        Zmin=max(ZminZmax(1),3);Zmax=min(ZminZmax(2),Nz-3);
        
        
        inputFAimg=inputFAimg(Xmin-2:Xmax+2,Ymin-2:Ymax+2,Zmin-2:Zmax+2);
        inputFIBimg=inputFIBimg(Xmin-2:Xmax+2,Ymin-2:Ymax+2,Zmin-2:Zmax+2);
        
        indx=find(inputFIBimg~=0);
        [x y z]=ind2sub(size(inputFIBimg),indx);
        
        sliceSs = round(quantile(x,[.2 .4 .6 .8]));
        sliceCs = round(quantile(y,[.2 .4 .6 .8]));
        sliceAs = round(quantile(z,[.2 .4 .6 .8]));
        txts={'20';'40';'60';'80'};
        
        for slice = 1:4
            sliceS=sliceSs(slice);
            sliceC=sliceCs(slice);
            sliceA=sliceAs(slice);
            txt=char(txts(slice));
            
            m=64;
            mask=inputFIBimg~=0;
            cmin=min(inputFAimg(:));
            cmax=max(inputFAimg(:));
            
            while ~done
                inputFAimg=inputFAimg/10;
                cmax=max(inputFAimg(:));
                if cmax < 100
                    done = 1;
                end
            end
            
            cminF=min(inputFIBimg(:));
            cmaxF=max(inputFIBimg(:));
            

            h=figure('Visible','off');
            %%%%%%%%%%%%%%%%%%%
            h(1)= image(Xmax+2:-1:Xmin-2,Ymax+2:-1:Ymin-2,transpose(inputFAimg(:,:,sliceA)));
            axis square; axis off; hold on;

            h(2)= image(Xmax+2:-1:Xmin-2,Ymax+2:-1:Ymin-2,transpose(inputFIBimg(:,:,sliceA)));
            set(h(2),'AlphaData',transpose(mask(:,:,sliceA)),'AlphaDataMapping','none');
            
            text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name);
            colormap([bone(64); jet(64)]);
            
            C1 = min(m,round((m-1)*(inputFAimg(:,:,sliceA)-cmin)/(cmax-cmin))+1);
            C2 = min(m,round((m-1)*(inputFIBimg(:,:,sliceA)-cminF)/(cmaxF-cminF))+1)+64;

            set(h(1),'CData',C1');
            set(h(2),'CData',C2');
            caxis([1 64]);
            axis off;
            colormap([bone(64); jet(64)]);
            saveas(gca,char(strcat(dirOS,'ROIset_Axial_',txt,'.png')),'png')
            set(h(2),'AlphaData',0)
            saveas(gca,char(strcat(dirOS_non,'ROIset_Axial_',txt,'.png')),'png')
            hold off;
            
            h=figure('Visible','off') ;
            %%%%%%%%%%%%%%%%%
            C1 = min(m,round((m-1)*(squeeze(inputFAimg(:,sliceC,:))-cmin)/(cmax-cmin))+1);
            C2 = min(m,round((m-1)*(squeeze(inputFIBimg(:,sliceC,:))-cminF)/(cmaxF-cminF))+1)+64;

            h(1)=image(Xmin-2:Xmax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(inputFAimg(:,sliceC,:))));
            axis square; hold on; axis off;

            h(2)=image(Xmin-2:Xmax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(inputFIBimg(:,sliceC,:))));
            set(h(2),'AlphaData',transpose(squeeze(mask(:,sliceC,:))),'AlphaDataMapping','none');
            
            set(h(1),'CData',C1');
            set(h(2),'CData',C2');
            text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name);
            caxis([1 64]);
            axis off;
            colormap([bone(64); jet(64)]);
            saveas(gca,char(strcat(dirOS,'ROIset_Coronal_',txt,'.png')),'png')
            set(h(2),'AlphaData',0)
            saveas(gca,char(strcat(dirOS_non,'ROIset_Coronal_',txt,'.png')),'png')
            hold off;
            close all;
            
            h1=figure('Visible','off') ;
            %%%%%%%%%%%%%%%%%%
            C1 = min(m,round((m-1)*(squeeze(inputFAimg(sliceS,:,:))-cmin)/(cmax-cmin))+1);
            C2 = min(m,round((m-1)*(squeeze(inputFIBimg(sliceS,:,:))-cminF)/(cmaxF-cminF))+1)+64;
            
            h1(1)=image(Ymin-2:Ymax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(inputFAimg(sliceS,:,:))));
            hold on; axis off; axis square;
            
            h1(2)=image(Ymin-2:Ymax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(inputFIBimg(sliceS,:,:)))) ;
            set(h1(2),'AlphaData',transpose(squeeze(mask(sliceS,:,:))),'AlphaDataMapping','none');
            
            set(h1(1),'CData',C1');
            set(h1(2),'CData',C2');
            
            text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name);      
            caxis([1 64]);
            axis off;
            colormap([bone(64); jet(64)]);
            saveas(gca,char(strcat(dirOS,'ROIset_Sagittal_',txt,'.png')),'png')
            set(h1(2),'AlphaData',0)
            saveas(gca,char(strcat(dirOS_non,'ROIset_Sagittal_',txt,'.png')),'png')
            hold off;
            close all;
        end
        
        
        %%% loop through each of the structures
        for struct = 1:2:14
            
            structures = zeros(size(inputFIBimg));
            structures(inputFIBimg==struct)=1;
            structures(inputFIBimg==(struct+1))=2;
            
            indx=find(structures~=0);
            [xS yS zS]=ind2sub(size(inputFIBimg),indx);
            
            SsliceSs = round(quantile(xS,[.25 .50 .75])) ;
            SsliceCs = round(quantile(yS,[.25 .50 .75])) ;
            SsliceAs = round(quantile(zS,[.25 .50 .75])) ;
            txts={'25';'50';'75'};
            
            for slice = 1:3
                sliceA=SsliceAs(slice);
                sliceC=SsliceCs(slice);
                sliceS=SsliceSs(slice);
                txt=char(txts(slice));
                
                mask=structures~=0;
                mask= mask .* 0.4;
                while ~done
                    inputFAimg=inputFAimg/10;
                    cmax=max(inputFAimg(:));
                    if cmax < 100
                        done = 1;
                    end
                end
                
                cminF=min(structures(:));
                cmaxF=max(structures(:));
                
                h=figure('Visible','off') ;
                %%%%%%%%%%%%%%%%%%%%%
                h(1)= image(Xmax+2:-1:Xmin-2,Ymax+2:-1:Ymin-2,transpose(inputFAimg(:,:,sliceA)));
                axis square; axis off; hold on;
                
                h(2)= image(Xmax+2:-1:Xmin-2,Ymax+2:-1:Ymin-2,transpose(structures(:,:,sliceA)));
                set(h(2),'AlphaData',transpose(mask(:,:,sliceA)),'AlphaDataMapping','none');
                
                text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name);
                
                colormap([bone(64); jet(64)]);
                C1 = min(m,round((m-1)*(inputFAimg(:,:,sliceA)-cmin)/(cmax-cmin))+1);
                C2 = structures(:,:,sliceA);
                C2(C2 == 0) = 65;
                C2(C2 == 1) = 128;
                C2(C2 == 2) = 88;
                %C2 = min(m,round((m-1)*(structures(:,:,sliceA)-cminF)/(cmaxF-cminF))+1)+64;
                
                set(h(1),'CData',C1');
                set(h(2),'CData',C2');
                caxis([1 64]);
                axis off;
                colormap([bone(64); jet(64)]);
                saveas(gca,char(strcat(dirOS,regions(struct),'_Axial_',txt,'.png')),'png')
                set(h(2),'AlphaData',0)
                saveas(gca,char(strcat(dirOS_non,regions(struct),'_Axial_',txt,'.png')),'png')
                hold off;
                close all;
                
                h=figure('Visible','off') ;
                %%%%%%%%%%%%%%%%%%%%%
                C1 = min(m,round((m-1)*(squeeze(inputFAimg(:,sliceC,:)-cmin))/(cmax-cmin))+1);
                C2 = squeeze(structures(:,sliceC,:));
                C2(C2 == 0) = 65;
                C2(C2 == 1) = 128;
                C2(C2 == 2) = 88;
                %C2 = min(m,round((m-1)*(structures(:,sliceC,:)-cminF)/(cmaxF-cminF))+1)+64;
                
                h(1)=image(Xmin-2:Xmax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(inputFAimg(:,sliceC,:))));
                axis square; hold on; axis off;

                h(2)=image(Xmin-2:Xmax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(structures(:,sliceC,:))));
                set(h(2),'AlphaData',transpose(squeeze(mask(:,sliceC,:))),'AlphaDataMapping','none');
                
                set(h(1),'CData',C1');
                set(h(2),'CData',C2');
                
                text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name);
                caxis([1 64]);
                axis off;
                colormap([bone(64); jet(64)]);
                saveas(gca,char(strcat(dirOS,regions(struct),'_Coronal_',txt,'.png')),'png')
                set(h(2),'AlphaData',0)
                saveas(gca,char(strcat(dirOS_non,regions(struct),'_Coronal_',txt,'.png')),'png')
                hold off;
                close all;
                
                h=figure('Visible','off') ;
                %%%%%%%%%%%%%%%%%%
                C1 = min(m,round((m-1)*(squeeze(inputFAimg(sliceS,:,:)-cmin))/(cmax-cmin))+1);
                C2 = squeeze(structures(sliceS,:,:));
                C2(C2 == 0) = 65;
                C2(C2 == 1) = 128;
                C2(C2 == 2) = 88;
                %C2 = min(m,round((m-1)*(inputFIBimg(sliceS,:,:)-cminF)/(cmaxF-cminF))+1)+64;
                
                h(1)=image(Ymin-2:Ymax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(inputFAimg(sliceS,:,:)))) ;
                hold on;axis off; axis square;
                
                h(2)=image(Ymin-2:Ymax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(inputFIBimg(sliceS,:,:)))) ;
                set(h(2),'AlphaData',transpose(squeeze(mask(sliceS,:,:))),'AlphaDataMapping','none');
                
                set(h(1),'CData',C1');
                set(h(2),'CData',C2');

                text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name);
                caxis([1 64]);
                axis off;
                colormap([bone(64); jet(64)]);
                saveas(gca,char(strcat(dirOS,regions(struct),'_Sagittal_',txt,'.png')),'png')
                set(h(2),'AlphaData',0)
                saveas(gca,char(strcat(dirOS_non,regions(struct),'_Sagittal_',txt,'.png')),'png')
                close all;
            end
        end
        
        
    end
    
end

