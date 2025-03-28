classdef LMMODE < ALGORITHM

    methods
        function main(Algorithm,Problem)
            Population = Problem.Initialization();
            maxFE = Problem.maxFE;
            [N1, ~] = size(Population.decs);
            Zmax = max(Population.decs,[],1);
            Zmin = min(Population.decs,[],1);
            Pop=(Population.decs-repmat(Zmin,N1,1))./repmat(Zmax-Zmin,N1,1);
            km_n = Problem.N/10;
            [~,fcm_index,~] = fcm(Pop,km_n);
            [~,fcm_index] = max(fcm_index,[],1);
            count_i = 0;
            [~,Fitness] = EnvironmentalSelection(Population,Problem.N,count_i,maxFE);
            [CR,F] = Algorithm.ParameterSet(0.9,0.5);
            
            while Algorithm.NotTerminated(Population)
                count_i = count_i + 1;               

                for i = 1:km_n
                    clu_t = find(fcm_index == i); 
                    if clu_t == 0
                        i = i + 1;
                    else
                        Fitness_t = CalFitness_Obj(Population(clu_t).objs);
                        [~,index_t] = min(Fitness_t);
                        if count_i == 1
                            %[~,index_t] = min(Fitness_t);
                            Arc = Population(clu_t(index_t));
                        else
                            Arc = [Arc Population(clu_t(index_t))];
                        end
                    end
                end
                while size(Arc.decs,1) > Problem.N
                    %Crowd_dec = CrowdingDistance(Arc.decs);
                    dist = sort(pdist2(Arc.decs,Arc.decs));
                    Crowd_dec = sum(dist(1:3,:));
                    [~,index_del] = min(Crowd_dec);
                    Arc = [Arc(1:index_del-1) Arc(index_del+1:end)];
                end
                if(i <= maxFE/(4*Problem.N))
                    MatingPool = TournamentSelection(2,2*Problem.N,Fitness);
                    Offspring  = OperatorDE(Problem,Population,Population(MatingPool(1:end/2)),Population(MatingPool(end/2+1:end)),{CR,F,0,0});
                    [Population,Fitness] = EnvironmentalSelection([Population Offspring],Problem.N,count_i,maxFE);
                    [N1, ~] = size(Population.decs);
                    Zmax = max(Population.decs,[],1);
                    Zmin = min(Population.decs,[],1);
                    Pop=(Population.decs-repmat(Zmin,N1,1))./repmat(Zmax-Zmin,N1,1);
                    [~,fcm_index,~] = fcm(Pop,km_n);
                    [~,fcm_index] = max(fcm_index,[],1);
                else
                    if rand > 0.5
                        %rk = rand(1,Problem.N,0.5);
                        %Population_1 = Population(rk);
                        %N_2 = Problem.N - size(Population_1.objs,1);
                        %while N_2 > 0
                        %    r2 = randperm(N,1);
                        %    Population_1 = [Population_1,Arc(r2)];
                        %    N_2 = N_2 -1;
                        %end
                        %Fitness = CalFitness(Population_1.decs,Population_1.objs,count_i,maxFE);
                        Fitness = CalFitness(Arc.decs,Arc.objs,count_i,maxFE);
                        MatingPool = TournamentSelection(2,2*Problem.N,Fitness);
                        Offspring  = OperatorDE(Problem,Population,Population(MatingPool(1:end/2)),Population(MatingPool(end/2+1:end)),{CR,F,0,0});
                        [Population,Fitness] = EnvironmentalSelection([Population Offspring],Problem.N,count_i,maxFE);
                        [N1, ~] = size(Population.decs);
                        Zmax = max(Population.decs,[],1);
                        Zmin = min(Population.decs,[],1);
                        Pop=(Population.decs-repmat(Zmin,N1,1))./repmat(Zmax-Zmin,N1,1);
                        [~,fcm_index,~] = fcm(Pop,km_n);
                        [~,fcm_index] = max(fcm_index,[],1);
                    else
                        MatingPool = TournamentSelection(2,2*Problem.N,Fitness);
                        Offspring  = OperatorDE(Problem,Population,Population(MatingPool(1:end/2)),Population(MatingPool(end/2+1:end)),{CR,F,0,0});
                        [Population,Fitness] = EnvironmentalSelection([Population Offspring],Problem.N,count_i,maxFE);
                        [N1, ~] = size(Population.decs);
                        Zmax = max(Population.decs,[],1);
                        Zmin = min(Population.decs,[],1);
                        Pop=(Population.decs-repmat(Zmin,N1,1))./repmat(Zmax-Zmin,N1,1);
                        [~,fcm_index,~] = fcm(Pop,km_n);
                        [~,fcm_index] = max(fcm_index,[],1);
                    end
                end
            end
        end
    end
end