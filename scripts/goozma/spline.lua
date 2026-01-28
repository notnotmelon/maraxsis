local CubicSpline1D = {}
CubicSpline1D.__index = CubicSpline1D

local CubicSpline2D = {}
CubicSpline2D.__index = CubicSpline2D

-- https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm
local function solve_tridiagonal(points)
    local a, b, c, d = {}, {}, {}, {}
    a[1] = 0
    b[1] = 1
    c[1] = 0
    d[1] = 0
    a[#points] = 0
    b[#points] = 1
    c[#points] = 0
    d[#points] = 0
    for i = 2, #points - 1 do
        a[i] = 1
        b[i] = 4
        c[i] = 1
        d[i] = 6 * (points[i + 1] + points[i - 1] - 2 * points[i])
    end

    local cp = {}
    local dp = {}
    local result = {}
    cp[1] = 0
    dp[1] = 0
    for i = 2, #points do
        local denom = b[i] - a[i] * cp[i - 1]
        cp[i] = (i < #points) and (c[i] / denom) or 0
        dp[i] = (d[i] - a[i] * dp[i - 1]) / denom
    end
    result[#points] = dp[#points]
    for i = #points - 1, 1, -1 do
        result[i] = dp[i] - cp[i] * result[i + 1]
    end
    return result
end

function CubicSpline1D.new(points)
    if #points == 2 then
        local self = setmetatable({
            n = #points,
            coef = {
                {A = points[1], B = points[2] - points[1], C = 0, D = 0}
            }
        }, CubicSpline1D)
        return self
    end

    local solution = solve_tridiagonal(points)

    local coef = {}
    for i = 1, #points - 1 do
        local yi = points[i]
        local yi1 = points[i + 1]
        local si = solution[i]
        local si1 = solution[i + 1]

        coef[i] = {
            A = yi,
            B = (yi1 - yi) - (si1 + 2 * si) / 6,
            C = si / 2,
            D = (si1 - si) / 6,
        }
    end

    return setmetatable({n = #points, coef = coef}, CubicSpline1D)
end

function CubicSpline1D:eval(timestamp)
    assert(0 <= timestamp and timestamp <= 1)
    timestamp = timestamp * (self.n - 2)
    local lo, hi = 1, self.n
    while lo + 1 < hi do
        local mid = math.floor((lo + hi) / 2)
        if timestamp < mid - 1 then hi = mid else lo = mid end
    end
    local c = self.coef[lo]
    local t = timestamp - lo + 1
    return c.A + c.B * t + c.C * t * t + c.D * t * t * t
end

function CubicSpline2D.new(points)
    local vx = {}
    local vy = {}
    for i = 1, #points do
        local p = points[i]
        vx[i] = p.x or p[1]
        vy[i] = p.y or p[2]
    end
    return setmetatable({
        spline_x = CubicSpline1D.new(vx),
        spline_y = CubicSpline1D.new(vy)
    }, CubicSpline2D)
end

function CubicSpline2D:eval(timestamp)
    return {
        self.spline_x:eval(timestamp),
        self.spline_y:eval(timestamp)
    }
end

function CubicSpline2D:convert_to_points(num_points)
    local out = {}
    for i = 0, num_points - 1 do
        out[i] = self:eval(i / (num_points - 1))
    end
    return out
end

return {
    CubicSpline1D = CubicSpline1D,
    CubicSpline2D = CubicSpline2D
}
