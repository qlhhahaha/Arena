classdef Policy < handle
    properties
        obtainMap
        dilateMap
        startPosP
        endPosP
        obstacles
    end
    
    properties
        viewerP1
        viewerP2
        agentP
        agentOccupy
    end

    methods
        
        function self = Policy()
            self.obtainMap=zeros(50,50);
        end
        
        function action=action(self,observation)
            if observation.collide
                action=[-10,rand(1)-0.5];
            else
                action=[10,rand(1)-0.5];
            end
            %action=[0,0];
            
            self.obtainMap=double(observation.scanMap'|self.obtainMap);
            
            %self.dilate();
        end
        
%         function dilate(self)
%             for i=1:50
%                 for j=1:50
%                     if self.obtainMap(i,j)==1
%                         self.dilateMap=
                        
        
        function reset(self,observation)
            self.obtainMap=observation.scanMap;
            self.viewerP1=Viewer(50,50);
            %self.viewerP2=Viewer(50,50);
            self.endPosP=observation.endPos;
            self.plotEndPosP(self.viewerP1.ax);
            self.plotMapP(self.viewerP1.ax);
            %self.plotEndPosP(self.viewerP2.ax);
            %self.plotMapP(self.viewerP2.ax);
            
            self.agentP=Agent(observation.startPos.x,observation.startPos.y,observation.startPos.heading,...
                8,0.58,2);
        end
        
        function render(self,observation)
            
            self.plotMapP(self.viewerP1.ax);
            
            self.agentP.x=observation.agent.x;
            self.agentP.y=observation.agent.y;
            self.agentP.h=observation.agent.h;
            self.agentP.plot(self.viewerP1.ax);
            self.agentOccupy=observation.agent.updateOccupyMap();
        end
        
        function plotEndPosP(self,handle)
            persistent hPlot;
            
            X=[self.endPosP.x self.endPosP.x+1 self.endPosP.x+1 self.endPosP.x self.endPosP.x];
            Y=[self.endPosP.y self.endPosP.y self.endPosP.y+1 self.endPosP.y+1 self.endPosP.y];
            
            X=[X self.endPosP.x self.endPosP.x+1 ];
            Y=[Y self.endPosP.y self.endPosP.y+1];
            
            X=[X self.endPosP.x+1 self.endPosP.x];
            Y=[Y self.endPosP.y self.endPosP.y+1];
            if isempty(hPlot)
                hPlot=plot(handle,X,Y,'r-','linewidth',3);
            else
                set(hPlot,'XData',X,'YData',Y);
            end
        end
        
        function plotMapP(self,handle)
            persistent fillHandle;
            %self.obtainmap=mapdata;
            [I,J]=find(self.obtainMap==1);
            self.obstacles=[J I]';
            len=size(self.obstacles,2);
            fillHandle=zeros(len,1);
            for i=1:len
                x=self.obstacles(1,i)-1;
                y=self.obstacles(2,i)-1;
                corners=[x,y;x+1,y;x+1,y+1;x,y+1];
                if fillHandle(i)==0
                    fillHandle(i)=fill(handle,corners(:,1),corners(:,2),'k');
                else
                    set(fillHandle(i),'XData',corners(:,1),'YData',corners(:,2));
                end
            end
        end
    end
end