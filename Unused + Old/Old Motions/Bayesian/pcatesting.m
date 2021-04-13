%%% Adapted from UROP pcatesting script

threshold = 15;

xparams = table2array(BayesoptResults.XTrace);
scores = BayesoptResults.ObjectiveTrace;

%normalise each column of the parameter matrix
normresults = normalize(xparams,1);

%work out the variables applied to normalise the columns
normalisers = zeros(11,2); %y = ax + b: a is first column, b second
for i = 1:11
    for j = 1:size(normresults,1)-1
        if xparams(j,i) ~= xparams(j+1,i)
            normalisers(i,1) = (normresults(j,i)-normresults(j+1,i))/(xparams(j,i)-xparams(j+1,i));
            normalisers(i,2) = normresults(j,i) - normalisers(i,1)*xparams(j,i);
            break
        end
    end
    
end

%Perform built-in principal component analysis
pcaweights = pca(xparams);

%plot data
plotresults(normalisedata(xparams(scores<threshold,:),normalisers),pcaweights,'r')

function plotresults(parameters, pcaweights,color)
    %set marker colour/type
    if color == 'jj'
        markerstring = 'ro';
    else
        markerstring = strcat(color,'x');
    end
    weightedparameters = zeros(size(parameters,1),size(pcaweights,1));
    %Apply previous weightings to each of the flagged sets
    for i = 1:size(pcaweights,1)
        for j = 1:size(parameters,1)
            total = 0;
            for k = 1:size(pcaweights,1)
               total = total + pcaweights(k,i)*parameters(j,k); 
               weightedparameters(j,i) = total;
            end
        end
    end
    
    %{
    scatter(weightedparameters(:,1),weightedparameters(:,3),markerstring)
    xlabel('PCA 1')
    ylabel('PCA 2')
    %}
    
    plot3(weightedparameters(:,1),weightedparameters(:,2),weightedparameters(:,3),markerstring);
    xlabel('PCA 1')
    ylabel('PCA 2')
    zlabel('PCA 3')
    
    
end

%Normalising function using variables obtained earlier
function normparameters = normalisedata(parameters,normalisers)
    normparameters = zeros(size(parameters));
    for i = 1:size(parameters,1)
        for j = 1:size(parameters,2)
            normparameters(i,j) = parameters(i,j)*normalisers(j,1) + normalisers(j,2);
        end
    end
end
