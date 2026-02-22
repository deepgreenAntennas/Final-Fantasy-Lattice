//
//  altima_complete.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

{
  "character": {
    "id": "altima",
    "name": "Altima",
    "title": "Entity of Order",
    "base_stats": {
      "hp": 320,
      "mp": 280,
      "attack": 18,
      "magic": 30,
      "defense": 14,
      "speed": 16
    },
    "appearance_sets": {
      "default": {
        "description": "Primordial form with crystalline accents",
        "sprite_sheet": "altima_default",
        "color_palette": ["#2C2C54", "#FFFFFF", "#8A2BE2", "#00CED1"],
        "unlocked": true
      },
      "ceremonial": {
        "description": "Elegant robes for formal occasions",
        "sprite_sheet": "altima_ceremonial",
        "color_palette": ["#4B0082", "#F0E68C", "#000000", "#FFFFFF"],
        "unlocked": false,
        "requirements": "Complete Chapter 3"
      },
      "battle_armor": {
        "description": "Tactical combat gear",
        "sprite_sheet": "altima_battle_armor",
        "color_palette": ["#36454F", "#C0C0C0", "#FF6B6B", "#000000"],
        "unlocked": false,
        "requirements": "Reach Level 20"
      }
    },
    "default_equipment": ["seraph_dagger", "requiem_robe"],
    "unlocked_at_start": true
  }
}
