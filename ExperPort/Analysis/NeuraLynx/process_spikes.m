function err=process_spikes(sessid,fldr,rt, force,eibid)
% This function will bring all cut clusters from a session into the DB.
%

err=0;
if nargin<4
	force=0;
	% should we replace the old data if this has been run before?
end


% get the ratname to put into cells for convenience.
ratname=bdata('select ratname from sessions where sessid="{S}"',sessid);
ratname=ratname{1};



%% checkif these have been processed

already_done=bdata('select count(*) from cells where sessid="{Si}"',sessid);

if already_done>0
	fprintf(2,'Session %i already processed\n', sessid);
	if force
		fprintf(2,'Reprocessing session %i. Deleting old entries\n', sessid);
		clearphys(sessid);
	else
		err=3;
		return;
	end

end

%% Try to load cutting notes in the phys_sess table


try
    in_phys_sess=bdata('select count(sessid) from phys_sess where sessid="{Si}"',sessid);
    if in_phys_sess>0
mym(bdata,'update phys_sess set cutting_notes="{F}" ,sync_fit_m="{S12}",sync_fit_b="{S12}" where sessid="{S}"','cutting.txt',rt(1),rt(2),sessid)    
    else
bdata('insert into phys_sess (sessid, cutting_notes,sync_fit_m,sync_fit_b) values ("{Si}", "{F}","{S12}","{S12}")',sessid,'cutting.txt',rt(1),rt(2))
    end
catch
    showerror(lasterror)
end

%% are there cells to process?

olddir=pwd;
try
	cd(fldr)
	cuts=dir('cut_*');
	if isempty(cuts)
		fprintf(1,'No cut cells to process\n');
		return;
	end

% This vector of indeces persists across files to deal with the case that a single channel 
% has been split into 2 files.

clust_ind=ones(32,1);

%% go through all the spike files.


	for sci=1:numel(cuts)

		f_name=cuts(sci).name;
		try
			[ts, cell_n,  waves, param, sc_n ,hd]=nlx_spike2mat(f_name);
			% convert the waves into microvolts
			[wsc, chans]=extract_header(hd);
            wsc=repmat(wsc(:),1,32);
            

			% all the cells from a single file are recorded from the same
			% channels
			sc_num=sc_n(1);
			
            % Assuming that there are 8 tetrodes on each EIB and the
            % tetrode num starts at 0
            
            cur_eib=eibid(floor(sc_num/8)+1);
            
                
            
			% keep track of how many cells per channel



			

			sql1='insert into bdata.channels (sessid, ad_channels, header, file_name, path_name) ';
			sql2=' values ("{Si}","{S}","{S}","{S}","{S}")';
			bdata([sql1 sql2], sessid, chans, hd, f_name, fldr);
			channelid=bdata('select last_insert_id()');



%%  For each cell in the spike file

			all_cells=unique(cell_n);
			
			for cx=1:numel(all_cells)
				cl_n=all_cells(cx);
				if cl_n==0
					% uncut spikes
					continue;
				end

				% first the cell table

				nSpikes=sum(cell_n==cl_n);
				cluster_in_file=cl_n;
				cluster=clust_ind(sc_num+1); % need to sc_num+1 because the channels are 0 indexed.
				clust_ind(sc_num+1)=clust_ind(sc_num+1)+1;
				sql1='insert into bdata.cells (ratname,sessid, channelid , sc_num, cluster ,  nSpikes , filename  , cluster_in_file,eibid) values ';
				sql2='("{S}","{Si}","{Si}","{Si}","{Si}","{Si}","{S}","{Si}","{Si}")';
				bdata([sql1 sql2],ratname,sessid, channelid, sc_num, cluster, nSpikes, f_name, cl_n,cur_eib);
				cellid=bdata('select last_insert_id()');
				% then the spike

				c_ts=ts(cell_n==cl_n)*rt(1)+rt(2);
				w.mn=squeeze(mean(waves(cell_n==cl_n,:,:)));       
                w.mn=w.mn.*wsc;
                try
    				w.std=squeeze(std(double(waves(cell_n==cl_n,:,:))));
                    w.std=w.std.*wsc;
                catch
                    sprintf('not enough memory to compute std of waveform');
                    w.std = zeros(size(w.mn));
                end;
				sql1='insert into bdata.spktimes (cellid, sessid, ts, wave) values ("{Si}","{Si}","{M}","{M}")';
				bdata(sql1, cellid, sessid, c_ts, w);
                
                
			end
		catch
			showerror(lasterror);
		end

	end
	err=0;
    
    %% Parse the cutting notes and update the cells table.
    
    [cn]=bdata('select cutting_notes from phys_sess where sessid="{S}"',sessid);
    
    S=parse_cutting_notes(cn{1});
    if isempty(S)
           fprintf(1,'No cutting notes for session %d\n',sessid);
    else
    for sx=1:numel(S)
        cellid=bdata('select cellid from cells  where sessid="{S}" and sc_num="{S}" and cluster="{S}"',sessid, S(sx).TT-1, S(sx).SC);
        bdata('call update_cutting("{S}","{S}","{S}")',cellid, S(sx).single, S(sx).cutting_comment);
    end
    fprintf(1,'Done session %d. %d cells added.\n',sessid,numel(S));
    end
    
    
catch
	showerror(lasterror);
	err=1;

end

cd(olddir)



%% get the parameters to convert the waveforms to uV

function [wscale,c_nums]=extract_header(hd)

n=regexp(hd,'InputRange','end');
eol=find(hd(n:end)==13,1,'first');
wscalen=str2num(hd(n+1:n+eol-1)); % THIS IS A TOTAL HACK
n=regexp(hd,'ADMaxValue','end');
eol=find(hd(n:end)==13,1,'first');
wscaled=str2num(hd(n+1:n+eol-1)); % THIS IS A TOTAL HACK
wscale=wscalen/wscaled;
n=regexp(hd,'-ADChannel','end');
c_nums=strtok(hd(n+1:n+12),'-');








