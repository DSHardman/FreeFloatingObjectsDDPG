radii = [40 55 70 85 100];
thetas = pi*[1/4 2/4 3/4 4/4 5/4];

%% Run Tests
for i = 1:5
    for j = 1:5  
        ResetPosition_IROS(radii(i), thetas(j), cam, cameraParams, worldcentre, imagecentre);
        rCostFunction(params, strcat('AttractorsOutr',string(radii(i)),'t',string(thetas(j))));
    end
end

%% Plot results
for i = 1:5
    for j = 1:5
        load(strcat('Motions\Bayesian\','AttractorsOutr',string(radii(i)),'t',string(thetas(j)),'.mat'));
        results = results(2:end,:);
        subplot(5,5,(i-1)*5+j);
        [cartx, carty] = pol2cart(results(:,3),results(:,2));
        plot(cartx,carty);
        viscircles([0 0], 180, 'color', 'k', 'LineStyle', '--');
        viscircles([0 0], 20, 'color', 'k', 'LineStyle', '--');
        xlim([-200 200])
        ylim([-200 200])
    end
end

%% Plot selected results
subplot(2,2,1);
load('Motions\Bayesian\AttractorsOutr55t0.7854.mat');
results = results(2:end,:);
[cartx, carty] = pol2cart(results(:,3),results(:,2));
plot(cartx,carty, 'LineWidth', 2); hold on;
load('Motions\Bayesian\AttractorsOutr70t0.7854.mat');
results = results(2:end,:);
[cartx, carty] = pol2cart(results(:,3),results(:,2));
plot(cartx,carty, 'LineWidth', 2); hold on;
viscircles([0 0], 180, 'color', 'k', 'LineStyle', '--');
viscircles([0 0], 20, 'color', 'k', 'LineStyle', '--');
xlim([-200 200])
ylim([-200 200])

subplot(2,2,2);
load('Motions\Bayesian\AttractorsOutr70t2.3562.mat');
results = results(2:end,:);
[cartx, carty] = pol2cart(results(:,3),results(:,2));
plot(cartx,carty, 'LineWidth', 2); hold on;
load('Motions\Bayesian\AttractorsOutr100t2.3562.mat');
results = results(2:end,:);
[cartx, carty] = pol2cart(results(:,3),results(:,2));
plot(cartx,carty, 'LineWidth', 2);
load('Motions\Bayesian\AttractorsOutr100t3.927.mat');
results = results(2:end,:);
[cartx, carty] = pol2cart(results(:,3),results(:,2));
plot(cartx,carty, 'LineWidth', 2);
viscircles([0 0], 180, 'color', 'k', 'LineStyle', '--');
viscircles([0 0], 20, 'color', 'k', 'LineStyle', '--');
xlim([-200 200])
ylim([-200 200])

subplot(2,2,3);
load('Motions\Bayesian\AttractorsOutr55t1.5708.mat');
results = results(2:end,:);
[cartx, carty] = pol2cart(results(:,3),results(:,2));
plot(cartx,carty, 'LineWidth', 2); hold on;
load('Motions\Bayesian\AttractorsOutr55t3.1416.mat');
results = results(2:end,:);
[cartx, carty] = pol2cart(results(:,3),results(:,2));
plot(cartx,carty, 'LineWidth', 2);
viscircles([0 0], 180, 'color', 'k', 'LineStyle', '--');
viscircles([0 0], 20, 'color', 'k', 'LineStyle', '--');
xlim([-200 200])
ylim([-200 200])

subplot(2,2,4);
load('Motions\Bayesian\AttractorsOutr70t3.1416.mat');
results = results(2:end,:);
[cartx, carty] = pol2cart(results(:,3),results(:,2));
plot(cartx,carty, 'LineWidth', 2); hold on;
load('Motions\Bayesian\AttractorsOutr40t3.927.mat');
results = results(2:end,:);
[cartx, carty] = pol2cart(results(:,3),results(:,2));
plot(cartx,carty, 'LineWidth', 2);
viscircles([0 0], 180, 'color', 'k', 'LineStyle', '--');
viscircles([0 0], 20, 'color', 'k', 'LineStyle', '--');
xlim([-200 200])
ylim([-200 200])