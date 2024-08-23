---@class Pyvector 3d vector
---@field x number
---@field y number
---@field z number
---@field cross fun(self, v: Pyvector): Pyvector -- cross product
---@field dot fun(self, v: Pyvector): number -- dot product
---@field mag fun(self): number -- get the magnitude of a vector
---@field normalized fun(self): Pyvector -- normalize the vector
---@field is_vector fun(self): boolean
---@field new fun(x: {x: number, y: number, z: number} | number, y: number?, z: number?): Pyvector -- create new vector from table or 3 numbers
---@operator add(): Pyvector
---@operator sub(): Pyvector
---@operator mul(): Pyvector
---@operator div(): Pyvector
---@operator unm(): Pyvector
h2o.vector = {
    __add = function(self, v)
        return h2o.vector.new(self.x + v.x, self.y + v.y, self.z + v.z)
    end,

    __sub = function(self, v)
        return h2o.vector.new(self.x - v.x, self.y - v.y, self.z - v.z)
    end,

    __mul = function(self, v)
        if type(self) == 'number' then self = h2o.vector.new(self,self,self) end
        if type(v) == 'number' then v = h2o.vector.new(v,v,v) end
        return h2o.vector.new(self.x * v.x, self.y * v.y, self.z * v.z)
    end,

    __div = function(self, v)
        if type(self) == 'number' then self = h2o.vector.new(self,self,self) end
        if type(v) == 'number' then v = h2o.vector.new(v,v,v) end
        return h2o.vector.new(self.x / v.x, self.y / v.y, self.z / v.z)
    end,

    __unm = function(self)
        return h2o.vector.new(self.x * -1, self.y * -1, self.z * -1)
    end,

    __tostring = function(self)
        return string.format('(%f, %f, %f)', self.x, self.y, self.z)
    end,

    __index = {
        ---@return Pyvector
        new = function(x, y, z)
            if type(x) == 'table' then
                return setmetatable(x, h2o.vector)
            end
            return setmetatable({x = x or 0, y = y or 0, z = z or 0}, h2o.vector)
        end,

        ---@return boolean
        is_vector = function(self)
            return getmetatable(self) == h2o.vector
        end,

        ---@param v Pyvector
        ---@return Pyvector
        dot = function(self, v)
            return self.x * v.x + self.y * v.y + self.z * v.z
        end,

        ---@param v Pyvector
        ---@return Pyvector
        cross = function(self, v)
            local out = {}
            local a, b, c = self.x, self.y, self.z
            out.x = b * v.z - c * v.y
            out.y = c * v.x - a * v.z
            out.z = a * v.y - b * v.x
            return h2o.vector.new(out)
        end,

        mag = function(self)
            return math.sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
        end,

        normalized = function(self)
            local mag = self:mag()
            return h2o.vector.new(self.x / mag, self.y / mag, self.z / mag)
        end
    }
}

setmetatable(h2o.vector, h2o.vector)
script.register_metatable('Pyvector_metatable', h2o.vector)