function doh = deOneHot(oh)
    doh = zeros(1,size(oh,2));
    for i = 1:length(doh)
        [~,doh(i)] = max(oh(:,i));
    end
end