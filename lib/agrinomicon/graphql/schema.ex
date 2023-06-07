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
    parse fn input ->
      case Jason.decode(input.value) do
        {:ok, result} -> result
        _ -> :error
      end
    end

    serialize fn value -> value end
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

    @desc "Retrieve a list of features."
    field :features, list_of(:feature) do
      resolve(&Resolvers.Feature.list_features/3)
    end
  end
end
