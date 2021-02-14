open Belt

type id = string
type title = string
type ingredients = string
type instructions = string
type tag = string

type recipe = {
  id: id,
  title: title,
  ingredients: ingredients,
  instructions: instructions,
  tags: array<tag>,
}

type taggedRecipes = {
  tag: tag,
  recipes: array<id>,
}
