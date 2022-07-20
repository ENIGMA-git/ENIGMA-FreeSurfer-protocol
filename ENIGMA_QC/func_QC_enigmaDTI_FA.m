

dirI='/Volumes/four_d/nwarstad/TWINS/DTI105/FLIRTFA2T1/';
dirO='/Volumes/four_d/nwarstad/TWINS/DTI105/FLIRTFA2T1_QC/';
niftifile=char(strcat(dirO,'QC_registrations_all_x2.nii'));
direc = dir(fullfile(char(strcat(dirI,'8*'))));
subjects={direc.name}; subjects(:)

mkdir(dirO);

%%%%%%%%%%%% %% this bit will just read in one subject and assign an output matrix of the same size x N subjects
i=1;
subj=char(subjects(i));
fileName=char(strcat(dirI,subjects(i),'/',subjects(i),'_FA2T16pdownsampto2mm_9p.nii.gz'))

Fa=char(fileName);
iFA = load_image(Fa);
MDT = iFA.img;

fclose all;

% setting dimenions of images
Nx = iFA.hdr.dime.dim(2);
Ny = iFA.hdr.dime.dim(3);
Nz = iFA.hdr.dime.dim(4);

dx = iFA.hdr.dime.pixdim(2);
dy = iFA.hdr.dime.pixdim(3);
dz = iFA.hdr.dime.pixdim(4);

%N=length(subjects);
N=2;
movie.img=zeros(Nx,Ny,N);

movie.hdr=iFA.hdr;
movie.hdr.dime.dim(4)=N;

%%%%%%%%%%%%
	%%% now to loop through them ALL!! 
for i=1:N
      subj=char(subjects(i));

%%% following line will need to be changed depending on how the files are stored/what they are named
  	fileName=char(strcat(dirI,subjects(i),'/',subjects(i),'_FA2T16pdownsampto2mm_9p.nii.gz')) 
  img=fopen(fileName,'r','l');
  if img >0
	  fclose(img);
  Fa=char(fileName);
  iFA = load_image(Fa);
  MDT = iFA.img;
	
% setting max and min values for each template
cminMDT = min(MDT(:));
cmaxMDT = max(MDT(:));

m=64;

% setting the slice numbers to make pngs for
sliceS = floor(Nx/3);
sliceC = floor(Ny/2);
sliceA = floor(Nz/2);

h1 = figure;
colormap(bone(m));

h1(1)=image(transpose(squeeze(MDT(Nx:-1:1,:,sliceA))));  hold on;
set(gca,'YDir','normal');
text('units','pixels','position',[4 9],'BackgroundColor','r','fontsize',18,'string',subj,'Interpreter','none');

C1 = min(m,round((m-1)*(MDT(Nx:-1:1,:,sliceA)-cminMDT)/(cmaxMDT-cminMDT))+1);
    set(h1(1),'CData',C1');
    axis off;
    axis image;
    set(gca,'DataAspectRatio',[dx/dy 1 1])
    hold off;

F=getframe(gca,[1 1 Nx Ny]);
C=transpose(squeeze(mean(F.cdata,3)));
Cname(:,1:Ny)=C(:,Ny:-1:1);

movie.img(:,:,i)=transpose(getimage);

    close all;    
	  
	 else
	 disp(['problem with subject ', subjects(i)]);
	 continue
	end
		 
end

save_nii(movie,niftifile)

