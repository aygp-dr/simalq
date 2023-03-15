(import
  simalq.geometry [NORTH EAST SOUTH WEST])
(setv  T True  F False)


(defclass Tile)
(defclass Scenery [Tile])
(defclass Pickup [Tile])
(defclass Monster [Tile])


(setv tile-defs [

[:iq-ix   1 :iq-desc "The dungeon floor" :class Scenery
  :slug "floor"]
[:iq-ix   2 :iq-desc "A wall" :class Scenery]
[:iq-ix   3 :iq-desc "A damaged wall" :class Scenery]
[:iq-ix   4 :iq-desc "A crumbling wall" :class Scenery]
[:iq-ix   5 :iq-desc "A door" :class Scenery]
[:iq-ix   6 :iq-desc "A locked door" :class Scenery]
[:iq-ix   7 :iq-desc "The exit" :class Scenery
  :mobile-exit F]
[:iq-ix   8 :iq-desc "A one-way door (up)" :class Scenery]
[:iq-ix   9 :iq-desc "A one-way door (down)" :class Scenery]
[:iq-ix  10 :iq-desc "A one-way door (left)" :class Scenery]
[:iq-ix  11 :iq-desc "A one-way door (right)" :class Scenery]
[:iq-ix  12 :iq-desc "A pillar" :class Scenery]
[:iq-ix  13 :iq-desc "A trap" :class Scenery]
[:iq-ix  14 :iq-desc "A trapped wall" :class Scenery]
[:iq-ix  15 :iq-desc "A damageable wall" :class Scenery]
[:iq-ix  16 :iq-desc "A treasure chest" :class Pickup]
[:iq-ix  17 :iq-desc "The Void" :class Scenery]
[:iq-ix  18 :iq-desc "A pile of gold" :class Pickup]
[:iq-ix  19 :iq-desc "A key" :class Pickup]
[:iq-ix  20 :iq-desc "A healing potion (100 Life)" :class Pickup]
[:iq-ix  21 :iq-desc "An unknown potion" :class Pickup]
[:iq-ix  22 :iq-desc "A moveable wall" :class Scenery]
[:iq-ix  23 :iq-desc "A teleporter" :class Scenery]
[:iq-ix  24 :iq-desc "A gate" :class Scenery]
[:iq-ix  25 :iq-desc "A cloak of invisibility" :class Pickup]
[:iq-ix  26 :iq-desc "An amulet of invulnerability" :class Pickup]
[:iq-ix  27 :iq-desc "10 magic arrows" :class Pickup]
[:iq-ix  28 :iq-desc "The Magic Shield" :class Pickup]
[:iq-ix  29 :iq-desc "The Elven Bow" :class Pickup]
[:iq-ix  30 :iq-desc "The Holy Sword" :class Pickup]
[:iq-ix  31 :iq-desc "A bomb" :class Pickup]
[:iq-ix  32 :iq-desc "A passwall wand" :class Pickup]
[:iq-ix  33 :iq-desc "A wall-making wand" :class Pickup]
[:iq-ix  34 :iq-desc "A potion of speed" :class Pickup]
[:iq-ix  35 :iq-desc "A damage-causing trap" :class Scenery]
[:iq-ix  36 :iq-desc "A paralysis trap" :class Scenery]
[:iq-ix  37 :iq-desc "A ghost (5/10/15)" :class Monster]
[:iq-ix  38 :iq-desc "A ghost generator" :class Monster]
[:iq-ix  39 :iq-desc "An orc (3/6/9)" :class Monster]
[:iq-ix  40 :iq-desc "An orc generator" :class Monster]
[:iq-ix  41 :iq-desc "A devil (3/6/9 - 10)" :class Monster]
[:iq-ix  42 :iq-desc "A devil generator" :class Monster]
[:iq-ix  43 :iq-desc "An imp (0 - 1/2/3)" :class Monster]
[:iq-ix  44 :iq-desc "An imp generator" :class Monster]
[:iq-ix  45 :iq-desc "A bat (1/2/3)" :class Monster]
[:iq-ix  46 :iq-desc "A bat generator" :class Monster]
[:iq-ix  47 :iq-desc "A floater (10)" :class Monster]
[:iq-ix  48 :iq-desc "A blob (6)" :class Monster]
[:iq-ix  49 :iq-desc "Death (20)" :class Monster]
[:iq-ix  50 :iq-desc "A specter (15)" :class Monster]
[:iq-ix  51 :iq-desc "A thorn tree (4)" :class Monster]
[:iq-ix  52 :iq-desc "A negaton (25)" :class Monster]
[:iq-ix  53 :iq-desc "A Dark Knight (12)" :class Monster]
[:iq-ix  54 :iq-desc "A Tricorn (5 - 6)" :class Monster]
[:iq-ix  55 :iq-desc "A ghost (5/10/15)" :class Monster]
[:iq-ix  56 :iq-desc "A ghost (5/10/15)" :class Monster]
[:iq-ix  57 :iq-desc "A ghost generator" :class Monster]
[:iq-ix  58 :iq-desc "A ghost generator" :class Monster]
[:iq-ix  59 :iq-desc "An orc (3/6/9)" :class Monster]
[:iq-ix  60 :iq-desc "An orc (3/6/9)" :class Monster]
[:iq-ix  61 :iq-desc "An orc generator" :class Monster]
[:iq-ix  62 :iq-desc "An orc generator" :class Monster]
[:iq-ix  63 :iq-desc "A devil (3/6/9 - 10)" :class Monster]
[:iq-ix  64 :iq-desc "A devil (3/6/9 - 10)" :class Monster]
[:iq-ix  65 :iq-desc "A devil generator" :class Monster]
[:iq-ix  66 :iq-desc "A devil generator" :class Monster]
[:iq-ix  67 :iq-desc "An imp (0 - 1/2/3)" :class Monster]
[:iq-ix  68 :iq-desc "An imp (0 - 1/2/3)" :class Monster]
[:iq-ix  69 :iq-desc "An imp generator" :class Monster]
[:iq-ix  70 :iq-desc "An imp generator" :class Monster]
[:iq-ix  71 :iq-desc "A bat (1/2/3)" :class Monster]
[:iq-ix  72 :iq-desc "A bat (1/2/3)" :class Monster]
[:iq-ix  73 :iq-desc "A bat generator" :class Monster]
[:iq-ix  74 :iq-desc "A bat generator" :class Monster]
[:iq-ix  75 :iq-desc "A trap" :class Scenery]
[:iq-ix  76 :iq-desc "A trap" :class Scenery]
[:iq-ix  77 :iq-desc "A trap" :class Scenery]
[:iq-ix  78 :iq-desc "A trapped wall" :class Scenery]
[:iq-ix  79 :iq-desc "A trapped wall" :class Scenery]
[:iq-ix  80 :iq-desc "A trapped wall" :class Scenery]
[:iq-ix  81 :iq-desc "A locked disappearing door" :class Scenery]
[:iq-ix  82 :iq-desc "A broken pillar" :class Scenery]
[:iq-ix  83 :iq-desc "A healing salve (25 Life)" :class Pickup]
[:iq-ix  84 :iq-desc "A strong bomb" :class Pickup]
[:iq-ix  85 :iq-desc "A super-bomb" :class Pickup]
[:iq-ix  86 :iq-desc "A jar of poison" :class Pickup]
[:iq-ix  87 :iq-desc "A wizard (4 - 4/8/12)" :class Monster]
[:iq-ix  88 :iq-desc "A wizard (4 - 4/8/12)" :class Monster]
[:iq-ix  89 :iq-desc "A wizard (4 - 4/8/12)" :class Monster]
[:iq-ix  90 :iq-desc "A wizard generator" :class Monster]
[:iq-ix  91 :iq-desc "A wizard generator" :class Monster]
[:iq-ix  92 :iq-desc "A wizard generator" :class Monster]
[:iq-ix  93 :iq-desc "A false exit" :class Scenery]
[:iq-ix  94 :iq-desc "An exit to level " :class Scenery]
[:iq-ix  95 :iq-desc "A goblin (2/4/6)" :class Monster]
[:iq-ix  96 :iq-desc "A goblin (2/4/6)" :class Monster]
[:iq-ix  97 :iq-desc "A goblin (2/4/6)" :class Monster]
[:iq-ix  98 :iq-desc "A goblin generator" :class Monster]
[:iq-ix  99 :iq-desc "A goblin generator" :class Monster]
[:iq-ix 100 :iq-desc "A goblin generator" :class Monster]
[:iq-ix 101 :iq-desc "A Fire Mage (? - 10)" :class Monster]
[:iq-ix 102 :iq-desc "An open portcullis" :class Scenery]
[:iq-ix 103 :iq-desc "A closed portcullis" :class Scenery]
[:iq-ix 104 :iq-desc "A wand of annihilation" :class Pickup]
[:iq-ix 105 :iq-desc "An exit-making wand" :class Pickup]
[:iq-ix 106 :iq-desc "A wand of gating" :class Pickup]
[:iq-ix 107 :iq-desc "A crevasse" :class Scenery]
[:iq-ix 108 :iq-desc "A fountain" :class Scenery]
[:iq-ix 109 :iq-desc "A handful of gems" :class Pickup]
[:iq-ix 110 :iq-desc "A candle" :class Pickup]
[:iq-ix 111 :iq-desc "A trap" :class Scenery]
[:iq-ix 112 :iq-desc "A trap" :class Scenery]
[:iq-ix 113 :iq-desc "A trap" :class Scenery]
[:iq-ix 114 :iq-desc "A trap" :class Scenery]
[:iq-ix 115 :iq-desc "A trap" :class Scenery]
[:iq-ix 116 :iq-desc "A trapped wall" :class Scenery]
[:iq-ix 117 :iq-desc "A trapped wall" :class Scenery]
[:iq-ix 118 :iq-desc "A trapped wall" :class Scenery]
[:iq-ix 119 :iq-desc "A trapped wall" :class Scenery]
[:iq-ix 120 :iq-desc "A trapped wall" :class Scenery]
[:iq-ix 121 :iq-desc "A poison gas bomb" :class Pickup]
[:iq-ix 122 :iq-desc "A dimness trap" :class Scenery]
[:iq-ix 123 :iq-desc "A giant bee (5/7/9)" :class Monster]
[:iq-ix 124 :iq-desc "A giant bee (5/7/9)" :class Monster]
[:iq-ix 125 :iq-desc "A giant bee (5/7/9)" :class Monster]
[:iq-ix 126 :iq-desc "A bee generator" :class Monster]
[:iq-ix 127 :iq-desc "A bee generator" :class Monster]
[:iq-ix 128 :iq-desc "A bee generator" :class Monster]
[:iq-ix 129 :iq-desc "An archdevil (12 - 15)" :class Monster]
[:iq-ix 130 :iq-desc "The exit" :class Scenery
  :mobile-exit T]
[:iq-ix 131 :iq-desc "An invisible wall" :class Scenery]
[:iq-ix 132 :iq-desc "A golem (18)" :class Monster]
[:iq-ix 133 :iq-desc "A controllable teleporter" :class Scenery]
[:iq-ix 134 :iq-desc "A siren (5 - 0)" :class Monster]
[:iq-ix 135 :iq-desc "A spider (10)" :class Monster]
[:iq-ix 136 :iq-desc "A web" :class Scenery]
[:iq-ix 137 :iq-desc "A poisonous fountain" :class Scenery]
[:iq-ix 138 :iq-desc "An hourglass" :class Pickup]
[:iq-ix 139 :iq-desc "A phasing wall (in phase)" :class Scenery]
[:iq-ix 140 :iq-desc "A phasing wall (out of phase)" :class Scenery]
[:iq-ix 141 :iq-desc "A phasing wall trap" :class Scenery]
[:iq-ix 142 :iq-desc "A phasing wall trigger" :class Scenery]
[:iq-ix 143 :iq-desc "A phase wand" :class Pickup]
[:iq-ix 144 :iq-desc "An unstable moveable wall (1 move)" :class Scenery]
[:iq-ix 145 :iq-desc "An unstable moveable wall (2 moves)" :class Scenery]
[:iq-ix 146 :iq-desc "A fire fountain" :class Scenery]
[:iq-ix 147 :iq-desc "A wand of light" :class Pickup]
[:iq-ix 148 :iq-desc "A darkness trap" :class Scenery]
[:iq-ix 149 :iq-desc "A counterpoison amulet" :class Pickup]
[:iq-ix 150 :iq-desc "A poisonous amulet" :class Pickup]
[:iq-ix 151 :iq-desc "A passwall amulet" :class Pickup]
[:iq-ix 152 :iq-desc "A random gate" :class Scenery]
[:iq-ix 153 :iq-desc "An amulet of sight" :class Pickup]
[:iq-ix 154 :iq-desc "A wand of flame" :class Pickup]
[:iq-ix 155 :iq-desc "A super-healing potion (back to 500 Life)" :class Pickup]
[:iq-ix 156 :iq-desc "A wand of death" :class Pickup]
[:iq-ix 157 :iq-desc "An earthquake bomb" :class Pickup]
[:iq-ix 158 :iq-desc "A ring of protection" :class Pickup]
[:iq-ix 159 :iq-desc "An amulet of poisonous touch" :class Pickup]
[:iq-ix 160 :iq-desc "A breakable wall" :class Scenery
  :axis NORTH]
[:iq-ix 161 :iq-desc "A breakable wall" :class Scenery
  :axis EAST]
[:iq-ix 162 :iq-desc "A one-shot gate" :class Scenery]
[:iq-ix 163 :iq-desc "An archmage (2 - 12)" :class Monster]
[:iq-ix 164 :iq-desc "A cyclops" :class Monster]
[:iq-ix 165 :iq-desc "A Dark Prince (15)" :class Monster]
[:iq-ix 166 :iq-desc "A blind mage (4 - 8)" :class Monster]
[:iq-ix 167 :iq-desc "A metal door" :class Scenery]
[:iq-ix 168 :iq-desc "A metal door control" :class Scenery]
[:iq-ix 169 :iq-desc "An anti-magic trap" :class Scenery]
[:iq-ix 170 :iq-desc "A wand of webs" :class Pickup]
[:iq-ix 171 :iq-desc "A shade (3/5/7)" :class Monster]
[:iq-ix 172 :iq-desc "A shade (3/5/7)" :class Monster]
[:iq-ix 173 :iq-desc "A shade (3/5/7)" :class Monster]
[:iq-ix 174 :iq-desc "A shade generator" :class Monster]
[:iq-ix 175 :iq-desc "A shade generator" :class Monster]
[:iq-ix 176 :iq-desc "A shade generator" :class Monster]
[:iq-ix 177 :iq-desc "A doppelganger (5)" :class Monster]
[:iq-ix 178 :iq-desc "A magical barrier generator" :class Scenery]
[:iq-ix 179 :iq-desc "A magical barrier" :class Scenery
  :axis EAST]
[:iq-ix 180 :iq-desc "A magical barrier" :class Scenery
  :axis NORTH]
[:iq-ix 181 :iq-desc "A gunk seed" :class Monster]
[:iq-ix 182 :iq-desc "A gunk (2)" :class Monster]
[:iq-ix 183 :iq-desc "A magical key" :class Pickup]
[:iq-ix 184 :iq-desc "A giant ant (7)" :class Monster]
[:iq-ix 185 :iq-desc "A Dark Brain (8 - 8)" :class Monster]
[:iq-ix 186 :iq-desc "An invisible mage (10)" :class Monster]
[:iq-ix 187 :iq-desc "A magical mirror" :class Scenery]
[:iq-ix 188 :iq-desc "A fading wall" :class Scenery]
[:iq-ix 189 :iq-desc "A confusion trap" :class Scenery]
[:iq-ix 190 :iq-desc "A wall generator" :class Scenery
  :direction NORTH]
[:iq-ix 191 :iq-desc "A wall generator" :class Scenery
  :direction SOUTH]
[:iq-ix 192 :iq-desc "A wall generator" :class Scenery
  :direction WEST]
[:iq-ix 193 :iq-desc "A wall generator" :class Scenery
  :direction EAST]
[:iq-ix 194 :iq-desc "An arrow trap" :class Scenery]
[:iq-ix 195 :iq-desc "A dragon egg" :class Monster]
[:iq-ix 196 :iq-desc "A wyrm (young dragon) (9)" :class Monster]
[:iq-ix 197 :iq-desc "A dragon (20 - 20)" :class Monster]
[:iq-ix 198 :iq-desc "A wand of remote action" :class Pickup]
[:iq-ix 199 :iq-desc "A random-damage trap" :class Scenery]
[:iq-ix 200 :iq-desc "A wand of shielding" :class Pickup]
[:iq-ix 201 :iq-desc "A weakness trap" :class Scenery]
[:iq-ix 202 :iq-desc "A rotation trap" :class Scenery]
[:iq-ix 203 :iq-desc "A krogg (10)" :class Monster]
[:iq-ix 204 :iq-desc "A vampire (10)" :class Monster]
[:iq-ix 205 :iq-desc "A moving wall" :class Scenery]
[:iq-ix 206 :iq-desc "An illusory wall" :class Scenery]
[:iq-ix 207 :iq-desc "An exploding wall" :class Scenery]
[:iq-ix 208 :iq-desc "A wall-making trap" :class Scenery]
[:iq-ix 209 :iq-desc "A snitch (2)" :class Monster]
[:iq-ix 210 :iq-desc "A Dark King (12 - 12)" :class Monster]
[:iq-ix 211 :iq-desc "A Lord of the Undead (15 - 5)" :class Monster]

])

(defn show-tiles-in-html []

  (setv all-tile-types [None])
  (for [string-group ["Scenery" "Objects" "Monsters"]]
    (.extend all-tile-types (gfor
      [i desc] (enumerate (string-resource string-group))
      (dict :desc desc :group string-group :i (+ i 1)))))
  (setv portions (partition 2 [
    0 0
    1 7
    10 17
    67 67
    18 18
    68 71
    19 19
    20 21
    72 73
    85 85
    74 80
    22 23
    109 118
    123 130

    109 109 109 109 110 110 110 110 111 111 111 111
    112 112 112 112 113 113 113 113 114 114 114 114
    115 115 115 115 116 116 116 116 117 117 117 117
    118 118 118 118

    15 15 15 15 15 15
    16 16 16 16 16 16

    24 25
    81 84

    119 119 119 119 119 119
    120 120 120 120 120 120

    8 9

    121 121 121 121 121 121
    122 122 122 122 122 122

    131 131
    26 27
    86 88
    28 29
    89 90

    15 15 15 15 15 15 15 15 15 15
    16 16 16 16 16 16 16 16 16 16

    91 91
    30 30
    
    132 132 132 132 132 132
    133 133 133 133 133 133
    
    134 134
    31 32
    135 135
    33 33
    136 137
    34 35
    92 92
    36 39
    93 93
    40 42
    94 94
    43 43
    95 97
    44 44
    98 104
    45 47
    140 143
    48 50
    105 105

    138 138 138 138 138 138
    139 139 139 139 139 139

    144 144

    51 51
    52 52 52 52
    145 146
    106 106
    147 149
    53 55

    56 56 56 56 56 56 56 56

    57 57
    150 152
    107 107
    58 58
    108 108
    59 60
    153 154
    61 63
    64 64
    155 157]))
  (setv tile-types (+ #* (gfor
    [i1 i2] portions
    (cut all-tile-types i1 (+ i2 1)))))

  (return tile-types)

;  (for [[i tt] (enumerate all-tile-types)]
;    (when (not-in tt tile-types)
;      (print i (hy.repr tt))))

  (import html)
  (.write-text (Path "/tmp/iq_tiles.html") (+
    "<!DOCTYPE html>\n"
    "<html lang='en'><meta charset=\"UTF-8\">\n"
    "<title>Infinity Quest II tiles</title>\n"
    "<table>"
    (.join "\n" (gfor
      i (range 1 257)
      (.format "<tr><td>{}<td>{}<td>{}</tr>"
        i
        f"<img alt='' src='tile_images/tile_{i :03}.gif'>"
        (html.escape (if (< i (len tile-types))
          (do
            (setv t (get tile-types i))
            (if t (.format "{desc} [{group} {i}]" #** t) "???"))
          "-")))))
    "</table>")))
