% Create digraph objects for the food webs

clear all
close all

% Fluxes (consumption rates)
%rows 1:Npp->zoop, 2:zoop->F, 3:F->P, 4:NPP->det, 5:B->D, 6:P->D, 7:F->D 
%cols example, EBS, PUp, HOT
edges = {...
    'purple' 'grey'   5e-1  0.5       0.8     0.1
    'grey'   'orange' 5e-2  1.1e-1    2.6e-1  3.5e-1    
    'orange' 'blue'   5e-3  3.0e-3    4.4e-3  1.2e-2
    'purple' 'black'  5e-1  1.0       2.3e-2  1.2e-2
    'black'  'green'  5e-2  2.1e-2    8.0e-3  7.6e-3
    'blue'   'green'  5e-4  4.5e-5    0.0     0.0
    'orange' 'green'  5e-3  2.7e-4    0.0     0.0};

% Biomasses
%rows 1:Npp, 2:zoop, 3:F, 4:P, 5:B, 6:D 
%cols example, EBS, PUp, HOT
xybio = [...
1 2  5      4.3  7.9 3.1   % 'purple'
2 2  10     22.8 15.6 6.2  % 'grey'  
3 2  2.5    0.8  3.2 1.5   % 'orange'
4 2  1      0.3 12.8 0.0   % 'blue'  
2 1  0.5    4.2  0.2 0.1   % 'black' 
4 1  1      8.0  0.2 0.1]; % 'green'

G = cell(4,1);
for ii = 1:4
    G{ii} = digraph(edges(:,1), edges(:,2), cell2mat(edges(:,ii+2)));
    G{ii}.Nodes.bio = xybio(:,ii+2);
    G{ii}.Nodes.x = xybio(:,1);
    G{ii}.Nodes.y = xybio(:,2);
end

% Some scaling setup

rmax = 0.5; % maximum radius 
bmax = 30;  % biomass represented by max radius
fmax = 1.0; % flux represented by max line width
wmax = 100;  % edge width scale

for ii = 1:4
    G{ii}.Nodes.r = sqrt((G{ii}.Nodes.bio .* (pi*rmax.^2)/30)/pi);
end

%--------------------
% Plot
%--------------------

th = linspace(0,2*pi,50);
nedge = numedges(G{1});
nnode = numnodes(G{1});

lbl = {'e.g.','EBS', 'PUP', 'HOT'};

for ii = 1:4
    h(ii).ax = subplot(2,2,ii);

    % Plot edges first

    [h(ii).edg, Data] = plotdeb(G{ii}, 'p', 1/3, 'gmax', fmax, 'w', wmax);

    % Plot nodes

    h(ii).nd = arrayfun(@(x,y,r) patch(r.*cos(th)+x, r.*sin(th)+y, 'w'), ...
        G{ii}.Nodes.x, G{ii}.Nodes.y, G{ii}.Nodes.r, 'uni', 0);
    h(ii).nd = cat(1, h(ii).nd{:});

    % Color nodes, and match edge colors to their source nodes

    nvert = size(h(ii).edg.CData,1);

    set(h(ii).nd, 'facecolor', 'flat', 'edgecolor', 'w');
    set(h(ii).nd, {'CData'}, num2cell((1:nnode)'));
    h(ii).edg.CData = ones(nvert,1)*findnode(G{1}, G{1}.Edges.EndNodes(:,1))';

    title(lbl{ii});
end
set([h.ax], 'dataaspectratio', [1 1 1], ...
    'ylim', [0.5 2.75], 'xlim', [0.5 4.5], 'xtick', [], 'ytick', []);
%
subplot(2,2,1)
%Numbers
% text(1,2.6,sprintf('%2.1f',xybio(1,3)),'HorizontalAlignment','center'); hold on;
% text(2,2.6,sprintf('%2.1f',xybio(2,3)),'HorizontalAlignment','center'); hold on;
% text(2,0.6,sprintf('%2.1f',xybio(5,3)),'HorizontalAlignment','center'); hold on;
% text(3,2.6,sprintf('%2.1f',xybio(3,3)),'HorizontalAlignment','center'); hold on;
% text(4,2.6,sprintf('%2.1f',xybio(4,3)),'HorizontalAlignment','center'); hold on;
% text(4,0.6,sprintf('%2.1f',xybio(6,3)),'HorizontalAlignment','center'); hold on;
% text(1.5,2.3,sprintf('%2.1f',edges{1,3}),'HorizontalAlignment','center'); hold on;
% text(2.5,2.3,sprintf('%1.0e',edges{2,3}),'HorizontalAlignment','center'); hold on;
% text(3.5,2.3,sprintf('%1.0e',edges{3,3}),'HorizontalAlignment','center'); hold on;
% text(1.25,1.3,sprintf('%2.1f',edges{4,3}),'HorizontalAlignment','center'); hold on;
% text(3,0.8,sprintf('%1.0e',edges{5,3}),'HorizontalAlignment','center'); hold on;
% text(3.25,1.35,sprintf('%1.0e',edges{7,3}),'HorizontalAlignment','center'); hold on;
% text(4.25,1.5,sprintf('%1.0e',edges{6,3}),'HorizontalAlignment','center'); hold on;
%Text
text(1,2.6,'NPP','HorizontalAlignment','center'); hold on;
text(2,2.6,'Z','HorizontalAlignment','center'); hold on;
text(2,0.6,'B','HorizontalAlignment','center'); hold on;
text(3,2.6,'F','HorizontalAlignment','center'); hold on;
text(4,2.6,'P','HorizontalAlignment','center'); hold on;
text(4,0.6,'D','HorizontalAlignment','center'); hold on;


%% Colors
cmap = [...
     0.49412      0.11765      0.61176
     0.57255      0.58431      0.56863
     0.97647      0.45098     0.023529
     0.17255      0.43529      0.73333
           0            0            0
    0.082353       0.6902      0.10196];
colormap(cmap);

set(gcf, 'color', 'w');
print(gcf, '-dpng','foodweb_eg_cbrt_eg_names');