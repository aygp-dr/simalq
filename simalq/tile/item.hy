(require
  simalq.macros [fn-dd])
(import
  simalq.util [CommandError]
  simalq.game-state [G]
  simalq.tile [Tile deftile rm-tile])


(defclass Item [Tile]
  "An object the player can pick up."

  (setv __slots__ [])

  (defn hook-player-walked-into [self]
    (rm-tile self)
    (+= G.score self.points)
    (.pick-up self))
  (defn pick-up [self])

  (defn info-bullets [self] [
    #("Point value" self.points)
    (when (is-not (. (type self) pick-up) Item.pick-up)
      #("Pickup effect" (or
        self.pick-up.__doc__
        (self.pick-up.dynadoc self))))]))


(deftile Item "$ " "a pile of gold"
  :color 'dark-yellow
  :iq-ix 18
  :points 100
  :flavor "Ooh, shiny.")

(deftile Item "$ " "a handful of gems"
  :color 'red
  :iq-ix 109
  :points 250
  :flavor "Ooh, shinier.")

(deftile Item "⚷ " "a key"
  :iq-ix 19
  :points 50

  :hook-player-walk-to (fn [self origin]
    (when (>= G.player.keys G.rules.max-keys)
      (raise (CommandError "Your keyring has no room for another key."))))

  :pick-up (fn-dd [self]
    (doc f"Adds to your count of keys. If you're at the maximum number
      of keys ({G.rules.max-keys}), you can't step on its square.")
    (+= G.player.keys 1)
    (assert (<= G.player.keys G.rules.max-keys)))

  :flavor "Idok uses only the worst locks and keys that money can buy. The keys are bulky and heavy, yet immediately snap into pieces on being used once, and every lock can be opened by any old key.")
