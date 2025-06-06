#!/bin/bash

# ~/scripts/PPP_imaging/FSL/fsl_extract_stats_loop.sh

ANALYSISDIR="/project/3024006.02/Analyses/motor_task/Group/Longitudinal/FSL"
LOGDIR="/project/3024006.02/Analyses/motor_task/Group/Longitudinal/FSL/logs"
CONS=(con_0007 con_0010)
SESSION=(delta)
CONDIR_END=""
# CONDIR_END="/by_session/ses-Visit1"
# CONDIR_END="/by_session/ses-Visit2"

# Brain - Clinical correlations
ANALYSIS=(clincorr_all_vxlEV)
for C in ${CONS[@]}; do
	DATADIR=${ANALYSISDIR}/data/${C}
	CONDIR=${ANALYSISDIR}/stats/${C}${CONDIR_END}
	OUTDIR=${CONDIR}/vals
	mkdir -p ${OUTDIR}
	for T in ${SESSION[@]}; do
		DAT=${DATADIR}/imgs__${T}_clincorr.nii.gz
		FN=${DATADIR}/imgs__${T}_clincorr.txt
		for A in ${ANALYSIS[@]}; do
			CORRP=( `ls ${CONDIR}/rand_${T}_${A}_*tfce_corrp_tstat*.nii.gz` )
			TSTAT=( `ls ${CONDIR}/rand_${T}_${A}_*tfce_tstat*.nii.gz` )
			for(( i=0; i<${#CORRP[@]}; i++ )); do
				BN=`basename ${CORRP[i]}`
				BN=${BN%%.*}
				OBN=${OUTDIR}/${BN}_stats
				cmd="/home/sysneu/marjoh/scripts/PPP_imaging/FSL/fsl_extract_stats.sh -d ${DAT} -n ${FN} -p ${CORRP[i]} -t ${TSTAT[i]} -o ${OBN}"
				echo '#!/bin/bash' > ${OUTDIR}/script_${BN}.txt
				printf "\n${cmd}\n\n" >> ${OUTDIR}/script_${BN}.txt
				#qsub \
				#	-o ${LOGDIR} \
				#	-e ${LOGDIR} \
				#	-N "stxtrct_${BN}" \
				#	-l "nodes=1:ppn=1,walltime=00:10:00,mem=5gb" \
				#	${OUTDIR}/script_${BN}.txt
				sbatch \
					--output ${LOGDIR}/job.stxtrct.%A_%a.out \
					--error ${LOGDIR}/job.stxtrct.%A_%a.err \
					--job-name "stxtrct_${BN}" \
					--nodes=1 --cpus-per-task 1 --ntasks-per-node=1 --mem=5G --time=00:10:00 \
					${OUTDIR}/script_${BN}.txt
			done 
		done
	done
done

# Baseline for delta analyses
ANALYSIS=(clincorr_all_vxlEV)
for C in ${CONS[@]}; do
	DATADIR=${ANALYSISDIR}/data/${C}
	CONDIR=${ANALYSISDIR}/stats/${C}${CONDIR_END}
	OUTDIR=${CONDIR}/vals
	DAT=${DATADIR}/imgs__ba_clincorr.nii.gz
	FN=${DATADIR}/imgs__ba_clincorr.txt
	for A in ${ANALYSIS[@]}; do
		CORRP=( `ls ${CONDIR}/rand_delta_${A}_*tfce_corrp_tstat*.nii.gz` )
		TSTAT=( `ls ${CONDIR}/rand_delta_${A}_*tfce_tstat*.nii.gz` )
		for(( i=0; i<${#CORRP[@]}; i++ )); do
			BN=`basename ${CORRP[i]}`
			BN=${BN%%.*}
			OBN=${OUTDIR}/${BN}_stats_BASELINE
			cmd="/home/sysneu/marjoh/scripts/PPP_imaging/FSL/fsl_extract_stats.sh -d ${DAT} -n ${FN} -p ${CORRP[i]} -t ${TSTAT[i]} -o ${OBN}"
			echo '#!/bin/bash' > ${OUTDIR}/script_${BN}_BAvals.txt
			printf "\n${cmd}\n\n" >> ${OUTDIR}/script_${BN}_BAvals.txt
			#qsub \
			#	-o ${LOGDIR} \
			#	-e ${LOGDIR} \
			#	-N "stxtrct_${BN}_BAvals" \
			#	-l "nodes=1:ppn=1,walltime=00:10:00,mem=5gb" \
			#	${OUTDIR}/script_${BN}_BAvals.txt
			sbatch \
				--output ${LOGDIR}/job.stxtrct_ba.%A_%a.out \
				--error ${LOGDIR}/job.stxtrct_ba.%A_%a.err \
				--job-name "stxtrct_${BN}_BAvals" \
				--nodes=1 --cpus-per-task 1 --ntasks-per-node=1 --mem=5G --time=00:10:00 \
				${OUTDIR}/script_${BN}_BAvals.txt
		done
	done
done

# Group comparisons
ANALYSIS=(unpaired_ttest_unmatched)
for C in ${CONS[@]}; do
	DATADIR=${ANALYSISDIR}/data/${C}
	CONDIR=${ANALYSISDIR}/stats/${C}${CONDIR_END}
	OUTDIR=${CONDIR}/vals
	for T in ${SESSION[@]}; do
		for A in ${ANALYSIS[@]}; do
			DAT=${DATADIR}/imgs__${T}_${A}.nii.gz
			FN=${DATADIR}/imgs__${T}_${A}.txt
			CORRP=( `ls ${CONDIR}/rand_${T}_${A}_*tfce_corrp_tstat*.nii.gz` )
			TSTAT=( `ls ${CONDIR}/rand_${T}_${A}_*tfce_tstat*.nii.gz` )
			for(( i=0; i<${#CORRP[@]}; i++ )); do
				BN=`basename ${CORRP[i]}`
				BN=${BN%%.*}
				OBN=${OUTDIR}/${BN}_stats
				cmd="/home/sysneu/marjoh/scripts/PPP_imaging/FSL/fsl_extract_stats.sh -d ${DAT} -n ${FN} -p ${CORRP[i]} -t ${TSTAT[i]} -o ${OBN}"
				echo '#!/bin/bash' > ${OUTDIR}/script_${BN}.txt
				printf "\n${cmd}\n\n" >> ${OUTDIR}/script_${BN}.txt
				# # # qsub \
					# # # -o ${LOGDIR} \
					# # # -e ${LOGDIR} \
					# # # -N "stxtrct_${BN}" \
					# # # -l "nodes=1:ppn=1,walltime=00:10:00,mem=5gb" \
					# # # ${OUTDIR}/script_${BN}.txt
				sbatch \
					--output ${LOGDIR}/job.stxtrct_tt.%A_%a.out \
					--error ${LOGDIR}/job.stxtrct_tt.%A_%a.err \
					--job-name "stxtrct_${BN}_tt" \
					--nodes=1 --cpus-per-task 1 --ntasks-per-node=1 --mem=5G --time=00:10:00 \
					${OUTDIR}/script_${BN}.txt
			# # # done 
		# # # done
	# # # done
# # # done
