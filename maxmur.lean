def D : String := include_str "README.md"

def main : IO Unit := do
  IO.print D
