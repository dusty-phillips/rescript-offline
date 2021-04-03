@module("rxdb/plugins/replication-graphql")
external graphqlReplicationPlugin: 'plugin = "RxDBReplicationGraphQLPlugin"

type queryParams = {
  query: string,
  variables: {"id": Model.id, "minUpdatedAt": float, "limit": int},
}

type queryBuilder<'document> = Js.Nullable.t<'document> => queryParams

type pullOptions<'document> = {queryBuilder: queryBuilder<'document>}

type syncGraphQLOptions<'document> = {
  url: string,
  pull: pullOptions<'document>,
  deletedFlag: string,
  live: bool,
}

let recipeQueryBuilder: queryBuilder<Model.recipe> = recipeOption => {
  let query = `
    query Query($id: String!, $minUpdatedAt: Float!, $limit: Int!) {
      recipeRxDbFeed(id: $id, minUpdatedAt: $minUpdatedAt, limit: $limit) {
        id
        title
        ingredients
        instructions
        deleted
        tags
        updatedAt
      }
    }
  `

  let variables = switch recipeOption->Js.Nullable.toOption {
  | Some(recipe) => {
      "id": recipe.id,
      "minUpdatedAt": recipe.updatedAt,
      "limit": 5,
    }
  | None => {
      "id": "",
      "minUpdatedAt": 0.0,
      "limit": 5,
    }
  }

  {
    query: query,
    variables: variables,
  }
}

let taggedRecipesQueryBuilder: queryBuilder<Model.taggedRecipes> = recipeOption => {
  let query = `
    query Query($id: String!, $minUpdatedAt: Float!, $limit: Int!) {
      taggedRecipesRxDbFeed(tag: $id, minUpdatedAt: $minUpdatedAt, limit: $limit) {
        tag
        recipes
        updatedAt
        deleted
      }
    }
  `

  let variables = switch recipeOption->Js.Nullable.toOption {
  | Some(taggedRecipes) => {
      "id": taggedRecipes.tag,
      "minUpdatedAt": taggedRecipes.updatedAt,
      "limit": 5,
    }
  | None => {
      "id": "",
      "minUpdatedAt": 0.0,
      "limit": 5,
    }
  }

  {
    query: query,
    variables: variables,
  }
}
