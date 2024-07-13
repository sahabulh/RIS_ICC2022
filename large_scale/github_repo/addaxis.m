classdef addaxis < hgsetget & matlab.mixin.Heterogeneous
    properties(Abstract, Constant)
        dimension;
    end
    properties
        h_axis_line;    % Invisible
        h_axis;
    end
    properties(Access=protected)
        h_parent_line;
        h_parent;
        % Listeners
        l_parent_lim;
        l_axis_lim;
        l_axis_data;
        l_parent_resize;
        l_parent_recolor;
        
        zoom_lim_cache;
    end
    methods(Abstract = true, Access=protected)
        RequiredSpace = getRequiredSpace(obj);
        OuterPosition = resizePeerAxis(obj, OuterPosition);
    end
    methods(Sealed = true)
        function var = eq(varargin)
            var = eq@hgsetget(varargin{:});
        end
        function var = ne(varargin)
            var = ne@hgsetget(varargin{:});
        end
    end
    methods
        function hfig = GetParentFig(obj)
            hfig = obj.h_parent;
            while ~strcmpi(get(hfig, 'Type'), 'figure')
                hfig = get(hfig, 'Parent'); % In case docked inside a tab/panel..
            end
        end
        function obj = plot(obj, varargin)
            % Remove any args meant for this class
            label = [obj.dimension 'Label'];
            lim = [obj.dimension, 'Lim'];
            data = [obj.dimension, 'Data'];
            scale = [obj.dimension 'Scale'];
            dir   = [obj.dimension 'Dir'];
            
            
            i = 1;
            set_args = struct('PlotFcn', @plot, label, [], lim, []);
            while (i < length(varargin))
                if ischar(varargin{i}) && isfield(set_args, varargin{i})
                    set_args.(varargin{i}) = varargin{i+1};
                    varargin = varargin(setdiff(1:length(varargin), [i,i+1]));
                else
                    i = i + 1;
                end
            end
            
            % Plot, but make the lineseries invisible
            axes(obj.h_axis);
            if ~isempty(obj.h_axis_line)
                hold(obj.h_axis, 'on');
            end
            obj.h_axis_line(end+1) = set_args.PlotFcn(varargin{:});
            
            ylim(obj.h_axis); % Force YLim to auto-scale
            set(obj.h_axis, [lim 'Mode'], 'manual');
            if length(obj.h_axis_line)==1
                try
                    set(obj.h_axis,[(lower(obj.dimension)) 'color'], ...
                        get(obj.h_axis_line,'color'));
                end
            end
            
            %% Plot on the master axis
            axes(obj.h_parent);
            hold(obj.h_parent, 'on');
            set(obj.h_parent, [lim 'Mode'], 'manual');
            obj.h_parent_line(length(obj.h_axis_line)) = ...
                set_args.PlotFcn(varargin{:});
            
            %% Calculate transform, apply listeners
            obj = obj.applyTransform();
            % Apply YLim property listeners
            obj.l_parent_lim = addlistener(obj.h_parent, ...
                {lim, scale, dir}, 'PostSet', @(h, ev) obj.applyTransform(h,ev));
            obj.l_axis_lim = addlistener(obj.h_axis, ...
                {lim, scale, dir}, 'PostSet', @(h, ev) obj.applyTransform(h,ev));
            % Put one on the h_axis_line property too
            for i = 1:length(obj.h_axis_line)
                lh = addlistener(obj.h_axis_line(i), ...
                    data, 'PostSet', @(h, ev) obj.applyTransform(h,ev));
                if isempty(obj.l_axis_data)
                    obj.l_axis_data = lh;
                else
                    obj.l_axis_data(i) = lh;
                end
            end
            
            % Set dummy line invisible..
            set(obj.h_axis_line,'visible','off');
            
            % Set any other properties...
            if ~isempty(set_args.(label))
                set(obj, label, set_args.(label));
            end
            if ~isempty(set_args.(lim))
                set(obj.h_axis, lim, set_args.(lim));
            end
            
            % Change gca to parent axis
            axes(obj.h_parent);
        end
        
        function p = getPeers(obj)
            p = addaxis.getAxes(obj.h_parent);
        end
        function obj = addaxis(varargin)
            %% Get parent axis
            if isscalar(varargin{1}) && ishandle(varargin{1}) && strcmp(get(varargin{1}, 'Type'), 'axes')
                obj.h_parent = varargin{1};
                varargin = varargin(2:end);
            else
                obj.h_parent = gca;
            end
            
            %% Create a second axis, for ticks. Format it.
            hContainer = get(obj.h_parent, 'Parent');
            obj.h_axis = axes('Parent', hContainer);
            set(obj.h_axis, 'Units', 'pixels');
            % Plot
            obj = obj.plot(varargin{:});
            
            % Format the second axis
            switch get(hContainer, 'Type')
                case 'figure'
                    propname = 'Color';
                otherwise
                    propname = 'BackgroundColor';
            end
            set(obj.h_axis,'color',get(hContainer,propname));
            % Add listener for bg color (useful for saving plots...)
            obj.l_parent_recolor = addlistener(hContainer, ...
                propname, 'PostSet', @(h, ev) obj.cbContainerColor(h, ev));
            % Resize using a listener
            obj.l_parent_resize = addlistener(obj.GetParentFig, ...
                'Position', 'PostSet', @(h, ev) obj.resizeParentAxis(obj.h_parent));
            if obj.GetParentFig ~= hContainer
                obj.l_parent_resize(2) = addlistener(hContainer, ...
                    'Position', 'PostSet', @(h, ev) obj.resizeParentAxis(obj.h_parent));
            end
            
            % Set this object inside the peers stored in appdata
            axh = obj.getPeers();
            if isempty(axh)
                axh = obj;
            else
                axh = [axh, obj];
            end
            addaxis.setAxes(obj.h_parent,axh);
            
            %% Get the figure handle... set callbacks etc. (this can be changed later)
            hfig = obj.GetParentFig;
            
            % Set callback hooks for Zoom/Pan tools
            hax = obj.h_parent;
            set(zoom(hfig),'ActionPostCallback',@(x,y)  addaxis.postZoomFcn(x, y));
            set(zoom(hfig),'ActionPreCallback',@(x,y) addaxis.preZoomFcn(x, y));
            set(pan( hfig),'ActionPostCallback',@(x,y)  addaxis.postZoomFcn(x, y));
            set(pan( hfig),'ActionPreCallback',@(x,y) addaxis.preZoomFcn(x, y));
            zoom reset;
            % Use custom datatips
            dcm = datacursormode(hfig);
            set(dcm, 'Enable', 'on', 'UpdateFcn', @(h, event) addaxis.dataTipText(h, event));
            datacursormode(hfig, 'off');
            
            % Force a resize event
            obj.h_parent = addaxis.resizeParentAxis(obj.h_parent);
        end
        function delete(obj)
            try
                % Clean up object... Remove listeners...
                delete(obj.l_parent_lim);
                delete(obj.l_axis_lim);
                delete(obj.l_axis_data);
                delete(obj.l_parent_resize);
                % Remove drawing objects...
                handles = [obj.h_axis_line, obj.h_axis, obj.h_parent_line];
                handles = handles(ishandle(handles));
                delete(handles);
            end
            try % Remove object from appdata, if parent still exists
                aad = addaxis.getAxes(obj.h_parent);
                aad = setxor(union(aad, obj), obj);
                addaxis.setAxes(obj.h_parent, aad);
                % Force a resize
                addaxis.resizeParentAxis(obj.h_parent);
            end
        end
        
        function obj = preZoom(obj, handle, event)
            obj.zoom_lim_cache = get(obj.h_parent, [obj.dimension 'Lim']);
        end
        function obj = postZoom(obj, handle, event)
            lim = [obj.dimension 'Lim'];
            % Adapt YLim for this axis
            new_lim = get(obj.h_parent, lim);
            AAD = addaxis.getAxes(obj.h_parent);
            old_lim = obj.zoom_lim_cache;
            
            c_lim = get(obj.h_axis, lim);
            m = diff(old_lim)/diff(c_lim);
            c = old_lim(1) - m*c_lim(1);
            yl = (new_lim - c)/m;
            set(obj.h_axis, lim, yl);
            % Resize axis in case ticks have changed size
            obj.resizeParentAxis(obj.h_parent);
        end
        
    end
    methods(Static = true)
        function preZoomFcn(handle, event)
            hax = event.Axes;
            aad = addaxis.getAxes(hax);
            for i = 1:length(aad)
                aad(i).preZoom(hax, event);
            end
        end
        function postZoomFcn(handle, event)
            hax = event.Axes;
            aad = addaxis.getAxes(hax);
            for i = 1:length(aad)
                aad(i).postZoom(hax, event);
            end
        end
        
        function h_axes = getAxes(hObj)
            %  This function allows some data to be stored within the axis
            %  handle
            h_axes = getappdata(hObj, 'addaxis_data');
        end
        function output_txt = dataTipText(hObj,event_obj)
            % Custom text generation for AAD datatips
            
            % Identify the lineseries from the handle...
            lineH = get(event_obj, 'Target');
            hax = get(lineH, 'Parent');
            aad = addaxis.getAxes(hax);
            
            pos = get(event_obj,'Position');
            
            axis_idx = [];
            line_idx = [];
            for i = 1:length(aad)
                lx = find(aad(i).h_parent_line == lineH, 1);
                if ~isempty(lx)
                    line_idx = lx;
                    axis_idx = i;
                end
            end
            
            if ~isempty(axis_idx)
                % It's put on one of the ADDAXIS lineseries..
                label = aad(axis_idx).getLabel;
                % Index to find the real point
                idx_x = find(get(aad(axis_idx).h_parent_line(line_idx), 'XData') == pos(1));
                idx_y = find(get(aad(axis_idx).h_parent_line(line_idx), 'YData') == pos(2));
                idx = intersect(idx_x, idx_y);
                if length(pos) >= 3
                    idx_z = find(get(aad(axis_idx).h_parent_line(line_idx), ...
                        'ZData') == pos(3));
                    idx = intersect(idx, idx_y);
                end
                % Write x/y/z data back to point
                if ~isempty(idx)
                    idx = idx(1);
                    xd = get(aad(axis_idx).h_axis_line(line_idx), 'XData');
                    pos(1) = xd(idx);
                    yd = get(aad(axis_idx).h_axis_line(line_idx), 'YData');
                    pos(2) = yd(idx);
                    if length(pos) >= 3
                        zd = get(aad(axis_idx).h_axis_line(line_idx), 'ZData');
                        pos(3) = zd(idx);
                    end
                end
            else
                label = get(get(hax, 'YLabel'), 'String');
                axis_idx = 0;
            end
            chantext = sprintf('%i: %s', axis_idx+1, label);
            
            % Output point co-ords
            output_txt = {chantext, ['X: ',num2str(pos(1),4)],...
                ['Y: ',num2str(pos(2),4)]};
            % If there is a Z-coordinate in the position, display it as well
            if length(pos) > 2
                output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
            end
        end
        
        function hax = resizeParentAxis(hax, OuterPos)
            % Main input to function is hidden: OuterPos, this is the outer extent of
            % the axis...
            set(hax, 'Units', 'Pixels');
            TForm = [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]; % TI to Pos tform matrix
            
            hfig = hax;
            while ~strcmpi(get(hfig, 'Type'), 'figure')
                hfig = get(hfig, 'Parent'); % In case docked inside a tab/panel..
            end
            hParent = get(hax, 'Parent');
            
            % Default outerpos to figure dimensions..
            PU = get(hParent, 'Units');
            set(hParent, 'Units', 'pixels');
            if nargin <= 1
                OuterPos = get(hParent, 'Position');
                OuterPos(1:2) = [0, 0]; % Set origin to LH corner if fig
            end
            
            % Resize plot area incl. colorbar if present...
            spacer = 2; % 2 px border <- Is this needed??
            
            TI = get(hax, 'TightInset');
            % This part calculates the border needed to store extra axis
            RequiredSpace = zeros(1,4);
            % Give extra space if docked in a panel
            if strcmpi(get(hParent, 'Type'), 'uipanel')
                border = 2;
                title = 10;
                RequiredSpace = [border, border, (2*border), (2*border + title)];
            end

            % Thin axis, compute space requirements
            AAD = addaxis.getAxes(hax);
            for i = 1:length(AAD)
                RequiredSpace = RequiredSpace + AAD(i).getRequiredSpace();
            end
            
            % Colorbar code. This works fine?
            cbar = findobj(hfig, 'Tag', 'Colorbar');
            if ~isempty(cbar)
                if length(cbar) > 1 
                    cbar = cbar(end);
                end
                % Make it thinner!
                set(cbar, 'Units', 'pixels');
                CBInner = get(cbar, 'Position');
                CBInner(3) = 10;
                set(cbar, 'Position', CBInner);
                
                RequiredSpace = RequiredSpace + addaxis.getColorbarPosition(cbar);
            end
            
            % Transofrm borders and subtract from outerpos to set innerpos
            InnerPos = OuterPos - ((TI + RequiredSpace + spacer) * TForm);
            InnerPos = round(InnerPos);
            InnerPos(InnerPos <= 10) = 10; % Guard against negative width
            set(hax, 'Position', InnerPos);
            
            % This position is between Outer and (Inner +TI), to arrange the CAN axis
            % around
            InsetPos = InnerPos + ((TI) * TForm); % May need the spacer here...
            
            % Reposition all axis...
            for i = 1:length(AAD)
                InsetPos = AAD(i).resizePeerAxis(InsetPos);
            end
            if ~isempty(cbar) % Reposition the colorbar to a convenient place
                InsetPos = addaxis.resizeColorbar(cbar, InnerPos, InsetPos);
            end
            % Reset units
            set(hParent, 'Units', PU);
        end
    end
    methods(Access=protected)
        function obj = cbContainerColor(obj, h, ev)
            try
                hContainer = get(obj.h_axis, 'Parent');
                switch get(hContainer, 'Type')
                    case 'figure'
                        propname = 'Color';
                    otherwise
                        propname = 'BackgroundColor';
                end
                set(obj.h_axis,'color',get(hContainer,propname));
            end
        end
        function label = getLabel(obj)
            % Just get the current text..
            label = get(get(obj.h_axis, [upper(obj.dimension) 'Label']), 'String');
        end
        function obj = setLabel(obj, val)
            % Set axis label, colour, reposition in case things change
            % size..
            fun = str2func([lower(obj.dimension), 'label']);
            h_label = fun(obj.h_axis, val);
            set(h_label,'color',get(obj.h_axis,[lower(obj.dimension), 'color']));
            
            % Resize function in case axes have changed width..
            obj.h_parent = addaxis.resizeParentAxis(obj.h_parent);
        end
        %% Transformation functions
        function obj = applyTransform(obj, handle, event)
            % Apply linear transform to data in y dimension. Used for
            % listener callbacks
            scale = [obj.dimension 'Scale'];
            lim   = [obj.dimension 'Lim'];
            data  = [obj.dimension 'Data'];
            dir   = [obj.dimension 'Dir'];
            
            % Get log-lin scale transformation function
            if strcmpi(get(obj.h_axis, scale), get(obj.h_parent, scale))
                logfcn = @(x) x;
            elseif strcmpi(get(obj.h_axis, scale), 'log')
                logfcn = @(x) log10(x);
            elseif strcmpi(get(obj.h_parent, scale), 'log')
                logfcn = @(x) 10.^(x);
            else
                logfcn = @(x) x;
            end
            
            % Find linear transformation
            p_lim =        get(obj.h_parent, lim);
            c_lim = logfcn(get(obj.h_axis, lim));
            if ~strcmpi(get(obj.h_axis, dir), get(obj.h_parent, dir))
                % Scale directions different... reverse...
                c_lim = c_lim([2 1]);
            end
            m = diff(p_lim)/diff(c_lim);
            c = p_lim(1) - m*c_lim(1);
            
            for i = 1:length(obj.h_axis_line)
                try
                    ydata = get(obj.h_axis_line(i), data);
                    ydata = logfcn(ydata) * m + c;
                    set(obj.h_parent_line(i), data, ydata);
                catch ex
                    warning('Error in addaxis transformation fcn.\nMessage %s\n Report %s\n', ex.message, ex.getReport);
                end
            end
        end
    end
    methods(Static=true, Access=protected)
        function setAxes(hObj, aad)
            %  This function allows some data to be stored within the axis
            %  handle
            setappdata(hObj, 'addaxis_data', aad);
        end
        function RequiredSpace = getColorbarPosition(hColor)
            % Calculate inner and outer positions required for axis
            TForm = [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]; % TI to Pos tform matrix
            set(hColor, 'Units', 'Pixels');
            PositionInner = get(hColor, 'Position');
            % Here is a convenient place to set the width...
            PositionInner(3) = 10;
            set(hColor, 'Position', PositionInner);
            % Calculate space required with tight inset
            TI = get(hColor, 'TightInset');
            PositionTight = PositionInner + TI * TForm; % Total current dims of obj.
            if strcmpi(get(hColor, 'YAxisLocation'), 'right')
                RequiredSpace = [0 0 PositionTight(3) 0];
            else
                RequiredSpace = [PositionTight(3) 0 0 0];
            end
        end
        function CentralPosition = resizeColorbar(hColor, ParentInner, CentralPosition)
            % CentralPosition = TightPosition of parent axis + labels,
            % ticks and other addaxis objects.
            
            % Place the axis in the desired spot, returning space available
            set(hColor, 'Units', 'Pixels');
            TForm = [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]; % TI to Pos tform matrix
            TI = get(hColor, 'TightInset');
            PositionInner = get(hColor, 'Position');
            PositionTight = PositionInner + TI * TForm; % Total current dims of obj.

            
            % Align inner y position and y height to match parent figure
            PositionInner(4) = ParentInner(4);
            PositionInner(2) = ParentInner(2);
            
            % Which side of AXIS TIGHTINSET to add width to?
            if strcmpi(get(hColor, 'YAxisLocation'), 'right')
                % Place the axis on the right of central axis
                PositionInner(1) = CentralPosition(1) + CentralPosition(3) + TI(1);
                % Increase central box to include the size of this axis
                CentralPosition(3) = CentralPosition(3) + PositionTight(3);
            else
                % Place the axis on the left of the central axis
                PositionInner(1) = CentralPosition(1) - TI(3) - PositionInner(3);
                % Move left bound and increase width of the centra, box to
                % include this axis
                CentralPosition(1) = CentralPosition(1) - PositionTight(3);
                CentralPosition(3) = CentralPosition(3) + PositionTight(3);
            end
            % Set the new position of Axis
            set(hColor, 'Position', PositionInner);
        end
    end
end