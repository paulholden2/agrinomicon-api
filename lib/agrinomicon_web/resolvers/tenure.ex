defmodule AgrinomiconWeb.Resolvers.Tenure do
  import Ecto.Query

  def list_tenures(_parent, args, _resolution) do
    queryable =
      from(
        Agrinomicon.Production.Tenure
        |> sort_tenures(args)
        |> limit_tenures(args)
      )

    {:ok, queryable |> Agrinomicon.Repo.all()}
  end

  defp sort_tenures(queryable, %{sort_by: sort_by, sort_dir: sort_dir})
       when sort_by in ["occupied_at"] and sort_dir in ["asc", "desc"] do
    order_by(queryable, ^["#{sort_dir}": String.to_atom(sort_by)])
  end

  defp sort_tenures(q, _), do: q

  defp limit_tenures(queryable, %{limit: limit}) when is_integer(limit) and limit > 0 do
    limit(queryable, ^limit)
  end

  defp limit_tenures(q, _), do: q
end
