abstract type DiagonalRule <: CompositionRule end

function show!(ax::Axis, ::Type{DiagonalRule})
    limits = ax.finallimits[]
    xmin, ymin = limits.origin
    xmax, ymax = limits.widths

    r1 = ablines!(ax, xmin, 1, color=RULE_COLOR)
    r2 = ablines!(ax, xmax, -1, color=RULE_COLOR)
    r3 = ablines!(ax, ymax, -1, color=RULE_COLOR)
    r4 = ablines!(ax, ymax - xmax, 1, color=RULE_COLOR)

    return r1, r2, r3, r4
end

