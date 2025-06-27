mask = '/project/3024006.02/Analyses/motor_task/Group/Longitudinal/Masks/Oxford-Imanova_putamen';
sessions = {'delta', 'ba', 'fu'};
submasks={'a_r', 'a_l', 'p_r', 'p_l'}; % 'a', 'p'

% % cons = {'con_0007', 'con_0010'};
% img_type = 'FPList'; % 'Concat'
% vals = [];
% varnames = {};
% for i = 1:numel(cons)
%     for j = 1:numel(sessions)
%         img = ['/project/3024006.02/Analyses/motor_task/Group/Longitudinal/FSL/data/', cons{i}, '/imgs__', sessions{j}, '_clincorr.txt'];
%         for k = 1:numel(submasks)
%                tmp_mask = [];
%                tmp_mask = [mask, '_', submasks{k}, '.nii'];
%                [beta_estimates, subjects] = mj_ExtractValsInMask(img, img_type, tmp_mask);
%                vals = [vals, round(beta_estimates-mean(beta_estimates,'omitnan'),5)];
%                varnames = [varnames, {[cons{i},'_',sessions{j},'_',submasks{k}]}];
%         end
%     end
% end
% putamen_activity = [cell2table(subjects,'VariableNames',{'pseudonym'}), array2table(vals,'VariableNames',varnames)];
%writetable(putamen_activity, '/project/3024006.02/Analyses/motor_task/Group/Longitudinal/APvsPP/putamen_activity.csv')

img_type = 'AFNItable';
vals = [];
varnames = {};
img = ['/project/3024006.02/Analyses/motor_task/Group/Longitudinal/AFNI/', 'con_combined_disease_dataTable2', '.txt'];
for k = 1:numel(submasks)
    tmp_mask = [];
    tmp_mask = [mask, '_', submasks{k}, '.nii'];
    [beta_estimates, subjects] = mj_ExtractValsInMask(img, img_type, tmp_mask);
    vals = [vals, round(beta_estimates-mean(beta_estimates,'omitnan'),5)];
    varnames = [varnames, {['beta','_',submasks{k}]}];
end
tab = tdfread(img);
putamen_activity = [cell2table(subjects','VariableNames',{'pseudonym'}),...
    cell2table(cellstr(tab.Group),'VariableNames',{'ParticipantType'}),...
    cell2table(cellstr(tab.TimepointNr),'VariableNames',{'TimepointNr'}),...
    cell2table(cellstr(tab.trial_type),'VariableNames',{'trial_type'}),...
    array2table(vals,'VariableNames',varnames)];
writetable(putamen_activity, '/project/3024006.02/Analyses/motor_task/Group/Longitudinal/APvsPP/putamen_activity_full_sample.csv')