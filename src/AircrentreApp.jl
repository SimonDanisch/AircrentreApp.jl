module AircrentreApp

using NDViewer
using Bonito
using WGLMakie
using Bonito: Dropdown, Asset
using PrecompileTools
using Downloads

include("dataviewer.jl")

function run(port=8081, blocking=true; file=joinpath(@__DIR__, "..", "examples", "default.yaml"))
    server = Server("0.0.0.0", port)
    viewer_app1 = create_app_from_yaml(file)
    route!(server, "/" => viewer_app1);
    if blocking
        wait(server)
    end
    return server
end

let
    @setup_workload begin
        @compile_workload begin
            file=joinpath(@__DIR__, "..", "examples", "precompile.yaml")
            server = run(8888, false; file=file)
            getit(x) = begin
                Bonito.HTTP.get(Bonito.HTTPServer.online_url(server, x))
            end
            getit("")
            for (name, app) in server.routes.table
                if app isa Bonito.App
                    close(app.session[])
                end
            end
            empty!(NDViewer.GLOBAL_DATA)
            close(server)
            f = Makie.CURRENT_FIGURE[];
            if !isnothing(f)
                empty!(f.scene)
            end
            Makie.CURRENT_FIGURE[] = nothing
            for (task, (task, close_ref)) in Bonito.SERVER_CLEANUP_TASKS
                close_ref[] = false
            end
            Bonito.CURRENT_SESSION[] = nothing
            if !isnothing(Bonito.GLOBAL_SERVER[])
                close(Bonito.GLOBAL_SERVER[])
            end
            Bonito.GLOBAL_SERVER[] = nothing
            yield()
        end
    end
end

end
