classdef ContentHandler < handle
    % Class to manage the content of the Session window
    
    properties
        DBHandler % Handler to Database
        Handles
        MyDefaultTimer 
    end
    
    methods
        function obj = ContentHandler(handles,dbHandler)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.DBHandler = dbHandler;
            obj.Handles = handles;
            obj.MyDefaultTimer = DefaultTimer(handles.txt_timer);
            
            % Set Static Texts
            %Set Loaded File String
            set(handles.txt_currentFile,'String',...
                dbHandler.SessionData.GenerateOutputFileName());

            % Set Current Rows
            obj.update_gui();            
        end
                 
        function ShowFirstPage(obj)
           if(obj.DBHandler.TotalRowsNum()==0)
              % Matrix is empty, Create first row default
              obj.DBHandler= obj.DBHandler.AddNewDefaultRow();
           end            
           obj.update_gui();
        end
        
        function NextIfPossible(obj)
            if(obj.check_input_sanity())
                if(obj.DBHandler.CurrentRow <= ...
                        size(obj.DBHandler.DataMatrix,1))                    
                    disp("Next");
                    obj.update_csv_if_needed();
                    obj = obj.internal_next();
                end
            end   
        end
        
        function BeforeIfPossible(obj)
            if(obj.check_input_sanity())
                if(obj.DBHandler.CurrentRow > 1)                    
                    disp("Before");
                    obj.update_csv_if_needed();
                    obj = obj.internal_before();
                end
            end   
        end
        
        function SetValue(obj,handle,value)
            obj.DBHandler.SetValue(handle,value);
        end

        
    end
    
    methods (Access=private)
        function isOk = check_input_sanity(obj)
            isOk=false;
            if(obj.IfGroupEmptyThrowWarning(obj.Handles.Grp_P2_PosAffekt,...
                    "Bitte füllen Sie P2 Pos Affekt"))
                return
            end
            if(obj.IfGroupEmptyThrowWarning(obj.Handles.Grp_P2_NegAffekt,...
                    "Bitte füllen Sie P2 Neg Affekt"))
                return
            end
            %A2
            if(obj.IfCheckbokGroupWrong(obj.Handles.ChkBox_A2_PersF,...
                    obj.Handles.ChkBox_A2_PosG,...
                    obj.Handles.ChkBox_A2_PosInt,...
                    obj.Handles.Grp_A2_Inhalt,...
                    "Bitte füllen Sie Gruppe A2 korrekt."))
                return
            end
            
            % B1
            if(obj.IfCheckbokGroupWrong(obj.Handles.ChkBox_B1_Ziele,...
                    obj.Handles.ChkBox_B1_Los,...
                    obj.Handles.ChkBox_B1_Wahl,...
                    obj.Handles.Grp_B1_Inhalt,...
                    "Bitte füllen Sie Gruppe B1 korrekt."))
                return
            end
            
            % C1
            if(obj.IfCheckbokGroupWrong(obj.Handles.ChkBox_C1_Met,...
                    obj.Handles.ChkBox_C1_Aus,...
                    obj.Handles.ChkBox_C1_Abw,...
                    obj.Handles.Grp_C1_Inhalt,...
                    "Bitte füllen Sie Gruppe C1 korrekt."))
                return
            end

            % G3
            if(obj.IfGroupEmptyThrowWarning(obj.Handles.Grp_G3_Res,...
                    "Bitte füllen Sie Gruppe G3"))
                return
            end
            % A
            if(obj.IfGroupEmptyThrowWarning(obj.Handles.Grp_A_tiefe,...
                    "Bitte füllen Sie Gruppe A"))
                return
            end
            % B
            if(obj.IfGroupEmptyThrowWarning(obj.Handles.Grp_B_Therapie,...
                    "Bitte füllen Sie Gruppe B"))
                return
            end
            isOk=true;
        end
        
        function isWarn = IfCheckbokGroupWrong(obj,handles1,handles2,...
                handles3,handleInhalt,text)
            isWarn=false;
            if((get(handles1,'Value')~=0) ||...
                (get(handles2,'Value')~=0) ||...
                (get(handles3,'Value')~=0))                
                if(isempty(get(handleInhalt,'SelectedObject')))
                    isWarn = true;
                    f = warndlg(text);
                    uiwait(f);
                    return
                end            
            end
            
            if(not(isempty(get(handleInhalt,'SelectedObject'))))
                if((get(handles1,'Value')==0) &&...
                    (get(handles2,'Value')==0) &&...
                    (get(handles3,'Value')==0))   
                    isWarn = true;
                    f = warndlg(text);
                    uiwait(f);
                    return
                end
            end         
        end
        
        function isWarn = IfGroupEmptyThrowWarning(obj,grpHandle,text)
            isWarn =false;
            if(isempty(get(grpHandle,'SelectedObject')))
                isWarn=true;
                f = warndlg(text);
                uiwait(f);                
            end           
        end
        
        
        function obj = internal_next(obj)
            disp("Changing Rows from "+num2str(obj.DBHandler.CurrentRow)...
                +" to "+num2str(obj.DBHandler.CurrentRow+1));           
            obj.DBHandler.CurrentRow = obj.DBHandler.CurrentRow +1;
            if(obj.DBHandler.CurrentRow > size(obj.DBHandler.DataMatrix,1))
                obj.DBHandler.AddNewDefaultRow();
            end
            obj.update_gui();
        end
        
        function obj = internal_before(obj)
            disp("Changing Rows from "+num2str(obj.DBHandler.CurrentRow)...
                +" to "+num2str(obj.DBHandler.CurrentRow-1));
            obj.DBHandler.CurrentRow = obj.DBHandler.CurrentRow - 1;
            obj.update_gui();            
        end
        
        
        function update_csv_if_needed(obj)
            if(obj.DBHandler.NeedCSVUpdate)
                % NOTE: This can be more efficient. This is for simplicity. Performance
                % shouldnt be an issue.
                outputPath =obj.DBHandler.SessionData.GetOutputFilePath();
                csvwrite(outputPath,obj.DBHandler.DataMatrix);
                disp("Writting csv File...");
            end

            obj.DBHandler.NeedCSVUpdate=false;
        end
        
        function update_gui(obj)
            handles = obj.Handles;
            rowNum = obj.DBHandler.CurrentRow;
            dataMatrix = obj.DBHandler.DataMatrix;
            totalRows = size(dataMatrix,1);
            
            if(rowNum>0 && rowNum <=totalRows)
                % Load Data if possible
                % TODO Set handles
                %
                %
                %
                %
                currentRowData = dataMatrix(rowNum,:);
                
                %Affek
                obj.set_radionbtn_group(handles.Grp_P2_PosAffekt,...
                    currentRowData);
                obj.set_radionbtn_group(handles.Grp_P2_NegAffekt,...
                    currentRowData);
                % A2)
                obj.set_checkbox(handles.ChkBox_A2_PersF,currentRowData);               
                obj.set_checkbox(handles.ChkBox_A2_PosG,currentRowData);               
                obj.set_checkbox(handles.ChkBox_A2_PosInt,currentRowData);                               
                obj.set_radionbtn_group(handles.Grp_A2_Inhalt,...
                    currentRowData);
                % B1)
                obj.set_checkbox(handles.ChkBox_B1_Ziele,currentRowData);               
                obj.set_checkbox(handles.ChkBox_B1_Los,currentRowData);               
                obj.set_checkbox(handles.ChkBox_B1_Wahl,currentRowData);                               
                obj.set_radionbtn_group(handles.Grp_B1_Inhalt,...
                    currentRowData);    
                % C1)
                obj.set_checkbox(handles.ChkBox_C1_Met,currentRowData);               
                obj.set_checkbox(handles.ChkBox_C1_Aus,currentRowData);               
                obj.set_checkbox(handles.ChkBox_C1_Abw,currentRowData);                               
                obj.set_radionbtn_group(handles.Grp_C1_Inhalt,...
                    currentRowData);    
                % G3)
                obj.set_radionbtn_group(handles.Grp_G3_Res,...
                    currentRowData);                 
                % A)
                obj.set_radionbtn_group(handles.Grp_A_tiefe,...
                    currentRowData);                 
                % B)
                obj.set_radionbtn_group(handles.Grp_B_Therapie,...
                    currentRowData);   
                %
                %
                %
                %
                %
                %
                %

            end
            
            % Set Current Rows
            set(handles.txt_zeileNum,'String',...
                strcat(num2str(rowNum),"/",num2str(totalRows)));

            % Set Timer
            obj.MyDefaultTimer.stop();
            if(rowNum==totalRows)
                obj.MyDefaultTimer = DefaultTimer(handles.txt_timer);
                obj.MyDefaultTimer.start();
            end
        end
                
        function set_checkbox(obj,handle,valuesRow)
            csvIdx = obj.DBHandler.get_csv_idx_by_handle(handle);
            value = valuesRow(csvIdx);        
            if(isnan(value))
                set(handle,'Value',0);
                return
            end
            if((value == 0) || (value ==1))
                set(handle,'Value',value);
            else
                error("Checkbox Value is on 0 or 1");
            end
        end
        
        function set_radionbtn_group(obj,grpHandle,valuesRow)
            
            csvIdx = obj.DBHandler.get_csv_idx_by_handle(grpHandle);
            value = valuesRow(csvIdx);
            
            if(isnan(value))
                set(grpHandle,'SelectedObject',[]);
                return
            end
            
            radionBtns = get(grpHandle,'Children');
            for idx = 1:length(radionBtns)
                rbtn_tag = char(get(radionBtns(idx),'Tag'));
                btnValue = rbtn_tag(end:end);
                if(str2double(btnValue) == value)
                   set(grpHandle,'SelectedObject',radionBtns(idx));
                   return
                end
                btnValue = rbtn_tag(end-1:end-1);
                if(str2double(btnValue) == -value)
                   set(grpHandle,'SelectedObject',radionBtns(idx));
                   return
                end                                
            end
            
            error("RadioButton Assigned failed. Could find value "+...
                 num2str(value)+" in Group "+ get(grpHandle,'Tag'));
        end
        
        
              
    end
end

