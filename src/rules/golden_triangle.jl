abstract type GoldenTriangle <: CompositionRule end

function show!(ax::Axis, ::Type{GoldenTriangle})
    limits = ax.finallimits[]
    xmin, ymin = limits.origin
    xmax, ymax = limits.widths

    slope = ymax / xmax
    # diagonal
    r1 = ablines!(ax, xmin, slope, color=RULE_COLOR)

    # TODO: make to line sections
    d = LineSegment(Point2f0(xmin, ymin), Point2f0(xmax, ymax))

    a = LineSegment(Point2f0(xmin, ymax), Point2f0(slope * ymax, ymin))
    i1 = intersects(d, a)

    r2 = linesegments!(ax, [xmin, i1[2][1]], [ymax, i1[2][2]], color=RULE_COLOR)

    b = LineSegment(Point2f0(xmax, ymin), Point2f0(xmax - slope * ymax, ymax))
    i2 = intersects(d, b)

    r3 = linesegments!(ax, [i2[2][1], xmax], [i2[2][2], ymin], color=RULE_COLOR)

    return r1, r2, r3
end

