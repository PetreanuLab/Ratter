function checknoratsrun(slots,varargin)

try 
    try 
        riglist = mym(bdata,['SELECT DISTINCT rig FROM ratinfo.schedule WHERE date="',datestr(now, 29),'";']);
    catch %#ok<CTCH>
        bdata('connect');
        riglist = mym(bdata,['SELECT DISTINCT rig FROM ratinfo.schedule WHERE date="',datestr(now, 29),'";']);
    end

    setpref('Internet','SMTP_Server','sonnabend.princeton.edu');
    setpref('Internet','E_mail','ScheduleMeister@Princeton.EDU');
    
    if nargin == 0; slots = 1:6; end
          
    rigs = riglist.rig;
    E = cell(0);
    output = []; %#ok<NASGU>

    aratdidrun = 0;
    for slot = slots
        for rig = rigs'
            temp1 = mym(bdata,['SELECT DISTINCT ratname FROM ratinfo.schedule WHERE rig="',num2str(rig),'" AND timeslot="',num2str(slot),'" AND date="',datestr(now,29),'";']);
            if isempty(temp1.ratname); continue; end
            ratname = temp1.ratname{1};
            if isempty(ratname); continue; end
            
            temp2 = mym(bdata,['SELECT DISTINCT n_done_trials FROM sessions WHERE ratname="',ratname,'" AND sessiondate="',datestr(now,29),'";']);
            temp3 = mym(bdata,['SELECT DISTINCT Starttime FROM sessions WHERE ratname="',ratname,'" AND sessiondate="',datestr(now,29),'";']);
            n_done_trials = max(temp2.n_done_trials);
            if isempty(temp3.Starttime); Ts = []; else Ts = temp3.Starttime{1}; end
            
            %disp([ratname,' ',num2str(slot),' ',num2str(rig),' ',num2str(n_done_trials),' ',num2str(Ts)]);
            if ~isempty(n_done_trials) || ~isempty(Ts)
                aratdidrun = 1; continue;
            end
            
            E{end+1} = ratname; %#ok<AGROW>
            
        end
    end

    E = unique(E);
    
    email = cell(0);
    if aratdidrun == 0
        message = cell(0);
        message{end+1} = ['No rats appeared to run today in sessions ',num2str(slots)];
        message{end+1} = 'Please contact the appropriate tech and make sure someone';
        message{end+1} = 'gives the rats their 30 minutes of free water.';
        message{end+1} = ' ';
        message{end+1} = 'Thanks,';
        message{end+1} = 'The Schedule Meister';
        message{end+1} = '  ';                                                             
        message{end+1} = '  ';                                                             
        message{end+1} = 'This email was generated by the Brody Lab Automated Email System.';
        
        for e = 1:length(E)
            sqlstr = ['SELECT DISTINCT contact FROM ratinfo.rats WHERE ratname="',E{e},'";'];
            z = mym(bdata,sqlstr);
            temp = parse_emails(z.contact{1});
            
            for t = 1:length(temp)
                email{end+1} = [temp{t},'@Princeton.EDU']; %#ok<AGROW>
            end
        end
        
        z = mym(bdata,'SELECT DISTINCT email FROM ratinfo.contacts WHERE subscribe_all=1');
        email(end+1:end+length(z.email)) = z.email;
            
        z = mym(bdata,'SELECT DISTINCT email FROM ratinfo.contacts WHERE lab_manager=1;');
        email(end+1:end+length(z.email)) = z.email;
        
        if sum(slots < 4) > 0 
            z = mym(bdata,'SELECT DISTINCT email FROM ratinfo.contacts WHERE tech_morning=1;');
            email(end+1:end+length(z.email)) = z.email;
        end
        if sum(slots > 3) > 0 
            z = mym(bdata,'SELECT DISTINCT email FROM ratinfo.contacts WHERE tech_afternoon=1;');
            email(end+1:end+length(z.email)) = z.email;
        end
        email = unique(email);
         
        for e = 1:length(email)
            expname = mym(bdata,['SELECT DISTINCT experimenter FROM ratinfo.contacts WHERE email="',email{e},'";']);
            expname = expname.experimenter{1};
            eval(['output.',expname,' = message;']);
        end
        
        message = remove_duplicate_lines(message);
        sendmail(email,'No Rats Ran Today',message);    
    end
    
    LTR = 'abcdefghijklmnopqrstuvwxyz';
    for ltr = 1:26
        file = ['C:\Automated Emails\Schedule\NoRun\',yearmonthday,LTR(ltr),'_NoRatsRan_Email.mat'];
        if ~exist(file,'file'); save(file,'output'); break; end    
    end

catch %#ok<CTCH>
    senderror_report;
end





