module VisualComposition

using ColorTypes
using GeometryTypes
using GLMakie
using FileIO
using NativeFileDialog

export RuleOfThirds
export DiagonalRule
export GoldenTriangle
export main

include("rules/rules.jl")

const RULE_COLOR = (colorant"#fbbf24", 1.0)

function main(init=nothing, init_rule::Type{<:CompositionRule}=RuleOfThirds)
    # figure setup
    fig = Figure(size=(800, 600))
    axis = Axis(fig[1, 1], aspect=DataAspect(), height=600)
    hidespines!(axis)
    hidedecorations!(axis)

    # selected image
    img = Observable{AbstractMatrix}(rand(3, 3), ignore_equal_values=true)

    # buttons
    fig[1, 2] = buttongrid = GridLayout()

    # file picker
    file_picker_btn = Button(buttongrid[1, 1:2], label="Open file...", width=224)

    on(file_picker_btn.clicks) do click
        img_file = pick_file("", filterlist="jpg,jpeg,png")
        img[] = rotr90(load(assetpath(img_file)))
    end

    # rotate image
    rotl90_btn = Button(buttongrid[3, 1], label="rotate 90° left")

    on(rotl90_btn.clicks) do click
        img[] = rotl90(img[])
    end

    rotr90_btn = Button(buttongrid[3, 2], label="rotate 90° right")

    on(rotr90_btn.clicks) do click
        img[] = rotr90(img[])
    end

    # display image
    on(img) do i
        empty!(axis)
        image!(axis, i)
        active_rule_obj[] = show!(axis, active_rule[])
    end

    # composition rule
    active_rule = Observable{Type{<:CompositionRule}}(init_rule)
    active_rule_obj = Observable{Tuple}(show!(axis, init_rule))

    ruleset = Dict(RuleOfThirds => "Rule of thirds", DiagonalRule => "Diagonal rule", GoldenTriangle => "Golden triangle")

    rule_select = Menu(
        buttongrid[2, 1:2],
        options=zip(
            values(ruleset),
            keys(ruleset)
        ),
        default=ruleset[init_rule]
    )

    on(rule_select.selection) do rule
        try
            delete!.(axis, active_rule_obj[])
        catch e
            @error e
        end

        active_rule_obj[] = show!(axis, rule)
        active_rule[] = rule
    end

    # save images
    save_img_btn = Button(buttongrid[4, 1:2], label="Save", width=224)

    on(save_img_btn.clicks) do click
        save_file_path = save_file("", filterlist="png")
        save_fig = Figure(figure_padding=0)
        save_ax = Axis(save_fig[1, 1])
        image!(save_ax, img[])
        show!(save_ax, active_rule[])
        hidedecorations!(save_ax)
        hidespines!(save_ax)
        save(save_file_path, save_fig)
    end

    # set initial values
    if !isnothing(init)
        img[] = rotr90(load(assetpath(init)))
    end

    return fig
end

end # module VisualComposition
