FROM julia:1.11.4

ENV JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1);x86-64-v4,-rdrnd,base(1);znver4,-rdrnd,base(1)"

WORKDIR /home/server/bonito-demos

# Copy only the project files needed for dependency installation
RUN julia -e 'using Pkg; Pkg.activate("."); \
    pkg"add Bonito#master https://github.com/MakieOrg/Makie.jl#sd/compute-graph:ComputePipeline MakieCore#sd/compute-graph Makie#sd/compute-graph WGLMakie#sd/compute-graph https://github.com/MakieOrg/NDViewer.jl#main"; \
    Pkg.precompile()'

# Copy the app directory
COPY . ./AppAircentre
RUN rm -f ./AppAircentre/Dockerfile

# Install dependencies
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.develop(;path="./AppAircentre"); Pkg.precompile()'

EXPOSE 8081

# Set the command to activate the project and run the script
CMD ["julia", "--project=.", "AppAircentre/src/run.jl"]
