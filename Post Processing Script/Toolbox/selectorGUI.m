%% Create a figure window:
fiGUI           = uifigure('Position',[650 250 300 300]);
lbl             = uilabel(fiGUI);
lbl.Text        = 'Choose the analysis type:'; 
lbl.Position    = [30 220 200 100];
lbl.FontSize    = 13;
cbx             = zeros(5,1);
cbx(1,1)        = uicheckbox(fiGUI,'Position',[55 230 102 15],...
                 'Text','Varying load');
cbx(2,1)        = uicheckbox(fiGUI,'Position',[55 208 102 15],...
                 'Text','Varying camber');
cbx(3,1)        = uicheckbox(fiGUI,'Position',[55 186 102 15],...
                 'Text','Pacejka');
cbx(4,1)        = uicheckbox(fiGUI,'Position',[55 164 150 15],...
                 'Text','Cornering Stiffness');
% cbx(5,1)        = uicheckbox(fiGUI,'Position',[55 164 150 15],...
%                  'Text','Normalized Fy');
cbx(5,1)        = uicheckbox(fiGUI,'Position',[55 142 102 15],...
                 'Text','All');   
b               = uibutton(fiGUI,'push','Position',[55 100 102 25],...
                 'ButtonPushedFcn', @(b,event) buttonPushed(b,cbx,fiGUI));
b.Text          = 'Confirm';

uiwait(fiGUI)

%% Create the function for the ValueChangedFcn callback:
function buttonPushed(~,cbx,fiGUI)
    selector = zeros(length(cbx),1);
     for xx = 1:length(selector)
        toggle = get(cbx(xx,1),'Value');
        if toggle == 1
            selector(xx) = 1;
        end
     end
     
    save('Toolbox/Temp/selector','selector')   
    uiresume(fiGUI)
    close(fiGUI)
end
