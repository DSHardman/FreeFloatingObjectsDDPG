function comparevariables(n1,n2, N, sortedxin, sortedxout)
    scatter(table2array(sortedxin(1:N,n1)),table2array(sortedxin(1:N,n2)));
    hold on;
    scatter(table2array(sortedxout(1:N,n1)),table2array(sortedxout(1:N,n2)));
end