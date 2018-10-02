classdef SessionData < handle
    % Object to gather data for the session
    properties
        %Static session data
        PatientNum %Int
        SessionNum  %Int
        Rater %Int
        
        % Dyn session data
        DataMatrix %Matrix
        
        % Output
        OutputFolder %String
    end
    
    methods
        function obj = SessionData()
            % Constructor
        end
        
        function path = GetOutputFilePath(obj)
            filename = obj.GenerateOutputFileName();
            path = strcat(obj.OutputFolder,"/",filename);
        end
        
        function Parse(obj,filename)
            [filepath,name,ext] = fileparts(filename);
            obj.OutputFolder=filepath;
            cells = strsplit(name,"_");
            if(length(cells)==4)
                obj.PatientNum = str2double(cells{2});
                obj.SessionNum = str2double(cells{3});
                obj.Rater = str2double(cells{4});
            else
                h= errordlg("Fehler tratt auf! Nicht alle Meta-Daten der Sitzung konnten gelesen werden. Wir korrigieren Sie den File-Titel.","Fehler beim Laden des Files");
                uiwait(h);                
            end
            
        end
        
        function filename = GenerateOutputFileName(obj)
           filename = strcat("Sitzung_",num2str(obj.PatientNum),"_",...
               num2str(obj.SessionNum),"_",num2str(obj.Rater),".csv"); 
        end
        
        function set.OutputFolder(obj,value)
            obj.OutputFolder = value;
        end
        
        function set.PatientNum(obj,value)
            if(isnan(value))
                error("Patientennummer kann nicht Text sein.")
            end
            obj.PatientNum = value;
        end
        
        function set.SessionNum(obj,value)
            if(isnan(value))
                error("Sitzungsnummer kann nicht Text sein.")
            end
            obj.SessionNum = value;
        end
        
        function set.Rater(obj,value)
            if(isnan(value))
                error("Rater kann nicht text sein.")
            end
            obj.Rater = value;
        end
    end
end

