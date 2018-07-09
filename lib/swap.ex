defmodule Swap do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro swap(swapped_module, delegate_module, opts \\ [])
  defmacro swap(swapped_module, delegate_module, do: block) do
    quote do
      swap(unquote(swapped_module), unquote(delegate_module), [])
      result = unquote(block)
      revert(unquote(swapped_module))
      result
    end
  end
  defmacro swap(swapped_module, delegate_module, opts) do
    quote bind_quoted: [swapped_module: swapped_module, delegate_module: delegate_module, opts: opts] do
      Code.compiler_options(ignore_module_conflict: true)

      should_swap =
        cond do
          is_nil(opts[:when]) -> true
          true -> true
        end

      if is_nil(opts[:when]) || opts[:when] == true do
        swapped_module_functions = swapped_module.__info__(:functions)
        delegate_module_functions = delegate_module.__info__(:functions)

        defmodule swapped_module do
          for {s_m_func_name, arity} <- swapped_module_functions do
            args = Macro.generate_arguments(arity, swapped_module)
            if delegate_module_functions[s_m_func_name] == arity do
              defdelegate unquote(s_m_func_name)(unquote_splicing(args)), to: delegate_module
            else
              def unquote(s_m_func_name)(unquote_splicing(args)) do
                raise("#{unquote(s_m_func_name)}/#{unquote(arity)} is not defined in #{unquote(delegate_module)}")
              end
            end
          end
        end
      end
    end
  end

  defmacro revert(swapped_module) do
    quote do
      result =
        unquote(swapped_module).module_info[:compile][:source]
        |> to_string()
        |> Code.load_file()

      Code.compiler_options(ignore_module_conflict: false)

      result
    end
  end
end
