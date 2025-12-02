module Days.One where

dayOne :: IO ()
dayOne = do
  contents <- readFile "./app/Days/one-input.txt"
  let actions = lines contents
      result = foldl' calculation (50, 0) actions
  putStrLn . show $ snd result

calculation :: (Int, Int) -> String -> (Int, Int)
calculation (position, numZeros) action = do
  let (direction : amount) = action
      potentialPosition = case direction of
        'L' -> (position - (read @Int amount))
        'R' -> (position + (read @Int amount))
        _ -> position
      newPosition = mod potentialPosition 100
      newZeros = case newPosition == 0 of
        True -> numZeros + 1
        False -> numZeros
  (newPosition, newZeros)
