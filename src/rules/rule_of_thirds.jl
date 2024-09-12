abstract type RuleOfThirds <: CompositionRule end

function show!(ax::Axis, ::Type{RuleOfThirds})
    limits = ax.finallimits[]
    xmax, ymax = limits.widths

    r1 = vlines!(ax, [xmax / 3, xmax * 2 / 3], color=RULE_COLOR)
    r2 = hlines!(ax, [ymax / 3, ymax * 2 / 3], color=RULE_COLOR)
    return r1, r2
end
