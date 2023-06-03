defmodule Agrinomicon.Taxonomy.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:list_classifications, _user, _resource), do: :ok

  def authorize(_action, _user, _resource), do: :error
end
