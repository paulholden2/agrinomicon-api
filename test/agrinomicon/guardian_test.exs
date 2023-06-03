defmodule Agrinomicon.GuardianTest do
  use Agrinomicon.DataCase

  import Agrinomicon.IamFixtures

  test "encode_and_sign/2 creates user token" do
    user = user_fixture()

    {:ok, _token, %{"typ" => "user"}} =
      Agrinomicon.Guardian.encode_and_sign(user, %{}, token_type: :user)
  end

  test "resource_from_token/2 retrieves user from token" do
    user = user_fixture()

    {:ok, token, %{"typ" => "user"}} =
      Agrinomicon.Guardian.encode_and_sign(user, %{}, token_type: :user)

    assert {:ok, %{id: id}, _claims} = Agrinomicon.Guardian.resource_from_token(token)
    assert user.id == id
  end
end
