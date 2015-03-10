local class = require "middleclass"


local TiledLoader = class "TiledLoader"

function TiledLoader:initialize(mapTable)
  
  -- A table to map tile ids to quads
  self.tileTable = {}
  self.tileWidth = mapTable.tilewidth
  self.tileHeight = mapTable.tileheight
  
  for i=1,#mapTable.tilesets do
    local tileset = mapTable.tilesets[i]
    local image = love.graphics.newImage(tileset.image)
    image:setFilter("nearest", "nearest")
    local targetIndex = tileset.firstgid
    
    local finished=false
    local sx=tileset.margin
    local sy=tileset.margin
    
    assert(image:getWidth() == tileset.imagewidth, "Inconsistent image width")
    assert(image:getHeight() == tileset.imageheight, "Inconsistent image height")
    
    while not finished do
      self.tileTable[targetIndex] = {
        quad = love.graphics.newQuad(sx, sy, tileset.tilewidth, tileset.tileheight, image:getWidth(), image:getHeight()),
        image = image
      }
      
      targetIndex = targetIndex + 1
      
      if (sx + tileset.tilewidth + tileset.margin) >= tileset.imagewidth then
        if (sy + tileset.tileheight + tileset.margin) >= tileset.imageheight then
          finished=true
        else
          sx = tileset.margin
          sy = sy + tileset.tileheight + tileset.spacing
        end       
      else        
        sx = sx + tileset.spacing + tileset.tilewidth
      end
    end
    
    
  end
  
  self.layers = mapTable.layers
  
end


function TiledLoader:draw()
  for i=1,#self.layers do
    self:drawLayer(self.layers[i])
  end
end


function TiledLoader:drawLayer(layer)
  local i=1
  local ox=-layer.width*self.tileWidth/2
  local oy=-layer.height*self.tileHeight/2
  
  for y=0, layer.height-1 do
    for x=0, layer.width-1 do
      local tile = self.tileTable[layer.data[i]]
      i = i+1
      love.graphics.draw(tile.image, tile.quad, x*self.tileWidth+ox, y*self.tileHeight+oy)
    end
  end
end


return TiledLoader