defmodule BaleWeb.AtMe do
  @moduledoc """
  Plug to replace a param valued "@me" with the currently authenticated
  requester's account_id.
  """

  def init(opts) do
    opts
  end

  def replace_me(map, key, new) do
    if map[key] == "@me" do
      %{map | key => new}
    else
      map
    end
  end

  def call(conn, opts) do
    param_name = Keyword.get(opts, :param, "account_id")
    account_id = conn.assigns[:account_id]

    %{
      conn
      | params: replace_me(conn.params, param_name, account_id),
        body_params: replace_me(conn.body_params, param_name, account_id),
        path_params: replace_me(conn.path_params, param_name, account_id),
        query_params: replace_me(conn.query_params, param_name, account_id)
    }
  end
end
