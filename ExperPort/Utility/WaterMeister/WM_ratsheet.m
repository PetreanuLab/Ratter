function WM_ratsheet(ratnames,handles)

axes(handles.axes1);
[R,I] = sortrows(ratnames(:,2));
ratnames = ratnames(I,:);

[TL RGB] = bdata('select tag_letter,tag_RGB from ratinfo.contacts');
C = cell(0);
for e = 1:length(TL)
    if ~isempty(TL{e});  C{end+1,1} = TL{e};  else continue; end %#ok<AGROW>
    if ~isempty(RGB{e}); C{end,  2} = RGB{e}; else C{end,2} = [1 1 1]; end
end

if     size(ratnames,1) <= 20; h = 5; w = 4; fs = calcfontsize(handles.fontsize_ratname,      handles);
else                           h = 6; w = 5; fs = calcfontsize(handles.fontsize_ratname * 0.8,handles);
end

axlm = get(handles.axes1,'xlim');
aylm = get(handles.axes1,'ylim');

for f = 1:ceil(size(ratnames,1)/(h*w))
    
    if f ~= ceil(size(ratnames,1)/(h*w))
        ratnames_temp = ratnames(((f-1)*h*w)+1:f*h*w,:);
    else
        ratnames_temp = ratnames(((f-1)*h*w)+1:end,:);
    end
    
    xc = (diff(axlm)/(w*2))+axlm(1):diff(axlm)/w:axlm(2)-(diff(axlm)/(w*2)); 
    yc = (diff(aylm)/(h*2))+aylm(1):diff(aylm)/h:aylm(2)-(diff(aylm)/(h*2));

    cnt = 0;
    for x = xc
        for y = yc
            cnt = cnt + 1;
            if cnt > size(ratnames_temp,1); continue; end
            makelabel(x,y,100/w,75/h,ratnames_temp(cnt,:),C,fs);
        end
    end

    set(gca,'Units','Normalized');
end




function makelabel(x,y,dx,dy,ratnames,C,fs)
ratnames(strcmp(ratnames,'')) = [];

text(x-(dx/4),y,ratnames,'fontsize',fs);
c = C{strcmp(C(:,1),ratnames{1}(1)),2};

pw = 2;
ph = 10;

p1 = [x-(dx/4)-pw-1, y-(dy/2)+((dy-ph)/2)];
p2 = [x+(dx/4)+1,    y-(dy/2)+((dy-ph)/2)];

patch([p1(1) p1(1)+pw p1(1)+pw p1(1)],[p1(2) p1(2) p1(2)+ph p1(2)+ph],c);
patch([p2(1) p2(1)+pw p2(1)+pw p2(1)],[p2(2) p2(2) p2(2)+ph p2(2)+ph],c);