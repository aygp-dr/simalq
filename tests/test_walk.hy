(import
  pytest
  simalq.game-state [G]
  simalq.geometry [Pos pos+ at NORTH EAST SOUTH WEST NORTHEAST SOUTHEAST SOUTHWEST]
  simalq.un-iq [read-quest iq-quest]
  simalq.player-actions [do-action Walk ActionError]
  simalq.main [start-quest])


(defmacro cant [form msg-check]
  (setv e (hy.gensym))
  `(do
    (with [~e (pytest.raises ActionError)]
      ~form)
    (assert (in ~msg-check (. ~e value args [0])))))



(defn test-bootcamp-level1 []
  (start-quest (read-quest (iq-quest "Boot Camp 2")))
  (assert (= G.level-n 1))

  (defn wk [direction]
    (do-action (Walk direction)))

  ; We start at the extreme northwest.
  (assert (= G.player-pos (Pos G.map 0 15)))
  ; Walk south 1 step.
  (wk SOUTH)
  (assert (= G.player-pos (Pos G.map 0 14)))
  ; Try going west, bumping into the level border.
  (cant (wk WEST) "The border of the dungeon blocks your movement.")
  ; Try walking into a wall tile.
  (wk SOUTH)
  (cant (wk SOUTH) "Your way is blocked.")
  ; Walk into the (plain) door to the east.
  (wk NORTHEAST)
  (for [_ (range 3)]
    (wk EAST))
  (assert (= (. (at G.player-pos) [0] stem) "door"))
  ; Try walking diagonally past the wall to the north.
  (cant (wk NORTHEAST) "That diagonal is blocked by a neighbor.")
  ; Walk diagonally between some pillars.
  (setv G.player-pos (Pos G.map 3 1))
  (assert (= (. (get G.map.data 3 2 0) stem) "pillar"))
  (assert (= (. (get G.map.data 4 1 0) stem) "pillar"))
  (wk NORTHEAST)
  (assert (= G.player-pos (Pos G.map 4 2)))
  ; Try some one-way doors.
  (setv G.player-pos (Pos G.map 3 13))
  (cant (wk SOUTH) "That one-way door must be entered from the east.")
  (wk WEST)
  (setv (cut (at (pos+ G.player-pos SOUTH))) [])
    ; We remove a wall so that stepping into these one-way doors
    ; diagonally won't be blocked by it.
  (cant (wk SOUTHEAST) "That one-way door must be entered from the east.")
  (cant (wk SOUTHWEST) "That one-way door must be entered from the north.")
  (wk WEST)
  (wk SOUTH) ; Now we're on the door.
  (cant (wk NORTH) "You can only go south from this one-way door.")
  (wk SOUTH)
  (cant (wk NORTH) "That one-way door must be entered from the north."))
