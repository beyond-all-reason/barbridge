defmodule Barbridge do
  @moduledoc false
  alias Barbridge.Helpers.CacheHelper

  # Cache stuff
  @spec cache_get(atom, any, any) :: any
  defdelegate cache_get(table, key, default \\ nil), to: CacheHelper

  @spec cache_get_or_store(atom, any, function) :: any
  defdelegate cache_get_or_store(table, key, func), to: CacheHelper

  @spec cache_delete(atom, any) :: :ok | {:error, any}
  defdelegate cache_delete(table, keys), to: CacheHelper

  @spec cache_put(atom, any, any) :: :ok | {:error, any}
  defdelegate cache_put(table, key, value), to: CacheHelper

  @spec cache_insert_new(atom, any, any) :: :ok | {:error, any}
  defdelegate cache_insert_new(table, key, value), to: CacheHelper

  @spec cache_update(atom, any, any) :: :ok | {:error, any}
  defdelegate cache_update(table, key, func), to: CacheHelper

  @spec store_get(atom, any) :: any
  defdelegate store_get(table, key), to: CacheHelper

  @spec store_delete(atom, any) :: :ok
  defdelegate store_delete(table, key), to: CacheHelper

  @spec store_put(atom, any, any) :: :ok
  defdelegate store_put(table, key, value), to: CacheHelper

  @spec store_insert_new(atom, any, any) :: :ok
  defdelegate store_insert_new(table, key, value), to: CacheHelper

  @spec store_update(atom, any, function()) :: :ok
  defdelegate store_update(table, key, func), to: CacheHelper

  @spec store_get_or_store(atom, any, function) :: any
  defdelegate store_get_or_store(table, key, func), to: CacheHelper
end
