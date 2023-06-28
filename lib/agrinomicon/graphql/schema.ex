defmodule AgrinomiconWeb.Graphql.Schema do
  use Absinthe.Schema

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias AgrinomiconWeb.Resolvers

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Agrinomicon.Taxonomy, Agrinomicon.Taxonomy.datasource())
      |> Dataloader.add_source(Agrinomicon.Gis, Agrinomicon.Gis.datasource())
      |> Dataloader.add_source(Agrinomicon.Agency, Agrinomicon.Agency.datasource())
      |> Dataloader.add_source(Agrinomicon.Production, Agrinomicon.Production.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  scalar :geojson do
    parse(fn input ->
      with {:ok, geojson} <- Jason.decode(input.value),
           {:ok, geometries} <- Geo.JSON.decode(geojson),
           {[geometry | _], _} <- Map.pop(geometries, :geometries) do
        geometry
      else
        :error -> :error
        _ -> :error
      end
    end)

    serialize(fn value ->
      with {:ok, geojson} <- Geo.JSON.encode(value) do
        geojson
      else
        :error -> :error
        _ -> :error
      end
    end)
  end

  scalar :json do
    parse(fn input ->
      case Jason.decode(input.value) do
        {:ok, result} -> result
        _ -> :error
      end
    end)

    serialize(fn value -> value end)
  end

  scalar :map do
    parse(fn input -> input end)
    serialize(fn value -> value end)
  end

  @desc """
  The `DateTime` scalar type represents a date and time in the UTC
  timezone. The DateTime appears in a JSON response as an ISO8601 formatted
  string, including UTC timezone ("Z"). The parsed date and time string will
  be converted to UTC and any UTC offset other than 0 will be rejected.
  """
  scalar :datetime, name: "DateTime" do
    serialize(&DateTime.to_iso8601/1)
    parse(&parse_datetime/1)
  end

  @desc "A taxonomy classification"
  object :classification do
    field :id, :id
    @desc "Binomial name, typically the genus name followed by species name."
    field :binomial_name, :string
    @desc "Taxonomic kingdom."
    field :kingdom, :string
    @desc "Taxonomic genus."
    field :genus, :string
    @desc "Taxonomic species."
    field :species, :string
    @desc "Common names for this species."
    field :common_names, list_of(:string)
    @desc "Aliases, or synonymous binomial names for this species."
    field :aliases, list_of(:string)
    @desc "Color to display geometry for this classification."
    field :geometry_color, :string
  end

  @desc "A species variety."
  object :variety do
    field :id, :id
    @desc "The variety's denomination, or common name."
    field :denomination, :string
    @desc "The Classification (species) of which this variety is a member."
    field :classification, :classification, resolve: dataloader(Agrinomicon.Taxonomy)
  end

  @desc "A geographic datum such as a polygon, or point."
  object :feature do
    field :id, :id
    @desc "Geographic shape data as GeoJSON."
    field :geometry, :geojson
    @desc "Properties associated with this feature."
    field :properties, :json
  end

  @desc "An organization."
  object :organization do
    field :id, :id
    @desc "The organization's name."
    field :name, :string
  end

  @desc "An area of land, typically designated for a single use, such as growing crops or as pasture for livestock."
  object :block do
    field :id, :id
    @desc "The block's name or other designation."
    field :name, :string
    @desc "The Feature describing its geographic shape."
    field :feature, :feature, resolve: dataloader(Agrinomicon.Gis)
    @desc "The Organization that owns the land described by the block's Feature."
    field :organization, :organization, resolve: dataloader(Agrinomicon.Agency)
    @desc "The Tenures associated with this block."
    field :tenures, list_of(:tenure) do
      arg(:sort_by, non_null(:string), default_value: "occupied_at")
      arg(:sort_dir, non_null(:string), default_value: "asc")
      arg(:limit, :integer)
      resolve(dataloader(Agrinomicon.Production))
    end
  end

  @desc "The occupation of a block for the purposes of production."
  object :tenure do
    field :id, :id
    @desc "The distributions of occupants for this Tenure."
    field :distributions, list_of(:distribution), resolve: dataloader(Agrinomicon.Production)
    @desc "The start date and time of the Tenure."
    field :occupied_at, :datetime
    @desc "The associated block."
    field :block, :block, resolve: dataloader(Agrinomicon.Agency)
  end

  @desc "Represents an occuptant of a Tenure, i.e. a crop or livestock."
  object :distribution do
    field :id, :id
    @desc "The variety of the occupant."
    field :variety, :variety, resolve: dataloader(Agrinomicon.Taxonomy)
    @desc "The classification of hte occupant."
    field :classification, :classification, resolve: dataloader(Agrinomicon.Taxonomy)
    @desc "The coverage percent of the occupant."
    field :coverage, :float
  end

  query do
    @desc "Retrieve a list of classifications."
    field :classifications, list_of(:classification) do
      resolve(&Resolvers.Classification.list_classifications/3)
    end

    @desc "Retrieve a list of varieties."
    field :varieties, list_of(:variety) do
      resolve(&Resolvers.Variety.list_varieties/3)
    end

    @desc "Retrieve a list of organizations."
    field :organizations, list_of(:organization) do
      resolve(&Resolvers.Organization.list_organizations/3)
    end

    @desc "Retrieve a list of blocks."
    field :blocks, list_of(:block) do
      resolve(&Resolvers.Block.list_blocks/3)
    end

    @desc "Retrieve a block by ID."
    field :block, :block do
      @desc "The block ID."
      arg(:id, non_null(:id))
      resolve(&Resolvers.Block.get_block/3)
    end

    @desc "Retrieve a list of tenures."
    field :tenures, list_of(:tenure) do
      @desc 'The column by which to sort. Allowed values are: `"occupied_at"`. Defaults to `"occupied_at"`.'
      arg(:sort_by, non_null(:string), default_value: "occupied_at")

      @desc 'The direction to sort results. Allowed values are: `"asc"`, `"desc"`. Defaults to `"asc"`.'
      arg(:sort_dir, non_null(:string), default_value: "asc")

      @desc 'The number of results to return. Allowed values are any integers greater than zero, or `nil`'
      arg(:limit, :integer)
      resolve(&Resolvers.Tenure.list_tenures/3)
    end

    @desc "Retrieve a list of features."
    field :features, list_of(:feature) do
      resolve(&Resolvers.Feature.list_features/3)
    end
  end

  @spec parse_datetime(Absinthe.Blueprint.Input.String.t()) :: {:ok, DateTime.t()} | :error
  @spec parse_datetime(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, 0} -> {:ok, datetime}
      {:ok, _datetime, _offset} -> :error
      _error -> :error
    end
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}
  defp parse_datetime(_), do: :error
end
