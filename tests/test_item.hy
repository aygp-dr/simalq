(require
  hyrule [do-n ecase]
  tests.lib [cant])
(import
  fractions [Fraction :as f/]
  tests.lib [init init-boot-camp assert-at assert-player-at assert-hp assert-textmap assert-full-name set-square mv-player wk shoot wait use-item top]
  simalq.geometry [Pos Direction at]
  simalq.game-state [G]
  simalq.util [StatusEffect]
  simalq.tile [Monster]
  simalq.quest-definition [mk-tile]
  simalq.commands [move-blocked-msgs])
(setv  T True  F False)


(defn test-treasure []
  (init-boot-camp)

  (mv-player 6 14)
  (assert (= G.score 0))
  (assert-at 'E "pile of gold")
  (wk 'E)
  (assert (= G.score 100))
  (assert-at 'here 'player)

  (mv-player 5 10)
  (assert-at 'N "handful of gems")
  (wk 'N)
  (assert (= G.score 350))
  (assert-at 'here 'player))


(defn test-key-get []
  (init-boot-camp)
  (mv-player 13 10)
  (assert (and (= G.player.keys 0) (= G.score 0)))
  (wk 'S)
  (assert (and (= G.player.keys 1) (= G.score 50)))

  (init-boot-camp)
  (mv-player 13 10)
  (setv G.player.keys G.rules.max-keys)
  (assert (and (= G.player.keys G.rules.max-keys) (= G.score 0)))
  (cant (wk 'S) "Your keyring has no room for another key.")
  (assert (and (= G.player.keys G.rules.max-keys) (= G.score 0)))

  ; Being maxed out on keys doesn't prevent you from unlocking a door
  ; on the same square.
  (init)
  (set-square 'E "key" "locked door")
  (assert-at 'E "key" "locked door")
  (setv G.player.keys G.rules.max-keys)
  (wk 'E)
  (assert-at 'E "key" "door")
  (assert (= G.player.keys (- G.rules.max-keys 1)))
  (wk 'E)
  (assert-at 'here 'player "door"))


(defn test-magic-arrow []
  (init
    :map "
      ████████d ████
      @ ↑ o d ☠ ##G "
    :map-marks {
      "o " ["orc" :hp 4]
      "☠ " "jar of poison"
      "##" ["cracked wall" :hp 3]})

  ; Pick up some magic arrows.
  (assert (= G.player.magic-arrows 0))
  (wk 'E)
  (assert (= G.player.magic-arrows 10))
  (assert-at 'E "orc")
  (assert-hp 'E 4)
  ; Shoot at the orc. That does 3 damage to it. The devil is unhurt.
  (shoot 'E)
  (assert-at 'E "orc")
  (assert-hp 'E 1)
  (assert-at [3 0] "devil")
  ; Shoot again. This kills the orc, so the magic arrow penetrates
  ; and continues along the whole line, smashing the jar of poison
  ; and hitting the ghost. Unlike IQ, a magic arrow can continue
  ; after destroying an object.
  (shoot 'E)
  (assert-at 'E 'floor)
  (assert-at [3 0] 'floor)
  (assert-at [4 1] 'floor)
  (assert-at [6 0] 'floor))


(defn test-clock []
  (init
    :time-limit 10
    :tiles ["clock"])
  (wait 2)
  (assert (= G.time-left 8))
  (wk 'E)
  (assert (= G.time-left 32)))


(defn test-food-eat []
  (init :tiles [
     "snack" "meal" "jar of poison" "rotten food" "empty platter"
     "dessert" "snack" "dessert"])
  (assert (= G.player.hp 100))
  (wk 'E)
  (assert (= G.player.hp 125))
  (wk 'E)
  (assert (= G.player.hp 225))
  (wk 'E)
  (assert (= G.player.hp 175))
  (wk 'E)
  (assert (= G.player.hp  75))
  (wk 'E)
  (assert (= G.player.hp  75))
  (wk 'E)
  (assert (= G.player.hp 500))
  (wk 'E)
  (assert (= G.player.hp 525))
  ; The second dessert has no effect, because we're already at 500 HP.
  (wk 'E)
  (assert (= G.player.hp 525)))


(defn test-food-hp-factor []
  (init
    :player-hp-factor (f/ 1 2)
    :tiles ["snack" "meal" "dessert"])
  (assert (= G.player.hp 50))
  (wk 'E)
  (assert (= G.player.hp 62))
    ; The snack heals 12 HP rather than 13 because of the
    ; round-to-even rule.
  (wk 'E)
  (assert (= G.player.hp 112))
  (wk 'E)
  (assert (= G.player.hp 250)))


(defn test-food-shoot []
  "We also test poison-gas bombs here, because they have the same
  effect when used as a jar of poison does when shot."

  (init
    :tiles ["snack"])
  ; Shooting a snack (or most other foods) just destroys it.
  (assert-at 'E "snack")
  (shoot 'E)
  (assert-at 'E 'floor)

  (for [use-bomb? [F T]]
    (init
      :map "
        @ ☠ ██o o
        ██##██G ██
        ██o ██████"
      :map-marks {
        "☠ " "jar of poison"
        "##" ["cracked wall" :hp 2]
        "o " ["orc" :hp 4]})
    ; Shooting a jar of poison (or using a poison-gas bomb) creates a
    ; 5 × 5 cloud of poison, which can damage both the player and
    ; monsters. It goes through walls.
    (assert-at 'E "jar of poison")
    (assert (= G.player.hp 100))
    (if use-bomb?
      (use-item "poison-gas bomb" 'E)
      (shoot 'E))
    (assert-at 'E (if use-bomb? "jar of poison" 'floor))
    ; The player takes 20 damage.
    (assert (= G.player.hp 80))
    ; The two orcs in the blast radius take 3 damage each.
    (assert-hp [1 0] 1)
    (assert-hp [3 2] 1)
    ; The ghost, being undead, takes no damage from poison.
    (assert-hp [3 1] 1)
    ; Cracked walls are also immune to poison.
    (assert-hp [1 1] 2)
    ; The third orc is outside of the blast radius.
    (assert-hp [4 2] 4)
    ; Points are earned for all damage dealt.
    (assert (= G.score (py "3*3 + 3*3")))))


(defn test-amulet-of-invulnerability []
  (init
    :poison-intensity (f/ 1 3)
    :tiles ["amulet of invulnerability" "orc"])
  (defn check [turn-n player-hp [poison-dose None]]
    (assert (and (= G.turn-n turn-n)) (= G.player.hp player-hp))
    (when (is-not poison-dose None)
      (= G.player.poison-dose poison-dose)))

  (check 0 100 (f/ 0))
  ; Get hit by the orc and breathe in some poison.
  (wk 'NE)
  (check 1 97 (f/ 1 3))
  ; Pick up the amulet.
  (wk 'S)
  (check 2 97 (f/ 1 3))
  ; The amulet provides 20 turns of protection, including the turn we
  ; got it. (This is 1 more turn than you effectively get in IQ.)
  (wait 19)
  (check 21 97 (f/ 1 3))
  (wait)
  (check 22 94 (f/ 2 3))

  ; If you get multiple status-effect items, the durations are summed.
  (init
    :tiles [#* (* ["amulet of invulnerability"] 2) "orc"])
  (wk 'E 2)
  (wait 38)
  (check 40 100)
  (wait)
  (check 41 97))


(defn test-cloak-of-invisibility []

  (init
    :map "
      . d . . .
      . . . . .
      @ ! . i .
      . . . . .
      . o . . ."
    :map-marks {
      "! " "cloak of invisibility"})
  (assert (= G.player.hp 100))
  ; Get the cloak. Now that we're invisible, the orc can't approach
  ; and the devil can't shoot. (Nor can the imp flee, and it's too
  ; close to shoot even if the player were visible, but it can still
  ; wander.)
  (wk 'E)
  (while (at (Pos G.map 3 2))
    (wait))
  (assert (<= G.turn-n 10))
  (assert (= G.player.hp 100))
  (assert-at [1 0] "orc")
  (assert-at [1 4] "devil")
  ; Step adjacent to the orc, allowing it to attack. The devil remains
  ; immobile.
  (wk 'SW)
  (assert (= G.player.hp 97))
  (assert-at [1 4] "devil")

  ; Contra IQ, monsters can still shoot an invisible Tris so long as
  ; they're adjacent.
  (init
    :map "
       ██d
       . ██
       ! ██
       @ ██"
    :map-marks {
      "! " "cloak of invisibility"})
  (wk 'N 2)
  (assert (= G.player.hp 90)))


(defn test-potion-of-speed []
  (init
    :tiles ["potion of speed" "orc"])
  (defn check [state-i turn-n [player-hp None]]
    (assert (and (= G.state-i state-i) (= G.turn-n turn-n)))
    (when (is-not player-hp None)
      (assert (= G.player.hp player-hp))))

  (check 0 0 100)
  ; Pick up the potion of speed. We immediately get a second action
  ; for this turn, so the orc doesn't get to hit yet.
  (wk 'E)
  (check 1 0 100)
  ; Wait a bit, watching the orc hit once per two actions.
  (wait)
  (check 2 1 97)
  (wait)
  (check 3 1 97)
  (wait)
  (check 4 2 94)
  ; Kill the orc.
  (wk 'E)
  (check 5 2 94)
  ; Wait around until the potion wears off. Tris gets 10 free actions
  ; in total.
  (wait 13)
  (check 18 9)
  (wait)
  (check 19 9)
  (wait)
  (check 20 10)
  (wait)
  (check 21 11))


(defn test-amulet-of-poison []
  (init
    :map "
      . @ .
      o ! o
      o o o"
    :map-marks {
      "o " ["orc" :hp 10]
      "! " "amulet of poison"})

  ; Pick up the amulet, doing 3 damage to all the surrounding orcs.
  (wk 'S)
  ; Make another orc on our own square. Wait 1 turn, doing another
  ; 3 damage to all of 'em.
  (Monster.make G.player.pos "orc" :hp 10)
  (wait)
  (for [direction ['E 'SE 'S 'SW 'W]]
    (assert-hp direction 4))
  (assert-hp 'here 7))


(defn test-passwall-amulet []

  (defn ok [tile [can-pass-thru? True]]
    (init
      :tiles ["passwall amulet" tile])
    (wk 'E)
    (if can-pass-thru?
      (do
        (wk 'E 2)
        (assert-player-at 3 0))
      (cant (wk 'E))))

  (ok "wall")
  (ok "trapped wall")
  (ok "cracked wall")
  (ok "breakable wall (zonal)")
  (ok "pillar")
  (ok "broken pillar")
  (ok "locked door")
  (ok "locked disappearing door")
  (ok "one-way door (west)")
  (ok "closed portcullis")
  (ok "phasing wall (in phase)")

  (ok "Void" F)
  (ok "water fountain" F)
  (ok "treasure chest" F))


(defn test-passwall-diag []

  ; Passwall allows you to ignore diagonal blockers that you would be
  ; able to walk through, but not other diagonal blockers (contra IQ).
  (init
    :map "
      . ██.
      @ ! ██"
    :map-marks {
      "! " "passwall amulet"})
  (wk 'E)
  (wk 'NE)
  (assert-player-at 2 1)
  (mv-player 1 0)
  (set-square 'N "Void")
  (cant (wk 'NE) move-blocked-msgs.diag)

  ; Test for a bug where monsters could ignore diagonal blockers if
  ; the player had a passwall amulet.
  (init
    :map "
      . ██o
      @ ! ██"
    :map-marks {
      "! " "passwall amulet"})
  (wk 'E)
  (assert (= G.player.hp 100)))


(defn test-ring-of-protection []
  (init
    :height 1
    :tiles [
      "passwall amulet" "ring of protection"
      "anti-magic trap" "weakness trap"
      "pile of gold" "hole" "archmage"])
  (defn check [player-hp pass prot]
    (assert (= G.player.hp player-hp))
    (assert (= (.player-has? StatusEffect.Pass) pass))
    (assert (= (.player-has? StatusEffect.Prot) prot)))

  ; A ring of protection makes an anti-magic trap ineffective.
  (wk 'E 3)
  (check 100 T T)
  ; Likewise a weakness trap.
  (wk 'E)
  (assert (not (.player-has? StatusEffect.Weak)))
  ; The archmage's shots have no effect, since we have an effect to
  ; disenchant (`Pass`), but he can't actually remove it due to
  ; `Prot`.
  (wk 'E)
  (check 100 T T)
  ; Just before `turn-n` advances to 20, `Pass` ends. `Prot` is still
  ; in effect, but doesn't do anything about damaging shots from the
  ; archmage.
  (wait 14)
  (assert (= G.turn-n 19))
  (check 100 T T)
  (wait)
  (check 100 F T)
  (wait)
  (check 88 F T))


(defn test-magical-key []

  (setv becomes {
    'floor                     'floor
    "locked door"              "door"
    "door"                     "door"
    "locked disappearing door" 'floor
    "closed portcullis"        "closed portcullis"
      ; The portcullis will open, but then close again after we walk
      ; through it.
    "treasure chest"           'floor
    "one-way door (east)"      "door"
    "one-way door (north)"     "door"
    "metal door"               'floor})
  (init :tiles [
    "magical key" "magical key"
    #* (.keys becomes)
    'floor "wall"])

  (wk 'E 19)
  (cant (wk 'E) move-blocked-msgs.simple)
  (for [[i result] (enumerate (.values becomes))]
    (assert-at [(+ i 3) 0] result)))


(defn test-inventory []
  (init :tiles [
     "wand of shielding" "wall-making wand"
     "standard bomb" "standard bomb"])

  (defn check [#* args]
    (assert (all (gfor
      [got expected] (zip G.player.inventory args)
      (if (is expected None) (is got None) (= got.stem expected))))))

  ; Inventory slots fill from the top.
  (check None None None)
  (cant (use-item 0) "That inventory slot is empty.")
  (wk 'E)
  (check "wand of shielding" None None)
  (cant (use-item 1) "That inventory slot is empty.")
  (wk 'E)
  (check "wand of shielding" "wall-making wand" None)
  (setv
    [(get G.player.inventory 0) (get G.player.inventory 2)]
    [(get G.player.inventory 2) (get G.player.inventory 0)])
  (check None "wall-making wand" "wand of shielding")
  (wk 'E)
  (check "standard bomb" "wall-making wand" "wand of shielding")
  (cant (wk 'E) "Your inventory is full.")
  (assert-at 'E "standard bomb")
  (assert-at 'W 'floor))


(defn test-wand-shielding []
  (init :map "
    . o .
    ██. .
    $ @ .")

  ; A wand of shielding creates a shield on each adjacent square (even
  ; if something else is there, unlike IQ). Monsters can't move onto
  ; the shields.
  (use-item "wand of shielding")
  (assert-at 'W "magical energy shield" "pile of gold")
  (assert-at 'NW "magical energy shield" "wall")
  (assert-at 'N "magical energy shield")
  (assert-at 'NE "magical energy shield")
  (assert-at 'E "magical energy shield")
  ; But Tris can walk onto them. Since this puts her on top of the
  ; shield tiles rather than under them, they no longer protect her.
  (assert (= G.player.hp 100))
  (wk 'N)
  (assert (= G.player.hp 97))

  ; Unlike IQ, creating new shields don't affect existing ones, which
  ; keep their own timers.
  (defn check [turn-n old new]
    (assert (= G.turn-n turn-n))
    (setv old (if old ["magical energy shield"] []))
    (setv new (if new ["magical energy shield"] []))
    (assert-at 'here 'player #* old)
    (assert-at 'NE #* new)
    (assert-at 'E #* old #* new))
  (use-item "wand of shielding")
  (assert-full-name 'N "a magical energy shield (time left 11)")
  (check 3 T T)
  ; Shields protect for 12 turns, so the first set (created on turn 0,
  ; and therefore providing its first turn of protection on turn 0)
  ; disappates at the end of turn 11, soon before `G.turn-i` becomes
  ; 12.
  (wait 8)
  (check 11 T T)
  (wait)
  (check 12 F T)
  ; The second set disspiates just before turn 2 + 12 = 14.
  (wait)
  (check 13 F T)
  (wait)
  (check 14 F F))


(defn test-wand-wall-making []
  (init
    :tiles ["orc" "wall"])

  ; Unlike IQ, walls can be added regardless of what's already on the
  ; target square.
  (use-item "wall-making wand" [0 0])
  (assert-at [0 0] "wall" 'player)
  (use-item "wall-making wand" [1 0])
  (assert-at [1 0] "wall" "orc")
  (use-item "wall-making wand" [2 0])
  (assert-at [2 0] "wall" "wall")
  (use-item "wall-making wand" [3 0])
  (assert-at [3 0] "wall"))


(defn test-wand-phase []
  (init)
  (defn phase [start end]
    (set-square 'E #* start)
    (use-item "phase wand" 'E)
    (assert-at 'E #* end))

  (phase
    []
    ["phasing wall (out of phase)"])
  (phase
    ["wall"]
    ["phasing wall (out of phase)" "wall"])
  (phase
    ["phasing wall (out of phase)"]
    ["phasing wall (in phase)"])
  (phase
    ["phasing wall (in phase)"]
    ["phasing wall (out of phase)"])
  ; Only the topmost phaser is affected.
  (phase
    ["wall" "phasing wall (in phase)" "wall" "phasing wall (out of phase)"]
    ["wall" "phasing wall (out of phase)" "wall" "phasing wall (out of phase)"]))


(defn test-wand-wall-destroying []
  (init
    :tiles ["orc" "wall" "pillar"])

  (cant (use-item "wall-destroying wand" 'E) "There isn't a destructible tile there.")
  (use-item "wall-destroying wand" [2 0])
  (assert-at [2 0] 'floor)
  (use-item "wall-destroying wand" [3 0])
  (assert-at [3 0] 'floor)
  (set-square [3 0] "wall" "wall")
  (assert-at [3 0] "wall" "wall")
  (use-item "wall-destroying wand" [3 0])
  (assert-at [3 0] "wall"))


(defn test-wand-exit []
  (init
    [:next-level 3 :tiles ["pile of gold"]]
    []
    [])

  (cant (use-item "wand of exit" 'E) "This wand can only target an empty square.")
  (use-item "wand of exit" 'N)
  (wk 'N)
  (assert (= G.level-n 3)))


(defn test-wand-webs []
  (init
    :reality-bubble-size 7
    :height 1
    :tiles ['floor "pile of gold" 'floor "wall" "giant spider" "wall" 'floor 'floor])

  (use-item "wand of webs")
  ; Every free square in the reality bubble gets a web.
  ; (The wand doesn't add a web under the spider, but the spider makes
  ; one itself.)
  (assert-at [1 0] "web")
  (assert-at [2 0] "pile of gold")
  (assert-at [3 0] "web")
  (assert-at [4 0] "wall")
  (assert-at [5 0] "giant spider" "web")
  (assert-at [6 0] "wall")
  (assert-at [7 0] "web")
  (assert-at [8 0] 'floor))


(defn test-wand-death []
  (setv map-marks {
    "s " "shade"
    "☉G" ["generator" :summon-class "ghost"]
    "☉o" ["generator" :summon-class "orc"]
    "##" "cracked wall"})
  (init
    :map "
      ██d ██☉G██A
      t ██o ##i ██
      ██G ██☉o██K
      @ ██N ██s ██"
    :map-marks map-marks)

  (setv hp (int 1e20))
  (for [
      x (range G.map.width)
      y (range G.map.height)
      :if (= (% (+ x y) 2) 0)]
    (setv (. (top [x y]) hp) hp))

  (use-item "wand of death" [2 2])
  ; Undead, undead generators, cracked walls, and (contra IQ) negatons
  ; are immune to wands of death. The rightmost column is outside the
  ; burst radius.
  (assert-textmap :map-marks map-marks :text "
    ██. ██☉G██A
    . ██. ##. ██
    ██G ██. ██K
    @ ██N ██s ██")
  ; Tris doesn't die instantly, but she does take 25 damage.
  (assert (= G.player.hp (- hp 25)))
  ; Contra IQ, points are awarded for all kills.
  (assert (= G.score (+ (* 12 hp) 10 (* 3 hp) (* 4 hp) (* 5 hp)))))


(defn test-wand-annihilation []
  (init)
  (set-square 'E
    "orc" "wall" "exit" "pile of gold" "negaton" "Void" "hole")
  ; Everything except the Void is destroyed by annihilation.
  (use-item "wand of annihilation" 'E)
  (assert-at 'E "Void")
  ; There's an error message for trying to use a wand of annihliation
  ; where it would do nothing.
  (cant (use-item "wand of annihilation" 'E) "There isn't anything you can annihilate there.")
  (cant (use-item "wand of annihilation" 'N) "There isn't anything you can annihilate there.")
  ; Contra IQ, we allow the player to kill herself with a wand of
  ; annihilation, because it's funny.
  (use-item "wand of annihilation" 'here)
  (cant (wk 'E) "You're dead. You can undo or load a saved game."))


(defn test-wand-flame []
  (init
    :height 1
    :tiles ["wall" ["orc" :hp 10] ["orc" :hp 10] "web" "wall" ["orc" :hp 10]])

  (assert (= G.player.hp 100))
  (use-item "wand of flame" [2 0])
  ; The player is unhurt.
  (assert (= G.player.hp 100))
  ; The wall is unaffected.
  (assert-at [1 0] "wall")
  ; Orc 1 takes 2 damage.
  (assert-hp [2 0] 8)
  ; Orc 2 takes 1 damage.
  (assert-hp [3 0] 9)
  ; The web is destroyed.
  (assert-at [4 0] 'floor)
  ; Orc 3 is out of range and undamaged.
  (assert-hp [6 0] 10))


(defn test-wand-teleportation []
  (init
    :tiles ["orc"])

  (cant (use-item "wand of teleportation" 'E) "This wand can only target an empty square.")
    ; You can't tele-frag with a wand.
  (use-item "wand of teleportation" [3 4])
  (assert-player-at 3 4))


(defn test-wand-remote-action []
  (init
    :reality-bubble-size Inf
    :width 30 :height 1
    :tiles [
      "pile of gold" "wall generator (west)"
      "treasure chest" "key"
      "phase trigger" "phasing wall (in phase)"
      "barrier projector" "magical barrier (zonal)"
      "cracked wall" "orc"])
  (defn remote [x]
    (use-item "wand of remote action" [x 0]))
  (setv nothing "There isn't anything you can affect there.")

  ; Wands of remote action can do lots of things.
  ; Pick up gold.
  (remote 1)
  (assert (= G.score 100))
  ; Trigger a wall generator.
  (remote 2)
  (assert-at [1 0] "wall")
  (assert-at [2 0] "wall")
  ; Try to unlock a chest.
  (set-square [3 0] "treasure chest" "pile of gold")
  (cant (remote 3) "It's locked, and you're keyless at the moment.")
  ; Get a key, unlock it, and get the gold.
  (remote 4)
  (assert (= G.player.keys 1))
  (assert (= G.score 150))
  (remote 3)
  (assert (= G.player.keys 0))
  (assert (= G.score 150))
  (remote 3)
  (assert (= G.score 250))
  ; Hit a phase trigger.
  (remote 5)
  (assert-at [6 0] "phasing wall (out of phase)")
  ; Hit a barrier projector.
  (remote 7)
  (assert-at [8 0] 'floor)

  ; Things that wands of remote action can't do include:
  ; - Break a cracked wall
  (cant (remote 9) nothing)
  ; - Attack a monster
  (cant (remote 10) nothing)
  ; - Affect an empty square
  (cant (remote 15) nothing)
  ; - Pick up a key when you're already full.
  (setv G.player.keys G.rules.max-keys)
  (set-square 'E "key")
  (cant (remote 1) "Your keyring has no room for another key."))


(defn test-fire-bomb []
  "Put some orcs in a line and check how much damage is done to each."

  (defn check [item-stem usage #* damages]
    (setv starting-orc-hp 10)
    (init
      :height 1
      :tiles (lfor  _ damages  ["orc" :hp starting-orc-hp]))
    (ecase usage
      'use (do
        ; Actually use the bomb.
        (use-item item-stem 'E))
      'shoot (do
        ; Shoot the bomb while it's on the floor. This creates a
        ; less impressive explosion.
        (mk-tile 'E item-stem)
        (shoot 'E)))
     (for [[i dmg] (enumerate damages)]
       (assert-hp [(+ i 1) 0] (- starting-orc-hp dmg))))

  (check  "standard bomb" 'shoot  2 1 0 0 0 0 0)
  (check  "standard bomb" 'use    3 2 1 0 0 0 0)
  (check  "strong bomb"   'shoot  3 2 1 0 0 0 0)
  (check  "strong bomb"   'use    3 3 2 1 0 0 0)
  (check  "super-bomb"    'shoot  3 3 2 1 0 0 0)
  (check  "super-bomb"    'use    3 3 2 2 1 1 0))


(defn test-earthquake-bomb []
  (init
    :map "
       ██| #2█1
       ↑↓#1←→.
       @ ╷ o ."
    :map-marks {
      "o " ["orc" :hp 10]
      "#1" ["cracked wall" :hp 10]
      "#2" ["cracked wall" :hp  2]
      "█1" "trapped wall"})

  ; An earthquake bomb does 3 damage to monsters and 2 to cracked
  ; walls.
  (use-item "earthquake bomb" [1 1])
  (assert-textmap :map-marks {"##" "cracked wall"} :text "
    ##╷ . ##
    . ##. .
    @ ╷ o .")
  (assert-hp [2 0] 7)
  (assert-hp [1 1] 8)
  (assert-hp [0 2] 4)
  (assert-hp [3 2] 4))


(defn test-artifact-weapon []

  ; The sword artifact increases melee damage to 3. Multiple copies
  ; don't stack.
  (init
    :height 1
    :tiles ["Holy Sword" "Holy Sword" ["orc" :hp 4]])
  (wk 'E 3)
  (assert-hp 'E 1)

  ; The bow artifact is similar, but increases ranged damage to 2.
  (init
     :tiles ["Elven Bow" ["orc" :hp 10]])
  (wk 'E)
  (shoot 'E)
  (assert-hp 'E 8)
  ; The Elven Bow has no effect on magic arrows. They still do 3
  ; damage.
  (+= G.player.magic-arrows 10)
  (shoot 'E)
  (assert-hp 'E 5))


(defn test-artifact-shield []
  (init
    :tiles ["Magic Shield" "fixed damaging trap" "devil"])

  ; The shield makes you take 3/4 damage, rounded up.
  ; A devil's shot normally does 10 damage, but now does
  ;     ceil(.75 * 10) = ceil(7.5) = 8.
  (assert (= G.player.hp 100))
  (wk 'E)
  (assert (= G.player.hp 92))
  ; Kill the devil.
  (shoot 'E)
  ; Walk into the trap. The shield only protects against monster
  ; attacks, so this damage is unreduced.
  (wk 'E)
  (assert (= G.player.hp 87)))
