%% Sensitivity
clear;clc;
tmp1=readmatrix('F:\Precipitation Sensitivity\Revised\data\climate_data.xlsx','Sheet','tmp');
pre1=readmatrix('F:\Precipitation Sensitivity\Revised\data\climate_data.xlsx','Sheet','pre');
sw1=readmatrix('F:\Precipitation Sensitivity\Revised\data\climate_data.xlsx','Sheet','swr');
ring1=readmatrix('F:\Precipitation Sensitivity\Revised\data\tree ring.xlsx','Sheet','Sheet1');

sw=sw1(2:3486,57:119);
pre=pre1(2:3486,57:119);
tmp=tmp1(2:3486,57:119);
ring=ring1(2:3486,51:113);

num=nan(3485,1);
for ii=1:3485
    aa=ring(ii,:);
    num(ii,1)=numel(aa(isnan(aa)==0));
end

sensitivity=nan(3485,1);
for i=1:3485
    num1=num(i,1);
     if num1>56
        data=nan(63,5);
        ww=sw(i,1:63);
        pp=pre(i,1:63);
        rr=ring(i,1:63);
        tt=tmp(i,1:63);
        

        data(:,1)=tt;
        data(:,2)=pp;
        data(:,3)=ww;
        data(:,4)=rr;

        row=find(isnan(rr)==1);
        data(row,:)=[];
        X=[ones(length(data(:,1)),1),zscore(detrend(data(:,2))),zscore(detrend(data(:,1))),zscore(detrend(data(:,3)))];
        Y=zscore(data(:,4));
        [b,bint,r,rint,stats]=regress(Y,X,0.05);
            if stats(3)<=0.05
        sensitivity(i,1)=b(2);
            end
        disp(i)
     end
end

%% Moving Windows
clear;clc;
filename='climate_data';
tmp1=readmatrix(['F:\Precipitation Sensitivity\Revised\data\',filename,'.xlsx'],'Sheet','tmp');
pre1=readmatrix(['F:\Precipitation Sensitivity\Revised\data\',filename],'Sheet','pre');
sw1=readmatrix(['F:\Precipitation Sensitivity\Revised\data\',filename],'Sheet','swr');
ring1=readmatrix('F:\Precipitation Sensitivity\Revised\data\tree ring.xlsx');

s=size(ring1);
sw=sw1(2:3486,8:119);
pre=pre1(2:3486,8:119);
tmp=tmp1(2:3486,8:119);
ring=ring1(2:3486,2:113);
%
Psensitivity_30windows=nan(3485,100);
pre_30windows=nan(3485,100);

num=nan(s(1)-1,1);
for ii=1:s(1)-1
    aa=ring(ii,:);
    num(ii,1)=numel(aa(isnan(aa)==0));
end

for i=1:3485
    num1=num(i,1);
    if num1>56
        data=nan(112,5);
        ww=sw(i,1:112);
        pp=pre(i,1:112);
        rr=ring(i,1:112);
        tt=tmp(i,1:112);

        data(:,1)=tt;
        data(:,2)=pp;
        data(:,3)=ww;
        data(:,6)=rr;

        for j=1:length(data)-30
            x=[data(j:j+29,1),data(j:j+29,2),data(j:j+29,3)];
            y=data(j:j+29,6);
            row=find(isnan(y)==1);
            x(row,:)=[];
            y(row,:)=[];
            if (length(y))>=15
                X=[ones(length(y),1),zscore(detrend(x(:,2))),zscore(detrend(x(:,1))),zscore(detrend(x(:,3)))];
                Y=zscore(y(:,1));
                [b,bint,r,rint,stats]=regress(Y,X,0.05);
                if stats(3)<=0.05
                    Psensitivity_30windows(i,j)=b(2);
                    pre_30windows(i,j)=nanmean(pp(1,j:j+29));
                    tmp_30windows(i,j)=nanmean(tt(1,j:j+29));
                    sw_30windows(i,j)=nanmean(ww(1,j:j+29));


                    pre_cv_30windows(i,j)=nanstd(pp(1,j:j+29))/nanmean(pp(1,j:j+29));
                    tmp_cv_30windows(i,j)=nanstd(tt(1,j:j+29))/nanmean(tt(1,j:j+29));
                    sw_cv_30windows(i,j)=nanstd(ww(1,j:j+29))/nanmean(ww(1,j:j+29));
                end
            end
        end
    end
    disp(i)
end