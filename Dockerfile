FROM julia:1.11

ENV JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1);x86-64-v4,-rdrnd,base(1);znver4,-rdrnd,base(1)"

WORKDIR /home/server/bonito-demos

# Copy the app directory
COPY . ./AircrentreApp
RUN rm -f ./AircrentreApp/Dockerfile
RUN rm -f ./AircrentreApp/Manifest.toml

# Install dependencies
RUN julia --project=. -e 'using Pkg; Pkg.develop(path="AircrentreApp"); Pkg.precompile()'

EXPOSE 8081

# Set the command to activate the project and run the script
CMD ["julia", "--project=.", "AircrentreApp/src/run.jl"]
