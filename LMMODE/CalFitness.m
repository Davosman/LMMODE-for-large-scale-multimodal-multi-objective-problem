function Fitness = CalFitness(PopDec,PopObj,count_i,maxFE)

    N = size(PopObj,1);

    CV = zeros(N,1);

    Dominate = false(N);
    for i = 1 : N-1
        for j = i+1 : N
            if CV(i) < CV(j)
                Dominate(i,j) = true;
            elseif CV(i) > CV(j)
                Dominate(j,i) = true;
            else
                k = any(PopObj(i,:)<PopObj(j,:)) - any(PopObj(i,:)>PopObj(j,:));
                if k == 1
                    Dominate(i,j) = true;
                elseif k == -1
                    Dominate(j,i) = true;
                end
            end
        end
    end

    S = sum(Dominate,2);

    Fc = zeros(1,N);
    for i = 1 : N
        Fc(i) = sum(S(Dominate(:,i)));
    end
    
    Distance_obj = pdist2(PopObj,PopObj);
    Distance_obj(logical(eye(length(Distance_obj)))) = inf;
    Distance_obj = sort(Distance_obj,2);
    obj_dis_max = max(Distance_obj(:,floor(sqrt(N))));
    obj_dis_min = min(Distance_obj(:,floor(sqrt(N))));
    D_obj = 1./(Distance_obj(:,floor(sqrt(N)))+2);

    Distance_dec = pdist2(PopDec,PopDec);
    Distance_dec(logical(eye(length(Distance_dec)))) = inf;
    Distance_dec = sort(Distance_dec,2);
    dec_dis_max = max(Distance_dec(:,floor(sqrt(N))));
    dec_dis_min = min(Distance_dec(:,floor(sqrt(N))));
    alfa = (obj_dis_max - obj_dis_min)/(dec_dis_max - dec_dis_min);
    D_dec = 1./(Distance_dec(:,floor(sqrt(N)))+2);

    %Fd = D_obj + 0.48 * D_dec;
    %Fd = D_obj + (count_i/(maxFE/N)) * 0.48 * D_dec;
    Fd = D_obj + D_dec;

    Fitness = Fc + Fd';
    