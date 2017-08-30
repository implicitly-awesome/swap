defmodule Swap.Container do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro swap(module, delegate_module, opts \\ [])
  defmacro swap(module, delegate_module, do: block) do
    quote do
      swap(unquote(module), unquote(delegate_module), [])
      result = unquote(block)
      revert(unquote(module))
      result
    end
  end
  defmacro swap(module, delegate_module, opts) do
    quote bind_quoted: [module: module, delegate_module: delegate_module, opts: opts] do
      env = opts[:env]

      should_swap =
        cond do
          is_nil(env) -> true
          is_binary(env) -> String.to_existing_atom(env) == Mix.env()
          is_atom(env) -> env == Mix.env()
          is_list(env) -> Mix.env() in env
          true -> false
        end

      if should_swap do
        functions = delegate_module.__info__(:functions)
        
        defmodule module do
          for {func_name, arity} <- functions do
            if arity > 0 do
              args = Enum.map(1..arity, &(Macro.var(:"arg#{&1}", module)))
              defdelegate unquote(func_name)(args), to: delegate_module
            else
              defdelegate unquote(func_name)(), to: delegate_module
            end
          end
        end
      end
    end
  end

  defmacro revert(module) do
    quote do
      unquote(module).module_info[:compile][:source]
      |> IO.inspect()
      |> to_string()
      |> Code.load_file()
    end
  end
end
