## How to use

- Prepare the data for your case. See [this guide](https://metos-uio.github.io/CTSM-Norway-Documentation/quick-start-single-point/) on how to create data for a single point.
- Put your data folder under `data`.
- Change `CLM_USRDAT_DIR` in `data/<site_name>/user_mods/shell_commands` to `/ctsm-api/resources/data/<site_name>`.
- If `MPILIB` is set in `data/<site_name>/user_mods/shell_commands`, remove it.
- Adjust `cases/run_case.sh` for the case you want to run. `CASE_NAME` must refer to the name of the data folder you put in `data`. Modify the `xmlchange` calls as needed.
- Create a `.env` file in the root directory of the project. See `env.example` for an example. You only need to adjust `CTSM_REPO` and `CTSM_TAG` for the CTSM version you want to use. Keep the other variables as they are in `env.example`.
- Run `run_docker.sh` to start a shell in the docker container.
- From within the container, you can test your case by calling `/ctsm-api/resources/cases/run_case.sh`.
