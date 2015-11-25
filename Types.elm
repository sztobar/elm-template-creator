module Types where

type alias Named a =
  { a |
      name : String
  }

type alias Identified a =
  { a |
      id : ID
  }

type alias ID = Int
