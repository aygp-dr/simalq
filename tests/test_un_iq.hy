(import
  collections [Counter]
  fractions [Fraction]
  toolz [partition]
  simalq.geometry [Pos]
  simalq.un-iq [read-quest iq-quest])


(defn test-get-all []
  (setv d (iq-quest 'all))
  (assert (is (type d) dict))
  (assert (= (len d) 7)))


(defn test-read-bootcamp []
  (setv quest (read-quest (iq-quest "Boot Camp 2")))
  (assert (= quest.title "Boot Camp will teach you how to play Infinity Quest II"))
  (assert (= quest.starting-hp 500))
  (assert (= (len quest.levels) 26)))


(defn test-read-bootcamp-level1 []
  (setv level (. (read-quest (iq-quest "Boot Camp 2")) levels [0]))

  ; Check the level attributes.
  (for [[got expected] (partition 2 [
      level.title (.join "\n" [
        "Welcome to Boot Camp!"
        "Let's start with some basic scenery."
        "Shift-click to identify objects."])
      level.player-start (Pos level.map 0 15)
      level.next-level 2
      level.poison-intensity (Fraction 1 5)
      level.time-limit 0
      level.exit-speed 10
      level.moving-exit-start None
      level.map.wrap-x False
      level.map.wrap-y False])]
    (assert (= got expected)))

  ; Count the number of tiles of each type that occur in the map.
  (assert (=

    (dict (Counter (gfor
      row level.map.data
      stack row
      tile stack
      tile.stem)))

    {

      "wall" 50
      "door" 1
      "one-way door (west)" 1
      "one-way door (south)" 1
      "one-way door (east)" 2
      "cracked wall" 2
      "locked door" 1
      "locked disappearing door" 1
      "pillar" 15
      "exit" 1

      "key" 2
      "pile of gold" 1
      "handful of gems" 1}))

  ; Check a few corner tiles, so we know we haven't rotated or
  ; reflected the map.
  (assert (= (. level map data [0] [0]) [])) ; I.e., floor
  (assert (= (. level map data [15] [0] [0] stem) "key"))
  (assert (= (. level map data [15] [15] [0] stem) "cracked wall"))

  ; Check the hit points of the two cracked walls.
  (assert (= (. level map data [7] [8] [0] hp) 4))
  (assert (= (. level map data [15] [15] [0] hp) 2)))


(defn test-read-varlife []
  (setv m (. (read-quest (iq-quest "New First Quest"))
    levels [2] map data))
  (setv t (get m 11 11 0))
  (assert (= t.stem "Dark Knight"))
  (assert (= t.hp 1))
  ; The life of variable-life monsters is stored in the second byte
  ; of their tile extras.
  (setv t (get m 11 2 0))
  (assert (= t.stem "tricorn"))
  (assert (= (get t.tile-extras 1) 4)))
