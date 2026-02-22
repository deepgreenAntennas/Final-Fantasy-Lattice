//
//  altima_portrait.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import Foundation
import Altima

Altima Portrait Blueprint - 16x16 Grid

Wing Area:     [WWWW....WWWW]
               [WWWW....WWWW]
Red Robes:     [RRRR####RRRR]
               [RRRR####RRRR]
Daggers:       [..DD||DD..]
               [..DD||DD..]
Face:          [....@@....]
               [...@@@@...]
               [...@@@@...]

Legend:
W = Wing pixels (white/gold)
R = Red robe pixels
# = Robe details (darker red)
D = Seraph dagger pixels
@ = Face/skin pixels
| = Dagger glow/light effect
{
  "id": "altima",
  "name": "Altima",
  "portrait_image": "altima_portrait",  // Reference the asset name
  "unlocked_at_start": true
}
let altimaImage = UIImage(named: "altima_portrait")
* Altima Color Palette */
:root {
  --altima-red-primary: #ff2a2a;
  --altima-red-shadow: #8b0000;
  --altima-red-highlight: #ff6b6b;
  --seraph-glow: #ffff80;
  --wing-white: #f0f0f0;
  --wing-gold: #ffd700;
  --skin-pale: #ffe0bd;
  --hair-white: #ffffff;
}
-- Aseprite script for Altima portrait
sprite = Sprite(64, 64)

-- Set palette
palette = sprite.palette
palette:setColor(0, Color(0xff, 0x2a, 0x2a))  -- Red primary
palette:setColor(1, Color(0x8b, 0x00, 0x00))  -- Red shadow
palette:setColor(2, Color(0xff, 0x6b, 0x6b))  -- Red highlight

-- Draw red robes (simplified)
for y = 20, 50 do
    for x = 15, 49 do
        sprite:putPixel(x, y, 0)  -- Fill with primary red
    end
end

print("Altima portrait template created")
                        # Python-style coordinates for pixel placement
                        altima_portrait_spec = {
                            "canvas_size": (64, 64),
                            "layers": [
                                {
                                    "name": "wings",
                                    "color": "#f0f0f0",
                                    "coordinates": [
                                        (0, 0), (1, 0), (0, 1), (1, 1),  # Top left wing
                                        (62, 0), (63, 0), (62, 1), (63, 1) # Top right wing
                                    ]
                                },
                                {
                                    "name": "red_robes",
                                    "color": "#ff2a2a",
                                    "coordinates": "fill_rect(20, 10, 24, 40)"  # x,y,width,height
                                },
                                {
                                    "name": "daggers",
                                    "color": "#ffff80",
                                    "positions": [
                                        {"left_hand": (15, 25), "right_hand": (49, 25)}
                                    ]
                                }
                            ]
                        }
-- Aseprite script for Altima portrait
sprite = Sprite(64, 64)

-- Set palette
palette = sprite.palette
palette:setColor(0, Color(0xff, 0x2a, 0x2a))  -- Red primary
palette:setColor(1, Color(0x8b, 0x00, 0x00))  -- Red shadow
palette:setColor(2, Color(0xff, 0x6b, 0x6b))  -- Red highlight

-- Draw red robes (simplified)
for y = 20, 50 do
    for x = 15, 49 do
        sprite:putPixel(x, y, 0)  -- Fill with primary red
    end
end

print("Altima portrait template created")
