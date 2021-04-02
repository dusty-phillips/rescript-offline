@module("rxdb/plugins/replication-graphql")
external graphqlReplicationPlugin: 'plugin = "RxDBReplicationGraphQLPlugin"
type queryParams = {
  query: string,
  variables: {"id": Model.id, "minUpdatedAt": float, "limit": int},
}

type queryBuilder<'document> = option<'document> => queryParams

