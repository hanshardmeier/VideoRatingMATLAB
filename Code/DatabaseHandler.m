classdef DatabaseHandler < handle
    % Handles the DataMatrix
    
    properties
        NeedCSVUpdate % Set to true if CSV update needed 
        CurrentRow 
        SessionData 
        DataMatrix
        Handles
    end
    
    methods
        function obj = DatabaseHandler(sessionData,handles)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.SessionData = sessionData;
            obj.NeedCSVUpdate=false;
            obj.CurrentRow = 1;
            obj.Handles = handles;
            dataMatrix=[];
            try
                dataMatrix = csvread(sessionData.GetOutputFilePath());
            catch 
                disp("Reading empty CSV File. Setting Matrix to empty");
            end

            obj.DataMatrix = dataMatrix;            
        end
        
        function obj = SetValue(obj,handle,value)
            obj.NeedCSVUpdate=true;
            csvIdx = obj.get_csv_idx_by_handle(handle);            
            obj.DataMatrix(obj.CurrentRow,csvIdx)=value;                      
        end
        
        
        function obj = AddNewDefaultRow(obj)
            d=obj.SessionData;
            defaultRow = [d.Rater d.PatientNum d.SessionNum ...
                           size(obj.DataMatrix,1)+1 ...
                           nan nan ...  % P2
                           0 0 0 nan... % A2
                           0 0 0 nan... % B1
                           0 0 0 nan... % C1
                           nan nan nan];% G3 A B
            obj.DataMatrix = [obj.DataMatrix;defaultRow];                                   
        end
        
        function num = TotalRowsNum(obj)
           num=size(obj.DataMatrix,1); 
        end
        
        function obj = set.DataMatrix(obj,value)
            obj.DataMatrix = value;
        end

          function num = get_csv_idx_by_handle(obj,handle)
            switch handle
               case obj.Handles.Grp_P2_PosAffekt
                  num =5;
               case obj.Handles.Grp_P2_NegAffekt
                  num = 6;
               case obj.Handles.ChkBox_A2_PersF
                  num = 7;
               case obj.Handles.ChkBox_A2_PosG
                  num = 8;          
               case obj.Handles.ChkBox_A2_PosInt
                  num = 9;
               case obj.Handles.Grp_A2_Inhalt
                  num = 10;
               case obj.Handles.ChkBox_B1_Ziele
                  num = 11;
               case obj.Handles.ChkBox_B1_Los
                  num = 12;          
               case obj.Handles.ChkBox_B1_Wahl
                  num = 13;
               case obj.Handles.Grp_B1_Inhalt
                  num = 14;
               case obj.Handles.ChkBox_C1_Met
                  num = 15;
               case obj.Handles.ChkBox_C1_Aus
                  num = 16;          
               case obj.Handles.ChkBox_C1_Abw
                  num = 17;
               case obj.Handles.Grp_C1_Inhalt
                  num = 18;                  
               case obj.Handles.Grp_G3_Res
                  num = 19;
               case obj.Handles.Grp_A_tiefe
                  num = 20; 
               case obj.Handles.Grp_B_Therapie
                  num = 21; 
                otherwise
                  error("Handle index not known");
            end            
          end        
    end
end

