(setv

  by-name (dfor
    [k v] (.items {

      'black [0 0 0]
      'white [1 1 1]
      'dark-gray [(/ 1 4) (/ 1 4) (/ 1 4)]
      'light-gray [(/ 3 4) (/ 3 4) (/ 3 4)]
      'brown [(/ 1 2) (/ 1 4) 0]
      'yellow [1 1 0]
      'pale-yellow [1 1 (/ 3 4)]
      'dark-yellow [(/ 1 2) (/ 1 2) 0]
      'red [(/ 3 4) 0 0]
      'dark-navy [0 0 (/ 3 8)]
      'navy [0 0 (/ 1 2)]
      'steel-blue [(/ 1 4) (/ 1 2) (/ 3 4)]
      'lime [0 1 0]})

    k (tuple (gfor  x v  (round (* x 255)))))

  default-fg 'black
  default-bg 'white

  void 'dark-navy
  reality-fringe 'light-gray
  reality-fringe-block 'dark-gray
  focus 'yellow
  message-bg 'pale-yellow)
