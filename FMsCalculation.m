function FMsValue=FMsCalculation(varargin)
% Function : calculate the focus measure value of the same area in one or more images.
% The last input parameter is the ROI (Region Of Interest) of the area of the image, the format is [x, y, width, height];
% The second input parameter is the vector composed of the characters of the focus measure, such as 'ACM'; 'BRE';
% The first input parameters are image (grayscale).
% The output is the focus measure value.
if nargin>2      
    ROI=varargin{nargin};
    FMs=varargin{nargin-1};
    NumOfFMs=size(FMs,1);  
    FMsValue=zeros(nargin-2,NumOfFMs);
    for i=1:nargin-2
        Img=varargin{i};
        Img=imcrop(Img,ROI);
        for j=1:NumOfFMs
            switch FMs(j,:)
                case 'AC' % Auto correlation 
                    % Said Pertuz, Domenec Puig, Miguel Angel Garcia, Analysis of focus measure operators for shapefrom-focus, Pattern Recognition, 46 (5) (2013) 1415-1432.
                    Image=double(Img);
                    FM=Image(:,1:end-2).*(Image(:,2:end-1)-Image(:,3:end));
                    FMsValue(i,j)=mean2(FM);  
                case 'Bre' % Brenner
                    % Said Pertuz, Domenec Puig, Miguel Angel Garcia, Analysis of focus measure operators for shapefrom-focus, Pattern Recognition, 46 (5) (2013) 1415-1432.
                    Image=double(Img);
                    FM=Image(:,3:end)-Image(:,1:end-2);
                    FM=FM.^2;
                    FMsValue(i,j)=mean2(FM);
                case 'DER' % Discrete cosine transform energy ratio
                    % Chun-Hung Shen, H. H. Chen, Robust focus measure for low-contrast Images, in 2006 Digest of Technical Papers International Conference on Consumer Electronics, 2006, pp. 69 -70.
                    Image=double(Img);
                    ImgDct=dct2(Image);
                    Edc=ImgDct(1,1).^2;
                    Eac=sum(sum(ImgDct.^2))-Edc;
                    FMsValue(i,j)=Eac/Edc;
                case 'Eig' % Eigenvalues
                    % Said Pertuz, Domenec Puig, Miguel Angel Garcia, Analysis of focus measure operators for shapefrom-focus, Pattern Recognition, 46 (5) (2013) 1415-1432.
                    Image=double(Img);
                    [M,N]=size(Image);
                    num=uint8(M/3);
                    Image=Image/sqrt(sum(sum(Image.^2)));
                    u=sum(sum(Image))/M/N; 
                    Image=Image-u;
                    sg=Image*Image'; 
                    [U,S,V]=svd(sg); 
                    FM=S'*S; 
                    FMsValue(i,j)=sum(FM(1:num));
                case 'Ent' % Entropy
                    % Xiaohua Xia, Lijuan Yin, Yunshi Yao, et al., Combining two focus measures to improve performance, Measurement Science and Technology, 28 (10) (2017) 105401.
                    Image=Img;
                    [M,N]=size(Image);
                    Hist=imhist(Image)/(M*N);
                    for k=1:256
                        if Hist(k)~=0
                            Hist(k)=-Hist(k)*log2(Hist(k));
                        end
                    end
                    FMsValue(i,j)=sum(Hist);
                case 'EOL' % Energy of Laplacian
                    % Yu Sun, Stefan Duthaler, Bradley J. Nelson, Autofocusing in computer microscopy: selecting the optimal focus algorithm, Microscopy Research and Technique, 65 (3) (2004) 139¨C149.
                    Image=double(Img);
                    Lap=[-1 -4 -1;-4 20 -4;-1 -4 -1];        
                    FM=imfilter(Image,Lap,'replicate');
                    FM=FM.^2;
                    FMsValue(i,j)=mean2(FM);             
                case 'SML' % Sum of Modified Laplacian 
                    % Said Pertuz, Domenec Puig, Miguel Angel Garcia, Analysis of focus measure operators for shapefrom-focus, Pattern Recognition, 46 (5) (2013) 1415-1432.
                    Image=double(Img);
                    M=[-1 2 -1];        
                    Lx=imfilter(Image,M,'replicate','conv');
                    Ly=imfilter(Image,M','replicate','conv');
                    FM=abs(Lx)+abs(Ly);
                    FMsValue(i,j)=mean2(FM);
                case 'SpF' % Spatial frequency
                    % Said Pertuz, Domenec Puig, Miguel Angel Garcia, Analysis of focus measure operators for shapefrom-focus, Pattern Recognition, 46 (5) (2013) 1415-1432.
                    Image=double(Img);
                    H2=Image(:,2:end)-Image(:,1:end-1);
                    V2=Image(2:end,:)-Image(1:end-1,:);
                    H2=H2.^2;
                    V2=V2.^2;
                    H2=mean2(H2);
                    V2=mean2(V2);
                    FMsValue(i,j)=sqrt(H2+V2);
                case 'StF' %Steerable filters
                    % Rashid Minhas, Abdul A. Mohammed, Q. M. Jonathan Wu, et al., 3D shape from focus and depth map computation using steerable filters, in International Conference Image Analysis and Recognition, 2009, pp. 573-583.
                    Image=double(Img);
                    WSize = 15; % Size of local window
                    N = floor(WSize/2);
                    sig = N/2.5;
                    [x,y] = meshgrid(-N:N, -N:N);
                    G = exp(-(x.^2+y.^2)/(2*sig^2))/(2*pi*sig);
                    Gx = -x.*G/(sig^2);Gx = Gx/sum(Gx(:));
                    Gy = -y.*G/(sig^2);Gy = Gy/sum(Gy(:));
                    R(:,:,1) = imfilter(Image, Gx, 'conv', 'replicate');
                    R(:,:,2) = imfilter(Image, Gy, 'conv', 'replicate');
                    R(:,:,3) = cosd(45)*R(:,:,1)+sind(45)*R(:,:,2);
                    R(:,:,4) = cosd(135)*R(:,:,1)+sind(135)*R(:,:,2);
                    R(:,:,5) = cosd(180)*R(:,:,1)+sind(180)*R(:,:,2);
                    R(:,:,6) = cosd(225)*R(:,:,1)+sind(225)*R(:,:,2);
                    R(:,:,7) = cosd(270)*R(:,:,1)+sind(270)*R(:,:,2);
                    R(:,:,8) = cosd(315)*R(:,:,1)+sind(315)*R(:,:,2);
                    FM=max(R,[],3);
                    FMsValue(i,j)=mean2(FM);
                case 'SWC' %Sum of Wavelet coeffs
                    % Ge Yang, Bradley J Nelson, Wavelet-based autofocusing and unsupervised segmentation of microscopic images, in 2003 IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS 2003), 2003, pp. 2143-2148.
                    Image=double(Img);
                    [C,S]=wavedec2(Image,1,'db6');
                    H=wrcoef2('h',C,S,'db6',1);   
                    V=wrcoef2('v',C,S,'db6',1);   
                    D=wrcoef2('d',C,S,'db6',1);   
                    FM=abs(H)+abs(V)+abs(D);
                    FMsValue(i,j)=mean2(FM);
                case 'Ten' % Tenengrad 
                    % Said Pertuz, Domenec Puig, Miguel Angel Garcia, Analysis of focus measure operators for shapefrom-focus, Pattern Recognition, 46 (5) (2013) 1415-1432.
                    Image=double(Img);
                    Sx=fspecial('sobel');
                    Gx=imfilter(Image,Sx ,'replicate','conv');
                    Gy=imfilter(Image,Sx','replicate','conv');
                    FM=Gx.^2+Gy.^2;
                    FMsValue(i,j)=mean2(FM);
                case 'Var' % Graylevel variance
                    % Said Pertuz, Domenec Puig, Miguel Angel Garcia, Analysis of focus measure operators for shapefrom-focus, Pattern Recognition, 46 (5) (2013) 1415-1432.
                    Image=double(Img);
                    FMsValue(i,j)=std2(Image);
                case 'VWC' % Variance of wavelet coefficients
                    % Hui Xie, Weibin Rong, Lining Sun, Wavelet-based focus measure and 3-D surface reconstruction method for microscopy images, in 2006 IEEE/RSJ International Conference on Intelligent Robots and Systems, 2006, pp. 229-234.
                    Image=double(Img);
                    [C,S]=wavedec2(Image,1,'db6');
                    H=wrcoef2('h',C,S,'db6',1);   
                    V=wrcoef2('v',C,S,'db6',1);   
                    D=wrcoef2('d',C,S,'db6',1);  
                    MeanH=mean2(H);
                    MeanV=mean2(V);
                    MeanD=mean2(D);
                    FM=(H-MeanH).^2+(V-MeanV).^2+(D-MeanD).^2;
                    FMsValue(i,j)=mean2(FM);
                otherwise
                    error('Unknown measure %s',upper(FMs(j,:)))
            end
        end  
    end
end 