## Global func to check 'special' files


run_wdl() {
	# Function to run a WDL on an inputs.json, both given as arg
	# A different config file can also be specified as an (optional) 3rd arg

	local main_wdl=$1
	local input_json=$2
	local main_conf=tests/slurm_apptainer.conf
	if [ $# -eq 3 ]; then
		main_conf=$3
	fi

	# WARN: Clean PATH from custom stuffs:
	#       (similar to when somebody else is running pipeline)
	#OLD_PATH=$PATH && PATH="/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"  # Minimal PATH

	# Activate Cromwell Conda/Mamba env:
	source /etc/profile.d/conda.sh && conda activate cromwell
	#source /home/felix/.local/share/mamba/etc/profile.d/mamba.sh && mamba activate cromwell

	# Should give in PATH:
	# - cww.sh
	# - womtool
	# - cromwell.jar in 'share/cromwell'


	# Actually run pipeline:
	cww.sh \
		--exec $CONDA_PREFIX/share/cromwell/cromwell-90.jar \
		--wdl "$main_wdl" \
		--input "$input_json" \
		--option tests/cromwell_options.json \
		--conf "$main_conf"
}
export -f run_wdl

