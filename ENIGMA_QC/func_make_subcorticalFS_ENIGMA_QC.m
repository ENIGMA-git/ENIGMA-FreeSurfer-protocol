%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ENIGMA Subcortical QC Protocol
%% for FreeSurfer (Fischl Neuroimage, 2012) segmentations 
%% written by Neda Jahanshad -- neda.jahansad@ini.usc.edu
%% August 2014 - enigma.ini.usc.edu
%% -- redone b/c this way is easier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%     example inputs

	%%dirO='/Volumes/enigma/Neda/SubcoritcalTest/QC/'    %% output directory
	%%subject='8003201_JC'
	%%imageF=char(strcat('/Volumes/enigma/Neda/FreesurferRuns/',subject,'/mri/orig.mgz'));
	%%overlay=char(strcat('/Volumes/enigma/Neda/FreesurferRuns/',subject,'mri/aparc+aseg.mgz'));
	%% make_subcorticalpngsFS(dirO,subject,imageF,overlay)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function make_subcorticalpngsFS(dirO,subject,imageF,overlay)

regions={'Thal'; 'none'; 'Caud';'none'; 'Put';'none'; 'Pall';'none'; 'Hip';'none'; 'Amyg';'none'; 'NAcc'};

done=0;
subj=subject;
dirOS=char(strcat(dirO,filesep,subject,filesep));
mkdir(dirOS)
s_name=char(subject);

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
		  
		  %% zero out structures of no interest
        
        ROIS=[10 11 12 13 17 18 26 49 50 51 52 53 54 58];
        indexs=ismember(inputLABELimg,ROIS);
        
        inputLABELimg2=zeros(Nx,Ny,Nz);
        inputLABELimg2(indexs)=inputLABELimg(indexs);
        inputLABELimg=inputLABELimg2;
        clear inputLABELimg2;
        
        %thal
        inputLABELimg(inputLABELimg==10)=1; inputLABELimg(inputLABELimg==49)=2;
        %%caud
        inputLABELimg(inputLABELimg==11)=3; inputLABELimg(inputLABELimg==50)=4;
        %%putamen
        inputLABELimg(inputLABELimg==12)=5; inputLABELimg(inputLABELimg==51)=6;
        %%pallidum
        inputLABELimg(inputLABELimg==13)=7; inputLABELimg(inputLABELimg==52)=8;
        %%hippo
        inputLABELimg(inputLABELimg==17)=9; inputLABELimg(inputLABELimg==53)=10;
        %amygdala
        inputLABELimg(inputLABELimg==18)=11; inputLABELimg(inputLABELimg==54)=12;
        %accumbens
        inputLABELimg(inputLABELimg==26)=13; inputLABELimg(inputLABELimg==58)=14;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%% step 1 -- make images with full set of ROIS overlayed
        
        %% find min max of image
        
        indx=find(T1~=0);
        [x y z]=ind2sub([Nx Ny Nz],indx);
        
        XminXmax = quantile(x,[0 1]) ;
        YminYmax= quantile(y,[0 1]) ;
        ZminZmax = quantile(z,[0 1]) ;
        
        Xmin=max(XminXmax(1),3);Xmax=min(XminXmax(2),Nx-3);
        Ymin=max(YminYmax(1),3);Ymax=min(YminYmax(2),Ny-3);
        Zmin=max(ZminZmax(1),3);Zmax=min(ZminZmax(2),Nz-3);

        T1=T1(Xmin-2:Xmax+2,Ymin-2:Ymax+2,Zmin-2:Zmax+2);
        inputLABELimg=inputLABELimg(Xmin-2:Xmax+2,Ymin-2:Ymax+2,Zmin-2:Zmax+2);
		  
        indx=find(inputLABELimg~=0);
        [x y z]=ind2sub(size(inputLABELimg),indx);
        
        sliceSs = round(quantile(x,[.2 .4 .6 .8]));
        sliceCs = round(quantile(y,[.2 .4 .6 .8]));
        sliceAs = round(quantile(z,[.2 .4 .6 .8]));
        txts={'20';'40';'60';'80'};
        %% for each slice
        
        for slice = 1:4
            sliceA=sliceAs(slice);
            sliceC=sliceCs(slice);
            sliceS=sliceSs(slice);
            txt=char(txts(slice));
            
            m=64;
            mask=inputLABELimg~=0;
            cmin=min(T1(:));
            cmax=max(T1(:));
            
            cminF=min(inputLABELimg(:));
            cmaxF=max(inputLABELimg(:));
            
            %%%%%%%%%%%%%%%%%
            %% axial %%
            h=figure('Visible','off');
            h(1)= image(Xmax+2:-1:Xmin-2,Ymin-2:Ymax+2,transpose(T1(:,:,sliceA)));
            axis image; axis off; hold on;
            h(2)= image(Xmax+2:-1:Xmin-2,Ymin-2:Ymax+2,transpose(inputLABELimg(:,:,sliceA)));
            set(h(2),'AlphaData',transpose(mask(:,:,sliceA)),'AlphaDataMapping','none');
            
            text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
            colormap([bone(64); jet(64)]);
            
            C1 = min(m,round((m-1)*(T1(:,:,sliceA)-cmin)/(cmax-cmin))+1);
            C2 = min(m,round((m-1)*(inputLABELimg(:,:,sliceA)-cminF)/(cmaxF-cminF))+1)+64;
            
            set(h(1),'CData',C1');
            set(h(2),'CData',C2');
            caxis([1 64]);
            axis off;
            colormap([bone(64); jet(64)]);
            hold off;
	         saveas(gca,char(strcat(dirOS,'Subcortical_set_Coronal_',txt,'.png')),'png')
	         print('-dpng','-r70',char(strcat(dirOS,'Subcortical_set_Coronal_70_',txt,'.png')));
            close all;
            
            %%%%%%%%%%%%%%%%%
            h=figure('Visible','off') ;
            
            C1 = min(m,round((m-1)*(squeeze(T1(:,sliceC,:))-cmin)/(cmax-cmin))+1);
            C2 = min(m,round((m-1)*(squeeze(inputLABELimg(:,sliceC,:))-cminF)/ ...
                (cmaxF-cminF))+1)+64;
            
            h(1)=image(Xmin-2:Xmax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(T1(:,sliceC,:)))); axis image; hold on;axis off;
            set(h(1),'CData',C1');
            h(2)=image(Xmin-2:Xmax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(inputLABELimg(:,sliceC,:))));
            set(h(2),'AlphaData',transpose(squeeze(mask(:,sliceC,:))),'AlphaDataMapping','none');
            set(h(2),'CData',C2');
            
            text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
            caxis([1 64]);
            axis off;
            colormap([bone(64); jet(64)]);
	         saveas(gca,char(strcat(dirOS,'Subcortical_set_Axial_',txt,'.png')),'png')
	         print('-dpng','-r70',char(strcat(dirOS,'Subcortical_set_Axial_70_',txt,'.png')));
            hold off;
            close all;
            
            %%%%%%%%%%%%%%%%%
            h1=figure('Visible','off') ;
            
            C1 = min(m,round((m-1)*(squeeze(T1(sliceS,:,:))-cmin)/(cmax-cmin))+1);
            C2 = min(m,round((m-1)*(squeeze(inputLABELimg(sliceS,:,:))-cminF)/ ...
                (cmaxF-cminF))+1)+64;
            
            h1(1)=image(Ymax+2:-1:Ymin-2,Zmin-2:Zmax+2,(squeeze(T1(sliceS,:,:)))) ;hold on;axis off; axis image;
            set(h1(1),'CData',C1);
            h1(2)=image(Ymax+2:-1:Ymin-2,Zmin-2:Zmax+2,(squeeze(inputLABELimg(sliceS,:,:)))) ;
            set(h1(2),'AlphaData',(squeeze(mask(sliceS,:,:))),'AlphaDataMapping','none');
            set(h1(2),'CData',C2);
            
            text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
            
            caxis([1 64]);
            axis off;
            colormap([bone(64); jet(64)]);
	         saveas(gca,char(strcat(dirOS,'Subcortical_set_Sagittal_',txt,'.png')),'png')
	         print('-dpng','-r70',char(strcat(dirOS,'Subcortical_set_Sagittal_70_',txt,'.png')));
            hold off;
            close all;
        end
        
        
        %%% loop through each of the structures
        for struct = 1:2:14
            regions(struct);
            structures = zeros(size(inputLABELimg));
            structures(inputLABELimg==struct)=1;
            structures(inputLABELimg==(struct+1))=2;
            
            indx=find(structures~=0);
            [xS yS zS]=ind2sub(size(structures),indx);

            SsliceSs = round(quantile(xS,[.25 .50 .75])) ;
            SsliceAs = round(quantile(yS,[.25 .50 .75])) ;
            SsliceCs = round(quantile(zS,[.25 .50 .75])) ;
            txts={'25';'50';'75'};
            
            for slice = 1:3
                sliceA=SsliceAs(slice);
                sliceC=SsliceCs(slice);
                sliceS=SsliceSs(slice);
                txt=char(txts(slice));
                
                mask=structures~=0;
                mask= mask .* 0.4;
                            
                cminF=min(structures(:));
                cmaxF=max(structures(:));
                
                %%%%%%%%%%%%%%%%%%%%%%%%%
                h=figure('Visible','off');
                
                h(1)= image(Xmax+2:-1:Xmin-2,Ymin-2:Ymax+2,transpose(T1(:,:,sliceC)));
                axis image; axis off; hold on;
                h(2)= image(Xmax+2:-1:Xmin-2,Ymin-2:Ymax+2,transpose(structures(:,:,sliceC)));
                set(h(2),'AlphaData',transpose(mask(:,:,sliceC)),'AlphaDataMapping','none');
                
                text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
                
                colormap([bone(64); jet(64)]);                
                C1 = min(m,round((m-1)*(T1(:,:,sliceC)-cmin)/(cmax-cmin))+1);
                C2 = structures(:,:,sliceC);
                C2(C2 == 0) = 65;
                C2(C2 == 1) = 88;
                C2(C2 == 2) = 128;
                
                set(h(1),'CData',C1');
                set(h(2),'CData',C2');
                caxis([1 64]);
                axis off;
                colormap([bone(64); jet(64)]);
                saveas(gca,char(strcat(dirOS,regions(struct),'_Coronal_',txt,'.png')),'png')
			          print('-dpng','-r70',char(strcat(dirOS,regions(struct),'_Coronal_70_',txt,'.png')));
			          close all;
                hold off;
                close all;

                %%%%%%%%%%%%%%%%%%%%%%%%
                h=figure('Visible','off');

                h(1)=image(Xmin-2:Xmax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(T1(:,sliceA,:))));
                axis image; hold on; axis off;                
                h(2)=image(Xmin-2:Xmax+2,Zmax+2:-1:Zmin-2,transpose(squeeze(structures(:,sliceA,:))));
                set(h(2),'AlphaData',transpose(squeeze(mask(:,sliceA,:))),'AlphaDataMapping','none');
 
                text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
                
                colormap([bone(64); jet(64)]);
                C1 = min(m,round((m-1)*(squeeze(T1(:,sliceA,:))-cmin)/(cmax-cmin))+1);
                C2 = squeeze(structures(:,sliceA,:));
                C2(C2 == 0) = 65;
                C2(C2 == 1) = 88;
                C2(C2 == 2) = 128;
                
                set(h(1),'CData',C1');
                set(h(2),'CData',C2');
                caxis([1 64]);
                axis off;
                colormap([bone(64); jet(64)]);
                saveas(gca,char(strcat(dirOS,regions(struct),'_Axial_',txt,'.png')),'png')
					 print('-dpng','-r70',char(strcat(dirOS,regions(struct),'_Axial_70_',txt,'.png')));
                hold off;
                close all;
                
                %%%%%%%%%%%%%%%%%%%%%%%%
                h=figure('Visible','off') ;
                
                h(1)=image(Ymax+2:-1:Ymin-2,Zmin-2:Zmax+2,(squeeze(T1(sliceS,:,:))));
                hold on; axis off; axis image;               
                h(2)=image(Ymax+2:-1:Ymin-2,Zmin-2:Zmax+2,(squeeze(structures(sliceS,:,:)))) ;
                set(h(2),'AlphaData',(squeeze(mask(sliceS,:,:))),'AlphaDataMapping','none');
                
                text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
                
                colormap([bone(64); jet(64)]);
                C1 = min(m,round((m-1)*(squeeze(T1(sliceS,:,:))-cmin)/(cmax-cmin))+1);
                C2 = squeeze(structures(sliceS,:,:));
                C2(C2 == 0) = 65;
                C2(C2 == 1) = 88;
                C2(C2 == 2) = 128;
                %C2 = min(m,round((m-1)*(squeeze(structures(sliceS,:,:))-cminF)/(cmaxF-cminF))+1)+64;
                
                set(h(1),'CData',C1);
                set(h(2),'CData',C2);
                caxis([1 64]);
                axis off;
                colormap([bone(64); jet(64)]);
                saveas(gca,char(strcat(dirOS,regions(struct),'_Sagittal_',txt,'.png')),'png')
 			       print('-dpng','-r70',char(strcat(dirOS,regions(struct),'_Sagittal_70_',txt,'.png')));
                hold off;
                close all;
            end
        end
					end
		         else
		         txts={'20';'40';'60';'80'};
		         %% for each slice
    
		         for slice = 1:4
		         txt=char(txts(slice));
		         %%%%%%%%%%%%%%%%%
		         %% sagittal %%
		         h=figure('Visible','off') ;
		         text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
		         text('position',[0.3 0.5],'BackgroundColor','w','fontsize',16,'string','FS failed to output labels','Interpreter','none');
		         axis off;
		         saveas(gca,char(strcat(dirOS,'Subcortical_set_Sagittal_',txt,'.png')),'png')
		         print('-dpng','-r70',char(strcat(dirOS,'Subcortical_set_Sagittal_70_',txt,'.png')));
		         close all;
					
					
		         %%%%%%%%%%%%%%%%%
		         %% coronal %%
		         h=figure('Visible','off');

		         text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
		         text('position',[0.3 0.5],'BackgroundColor','w','fontsize',16,'string','FS failed to output labels','Interpreter','none');
		         axis off;
		         saveas(gca,char(strcat(dirOS,'Subcortical_set_Coronal_',txt,'.png')),'png')
		         print('-dpng','-r70',char(strcat(dirOS,'Subcortical_set_Coronal_70_',txt,'.png')));
		         close all;
                
		         %%%%%%%%%%%%%%%%%
		         %% axial %%
		         h=figure('Visible','off') ;
		         text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',12,'string',s_name,'Interpreter','none');
		         text('position',[0.3 0.5],'BackgroundColor','w','fontsize',16,'string','FS failed to output labels','Interpreter','none');
		         axis off;
		         saveas(gca,char(strcat(dirOS,'Subcortical_set_Axial_',txt,'.png')),'png')
		         print('-dpng','-r70',char(strcat(dirOS,'Subcortical_set_Axial_70_',txt,'.png')));
		         close all;
					
					
								
    end    
end
