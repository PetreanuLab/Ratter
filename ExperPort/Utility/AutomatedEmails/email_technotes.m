function email_technotes(shift,varargin)

try
    if nargin == 0; shift = 'all'; end
    setpref('Internet','SMTP_Server','sonnabend.princeton.edu');
    setpref('Internet','E_mail','TechNotesMeister@Princeton.EDU');
    
    [TN T RG R TM] = bdata('select technotes, tech_initials, rig_id, ratname, timestamp from technician_notes_tbl where sessiondate="{S}"',datestr(now,29));
    
    if ~isempty(TN)
        message = cell(0);
        for i = 1:length(TN)
            if (strcmp(shift,'morning')   && str2num(TM{i}(12:13)) <  13) ||...
               (strcmp(shift,'afternoon') && str2num(TM{i}(12:13)) >= 13) ||...
                strcmp(shift,'all') %#ok<ST2NM>
           
                message{end+1} = ['Tech: ',T{i},'   Rig: ',num2str(RG(i)),'   Rat: ',R{i},'   Time: ',TM{i}(12:end)]; %#ok<AGROW>
                message{end+1} = TN{i}; %#ok<AGROW>
                message{end+1} = '  '; %#ok<AGROW>
            end
        end
        
        EE = bdata('SELECT DISTINCT email FROM ratinfo.contacts WHERE tech_afternoon=1');
        EC = bdata('SELECT DISTINCT email FROM ratinfo.contacts WHERE tech_computer=1');
        EM = bdata('SELECT DISTINCT email FROM ratinfo.contacts WHERE tech_morning=1');
        EA = bdata('SELECT DISTINCT email FROM ratinfo.contacts WHERE subscribe_all=1');
        
        email = unique([EM; EE; EA; EC]);
        
        if ~isempty(message)
            sendmail(email,['TechNotes for ',datestr(now,29)],message);

            for e = 1:length(email)
                temp = bdata(['SELECT experimenter FROM ratinfo.contacts WHERE email="',email{e},'"']);
                eval(['output.',temp{1},' = message;']);
            end

            LTR = 'abcdefghijklmnopqrstuvwxyz';
            for ltr = 1:26
                file = ['C:\Automated Emails\Schedule\TechNotes\',yearmonthday,LTR(ltr),'_TechNotes_Email.mat'];
                if ~exist(file,'file'); save(file,'output'); break; end    
            end
        end
    end
    
catch %#ok<CTCH>
    senderror_report;
end
        