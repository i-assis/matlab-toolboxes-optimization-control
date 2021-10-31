function [dcert,dunc,rowscert,colscert,rowsunc,colsunc] = separatecertainuncertain( in )
%SEPARATECERTAINUNCERTAIN - Internal

%   This file is part of RoMulOC
%   Last Update 29-Oct-2012
%   author : Dimitri Peaucelle
%   peaucelle@laas.fr
%   LAAS-CNRS, Toulouse, France

issampled=find(in.sampled);
rowscert=[];
colscert=[];
dcert=[];
for ii=1:size(in.struc,2)
  if ismember(in.struc(2,ii),issampled)
    rowscert=union(rowscert,in.rows{in.struc(2,ii)});
    colscert=union(colscert,in.cols{in.struc(2,ii)});
    dcert=blkdiag3d(dcert,in.usample{in.struc(2,ii)});
  end
end
isunc=find(~in.sampled);
rowsunc=[];
colsunc=[];
dunc=uncertainty;
dunc.nbb=length(isunc);
dunc.nominal=in.nominal(isunc);
dunc.usample=in.usample(isunc);
dunc.sampled=in.sampled(isunc);
dunc.transpose=in.transpose;
dunc.uindex=in.uindex(isunc);
dunc.names=in.names(isunc);
dunc.constr=in.constr(isunc);
dunc.constrcode=in.constrcode(isunc);
dunc.complex=in.complex(isunc);
dunc.distribution=in.distribution(isunc);
dunc.nature=in.nature(isunc);
dunc.X=in.X(isunc);
dunc.Y=in.Y(isunc);
dunc.Z=in.Z(isunc);
dunc.vtx=in.vtx(isunc);
dunc.ubase=in.ubase(isunc);
rws=0;
cls=0;
diagpos=0;
dunc.rows=cell(1,length(isunc));
dunc.cols=cell(1,length(isunc));
for ii=1:size(in.struc,2)
  if ismember(in.struc(2,ii),isunc)
    rowsunc=union(rowsunc,in.rows{in.struc(2,ii)});
    colsunc=union(colsunc,in.cols{in.struc(2,ii)});
    diagpos=diagpos+1;
    locidx=find(dunc.uindex==in.struc(1,ii));
    dunc.struc(1,diagpos)=in.struc(1,ii);
    dunc.struc(2,diagpos)=locidx;
    addrws=size(in.rows{in.struc(2,ii)},1);    
    dunc.rows{locidx}(:,end+1)=rws+(1:addrws);
    rws=rws+addrws;
    addcls=size(in.cols{in.struc(2,ii)},1);
    dunc.cols{locidx}(:,end+1)=cls+(1:addcls);
    cls=cls+addcls;
  end
end
dunc.size=[rws,cls];
rowscert=reshape(rowscert,1,[]);
colscert=reshape(colscert,1,[]);
rowsunc=reshape(rowsunc,1,[]);
colsunc=reshape(colsunc,1,[]);

