classdef DefaultTimer
    %Object for the Time on last known row evaluation
    
    properties (Constant)
      StartColor = [0 1 0] %Green
      EndColor = [1 0 0] %Red
      DefaultTime = 60 %Seconds
    end
   
    properties
        m_timer
        m_displayhandle
    end
    
    methods
        function obj = DefaultTimer(displayHandle)
            obj.m_displayhandle=displayHandle;
            obj.m_timer = timer(...,
                'StartFcn',@(tmr,~)timer_start_callback(displayHandle),...
                'Period',1,...
                'ExecutionMode','fixedSpacing',...
                'TasksToExecute',obj.DefaultTime+2,...
                'TimerFcn',@(tmr,~)timer_period_callback(displayHandle),...
                'StopFcn',@(tmr,~)timer_stop_callback(tmr));
            
            function timer_start_callback(displayHandle)
                tic;
                set(displayHandle,'backgroundcolor',obj.StartColor);
            end
            
            function timer_period_callback(displayHandle)
                timeLeft = int8(obj.DefaultTime-toc);
                if(timeLeft<=0)
                    set(displayHandle,'backgroundcolor',obj.EndColor);
                    set(displayHandle,'String',"0 sek.");
                    return;
                end
                set(displayHandle,'String',...
                    strcat(num2str(timeLeft)," sek."));    
            end
        
            function timer_stop_callback(tmr) 
                if(isvalid(tmr))
                    delete(tmr); 
                end
            end
        end
        
       
        function start(obj)        
            if(isvalid(obj.m_timer))
               start(obj.m_timer);
            end
        end
        
        function stop(obj)
            if(isvalid(obj.m_timer))
               stop(obj.m_timer);
               delete(obj.m_timer); 
            end
            set(obj.m_displayhandle,'backgroundcolor',obj.EndColor);
            set(obj.m_displayhandle,'String',"0 sek.");
        end
        
        
    end
end

