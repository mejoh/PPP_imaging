img_type = 'FPList'; % 'Concat'
mask = '/project/3024006.02/Analyses/motor_task/Group/Longitudinal/Masks/Oxford-Imanova_putamen';
cons = {'con_0007', 'con_0010'};
sessions = {'delta', 'ba', 'fu'};
submasks={'a', 'p', 'a_r', 'a_l', 'p_r', 'p_l'};

vals = [];
varnames = {};
for i = 1:numel(cons)
    for j = 1:numel(sessions)
        img = ['/project/3024006.02/Analyses/motor_task/Group/Longitudinal/FSL/data/', cons{i}, '/imgs__', sessions{j}, '_clincorr.txt'];
        for k = 1:numel(submasks)
               tmp_mask = [];
               tmp_mask = [mask, '_', submasks{k}, '.nii'];
               [beta_estimates, subjects] = mj_ExtractValsInMask(img, img_type, tmp_mask);
               vals = [vals, round(beta_estimates-mean(beta_estimates,'omitnan'),5)];
               varnames = [varnames, {[cons{i},'_',sessions{j},'_',submasks{k}]}];
        end
    end
end
putamen_activity = [cell2table(subjects,'VariableNames',{'pseudonym'}), array2table(vals,'VariableNames',varnames)];
writetable(putamen_activity, '/project/3024006.02/Analyses/motor_task/Group/Longitudinal/APvsPP/putamen_activity.csv')