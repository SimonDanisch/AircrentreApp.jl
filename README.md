# AircentreApp for NDViewer

A simple App to view any `.nc` dateset with NDViewer.

The main command to start the App with a custom file is:
```
docker run -p 8081:8081 -v /path/to/yourfile.nc:/data/file.nc simondanisch/ndviewer-demo:latest
```
The `/data/file.nc` is hardcoded in the configuration file located in:
`./examples/default.yaml`:

```yaml
data:
  path: "/data/file.nc"
layers:
  - figure:
      size: [1200, 700]
  - type: Axis
    position: [1, 1]
    attributes:
      aspect: DataAspect
    plots:
      - type: image
        attributes:
          colormap: viridis
        args: [[1, 2]]
```

You can change the size of the figure and add multiple views to the dataset by adding more axes.
You can pass any Makie plot attribute to the `plots->image->attributes` field.
To see all available attributes, you can get them in the Julia REPL like this:
```julia
> using WGLMakie
> ?image
```
The plot type can also be changed to something else.
The `args` argument works as follows:
* the outer array is the arguments to the plot function, so for `image` `[plot_arg_1, plot_arg_2, ....]`, corresponds to the `Makie.image(plot_arg_1, plot_arg_2)`.
* The arguments are slices, so `[1, 2]` means using the first and second slice of the n-dimensional input array. Any unspecified dimension gets a slice selection widget, which tries to use the correct widget per dimension (e.g. a Dropdown for a few categorical variables, or a slider for a range of values).

This configuration file can be updated, which needs you to rebuild the image:
```
docker build -t ndviewer-demo .
```
(All docker commands are in `./build.sh`)

## Styling

Any styling can be added to `./src/dataviewer.jl` to the DOM in `viewer()`.
This is just a normal Bonito App, and DOM + Styling works just as any other [Bonito app](https://simondanisch.github.io/Bonito.jl/stable/index.html).
