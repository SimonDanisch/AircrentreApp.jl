using Bonito, WGLMakie, NDViewer

function viewer(file)
    yaml_str = read(file, String)
    viewer = NDViewer.load_from_yaml(yaml_str)
    WGLMakie.activate!(resize_to=:parent)
    logo = Bonito.Asset(joinpath(@__DIR__,  "aircentre.png"))
    app_dom = DOM.div(
        Centered(DOM.img(src=logo; height="250px")),
        viewer
    )
    return Centered(app_dom)
end

function create_app_from_yaml(file)
    return Bonito.App(()-> viewer(file); title="NDViewer")
end
