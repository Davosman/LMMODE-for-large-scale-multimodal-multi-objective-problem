function Fitness = CalFitness_Obj(PopObj)

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

    Fitness = Fc;